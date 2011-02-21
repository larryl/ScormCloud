#!perl -T

use strict;
use warnings;

use File::Spec;
use WebService::ScormCloud;

use constant CFGFILE => File::Spec->catfile('blib', 'api-info.cfg');

use constant SERVICE_URL => 'http://cloud.scorm.com/api';

sub createTestConfigInfo
{
    my $fh;

    unless (open($fh, '>', CFGFILE))
    {
        BAIL_OUT('Cannot open test config file for writing: ' . CFGFILE);
    }

    my $AppID;
    if ($ENV{SCORM_CLOUD_APPID})
    {
        $AppID = $ENV{SCORM_CLOUD_APPID};
        diag("\n", 'Using $ENV{SCORM_CLOUD_APPID}: ', $AppID);
    }
    else
    {
        diag("\n", '$ENV{SCORM_CLOUD_APPID} is not set.',
             "\n", 'Please enter your ScormCloud AppID:');
        $AppID = <STDIN>;
        chomp $AppID;
    }
    print $fh "$AppID\n";

    my $SecretKey;
    if ($ENV{SCORM_CLOUD_SECRETKEY})
    {
        $SecretKey = $ENV{SCORM_CLOUD_SECRETKEY};
        diag("\n", 'Using $ENV{SCORM_CLOUD_SECRETKEY}: ', $SecretKey);
    }
    else
    {
        diag("\n", '$ENV{SCORM_CLOUD_SECRETKEY} is not set.',
             "\n", 'Please enter your ScormCloud SecretKey:');
        $SecretKey = <STDIN>;
        chomp $SecretKey;
    }
    print $fh "$SecretKey\n";

    my $ServiceURL;
    if ($ENV{SCORM_CLOUD_SERVICEURL})
    {
        $ServiceURL = $ENV{SCORM_CLOUD_SERVICEURL};
        if ($ServiceURL eq 'default')
        {
            $ENV{SCORM_CLOUD_SERVICEURL} = SERVICE_URL;
            $ServiceURL = SERVICE_URL;
        }
        diag("\n", 'Using $ENV{SCORM_CLOUD_SERVICEURL}: ', $ServiceURL);
    }
    else
    {
        diag(
             "\n",        '$ENV{SCORM_CLOUD_SERVICEURL} is not set.',
             "\n",        '(You can set it to a URL, or "default".)',
             "\n",        'Please enter your ScormCloud ServiceURL:',
             "\n",        '(hit return for default: ',
             SERVICE_URL, ')'
            );
        $ServiceURL = <STDIN>;
        chomp $ServiceURL;
        $ServiceURL ||= SERVICE_URL;
    }
    print $fh "$ServiceURL\n";

    close $fh;
}

sub getTestConfigInfo
{
    my $fh;

    createTestConfigInfo() unless -f CFGFILE;

    unless (open($fh, '<', CFGFILE))
    {
        BAIL_OUT('Cannot open existing test config file: ' . CFGFILE);
    }

    my $AppID = <$fh>;
    chomp $AppID;

    my $SecretKey = <$fh>;
    chomp $SecretKey;

    my $ServiceURL = <$fh>;
    chomp $ServiceURL;

    close $fh;

    unless ($AppID && $SecretKey && $ServiceURL)
    {
        BAIL_OUT('Bad data in existing test config file: ' . CFGFILE);
    }

    return ($AppID, $SecretKey, $ServiceURL);
}

sub getScormCloudObject
{
    my ($AppID, $SecretKey, $ServiceURL) = getTestConfigInfo();

    return WebService::ScormCloud->new(
        app_id              => $AppID,
        secret_key          => $SecretKey,
        service_url         => $ServiceURL,
        die_on_bad_response => 1,

        #dump_request_url    => 1,
        dump_response_xml  => 1,
        dump_response_data => 1,

        #dump_api_results    => 1,
                                      );
}

1;

