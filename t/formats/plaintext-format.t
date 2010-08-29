use strict;
use warnings;

use Test::More;
use ok 'RavLog::Format::PlainText';
use Test::XML::Valid;

my $can_test_tidy = eval {
    require Test::HTML::Tidy;
    import Test::HTML::Tidy;
    require RavLog::Test::Tidy;
};

my $plaintext = RavLog::Format::PlainText->new;
isa_ok( $plaintext, 'RavLog::Format::PlainText', 'created parser' );

my $input = do { local $/; <DATA> };
my $output = $plaintext->format($input);

$output = <<"";
<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN"
                      "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
<html xmlns="http://www.w3.org/1999/xhtml"
      xml:lang="en">
<head><title>test</title></head><body>$output</body></html>

if ($can_test_tidy) {
    # make output tidier for tidy:
    html_tidy_ok(RavLog::Test::Tidy->tidy, $output, 'html is tidy');
}

xml_string_ok( $output, 'html is valid xml' );

like($output, 
     qr|<a href="http://www\.google\.com/">http://www\.google\.com/</a>.|,
     'link was made clickable');

done_testing;

__DATA__ 

This is some text.  This is some text.  It is time for some text.

Here is a new paragraph, with a link to http://www.google.com/.  Enjoy.

