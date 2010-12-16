#!perl -T

use Test::More tests => 18;

require './t/_test_util.pl';

my $ScormCloud = getScormCloudObject();

##########

can_ok($ScormCloud, 'getAccountInfo');

my $account_info = $ScormCloud->getAccountInfo;

isa_ok($account_info, 'HASH', '$ScormCloud->getAccountInfo');

my %expected = (
                accounttype => '',
                company     => '',
                email       => '',
                firstname   => '',
                lastname    => '',
                usage       => 'HASH',
               );

foreach my $key (sort keys %expected)
{
    ok(exists $account_info->{$key},
        "\$ScormCloud->getAccountInfo includes $key");
    is(ref($account_info->{$key}),
        $expected{$key}, "ref(\$ScormCloud->getAccountInfo->{$key})");
}

my $usage = $account_info->{usage};

foreach my $key qw(totalcourses totalregistrations)
{
    ok(exists $usage->{$key},
        "\$ScormCloud->getAccountInfo->{usage} includes $key");
    like($usage->{$key}, qr/^\d+$/,
         "\$ScormCloud->getAccountInfo->{usage}->{$key} is numeric");
}

