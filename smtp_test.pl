#!/usr/bin/env perl

#  Name: time_smtp.pl
#  Desc: connect to SMTP and time
#  Date: Oct 31, 2014
#  Created by ALEJANDRO MARTINEZ

# Modules
use strict;
use warnings;
use Net::SMTP;
use Time::HiRes qw(gettimeofday);

my $start = gettimeofday();

my $smtp = Net::SMTP->new("$ARGV[0]",
            Hello => 'rackspace.com',
            Timeout => 20) or die "Cannot connect to remote smtp: $@";

my $response = $smtp->banner;

my $fin = gettimeofday();

my $tot_time = ($fin - $start);

printf "%s", $response;
printf "%s -->  %.3f seconds to retrieve SMTP response banner.\n", $ARGV[0],  $tot_time;

$smtp->quit;
exit 0;
