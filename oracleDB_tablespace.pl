#!/usr/bin/env perl

#  License: BSD
#  Name: oracleDB_tablespace.pl
#  Desc: Compute and display tablespace 
#  Date: Oct 31, 2013 
#  Created by ALEJANDRO MARTINEZ

use DBI;
use DBD::Oracle qw(:ora_session_modes);
use POSIX; # for ceil rounding function
use strict;

print 'Enter passwd for sys: ';
chomp( my $pw = <STDIN> );

# connect to the database
my $dbh = DBI->connect( 'DBI:Oracle:', 'sys', $pw,
    { RaiseError = > 1, ShowErrorStatement = > 1, AutoCommit = > 0, ora_session_mode = > ORA_SYSDBA }
);

# get the quota information
my $sth = $dbh->prepare(
    q{SELECT USERNAME,TABLESPACE_NAME,BYTES,MAX_BYTES FROM SYS.DBA_TS_QUOTAS
        WHERE TABLESPACE_NAME = 'USERS' or TABLESPACE_NAME = 'TEMP'}
);

$sth->execute;

# bind the results of the query to these variables, later to be stored in %qdata
my ( $user, $tablespace, $bytes_used, $bytes_quota, %qdata );
$sth->bind_columns( \$user, \$tablespace, \$bytes_used, \$bytes_quota );

while ( defined $ sth-> fetch ) {
    $qdata{$user}->{$tablespace} = [ $bytes_used, $bytes_quota ];
    }

$dbh-> disconnect;

# show this information graphically
foreach my $user ( sort keys %qdata ) {
    graph(
        $user,
        $qdata{$user}->{'USERS'}[0], # bytes used
        $qdata{$user}->{'TEMP'}[0],
        $qdata{$user}->{'USERS'}[1], # quota size
        $qdata{$user}->{'TEMP'}[1]
    );
}

# print out nice chart given username, user and temp sizes,
# and usage info
sub graph {
    my ( $user, $user_used, $temp_used, $user_quota, $temp_quota ) = @_;

    # line for user space usage
    if ( $user_quota > 0 ) {
        print ' ' x 15 . '|'
            . 'd' x POSIX::ceil( 49 * ( $user_used / $user_quota ) )
            . ' ' x ( 49 - POSIX::ceil( 49 * ( $user_used / $user_quota ) ) )
            . '|'
    ;

        # percentage used and total M for data space
        printf( "%. 2f", ( $user_used / $user_quota * 100 ) );
        print "%/" . ( $user_quota / 1024 / 1000 ) . "MB\ n";
    }

    #some users do not have user quotas
    else {
        print ' ' x 15 . '|- no user quota' . ( ' ' x 34 ) . "|\ n";
    }

    print $user . '-' x ( 14 - length($user) ) . '-|' . ( ' ' x 49 ) . "|\ n";

    # line for temp space usage
    if ( $temp_quota > 0 ) {
        print ' ' x 15 . '|'
            . 't' x POSIX::ceil( 49 * ( $temp_used / $temp_quota ) )
            . ' ' x ( 49 - POSIX::ceil( 49 * ( $temp_used / $temp_quota ) ) ) . '|';

        # percentage used and total M for temp space
        printf( "%. 2f", ( $temp_used / $temp_quota * 100 ) );
        print "%/" . ( $ temp_quota / 1024 / 1000 ) . "MB\ n"; }

    #some users do not have temp quotas
    else {
        print ' ' x 15 . '|- no temp quota' . ( ' ' x 34 ) . "|\ n";
    }
    print "\ n";
}

exit;
