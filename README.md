## What is this?

**perlbox**: The lightweight portable perl reproducible virtualized development environment with out of the box declarative automatic CPAN dependency management.

Reliable open source stack:
- [CentOS v5.8](http://centos.org)
- [Perlbrew](http://perlbrew.pl/)
- [Perl v5.16.0](http://www.perl.org/)
- [App::cpanminus](http://cpanmin.us/)
- [Module::CPANfile](https://github.com/miyagawa/cpanfile)

## What do I need?

- [Vagrant](http://vagrantup.com/)
- [Veewee (optional)](https://github.com/jedi4ever/veewee/)

## What do I do?

`vagrant up`

#### Seriously…thats it, watch.

    [default] Box centos58 was not found. Fetching box from specified URL...
    [vagrant] Downloading with Vagrant::Downloaders::HTTP...
    [vagrant] Downloading box: https://github.com/downloads/gauravk92/perlbox/centos58.box
    [vagrant] Downloading box: http://cloud.github.com/downloads/gauravk92/perlbox/centos58.box
    [vagrant] Extracting box...
    [vagrant] Verifying box...
    [vagrant] Cleaning up downloaded box...

## How can I help?

Pull requests are always welcome.

## Notes

- [Perlbrew installation procedure](http://blog.fox.geek.nz/2010/09/installing-multiple-perls-with.html)
- bootstrap.pl condenses [the veewee build procedure](http://www.ducea.com/2011/08/15/building-vagrant-boxes-with-veewee/)
- veewee definitions are included for completeness

## Changelog

### 1.1:
- Added [Module::CPANfile](https://github.com/miyagawa/cpanfile) support
- Added vagrant fallback url to vm box

### 1.0:
- Initial commit