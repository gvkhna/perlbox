$PERL_VERSION='5.16.0'
$USER='vagrant'
$HOME="/home/${USER}"

# This is necessary due to a bug in the puppet CentOS installation
group { 'puppet': ensure => present }

include update
include setup
include perlbrew

class update {
    $UPDATE_ARG='update -y'
    if $operatingsystem == 'Ubuntu' {
        $UPDATE_BIN='/usr/bin/apt-get'
    } else {
        $UPDATE_BIN='/usr/bin/yum'
        # This is necessary to support CentOS 6 coming soon...
        if $osfamily == 'RedHat' and $lsbmajdistrelease == 6 {
            $UPDATE_ARG='distribution-synchronization -y'
        }
    }

    exec { 'Update Repository Packages':
        command => "${UPDATE_BIN} ${UPDATE_ARG}",
        onlyif => "/usr/bin/test -x ${UPDATE_BIN}",
        timeout => 2500
    }

    if $operatingsystem == 'Ubuntu' {
        exec { 'Upgrade Repository Packages':
            require => Exec['Update Repository Packages'],
            command => "${UPDATE_BIN} upgrade -y",
            onlyif => "/usr/bin/test -x ${UPDATE_BIN}",
            timeout => 2500
        }
    }
}

class setup {
    user { $USER: ensure => present }
    group { $USER: ensure => present }

    file { '/home': ensure => directory }

    file { 'Home Directory Validation':
        require => File['/home'],
        ensure => directory,
        path => $HOME,
        owner => $USER,
        group => $USER,
        mode => 700,
    }
}

class perlbrew {
    $PERL_NAME="perl-${PERL_VERSION}"
    $PERLBREW_ROOT="${HOME}/perl5/perlbrew"
    $CPANM="${PERLBREW_ROOT}/perls/${PERL_NAME}/bin/cpanm"
    $PERL="${PERLBREW_ROOT}/perls/${PERL_NAME}/bin/perl"

    Exec {
        path => '/bin:/usr/bin',
        user => $USER,
        group => $USER,
        cwd => $HOME,
        #logoutput => true,
        environment => ["PERLBREW_ROOT=${PERLBREW_ROOT}", "HOME=${HOME}"]
    }

    File {
        owner => $USER,
        group => $USER,
        mode => 644
    }

    package { curl: ensure => latest }

    exec { 'Perlbrew Installation':
        require => Package['curl'],
        command => 'curl -kL http://install.perlbrew.pl | /bin/bash',
        creates => "${PERLBREW_ROOT}/bin/perlbrew"
    }

    exec { 'Perlbrew Initialization':
        require => Exec['Perlbrew Installation'],
        command => "${PERLBREW_ROOT}/bin/perlbrew init",
        creates => "${PERLBREW_ROOT}/etc/bashrc"
    }

    exec { 'Perlbrew Self Upgrade':
        require => Exec['Perlbrew Initialization'],
        command => "${PERLBREW_ROOT}/bin/perlbrew self-upgrade"
    }

    $BASHRC="${HOME}/.bashrc"
    file { $BASHRC: ensure => present }

    exec { 'Setup Perlbrew Shell Extension':
        require => [File[$BASHRC], Exec['Perlbrew Self Upgrade']],
        command => "echo 'source ${PERLBREW_ROOT}/etc/bashrc' >> ${BASHRC}",
        unless => "grep 'source ${PERLBREW_ROOT}/etc/bashrc' ${BASHRC}"
    }

    $PROFILE="${HOME}/.bash_profile"
    file { $PROFILE: ensure => present }

    # Set `vagrant ssh' shell to use this perl by default (turn off for debugging)
    exec { 'Setup Perl Default Version Shell Extension':
        require => [File[$PROFILE], Exec['Perlbrew Self Upgrade']],
        command => "echo 'perlbrew switch ${PERL_VERSION}' >> ${PROFILE}",
        unless => "grep 'perlbrew switch ${PERL_VERSION}' ${PROFILE}"
    }

    exec { 'Perl Installation':
        require => Exec['Perlbrew Self Upgrade'],
        command => "${PERLBREW_ROOT}/bin/perlbrew install -j 4 ${PERL_VERSION}",
        creates => $PERL,
        timeout => 10000
    }

    exec { 'App::cpanminus Installation':
        require => [Package['curl'], Exec['Perl Installation']],
        provider => shell,
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
        command => "${PERLBREW_ROOT}/perls/${PERL_NAME}/bin/cpan-outdated"
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
        provider => shell,
        command => "${CPANM} -q --installdeps /${USER}",
        onlyif => "test -r /${USER}/cpanfile",
        logoutput => true
    }

}

## rebuild virtualbox tools
# sudo /etc/init.d/vboxadd setup
# unless => 'grep 'vboxsf' /proc/modules

# print all puppet facts (useful for debugging)
file { "/tmp/facts.yaml":
    content => inline_template("<%= scope.to_hash.reject { |k,v| \
   !( k.is_a?(String) && v.is_a?(String) ) }.to_yaml %>"),
}