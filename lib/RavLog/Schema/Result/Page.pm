package RavLog::Schema::Result::Page;

use strict;
use warnings;

use parent 'DBIx::Class::Core';

use RavLog::Format;

__PACKAGE__->load_components('PK::Auto');

__PACKAGE__->table('pages');

__PACKAGE__->add_columns(
    page_id => {
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
	is_nullable   => 0,
	default_value => '',
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
    display_sidebar => {
	data_type     => 'smallint',
	default_value => 1,
	is_nullable   => 0,
    },
    display_in_drawer => {
	data_type     => 'smallint',
	default_value => 1,
	is_nullable   => 0,
    }
);

__PACKAGE__->set_primary_key('page_id');

__PACKAGE__->add_unique_constraint(page_unq_name => ['name']);

sub formatted_body {
    my $self = shift;
    my $format = $self->format || 'text';
    return RavLog::Format::format_html($self->body, $format);
}

1;
