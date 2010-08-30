package RavLog::Schema;

use Moose;
use DateTime;

extends 'DBIx::Class::Schema';

=head1 NAME

RavLog::Schema -- DBIC Schema Class for RavLog

=head1 DESCRIPTION

This is L<schema class|DBIx::Class::Schema> of the RavLog database.

C<RavLog::Schema> inherits from L<DBIx::Class::Schema|DBIx::Class::Schema>
and adds a few methods.

=cut

__PACKAGE__->mk_group_accessors(
    simple => qw(
	_esc_char
    )
);

__PACKAGE__->load_namespaces;

=head1 METHODS

=head2 now

  $schema->resultset('Book')->search({
    written_on => $schema->now,
  });

Get current datetimestamp formatted for the current db engine.
  
=cut

sub now {
    $_[0]->storage->datetime_parser->format_datetime(DateTime->now);
}

=head2 esc_char

  say $schema->esc_char;

A read-only accessor that returns the character used to mask special
characters, namely C<%> and C<_> (C<'> already get masked by the
L<DBI|DBI> layer).

=cut

sub esc_char {
    my $self = $_[0];
    my $esc_char;

    $esc_char = $self->_esc_char
	and return $esc_char;

    return $self->_esc_char(eval {$self->storage->dbh->get_info(14)} || '\\');
}

=head2 deploy

A wrapper for L<DBIx::Class::Schema::deploy|DBIx::Class::Schema/deploy>
to do the default setup.

=cut

after deploy => sub {
    my $schema = shift;
    my $username = 'admin';
    my $hostname = qx(hostname -f 2>/dev/null) || 'localhost';

    $hostname =~ s/\r?\n//;

    $schema->resultset('Config')->create({
	name => 'front page',
	value => 'blog',
	description => 'which page to display as front page',
    });

    my $user = $schema->resultset('User')->new({
	username => 'test',
	email => $username . '@' . $hostname,
    });

    $user->password('pass_for_test');
    $user->insert;

    $user->articles->create({
	subject => 'test test',
	body => 'alkdjajas asdflkasd lajsdflj',
    });

};

__PACKAGE__->meta->make_immutable;

__END__

=head1 AUTHORS

See L<RavLog>.

=head1 LICENSE

This library is free software, you can redistribute it and/or modify it under
the same terms as Perl itself.
