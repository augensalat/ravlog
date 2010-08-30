#!/usr/bin/env perl

use strict;
use warnings;

use FindBin;
use lib "$FindBin::Bin/../lib";

use RavLog::Schema;
use RavLog::Util::Script qw(load_config);

my $config = load_config;
my $connect_info = $config->{'Model::DB'}->{connect_info};

my $schema = RavLog::Schema->connect(@$connect_info)
    or die <<'';
Can't connect to database. Please check instructions in INSTALL.

my $username = question('Please choose a username:');
my $password = question('Please choose a password:');
my $email    = question('What is your email address?');

my $user = $schema->resultset('User')->new({});
$user->username($username);
$user->password($password);
$user->email($email);
$user->insert();

print "done.\n";

sub question {
    my $what = shift;
    my $input;

    while(1) {
	print $what, ' ';
	$input = <STDIN>;
	chomp $input;
	if ($input =~ / /) {
	    print "\n\nNo spaces allowed in $what\n\n";
	}
	else {
	    last;
	}
    }	

    return $input;
}


