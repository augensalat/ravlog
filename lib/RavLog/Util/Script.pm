package RavLog::Util::Script;

use strict;
use warnings;

use Exporter 'import';
use FindBin;
use Config::JFDI;

our @EXPORT_OK = qw/
    load_config
    printime
    printimef
/;

=head1 NAME

RavLog::Util::Script - miscellaneous utility functions for scripts

=head1 DESCRIPTION

A collection of miscellaneous utility functions for scripts.

=head1 FUNCTIONS

=cut

=head2 load_config

  load_config
  load_config($path_to_file)

Attempts to load the config file.
By Default it is searched at C<$FindBin::Bin/..>.

=cut

sub load_config (;$) {
    my $loc = shift || "$FindBin::Bin/..";

    return scalar(Config::JFDI->open(name => 'ravlog', path => "$FindBin::Bin/.."));
}

=head2 printime

  printime $hal, ': ', "Something wonderful is about to happen\n";

Print arguments to stdout the way C<print()> does, prepended with the
current timestamp.

=cut

sub printime (@) {
    sub {printf "%04d-%02d-%02d %02d:%02d:%02d", $_[5]+1900, $_[4]+1, @_[3,2,1,0]}->(localtime);
    print ' ', @_;
}

=head2 printime

  printimef "Hal %d: Sorry %s, I'm afraid, I can't do that\n", 9000, 'Dave';

Print arguments to stdout the way C<printf()> does, prepended with the
current timestamp.

=cut

sub printimef (@) {
    sub {printf "%04d-%02d-%02d %02d:%02d:%02d", $_[5]+1900, $_[4]+1, @_[3,2,1,0]}->(localtime),
    print ' ';
    printf @_;
}

1;

__END__

=head1 AUTHOR

See L<RavLog>.

=head1 LICENSE

This library is free software, you can redistribute it and/or modify it under
the same terms as Perl itself.

