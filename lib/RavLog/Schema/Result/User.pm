package RavLog::Schema::Result::User;

use strict;
use warnings;

use parent 'DBIx::Class::Core';

use Gravatar::URL ();

__PACKAGE__->load_components(qw(PK::Auto TimeStamp EncodedColumn));

__PACKAGE__->table('users');

__PACKAGE__->add_columns(
    user_id => {
	data_type         => 'integer',
	is_auto_increment => 1,
	is_nullable       => 0,
	size              => 10,
	extra => {
	    unsigned => 1,
	},
    },
    username => {
	data_type     => 'varchar',
	default_value => '',
	is_nullable   => 0,
	size          => 20
    },
    password => {
	data_type => 'char',
	default_value => undef,
	is_nullable => 1,
	size => 60,
	encode_column => 1,
	encode_class  => 'Crypt::Eksblowfish::Bcrypt',
	encode_check_method => 'check_password',
    },
    website => {
	data_type     => 'varchar',
	is_nullable   => 1,
	size          => 255,
    },
    email => {
	data_type     => 'varchar',
	is_nullable   => 1,
	size          => 255,
    },
    created_at => {
	data_type     => 'datetime',
	set_on_create => 1,
	is_nullable   => 0,
	timezone      => 'UTC',
    },
);

__PACKAGE__->set_primary_key("user_id");

__PACKAGE__->add_unique_constraint(user_unq_username => ['username']);

__PACKAGE__->has_many(
   'articles' => 'RavLog::Schema::Result::Article', 'user_id'
);

=head2 gravatar

  $url = $user->gravatar;
  $url = $user->gravatar(default => 'http://domain.id/default.jpg');

Get URL for the user's gravatar. Any additional paramaters accepted by
the methods of L<Gravatar::URL> besides C<email> can be passed as
arguments.

=cut

sub gravatar {
    my $self = shift;
    my $email = $self->email
	or return undef;

    return Gravatar::URL::gravatar_url(email => $email, @_);
}

1;
