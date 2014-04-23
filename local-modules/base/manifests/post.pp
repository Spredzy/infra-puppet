# Class that defines post-base installation
class base::post {
  firewall {
    '999 drop all other requests':
      action => 'drop';
  }

  exec {
    'kill puppet gems' :
      onlyif  => 'gem list | grep ^puppet',
      command => 'gem uninstall -ax puppet facter',
      path    => ['/var/lib/gems/1.8/bin',
                  '/usr/local/bin',
                  '/usr/bin',
                  '/bin'];
  }
}
