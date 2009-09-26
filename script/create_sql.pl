#!/usr/bin/env perl
use lib './lib';
use RavLog::Schema::DB;
use Data::Dumper;
use Config::Any::Perl;

my $cfg = Config::Any::Perl->load('ravlog.pl');

my $db = RavLog::Schema::DB->connect($cfg->{RavLog}->{connect_info});

#$db->deploy();
$db->create_ddl_dir();

