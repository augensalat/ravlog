package RavLog::Schema::ResultSet::Article;

use parent 'DBIx::Class::ResultSet';

use DateTime;

sub get_latest_articles {
    my ($self, $number_of_posts) = @_;

    return $self->search(
	undef,
	{
	    rows => $number_of_posts || 10,
	    order_by => {-desc => \'me.article_id'},
	}
    );
}

sub archived {
    my $self = shift;
    my %arg = @_;
    my ($year, $month, $day, $time_zone) = @arg{qw(year month day time_zone)};
    my $lastday;
    my $schema = $self->result_source->schema;

    if (defined $day) {
	$lastday = $day;
    }
    else {
	$day = 1;
	$lastday = DateTime->last_day_of_month(year => $year, month => $month)->day;
    }

    my $from = DateTime->new(
	year => $year, month => $month, day => $day,
	time_zone => $time_zone || 'local'
    );
    my $until = $from->clone->set_day($lastday)->add(days => 1)->subtract(seconds => 1);

    return $self->search(
	{
	    created_at => {
		# XXX TODO time zone support XXX
		-between => [
		    $schema->format_datetime($from),
		    $schema->format_datetime($until)
		]
	    }
	},
	{
	    order_by => {-desc => \'article_id'},
	    cache => 1,
	}
    );

}

sub from_month {
    my $self = shift;
    my %arg = @_;
    my ($month, $time_zone) = @arg{qw(month time_zone)};
    my $year = $arg{year} || DateTime->now->year;
    my $lastday = DateTime->last_day_of_month(year => $year, month => $month)->day;
    my $schema = $self->result_source->schema;
    my $from = DateTime->new(
	year => $year, month => $month, day => 1,
	time_zone => $time_zone || 'local'
    );
    my $until = $from->clone->set_day($lastday)->add(days => 1)->subtract(seconds => 1);

    return $self->search(
        {
	    created_at => {
		-between => [
		    $schema->format_datetime($from),
		    $schema->format_datetime($until)
		]
	    }
	},
        {
	    order_by => {-desc => \'article_id'},
	    cache => 1,
	}
    )->all;
}

1;
