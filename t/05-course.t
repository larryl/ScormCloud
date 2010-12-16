#!perl -T

use Test::More tests => 5;

require './t/_test_util.pl';

my $ScormCloud = getScormCloudObject();

##########

can_ok($ScormCloud, 'getCourseList');

my $course_list = $ScormCloud->getCourseList;

isa_ok($course_list, 'ARRAY', '$ScormCloud->getCourseList');

##########

can_ok($ScormCloud, 'courseExists');

is($ScormCloud->courseExists('i do not exist'), 0, '$ScormCloud->courseExists');

SKIP:
{
    skip 'No courses for $ScormCloud->courseExists check', 1
      unless @{$course_list} > 0;

    my $course_id = $course_list->[0]->{id};
    is($ScormCloud->courseExists($course_id), 1, '$ScormCloud->courseExists');
}

