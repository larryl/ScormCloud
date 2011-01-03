package WebService::ScormCloud::Service::Registration;

use Moose::Role;

with 'WebService::ScormCloud::Service';

=head1 NAME

WebService::ScormCloud::Service::Registration - ScormCloud API "registration" namespace

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';

=head1 SYNOPSIS

    use WebService::ScormCloud;

    my $ScormCloud = WebService::ScormCloud->new(
                        app_id      => '12345678',
                        secret_key  => 'ABCDEFGHIJKLMNOPQRSTUVWXYZ',
    );

    my $registration_list = $ScormCloud->getRegistrationList;

=head1 DESCRIPTION

This module defines L<WebService::ScormCloud> API methods in the "registration"
namespace.  See L<WebService::ScormCloud> for more info.

=cut

use Carp;

requires 'process_request';

=head1 METHODS

=head2 getRegistrationResult ( I<registration_id> [ , I<results_format> ] )

Given a registration ID, returns registration results.

=cut

sub getRegistrationResult
{
    my ($self, $registration_id, $results_format) = @_;

    croak "Missing registration_id" unless $registration_id;

    my %params = (
                  method => 'registration.getRegistrationResult',
                  regid  => $registration_id
                 );
    $params{resultsformat} = $results_format if $results_format;

    return $self->process_request(
        \%params,
        sub {
            my ($response) = @_;

            return
              ref($response->{registrationreport}) eq 'HASH'
              ? $response->{registrationreport}
              : undef;
        },
        {
         xml_parser => {
                        ForceArray =>
                          [qw(activity comment response interaction objective)],
                        GroupTags => {
                                      'children'              => 'activity',
                                      'comments_from_learner' => 'comment',
                                      'comments_from_lms'     => 'comment',
                                      'correct_responses'     => 'response',
                                      'interactions'          => 'interaction',
                                      'objectives'            => 'objective',
                                     },
                       }
        }
    );
}

=head2 getRegistrationList ( [ I<filters> ] )

Returns an arrayref containing a list of registrations.
The returned list might be empty.

The optional I<filters> hashref can contain any of these entries
to filter the returned list of registrations:

=over 4

=item filter

A regular expression for matching the registration ID

=item coursefilter

A regular expression for matching the course ID

=back

Note that any filter regular expressions must match the B<entire>
string.  (There seems to be an implied C<^...$> around the supplied
pattern.)  So to match e.g. any courses that begin with "ABC":

    {coursefilter => '^ABC'}    # THIS WILL NOT WORK

    {coursefilter => 'ABC.*'}   # This will work

=cut

sub getRegistrationList
{
    my ($self, $filters) = @_;

    $filters ||= {};

    my %params = (method => 'registration.getRegistrationList');

    foreach my $key qw(filter coursefilter)
    {
        $params{$key} = $filters->{$key} if $filters->{$key};
    }

    return $self->process_request(
        \%params,
        sub {
            my ($response) = @_;

            die unless exists $response->{registrationlist};
            if ($response->{registrationlist})
            {
                return $response->{registrationlist};
            }
            else
            {
                return [];    # empty list
            }
        },
        {
         xml_parser => {
                        ForceArray => ['registration', 'instance'],
                        GroupTags  => {
                                      'registrationlist' => 'registration',
                                      'instances'        => 'instance',
                                     },
                       }
        }
    );
}

1;

__END__

=head1 SEE ALSO

L<WebService::ScormCloud>

=head1 AUTHOR

Larry Leszczynski, C<< <larryl at cpan.org> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-scormcloud at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=WebService-ScormCloud>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc WebService::ScormCloud::Service::Registration

You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=WebService-ScormCloud>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/WebService-ScormCloud>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/WebService-ScormCloud>

=item * Search CPAN

L<http://search.cpan.org/dist/WebService-ScormCloud/>

=back

=head1 ACKNOWLEDGEMENTS


=head1 COPYRIGHT & LICENSE

Copyright 2010 Larry Leszczynski.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.

=cut

