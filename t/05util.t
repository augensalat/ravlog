use strict;
use warnings;
use utf8;

use Test::More;

BEGIN {
    use_ok 'RavLog::Util', qw(
	generate_password
	valid_username
    );
}

like(generate_password, qr{[a-z]{9,12}}, 'generate_password()')
    for 1 .. 10;
like(generate_password(13), qr{[a-z]{13}}, 'generate_password(13)')
    for 1 .. 10;
like(generate_password(5, 7), qr{[a-z]{5,7}}, 'generate_password(5,7)')
    for 1 .. 10;

eval 'generate_password(1, 2, 3)';
ok($@, 'invalid function call: generate_password(1, 2, 3)');

ok(valid_username($_), $_ . ' is a valid username')
    for qw(ab abc abcdefghijklmnopqrst a123 123a 1.x a- -x);

ok(!valid_username($_), $_ . ' is not a valid username')
    for qw(a abcdefghijklmnopqrstu 123 -- 1.2 -1 A+);

for ('valid_username', q{valid_username('John', 'Doe')}) {
    eval $_;
    ok($@, 'invalid function call: ' . $_);
}


done_testing;
