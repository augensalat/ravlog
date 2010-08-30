package RavLog::Schema::Result::Config;

use strict;
use warnings;

use parent 'DBIx::Class::Core';

__PACKAGE__->table('config');

__PACKAGE__->add_columns(
    name => {
	data_type     => 'varchar',
	is_nullable   => 0,
	default_value => '',
        size          => 60,
    },
    value => {
	data_type     => 'varchar',
	is_nullable   => 0,
	default_value => '',
        size          => 255,
    },
    description => {
	data_type     => 'varchar',
	is_nullable   => 1,
	size          => 255,
    },
);

__PACKAGE__->set_primary_key('name');

1;

