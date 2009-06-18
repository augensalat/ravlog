package CatalystX::Comments::ControllerFormRole;
use Moose::Role;
use CatalystX::Comments::Form;

sub stash_comment_form {
    my( $self, $c, $article_id ) = @_;
    my $form = CatalystX::Comments::Form->new( 
        schema => $c->model( $self->model_name ),
    );
    if( $c->req->method eq 'POST' ){
        my $params = $c->req->params;
        $form->params( $params );
        if( $form->process ){
            my $comment = $form->item;
            $comment->update( { article_id => $article_id, remote_ip => $c->req->address } );
            $c->res->redirect( $c->uri_for($c->action, $c->req->captures) );
        }
    }
    $c->stash( comment_form => $form );
}

no Moose::Role;
1;

