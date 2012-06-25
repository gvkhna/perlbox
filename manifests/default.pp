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

    exec { 'Setup Perl Shell Extension':
        require => Exec['Perlbrew Self Upgrade'],
        command => "echo 'perlbrew switch ${PERL_VERSION}' >> ${HOME}/.bashrc",
        unless => "grep 'perlbrew switch ${PERL_VERSION}' ${HOME}/.bashrc"
    }

    exec { 'Perl Installation':
        require => Exec['Add Perlbrew to PATH'],
        command => "${PERLBREW}/bin/perlbrew install -j 5 ${PERL_NAME}",
        creates => "${PERLBREW}/perls/${PERL_NAME}/bin/perl${PERL_VERSION}",
        timeout => 2500
    }

    exec { 'App::cpanminus Installation':
        require => Exec['Perl Installation'],
        command => "${PERLBREW}/bin/perlbrew install-cpanm",
        creates => "${PERLBREW}/bin/cpanm"
    }

    exec { 'App::cpanminus Local Lib Installation':
        require => Exec['App::cpanminus Installation'],
        provider => 'shell',
        command => "echo '${PERLBREW}/bin/cpanm --self-upgrade' \
                    | ${PERLBREW}/bin/perlbrew use ${PERL_NAME}",
        creates => $CPANM
    }

    exec { 'App::cpanminus Self Upgrade':
        require => Exec['App::cpanminus Local Lib Installation'],
        command => "${CPANM} --self-upgrade"
    }

    exec { 'App::cpanoutdated Installation':
        require => Exec['App::cpanminus Self Upgrade'],
        command => "${CPANM} App::cpanoutdated"
    }

    exec { 'cpan-outdated Execution':
        require => Exec['App::cpanoutdated Installation'],
        command => "${PERLBREW}/perls/${PERL_NAME}/bin/cpan-outdated"
    }

    exec { 'App::CPAN::Fresh Installation':
        require => Exec['cpan-outdated Execution'],
        command => "${CPANM} App::CPAN::Fresh"
    }

    # Install CPAN Modules

    exec { 'Modern::Perl Installation':
        require => Exec['App::cpanminus Self Upgrade'],
        command => "${CPANM} Modern::Perl"
    }

    exec { 'Mojolicious::Lite Installation':
        require => Exec['App::cpanminus Self Upgrade'],
        command => "${CPANM} Mojolicious::Lite"
    }

    exec { 'URI Installation':
        require => Exec['App::cpanminus Self Upgrade'],
        command => "${CPANM} URI"
    }
}

# print all puppet facts (useful for debugging)
file { "/tmp/facts.yaml":
    content => inline_template("<%= scope.to_hash.reject { |k,v| !( k.is_a?(String) && v.is_a?(String) ) }.to_yaml %>"),
}