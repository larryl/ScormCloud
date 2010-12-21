#!perl -T

use strict;
use warnings;

use Test::More tests => 7;

BEGIN
{
    use_ok('ScormCloud');
    use_ok('ScormCloud::Types');
    use_ok('ScormCloud::Service');
    use_ok('ScormCloud::Service::Course');
    use_ok('ScormCloud::Service::Debug');
    use_ok('ScormCloud::Service::Registration');
    use_ok('ScormCloud::Service::Reporting');
}

diag("Testing ScormCloud $ScormCloud::VERSION, Perl $], $^X");
