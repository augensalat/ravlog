#!/usr/bin/env perl

use strict;
use warnings;

use FindBin;
use lib "$FindBin::Bin/../lib";

use RavLog::Schema;
use RavLog::Util::Script qw(load_config);

=head1 NAME

ravlog_ddl_dir.pl - create SQL schema files

=cut

my $schema_version = $RavLog::Schema::VERSION || '0.1';
my $sqldir = "$FindBin::Bin/../sql/";

my $config = load_config;

my $schema = RavLog::Schema->connect(@{$config->{'Model::DB'}->{connect_info}});

$schema->create_ddl_dir(undef, $schema_version, $sqldir);

__END__

=head1 DESCRIPTION

ravlog_ddl_dir.pl creates an SQL file based on the Schema, for each of
the common open source RDBMSes Mysql, PostgreSQL and SQLite.
Settings are read from the C<ravlog_local> config file or, if that
does not exist, form the C<ravlog> config file.

=head1 AUTHOR

See L<RavLog>.

=head1 LICENSE

This library is free software, you can redistribute it and/or modify it under
the same terms as Perl itself.

