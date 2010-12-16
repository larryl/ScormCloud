#!perl -T

use Test::More tests => 2;

require './t/_test_util.pl';

my $ScormCloud = getScormCloudObject();

##########

can_ok($ScormCloud, 'getRegistrationList');

my $registration_list = $ScormCloud->getRegistrationList;

isa_ok($registration_list, 'ARRAY', '$ScormCloud->getRegistrationList');

diag('$ScormCloud->getRegistrationList size: ' . scalar(@{$registration_list}));

