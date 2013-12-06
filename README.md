#[**perlbox**](https://github.com/gauravk92/perlbox):

The Portable Reproducible perl Virtualized Development Environment with Automatic Declarative APT Package and CPAN Module Version Control Dependency Management.

Production stack:

> [Perl](http://www.perl.org/) v5.20.0
>
> [Precise64](https://vagrantcloud.com/hashicorp/precise64) "A standard Ubuntu 12.04 LTS 64-bit box."

Uses these open source projects:

> [Perlbrew](http://perlbrew.pl/)
>
> [App::cpanminus](http://cpanmin.us/)
>
> [Module::CPANfile](https://github.com/miyagawa/cpanfile)
>
> [App::cpanoutdated](http://www.freshports.org/devel/p5-App-cpanoutdated/)

## Built on top of Vagrant

> [Vagrant](http://vagrantup.com/)

## Installation: What do I do?

### Walk away[^readlog]

> Make sure you have installed the hashicorp box

	$ vagrant init hashicorp/precise64

> Make sure you have installed the vbguest plugin if you already haven't

	$ vagrant plugin install vagrant-vbguest

> Clone into the project directory

    git clone https://github.com/gauravk92/perlbox my-perlbox \
    && cd my-perlbox \
    && vagrant up \
    && vagrant ssh -c 'perl /vagrant/helloworld.pl'

[^readlog] See the full output here:

### The box comes with a clean perl installation

    $ vagrant ssh -c 'which perl && which cpanm && cpanm Mojolicious::Lite'
    /home/vagrant/perl5/perlbrew/perls/perl-5.16.0/bin/perl
    /home/vagrant/perl5/perlbrew/perls/perl-5.16.0/bin/cpanm
    Mojolicious::Lite is up to date.

### If you want to add an APT Package

> move the template/pkgfile to the perlbox directory

### If you want to add a CPAN Module

> move the template/cpanfile to the perlbox directory

### If you make any changes to the dependencies

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
- [Repackaging a vagrant box](http://till.klampaeckel.de/blog/archives/155-VirtualBox-Guest-Additions-and-vagrant.html) (with latest guest additions)

## Changelog

### 3.0:
- Switched to Perl v5.20.0 (latest version to-date)
- Removed CentOS in favor of Ubuntu

### 2.0:
- Added [Module::CPANfile](https://github.com/miyagawa/cpanfile) automatic dependency installation
- Added vm_url to [perl.box](https://github.com/downloads/gauravk92/perlbox/perl.box) via github
- Added [permissive BSD license](http://www.gnu.org/licenses/license-list.html#ModifiedBSD)
- Added dependencies.pp for declarative version controlled package management
- Massive refactoring for better maintainability and declarativity
- Massive reduction of assumptions in puppet provisioning script

### 1.0:
- Initial commit