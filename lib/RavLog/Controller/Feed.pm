package RavLog::Controller::Feed;

use strict;
use warnings;
use utf8;

use parent 'Catalyst::Controller';

use XML::Feed;

sub comments : Local {
    my ($self, $c, $subject) = @_;
    my $feed = XML::Feed->new('RSS');
    my @comments;

    $feed->title($c->config->{name} . ' RSS');
    $feed->link($c->uri_for('/'));
    $feed->description($c->config->{name} . ' RSS Feed');

    if (!defined $subject) {
	@comments = $c->model('DB::Comment')->all();
    }
    else {
	@comments =
	    $c->model('DB::Article')
	    ->search({subject => {like => $c->ravlog_url_to_query($subject)}})->first
	    ->comments;
    }

    for my $com (@comments) {
	my $feed_entry = XML::Feed::Entry->new('RSS');

	$feed_entry->title($com->name . "'s comment " . $com->created_at->ymd);
	$feed_entry->link(
	    $c->uri_for_action(
		'/article/view', [$c->ravlog_txt_to_url($com->article->subject)]
	    ) . '#comments'
	);
	$feed_entry->summary($com->formatted_body);
	$feed_entry->issued($com->created_at);
	$feed->add_entry($feed_entry);
    }

    $c->response->content_type('application/rss+xml');
    $c->response->body($feed->as_xml);
}

sub articles : Local {
    my ($self, $c, $tag) = @_;
    my $feed = XML::Feed->new('RSS');
    my @articles;

    $feed->title($c->config->{name} . ' RSS');
    $feed->link($c->uri_for('/'));
    $feed->description($c->config->{name} . ' RSS Feed');

    if (!defined $tag) {
	@articles = $c->model('DB::Article')->get_latest_articles;
    }
    else {
	@articles =
	    $c->model('DB::Tag')
	    ->search({name => {like => $c->ravlog_url_to_query($tag)}})
	    ->first
	    ->articles;
    }

    for my $a (@articles) {
	my $feed_entry = XML::Feed::Entry->new('RSS');

	$feed_entry->title($a->subject);
	$feed_entry->link($c->uri_for_action(
	    '/article/view', [$c->ravlog_txt_to_url($a->subject)]
	));
	$feed_entry->summary($a->formatted_body);
	$feed_entry->issued($a->created_at);
	$feed->add_entry($feed_entry);
    }

    $c->response->content_type('application/rss+xml');
    $c->response->body($feed->as_xml);
}

1;
