# Basic Nagios Host
define nagios::server::basic-host($full_name, $os = 'ubuntu', $ensure ='present') {
  if ($os == 'ubuntu') {
    $disk_status = $ensure
  }
  else {
    $disk_status = 'absent'
  }

  nagios::server::check-disk {
    $name :
      ensure => $disk_status;
  }

  nagios_host {
    $full_name :
      ensure         => $ensure,
      alias          => $name,
      contact_groups => 'core-admins',
      check_command  => 'check_ssh_4',
      target         => "${nagios::server::jenkins_cfg_dir}/${name}_host.cfg",
      notify         => [
        Service['nagios'],
        Class['nagios::server::permissions']
      ],
      use            => 'generic-host';
  }

  nagios_hostextinfo {
    $full_name:
      ensure          => $ensure,
      notify          => [
        Service['nagios'],
        Class['nagios::server::permissions']
      ],
      icon_image_alt  => $os,
      icon_image      => "base/${os}.png",
      statusmap_image => "base/${os}.gd2",
      target          => "${nagios::server::jenkins_cfg_dir}/${name}_hostextinfo.cfg",
  }

  # Disable ping checks for kale. It has unmanaged iptable rules that
  # drop all inbound ICMP traffic. I'd rather fix those iptable rules once
  # kale is more properly managed by puppet
  if ($name == 'kale') {
    $ping_status = 'absent'
  }
  else {
    $ping_status = $ensure
  }

  nagios_service {
    "check_ping_${name}":
      ensure                => $ping_status,
      target                => "${nagios::server::jenkins_cfg_dir}/${name}_check_ping_service.cfg",
      notify                => [
        Service['nagios'],
        Class['nagios::server::permissions']
      ],
      contact_groups        => 'core-admins',
      service_descriptionx  => 'Ping',
      check_command         => 'check-host-alive',
      host_name             => $full_name,
      notification_interval => 5,
      use                   => 'generic-service';

    "check_ssh_${name}":
      ensure                => $ensure,
      target                => "${nagios::server::jenkins_cfg_dir}/${name}_check_ssh_service.cfg",
      notify                => [
        Service['nagios'],
        Class['nagios::server::permissions']
      ],
      contact_groups        => 'core-admins',
      service_description   => 'SSH',
      check_command         => 'check_ssh_4',
      host_name             => $full_name,
      notification_interval => 5,
      use                   => 'generic-service';
  }

  if ($os == 'ubuntu') {
    $puppet_ensure = $ensure
  }
  else {
    $puppet_ensure = 'absent'
  }
  nagios_service {
    "check_puppet_run_${name}" :
      ensure                => $puppet_ensure,
      target                => "${nagios::server::jenkins_cfg_dir}/${name}_check_puppet_run_service.cfg",
      notify                => [
        Service['nagios'],
        Class['nagios::server::permissions']
      ],
      contact_groups        => 'core-admins',
      service_description   => 'Puppet',
      check_command         => 'check_puppet_run_by_ssh',
      host_name             => $full_name,
      notification_interval => 5,
      use                   => 'generic-service';
  }
}
