package RavLog::Schema::Result::Comment;

use strict;
use warnings;

use parent 'DBIx::Class::Core';

use RavLog::Format;

__PACKAGE__->load_components(qw(PK::Auto TimeStamp));

__PACKAGE__->table('comments');

__PACKAGE__->add_columns(
    comment_id => {
	data_type         => 'integer',
	is_auto_increment => 1,
	is_nullable       => 0,
	size              => 10,
	extra => {
	    unsigned => 1,
	},
    },
    name => {
	data_type     => 'varchar',
	default_value => undef,
	is_nullable   => 1,
	size          => 255,
    },
    email => {
	data_type     => 'varchar',
	default_value => undef,
	is_nullable   => 1,
	size          => 255,
    },
    url => {
	data_type     => 'varchar',
	is_nullable   => 1,
	size          => 255,
    },
    body => {
	data_type     => 'text',
	is_nullable   => 1,
    },
    format => {
	data_type     => 'varchar',
	is_nullable   => 0,
	size          => 12,
	default_value => 'text',
    },
    remote_ip => {
	data_type     => 'varchar',
	is_nullable   => 1,
	size          => 40,
    },
    created_at => {
	data_type     => 'datetime',
	set_on_create => 1,
	is_nullable   => 0,
	timezone      => 'UTC',
    },
    article_id => {
	data_type => 'integer',
	default_value => '0',
	is_nullable => 0,
	size => 10,
	extra => {
	    unsigned => 1,
	},
    },
    user_id => {
	data_type => "integer",
	default_value => undef,
	is_nullable => 1,
	size => 10,
	extra => {
	    unsigned => 1,
	},
    },
);

__PACKAGE__->set_primary_key('comment_id');

__PACKAGE__->belongs_to('article', 'RavLog::Schema::Result::Article', 'article_id');
__PACKAGE__->belongs_to('user', 'RavLog::Schema::Result::User', 'user_id');

sub formatted_body {
    my $self = shift;
    my $format = $self->format || 'text';
    return RavLog::Format::format_html($self->body, $format);
}

1;

