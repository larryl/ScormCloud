
use ScormCloud;

use constant CFGFILE => './blib/api-info.cfg';

sub getTestConfigInfo
{
    my $fh;

    unless (-f CFGFILE && open($fh, '<', CFGFILE))
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

    return
      ScormCloud->new(
                      app_id              => $AppID,
                      secret_key          => $SecretKey,
                      service_url         => $ServiceURL,
                      die_on_bad_response => 1,
                      dump_response_xml   => 1,
                      dump_response_data  => 1,
                     );
}

1;

