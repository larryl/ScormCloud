#!perl -T

use Test::More tests => 5;

use constant CFGFILE => './blib/api-info.cfg';

use constant SERVICE_URL => 'http://cloud.scorm.com/api';

my ($file, $size, $fh);

my ($AppID, $SecretKey, $ServiceURL);

if (-f CFGFILE)
{
    $size = -s CFGFILE;
    ok($size, 'Found existing test config file: ' . CFGFILE);

    if (open($fh, '<', CFGFILE))
    {
        pass('Opened existing test config file: ' . CFGFILE);

        $AppID = <$fh>;
        chomp $AppID;
        ok($AppID, 'Got ScormCloud AppID');

        $SecretKey = <$fh>;
        chomp $SecretKey;
        ok($SecretKey, 'Got ScormCloud SecretKey');

        $ServiceURL = <$fh>;
        chomp $ServiceURL;
        ok($ServiceURL, 'Got ScormCloud ServiceURL');

        close $fh;
    }
    else
    {
        BAIL_OUT('Cannot open existing test config file: ' . CFGFILE);
    }
}
else
{
    if (open($fh, '>', CFGFILE))
    {
        pass('Opened test config file for writing: ' . CFGFILE);

        diag('Please enter your ScormCloud AppID:');
        $AppID = <STDIN>;
        chomp $AppID;
        ok($AppID, 'Got ScormCloud AppID');
        print $fh "$AppID\n";

        diag('Please enter your ScormCloud SecretKey:');
        $SecretKey = <STDIN>;
        chomp $SecretKey;
        ok($SecretKey, 'Got ScormCloud SecretKey');
        print $fh "$SecretKey\n";

        diag(  "Please enter your ScormCloud ServiceURL:\n"
             . "(hit return for default: "
             . SERVICE_URL
             . ")");
        $ServiceURL = <STDIN>;
        chomp $ServiceURL;
        $ServiceURL ||= SERVICE_URL;
        ok($ServiceURL, 'Got ScormCloud ServiceURL');
        print $fh "$ServiceURL\n";

        close $fh;

        $size = -s CFGFILE;
        ok($size, 'Stored data in test config file');
    }
    else
    {
        BAIL_OUT('Cannot open test config file for writing: ' . CFGFILE);
    }
}

