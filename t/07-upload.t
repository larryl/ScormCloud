#!perl -T

use strict;
use warnings;

use Test::More tests => 23;
use Test::Exception;

require './t/_test_util.pl';

my $SAMPLE_UPLOAD_FILE      = 'api-sample-upload.zip';
my $SAMPLE_UPLOAD_FILE_PATH = './blib/' . $SAMPLE_UPLOAD_FILE;

my $ScormCloud = getScormCloudObject();

##########

can_ok($ScormCloud, 'getUploadToken');

my $token = $ScormCloud->getUploadToken;
ok($token, '$ScormCloud->getUploadToken');

can_ok($ScormCloud, 'getUploadProgress');

my $progress;
throws_ok { $progress = $ScormCloud->getUploadProgress() } qr/^Missing token/,
  '$ScormCloud->getUploadProgress caught missing token';

$progress = $ScormCloud->getUploadProgress($token);
isa_ok($progress, 'HASH', '$ScormCloud->getUploadProgress');
is(keys %{$progress}, 0, '$ScormCloud->getUploadProgress is empty');

unless (-f $SAMPLE_UPLOAD_FILE_PATH)
{
    my $fh;
    unless (open($fh, '>', $SAMPLE_UPLOAD_FILE_PATH))
    {
        BAIL_OUT("Cannot create sample upload file: $SAMPLE_UPLOAD_FILE_PATH");
    }
    print $fh "foo\n";
    close $fh;
}

can_ok($ScormCloud, 'uploadFile');

my $remote_name;

throws_ok { $remote_name = $ScormCloud->uploadFile() } qr/^Missing file/,
  '$ScormCloud->uploadFile caught missing file';

$remote_name = $ScormCloud->uploadFile($SAMPLE_UPLOAD_FILE_PATH, $token);
like($remote_name, qr/$SAMPLE_UPLOAD_FILE$/,
     '$ScormCloud->uploadFile remote name');

$progress = $ScormCloud->getUploadProgress($token);
isa_ok($progress, 'HASH', '$ScormCloud->getUploadProgress');
foreach my $key qw(bytes_read content_length percent_complete upload_id)
{
    ok($progress->{$key}, "\$ScormCloud->getUploadProgress->{$key} exists");
}

can_ok($ScormCloud, 'listFiles');

my $list = $ScormCloud->listFiles;
isa_ok($list, 'ARRAY', '$ScormCloud->listFiles');
cmp_ok(@{$list}, '>=', 1, '$ScormCloud->listFiles at least one file');

isa_ok($list->[0], 'HASH', '$ScormCloud->listFiles is a list of hashrefs');
ok($list->[0]->{name}, '$ScormCloud->listFiles file name exists');

my @matches = grep { /$SAMPLE_UPLOAD_FILE$/ } map { $_->{name} } @{$list};
cmp_ok(scalar(@matches), '>=', 1,
       '$ScormCloud->listFiles at least one test file');

can_ok($ScormCloud, 'deleteFiles');

throws_ok { $ScormCloud->deleteFiles() } qr/^Missing file/,
  '$ScormCloud->deleteFiles caught missing file';

foreach my $file (@matches)
{
    $ScormCloud->deleteFiles($file);
}

$list = $ScormCloud->listFiles;
@matches = grep { /$SAMPLE_UPLOAD_FILE$/ } map { $_->{name} } @{$list};
is(scalar(@matches), 0, '$ScormCloud->deleteFiles deleted all test files');

