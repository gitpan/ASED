# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl test.pl'

######################### We start with some black magic to print on failure.

# Change 1..1 below to 1..last_test_to_print .
# (It may become useful if the test is moved to ./t subdirectory.)

BEGIN { $| = 1; print "1..2\n"; }
use Text::ASED;
use Data::Dumper;

######################### End of black magic.

$testno = 1;

my $editor = new Text::ASED;

system( "rm",  "t/tmp" ) if ( -e "t/tmp" );
system( "cp", "t/httpd.conf", "t/tmp" );

$outfile = eval $editor->prep( search => "MaxClients", 
			       replace => "MAXCLIENTS");

if ( $outfile ) {
    print "ok $testno\n";
} else {
    print "not ok $testno\n";
}
$testno++;

$outfile = eval $editor-> edit( infile => "t/tmp", 
				outfile => "/tmp/$$" );

if ( $outfile ) {
    test_maxclient( "/tmp/$$" );
} else {
    print "not ok a$testno\n";
}
unlink "/tmp/$$" ;
$testno++;

sub test_maxclient {
    my $outfile = shift;
    my $diff = `diff t/tmp $outfile`;
    my @lines =  split /\n/, $diff;
    if ( $lines[0] ne "106c106" ) {
	print "not ok b$testno\n";
    } elsif ( $lines[1] ne "< MaxClients 150" ) {
	print "not ok c$testno\n";
    } elsif ( $lines[3] ne "> MAXCLIENTS 150" ) {
	print "not ok d$testno\n";
    } else {
	print "ok $testno\n";
    }
}
