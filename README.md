#[**perlbox**](https://github.com/gauravk92/perlbox):

[![Build Status](https://travis-ci.org/gauravk92/perlbox.png)](https://travis-ci.org/gauravk92/perlbox) [![Code Climate](https://codeclimate.com/github/gauravk92/perlbox.png)](https://codeclimate.com/github/gauravk92/perlbox) [![Gem Version](https://badge.fury.io/rb/perlbox.png)](http://badge.fury.io/rb/perlbox)

The lightweight portable reproducible perl virtualized development environment with baked-in CPAN and package automatic declarative version controlled dependency management.

Assembled from these open source projects:

> [Perlbrew](http://perlbrew.pl/)
>
> [App::cpanminus](http://cpanmin.us/)
>
> [Module::CPANfile](https://github.com/miyagawa/cpanfile)

Works nicely with:

> [Vagrant](http://vagrantup.com/)

## What do I need?

> [Perlbox](http://rubygems.org/perlbox/)

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

## VirtualBox guest additions version problems

The perlbox base box referenced in the Vagrantfile was built for VirtualBox 4.1.x.  You may be running VirtualBox 4.2.x or newer.  You can use the [Vbguest plugin](https://github.com/dotless-de/vagrant-vbguest) to easily update the VirtualBox guest additions to match.  This [blog post](http://kvz.io/blog/2013/01/16/vagrant-tip-keep-virtualbox-guest-additions-in-sync/) shows you how to use it.

Install the plugin:

	$ vagrant plugin install vagrant-vbguest

Then while Vagrant is booting the box, you may see something like the following:

	[default] Booting VM...
	GuestAdditions versions on your host (4.2.18) and guest (4.1.18) do not match.
	...

Vbguest will proceed to update the guest additions.

Then you may see:

	...
	An error occurred during installation of VirtualBox Guest Additions 4.2.18. Some functionality may not work as intended.
	...

The box just needs a reboot.  Also, the [Vbguest README](https://github.com/dotless-de/vagrant-vbguest#running-as-a-middleware) explains that the Window System drivers error is not something to be concerned about.

Run `vagrant reload` and the box will reboot with the updated guest additions:

	$ vagrant reload
	...
	[default] Booting VM...
	GuestAdditions 4.2.18 running --- OK.
	...

Then you can run `vagrant provision` to provision the box as normal.


## How can I help?

Pull requests are always welcome.

## Notes

- [Perlbrew installation procedure](http://blog.fox.geek.nz/2010/09/installing-multiple-perls-with.html)
- bootstrap.pl condenses the [veewee build procedure](http://www.ducea.com/2011/08/15/building-vagrant-boxes-with-veewee) and is hosted as a [gist](https://gist.github.com/3032167)
- veewee definitions are included for [completeness](https://github.com/gauravk92/perlbox/downloads)
- Ubuntu and centos58 are not on by default but should work
- [Repackaging a vagrant box](http://till.klampaeckel.de/blog/archives/155-VirtualBox-Guest-Additions-and-vagrant.html) (with latest guest additions)
- Fixed mount '/vagrant' bug by rebuilding VirtualBox guest additions
- [automatically test your puppet modules with travis ci](http://bombasticmonkey.com/2012/03/02/automatically-test-your-puppet-modules-with-travis-ci/)

## TODO
- puppet-hiera support
