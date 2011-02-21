#!perl -T

use strict;
use warnings;

use File::Spec;
use Test::More tests => 6;
use Time::Local 'timegm';

use lib File::Spec->curdir;
require File::Spec->catfile('t', '_test_util.pl');

my $ScormCloud = getScormCloudObject();

##########

can_ok($ScormCloud, 'ping');
is($ScormCloud->ping, 1, '$ScormCloud->ping');

##########

can_ok($ScormCloud, 'authPing');
is($ScormCloud->authPing, 1, '$ScormCloud->authPing');

##########

can_ok($ScormCloud, 'getTime');
my $got = $ScormCloud->getTime || '';
if ($got =~ /\D/ || length($got) != 14)
{
    fail("\$ScormCloud->getTime should be a timestamp\n\tgot: $got");
}
else
{
    my $now = timegm gmtime;    # "now" in GMT epoch seconds

    my ($year, $mon, $day, $hour, $min, $sec) =
      $got =~ /^(\d{4})(\d{2})(\d{2})(\d{2})(\d{2})(\d{2})$/;

    $got = timegm $sec, $min, $hour, $day, ($mon - 1), ($year - 1900);

    if (abs($got - $now) <= 5)    # allow a few seconds time lag
    {
        pass('$ScormCloud->getTime');
    }
    else
    {
        fail(  "\$ScormCloud->getTime mismatch\n"
             . "\texpected: $now\n"
             . "\tgot:      $got");
    }
}

