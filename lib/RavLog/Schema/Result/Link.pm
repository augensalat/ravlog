package RavLog::Schema::Result::Link;

use strict;
use warnings;

use parent 'DBIx::Class::Core';

__PACKAGE__->load_components('PK::Auto');

__PACKAGE__->table('links');

__PACKAGE__->add_columns(
    link_id => {
       data_type         => 'integer',
       is_auto_increment => 1,
       default_value     => undef,
       is_nullable       => 0,
    },
    url => {
	data_type     => 'varchar',
	default_value => '',
	is_nullable   => 0,
	size          => 255,
    },
    name => {
	data_type     => 'varchar',
	is_nullable   => 1,
	size          => 255,
    },
    description => {
	data_type     => 'varchar',
	is_nullable   => 1,
	size          => 255,
    },
);

__PACKAGE__->set_primary_key("link_id");

1;

