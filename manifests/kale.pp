#
#   Root manifest to be run on kale
#
# Not sure what the hostname on the machine is just yet
node default {
    include base

    include ci-ssh-slave

    package {
      # Needed to build librarian-puppet, which is technically needed to
      # bootstrap the host, but we'll keep this dependency here to express that
      # this is a dependency
      'ruby-devel' :
        ensure  => present,
        require => Package['gcc'];

      'gcc' :
        ensure => present;
    }
}

Exec {
    path => [ '/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/' ]
}
