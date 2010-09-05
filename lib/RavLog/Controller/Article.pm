package RavLog::Controller::Article;

use Moose;
use namespace::autoclean;

use RavLog::Form::Comment;

BEGIN {
    extends 'Catalyst::Controller';
}

sub base : Chained('/') PathPart('article') CaptureArgs(0) {
}

sub item : Chained('base') PathPart('id') CaptureArgs(1) {
    my ($self, $c, $article_title) = @_;

    $c->stash->{article} = $c->model('DB::Article')
	->search({subject => {like => $c->ravlog_url_to_query($article_title)}})
	->first;
}

sub list : Chained('base') PathPart('') Args(0) {
    my ($self, $c) = @_;
    my $stash = $c->stash;

    $stash->{articles} = $c->model('DB::Article')->get_latest_articles;
    $stash->{template} = 'blog_index.tt';
}

sub view : Chained('item') PathPart('') Args(0) {
    my ($self, $c, $id) = @_;
    my $stash = $c->stash;
    my $req = $c->request;
    my $article = $stash->{article};

    $stash->{title}    = $article->subject();
    $stash->{comments} = [$article->comments->all];
    $stash->{template} = 'blog_view.tt';

    my $form = RavLog::Form::Comment->new(
	user => $c->user,
	article_id => $article->id,
	remote_ip => $req->address,
	schema => $c->model('DB'),
	ctx => $c,
    );
    $form->process(params => $req->params);
    $stash->{comment_form} = $form;
#    $self->stash_comment_form($c, $self->article->id);
}

__PACKAGE__->meta->make_immutable;
