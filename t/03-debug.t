#!perl -T

use Test::More tests => 6;

require './t/_test_util.pl';

my $ScormCloud = getScormCloudObject();

##########

can_ok($ScormCloud, 'ping');
is($ScormCloud->ping, 1, '$ScormCloud->ping');

##########

can_ok($ScormCloud, 'authPing');
is($ScormCloud->authPing, 1, '$ScormCloud->authPing');

##########

can_ok($ScormCloud, 'getTime');
my ($S, $M, $H, $d, $m, $y) = gmtime;
my $now = sprintf '%4d%02d%02d%02d%02d%02d', $y + 1900, $m + 1, $d, $H, $M, $S;
my $got = $ScormCloud->getTime;
if ($got =~ /\D/)
{
    fail("\$ScormCloud->getTime should be a timestamp\n\tgot: $got");
}
else
{
    if (($got - $now) <= 5)    # allow a few seconds time lag
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

