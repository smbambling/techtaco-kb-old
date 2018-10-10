# Default Template Header

Overview
--------

One posibility for creating a 'default' header to be added to all templates.

Custom Facter Fact
------------------

Here is an example for a custom fact that just sets text for the header

```ruby
#!/usr/bin/ruby

require "facter"

text = "######################################################################################
#  This file is managed by Pupppet, any manual changes will be OVERWRITTEN in 30min  #
######################################################################################

"

Facter.add("template_header") do
  setcode do
    text
  end
end
```

Usage
----

To use this you only need to add the following line to the beging of your Puppet .erb templates
```ruby
<%= scope['::template_header'] -%>
```

Pro Tip
-------

You can easily add the above ruby code to all files with the following sed
```bash
sed -i "1s/^/<%= scope['::template_header'] -%>\n/" *
```


