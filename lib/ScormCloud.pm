package ScormCloud;

use Moose;

=head1 NAME

ScormCloud - Interface to cloud.scorm.com

=head1 DESCRIPTION

This module provides an API interface to cloud.scorm.com, which is a
web service provided by Rustici Software (L<http://www.scorm.com/>).

API docs can be found at
L<http://cloud.scorm.com/EngineWebServices/doc/SCORMCloudAPI.html>.

The author of this module has no affiliation with Rustici Software
other than as a user of the interface.

Registered trademarks are property of their respective owners.

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

=cut

use ScormCloud::Types;

=head1 API CLASSES

Each portion of the API is defined in its own class:

L<ScormCloud::Service::Course>

L<ScormCloud::Service::Debug>

L<ScormCloud::Service::Registration>

L<ScormCloud::Service::Reporting>

L<ScormCloud::Service::Upload>

=cut

with
  'ScormCloud::Service::Course',
  'ScormCloud::Service::Debug',
  'ScormCloud::Service::Registration',
  'ScormCloud::Service::Reporting',
  'ScormCloud::Service::Upload',
  ;

=head1 USAGE

=head2 new( I<%args> )

Construct a C<ScormCloud> object to communicate with the API.

B<Note:> Any of the following constructor parameters can also be
called post-construction as object set/get methods.

=over 4

=item app_id

B<Required.>  An application ID generated for your login at
L<http://cloud.scorm.com/>.

=cut

has 'app_id' => (
                 is       => 'rw',
                 required => 1,
                 isa      => 'Str',
                );

=item secret_key

B<Required.>  A secret key that corresponds to the application ID,
used for hashing parameters in the API request URLs.  Generated at
L<http://cloud.scorm.com/>.

=cut

has 'secret_key' => (
                     is       => 'rw',
                     required => 1,
                     isa      => 'Str',
                    );

=item service_url

The API service URL.  Defaults to "http://cloud.scorm.com/api".

=cut

has 'service_url' => (
                      is       => 'rw',
                      required => 1,
                      isa      => 'ScormCloud::Types::URI',
                      coerce   => 1,
                      default  => 'http://cloud.scorm.com/api',
                     );

=item lwp_user_agent

Set the user agent string used in API requests.  Defaults to "MyApp/1.0".

=cut

has 'lwp_user_agent' => (
                         is       => 'rw',
                         required => 1,
                         isa      => 'ScormCloud::Types::LWP::UserAgent',
                         coerce   => 1,
                         default  => 'MyApp/1.0',
                        );

=item top_level_namespace

Top-level namespace for API methods.  Defaults to "rustici".

=cut

has 'top_level_namespace' => (
                              is       => 'rw',
                              required => 1,
                              isa      => 'Str',
                              default  => 'rustici',
                             );

=item dump_request_url

Set to true to dump request URLs to STDOUT.  Default is false.

=cut

has 'dump_request_url' => (
                           is      => 'rw',
                           isa     => 'Bool',
                           default => 0,
                          );

=item dump_response_xml

Set to true to dump raw response XML to STDOUT.  Default is false.

=cut

has 'dump_response_xml' => (
                            is      => 'rw',
                            isa     => 'Bool',
                            default => 0,
                           );

=item dump_response_data

Set to true to dump data from parsed response XML to STDOUT.
Default is false.

Parsing is currently done with L<XML::Simple>.

=cut

has 'dump_response_data' => (
                             is      => 'rw',
                             isa     => 'Bool',
                             default => 0,
                            );

=item dump_api_results

Set to true to dump results grabbed from response data by each API
call.  Default is false.

Parsing is currently done with L<XML::Simple>.

=cut

has 'dump_api_results' => (
                           is      => 'rw',
                           isa     => 'Bool',
                           default => 0,
                          );

=item die_on_bad_response

Set to true to die if the API response data is malformed or invalid
for the given API method being called (mainly useful for testing).
Default is false.

=cut

has 'die_on_bad_response' => (
                              is      => 'rw',
                              isa     => 'Bool',
                              default => 0,
                             );

=back

=cut

no Moose;

__PACKAGE__->meta->make_immutable;

1;

__END__

=head1 SEE ALSO

L<http://www.scorm.com/>

L<ScormCloud::Service::Course>

L<ScormCloud::Service::Debug>

L<ScormCloud::Service::Registration>

L<ScormCloud::Service::Reporting>

L<ScormCloud::Service::Upload>

=head1 AUTHOR

Larry Leszczynski, C<< <larryl at cpan.org> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-scormcloud at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=ScormCloud>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc ScormCloud

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

