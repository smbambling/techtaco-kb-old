# Icinga2 PagerDuty Configuration

The [Icinga Integration Guide](http://www.pagerduty.com/docs/guides/icinga-integration-guide/) is a good basis to start off, with a few gotchas for Icinga2.

1. The format for the notification and command objects needed for Icinga2
1. The Icinga2 env vars need prefixed by "ICINGA_" as the pagerduty_icinga.pl script is looking for them
```bash
while ((my $k, my $v) = each %ENV) {
  next unless $k =~ /^ICINGA_(.*)$/;
  $event{$1} = $v;
}
```

I've submitted/updated the current [Icinga2 Puppet Module](https://github.com/Icinga/puppet-icinga2) with the ability to create all the Icinga2 Object needed to configure PagerDuty integration

```ruby
# Configure PagerDuty Alerting Service
#
# Template Examples:
# http://monitoring-portal.org/wbb/index.php?page=Thread&postID=204321
# https://lists.icinga.org/pipermail/icinga-users/2014-May/008201.html
class icinga2::arin::pagerduty (
  $pagerduty_service_apikey = undef,
) {

  include stdlib

  # Install Perl dependencies
  $pagerduty_dependencies_packages = [ 'perl-libwww-perl', 'perl-Crypt-SSLeay' ]
  ensure_packages ( $pagerduty_dependencies_packages )

  # Install PagerDuty Alerting Script
  file { 'pagerduty_icinga.pl':
    ensure  => file,
    path    => '/usr/local/bin/pagerduty_icinga.pl',
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    content => template('icinga2/pagerduty_icinga.pl.erb'),
  }

  # Create PagerDuty Icinga User
  icinga2::object::user { 'pagerduty':
    display_name => 'PagerDuty Notification User',
    pager        => $pagerduty_service_apikey,
    target_dir   => '/etc/icinga2/objects/users',
    states       => [ 'OK', 'Critical' ],
  }

  ## Configure Cron for Icinga User
  cron { 'icinga pagerduty':
    ensure   => present,
    command  => '/usr/local/bin/pagerduty_icinga.pl flush',
    user     => 'icinga',
    minute   => '*',
    hour     => '*',
    monthday => '*',
    month    => '*',
    weekday  => '*',
  }

  ## Configure Icinga2 PagerDuty Notification Command for Service
  icinga2::object::notificationcommand { 'notify-service-by-pagerduty':
    command            => ['"/usr/local/bin/pagerduty_icinga.pl enqueue --verbose -f pd_nagios_object=service"'],
    template_to_import => 'plugin-notification-command',
    env                => {
      'ICINGA_CONTACTPAGER'     => '"$user.pager$"',
      'ICINGA_NOTIFICATIONTYPE' => '"$notification.type$"',
      'ICINGA_SERVICEDESC'      => '"$service.name$"',
      'ICINGA_HOSTNAME'         => '"$host.name$"',
      'ICINGA_HOSTALIAS'        => '"$host.display_name$"',
      'ICINGA_SERVICESTATE'     => '"$service.state$"',
      'ICINGA_SERVICEOUTPUT'    => '"$service.output$"',
    },
  }

  ## Configure Icinga2 PagerDuty Notification Command for Hosts
  icinga2::object::notificationcommand { 'notify-host-by-pagerduty':
    command            => ['"/usr/local/bin/pagerduty_icinga.pl enqueue --verbose -f pd_nagios_object=host"'],
    template_to_import => 'plugin-notification-command',
    env                => {
      'ICINGA_CONTACTPAGER'     => '"$user.pager$"',
      'ICINGA_NOTIFICATIONTYPE' => '"$notification.type$"',
      'ICINGA_HOSTNAME'         => '"$host.name$"',
      'ICINGA_HOSTALIAS'        => '"$host.display_name$"',
      'ICINGA_HOSTSTATE'        => '"$host.state$"',
      'ICINGA_HOSTOUTPUT'       => '"$host.output$"',
    },
  }

  ## Configure Apply Notification to Hosts
  icinga2::object::apply_notification_to_host { 'pagerduty-host':
    assign_where => 'host.vars.enable_pagerduty == "true"',
    command      => 'notify-host-by-pagerduty',
    users        => [ 'pagerduty' ],
    states       => [ 'Up', 'Down' ],
    types        => [ 'Problem', 'Acknowledgement', 'Recovery', 'Custom' ],
    period       => '24x7',
  }

  ## Configure Apply Notification to Services
  icinga2::object::apply_notification_to_service { 'pagerduty-service':
    assign_where => 'service.vars.enable_pagerduty == "true"',
    command      => 'notify-service-by-pagerduty',
    users        => [ 'pagerduty' ],
    states       => [ 'OK', 'Warning', 'Critical', 'Unknown' ],
    types        => [ 'Problem', 'Acknowledgement', 'Recovery', 'Custom' ],
    period       => '24x7',
  }
}
```
For those who want to configure this manually, below are examples of the objects needed.

Icinga2 Apply Objects
```bash
apply Notification "pagerduty-host" to Host {
    assign where host.vars.enable_pagerduty == "true"
  command = "notify-host-by-pagerduty"
  users = [ "pagerduty" ]
  period = "24x7"
  types = [ Problem, Acknowledgement, Recovery, Custom ]
  states = [ Up, Down ]
}

apply Notification "pagerduty-service" to Service {
    assign where service.vars.enable_pagerduty == "true"
  command = "notify-service-by-pagerduty"
  users = [ "pagerduty" ]
  period = "24x7"
  types = [ Problem, Acknowledgement, Recovery, Custom ]
  states = [ OK, Warning, Critical, Unknown ]
}
```

Icinga2 Notification Command Objects
```ruby
object NotificationCommand "notify-host-by-pagerduty" {
  import "plugin-notification-command"
  command = [ PluginDir + "/usr/local/bin/pagerduty_icinga.pl enqueue --verbose -f pd_nagios_object=host" ]
  env = {
    ICINGA_HOSTSTATE = "$host.state$"
    ICINGA_NOTIFICATIONTYPE = "$notification.type$"
    ICINGA_CONTACTPAGER = "$user.pager$"
    ICINGA_HOSTNAME = "$host.name$"
    ICINGA_HOSTALIAS = "$host.display_name$"
    ICINGA_HOSTOUTPUT = "$host.output$"
  }
}

object NotificationCommand "notify-service-by-pagerduty" {
  import "plugin-notification-command"
  command = [ PluginDir + "/usr/local/bin/pagerduty_icinga.pl enqueue --verbose -f pd_nagios_object=service" ]
  env = {
    ICINGA_SERVICESTATE = "$service.state$"
    ICINGA_NOTIFICATIONTYPE = "$notification.type$"
    ICINGA_CONTACTPAGER = "$user.pager$"
    ICINGA_SERVICEDESC = "$service.name$"
    ICINGA_HOSTNAME = "$host.name$"
    ICINGA_HOSTALIAS = "$host.display_name$"
    ICINGA_SERVICEOUTPUT = "$service.output$"
  }
}
```

Icinga2 User Object
```ruby
object User "pagerduty" {
  display_name = "PagerDuty Notification User"
  pager = "YOURAPIKEYGOESHERE"
  states = [  OK,  Critical, ]
}
```

[gimmick:Disqus](techtacoorg)
