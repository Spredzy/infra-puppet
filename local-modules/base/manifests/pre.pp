# Class that define pre-base operations
class base::pre {
  # It's generally useful to make sure our package meta-data is always up to
  # date prior to running just about everything else
  if ($::operatingsystem == 'Ubuntu') {
    # hack until we upgrade to supported versions of Ubuntu
    $command = 'apt-get update ; touch /tmp/repos-updated'
  }
  elsif ($::operatingsystem =~ /(RedHat|CentOS)/) {
    $command = 'yum makecache && touch /tmp/repos-updated'
  }
  else {
    err('Unsupported platform!')
  }

  exec {
    'pre-update packages' :
      command => $command,
      unless  => 'test -f /tmp/repos-updated';
  }
}
