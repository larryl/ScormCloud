#!perl -T

use strict;
use warnings;

use Test::More tests => 7;

BEGIN
{
    use_ok('WebService::ScormCloud');
    use_ok('WebService::ScormCloud::Types');
    use_ok('WebService::ScormCloud::Service');
    use_ok('WebService::ScormCloud::Service::Course');
    use_ok('WebService::ScormCloud::Service::Debug');
    use_ok('WebService::ScormCloud::Service::Registration');
    use_ok('WebService::ScormCloud::Service::Reporting');
}

diag(
    "Testing WebService::ScormCloud $WebService::ScormCloud::VERSION, Perl $], $^X"
);
