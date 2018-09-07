# (Puppet) Environments, (Hiera) Environments, (Application/Network) Environments OH MY!

## Overview

Environments is an easily and extremely overloaded term often used when explaining/with Puppet, Hiera, Deployment/Development "Application" (Internal) and Networks. Below is a clarification reclassification of the terms used to help provided a better understanding of what an "environment" really is within each definition.

## Puppet Environments

Puppet environments come in one of two flavors, [directory environments](https://docs.puppetlabs.com/puppet/latest/reference/environments_configuring.html) or [config file environments](https://docs.puppetlabs.com/puppet/latest/reference/environments_classic.html)

> Directory environments are easier to use and will eventually replace config file environments completely.

#### What are they ?

An isolated group of Puppet agent nodes, each environment is served with a completley different [main manifests](https://docs.puppetlabs.com/puppet/latest/reference/dirs_manifest.html) and [modulepaths](https://docs.puppetlabs.com/puppet/latest/reference/dirs_modulepath.html)

#### What are they used for ?

Frequently short-term assignments used for testing changes to your Puppet DSL code ( modules ) when your refactoring or adding new functionailty, but don't want to directly push the changes into production. (because your not crazy, right?). Instead pushing the changes to a subset of nodes to test before merging the changes in. 

##Hiera Environments

#### What are they ?

An isolated set hierarchial data sources.  

> Puppet environments and Hiera environments are symbiotic – both tools use the same environment concept and so environment names **MUST** match for the data to be shared (i.e. if you create an environment in Puppet called ‘yellow’, you will need a Hiera environment called ‘yellow’ for that data).

#### What are they used for ?

Testing changes when adding or modifiying hierarchical Hiera specific data, like Puppet environments you don't want to directly push these changes into production, but test on a subset of nodes before merging in the change set.

## Deployment/Development "Appliation" Environments

#### What are they ?

Resources designated to a specific tier/stage in the release process, IE: Development, Integration, Staging, Production.  In genernal each tier consists of groupings of nodes designated to a specific stage in the release process

#### What are they used for ?

Most commonly they are application or deployment gateways, used for the purpose of phased deployments. To provide isolated environments for development, integration testing, and staging of applications/software to ensure the ability to release/install an application/software in a production environment.

## Network Environmnets

#### What are they ?

A logical telecommunications network segment, to seperate devices. Segments often connected to provide connection and communication between various devices. This type of network topology allows for organizational segmentation and often coincides with a VLAN.

#### What are they used for ?

While the extent of a segment depends on the nature of the network and the device or devices used.  This is most commonly used to address issues of scalability, security and network management.

> This also may or may not link with an internal "environment" or tier

## Putting It All Together

In order to help limit the confusion when referencing the term environment within the Puppet infrastructure, we'll designate the the following terms to replace "**environment**"

- Puppet and Hiera have a symbiotic relationship and are main focus of the infrastructure thus they shall remain using the term **environment**
 
- Network Environments shall be refered to as **network segments**

- Deployment/Development "Appliation" Environments shall be refered to as **tiers**

## Terminology

## References

[Puppet - About Environments](https://docs.puppetlabs.com/puppet/latest/reference/environments.html)

[Traditional Development/Integration/Staging/Production Practice for Software Development](http://dltj.org/article/software-development-practice/)

