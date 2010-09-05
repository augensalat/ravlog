package RavLog::Form::Class::User;

use namespace::autoclean;

use HTML::FormHandler::Moose;
use HTML::FormHandler::Types qw(Password NoSpaces WordChars NotAllDigits);

use DateTime::TimeZone '0.92';
use Scalar::MoreUtils qw(empty);

use RavLog::Util qw(valid_username);

extends 'HTML::FormHandler::Model::DBIC';
with 'HTML::FormHandler::Render::Simple';

=head1 NAME

RavLog::Form::Class::User::Edit - User data form class

=head1 DESCRIPTION

User data edit form class.

=cut

my $PASSWORD_CONSTRAINTS = [Password, NoSpaces, WordChars, NotAllDigits];

=head1 ATTRIBUTES

=cut

=head2 timezone_options

An array reference that caches the timezone locations in the object instance.

=cut

has timezone_options => (
    is      => 'ro',
    builder => '_build_timezone_options',
    lazy    => 1,
    isa     => 'ArrayRef',
);

sub _build_timezone_options {
    return [
        (map { $_ => $_ }
            grep { index($_, '/') > $[ } DateTime::TimeZone->all_names),
        UTC => 'UTC'
    ];
}

=head1 FIELDS

=cut

=head2 username

=cut

has_field username => (
    type => 'Text',
    required => 1,
    apply => [
	{transform => sub {lc $_[0]}},
	{  
	    check => \&valid_username,
	    message => ['Username must have a least two characters'],
	}
    ],
    unique => 1,
    inactive => 1,
    minlength => 2,
    maxlength => 20,
    unique_message => 'Sorry, but this username is already taken',
);

has_field password => (
    type => 'Password',
    label => 'Password',
    apply => $PASSWORD_CONSTRAINTS,
    inactive => 1,
    maxlength => 40,
    ne_username => 'username',
#    comment => 'Min. 6 letters, ciphers and "_", not only ciphers',
);

has_field password_confirm => (
    type => 'PasswordConf',
    label => 'Re-type Password',
    apply => $PASSWORD_CONSTRAINTS,
    inactive => 1,
    required => 0,
    maxlength => 40,
    label => 'Repeat password',
#    comment => 'Please repeat password to obviate typos',
);

has_field 'website' => (
    type => 'Text',
    maxlength => 255,
);

has_field 'email' => (
    type => 'Email',
    required => 1,
    unique => 1,
    label    => 'E-Mail',
    maxlength => 255,
);

has_field timezone => (
    type => 'Select',
    label    => 'Time Zone',
);

has_field 'submit' => (
    type => 'Submit',
    value => 'Save'
);


=head1 METHOD MODIFIERS

=cut

=head2 before setup_form

Activate some fields depending on certain conditions.

=cut

before set_active => sub {
    my $self = shift;
    my $item = $self->item;
    my @activate;

    # username can only be set on account creation
    push @activate, 'username'
        unless blessed $item
	    and $item->can('username')
	    and not empty $item->username;

    # more to come (one fine day)

    $self->active(\@activate)
	if @activate;

    # password must be set on creation
    unless ($item) {
        $self->field($_)->required(1)
            for qw(password password_confirm)
    }
};

=head1 METHODS

=cut

sub options_timezone {
    return $_[0]->timezone_options;
}

__PACKAGE__->meta->make_immutable;

__END__
