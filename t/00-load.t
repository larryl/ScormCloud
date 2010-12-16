#!perl -T

use Test::More tests => 6;

BEGIN
{
    use_ok('ScormCloud');
    use_ok('ScormCloud::Types');
    use_ok('ScormCloud::API::Course');
    use_ok('ScormCloud::API::Debug');
    use_ok('ScormCloud::API::Registration');
    use_ok('ScormCloud::API::Reporting');
}

diag("Testing ScormCloud $ScormCloud::VERSION, Perl $], $^X");
