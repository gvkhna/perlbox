## What is this?

**perlbox**: A ready to fly perl [reproducible virtualized development environment](http://vagrantup.com/) with out of the box [declarative dependency management](https://github.com/miyagawa/cpanfile).

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

## How can I help?

Pull requests are always welcome.

## Notes

- [Perlbrew installation procedure](http://blog.fox.geek.nz/2010/09/installing-multiple-perls-with.html)
- bootstrap.pl condenses [the veewee build procedure](http://www.ducea.com/2011/08/15/building-vagrant-boxes-with-veewee/)
- veewee definitions are included for completeness

## Changelog

### 1.1:
- Added [Module::CPANfile](https://github.com/miyagawa/cpanfile) support

### 1.0:
- Initial commit