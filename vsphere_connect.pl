
#!/usr/bin/env perl -l

#  License: BSD
#  Name: vsphere.pl
#  Desc: connect to vsphere host
#  Date: Oct 31, 2014
#  Created by ALEJANDRO MARTINEZ

# Modules
use strict;

# Global variables
my $dc = lc($ARGV[0]);
my $user = $ARGV[1];

my $endpoint = '';
my $size = "1280x1024";
my $domain = qw(INTENSIVE);
my @endpoint = qw(dfw hkg1 iad lon ord1);

# Verify arguments, die if invalid
if (! defined $user) {
	print "Please provide a datacenter short name and user name.";
	print "Available Case-Insensitve Options -> DFW HKG1 IAD LON ORD1";
	die "Format -> ./vsphere.pl dfw user\n";
}

# Set destination via case-insensitive matching
foreach (@endpoint) {
	if ($dc eq $_) {
		$endpoint = ($dc .= '.vts.rackspace.com');
	}
}

# Verify endpoint, die if invalid
if ($endpoint eq '') {
	print "Connecting to $ARGV[0] ....";
	die "You have entered an invalid destination: $dc\n";
}

# Make the connection
print "rdesktop -d $domain -u $user -p -g $size $endpoint";

die "$!\n";
