# Copyright (c) 2012, Gaurav Khanna <gauravk92@gmail.com>
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#     * Redistributions of source code must retain the above copyright
#       notice, this list of conditions and the following disclaimer.
#     * Redistributions in binary form must reproduce the above copyright
#       notice, this list of conditions and the following disclaimer in the
#       documentation and/or other materials provided with the distribution.
#     * Neither the name of the author nor the
#       names of its contributors may be used to endorse or promote products
#       derived from this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
# ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL <COPYRIGHT HOLDER> BE LIABLE FOR ANY
# DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
# (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
# LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
# ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
# SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.


$PERL_VERSION = '5.16.0' # Needs to be moved to hiera

if $operatingsystem == 'amazon' {
    $USER = 'ec2-user'
} else {
    $USER = 'vagrant'
}

$USER_HOME = "/home/${USER}" # Hate that this is a variable

## This is necessary due to a bug in the puppet package for CentOS
group { 'puppet': ensure => present }

case $operatingsystem {
    centos, amazon, redhat: { include redhat }
    debian, ubuntu: { include debian }
    default: { fail("Unrecognized operating system for perlbox") }
}

Exec {
    logoutput => true
}

# Depreciated: import 'dependencies.pp'

# HACKY: include guest_additions
# CRUFTY: include user_setup
include perlbrew

class redhat {
    $PKG_MGR = '/usr/bin/yum'

    $CMD = $operatingsystemrelease ? {
        /^6/ => 'distribution-synchronization',
        default => 'update'
    }

    exec { 'Upgrade Repository Packages':
        command => "${PKG_MGR} ${CMD} -y",
        onlyif => "/usr/bin/test -x ${PKG_MGR}",
        timeout => 2500
    }

    exec { 'Install Package Dependencies':
        command => "${PKG_MGR} install -y $(cat /${USER}/pkgfile)",
        onlyif => "/usr/bin/test -r /${USER}/pkgfile",
        timeout => 2500
    }
}

#############
# NOT USED --
#############
class debian {
    $PKG_MGR = '/usr/bin/apt-get'

    exec { 'Update Repository Packages':
        command => "${PKG_MGR} update -y",
        onlyif => "/usr/bin/test -x ${PKG_MGR}",
        timeout => 2500
    }

    exec { 'Upgrade Repository Packages':
        require => Exec['Update Repository Packages'],
        user => root,
        command => "${PKG_MGR} upgrade -y",
        onlyif => "/usr/bin/test -x ${PKG_MGR}",
        timeout => 2500
    }

    package { 'build-essential': ensure => latest }
}
class guest_additions {
    exec { 'Rebuild Guest Additions':
        user => root,
        command => "/etc/init.d/vboxadd setup",
        #unless => "/sbin/lsmod | grep vboxsf"
    }
}
class user_setup {
    user { $USER:
        ensure => present,
        home => $USER_HOME,
        gid => $USER
    }

    group { $USER: ensure => present }

    file { '/home': ensure => directory }

    file { 'Home Directory Validation':
        require => File['/home'],
        ensure => directory,
        path => $USER_HOME,
        owner => $USER,
        group => $USER,
        mode => 700
    }
}
#############
# NOT USED --
#############

class perlbrew {
    $PERL_NAME = "perl-${PERL_VERSION}"
    $PERLBREW_ROOT = "${USER_HOME}/perl5/perlbrew"
    $CPANM = "${PERLBREW_ROOT}/perls/${PERL_NAME}/bin/cpanm"
    $PERL = "${PERLBREW_ROOT}/perls/${PERL_NAME}/bin/perl"

    Exec {
        path => '/bin:/usr/bin',
        user => $USER,
        group => $USER,
        cwd => $USER_HOME,
        tries => 3,
        environment => ["PERLBREW_ROOT=${PERLBREW_ROOT}", "HOME=${USER_HOME}"]
    }

    File {
        owner => $USER,
        group => $USER,
        mode => 644
    }

    package { curl: ensure => latest }
    package { gcc: ensure => latest }

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
        command => "${PERLBREW_ROOT}/bin/perlbrew self-upgrade",
        tries => 5
    }

    define file_append($text) {
        exec { "echo '${text}' >> ${title}":
            require => Exec['Perlbrew Self Upgrade'],
            unless => "grep '${text}' ${title}",
            onlyif => "/usr/bin/test -w ${title}"
        }
    }

    file_append { "${USER_HOME}/.bashrc": text => "source ${PERLBREW_ROOT}/etc/bashrc" }

    ## Set `vagrant ssh' login to use perlbrew by default (turn off for debugging)
    file_append { "${USER_HOME}/.profile": text => "perlbrew switch ${PERL_VERSION}" }
    file_append { "${USER_HOME}/.bash_profile": text => "perlbrew switch ${PERL_VERSION}" }

    exec { 'Perl Installation':
        require => [Package['gcc'], Exec['Perlbrew Self Upgrade']],
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
        command => "${CPANM} App::CPAN::Fresh",
        timeout => 10000 # Updates may cause timeout error
    }

    exec { 'Module::CPANfile Installation':
        require => Exec['App::CPAN::Fresh Installation'],
        command => "${CPANM} Module::CPANfile"
    }

    exec { 'App::cpanminus Dependencies Installation':
        require => Exec['Module::CPANfile Installation'],
        provider => shell,
        command => "${CPANM} -q --installdeps /${USER}",
        onlyif => "/usr/bin/test -r /${USER}/cpanfile",
        logoutput => true
    }

}

## print all puppet facts (useful for debugging)
file { "/tmp/facts.yaml":
    content => inline_template("<%= scope.to_hash.reject { |k,v| \
    !( k.is_a?(String) && v.is_a?(String) ) }.to_yaml %>")
}