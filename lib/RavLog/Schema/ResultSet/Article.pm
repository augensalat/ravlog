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
    my ($self, $year, $month, $day) = @_;
    my $lastday;

    if (defined $day) {
	$lastday = $day;
    }
    else {
	$day = 1;
	$lastday = DateTime->last_day_of_month(year => $year, month => $month)->day;
    }
    return $self->search(
    {
	created_at => {
	    # XXX TODO time zone support XXX
	   -between => [ "$year-$month-$day 00:00:00", "$year-$month-$lastday 23:59:59" ]
	}
     },
     {order_by => {-desc => 'article_id'}}
    );

}

sub from_month {
    my $self = shift;
    my $month = shift;
    my $year = shift || DateTime->now->year;
    my $lastday = DateTime->last_day_of_month(year => $year, month => $month)->day;

    return $self->search(
        { created_at => { -between => [ "$year-$month-1", "$year-$month-$lastday" ] } },
        { order_by   => 'article_id desc' }
    )->all();
}

1;
