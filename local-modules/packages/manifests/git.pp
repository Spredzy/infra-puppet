# Git Package
class packages::git {
    if ($::operatingsystem =~ /(RedHat|CentOS)/) {
        package {
            'git' :
                ensure => present,
                alias  => 'git-core';
        }
    }
    else {
        package {
            'git-core' :
                ensure => present;
        }
    }
}
