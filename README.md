#[**Perlbox:**](http://gauravk92.github.io/perlbox)

[![Build Status](https://travis-ci.org/gauravk92/perlbox.png)](https://travis-ci.org/gauravk92/perlbox) [![Code Climate](https://codeclimate.com/github/gauravk92/perlbox.png)](https://codeclimate.com/github/gauravk92/perlbox) [![Gem Version](https://badge.fury.io/rb/perlbox.png)](http://badge.fury.io/rb/perlbox)

The lightweight portable reproducible perl virtualized development environment with baked-in CPAN and package automatic declarative version controlled dependency management.

Assembled from these open source projects:

> [Perlbrew](http://perlbrew.pl/)
>
> [App::cpanminus](http://cpanmin.us/)
>
> [Module::CPANfile](https://github.com/miyagawa/cpanfile)
>
> [puppetlabs/puppet](https://github.com/puppetlabs/puppet)

Works nicely with:

> [Vagrant](http://vagrantup.com/)

## What do I need?

> [Perlbox](https://rubygems.org/gems/perlbox)

## What do I do?

### One elegantly simple command, watch this

    $ vagrant up

### The box is setup with a clean perl installation, everythings good to go, enjoy.

    $ vagrant ssh -c 'which perl && which cpanm && cpanm Mojolicious::Lite'
    /home/vagrant/perl5/perlbrew/perls/perl-5.16.0/bin/perl
    /home/vagrant/perl5/perlbrew/perls/perl-5.16.0/bin/cpanm
    Mojolicious::Lite is up to date.

### If you make any changes to the dependencies, simply

    $ vagrant provision

## USAGE - Modules installation

Perlbox supports `cpanfile` in the root of the project directory

    Imager::PNG
    Imager::JPEG

## USAGE - Package installation

Use `pkgfile` in the root of the project directory

    libpng-dev
    libjpeg-dev


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