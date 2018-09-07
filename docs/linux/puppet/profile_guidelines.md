##Overview

What is a profile ?

A profile is a collection (wrapper) of one or more component modules and/or resources along with any required logic or specific parameter values that wrap a application techonolgy stack.

**Breakdown**

- Technology specific
- May include [resources](https://docs.puppetlabs.com/references/stable/type.html) directly
- May make calls to Hiera for required data (parameters)
    - These calls may be transparent via [automatic parameter lookup](https://docs.puppetlabs.com/hiera/1/puppet.html#automatic-parameter-lookup)
- Include **Component** module classes/resources
- Named according to the technology they manage
    - Do **NOT** include environments in profile names
  
##Guidelines

####Naming

Profile naming needs to adhear to the following conventions:

- Named according to the technology that they manage
- Do NOT include a - (hypen), may include an _ (underscore)
- Do NOT include the puppet environment or environment tier (envtier)
  - (prod, stage, test, dev, si ....)

####Documentation

````
# == Overview:
#
# == Requirements:
#
# == Monitoring:
#
# == Notes:
````

> Inline comments are encouraged where sane, to provide clarity

Each **'top level**' profile manifest should be properly documented detailing the following information

- **Overview**: one-maybe-two sentence summary of what the profile does/problem it solves
- **Requirements**: Anything extra your manifest requires before being applied (bootstraped)
- **Monitoring**: Service Checks that are to be configured on the monitoring server
- **Notes**: Any additoinal information that provides clarity/suppliments the overview.

Each additional **'child/sub**' class or define should include the following information

- **Overview**: one-maybe-two sentence summary of what the class does/problem it solves

####Hierarchy

Each profile should attempt to adhere to the following hierarchy model that follows a branching pattern for any **'child/sub**' classes or defines.

````
profile
 ├──manifests
 |  └──applicationx.pp
 |  └──applicationx
 |     └──sub_class1.pp
 |     └──sub_class.pp
 |     └──monitoring
 |        └──base.pp
 |        └──define1.pp
 |        └──define2.pp
 ├──templates
 |  └──applicationx
 |  |  └──applicationx_file.ini.erb
 |  └──icinga2
 |     └──checkcommands
 |     |  └──check_applicationx.py.erb
 |     └──checkplugins
 |        └──check_applicationx.py.erb
 └──files
     └──applciationx
     |  └──applicationx_file.ini
     └──icinga2
        └──checkcommands
        |  └──check_applicationx.py.erb
        └──checkplugins
          └──check_applicationx.py.erb
````

####Manifests

**'Top level'** manifests will be included in a **role** class to be applied to a node or nodes

Store **'child/sub'** classes or defines within a sub-directory with the same name as the **'top level**' manifest.

Use **'child/sub'** classes or defines with **logic** for a specific identifier such as site, security zone, etc...  This helps to limit the size and complexity of monolithic manifests.  

- Reference these in the **'top level'** manifest.

````
  ## Include Required Sub-Class
  if ($::domain == 'cha.arin.net') or ($::domain == 'core.cha.arin.net') {
    include profile::applicationx::cha
  }
  elsif ($::domain == 'ash.arin.net') or ($::domain == 'core.ash.arin.net') {
    include profile::applicationx::ash
  }
  else {
    notify { 'ApplicationX Sub-Classes Not Loaded':
      withpath => true,
    }
  }
````

Store **'child/sub'** classes or defines related to monitoring within a sub-directory named monitoring under the application sub-directory.  

Define monitoring checksin a class named **base** ````profile::applicationx::monitoring::base````. 

 - Reference puppet defines in the **base** monitoring class.

````
profile::applicationx::monitoring::define1 = { $applicationx_server_names: }
profile::applicationx::monitoring::define2 = { $applicationx_server_names: }
````

####Files/Templates

Store required files or templates referenced within a profile **child/sub'** class or define (excluding monitoring) in a sub-directory with the same name as the **'top level'** manifest.

Store required files or templates referenced within a profile **child/sub'** class or define in a sub-directory with the same name of the monitoring software such as Icinga2.

Store catagory specific (checkcommands, checkplugins) monitoring files or templates in a sub-directory with the catagory name (checkcommands, checkplugins) under the templates/icinga2 directory

