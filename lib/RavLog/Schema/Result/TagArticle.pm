package RavLog::Schema::Result::TagArticle;

use strict;
use warnings;

use parent 'DBIx::Class::Core';

__PACKAGE__->load_components('PK::Auto');

__PACKAGE__->table('tags_articles');

__PACKAGE__->add_columns(
    tag_article_id => {
	data_type         => 'integer',
	is_auto_increment => 1,
	is_nullable       => 0,
	size              => 10,
	extra => {
	    unsigned => 1,
	},
    },
    tag_id => {
	data_type     => 'integer',
	default_value => '0',
	is_nullable   => 0,
	size          => 10,
	extra => {
	    unsigned => 1,
	},
    },
    article_id => {
	data_type     => 'integer',
	default_value => '0',
	is_nullable   => 0,
	size          => 10,
	extra => {
	    unsigned => 1,
	},
    },
);

__PACKAGE__->set_primary_key('tag_article_id');

__PACKAGE__->add_unique_constraint(tagarticle_unq_tag_article => ['tag_id', 'article_id']);

__PACKAGE__->belongs_to('tag', 'RavLog::Schema::Result::Tag', 'tag_id');
__PACKAGE__->belongs_to('article',  'RavLog::Schema::Result::Article', 'article_id');

1;

