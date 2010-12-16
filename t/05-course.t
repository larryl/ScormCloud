#!perl -T

use Test::More tests => 4;

require './t/_test_util.pl';

my $ScormCloud = getScormCloudObject();

##########

can_ok($ScormCloud, 'courseExists');

is($ScormCloud->courseExists('i do not exist'), 0, '$ScormCloud->courseExists');

##########

can_ok($ScormCloud, 'getCourseList');

my $course_list = $ScormCloud->getCourseList;

isa_ok($course_list, 'ARRAY', '$ScormCloud->getCourseList');

diag('$ScormCloud->getCourseList size: ' . scalar(@{$course_list}));

