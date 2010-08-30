package RavLog::Schema::Result::Article;

use strict;
use warnings;

use parent 'DBIx::Class::Core';

#use Text::Textile 'textile';
use RavLog::Format;

__PACKAGE__->load_components(qw(PK::Auto TimeStamp));

__PACKAGE__->table('articles');

__PACKAGE__->add_columns(
    article_id => {
	data_type         => 'integer',
	is_auto_increment => 1,
	is_nullable       => 0,
	size              => 10,
	extra => {
	    unsigned => 1,
	},
    },
    subject => {
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
    created_at => {
	data_type     => "datetime",
	set_on_create => 1,
	is_nullable   => 0,
	timezone      => 'UTC',
    },
    updated_at => {
	data_type     => "datetime",
	is_nullable   => 0,
	set_on_create => 1,
	set_on_update => 1,
	timezone      => 'UTC',
    },
    user_id => {
	data_type     => 'integer',
	is_nullable   => 1,
	size          => 10,
	extra => {
	    unsigned => 1,
	},
    },
);

__PACKAGE__->set_primary_key("article_id");
__PACKAGE__->has_many(
   'comments' => 'RavLog::Schema::Result::Comment',
   'article_id'
);

__PACKAGE__->belongs_to(
   'user' => 'RavLog::Schema::Result::User',
   'user_id'
);

__PACKAGE__->has_many(
   'tags_articles' => 'RavLog::Schema::Result::TagArticle',
   'article_id'
);
__PACKAGE__->many_to_many( 'tags' => 'tags_articles', 'tag' );


sub formatted_body {
    my $self = shift;
    my $format = $self->format || 'text';
    return RavLog::Format::format_html($self->body, $format);
}

1;
