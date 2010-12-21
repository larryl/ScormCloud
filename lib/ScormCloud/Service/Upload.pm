package ScormCloud::Service::Upload;

use Moose::Role;

with 'ScormCloud::Service';

=head1 NAME

ScormCloud::Service::Upload - ScormCloud API "upload" namespace

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';

=head1 SYNOPSIS

    use ScormCloud;

    my $ScormCloud = ScormCloud->new(
                        app_id      => '12345678',
                        secret_key  => 'ABCDEFGHIJKLMNOPQRSTUVWXYZ',
    );

    my $token = $ScormCloud->getUploadToken;

    my ($errcode, $msg) = $ScormCloud->uploadFile($token, $file);

    my $uploaded_files = $ScormCloud->listFiles;

=head1 DESCRIPTION

This module defines L<ScormCloud> API methods in the "upload"
namespace.  See L<ScormCloud> for more info.

=cut

use Carp;

requires 'process_request';

=head1 METHODS

=head2 getUploadToken

Get and return an upload token to be used with a file upload.

=cut

sub getUploadToken
{
    my ($self) = @_;

    return $self->process_request(
        {method => 'upload.getUploadToken'},
        sub {
            my ($response) = @_;

            return $response->{token}->{id};
        }
    );
}

=head2 getUploadProgress ( I<token> )

Given an upload token, get progress info for the corresponding
upload.

=cut

sub getUploadProgress
{
    my ($self, $token) = @_;

    croak 'Missing token' unless $token;

    return $self->process_request(
        {method => 'upload.getUploadProgress', token => $token},
        sub {
            my ($response) = @_;

            return {} if exists $response->{empty};
            return $response->{upload_progress};
        }
    );
}

=head2 uploadFile ( I<file> [ , I<token> ] )

Upload a file.  Will generate an upload token is none is supplied.

Returns the generated destination path on the remote filesystem.

=cut

sub uploadFile
{
    my ($self, $file, $token) = @_;

    croak 'Missing file' unless $file;

    $token ||= $self->getUploadToken;

    croak 'Cannot generate upload token' unless $token;

    return $self->process_request(
        {method => 'upload.uploadFile', token => $token},
        sub {
            my ($response) = @_;

            return $response->{location};
        },
        {
         request_method  => 'POST',
         request_content => [file => [$file]],
        }
    );
}

=head2 listFiles

Return a list of files that have been uploaded using the given AppID.

=cut

sub listFiles
{
    my ($self) = @_;

    return $self->process_request(
        {method => 'upload.listFiles'},
        sub {
            my ($response) = @_;

            die unless exists $response->{dir};
            if ($response->{dir}->{file})
            {
                return $response->{dir}->{file};
            }
            else
            {
                return [];    # empty list
            }
        },
        {xml_parser => {ForceArray => ['file']}}
                                 );
}

=head2 deleteFiles ( I<file> )

Delete a file that was uploaded.

Note: This method only handles one file at a time even though the
API servie can accept multiple files for deletion in a single
request.

=cut

sub deleteFiles
{
    my ($self, $file) = @_;

    croak 'Missing file' unless $file;

    return $self->process_request(
        {method => 'upload.deleteFiles', file => $file},
        sub {
            my ($response) = @_;

            die unless $response->{results}->[0]->{file} eq $file;
            die unless $response->{results}->[0]->{deleted} eq 'true';
            return 1;
        },
        {
         xml_parser => {
                        ForceArray => ['result'],
                        GroupTags  => {'results' => 'result',},
                       }
        }
    );
}

1;

__END__

=head1 SEE ALSO

L<ScormCloud>

=head1 AUTHOR

Larry Leszczynski, C<< <larryl at cpan.org> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-scormcloud at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=ScormCloud>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc ScormCloud::Service::Upload

You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=ScormCloud>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/ScormCloud>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/ScormCloud>

=item * Search CPAN

L<http://search.cpan.org/dist/ScormCloud/>

=back

=head1 ACKNOWLEDGEMENTS


=head1 COPYRIGHT & LICENSE

Copyright 2010 Larry Leszczynski.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.

=cut

