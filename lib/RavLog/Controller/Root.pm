package RavLog::Controller::Root;

use Moose;
use namespace::autoclean;

use HTML::CalendarMonthSimple;

BEGIN {
    extends 'Catalyst::Controller';
}

__PACKAGE__->config->{namespace} = '';

sub begin : Private {
    my ($self, $c) = @_;
    my $stash = $c->stash;

    if ($c->model('DB::Config')->find('front page')->value ne 'blog') {
	$stash->{blog_page} = 1;
    }
    $stash->{pages} = [$c->model('DB::Page')->search({display_in_drawer => 1})->all];
    $stash->{activelink} = {home => 'activelink'};    # set it to home unless overridden.
    $stash->{sidebar} = 1;
    $stash->{xmlrpc} = undef;
}

sub base : Chained PathPart('') CaptureArgs(0) {}

sub tag : Local {
    my ($self, $c, $tag) = @_;
    my $stash = $c->stash;
    my $db_tag = $c->model('DB::Tag')
	->search({name => {like => $c->ravlog_url_to_query($tag)}})->first;

    $stash->{articles} = $db_tag->articles;
    $stash->{rss}      = $db_tag->name;
    $stash->{template} = 'blog_index.tt';
}

sub page : Local {
    my ($self, $c, $what) = @_;
    my $stash = $c->stash;
    my $page = $c->model('DB::Page')
	->search({name => {like => $c->ravlog_url_to_query($what)}})->first;
    my $name = $c->ravlog_txt_to_url($page->name);

    $stash->{sidebar} = undef unless $page->display_sidebar;
    $stash->{page}    = $page;
    $stash->{title}   = $page->name;
    $stash->{activelink} = {$name => 'activelink'};
    $stash->{template} = 'page.tt';
}

sub archived : Local {
    my ($self, $c, $year, $month, $day) = @_;
    my $stash = $c->stash;

    $stash->{articles} = $c->model('DB::Article')->archived(
	year => $year, month => $month, day => $day,
	time_zone => $c->config->{time_zone_object}
    );
    $stash->{template} = 'blog_index.tt';
}

sub default : Local {
    my ($self, $c) = @_;

    $c->forward('/article/list');
}

sub front_page : Path Args(0) {
    my ($self, $c) = @_;
    my $stash = $c->stash;
    my $front_page = $c->model('DB::Config')->find('front page');

    $stash->{activelink} = {'home' => 'activelink'};

    if ($front_page->value eq 'blog') {
	$c->forward('/article/list');
    }
    else {
        $stash->{page} = $c->model('DB::Page')
          ->search({name => {like => $c->ravlog_url_to_query($front_page->value)}})
	  ->first;
        $stash->{template} = 'page.tt';
    }
}

sub blog : Path('/blog') Args(0) {
    my ($self, $c) = @_;

    $c->stash(activelink => {'blog' => 'activelink'});
    $c->forward('/article/list');
}

sub tags {
    my ($self, $c) = @_;

    $c->stash->{tags} = [$c->model('DB::Tag')->all];
}

sub links {
    my ($self, $c) = @_;

    $c->stash->{links} = [
	$c->model('DB::Link')->search(undef, {order_by => {-desc => 'link_id'}})->all
    ];
}

sub calendar : Local {
    my ($self, $c) = @_;
    my $dt  = DateTime->now;
    my $cal = HTML::CalendarMonthSimple->new(
	year  => $dt->year, month => $dt->month
    );
    $cal->border(0);
    $cal->width(50);
    $cal->headerclass('month_date');
    $cal->showweekdayheaders(0);

    my @articles = $c->model('DB::Article')->from_month(
	year  => $dt->year, month => $dt->month,
	time_zone => $c->config->{time_zone_object}
    );

    foreach my $article (@articles) {
	my $location =
	    '/archived/'
	  . $article->created_at->year . '/'
	  . $article->created_at->month . '/'
	  . $article->created_at->mday;
	$cal->setdatehref($article->created_at->mday, $location);
    }

    $c->stash->{calendar} = $cal->as_HTML;
}

sub archives
{
   my ( $self, $c ) = @_;

   my @articles = $c->model('DB::Article')->all();

   unless (@articles)
   {
      $c->stash->{archives} = "<p>No Articles in Archive!</p>";
      return;
   }

   my $months;
   foreach my $article (@articles)
   {
      my $month = $article->created_at()->month_name();
      my $year  = $article->created_at()->year();
      my $key   = "$year $month";
      if ( ( defined $months->{$key}->{count} ) && ( $months->{$key}->{count} > 0 ) )
      {
         $months->{$key}->{count} += 1;
      }
      else
      {
         $months->{$key}->{count} = 1;
         $months->{$key}->{year}  = $year;
         $months->{$key}->{month} = $article->created_at()->month();
      }
   }

   my @out;
   while ( my ( $key, $value ) = each( %{$months} ) )
   {
      push @out,
         "<li><a href='/archived/$value->{year}/$value->{month}'>$key</a> <span class='special_text'>($value->{count})</span></li>";
   }
   $c->stash->{archives} = join( ' ', @out );
}

sub enable_sidebar : Local
{
   my ( $self, $c ) = @_;

   $self->tags($c);
   $self->archives($c);
   $self->links($c);
   $self->calendar($c);
}

sub auto : Private
{
   my ( $self, $c ) = @_;

   $c->set_ravlog_params( [ [ 'ul#error_content h3', 'top' ] ] );

   return 1;
}

sub cache_refresh
{
   my ( $self, $c, $item ) = @_;

   return;
   $c->cache->remove('front_page_articles');
   $c->clear_cached_page('/');
   if ( ref($item) eq "RavLog::Model::DB::Article" )
   {
      $c->clear_cached_page( '/view/' . $c->ravlog_txt_to_url( $item->subject ) );
   }
   if ( ref($item) eq "RavLog::Model::DB::Page" )
   {
      $c->clear_cached_page( '/page/' . $c->ravlog_txt_to_url( $item->name ) );
   }
}

sub end : Private
{
   my ( $self, $c ) = @_;

   return 1 if $c->req->method eq 'HEAD';
   return 1 if length( $c->response->body );
   return 1 if scalar @{ $c->error } && !$c->stash->{template};
   return 1 if $c->response->status =~ /^(?:204|3\d\d)$/;

   $self->enable_sidebar($c) if $c->stash->{sidebar};
   $c->forward('TT');
}

__PACKAGE__->meta->make_immutable;
