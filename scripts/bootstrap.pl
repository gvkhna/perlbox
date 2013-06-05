#/usr/bin/env perl

$NAME='centos58';
$DISTRO='CentOS-5.8-x86_64-netboot';

unless ( -d 'definitions' ) {
    system("vagrant basebox define '$NAME' '$DISTRO'");
}

unless ( -e "$NAME.box") {
    system("vagrant basebox build '$NAME'");
    system("vagrant basebox validate '$NAME'");
    system("vagrant basebox export '$NAME'");
}

if (system("vagrant box list | grep '$NAME'")) {
    system("vagrant box add '$NAME' $NAME.box");
}