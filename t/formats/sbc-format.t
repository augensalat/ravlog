use strict;
use warnings;

use Test::More;
use ok 'RavLog::Format::SBC';
use Test::XML::Valid;

my $can_test_tidy = eval {
    require Test::HTML::Tidy;
    import Test::HTML::Tidy;
    require RavLog::Test::Tidy;
};

my $sbc = RavLog::Format::SBC->new;
isa_ok( $sbc, 'RavLog::Format::SBC', 'created parser' );

my $input = do { local $/; <DATA> };
my $output = $sbc->format($input);

# make output tidier for tidy:
$output = <<"";
<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN"
                      "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
<html xmlns="http://www.w3.org/1999/xhtml"
      xml:lang="en">
<head><title>test</title></head><body>$output</body></html>

if ($can_test_tidy) {
    html_tidy_ok(RavLog::Test::Tidy->tidy, $output, 'html is tidy');
}

xml_string_ok( $output, 'html is valid xml' );

done_testing;

__DATA__
*foo* /bar/

{http://www.example.org/foo.jpg image}

# one
# two
# three

[
\[...\] the three great virtues of a programmer:
- laziness,
- impatience and
- hubris.
] Larry Wall
