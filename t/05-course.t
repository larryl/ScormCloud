#!perl -T

use strict;
use warnings;

use Test::More tests => 13;

require './t/_test_util.pl';

my $ScormCloud = getScormCloudObject();

##########

can_ok($ScormCloud, 'getCourseList');

my $course_list;

$course_list = $ScormCloud->getCourseList({filter => 'i do not exist'});
isa_ok($course_list, 'ARRAY', '$ScormCloud->getCourseList');
is(scalar(@{$course_list}), 0, '$ScormCloud->getCourseList empty');

$course_list = $ScormCloud->getCourseList;

isa_ok($course_list, 'ARRAY', '$ScormCloud->getCourseList');

##########

can_ok($ScormCloud, 'courseExists');

is($ScormCloud->courseExists('i do not exist'), 0, '$ScormCloud->courseExists');

can_ok($ScormCloud, 'getMetadata');

SKIP:
{
    skip 'No courses exist for further testing', 6
      unless @{$course_list} > 0;

    my $course_id = $course_list->[0]->{id};
    is($ScormCloud->courseExists($course_id), 1, '$ScormCloud->courseExists');

    my $metadata = $ScormCloud->getMetadata($course_id);
    isa_ok($metadata, 'HASH', '$ScormCloud->getMetadata');

    my %expected = (
                    metadata => 'HASH',
                    object   => 'HASH',
                   );

    foreach my $key (sort keys %expected)
    {
        ok(exists $metadata->{$key}, "\$ScormCloud->getMetadata includes $key");
        is(ref($metadata->{$key}),
            $expected{$key}, "ref(\$ScormCloud->getMetadata->{$key})");
    }
}

