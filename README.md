## What is this?

[**perlbox**](https://github.com/gauravk92/perlbox): The lightweight portable reproducible perl virtualized development environment with baked-in automatic declarative CPAN dependency management.

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

### One elegantly simple command, watch this

> $ vagrant up

#### WARNING: It's not stuck, just give it a minute!

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
    [default] Fixed port collision for 22 => 2222. Now on port 2201.
    [default] Forwarding ports...
    [default] -- 22 => 2201 (adapter 1)
    [default] Creating shared folders metadata...
    [default] Clearing any previously set network interfaces...
    [default] Booting VM...
    [default] Waiting for VM to boot. This can take a few minutes.
    [default] VM booted and ready for use!
    [default] Mounting shared folders...
    [default] -- v-root: /vagrant
    [default] -- manifests: /tmp/vagrant-puppet/manifests
    [default] Running provisioner: Vagrant::Provisioners::Puppet...
    [default] Running Puppet with /tmp/vagrant-puppet/manifests/perlbox.pp...
    notice: /Stage[main]/Update/Exec[Update Repository Packages]/returns: executed successfully
    notice: /Stage[main]//File[/tmp/facts.yaml]/ensure: defined content as '{md5}050286e0d89fe61e71e461aa645276bb'
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
    notice: /Stage[main]/Perlbrew/Exec[App::cpanminus Install Dependencies]/returns: Successfully installed Mojolicious-3.01
    notice: /Stage[main]/Perlbrew/Exec[App::cpanminus Install Dependencies]/returns: 1 distribution installed
    notice: /Stage[main]/Perlbrew/Exec[App::cpanminus Install Dependencies]/returns: executed successfully

    notice: Finished catalog run in 1944.01 seconds

### Everythings good to go, enjoy.

> $ echo 'which perl && which cpanm && cpanm Mojolicious::Lite' | vagrant ssh

    /home/vagrant/perl5/perlbrew/perls/perl-5.16.0/bin/perl
    /home/vagrant/perl5/perlbrew/perls/perl-5.16.0/bin/cpanm
    Mojolicious::Lite is up to date.

## How can I help?

Pull requests are always welcome.

## Notes

- [Perlbrew installation procedure](http://blog.fox.geek.nz/2010/09/installing-multiple-perls-with.html)
- bootstrap.pl condenses the [veewee custom box build procedure](http://www.ducea.com/2011/08/15/building-vagrant-boxes-with-veewee) and is hosted as a gist [here](https://gist.github.com/3032167)
- veewee definitions are included for completeness [here](https://github.com/downloads/gauravk92/perlbox/definitions.zip)

## Changelog

### 2.0:
- Added [Module::CPANfile](https://github.com/miyagawa/cpanfile) support
- Added Vagrantfile vm_url to [centos58](https://github.com/downloads/gauravk92/perlbox/centos58.box) via github
- Added [permissive BSD license](http://www.gnu.org/licenses/license-list.html#ModifiedBSD)
- Stability improvements
- Bug fixes

### 1.0:
- Initial commit