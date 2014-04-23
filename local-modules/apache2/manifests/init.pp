# Install and start apache2 service (enabled at bot)
class apache2 {
  if $::operatingsystem != 'Ubuntu' {
    err("The apache2 module is not configured for ${::operatingsystem}")
  }
  else {
    package {
      'apache2' :
        ensure => installed,
        alias  => 'apache2';
    }

    service {
      'apache2' :
        ensure     => running,
        require    => Package['apache2'],
        hasstatus  => true,
        hasrestart => true,
        enable     => true;
    }
  }
}
