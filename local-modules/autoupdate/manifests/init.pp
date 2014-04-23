#
#   Auto-update manager for Jenkins puppet scripts
#
#
#   Since we're running a puppetmaster-less set up, we'll configure each node
#   to automatically update itself on a 30 minute interval
class autoupdate {
    include autoupdate::setup
    Class['autoupdate::setup'] -> Class['autoupdate']

    cron {
        'pull puppet updates' :
            ensure      => present,
            command     => '(cd /root/infra-puppet && sh run.sh)',
            user        => 'root',
            minute      => 15;

        # Might as well clean these up at some point
        'clean up old puppet logs' :
            ensure      => present,
            command     => 'rm -f /root/infra-puppet/puppet.*.log',
            user        => 'root',
            hour        => 4,
            minute      => 30,
            weekday     => '*';
    }
}
