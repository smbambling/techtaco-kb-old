##Overview

What is a role ?

A role is a unquie collection (wrapper) of one or more included profiles (technology stacks).

**Breakdown**

- Maps technology to a node
- Nodes get classified with only a **SINGLE** role
    - A **role** similar, yet different, from another role is: a **NEW** **role**.
- Do **NOT** include logic
- ONLY use **includes** for abstracting profiles
- Named according to the nodes purpose (business logic)

##Guidelines

####Naming

Role naming needs to adhear to the following conventions:

- Named according to the nodes purpose (business logic)
- Do NOT include a - (hypen), may include an _ (underscore)
- Do NOT include the puppet environment or environment tier (envtier)
    - (prod, stage, test, dev, si ....)

####Documentation

````
# == Overview:
#
# == Monitoring:
#
# == Notes:
````

Each role manifest should be properly documented detailing the following information

- **Overview**: one-maybe-two sentence summary of what the role manages
- **Monitoring**: Roll-up summary of the monitoring provided by included **profile** classes
- **Notes**: Any additoinal information that provides clarity/suppliments the overview.

####Manifests

**Roles** classes should be a self contained entity and not include or depend upon another **role**.  This provides greater visibility seeing exactly what’s being declared (i.e. all the profiles).

A **role** similar, yet different, from another role is: a **NEW** **role**.

**Roles** should **ONLY** use the ````include```` function and should **ONLY** include **profiles**.  No **Component Classes**, resources or logic should be used.

Example:

````
class role::myblog {
  include profile::wordpress
  include profile::base
}
````
