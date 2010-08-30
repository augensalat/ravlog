package RavLog::Schema::Result::Tag;

use strict;
use warnings;

use parent 'DBIx::Class::Core';

__PACKAGE__->load_components('PK::Auto');

__PACKAGE__->table('tags');

__PACKAGE__->add_columns(
    tag_id => {
	data_type         => 'integer',
	is_auto_increment => 1,
	is_nullable       => 0,
	size              => 10,
	extra => {
	    unsigned => 1,
	},
    },
    name => {
	data_type     => "character varying",
	is_nullable   => 0,
	default_value => '',
	size          => 255,
    },
);

__PACKAGE__->set_primary_key('tag_id');

__PACKAGE__->add_unique_constraint(tag_unq_name => ['name']);

__PACKAGE__->has_many(
    'tags_articles' => 'RavLog::Schema::Result::TagArticle', 'tag_id'
);

__PACKAGE__->many_to_many('articles' => 'tags_articles', 'article');

1;

