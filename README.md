#[**perlbox**](https://github.com/gauravk92/perlbox):

The lightweight portable reproducible perl virtualized development environment with baked-in CPAN and package automatic declarative version controlled dependency management.

Production stack:

> [Perl](http://www.perl.org/) v5.16.0
>
> [CentOS](http://centos.org) v6.2 x86_64

Assembled from these open source projects:

> [Perlbrew](http://perlbrew.pl/)
>
> [App::cpanminus](http://cpanmin.us/)
>
> [Module::CPANfile](https://github.com/miyagawa/cpanfile)
>
> [Veewee](https://github.com/jedi4ever/veewee/)
>
> [Veewee-templates-updater](https://github.com/mpapis/veewee-templates-updater)

## What do I need?

> [Vagrant](http://vagrantup.com/)

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
	VirtualBox Guest Additions installer
	Removing installed version 4.1.18 of VirtualBox Guest Additions...
	Copying additional installer modules ...
	Installing additional modules ...
	Removing existing VirtualBox non-DKMS kernel modules[  OK  ]
	Building the VirtualBox Guest Additions kernel modules
	Building the main Guest Additions module[  OK  ]
	Building the shared folder support module[  OK  ]
	Building the OpenGL support module[  OK  ]
	Doing non-kernel setup of the Guest Additions[  OK  ]
	You should restart your guest to make sure the new modules are actually used

	Installing the Window System drivers[FAILED]
	(Could not find the X.Org or XFree86 Window System.)
	An error occurred during installation of VirtualBox Guest Additions 4.2.18. Some functionality may not work as intended.
	Restarting VM to apply changes...
	[default] Attempting graceful shutdown of VM...
	[default] Booting VM...
	[default] Waiting for machine to boot. This may take a few minutes...
	[default] Machine booted and ready!
	The SSH connection was unexpectedly closed by the remote end. This
	usually indicates that SSH within the guest machine was unable to
	properly start up. Please boot the VM in GUI mode to check whether
	it is booting properly.

The box just needs a reboot.  Also, the [Vbguest README](https://github.com/dotless-de/vagrant-vbguest#running-as-a-middleware) explains that the Window System drivers error is not something to be concerned about.

Run `vagrant reload` and the box will reboot with the updated guest additions:

	$ vagrant reload
	[default] Attempting graceful shutdown of VM...
	[default] Clearing any previously set forwarded ports...
	[default] Creating shared folders metadata...
	[default] Clearing any previously set network interfaces...
	[default] Preparing network interfaces based on configuration...
	[default] Forwarding ports...
	[default] -- 22 => 2222 (adapter 1)
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

## TODO
- puppet-hiera support
- remove default dependencies.pp

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