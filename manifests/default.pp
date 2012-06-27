node default {
    $UPDATE_STMT = $lsbmajdistrelease ? {
        5 => 'update -y',
        6 => 'distribution-synchronization -y'
    }

    exec { 'Update Repository Packages':
        command => "/usr/bin/yum ${UPDATE_STMT}",
        timeout => 2500
    }

    user { 'puppet': ensure => 'present' }
    group { 'puppet': ensure => 'present' }
    user { 'vagrant': ensure => 'present' }
    group { 'vagrant': ensure => 'present' }

    include perlbrew
}

$PERL_VERSION='5.16.0'

class perlbrew {
    $USER='vagrant'
    $HOME="/home/${USER}"
    $PERL_NAME="perl-${PERL_VERSION}"
    $PERLBREW="${HOME}/perl5/perlbrew"
    $CPANM="${PERLBREW}/perls/${PERL_NAME}/bin/cpanm"
    $PERL="${PERLBREW}/perls/${PERL_NAME}/bin/perl"

    Exec {
        path => '/bin:/usr/bin',
        user => $USER,
        group => $USER,
        cwd => $HOME,
        #logoutput => true,
        environment => ["PERLBREW_ROOT=${PERLBREW}", "HOME=${HOME}"],
    }

    package { curl: ensure => latest }

    exec { 'Perlbrew Installation':
        require => Package['curl'],
        command => 'curl -kL http://install.perlbrew.pl | /bin/bash',
        creates => "${PERLBREW}/bin/perlbrew"
    }

    exec { 'Perlbrew Initialization':
        require => Exec['Perlbrew Installation'],
        command => "${PERLBREW}/bin/perlbrew init",
        creates => "${PERLBREW}/etc/bashrc"
    }

    exec { 'Perlbrew Self Upgrade':
        require => Exec['Perlbrew Initialization'],
        command => "${PERLBREW}/bin/perlbrew self-upgrade"
    }

    exec { 'Setup Perlbrew Shell Extension':
        require => Exec['Perlbrew Self Upgrade'],
        command => "echo 'source ${PERLBREW}/etc/bashrc' >> ${HOME}/.bashrc",
        unless => "grep 'source ${PERLBREW}/etc/bashrc' ${HOME}/.bashrc"
    }

    # Set `vagrant ssh' to use this perl by default (turn off for debugging)
    exec { 'Setup Perl Default Version Shell Extension':
        require => Exec['Perlbrew Self Upgrade'],
        command => "echo 'perlbrew switch ${PERL_VERSION}' >> ${HOME}/.bash_profile",
        unless => "grep 'perlbrew switch ${PERL_VERSION}' ${HOME}/.bash_profile"
    }

    exec { 'Perl Installation':
        require => Exec['Perlbrew Self Upgrade'],
        command => "${PERLBREW}/bin/perlbrew install -j 4 ${PERL_NAME}",
        creates => $PERL,
        timeout => 10000
    }

    exec { 'App::cpanminus Installation':
        require => [Package['curl'], Exec['Perl Installation']],
        provider => 'shell',
        command => "curl -L http://cpanmin.us | ${PERL} - --self-upgrade",
        creates => $CPANM
    }

    exec { 'App::cpanminus Self Upgrade':
        require => Exec['App::cpanminus Installation'],
        command => "${CPANM} --self-upgrade"
    }

    exec { 'App::cpanoutdated Installation':
        require => Exec['App::cpanminus Self Upgrade'],
        command => "${CPANM} App::cpanoutdated"
    }

    exec { 'App::cpanoutdated Execution':
        require => Exec['App::cpanoutdated Installation'],
        command => "${PERLBREW}/perls/${PERL_NAME}/bin/cpan-outdated"
    }

    exec { 'App::CPAN::Fresh Installation':
        require => Exec['App::cpanoutdated Execution'],
        command => "${CPANM} App::CPAN::Fresh"
    }

    exec { 'Module::CPANfile Installation':
        require => Exec['App::CPAN::Fresh Installation'],
        command => "${CPANM} Module::CPANfile"
    }

    exec { 'App::cpanminus Install Dependencies':
        require => Exec['Module::CPANfile Installation'],
        provider => 'shell',
        command => "${CPANM} -q --installdeps /${USER}",
        logoutput => true
    }

}

## rebuild virtualbox tools
# sudo /etc/init.d/vboxadd setup
# unless => 'grep 'vboxsf' /proc/modules

## print all puppet facts (useful for debugging)
# file { "/tmp/facts.yaml":
#     content => inline_template("<%= scope.to_hash.reject { |k,v| !( k.is_a?(String) && v.is_a?(String) ) }.to_yaml %>"),
# }