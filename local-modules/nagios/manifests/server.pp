#
class nagios::server {
  include apache2
  include nagios::client

  $nagios_dir = '/etc/nagios3'
  $nagios_cfg_dir = "${nagios_dir}/conf.d"
  $jenkins_cfg_dir = "${nagios_cfg_dir}/jenkinsci"

  class {
    'nagios::server::packages'  : ;
    'nagios::server::service'   : ;
    'nagios::server::commands'  : ;
    'nagios::server::hosts'     : ;
    'nagios::server::checks'    : ;
    'nagios::server::permissions': ;
    'nagios::server::contacts'  : ;
  }

  ## nagios-client should always get run first since it will create the nagios
  ## user and set up some basic permissions
  Class['nagios::client'] ->
    Class['nagios::server::packages'] ->
      Class['nagios::server'] ->
        Class['nagios::server::hosts'] ->
          Class['nagios::server::checks'] ->
            Class['nagios::server::contacts'] ->
              Class['nagios::server::permissions']

  # Nuke any "old" jenkins nagios configuration files, basically these
  # configuration files were created in a non-file-per-service manner which
  # makes ensure => absent possible
  exec {
    'nuke-old-nagios-configs' :
      path    => ['/bin', '/usr/bin'],
      command => "rm -rf ${nagios_cfg_dir}/jenkins",
      onlyif  => "test -d ${nagios_cfg_dir}/jenkins";
  }

  file {
    $jenkins_cfg_dir :
      ensure  => directory,
      mode    => '0755',
      require => [
        Group['nagios'],
        Class['nagios::server::packages'],
      ];

    "${nagios_dir}/htpasswd.users" :
      ensure  => present,
      require => [
        Class['nagios::server::packages'],
      ],
      source  => 'puppet:///modules/nagios/nagios.htpasswd';

    "${nagios_dir}/cgi.cfg" :
      ensure  => present,
      require => [
        Class['nagios::server::packages'],
      ],
      source  => 'puppet:///modules/nagios/nagios.cgi.cfg';

    "${nagios_dir}/nagios.cfg" :
      ensure  => present,
      require => [
        Class['nagios::server::packages'],
      ],
      source  => 'puppet:///modules/nagios/nagios.cfg';

    '/var/lib/nagios3' :
      ensure  => directory,
      mode    => '0751',
      require => [
        Class['nagios::server::packages'],
      ];

    '/var/lib/nagios3/rw' :
      ensure  => directory,
      group   => 'www-data',
      mode    => '2710',
      require => [
        Class['nagios::server::packages'],
      ];

    '/etc/apache2/sites-enabled/nagios.jenkins-ci.org' :
      ensure  => present,
      require => [
        Class['apache2'],
        Class['nagios::server::packages'],
      ],
      source  => 'puppet:///modules/nagios/apache2.conf';


    # Nagios Pager Duty integration
    # Thanks pagerduty.com for the gratis account!
    '/usr/local/bin/pagerduty_nagios.pl' :
      ensure => present,
      mode   => '0755',
      source => 'puppet:///modules/nagios/pagerduty_nagios.pl';

    # This file is dropped onto the host directly as it
    # contains the API key
    "${nagios_cfg_dir}/pagerduty_nagios.cfg" :
      ensure  => present,
      require => [
        Class['nagios::server::packages'],
      ],
      notify  => Service['nagios'],
      source  => [
            'puppet:///modules/nagios/pagerduty_nagios.cfg',
            'puppet:///modules/nagios/pagerduty_nagios.cfg.dummy',
          ];
  }

  cron {
    'pagerduty_flush' :
      command => '/usr/local/bin/pagerduty_nagios.pl',
      require => File['/usr/local/bin/pagerduty_nagios.pl'],
      user    => 'nagios';
  }

}

# vim: shiftwidth=2 expandtab tabstop=2
