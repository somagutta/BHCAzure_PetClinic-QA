#!/usr/bin/bash
#########################################################################################
###
###  Script: PostProvisionDeploy.sh
###
###  Description: This script is called via an Azure ARM extension from the GitHub
###               Action. It is called only when provisioning a VM to setup the
###               following Post Provisioning features:
###
###               2. Install mulitple required packages
###               3. Join Domain
###                  (a) DNS                      (/etc/resolv.conf)
###                  (b) NTP                      (/etc/ntp.conf)
###                  (c) Kerberos                 (/etc/krb5.conf)
###                  (d) Samba                    (/etc/samba/smb.conf)
###                  (e) SSSD Services and Domain (/etc/sssd/sssd.conf)
###                  (f) Login Access Control     (/etc/security/access.conf)
###                  (g) Login Restriction File   (/etc/login.group.allowed)
###                  (h) PAM Password Auth        (/etc/pam.d/password-auth-ac)
###                  (i) PAM System Auth          (/etc/pam.d/system-auth-ac)
###                  (j) Sudo Access File         (/etc/sudoers)
###               4. Install QUALYS - Cloud Security Software
###               5. Install Windows Defender for Linux
###               6. Install FlexNet
###               7. Install Splunk
###
###               The script MUST run as the root user and MUST pass in the LOC
###               argument.  The "PostProvision.tar" file, which is downloaded
###               from Azure Storage and extracted into the /tmp diretory, contains
###               RPM files for standard APPs like "splunk" as well as file templates
###               for domain specific files like "/etc/krb5.conf".
###
###  Arguments:   Location (east or west)
###               BH AD Password
###               QUALYS Customer ID
###               QUALYS Activation ID
###               Splunk Password
###
########################################################################################

#--------------------------------
#---  Must run as the root user
#--------------------------------
if [ `whoami` != "root" ] ; then
   echo 'ERROR: The "PostProvisionDeploy.sh" MUST run as "root"'
   exit
fi

#--------------------------------------------------
#--- Set the Log File for the Post Provision Setup
#--------------------------------------------------
DateStamp=`date +%Y%m%d%H%M%S`
LogFile="/var/log/PostProvision/PostProvision-$DateStamp.log"

#---------------------------------------------------
#--- Create the Log directory if it does not exist
#---------------------------------------------------
if [ ! -d /var/log/PostProvision ] ; then
   mkdir /var/log/PostProvision
   chmod 755 /var/log/PostProvision
fi

#------------------------------------
#--- Redirect output to a log file
#------------------------------------
exec &>> $LogFile 2>&1

#------------------------------------
#--- Validate the passed arguments
#------------------------------------
if [ $# -ne 6 ] ; then
   echo 'ERROR: Valid ARGS are: Location, BH AD Password, QUALYS Customer ID, QUALYS Activation ID, Splunk Password, and hash'
   echo 'Args Passed are:'

   i=0
   for var in "$@" ; do
     ((i=i+1))
      echo "   ARG $i: $var"
   done
   exit
fi

#---------------------------------------
#--- Location MUST be "east" or "west"
#---------------------------------------
if [[ "$1" == "east" || "$1" == "west" ]] ; then
   LOC=$1
else
   echo 'ERROR: Location "east" or "west" not passed'
   exit
fi

#--------------------------------------------
#--- Assigned passed arguments to variables
#---------------------------------------------
ADPWsecret=$2
QualCUSTOMERsecret=$3
QualACTIVATEsecret=$4
SplunkPWsecret=$5

#-------------------------------------------------------
#--- Add additional yum repos for required packages to
#--- the /etc/yum.repos.d directory.
#-------------------------------------------------------
if [ ! -f /etc/yum.repos.d/azure-cli.repo ] ; then
   echo "[azure-cli]"                                                > /etc/yum.repos.d/azure-cli.repo
   echo "name=Azure CLI"                                            >> /etc/yum.repos.d/azure-cli.repo
   echo "baseurl=https://packages.microsoft.com/yumrepos/azure-cli" >> /etc/yum.repos.d/azure-cli.repo
   echo "enabled=1"                                                 >> /etc/yum.repos.d/azure-cli.repo
   echo "gpgcheck=1"                                                >> /etc/yum.repos.d/azure-cli.repo
   echo "gpgkey=https://packages.microsoft.com/keys/microsoft.asc"  >> /etc/yum.repos.d/azure-cli.repo
   chmod 644 /etc/yum.repos.d/azure-cli.repo
fi

#--------------------------------------
#--- Declare packages to be installed
#--------------------------------------
echo ""
echo "======================="
echo "=== Update Packages ==="
echo "======================="
BASEDIR=/tmp/PostProvision
PKGS=("azure-cli" "sssd" "authconfig" "adcli" "sysstat" "bind-utils" "realmd"
      "krb5-workstation" "krb5-libs" "samba-common" "samba-common-tools" "unzip"
      "samba-winbind-clients" "oddjob" "oddjob-mkhomedir" "samba-winbind-modules"
      "pam_krb5" "cifs-utils")

#---------------------------------------------------------------
#--- Install Package only if they have not yet been installed
#---------------------------------------------------------------
for PKG in ${PKGS[@]} ; do
   if [ `yum list installed 2> /dev/null | grep -c "$PKG\."` == 0 ] ; then
      echo "... INSTALL ............. $PKG"
      yum install $PKG -y > /dev/null
   else
      echo "... ALREADY installed ... $PKG"
   fi
done
systemctl start oddjobd > /dev/null

#-------------------------------------------------
#--- Download the PostProvision.tar file to /tmp
#-------------------------------------------------
TarFile=PostProvision.tar

echo ""
echo "====================================="
echo "=== Extract PostProvision tarfile ==="
echo "====================================="
echo "... Extract $TarFile"
cd /tmp
tar -xf /postprovision/$TarFile

#-------------------------------------------------------
#--- Set the DOMAIN based on the passed LOC and the IP.
#--- Next update the domain files.
#-------------------------------------------------------
IP=`ifconfig eth0 | grep inet | head -1 | awk '{print $2}'`
IP4=`echo $IP | awk -F. '{print $4}'`
if [ `expr $IP4 % 2` == 0 ] ; then
   EvenOdd="EVEN"
else
   EvenOdd="ODD"
fi

if [ $LOC == "east" ] ; then
   if [ $EvenOdd == "ODD" ] ; then
      DOMAIN="AZECDC01"
   else
      DOMAIN="AZECDC02"
   fi

   NTP_IP="10.250.255.255"
else
   if [ $EvenOdd == "ODD" ] ; then
      DOMAIN="AZUCDC01"
   else
      DOMAIN="AZUCDC02"
   fi

   NTP_IP="10.250.255.254"
fi

echo ""
echo "==========================="
echo "=== Update DOMAIN Files ==="
echo "==========================="
echo "... update /etc/samba/smb.conf"
cp -f $BASEDIR/domainFiles/smb.conf                         /etc/samba/smb.conf
echo "... update /etc/krb5.conf"
sed "s/<DOMAIN>/$DOMAIN/"  $BASEDIR/domainFiles/krb5.conf > /etc/krb5.conf
echo "... update /etc/sssd/sssd.conf"
sed "s/<DOMAIN>/$DOMAIN/"  $BASEDIR/domainFiles/sssd.conf > /etc/sssd/sssd.conf
echo "... update /etc/pam.d/password-auth-ac"
cp -f $BASEDIR/domainFiles/password-auth-ac                 /etc/pam.d/password-auth-ac
echo "... update /etc/pam.d/system-auth-ac"
cp -f $BASEDIR/domainFiles/system-auth-ac                   /etc/pam.d/system-auth-ac
echo "... update /etc/resolv.conf"
chattr -i /etc/resolv.conf
cp -f $BASEDIR/domainFiles/resolv.conf.$LOC                 /etc/resolv.conf

#-----------------------------
#--- Adjust files attributes
#-----------------------------
chmod 644 /etc/krb5.conf
chmod 600 /etc/sssd/sssd.conf
chmod 644 /etc/pam.d/password-auth-ac
chmod 644 /etc/pam.d/system-auth-ac
chmod 644 /etc/resolv.conf
chattr +i /etc/resolv.conf

#------------------------------------------------
#--- Update the /etc/hosts with fully qualified
#--- hostname and IP address.
#------------------------------------------------
echo "... update /etc/hosts"
if [ `grep -c $(hostname) /etc/hosts` == 0 ] ; then
   echo "$IP	$(hostname).ent.bhicorp.com $(hostname)" >> /etc/hosts
fi

#-----------------------------------
#--- Set the NTP based on the LOC
#-----------------------------------
echo "... update /etc/ntp.conf"
sed -i "s/^server 169.254.169.123/#server 169.254.169.123/" /etc/ntp.conf
if [ `grep -c $NTP_IP /etc/ntp.conf` == 0 ] ; then
   echo "server $NTP_IP" >> /etc/ntp.conf
   systemctl disable chronyd.service
   systemctl stop chronyd.service
   systemctl enable ntpd
   systemctl start ntpd
   systemctl restart ntpd
   sleep 5
fi

#-----------------------------------------
#--- Update the NIC card with the domain
#-----------------------------------------
echo "... update /etc/sysconfig/network-scripts/ifcfg-eth0"
if [ `grep -c PEERDNS /etc/sysconfig/network-scripts/ifcfg-eth0` == 0 ] ; then
   echo "PEERDNS=yes"            >> /etc/sysconfig/network-scripts/ifcfg-eth0
else
   sed -i 's/PEERDNS.*/PEERDNS=yes/' /etc/sysconfig/network-scripts/ifcfg-eth0
fi

if [ `grep -c DOMAIN /etc/sysconfig/network-scripts/ifcfg-eth0` == 0 ] ; then
   echo "DOMAIN=ent.bhicorp.com" >> /etc/sysconfig/network-scripts/ifcfg-eth0
else
   sed -i 's/DOMAIN.*/DOMAIN=ent.bhicorp.com/' /etc/sysconfig/network-scripts/ifcfg-eth0
fi

#-----------------------------------
#--- Join the Baker Hughes Domain
#-----------------------------------
echo ""
echo "===================================="
echo "=== Join the Baker Hughes Domain ==="
echo "===================================="
echo "... joining $(hostname) to the \"ent.bhicorp.com\" domain"
echo "$ADPWsecret" | adcli join --stdin-password --domain-ou=OU="Managed Servers - Azure",DC=ent,DC=bhicorp,DC=com -U svc-mynavagent ent.bhicorp.com
authconfig --enablesssd --enablesssdauth --enablelocauthorize --enablemkhomedir --update

#------------------------
#--- Restart AD daemons
#------------------------
systemctl start oddjobd
if [ `systemctl status oddjobd | grep -c active` == 1 ] ; then
   echo "... oddjobd        start SUCESSFUL"
else
   echo "... oddjobd        start FAILED"
fi

systemctl start sssd
if [ `systemctl status sssd | grep -c active` == 1 ] ; then
   echo "... sssd           start SUCESSFUL"
else
   echo "... sssd           start FAILED"
fi

systemctl restart systemd-logind
if [ `systemctl status systemd-logind | grep -c active` == 1 ] ; then
   echo "... systemd-logind start SUCESSFUL"
else
   echo "... systemd-logind start FAILED"
fi

echo "... enable sssd"
systemctl enable sssd

systemctl restart sshd
if [ `systemctl status sshd | grep -c active` == 1 ] ; then
   echo "... sshd           start SUCESSFUL"
else
   echo "... sshd           start FAILED"
fi

#------------------------------------------------------------------------
#--- Add the BHCAzure_HPA_ALL to allow ssh and sudoer access to the VM
#------------------------------------------------------------------------
echo ""
echo "============================================="
echo "=== Add the BHCAzure_HPA_ALL Group Access ==="
echo "============================================="

echo "... update /etc/security/access.conf"
if [ `grep -c BHCAzure_HPA_ALL /etc/security/access.conf` == 0 ] ; then
   echo "+:@BHCAzure_HPA_ALL@ent.bhicorp.com:ALL" >> /etc/security/access.conf
else
   sed -i 's/^+:@BHCAzure_HPA_ALL.*/+:@BHCAzure_HPA_ALL@ent.bhicorp.com:ALL/' /etc/security/access.conf
fi

echo "... update /etc/login.group.allowed"
if [ -f /etc/login.group.allowed ] ; then
   if [ `grep -c BHCAzure_HPA_ALL /etc/login.group.allowed` == 0 ] ; then
      echo "BHCAzure_HPA_ALL" >> /etc/login.group.allowed
   fi
else
   echo "BHCAzure_HPA_ALL" >> /etc/login.group.allowed
fi
chmod 644 /etc/login.group.allowed

echo "... update /etc/sudoers"
if [ `grep -c BHCAzure_HPA_ALL /etc/sudoers` == 0 ] ; then
   echo "%ent.bhicorp.com\\\BHCAzure_HPA_ALL ALL=(ALL) ALL" >> /etc/sudoers
else
   sed -i 's/.*BHCAzure_HPA_ALL.*/%ent.bhicorp.com\\\\BHCAzure_HPA_ALL ALL=(ALL) ALL/' /etc/sudoers
fi

#-----------------------------
#--- Post Tools Installation
#-----------------------------
echo ""
echo "==============================="
echo "=== Post Tools Installation ==="
echo "==============================="

#----------------------
#---  Install QUALYS
#----------------------
if [ `rpm -qa | grep -c qualys-cloud-agent\.` == 1 ] ; then
   echo "... UNINSTALL QUALYS Application"
   rpm -e qualys-cloud-agent > /dev/null 2>&1
fi

echo "... Install QUALYS Application"
cd $BASEDIR/appFiles
unzip qualys-cloud-agent-4.7.0-35.x86_64.zip > /dev/null
cd QA-AWS-LINUX
rpm -ivh $BASEDIR/appFiles/QA-AWS-LINUX/QualysCloudAgent.rpm > /dev/null 2>&1
/usr/local/qualys/cloud-agent/bin/qualys-cloud-agent.sh ActivationId=$QualACTIVATEsecret CustomerId=$QualCUSTOMERsecret > /dev/null

#-----------------------------------------
#---  Install Windows Defender for Linux
#-----------------------------------------
if [ `yum list installed 2> /dev/null | grep -c mdatp\.` == 1 ] ; then
   echo "... UNINSTALL Windows Defender for Linux"
   yum remove mdatp -y > /dev/null 2>&1
fi

echo "... Install Windows Defender for Linux"
yum-config-manager --add-repo=https://packages.microsoft.com/config/rhel/7/prod.repo > /dev/null 2>&1
yum install mdatp -y > /dev/null 2>&1
cd $BASEDIR/appFiles
unzip WindowsDefenderATPOnboardingPackage.zip > /dev/null
python MicrosoftDefenderATPOnboardingLinuxServer.py > /dev/null
cp -nf mdatp_managed.json /etc/opt/microsoft/mdatp/managed/mdatp_managed.json

#----------------------------------------------
#--- Add Windows Defender cronjobs if needed
#----------------------------------------------
if [ `grep -c 'mdatp scan full' /var/spool/cron/root` == 0 ] ; then
   echo "... Add mdatp scan to /var/spool/cron/root"
   echo "0 2 * * sat /bin/mdatp scan full > ~/mdatp_cron_job.log" | tee -a /var/spool/cron/root
fi

if [ `grep -c 'yum update mdatp' /var/spool/cron/root` == 0 ] ; then
   echo "Add yum update mdatp to /var/spool/cron/root"
   echo "0 0 * * * sudo yum update mdatp >> ~/mdatp_cron_job.log" | tee -a /var/spool/cron/root
fi

#----------------------------------
#---  Install FlexNet Application
#----------------------------------
if [ `rpm -qa | grep -c managesoft\.` == 1 ] ; then
   echo "... UNINSTALL FlexNet Application"
   rpm -e managesoft > /dev/null 2>&1
fi

echo "... Install FlexNet Application"
cd $BASEDIR/appFiles
unzip FlexNet.zip > /dev/null
cd "Linux X86_64"
rpm -ivh managesoft-14.0.0-1.x86_64.rpm > /dev/null 2>&1

#---------------------
#---  Install Splunk
#---------------------
if [ ! -d /opt/splunkforwarder ] ; then
   echo "... Install Splunk Application"
   cd $BASEDIR/appFiles
   tar -xf splunkforwarder-8.0.5.tgz -C /opt
   /opt/splunkforwarder/bin/splunk start --accept-license --answer-yes --no-prompt --seed-passwd $SplunkPWsecret
   /opt/splunkforwarder/bin/splunk set deploy-poll 10.124.1.15:8089 -auth admin:$SplunkPWsecret
   /opt/splunkforwarder/bin/splunk enable boot-start
   /opt/splunkforwarder/bin/splunk restart
   /opt/splunkforwarder/bin/splunk status 
else
   echo "... Splunk Application ALREADY installed"
fi

#---------------------------------------------------
#--- Ensure the SElinux Security is set for /home
#---------------------------------------------------
echo ""
echo "========================================"
echo "=== Set SElinux Security for "/home" ==="
echo "========================================"
echo "... restorecon -vR /home"
restorecon -vR /home > /dev/null 2>&1

echo ""
echo "================"
echo "=== Clean up ==="
echo "================"
cd /tmp
echo "... Remove /tmp/PostProvision Directory"
rm -rf /tmp/PostProvision
echo "... Remove /tmp/PostProvision.tar"
rm -f /tmp/PostProvision.tar
echo "... Remove /tmp/PostProvisionDeploy.sh"
rm -f /tmp/PostProvisionDeploy.sh
