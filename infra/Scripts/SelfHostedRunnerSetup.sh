#!/bin/bash
########################################################################################
###
### Scripts: SelfHostedRunnerSetup.sh
###
### Description: This script will pull the GitHub Token from the Key Vault Secret
###              and then pull download the Repo.
###
### Arguments:   $1 - GitHub PAT
###              $2 - GitHub Repo
###              $3 - Runner Tag
###              $4 - hash
###
########################################################################################

#----------------------------------
#--- Validate the passed argument 
#-----------------------------------
if [ $# -ne 4 ] ; then
   echo 'ERROR: Valid ARGS are GitHubPAT, GitHubRepo, Runner Tag, and hash'
   exit
fi

GitHubPAT=$1
GitHubRepo=$2
RunnerTag=$3
GitHubSrv=`echo $GitHubRepo | sed 's^/^-^g'`
RunnerUser="bhrunner"

#-------------------------------------------------------
#--- Set the Log File for the Self-Hosted Runner  Setup
#-------------------------------------------------------
DateStamp=`date +%Y%m%d%H%M%S`
LogFile="/var/log/Runner/Runner-$DateStamp.log"

#---------------------------------------------------
#--- Create the Log directory if it does not exist
#---------------------------------------------------
if [ ! -d /var/log/Runner ] ; then
   mkdir /var/log/Runner
   chmod 755 /var/log/Runner
fi

#------------------------------------
#--- Redirect output to a log file
#------------------------------------
exec &>> $LogFile 2>&1

echo ""
echo "======================="
echo "=== Update Packages ==="
echo "======================="
PKGS=("openssl" "krb5-libs" "zlib" "libicu" "jq")

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


echo ""
echo "================================="
echo "=== Create the $RunnerUser user ==="
echo "================================"

#---------------------------------------------------
#--- Create the bhrunner user if it does not exist
#---------------------------------------------------
if [ `getent passwd $RunnerUser | wc -l` -eq 0 ] ; then
   echo "... Create /home/$RunnerUser Directory"
   mkdir /home/$RunnerUser
   echo "... Create $RunnerUser User"
   /usr/sbin/useradd $RunnerUser -M > /dev/null
   echo "... Copy /etc/skell files to /home/$RunnerUser"
   cp /etc/skel/.b* /home/${RunnerUser}
   echo "... Set onwershipp on /home/$RunnerUser"
   chown -R ${RunnerUser}:${RunnerUser} /home/$RunnerUser
else
   echo "... $RunnerUser ALREADY exists"
fi

cd /home/$RunnerUser

#----------------------------------------------------
#--- Set the RUNNER_CFG_PAT to the passed GitHubPAT
#----------------------------------------------------
export RUNNER_CFG_PAT="$GitHubPAT"

#-----------------------------------------
#--- If Runner Already exists, delete it
#-----------------------------------------
RunnerCNT=$(curl -s https://api.github.com/repos/${GitHubRepo}/actions/runners \
              -H "accept: application/vnd.github.v3+json" \
              -H "authorization: token ${RUNNER_CFG_PAT}" | grep -c $(hostname))

echo ""
echo "=============================================="
echo "=== Remove Previous Instance of the Runner ==="
echo "=============================================="

#---------------------------------------
#--- Stop Runner Process if it exists
#---------------------------------------
RunnerPID=`ps -ef | grep "/home/${RunnerUser}/runner/runsvc.sh" | grep -v grep | awk '{print $2}'`
if [ "$RunnerPID" != "" ] ; then
   echo "... Stop the /home/${RunnerUser}/runner Process"
   kill $RunnerPID
fi

#----------------------------------------------
#--- Delete the Runner directory if is exists
#----------------------------------------------
if [ -d /home/$RunnerUser/runner ] ; then
   echo "... Remove /home/$RunnerUser/runner Directory"
   rm -rf /home/$RunnerUser/runner
fi

#------------------------------------------------
#--- Delete the Self-Hosted Runner if it exists
#------------------------------------------------
if [ $RunnerCNT -eq 1 ] ; then
   echo "... Delete Self-Hosted Runner $(hostname) in $GitHubRepo Repo"
   OutPut=$(curl -s https://raw.githubusercontent.com/actions/runner/main/scripts/delete.sh | \
      bash -s $GitHubRepo $(hostname))
fi

#-------------------------------------
#--- Remove the service if it exists
#-------------------------------------
if [ -f /etc/systemd/system/actions.runner.${GitHubSrv}.$(hostname).service ] ; then
   echo "... Remove ${GitHubSrv}.$(hostname) service"
   rm -f /etc/systemd/system/actions.runner.${GitHubSrv}.$(hostname).service
fi


echo ""
echo "================================="
echo "=== Create Self-Hosted Runner ==="
echo "================================="

#--------------------------------------------------
#--- Create the Self-Hosted Runner for this Repo
#--------------------------------------------------
curl -s https://raw.githubusercontent.com/actions/runner/main/scripts/create-latest-svc.sh | \
   bash -s -- -s $GitHubRepo -n $(hostname) -l $RunnerTag -u $RunnerUser

echo ""
echo "... Remove Runner tarfile from /home/$RunnerUser"
rm -f /home/${RunnerUser}/actions*.tar.gz
