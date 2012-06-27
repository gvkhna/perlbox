## What is this?

[**perlbox**](https://github.com/gauravk92/perlbox): The lightweight portable perl reproducible virtualized development environment with out of the box declarative automatic CPAN dependency management.

Reliable open source development stack:

- [**CentOS**](http://centos.org) v5.8 x86_64
- [**Perlbrew**](http://perlbrew.pl/)
- [**Perl**](http://www.perl.org/) v5.16.0
- [**App::cpanminus**](http://cpanmin.us/)
- [**Module::CPANfile**](https://github.com/miyagawa/cpanfile)

Built with solid open source technologies:

- [Veewee](https://github.com/jedi4ever/veewee/)

## What do I need?

- [Vagrant](http://vagrantup.com/)
- [VirtualBox](https://www.virtualbox.org/)

## What do I do?

### One elegantly simple command, watch this.

**$** `vagrant up`

##### It's not stuck… just give it a minute!

    [default] Box centos58 was not found. Fetching box from specified URL...
    [vagrant] Downloading with Vagrant::Downloaders::HTTP...
    [vagrant] Downloading box: https://github.com/downloads/gauravk92/perlbox/centos58.box
    [vagrant] Downloading box: http://cloud.github.com/downloads/gauravk92/perlbox/centos58.box
    [vagrant] Extracting box...
    [vagrant] Verifying box...
    [vagrant] Cleaning up downloaded box...
    [default] Importing base box 'centos58'...
    [default] Matching MAC address for NAT networking...
    [default] Clearing any previously set forwarded ports...
    [default] Forwarding ports...
    [default] -- 22 => 2222 (adapter 1)
    [default] Creating shared folders metadata...
    [default] Clearing any previously set network interfaces...
    [default] Booting VM...
    [default] Waiting for VM to boot. This can take a few minutes.
    [default] VM booted and ready for use!
    [default] Mounting shared folders...
    [default] -- v-root: /vagrant
    [default] -- manifests: /tmp/vagrant-puppet/manifests
    [default] Running provisioner: Vagrant::Provisioners::Puppet...
    [default] Running Puppet with /tmp/vagrant-puppet/manifests/default.pp...
    notice: /Stage[main]//Exec[Update Repository Packages]/returns: executed successfully
    notice: /Stage[main]//Group[puppet]/ensure: created
    notice: /Stage[main]/Perlbrew/Exec[Perlbrew Installation]/returns: executed successfully
    notice: /Stage[main]/Perlbrew/Exec[Perlbrew Self Upgrade]/returns: executed successfully
    notice: /Stage[main]/Perlbrew/Exec[Setup Perl Default Version Shell Extension]/returns: executed successfully
    notice: /Stage[main]/Perlbrew/Exec[Setup Perlbrew Shell Extension]/returns: executed successfully
    notice: /Stage[main]/Perlbrew/Exec[Perl Installation]/returns: executed successfully
    notice: /Stage[main]/Perlbrew/Exec[App::cpanminus Installation]/returns: executed successfully
    notice: /Stage[main]/Perlbrew/Exec[App::cpanminus Self Upgrade]/returns: executed successfully
    notice: /Stage[main]/Perlbrew/Exec[App::cpanoutdated Installation]/returns: executed successfully
    notice: /Stage[main]/Perlbrew/Exec[App::cpanoutdated Execution]/returns: executed successfully
    notice: /Stage[main]/Perlbrew/Exec[App::CPAN::Fresh Installation]/returns: executed successfully
    notice: /Stage[main]/Perlbrew/Exec[Module::CPANfile Installation]/returns: executed successfully
    notice: /Stage[main]/Perlbrew/Exec[App::cpanminus Install Dependencies]/returns: Successfully installed Mojolicious-3.0
    notice: /Stage[main]/Perlbrew/Exec[App::cpanminus Install Dependencies]/returns: 1 distribution installed
    notice: /Stage[main]/Perlbrew/Exec[App::cpanminus Install Dependencies]/returns: executed successfully
    
    notice: Finished catalog run in 1672.59 seconds

**$** `echo 'which perl && which cpanm' | vagrant ssh`

    /home/vagrant/perl5/perlbrew/perls/perl-5.16.0/bin/perl
    /home/vagrant/perl5/perlbrew/perls/perl-5.16.0/bin/cpanm

## How can I help?

Pull requests are always welcome.

## Notes

- [Perlbrew installation procedure](http://blog.fox.geek.nz/2010/09/installing-multiple-perls-with.html)
- bootstrap.pl condenses the [veewee custom box build procedure](http://www.ducea.com/2011/08/15/building-vagrant-boxes-with-veewee)
- veewee definitions are included for completeness

## Changelog

### 1.2:
- Stability improvements
- Bug fixes

### 1.1:
- Added [Module::CPANfile](https://github.com/miyagawa/cpanfile) support
- Added Vagrantfile vm_url to [centos58@github/gauravk92](https://github.com/downloads/gauravk92/perlbox/centos58.box)

### 1.0:
- Initial commit