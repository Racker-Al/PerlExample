#!/usr/bin/env perl

# Name: src_build.pl
# Desc: build & install freebsd source
# Date: Oct 31, 2013
# Created by ALEJANDRO MARTINEZ

# Modules
use strict;
use warnings;
use File::chdir;
use Time::HiRes qw(gettimeofday);

# Record start time
my $start = gettimeofday();

# Move to '/usr/src'
$CWD = "/usr/src";
printf $CWD;
print "\n";

# build/install sources
my $buildworld = `make -j2 buildworld | grep '>>>'`;
if ( $? == -1 )
{
	printf "buildworld failed: $!\n";
	exit 1;
}

print "buildworld successful\n";

my $buildkernel = `make buildkernel | grep '>>>'`;
if ( $? == -1 )
{
	printf "buildkernel failed: $!\n";
	exit 1;
}

print "buildkernel successful\n";

my  $installkernel = `make installkernel | grep \^kldxref`;
if ( $? == -1 )
{
	printf "buildkernel failed: $!\n";
	exit 1;
}

print "installkernel successful\n";

# Calculate total time
my $fin = gettimeofday();
my $tot_time = ($fin - $start);

printf "Build complete. Total time is %.3f \n", $tot_time;
exit 0;
