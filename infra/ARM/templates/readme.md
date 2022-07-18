**Why choose ARM templates?**

If you&#39;re trying to decide between using ARM templates and one of the other infrastructures as code services, consider the following advantages of using templates:

- **Declarative syntax** : ARM templates allow you to create and deploy an entire Azure infrastructure declaratively. For example, you can deploy not only virtual machines, but also the network infrastructure, storage systems, and any other resources you may need.
- **Repeatable results** : Repeatedly deploy your infrastructure throughout the development lifecycle and have confidence your resources are deployed in a consistent manner. Templates are idempotent, which means you can deploy the same template many times and get the same resource types in the same state. You can develop one template that represents the desired state, rather than developing lots of separate templates to represent updates.
- **Orchestration** : You don&#39;t have to worry about the complexities of ordering operations. Resource Manager orchestrates the deployment of interdependent resources so they&#39;re created in the correct order. When possible, Resource Manager deploys resources in parallel so your deployments finish faster than serial deployments. You deploy the template through one command, rather than through multiple imperative commands.

![](RackMultipart20220627-1-pyvqqt_html_96a9fdde59cdb3f9.png)

- **Modular files** : You can break your templates into smaller, reusable components and link them together at deployment time. You can also nest one template inside another template.
- **Create any Azure resource** : You can immediately use new Azure services and features in templates. As soon as a resource provider introduces new resources, you can deploy those resources through templates. You don&#39;t have to wait for tools or modules to be updated before using the new services.
- **Extensibility** : With [deployment scripts](https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/deployment-script-template), you can add PowerShell or Bash scripts to your templates. The deployment scripts extend your ability to set up resources during deployment. A script can be included in the template, or stored in an external source and referenced in the template. Deployment scripts give you the ability to complete your end-to-end environment setup in a single ARM template.
- **Testing** : You can make sure your template follows recommended guidelines by testing it with the ARM template tool kit (arm-ttk). This test kit is a PowerShell script that you can download from [GitHub](https://github.com/Azure/arm-ttk). The tool kit makes it easier for you to develop expertise using the template language.
- **Preview changes** : You can use the [what-if operation](https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/deploy-what-if) to get a preview of changes before deploying the template. With what-if, you see which resources will be created, updated, or deleted, and any resource properties that will be changed. The what-if operation checks the current state of your environment and eliminates the need to manage state.
- **Built-in validation** : Your template is deployed only after passing validation. Resource Manager checks the template before starting the deployment to make sure the deployment will succeed. Your deployment is less likely to stop in a half-finished state.
- **Tracked deployments** : In the Azure portal, you can review the deployment history and get information about the template deployment. You can see the template that was deployed, the parameter values passed in, and any output values. Other infrastructure as code services aren&#39;t tracked through the portal.

![](RackMultipart20220627-1-pyvqqt_html_b95701ddc7485540.png)

- **Policy as code** : [Azure Policy](https://docs.microsoft.com/en-us/azure/governance/policy/overview) is a policy as code framework to automate governance. If you&#39;re using Azure policies, policy remediation is done on non-compliant resources when deployed through templates.
- **Deployment Blueprints** : You can take advantage of [Blueprints](https://docs.microsoft.com/en-us/azure/governance/blueprints/overview) provided by Microsoft to meet regulatory and compliance standards. These blueprints include pre-built templates for various architectures.
- **CI/CD integration** : You can integrate templates into your continuous integration and continuous deployment (CI/CD) tools, which can automate your release pipelines for fast and reliable application and infrastructure updates. By using Azure DevOps and Resource Manager template task, you can use Azure Pipelines to continuously build and deploy ARM template projects. To learn more, see [VS project with pipelines](https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/add-template-to-azure-pipelines) and [Tutorial: Continuous integration of Azure Resource Manager templates with Azure Pipelines](https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/deployment-tutorial-pipeline).
- **Exportable code** : You can get a template for an existing resource group by either exporting the current state of the resource group, or viewing the template used for a particular deployment. Viewing the [exported template](https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/export-template-portal) is a helpful way to learn about the template syntax.
- **Authoring tools** : You can author templates with [Visual Studio Code](https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/quickstart-create-templates-use-visual-studio-code) and the template tool extension. You get intellisense, syntax highlighting, in-line help, and many other language functions. In addition to Visual Studio Code, you can also use [Visual Studio](https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/create-visual-studio-deployment-project).

# 2.what are the requirements for arm template:

**Template format**

In its simplest structure, a template has the following elements:

JSONCopy

{

&quot;$schema&quot;: &quot;https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#&quot;,

&quot;contentVersion&quot;: &quot;&quot;,

&quot;apiProfile&quot;: &quot;&quot;,

&quot;parameters&quot;: { },

&quot;variables&quot;: { },

&quot;functions&quot;: [],

&quot;resources&quot;: [],

&quot;outputs&quot;: { }

}

| **Element name** | **Required** | **Description** |
| --- | --- | --- |
| $schema | Yes | Location of the JavaScript Object Notation (JSON) schema file that describes the version of the template language. The version number you use depends on the scope of the deployment and your JSON editor.

 If you&#39;re using [Visual Studio Code with the Azure Resource Manager tools extension](https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/quickstart-create-templates-use-visual-studio-code), use the latest version for resource group deployments:
https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#

 Other editors (including Visual Studio) may not be able to process this schema. For those editors, use:
https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#

 For subscription deployments, use:
https://schema.management.azure.com/schemas/2018-05-01/subscriptionDeploymentTemplate.json#

 For management group deployments, use:
https://schema.management.azure.com/schemas/2019-08-01/managementGroupDeploymentTemplate.json#

 For tenant deployments, use:
https://schema.management.azure.com/schemas/2019-08-01/tenantDeploymentTemplate.json# |
| --- | --- | --- |
| contentVersion | Yes | Version of the template (such as 1.0.0.0). You can provide any value for this element. Use this value to document significant changes in your template. When deploying resources using the template, this value can be used to make sure that the right template is being used. |
| apiProfile | No | An API version that serves as a collection of API versions for resource types. Use this value to avoid having to specify API versions for each resource in the template. When you specify an API profile version and don&#39;t specify an API version for the resource type, Resource Manager uses the API version for that resource type that is defined in the profile.

 The API profile property is especially helpful when deploying a template to different environments, such as Azure Stack and global Azure. Use the API profile version to make sure your template automatically uses versions that are supported in both environments. For a list of the current API profile versions and the resources API versions defined in the profile, see [API Profile](https://github.com/Azure/azure-rest-api-specs/tree/master/profile).

 For more information, see [Track versions using API profiles](https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/template-cloud-consistency#track-versions-using-api-profiles). |
| [parameters](https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/syntax#parameters) | No | Values that are provided when deployment is executed to customize resource deployment. |
| [variables](https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/syntax#variables) | No | Values that are used as JSON fragments in the template to simplify template language expressions. |
| [functions](https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/syntax#functions) | No | User-defined functions that are available within the template. |
| [resources](https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/syntax#resources) | Yes | Resource types that are deployed or updated in a resource group or subscription. |
| [outputs](https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/syntax#outputs) | No | Values that are returned after deployment. |

Each element has properties you can set. This article describes the sections of the template in greater detail.

**Parameters**

In the parameters section of the template, you specify which values you can input when deploying the resources. You&#39;re limited to 256 parameters in a template. You can reduce the number of parameters by using objects that contain multiple properties.

The available properties for a parameter are:

JSONCopy

&quot;parameters&quot;: {

&quot;\&lt;parameter-name\&gt;&quot; : {

&quot;type&quot; : &quot;\&lt;type-of-parameter-value\&gt;&quot;,

&quot;defaultValue&quot;: &quot;\&lt;default-value-of-parameter\&gt;&quot;,

&quot;allowedValues&quot;: [&quot;\&lt;array-of-allowed-values\&gt;&quot;],

&quot;minValue&quot;: \&lt;minimum-value-for-int\&gt;,

&quot;maxValue&quot;: \&lt;maximum-value-for-int\&gt;,

&quot;minLength&quot;: \&lt;minimum-length-for-string-or-array\&gt;,

&quot;maxLength&quot;: \&lt;maximum-length-for-string-or-array-parameters\&gt;,

&quot;metadata&quot;: {

&quot;description&quot;: &quot;\&lt;description-of-the parameter\&gt;&quot;

}

}

}

| **Element name** | **Required** | **Description** |
| --- | --- | --- |
| parameter-name | Yes | Name of the parameter. Must be a valid JavaScript identifier. |
| --- | --- | --- |
| type | Yes | Type of the parameter value. The allowed types and values are  **string** ,  **securestring** ,  **int** ,  **bool** ,  **object** ,  **secureObject** , and  **array**. See [Data types in ARM templates](https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/data-types). |
| defaultValue | No | Default value for the parameter, if no value is provided for the parameter. |
| allowedValues | No | Array of allowed values for the parameter to make sure that the right value is provided. |
| minValue | No | The minimum value for int type parameters, this value is inclusive. |
| maxValue | No | The maximum value for int type parameters, this value is inclusive. |
| minLength | No | The minimum length for string, secure string, and array type parameters, this value is inclusive. |
| maxLength | No | The maximum length for string, secure string, and array type parameters, this value is inclusive. |
| description | No | Description of the parameter that is displayed to users through the portal. For more information, see [Comments in templates](https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/syntax#comments). |

For examples of how to use parameters, see [Parameters in ARM templates](https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/parameters).

In Bicep, see [parameters](https://docs.microsoft.com/en-us/azure/azure-resource-manager/bicep/file#parameters).

**Variables**

In the variables section, you construct values that can be used throughout your template. You don&#39;t need to define variables, but they often simplify your template by reducing complex expressions. The format of each variable matches one of the [data types](https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/data-types).

The following example shows the available options for defining a variable:

JSONCopy

&quot;variables&quot;: {

&quot;\&lt;variable-name\&gt;&quot;: &quot;\&lt;variable-value\&gt;&quot;,

&quot;\&lt;variable-name\&gt;&quot;: {

\&lt;variable-complex-type-value\&gt;

},

&quot;\&lt;variable-object-name\&gt;&quot;: {

&quot;copy&quot;: [

{

&quot;name&quot;: &quot;\&lt;name-of-array-property\&gt;&quot;,

&quot;count&quot;: \&lt;number-of-iterations\&gt;,

&quot;input&quot;: \&lt;object-or-value-to-repeat\&gt;

}

]

},

&quot;copy&quot;: [

{

&quot;name&quot;: &quot;\&lt;variable-array-name\&gt;&quot;,

&quot;count&quot;: \&lt;number-of-iterations\&gt;,

&quot;input&quot;: \&lt;object-or-value-to-repeat\&gt;

}

]

}

For information about using copy to create several values for a variable, see [Variable iteration](https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/copy-variables).

For examples of how to use variables, see [Variables in ARM template](https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/variables).

In Bicep, see [variables](https://docs.microsoft.com/en-us/azure/azure-resource-manager/bicep/file#variables).

**Functions**

Within your template, you can create your own functions. These functions are available for use in your template. Typically, you define complicated expressions that you don&#39;t want to repeat throughout your template. You create the user-defined functions from expressions and [functions](https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/template-functions) that are supported in templates.

When defining a user function, there are some restrictions:

- The function can&#39;t access variables.
- The function can only use parameters that are defined in the function. When you use the [parameters function](https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/template-functions-deployment#parameters) within a user-defined function, you&#39;re restricted to the parameters for that function.
- The function can&#39;t call other user-defined functions.
- The function can&#39;t use the [reference function](https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/template-functions-resource#reference).
- Parameters for the function can&#39;t have default values.

JSONCopy

&quot;functions&quot;: [

{

&quot;namespace&quot;: &quot;\&lt;namespace-for-functions\&gt;&quot;,

&quot;members&quot;: {

&quot;\&lt;function-name\&gt;&quot;: {

&quot;parameters&quot;: [

{

&quot;name&quot;: &quot;\&lt;parameter-name\&gt;&quot;,

&quot;type&quot;: &quot;\&lt;type-of-parameter-value\&gt;&quot;

}

],

&quot;output&quot;: {

&quot;type&quot;: &quot;\&lt;type-of-output-value\&gt;&quot;,

&quot;value&quot;: &quot;\&lt;function-return-value\&gt;&quot;

}

}

}

}

],

| **Element name** | **Required** | **Description** |
| --- | --- | --- |
| namespace | Yes | Namespace for the custom functions. Use to avoid naming conflicts with template functions. |
| --- | --- | --- |
| function-name | Yes | Name of the custom function. When calling the function, combine the function name with the namespace. For example, to call a function named uniqueName in the namespace contoso, use &quot;[contoso.uniqueName()]&quot;. |
| parameter-name | No | Name of the parameter to be used within the custom function. |
| parameter-value | No | Type of the parameter value. The allowed types and values are  **string** ,  **securestring** ,  **int** ,  **bool** ,  **object** ,  **secureObject** , and  **array**. |
| output-type | Yes | Type of the output value. Output values support the same types as function input parameters. |
| output-value | Yes | Template language expression that is evaluated and returned from the function. |

For examples of how to use custom functions, see [User-defined functions in ARM template](https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/user-defined-functions).

In Bicep, user-defined functions aren&#39;t supported. Bicep does support a variety of [functions](https://docs.microsoft.com/en-us/azure/azure-resource-manager/bicep/bicep-functions) and [operators](https://docs.microsoft.com/en-us/azure/azure-resource-manager/bicep/operators).

**Resources**

In the resources section, you define the resources that are deployed or updated.

You define resources with the following structure:

JSONCopy

&quot;resources&quot;: [

{

&quot;condition&quot;: &quot;\&lt;true-to-deploy-this-resource\&gt;&quot;,

&quot;type&quot;: &quot;\&lt;resource-provider-namespace/resource-type-name\&gt;&quot;,

&quot;apiVersion&quot;: &quot;\&lt;api-version-of-resource\&gt;&quot;,

&quot;name&quot;: &quot;\&lt;name-of-the-resource\&gt;&quot;,

&quot;comments&quot;: &quot;\&lt;your-reference-notes\&gt;&quot;,

&quot;location&quot;: &quot;\&lt;location-of-resource\&gt;&quot;,

&quot;dependsOn&quot;: [

&quot;\&lt;array-of-related-resource-names\&gt;&quot;

],

&quot;tags&quot;: {

&quot;\&lt;tag-name1\&gt;&quot;: &quot;\&lt;tag-value1\&gt;&quot;,

&quot;\&lt;tag-name2\&gt;&quot;: &quot;\&lt;tag-value2\&gt;&quot;

},

&quot;identity&quot;: {

&quot;type&quot;: &quot;\&lt;system-assigned-or-user-assigned-identity\&gt;&quot;,

&quot;userAssignedIdentities&quot;: {

&quot;\&lt;resource-id-of-identity\&gt;&quot;: {}

}

},

&quot;sku&quot;: {

&quot;name&quot;: &quot;\&lt;sku-name\&gt;&quot;,

&quot;tier&quot;: &quot;\&lt;sku-tier\&gt;&quot;,

&quot;size&quot;: &quot;\&lt;sku-size\&gt;&quot;,

&quot;family&quot;: &quot;\&lt;sku-family\&gt;&quot;,

&quot;capacity&quot;: \&lt;sku-capacity\&gt;

},

&quot;kind&quot;: &quot;\&lt;type-of-resource\&gt;&quot;,

&quot;scope&quot;: &quot;\&lt;target-scope-for-extension-resources\&gt;&quot;,

&quot;copy&quot;: {

&quot;name&quot;: &quot;\&lt;name-of-copy-loop\&gt;&quot;,

&quot;count&quot;: \&lt;number-of-iterations\&gt;,

&quot;mode&quot;: &quot;\&lt;serial-or-parallel\&gt;&quot;,

&quot;batchSize&quot;: \&lt;number-to-deploy-serially\&gt;

},

&quot;plan&quot;: {

&quot;name&quot;: &quot;\&lt;plan-name\&gt;&quot;,

&quot;promotionCode&quot;: &quot;\&lt;plan-promotion-code\&gt;&quot;,

&quot;publisher&quot;: &quot;\&lt;plan-publisher\&gt;&quot;,

&quot;product&quot;: &quot;\&lt;plan-product\&gt;&quot;,

&quot;version&quot;: &quot;\&lt;plan-version\&gt;&quot;

},

&quot;properties&quot;: {

&quot;\&lt;settings-for-the-resource\&gt;&quot;,

&quot;copy&quot;: [

{

&quot;name&quot;: ,

&quot;count&quot;: ,

&quot;input&quot;: {}

}

]

},

&quot;resources&quot;: [

&quot;\&lt;array-of-child-resources\&gt;&quot;

]

}

]

| **Element name** | **Required** | **Description** |
| --- | --- | --- |
| condition | No | Boolean value that indicates whether the resource will be provisioned during this deployment. When true, the resource is created during deployment. When false, the resource is skipped for this deployment. See [condition](https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/conditional-resource-deployment). |
| --- | --- | --- |
| type | Yes | Type of the resource. This value is a combination of the namespace of the resource provider and the resource type (such as Microsoft.Storage/storageAccounts). To determine available values, see [template reference](https://docs.microsoft.com/en-us/azure/templates/). For a child resource, the format of the type depends on whether it&#39;s nested within the parent resource or defined outside of the parent resource. See [Set name and type for child resources](https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/child-resource-name-type). |
| apiVersion | Yes | Version of the REST API to use for creating the resource. When creating a new template, set this value to the latest version of the resource you&#39;re deploying. As long as the template works as needed, keep using the same API version. By continuing to use the same API version, you minimize the risk of a new API version changing how your template works. Consider updating the API version only when you want to use a new feature that is introduced in a later version. To determine available values, see [template reference](https://docs.microsoft.com/en-us/azure/templates/). |
| name | Yes | Name of the resource. The name must follow URI component restrictions defined in RFC3986. Azure services that expose the resource name to outside parties validate the name to make sure it isn&#39;t an attempt to spoof another identity. For a child resource, the format of the name depends on whether it&#39;s nested within the parent resource or defined outside of the parent resource. See [Set name and type for child resources](https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/child-resource-name-type). |
| comments | No | Your notes for documenting the resources in your template. For more information, see [Comments in templates](https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/syntax#comments). |
| location | Varies | Supported geo-locations of the provided resource. You can select any of the available locations, but typically it makes sense to pick one that is close to your users. Usually, it also makes sense to place resources that interact with each other in the same region. Most resource types require a location, but some types (such as a role assignment) don&#39;t require a location. See [Set resource location](https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/resource-location). |
| dependsOn | No | Resources that must be deployed before this resource is deployed. Resource Manager evaluates the dependencies between resources and deploys them in the correct order. When resources aren&#39;t dependent on each other, they&#39;re deployed in parallel. The value can be a comma-separated list of a resource names or resource unique identifiers. Only list resources that are deployed in this template. Resources that aren&#39;t defined in this template must already exist. Avoid adding unnecessary dependencies as they can slow your deployment and create circular dependencies. For guidance on setting dependencies, see [Define the order for deploying resources in ARM templates](https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/resource-dependency). |
| tags | No | Tags that are associated with the resource. Apply tags to logically organize resources across your subscription. |
| identity | No | Some resources support [managed identities for Azure resources](https://docs.microsoft.com/en-us/azure/active-directory/managed-identities-azure-resources/overview). Those resources have an identity object at the root level of the resource declaration. You can set whether the identity is user-assigned or system-assigned. For user-assigned identities, provide a list of resource IDs for the identities. Set the key to the resource ID and the value to an empty object. For more information, see [Configure managed identities for Azure resources on an Azure VM using templates](https://docs.microsoft.com/en-us/azure/active-directory/managed-identities-azure-resources/qs-configure-template-windows-vm). |
| sku | No | Some resources allow values that define the SKU to deploy. For example, you can specify the type of redundancy for a storage account. |
| kind | No | Some resources allow a value that defines the type of resource you deploy. For example, you can specify the type of Cosmos DB to create. |
| scope | No | The scope property is only available for [extension resource types](https://docs.microsoft.com/en-us/azure/azure-resource-manager/management/extension-resource-types). Use it when specifying a scope that is different than the deployment scope. See [Setting scope for extension resources in ARM templates](https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/scope-extension-resources). |
| copy | No | If more than one instance is needed, the number of resources to create. The default mode is parallel. Specify serial mode when you don&#39;t want all or the resources to deploy at the same time. For more information, see [Create several instances of resources in Azure Resource Manager](https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/copy-resources). |
| plan | No | Some resources allow values that define the plan to deploy. For example, you can specify the marketplace image for a virtual machine. |
| properties | No | Resource-specific configuration settings. The values for the properties are the same as the values you provide in the request body for the REST API operation (PUT method) to create the resource. You can also specify a copy array to create several instances of a property. To determine available values, see [template reference](https://docs.microsoft.com/en-us/azure/templates/). |
| resources | No | Child resources that depend on the resource being defined. Only provide resource types that are permitted by the schema of the parent resource. Dependency on the parent resource isn&#39;t implied. You must explicitly define that dependency. See [Set name and type for child resources](https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/child-resource-name-type). |

In Bicep, see [resources](https://docs.microsoft.com/en-us/azure/azure-resource-manager/bicep/file#resources).

**Outputs**

In the outputs section, you specify values that are returned from deployment. Typically, you return values from resources that were deployed.

The following example shows the structure of an output definition:

JSONCopy

&quot;outputs&quot;: {

&quot;\&lt;output-name\&gt;&quot;: {

&quot;condition&quot;: &quot;\&lt;boolean-value-whether-to-output-value\&gt;&quot;,

&quot;type&quot;: &quot;\&lt;type-of-output-value\&gt;&quot;,

&quot;value&quot;: &quot;\&lt;output-value-expression\&gt;&quot;,

&quot;copy&quot;: {

&quot;count&quot;: \&lt;number-of-iterations\&gt;,

&quot;input&quot;: \&lt;values-for-the-variable\&gt;

}

}

}

| **Element name** | **Required** | **Description** |
| --- | --- | --- |
| output-name | Yes | Name of the output value. Must be a valid JavaScript identifier. |
| --- | --- | --- |
| condition | No | Boolean value that indicates whether this output value is returned. When true, the value is included in the output for the deployment. When false, the output value is skipped for this deployment. When not specified, the default value is true. |
| type | Yes | Type of the output value. Output values support the same types as template input parameters. If you specify  **securestring**  for the output type, the value isn&#39;t displayed in the deployment history and can&#39;t be retrieved from another template. To use a secret value in more than one template, store the secret in a Key Vault and reference the secret in the parameter file. For more information, see [Use Azure Key Vault to pass secure parameter value during deployment](https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/key-vault-parameter). |
| value | No | Template language expression that is evaluated and returned as output value. Specify either  **value**  or  **copy**. |
| copy | No | Used to return more than one value for an output. Specify  **value**  or  **copy**. For more information, see [Output iteration in ARM templates](https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/copy-outputs). |

# 3. Multiple ways to deploy arm template:

Exploring three ways to deploy your ARM templates

Microsoft Azure uses Azure Resource Manager (ARM), which allows automation and consistency when deploying cloud solutions. Often, a solution consists of several pieces, which could be any type of resource, including VMs, Storage Accounts, VNETs, and Network Security Groups. We do have the option to manually create a solution using [Azure Portal](https://azure.microsoft.com/en-us/features/azure-portal/) and that is totally fine. But in a corporate environment we need consistency and to be able to reuse code to deploy the infrastructure and solutions. We can achieve that using ARM templates, which are files based in JSON (JavaScript Object Notation), where we define which resources and their configuration, and using Azure Portal, [Visual Studio](https://techgenix.com/visual-studio-team-services-arm-templates/), PowerShell, and CLI we can have the solutions being deployed in a consistent matter. We can use the same information to deploy the same solution in several environments and that is extremely useful when working in large and complex environments.

In this article, we will explore some steps how to get your ARM template from an existent resource in Azure Portal, and then use the template to deploy using Visual Studio, Azure Portal Deployment, or PowerShell. Keep in mind that these are not the only methods to use your ARM templates — we can also use Azure CLI, Visual Studio Team Services, and others to take advantage of ARM templates, but the focus on this article will be Visual Studio, Azure Portal, and PowerShell.

## First steps: Using ARM templates and Visual Studio:

Let&#39;s start exploring Visual Studio and ARM templates. We will see how to get enough information from an existent deployment to help create our own ARM templates. For now, let&#39;s create a create a new project ( **File**  /** New Project)** and select  **Azure Resource Group**  located under the _Cloud_ item.

![](RackMultipart20220627-1-pyvqqt_html_c6757d140448c644.png)

A wizard will show up and it will ask which type of resource we are trying to deploy. We can start from scratch by selecting  **Blank Template**  or pick any of the templates available. Keep in mind that we can bring this wizard by adding a resource later on through the graphical user interface.

![](RackMultipart20220627-1-pyvqqt_html_ba09199183753bfe.png)

The initial page of Visual Studio provides tons of information for your future ARM templates. Basically, on the right side (Item 1, below) we will have all files that are part of the current solution (we should have azuredeploy.json and azuredeploy.parameters.json files). Every file that we open (item 2) will be listed there, and we can edit the code by clicking on those tabs.

Every JSON file contains four main sections: _parameters_, _variables_, _resources_ and _output_ where we will eventually add our code to deploy our Azure resources. In the left side (item 4), we have a graphical representation of what is listed on the code (item 3), for any new entry in the code, an icon will be displayed in the left side which helps to understand the items that are being added and for navigation purposes.

![](RackMultipart20220627-1-pyvqqt_html_b1ec24aeb379c00a.png)

We can add new resources in the existent ARM template in two different ways. We can write the code, copy from an existent deployment or pieces of code from Internet (GitHub for example), or use Visual Studio to add resources (just right-click on  **resources**  and then  **Add a new resource**  and select the resource from the list and enter the information and perform the changes to meet our requirements).

In order to deploy from Visual Studio, right click on _Solutions Explorer_, click on  **Deploy** , and  **New**. In the new dialog box, select or add your subscription, define the Resource Group, and both JSON files.

If we click on  **Edit Parameters**  located beside of _Template parameters files_ we can provide the values and when we hit  **Save**  all those settings will be automatically saved on the  **azuredeploy.parameters.json**  file.

![](RackMultipart20220627-1-pyvqqt_html_e57e1a4c07a3b8ac.png)

Using automation script

One of my favorite methods is using the  **Automation Script**  feature. My recommendation to understand the capabilities available is creating a new Resource Group in Azure Portal and then create the desired resource. In this article, we are going to create a Storage Account. Click on  **Create a Resource** , type  **storage** , and create your Storage Account.

Now that we have a resource in our Resource Group, we can check the  **Automation script** , and on the new blade, we can see a generalized ARM template to deploy the current resource. We can check the ARM templates and parameters file, and several other deployment methods, such as Azure CLI, PowerShell, .NET, and even Ruby.

![](RackMultipart20220627-1-pyvqqt_html_b14b0fe41cdd8430.png)

One of the features is to  **download**  a zip file containing the deployment process to deploy on every single method described and the ARM templates (template.json and parameters.json).

![](RackMultipart20220627-1-pyvqqt_html_801163ba36c807d5.png)

If you want to perform a new deployment using the current ARM template information, just click  **Deploy**  and a  **Custom Deployment**  blade will be displayed. It already has all the ARM template information from the previous blade. Basically, we just need to check the information. In our case we want to use a different name to avoid an error during deployment.

In the same location, we have the ability to change the template itself or even parameters on the fly. In order to deploy, just select the option  **I agree to the terms and conditions stated above**  and click on  **Purchase**  to start the new deployment.

![](RackMultipart20220627-1-pyvqqt_html_c228517aa7145553.png)

A couple of important points and recommendations about  **Automation Script ** that we must be aware of before using the feature, as follows:

- The  **Automation Script ** will always reflect all resources deployed in any given resource group. If you want to troubleshoot a specific resource, having a resource group with just the object is much simpler to read than a busy resource group with tons of resources deployed.
- The ARM template that we see in the  **Automation Script**  is related to what you currently have. For example, if you deploy a Storage Account and after a couple of days deploy 10 VMs and you change the initial Storage Account to use GRS instead of LRS, the current  **Automation Script**  will have all the VMs and the storage account configured as GRS.
- You can use the same feature to check properties and values when you perform a change in any given resource for troubleshooting purposes or when creating your own ARM templates
- My recommendation is to get rid of  **comments**  lines because they inform us that this current template was generalized and the source information (not required when deploying new stuff)

Using PowerShell

If you have your ARM template and your parameters, we can take advantage of PowerShell and use the New-AzureRMResourceGroupDeployment cmdlet. We need to provide the Resource Group name, the template file, we can also pass the parameters that the template file is expecting, or even pass the parameter file with all the answers.

In the example below, we have a parameter on the JSON file called  **storageaccounts\_ap6enteprisesstgacct006\_name**  and I&#39;m assigning the name _ap6stgacct0009_ where the result will be a new Storage Account with that name.

Keep in mind that we are just using the parameter name that came from  **Automation Script**  at the beginning of this article. In a normal scenario, we would work on the parameters names to keep it simple and easy to deploy.

![](RackMultipart20220627-1-pyvqqt_html_bc1d69d59e684e47.png)

# 4.why we are preference GitHub actions instead of other CI,CD tools:

At its core, GitHub Actions is designed to help simplify workflows with flexible automation and offer easy-to-use CI/CD capabilities built by developers for developers.

Compared with other automation or CI/CD tools, GitHub Actions offers native capabilities right in your GitHub flow. It also makes it easy to leverage any of the 10,000+ pre-written and tested automations and CI/CD actions [in the GitHub Marketplace](https://github.com/marketplace?category=&amp;query=&amp;type=actions&amp;verification=) as well as the ability to write your own with easy-to-use YAML files.

The best part? GitHub Actions responds to webhook events. That means you can automate any workflow based on a webhook trigger in your GitHub repository—whether it&#39;s from an event on GitHub or from a third-party tool.

##


## The benefits of GitHub Actions:

GitHub Actions offers a powerful array of functionality and features to aid your developer experience. Here are just a few:

- **Automate everything within the GitHub flow:**  Actions gives you the ability to implement powerful automations right in your repositories. You can create your own actions or use readily available actions on the GitHub Marketplace to integrate your preferred tools right into your repository.
- **Hosted virtual machines on multiple operating systems:**  Actions offer hosted virtual machines (VM) with Ubuntu Linux, Windows, and macOS so you can build, test, and deploy code directly to the operating system of your choice—or all three at the same time.
- **Pre-written CI templates that are ready to use:**  GitHub Actions brings continuous integration (CI) directly to the GitHub flow with templates built by developers for developers. You can also create your own custom CI workflows, and your own continuous deployment (CD) workflows, too (more on that later).
- **Simple container and operating system testing:**  With support for Docker and access to hosted instances of Ubuntu Linux, Windows, and macOS, Actions make it simple to build and test code across systems—and automate build and test workflows, too.
- **Use it on your public repository for free:**  GitHub Actions is free to use on all public repositories—and can be used for free on private repositories with a limit of 2,000 minutes a month of hosted workflows (or an unlimited amount of minutes if a developer hosts their own GitHub Action server).


# **Window ARM template**

**Why choose ARM templates?**

If you&#39;re trying to decide between using ARM templates and one of the other infrastructures as code services, consider the following advantages of using templates:

- **Declarative syntax** : ARM templates allow you to create and deploy an entire Azure infrastructure declaratively. For example, you can deploy not only virtual machines, but also the network infrastructure, storage systems, and any other resources you may need.
- **Repeatable results** : Repeatedly deploy your infrastructure throughout the development lifecycle and have confidence your resources are deployed in a consistent manner. Templates are idempotent, which means you can deploy the same template many times and get the same resource types in the same state. You can develop one template that represents the desired state, rather than developing lots of separate templates to represent updates.
- **Orchestration** : You don&#39;t have to worry about the complexities of ordering operations. Resource Manager orchestrates the deployment of interdependent resources so they&#39;re created in the correct order. When possible, Resource Manager deploys resources in parallel so your deployments finish faster than serial deployments. You deploy the template through one command, rather than through multiple imperative commands.

![](RackMultipart20220627-1-dul320_html_96a9fdde59cdb3f9.png)

- **Modular files** : You can break your templates into smaller, reusable components and link them together at deployment time. You can also nest one template inside another template.
- **Create any Azure resource** : You can immediately use new Azure services and features in templates. As soon as a resource provider introduces new resources, you can deploy those resources through templates. You don&#39;t have to wait for tools or modules to be updated before using the new services.
- **Extensibility** : With [deployment scripts](https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/deployment-script-template), you can add PowerShell or Bash scripts to your templates. The deployment scripts extend your ability to set up resources during deployment. A script can be included in the template, or stored in an external source and referenced in the template. Deployment scripts give you the ability to complete your end-to-end environment setup in a single ARM template.
- **Testing** : You can make sure your template follows recommended guidelines by testing it with the ARM template tool kit (arm-ttk). This test kit is a PowerShell script that you can download from [GitHub](https://github.com/Azure/arm-ttk). The tool kit makes it easier for you to develop expertise using the template language.
- **Preview changes** : You can use the [what-if operation](https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/deploy-what-if) to get a preview of changes before deploying the template. With what-if, you see which resources will be created, updated, or deleted, and any resource properties that will be changed. The what-if operation checks the current state of your environment and eliminates the need to manage state.
- **Built-in validation** : Your template is deployed only after passing validation. Resource Manager checks the template before starting the deployment to make sure the deployment will succeed. Your deployment is less likely to stop in a half-finished state.
- **Tracked deployments** : In the Azure portal, you can review the deployment history and get information about the template deployment. You can see the template that was deployed, the parameter values passed in, and any output values. Other infrastructure as code services aren&#39;t tracked through the portal.

![](RackMultipart20220627-1-dul320_html_b95701ddc7485540.png)

- **Policy as code** : [Azure Policy](https://docs.microsoft.com/en-us/azure/governance/policy/overview) is a policy as code framework to automate governance. If you&#39;re using Azure policies, policy remediation is done on non-compliant resources when deployed through templates.
- **Deployment Blueprints** : You can take advantage of [Blueprints](https://docs.microsoft.com/en-us/azure/governance/blueprints/overview) provided by Microsoft to meet regulatory and compliance standards. These blueprints include pre-built templates for various architectures.
- **CI/CD integration** : You can integrate templates into your continuous integration and continuous deployment (CI/CD) tools, which can automate your release pipelines for fast and reliable application and infrastructure updates. By using Azure DevOps and Resource Manager template task, you can use Azure Pipelines to continuously build and deploy ARM template projects. To learn more, see [VS project with pipelines](https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/add-template-to-azure-pipelines) and [Tutorial: Continuous integration of Azure Resource Manager templates with Azure Pipelines](https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/deployment-tutorial-pipeline).
- **Exportable code** : You can get a template for an existing resource group by either exporting the current state of the resource group, or viewing the template used for a particular deployment. Viewing the [exported template](https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/export-template-portal) is a helpful way to learn about the template syntax.
- **Authoring tools** : You can author templates with [Visual Studio Code](https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/quickstart-create-templates-use-visual-studio-code) and the template tool extension. You get intellisense, syntax highlighting, in-line help, and many other language functions. In addition to Visual Studio Code, you can also use [Visual Studio](https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/create-visual-studio-deployment-project).

# 2.what are the requirements for arm template:

**Template format**

In its simplest structure, a template has the following elements:

JSONCopy

{

&quot;$schema&quot;: &quot;https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#&quot;,

&quot;contentVersion&quot;: &quot;&quot;,

&quot;apiProfile&quot;: &quot;&quot;,

&quot;parameters&quot;: { },

&quot;variables&quot;: { },

&quot;functions&quot;: [],

&quot;resources&quot;: [],

&quot;outputs&quot;: { }

}

| **Element name** | **Required** | **Description** |
| --- | --- | --- |
| $schema | Yes | Location of the JavaScript Object Notation (JSON) schema file that describes the version of the template language. The version number you use depends on the scope of the deployment and your JSON editor.

 If you&#39;re using [Visual Studio Code with the Azure Resource Manager tools extension](https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/quickstart-create-templates-use-visual-studio-code), use the latest version for resource group deployments:
https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#

 Other editors (including Visual Studio) may not be able to process this schema. For those editors, use:
https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#

 For subscription deployments, use:
https://schema.management.azure.com/schemas/2018-05-01/subscriptionDeploymentTemplate.json#

 For management group deployments, use:
https://schema.management.azure.com/schemas/2019-08-01/managementGroupDeploymentTemplate.json#

 For tenant deployments, use:
https://schema.management.azure.com/schemas/2019-08-01/tenantDeploymentTemplate.json# |
| --- | --- | --- |
| contentVersion | Yes | Version of the template (such as 1.0.0.0). You can provide any value for this element. Use this value to document significant changes in your template. When deploying resources using the template, this value can be used to make sure that the right template is being used. |
| apiProfile | No | An API version that serves as a collection of API versions for resource types. Use this value to avoid having to specify API versions for each resource in the template. When you specify an API profile version and don&#39;t specify an API version for the resource type, Resource Manager uses the API version for that resource type that is defined in the profile.

 The API profile property is especially helpful when deploying a template to different environments, such as Azure Stack and global Azure. Use the API profile version to make sure your template automatically uses versions that are supported in both environments. For a list of the current API profile versions and the resources API versions defined in the profile, see [API Profile](https://github.com/Azure/azure-rest-api-specs/tree/master/profile).

 For more information, see [Track versions using API profiles](https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/template-cloud-consistency#track-versions-using-api-profiles). |
| [parameters](https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/syntax#parameters) | No | Values that are provided when deployment is executed to customize resource deployment. |
| [variables](https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/syntax#variables) | No | Values that are used as JSON fragments in the template to simplify template language expressions. |
| [functions](https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/syntax#functions) | No | User-defined functions that are available within the template. |
| [resources](https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/syntax#resources) | Yes | Resource types that are deployed or updated in a resource group or subscription. |
| [outputs](https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/syntax#outputs) | No | Values that are returned after deployment. |

Each element has properties you can set. This article describes the sections of the template in greater detail.

**Parameters**

In the parameters section of the template, you specify which values you can input when deploying the resources. You&#39;re limited to 256 parameters in a template. You can reduce the number of parameters by using objects that contain multiple properties.

The available properties for a parameter are:

JSONCopy

&quot;parameters&quot;: {

&quot;\&lt;parameter-name\&gt;&quot; : {

&quot;type&quot; : &quot;\&lt;type-of-parameter-value\&gt;&quot;,

&quot;defaultValue&quot;: &quot;\&lt;default-value-of-parameter\&gt;&quot;,

&quot;allowedValues&quot;: [&quot;\&lt;array-of-allowed-values\&gt;&quot;],

&quot;minValue&quot;: \&lt;minimum-value-for-int\&gt;,

&quot;maxValue&quot;: \&lt;maximum-value-for-int\&gt;,

&quot;minLength&quot;: \&lt;minimum-length-for-string-or-array\&gt;,

&quot;maxLength&quot;: \&lt;maximum-length-for-string-or-array-parameters\&gt;,

&quot;metadata&quot;: {

&quot;description&quot;: &quot;\&lt;description-of-the parameter\&gt;&quot;

}

}

}

| **Element name** | **Required** | **Description** |
| --- | --- | --- |
| parameter-name | Yes | Name of the parameter. Must be a valid JavaScript identifier. |
| --- | --- | --- |
| type | Yes | Type of the parameter value. The allowed types and values are  **string** ,  **securestring** ,  **int** ,  **bool** ,  **object** ,  **secureObject** , and  **array**. See [Data types in ARM templates](https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/data-types). |
| defaultValue | No | Default value for the parameter, if no value is provided for the parameter. |
| allowedValues | No | Array of allowed values for the parameter to make sure that the right value is provided. |
| minValue | No | The minimum value for int type parameters, this value is inclusive. |
| maxValue | No | The maximum value for int type parameters, this value is inclusive. |
| minLength | No | The minimum length for string, secure string, and array type parameters, this value is inclusive. |
| maxLength | No | The maximum length for string, secure string, and array type parameters, this value is inclusive. |
| description | No | Description of the parameter that is displayed to users through the portal. For more information, see [Comments in templates](https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/syntax#comments). |

For examples of how to use parameters, see [Parameters in ARM templates](https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/parameters).

In Bicep, see [parameters](https://docs.microsoft.com/en-us/azure/azure-resource-manager/bicep/file#parameters).

**Variables**

In the variables section, you construct values that can be used throughout your template. You don&#39;t need to define variables, but they often simplify your template by reducing complex expressions. The format of each variable matches one of the [data types](https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/data-types).

The following example shows the available options for defining a variable:

JSONCopy

&quot;variables&quot;: {

&quot;\&lt;variable-name\&gt;&quot;: &quot;\&lt;variable-value\&gt;&quot;,

&quot;\&lt;variable-name\&gt;&quot;: {

\&lt;variable-complex-type-value\&gt;

},

&quot;\&lt;variable-object-name\&gt;&quot;: {

&quot;copy&quot;: [

{

&quot;name&quot;: &quot;\&lt;name-of-array-property\&gt;&quot;,

&quot;count&quot;: \&lt;number-of-iterations\&gt;,

&quot;input&quot;: \&lt;object-or-value-to-repeat\&gt;

}

]

},

&quot;copy&quot;: [

{

&quot;name&quot;: &quot;\&lt;variable-array-name\&gt;&quot;,

&quot;count&quot;: \&lt;number-of-iterations\&gt;,

&quot;input&quot;: \&lt;object-or-value-to-repeat\&gt;

}

]

}

For information about using copy to create several values for a variable, see [Variable iteration](https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/copy-variables).

For examples of how to use variables, see [Variables in ARM template](https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/variables).

In Bicep, see [variables](https://docs.microsoft.com/en-us/azure/azure-resource-manager/bicep/file#variables).

**Functions**

Within your template, you can create your own functions. These functions are available for use in your template. Typically, you define complicated expressions that you don&#39;t want to repeat throughout your template. You create the user-defined functions from expressions and [functions](https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/template-functions) that are supported in templates.

When defining a user function, there are some restrictions:

- The function can&#39;t access variables.
- The function can only use parameters that are defined in the function. When you use the [parameters function](https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/template-functions-deployment#parameters) within a user-defined function, you&#39;re restricted to the parameters for that function.
- The function can&#39;t call other user-defined functions.
- The function can&#39;t use the [reference function](https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/template-functions-resource#reference).
- Parameters for the function can&#39;t have default values.

JSONCopy

&quot;functions&quot;: [

{

&quot;namespace&quot;: &quot;\&lt;namespace-for-functions\&gt;&quot;,

&quot;members&quot;: {

&quot;\&lt;function-name\&gt;&quot;: {

&quot;parameters&quot;: [

{

&quot;name&quot;: &quot;\&lt;parameter-name\&gt;&quot;,

&quot;type&quot;: &quot;\&lt;type-of-parameter-value\&gt;&quot;

}

],

&quot;output&quot;: {

&quot;type&quot;: &quot;\&lt;type-of-output-value\&gt;&quot;,

&quot;value&quot;: &quot;\&lt;function-return-value\&gt;&quot;

}

}

}

}

],

| **Element name** | **Required** | **Description** |
| --- | --- | --- |
| namespace | Yes | Namespace for the custom functions. Use to avoid naming conflicts with template functions. |
| --- | --- | --- |
| function-name | Yes | Name of the custom function. When calling the function, combine the function name with the namespace. For example, to call a function named uniqueName in the namespace contoso, use &quot;[contoso.uniqueName()]&quot;. |
| parameter-name | No | Name of the parameter to be used within the custom function. |
| parameter-value | No | Type of the parameter value. The allowed types and values are  **string** ,  **securestring** ,  **int** ,  **bool** ,  **object** ,  **secureObject** , and  **array**. |
| output-type | Yes | Type of the output value. Output values support the same types as function input parameters. |
| output-value | Yes | Template language expression that is evaluated and returned from the function. |

For examples of how to use custom functions, see [User-defined functions in ARM template](https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/user-defined-functions).

In Bicep, user-defined functions aren&#39;t supported. Bicep does support a variety of [functions](https://docs.microsoft.com/en-us/azure/azure-resource-manager/bicep/bicep-functions) and [operators](https://docs.microsoft.com/en-us/azure/azure-resource-manager/bicep/operators).

**Resources**

In the resources section, you define the resources that are deployed or updated.

You define resources with the following structure:

JSONCopy

&quot;resources&quot;: [

{

&quot;condition&quot;: &quot;\&lt;true-to-deploy-this-resource\&gt;&quot;,

&quot;type&quot;: &quot;\&lt;resource-provider-namespace/resource-type-name\&gt;&quot;,

&quot;apiVersion&quot;: &quot;\&lt;api-version-of-resource\&gt;&quot;,

&quot;name&quot;: &quot;\&lt;name-of-the-resource\&gt;&quot;,

&quot;comments&quot;: &quot;\&lt;your-reference-notes\&gt;&quot;,

&quot;location&quot;: &quot;\&lt;location-of-resource\&gt;&quot;,

&quot;dependsOn&quot;: [

&quot;\&lt;array-of-related-resource-names\&gt;&quot;

],

&quot;tags&quot;: {

&quot;\&lt;tag-name1\&gt;&quot;: &quot;\&lt;tag-value1\&gt;&quot;,

&quot;\&lt;tag-name2\&gt;&quot;: &quot;\&lt;tag-value2\&gt;&quot;

},

&quot;identity&quot;: {

&quot;type&quot;: &quot;\&lt;system-assigned-or-user-assigned-identity\&gt;&quot;,

&quot;userAssignedIdentities&quot;: {

&quot;\&lt;resource-id-of-identity\&gt;&quot;: {}

}

},

&quot;sku&quot;: {

&quot;name&quot;: &quot;\&lt;sku-name\&gt;&quot;,

&quot;tier&quot;: &quot;\&lt;sku-tier\&gt;&quot;,

&quot;size&quot;: &quot;\&lt;sku-size\&gt;&quot;,

&quot;family&quot;: &quot;\&lt;sku-family\&gt;&quot;,

&quot;capacity&quot;: \&lt;sku-capacity\&gt;

},

&quot;kind&quot;: &quot;\&lt;type-of-resource\&gt;&quot;,

&quot;scope&quot;: &quot;\&lt;target-scope-for-extension-resources\&gt;&quot;,

&quot;copy&quot;: {

&quot;name&quot;: &quot;\&lt;name-of-copy-loop\&gt;&quot;,

&quot;count&quot;: \&lt;number-of-iterations\&gt;,

&quot;mode&quot;: &quot;\&lt;serial-or-parallel\&gt;&quot;,

&quot;batchSize&quot;: \&lt;number-to-deploy-serially\&gt;

},

&quot;plan&quot;: {

&quot;name&quot;: &quot;\&lt;plan-name\&gt;&quot;,

&quot;promotionCode&quot;: &quot;\&lt;plan-promotion-code\&gt;&quot;,

&quot;publisher&quot;: &quot;\&lt;plan-publisher\&gt;&quot;,

&quot;product&quot;: &quot;\&lt;plan-product\&gt;&quot;,

&quot;version&quot;: &quot;\&lt;plan-version\&gt;&quot;

},

&quot;properties&quot;: {

&quot;\&lt;settings-for-the-resource\&gt;&quot;,

&quot;copy&quot;: [

{

&quot;name&quot;: ,

&quot;count&quot;: ,

&quot;input&quot;: {}

}

]

},

&quot;resources&quot;: [

&quot;\&lt;array-of-child-resources\&gt;&quot;

]

}

]

| **Element name** | **Required** | **Description** |
| --- | --- | --- |
| condition | No | Boolean value that indicates whether the resource will be provisioned during this deployment. When true, the resource is created during deployment. When false, the resource is skipped for this deployment. See [condition](https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/conditional-resource-deployment). |
| --- | --- | --- |
| type | Yes | Type of the resource. This value is a combination of the namespace of the resource provider and the resource type (such as Microsoft.Storage/storageAccounts). To determine available values, see [template reference](https://docs.microsoft.com/en-us/azure/templates/). For a child resource, the format of the type depends on whether it&#39;s nested within the parent resource or defined outside of the parent resource. See [Set name and type for child resources](https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/child-resource-name-type). |
| apiVersion | Yes | Version of the REST API to use for creating the resource. When creating a new template, set this value to the latest version of the resource you&#39;re deploying. As long as the template works as needed, keep using the same API version. By continuing to use the same API version, you minimize the risk of a new API version changing how your template works. Consider updating the API version only when you want to use a new feature that is introduced in a later version. To determine available values, see [template reference](https://docs.microsoft.com/en-us/azure/templates/). |
| name | Yes | Name of the resource. The name must follow URI component restrictions defined in RFC3986. Azure services that expose the resource name to outside parties validate the name to make sure it isn&#39;t an attempt to spoof another identity. For a child resource, the format of the name depends on whether it&#39;s nested within the parent resource or defined outside of the parent resource. See [Set name and type for child resources](https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/child-resource-name-type). |
| comments | No | Your notes for documenting the resources in your template. For more information, see [Comments in templates](https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/syntax#comments). |
| location | Varies | Supported geo-locations of the provided resource. You can select any of the available locations, but typically it makes sense to pick one that is close to your users. Usually, it also makes sense to place resources that interact with each other in the same region. Most resource types require a location, but some types (such as a role assignment) don&#39;t require a location. See [Set resource location](https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/resource-location). |
| dependsOn | No | Resources that must be deployed before this resource is deployed. Resource Manager evaluates the dependencies between resources and deploys them in the correct order. When resources aren&#39;t dependent on each other, they&#39;re deployed in parallel. The value can be a comma-separated list of a resource names or resource unique identifiers. Only list resources that are deployed in this template. Resources that aren&#39;t defined in this template must already exist. Avoid adding unnecessary dependencies as they can slow your deployment and create circular dependencies. For guidance on setting dependencies, see [Define the order for deploying resources in ARM templates](https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/resource-dependency). |
| tags | No | Tags that are associated with the resource. Apply tags to logically organize resources across your subscription. |
| identity | No | Some resources support [managed identities for Azure resources](https://docs.microsoft.com/en-us/azure/active-directory/managed-identities-azure-resources/overview). Those resources have an identity object at the root level of the resource declaration. You can set whether the identity is user-assigned or system-assigned. For user-assigned identities, provide a list of resource IDs for the identities. Set the key to the resource ID and the value to an empty object. For more information, see [Configure managed identities for Azure resources on an Azure VM using templates](https://docs.microsoft.com/en-us/azure/active-directory/managed-identities-azure-resources/qs-configure-template-windows-vm). |
| sku | No | Some resources allow values that define the SKU to deploy. For example, you can specify the type of redundancy for a storage account. |
| kind | No | Some resources allow a value that defines the type of resource you deploy. For example, you can specify the type of Cosmos DB to create. |
| scope | No | The scope property is only available for [extension resource types](https://docs.microsoft.com/en-us/azure/azure-resource-manager/management/extension-resource-types). Use it when specifying a scope that is different than the deployment scope. See [Setting scope for extension resources in ARM templates](https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/scope-extension-resources). |
| copy | No | If more than one instance is needed, the number of resources to create. The default mode is parallel. Specify serial mode when you don&#39;t want all or the resources to deploy at the same time. For more information, see [Create several instances of resources in Azure Resource Manager](https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/copy-resources). |
| plan | No | Some resources allow values that define the plan to deploy. For example, you can specify the marketplace image for a virtual machine. |
| properties | No | Resource-specific configuration settings. The values for the properties are the same as the values you provide in the request body for the REST API operation (PUT method) to create the resource. You can also specify a copy array to create several instances of a property. To determine available values, see [template reference](https://docs.microsoft.com/en-us/azure/templates/). |
| resources | No | Child resources that depend on the resource being defined. Only provide resource types that are permitted by the schema of the parent resource. Dependency on the parent resource isn&#39;t implied. You must explicitly define that dependency. See [Set name and type for child resources](https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/child-resource-name-type). |

In Bicep, see [resources](https://docs.microsoft.com/en-us/azure/azure-resource-manager/bicep/file#resources).

**Outputs**

In the outputs section, you specify values that are returned from deployment. Typically, you return values from resources that were deployed.

The following example shows the structure of an output definition:

JSONCopy

&quot;outputs&quot;: {

&quot;\&lt;output-name\&gt;&quot;: {

&quot;condition&quot;: &quot;\&lt;boolean-value-whether-to-output-value\&gt;&quot;,

&quot;type&quot;: &quot;\&lt;type-of-output-value\&gt;&quot;,

&quot;value&quot;: &quot;\&lt;output-value-expression\&gt;&quot;,

&quot;copy&quot;: {

&quot;count&quot;: \&lt;number-of-iterations\&gt;,

&quot;input&quot;: \&lt;values-for-the-variable\&gt;

}

}

}

| **Element name** | **Required** | **Description** |
| --- | --- | --- |
| output-name | Yes | Name of the output value. Must be a valid JavaScript identifier. |
| --- | --- | --- |
| condition | No | Boolean value that indicates whether this output value is returned. When true, the value is included in the output for the deployment. When false, the output value is skipped for this deployment. When not specified, the default value is true. |
| type | Yes | Type of the output value. Output values support the same types as template input parameters. If you specify  **securestring**  for the output type, the value isn&#39;t displayed in the deployment history and can&#39;t be retrieved from another template. To use a secret value in more than one template, store the secret in a Key Vault and reference the secret in the parameter file. For more information, see [Use Azure Key Vault to pass secure parameter value during deployment](https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/key-vault-parameter). |
| value | No | Template language expression that is evaluated and returned as output value. Specify either  **value**  or  **copy**. |
| copy | No | Used to return more than one value for an output. Specify  **value**  or  **copy**. For more information, see [Output iteration in ARM templates](https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/copy-outputs). |

# 3. Multiple ways to deploy arm template:

Exploring three ways to deploy your ARM templates

Microsoft Azure uses Azure Resource Manager (ARM), which allows automation and consistency when deploying cloud solutions. Often, a solution consists of several pieces, which could be any type of resource, including VMs, Storage Accounts, VNETs, and Network Security Groups. We do have the option to manually create a solution using [Azure Portal](https://azure.microsoft.com/en-us/features/azure-portal/) and that is totally fine. But in a corporate environment we need consistency and to be able to reuse code to deploy the infrastructure and solutions. We can achieve that using ARM templates, which are files based in JSON (JavaScript Object Notation), where we define which resources and their configuration, and using Azure Portal, [Visual Studio](https://techgenix.com/visual-studio-team-services-arm-templates/), PowerShell, and CLI we can have the solutions being deployed in a consistent matter. We can use the same information to deploy the same solution in several environments and that is extremely useful when working in large and complex environments.

In this article, we will explore some steps how to get your ARM template from an existent resource in Azure Portal, and then use the template to deploy using Visual Studio, Azure Portal Deployment, or PowerShell. Keep in mind that these are not the only methods to use your ARM templates — we can also use Azure CLI, Visual Studio Team Services, and others to take advantage of ARM templates, but the focus on this article will be Visual Studio, Azure Portal, and PowerShell.

## **First steps: Using ARM templates and Visual Studio:**

Let&#39;s start exploring Visual Studio and ARM templates. We will see how to get enough information from an existent deployment to help create our own ARM templates. For now, let&#39;s create a create a new project ( **File**  /** New Project)** and select  **Azure Resource Group**  located under the _Cloud_ item.

![](RackMultipart20220627-1-dul320_html_c6757d140448c644.png)

A wizard will show up and it will ask which type of resource we are trying to deploy. We can start from scratch by selecting  **Blank Template**  or pick any of the templates available. Keep in mind that we can bring this wizard by adding a resource later on through the graphical user interface.

![](RackMultipart20220627-1-dul320_html_ba09199183753bfe.png)

The initial page of Visual Studio provides tons of information for your future ARM templates. Basically, on the right side (Item 1, below) we will have all files that are part of the current solution (we should have azuredeploy.json and azuredeploy.parameters.json files). Every file that we open (item 2) will be listed there, and we can edit the code by clicking on those tabs.

Every JSON file contains four main sections: _parameters_, _variables_, _resources_ and _output_ where we will eventually add our code to deploy our Azure resources. In the left side (item 4), we have a graphical representation of what is listed on the code (item 3), for any new entry in the code, an icon will be displayed in the left side which helps to understand the items that are being added and for navigation purposes.

![](RackMultipart20220627-1-dul320_html_b1ec24aeb379c00a.png)

We can add new resources in the existent ARM template in two different ways. We can write the code, copy from an existent deployment or pieces of code from Internet (GitHub for example), or use Visual Studio to add resources (just right-click on  **resources**  and then  **Add a new resource**  and select the resource from the list and enter the information and perform the changes to meet our requirements).

In order to deploy from Visual Studio, right click on _Solutions Explorer_, click on  **Deploy** , and  **New**. In the new dialog box, select or add your subscription, define the Resource Group, and both JSON files.

If we click on  **Edit Parameters**  located beside of _Template parameters files_ we can provide the values and when we hit  **Save**  all those settings will be automatically saved on the  **azuredeploy.parameters.json**  file.

![](RackMultipart20220627-1-dul320_html_e57e1a4c07a3b8ac.png)

Using automation script

One of my favorite methods is using the  **Automation Script**  feature. My recommendation to understand the capabilities available is creating a new Resource Group in Azure Portal and then create the desired resource. In this article, we are going to create a Storage Account. Click on  **Create a Resource** , type  **storage** , and create your Storage Account.

Now that we have a resource in our Resource Group, we can check the  **Automation script** , and on the new blade, we can see a generalized ARM template to deploy the current resource. We can check the ARM templates and parameters file, and several other deployment methods, such as Azure CLI, PowerShell, .NET, and even Ruby.

![](RackMultipart20220627-1-dul320_html_b14b0fe41cdd8430.png)

One of the features is to  **download**  a zip file containing the deployment process to deploy on every single method described and the ARM templates (template.json and parameters.json).

![](RackMultipart20220627-1-dul320_html_801163ba36c807d5.png)

If you want to perform a new deployment using the current ARM template information, just click  **Deploy**  and a  **Custom Deployment**  blade will be displayed. It already has all the ARM template information from the previous blade. Basically, we just need to check the information. In our case we want to use a different name to avoid an error during deployment.

In the same location, we have the ability to change the template itself or even parameters on the fly. In order to deploy, just select the option  **I agree to the terms and conditions stated above**  and click on  **Purchase**  to start the new deployment.

![](RackMultipart20220627-1-dul320_html_c228517aa7145553.png)

A couple of important points and recommendations about  **Automation Script ** that we must be aware of before using the feature, as follows:

- The  **Automation Script ** will always reflect all resources deployed in any given resource group. If you want to troubleshoot a specific resource, having a resource group with just the object is much simpler to read than a busy resource group with tons of resources deployed.
- The ARM template that we see in the  **Automation Script**  is related to what you currently have. For example, if you deploy a Storage Account and after a couple of days deploy 10 VMs and you change the initial Storage Account to use GRS instead of LRS, the current  **Automation Script**  will have all the VMs and the storage account configured as GRS.
- You can use the same feature to check properties and values when you perform a change in any given resource for troubleshooting purposes or when creating your own ARM templates
- My recommendation is to get rid of  **comments**  lines because they inform us that this current template was generalized and the source information (not required when deploying new stuff)

Using PowerShell

If you have your ARM template and your parameters, we can take advantage of PowerShell and use the New-AzureRMResourceGroupDeployment cmdlet. We need to provide the Resource Group name, the template file, we can also pass the parameters that the template file is expecting, or even pass the parameter file with all the answers.

In the example below, we have a parameter on the JSON file called  **storageaccounts\_ap6enteprisesstgacct006\_name**  and I&#39;m assigning the name _ap6stgacct0009_ where the result will be a new Storage Account with that name.

Keep in mind that we are just using the parameter name that came from  **Automation Script**  at the beginning of this article. In a normal scenario, we would work on the parameters names to keep it simple and easy to deploy.

![](RackMultipart20220627-1-dul320_html_bc1d69d59e684e47.png)

# 4.why we are preference GitHub actions instead of other CI,CD tools:

At its core, GitHub Actions is designed to help simplify workflows with flexible automation and offer easy-to-use CI/CD capabilities built by developers for developers.

Compared with other automation or CI/CD tools, GitHub Actions offers native capabilities right in your GitHub flow. It also makes it easy to leverage any of the 10,000+ pre-written and tested automations and CI/CD actions [in the GitHub Marketplace](https://github.com/marketplace?category=&amp;query=&amp;type=actions&amp;verification=) as well as the ability to write your own with easy-to-use YAML files.

The best part? GitHub Actions responds to webhook events. That means you can automate any workflow based on a webhook trigger in your GitHub repository—whether it&#39;s from an event on GitHub or from a third-party tool.

##


## The benefits of GitHub Actions:

GitHub Actions offers a powerful array of functionality and features to aid your developer experience. Here are just a few:

- **Automate everything within the GitHub flow:**  Actions gives you the ability to implement powerful automations right in your repositories. You can create your own actions or use readily available actions on the GitHub Marketplace to integrate your preferred tools right into your repository.
- **Hosted virtual machines on multiple operating systems:**  Actions offer hosted virtual machines (VM) with Ubuntu Linux, Windows, and macOS so you can build, test, and deploy code directly to the operating system of your choice—or all three at the same time.
- **Pre-written CI templates that are ready to use:**  GitHub Actions brings continuous integration (CI) directly to the GitHub flow with templates built by developers for developers. You can also create your own custom CI workflows, and your own continuous deployment (CD) workflows, too (more on that later).
- **Simple container and operating system testing:**  With support for Docker and access to hosted instances of Ubuntu Linux, Windows, and macOS, Actions make it simple to build and test code across systems—and automate build and test workflows, too.
- **Use it on your public repository for free:**  GitHub Actions is free to use on all public repositories—and can be used for free on private repositories with a limit of 2,000 minutes a month of hosted workflows (or an unlimited amount of minutes if a developer hosts their own GitHub Action server).

**Creating Microsoft portal credentials for service principal**

## Generate deployment credentials

- [Service principal](https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/deploy-github-actions?tabs=userlevel#tabpanel_1_userlevel)

You can create a [service principal](https://docs.microsoft.com/en-us/azure/active-directory/develop/app-objects-and-service-principals#service-principal-object) with the [az ad sp create-for-rbac](https://docs.microsoft.com/en-us/cli/azure/ad/sp#az-ad-sp-create-for-rbac) command in the [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/). Run this command with [Azure Cloud Shell](https://shell.azure.com/) in the Azure portal or by selecting the  **Try it**  button.

Create a resource group if you do not already have one.

Try It

az group create -n {MyResourceGroup} -l {location}

Replace the placeholder myApp with the name of your application.

Azure CLICopy

Try It

az ad sp create-for-rbac--name {myApp} --role contributor --scopes /subscriptions/{subscription-id}/resourceGroups/{MyResourceGroup} --sdk-auth

In the example above, replace the placeholders with your subscription ID and resource group name. The output is a JSON object with the role assignment credentials that provide access to your App Service app similar to below. Copy this JSON object for later. You will only need the sections with the clientId, clientSecret, subscriptionId, and tenantId values.

{

&quot;clientId&quot;: &quot;\&lt;GUID\&gt;&quot;,

&quot;clientSecret&quot;: &quot;\&lt;GUID\&gt;&quot;,

&quot;subscriptionId&quot;: &quot;\&lt;GUID\&gt;&quot;,

&quot;tenantId&quot;: &quot;\&lt;GUID\&gt;&quot;,

(...)

}

  **Important**

It is always a good practice to grant minimum access. The scope in the previous example is limited to the resource group.

## Configure the GitHub secrets

- [Service principal](https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/deploy-github-actions?tabs=userlevel#tabpanel_2_userlevel)

You need to create secrets for your Azure credentials, resource group, and subscriptions.

1. In [GitHub](https://github.com/), browse your repository.
2. Select  **Settings \&gt; Secrets \&gt; New secret**.
3. Paste the entire JSON output from the Azure CLI command into the secret&#39;s value field. Give the secret the name AZURE\_CREDENTIALS.
4. Create another secret named AZURE\_RG. Add the name of your resource group to the secret&#39;s value field (example: myResourceGroup).
5. Create an additional secret named AZURE\_SUBSCRIPTION. Add your subscription ID to the secret&#39;s value field (example: 90fd3f9d-4c61-432d-99ba-1273f236afa2).

## Add Resource Manager template

Add a Resource Manager template to your GitHub repository. This template creates a storage account.

https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/quickstarts/microsoft.storage/storage-account-create/azuredeploy.json

You can put the file anywhere in the repository. The workflow sample in the next section assumes the template file is named  **azuredeploy.json** , and it is stored at the root of your repository.

## Create workflow

The workflow file must be stored in the  **.github/workflows**  folder at the root of your repository. The workflow file extension can be either  **.yml**  or  **.yaml**.

1. From your GitHub repository, select  **Actions**  from the top menu.
2. Select  **New workflow**.
3. Select  **set up a workflow yourself**.
4. Rename the workflow file if you prefer a different name other than  **main.yml**. For example:  **deployStorageAccount.yml**.
5. Replace the content of the yml file with the following:

- [Service principal](https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/deploy-github-actions?tabs=userlevel#tabpanel_3_userlevel)

on:[push]

name:AzureARM

jobs:

build-and-deploy:

runs-on:ubuntu-latest

steps:

# Checkout code

- uses:actions/checkout@main

# Log into Azure

- uses:azure/login@v1

with:

creds:${{secrets.AZURE\_CREDENTIALS}}

# Deploy ARM template

- name:RunARMdeploy

uses:azure/arm-deploy@v1

with:

subscriptionId:${{secrets.AZURE\_SUBSCRIPTION}}

resourceGroupName:${{secrets.AZURE\_RG}}

template:./azuredeploy.json

parameters:storageAccountType=Standard\_LRS

# output containerName variable from template

- run:echo${{steps.deploy.outputs.containerName}}

- **Creating Microsoft portal credentials for OpenID connect** :

## Generate deployment credentials

- [OpenID Connect](https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/deploy-github-actions?tabs=openid#tabpanel_1_openid)

OpenID Connect is an authentication method that uses short-lived tokens. Setting up [OpenID Connect with GitHub Actions](https://docs.github.com/en/actions/deployment/security-hardening-your-deployments/about-security-hardening-with-openid-connect) is more complex process that offers hardened security.

1. If you do not have an existing application, register a [new Active Directory application and service principal that can access resources](https://docs.microsoft.com/en-us/azure/active-directory/develop/howto-create-service-principal-portal). Create the Active Directory application.

Try It

az ad app create --display-name myApp

This command will output JSON with an appId that is your client-id. Save the value to use as the AZURE\_CLIENT\_ID GitHub secret later.

You&#39;ll use the objectId value when creating federated credentials with Graph API and reference it as the APPLICATION-OBJECT-ID.

1. Create a service principal. Replace the $appID with the appId from your JSON output.

This command generates JSON output with a different objectId and will be used in the next step. The new objectId is the assignee-object-id.

Copy the appOwnerTenantId to use as a GitHub secret for AZURE\_TENANT\_ID later.

Try It

az ad sp create --id$appId

1. Create a new role assignment by subscription and object. By default, the role assignment will be tied to your default subscription. Replace $subscriptionId with your subscription ID, $resourceGroupName with your resource group name, and $assigneeObjectId with the generated assignee-object-id. Learn [how to manage Azure subscriptions with the Azure CLI](https://docs.microsoft.com/en-us/cli/azure/manage-azure-subscriptions-azure-cli).

Try It

az role assignment create --role contributor --subscription$subscriptionId--assignee-object-id$assigneeObjectId--assignee-principal-type ServicePrincipal --scopes /subscriptions/$subscriptionId/resourceGroups/$resourceGroupName/providers/Microsoft.Web/sites/

1. Run the following command to [create a new federated identity credential](https://docs.microsoft.com/en-us/graph/api/application-post-federatedidentitycredentials?view=graph-rest-beta&amp;preserve-view=true) for your active directory application.
  - Replace APPLICATION-OBJECT-ID with the **objectId (generated while creating app)** for your Active Directory application.
  - Set a value for CREDENTIAL-NAME to reference later.
  - Set the subject. The value of this is defined by GitHub depending on your workflow:
    - Jobs in your GitHub Actions environment: repo:\&lt; Organization/Repository \&gt;:environment:\&lt; Name \&gt;
    - For Jobs not tied to an environment, include the ref path for branch/tag based on the ref path used for triggering the workflow: repo:\&lt; Organization/Repository \&gt;:ref:\&lt; ref path\&gt;. For example, repo:n-username/ node\_express:ref:refs/heads/my-branch or repo:n-username/ node\_express:ref:refs/tags/my-tag.
    - For workflows triggered by a pull request event: repo:\&lt; Organization/Repository \&gt;:pull\_request.

az rest --method POST --uri&#39;https://graph.microsoft.com/beta/applications/\&lt;APPLICATION-OBJECT-ID\&gt;/federatedIdentityCredentials&#39;--body&#39;{&quot;name&quot;:&quot;\&lt;CREDENTIAL-NAME\&gt;&quot;,&quot;issuer&quot;:&quot;https://token.actions.githubusercontent.com&quot;,&quot;subject&quot;:&quot;repo:organization/repository:ref:refs/heads/main&quot;,&quot;description&quot;:&quot;Testing&quot;,&quot;audiences&quot;:[&quot;api://AzureADTokenExchange&quot;]}&#39;

To learn how to create a Create an active directory application, service principal, and federated credentials in Azure portal, see [Connect GitHub and Azure](https://docs.microsoft.com/en-us/azure/developer/github/connect-from-azure#use-the-azure-login-action-with-openid-connect).

## Configure the GitHub secrets

- [OpenID Connect](https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/deploy-github-actions?tabs=openid#tabpanel_2_openid)

You need to provide your application&#39;s  **Client ID** ,  **Tenant ID** , and  **Subscription ID**  to the login action. These values can either be provided directly in the workflow or can be stored in GitHub secrets and referenced in your workflow. Saving the values as GitHub secrets is the more secure option.

1. Open your GitHub repository and go to  **Settings**.
2. Select  **Settings \&gt; Secrets \&gt; New secret**.
3. Create secrets for AZURE\_CLIENT\_ID, AZURE\_TENANT\_ID, and AZURE\_SUBSCRIPTION\_ID. Use these values from your Active Directory application for your GitHub secrets:

| **GitHub Secret** | **Active Directory Application** |
| --- | --- |
| AZURE\_CLIENT\_ID | Application (client) ID |
| --- | --- |
| AZURE\_TENANT\_ID | Directory (tenant) ID |
| AZURE\_SUBSCRIPTION\_ID | Subscription ID |

4. Save each secret by selecting  **Add secret**.

## Add Resource Manager template

Add a Resource Manager template to your GitHub repository. This template creates a storage account.

https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/quickstarts/microsoft.storage/storage-account-create/azuredeploy.json

You can put the file anywhere in the repository. The workflow sample in the next section assumes the template file is named  **azuredeploy.json** , and it is stored at the root of your repository.

## Create workflow

The workflow file must be stored in the  **.github/workflows**  folder at the root of your repository. The workflow file extension can be either  **.yml**  or  **.yaml**.

1. From your GitHub repository, select  **Actions**  from the top menu.
2. Select  **New workflow**.
3. Select  **set up a workflow yourself**.
4. Rename the workflow file if you prefer a different name other than  **main.yml**. For example:  **deployStorageAccount.yml**.
5. Replace the content of the yml file with the following:

- [OpenID Connect](https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/deploy-github-actions?tabs=openid#tabpanel_3_openid)

ymlCopy

on:[push]

name:AzureARM

jobs:

build-and-deploy:

runs-on:ubuntu-latest

steps:

# Checkout code

- uses:actions/checkout@main

# Log into Azure

- uses:azure/login@v1

with:

client-id:${{secrets.AZURE\_CLIENT\_ID}}

tenant-id:${{secrets.AZURE\_TENANT\_ID}}

subscription-id:${{secrets.AZURE\_SUBSCRIPTION\_ID}}

# Deploy ARM template

- name:RunARMdeploy

uses:azure/arm-deploy@v1

with:

subscriptionId:${{secrets.AZURE\_SUBSCRIPTION}}

resourceGroupName:${{secrets.AZURE\_RG}}

template:./azuredeploy.json

parameters:storageAccountType=Standard\_LRS

# output containerName variable from template

- run:echo${{steps.deploy.outputs.containerName}}

1. Go to GitHub home page https://github.com

![](RackMultipart20220627-1-dul320_html_11099931db48f968.png)

1. Then go to Create a new repository

![](RackMultipart20220627-1-dul320_html_cff8410a242571a7.png)

Select Public this after creating

 ![Shape1](RackMultipart20220627-1-dul320_html_4d14c074e08c317a.gif)

![](RackMultipart20220627-1-dul320_html_5e3ee4064f4ee18d.png)

Go to [.github/workflows](https://github.com/somagutta/test/tree/main/.github/workflows) in that file select you select which every you like window

![Shape2](RackMultipart20220627-1-dul320_html_f91245ddccec356e.gif) ![](RackMultipart20220627-1-dul320_html_da4da5b106f63135.png)

Their will declare the yaml file

![Shape3](RackMultipart20220627-1-dul320_html_2942a5c534c62408.gif) ![](RackMultipart20220627-1-dul320_html_8ec79ffbe94cd72e.png)

Their will declare the parameters

![Shape4](RackMultipart20220627-1-dul320_html_eb833ee03836efad.gif) ![](RackMultipart20220627-1-dul320_html_eec6f90fa1d04676.png)

1. Then you can go to select ACTION in that you can create new workflow

![](RackMultipart20220627-1-dul320_html_199ba073ce04cbb.png)

1. Here you can select simple workflow

![](RackMultipart20220627-1-dul320_html_d2d3bee90d346782.png)

1. Create one CI name called CI DEMO then click on START COMMIT

![](RackMultipart20220627-1-dul320_html_97118d3b573b9186.png)

1. Then on click Run workflow

![](RackMultipart20220627-1-dul320_html_1569efe44fda1e20.png)

1. If we want to edit pipeline go to

![](RackMultipart20220627-1-dul320_html_3d29c04af1f42208.png)

1. Select which one you .github/workflows in that go to main.yml

![Shape5](RackMultipart20220627-1-dul320_html_48b4265a471acc84.gif) ![](RackMultipart20220627-1-dul320_html_9316a9786e2d46.png)

1. In marketplace search ARM deploy

 ![Shape6](RackMultipart20220627-1-dul320_html_1cdf8b8627a550d7.gif)

![](RackMultipart20220627-1-dul320_html_21175611956ea4f4.png)

1. After selecting Deploy Azure Resource Group Template. Go thought that

 ![Shape8](RackMultipart20220627-1-dul320_html_54bcbb895875af20.gif) ![Shape7](RackMultipart20220627-1-dul320_html_1e80dd1c7d0b9f16.gif)

![](RackMultipart20220627-1-dul320_html_f19819f0d81b4740.png)

After copy and pasted file then select start commit

1. Your build will be create

![](RackMultipart20220627-1-dul320_html_b0d5b1481c31a490.png)

1. After that go and check in Azure portal in Resource Group

![Shape9](RackMultipart20220627-1-dul320_html_aa3facb4f3e83fe0.gif) ![](RackMultipart20220627-1-dul320_html_3fd7587fdad3724b.png)
