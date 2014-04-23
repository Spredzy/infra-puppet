# Check http
define nagios::server::check-http($ensure = present) {
  nagios_service {
    "http check ${name}" :
      ensure              => $ensure,
      target              => "${nagios::server::jenkins_cfg_dir}/http_${name}_service.cfg",
      notify              => [
        Service['nagios'],
        Class['nagios::server::permissions']
      ],
      contact_groups      => 'core-admins',
      service_description => 'HTTP',
      check_command       => 'check_http_4',
      host_name           => "${name}.jenkins-ci.org",
      use                 => 'generic-service',
  }
}
