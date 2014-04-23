# Configure autoupdate setup
class autoupdate::setup {
    exec {
        'setup_git_repo' :
            cwd     => '/root',
            creates => '/root/infra-puppet',
            command => 'git clone git://github.com/jenkinsci/infra-puppet.git',
            require => Package['git-core'],
            # In the case of a new machine, we probably already have this
            unless  => 'test -d /root/infra-puppet/.git',
            path    => ['/usr/bin', '/usr/local/bin'],
    }
}

