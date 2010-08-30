#!/usr/bin/env perl

use strict;
use warnings;

use FindBin;
use lib "$FindBin::Bin/../lib";

use Getopt::Long;
use Pod::Usage;

use RavLog::Schema;
use RavLog::Util::Script qw(load_config printime);

=head1 NAME

ravlog_deploy.pl - Deploy initial database setup

=head1 SYNOPSIS

  ravlog_deploy.pl [options]

  Options:
    --force     overwrite existing database schema
    --help      show brief help message
    --man       show the manpage

=head1 OPTIONS

=over 8

=item B<--force>

Force installation even a database exists. Use with care!

=item B<--help>

Prints a brief help message and exits.

=item B<--man>

Prints the manual page and exits.

=back

=cut

my $Force = 0;
my $Help  = 0;
my $Man   = 0;

GetOptions(
    'force|f' => \$Force,
    'help|h'  => \$Help,
    'man|?'   => \$Man,
);

pod2usage(1) if $Help;
pod2usage(-verbose => 2) if $Man;

my $config = load_config;
my $connect_info = $config->{'Model::DB'}->{connect_info};

printime 'Doing default database setup in ', $connect_info->[0], "\n";

my $schema = RavLog::Schema->connect(@$connect_info)
    or die <<'';
Can't connect to database. Please check instructions in INSTALL.

$schema->deploy({add_drop_table => $Force});

printime "done.\n";

__END__

=head1 DESCRIPTION

ravlog_deploy.pl creates the database schema and initial data.
Settings are read from the C<ravlog_local> config file or, if that
does not exist, form the C<ravlog> config file.

=head1 AUTHOR

See L<RavLog>.

=head1 LICENSE

This library is free software, you can redistribute it and/or modify it under
the same terms as Perl itself.

