## What is this?

[**perlbox**](https://github.com/gauravk92/perlbox): The lightweight portable reproducible perl virtualized development environment with baked-in CPAN and package automatic declarative version controlled dependency management.

Reliable open source development stack:

- [**CentOS**](http://centos.org) v6.2 x86_64
- [**Perlbrew**](http://perlbrew.pl/)
- [**Perl**](http://www.perl.org/) v5.16.0
- [**App::cpanminus**](http://cpanmin.us/)
- [**Module::CPANfile**](https://github.com/miyagawa/cpanfile)

Built using open source tools:

- [Veewee](https://github.com/jedi4ever/veewee/)
- [Veewee-templates-updater](https://github.com/mpapis/veewee-templates-updater)

## What do I need?

- [Vagrant](http://vagrantup.com/)

## What do I do?

### One elegantly simple command, watch this

    $ vagrant up

### The box comes with a clean perl installation, everythings good to go, enjoy.

    $ vagrant ssh -c 'which perl && which cpanm && cpanm Mojolicious::Lite'
    /home/vagrant/perl5/perlbrew/perls/perl-5.16.0/bin/perl
    /home/vagrant/perl5/perlbrew/perls/perl-5.16.0/bin/cpanm
    Mojolicious::Lite is up to date.

### If you make any changes to the dependencies, simply

    $ vagrant provision

## How can I help?

Pull requests are always welcome.

## Notes

- [Perlbrew installation procedure](http://blog.fox.geek.nz/2010/09/installing-multiple-perls-with.html)
- bootstrap.pl condenses the [veewee custom box build procedure](http://www.ducea.com/2011/08/15/building-vagrant-boxes-with-veewee) and is hosted as a [gist](https://gist.github.com/3032167)
- veewee definitions are included for [completeness](https://github.com/gauravk92/perlbox/downloads)
- Ubuntu and centos58 are not on by default but should work
- [Repackaging a vagrant box](http://till.klampaeckel.de/blog/archives/155-VirtualBox-Guest-Additions-and-vagrant.html) (with latest guest additions)
- Fixed mount '/vagrant' bug by rebuilding VirtualBox guest additions via bootstrap.pl

## TODO
- puppet-hiera support
- remove default dependencies.pp
- remove

## Changelog

### 2.0:
- Added [Module::CPANfile](https://github.com/miyagawa/cpanfile) automatic dependency installation
- Added vm_url to [perl.box](https://github.com/downloads/gauravk92/perlbox/perl.box) via github
- Added [permissive BSD license](http://www.gnu.org/licenses/license-list.html#ModifiedBSD)
- Added dependencies.pp for declarative version controlled package management
- Added prebuilt clean perl installation for significantly faster setup
- Massive refactoring for better maintainability and declarativity
- Massive reduction of assumptions in puppet provisioning script

### 1.0:
- Initial commit