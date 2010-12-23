
use WebService::ScormCloud;

use constant CFGFILE => './blib/api-info.cfg';

use constant SERVICE_URL => 'http://cloud.scorm.com/api';

sub createTestConfigInfo
{
    my $fh;

    unless (open($fh, '>', CFGFILE))
    {
        BAIL_OUT('Cannot open test config file for writing: ' . CFGFILE);
    }

    diag('Please enter your ScormCloud AppID:');
    $AppID = <STDIN>;
    chomp $AppID;
    print $fh "$AppID\n";

    diag('Please enter your ScormCloud SecretKey:');
    $SecretKey = <STDIN>;
    chomp $SecretKey;
    print $fh "$SecretKey\n";

    diag(  "Please enter your ScormCloud ServiceURL:\n"
         . "(hit return for default: "
         . SERVICE_URL
         . ")");
    $ServiceURL = <STDIN>;
    chomp $ServiceURL;
    $ServiceURL ||= SERVICE_URL;
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

