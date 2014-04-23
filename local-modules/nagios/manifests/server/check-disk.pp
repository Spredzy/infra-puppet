# Check disk
define nagios::server::check-disk($ensure = present) {
  nagios_service {
    "disk check ${name}" :
      ensure              => $ensure,
      target              => "${nagios::server::jenkins_cfg_dir}/${name}_disk.cfg",
      notify              => [
        Service['nagios'],
        Class['nagios::server::permissions']
      ],
      contact_groups      => 'core-admins',
      service_description => 'Disk availability',
      check_command       => 'check_disk_by_ssh!1500!750',  # Unit is MB (otherwise use 10%, etc)
      host_name           => "${name}.jenkins-ci.org",
      use                 => 'generic-service',
  }
}
