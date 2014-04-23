# Check https
define nagios::server::check-https($ensure = present) {
  nagios_service {
    "https check ${name}" :
      ensure              => $ensure,
      target              => "${nagios::server::jenkins_cfg_dir}/http_${name}_service.cfg",
      notify              => [
        Service['nagios'],
        Class['nagios::server::permissions']
      ],
      contact_groups      => 'core-admins',
      service_description => 'HTTPs',
      check_command       => 'check_https_4',
      host_name           => "${name}.jenkins-ci.org",
      use                 => 'generic-service',
  }
}
