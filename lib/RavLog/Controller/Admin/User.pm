package RavLog::Controller::Admin::User;

use Moose;
use namespace::autoclean;

use RavLog::Form::Class::User;

BEGIN {
   extends 'Catalyst::Controller';
}

sub base : Chained('/admin/base') PathPart('user') CaptureArgs(0) {}

sub item : Chained('base') PathPart('') CaptureArgs(1) {
    my ($self, $c, $user_id) =  @_;
    my $user = $c->model('DB::User')->find($user_id);

    $c->stash(user => $user); 
}

sub list : Chained('base') PathPart('') Args(0) {
    my ($self, $c) = @_;
    my $users = $c->model('DB::User');

    $c->stash(users => $users, template => 'admin/user/list.tt', tabnavid => 'tabnav3');
}

sub create : Chained('base') Args(0) {
    my ($self, $c) = @_;

    $c->stash(user => $c->model('DB::User')->new_result({}));

    return unless $self->form($c);

    $c->response->redirect($c->uri_for_action('/admin/user/list'));
}

sub view : Chained('item') PathPart('') Args(0) {
    my ($self, $c) = @_;

    $c->stash(template => 'admin/user/view.tt');
}

sub edit : Chained('item') Args(0) {
    my ($self, $c) = @_;

    return unless $self->form($c);

    $c->response->redirect($c->uri_for_action('/admin/user/list') );
}

sub delete : Chained('item') PathPart('delete') Args(0) {
    my ($self, $c) = @_;

    $c->stash->{user}->delete;
    $c->response->redirect($c->uri_for_action('/admin/user/list'));
}

sub form {
    my ($self, $c) = @_;
    my $user = $c->stash->{user};

    $user->timezone($c->config->{time_zone_object}->name)
	unless $user->timezone;

    my $form = RavLog::Form::Class::User->new(item => $user);
    $c->stash(template => 'admin/user/edit.tt', form => $form);

    return $form->process(params => $c->request->params);
}

__PACKAGE__->meta->make_immutable;
