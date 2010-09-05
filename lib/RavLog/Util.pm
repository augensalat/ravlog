package RavLog::Util;

use strict;
use warnings;
use utf8;

use Exporter 'import';

use Text::Password::Pronounceable;

our @EXPORT_OK = qw(
    generate_password
    valid_username
);

=head2 generate_password

  $password = $self->generate_password

Generate a password with L<Text::Password::Pronounceable>.
Accepts two, one or no arguments. Two numeric arguments set the minimum
and maximum length, whereas one numeric argument sets the exact length
of the password. Without arguments the length will be between nine and
twelve characters.

=cut

sub generate_password(;$$) {
    my ($min, $max);

    if (@_) {
	$min = shift || 8;
	$max = shift || $min;
	$max = $min if $max < $min;
    }
    else {
	$min = 9;
	$max = 12;
    }

    return Text::Password::Pronounceable->generate($min, $max);
}

=head2 valid_username

  die "invalid username" unless valid_username $username;

Syntax check a username.

A valid username

=over

=item * is between 2 and 20 bytes long;

=item * is build from latin letters C<A-Z> and C<a-z>, digits C<0-9>,
hyphen C<"-">, dot C<"."> and underscore C<"_">;

=item * contains at least one letter C<A-Z> or C<a-z>.

=back

=cut

sub valid_username($) {
    my $u = shift;

    defined($u) and
    length($u) <= 20 and
    $u =~ /^[0-9A-Za-z\-_.]{2,}$/ and
    $u =~ /[A-Za-z]/;
}

1;

__END__

=head1 AUTHORS

See L<RavLog>.

=head1 LICENSE

This library is free software, you can redistribute it and/or modify it under
the same terms as Perl itself.
