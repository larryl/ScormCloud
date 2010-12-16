package ScormCloud::API::Registration;

use Moose::Role;

with 'ScormCloud::API';

=head1 NAME

ScormCloud::API::Registration - ScormCloud API "registration" namespace

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

    my $registration_list = $ScormCloud->getRegistrationList;

=head1 DESCRIPTION

This module defines L<ScormCloud> API methods in the "registration"
namespace.  See L<ScormCloud> for more info.

=cut

requires 'process_request';

=head1 METHODS

=head2 getRegistrationList

Returns an arrayref containing a list of registrations.
The returned list might be empty.

=cut

sub getRegistrationList
{
    my ($self) = @_;

    return $self->process_request(
        {method => 'registration.getRegistrationList'},
        sub {
            my ($response) = @_;

            my $registrationlist = $response->{registrationlist};
            if ($registrationlist->{courseid})
            {
                return [$registrationlist];    # single item
            }
            else
            {
                my @list = ();
                foreach my $id (keys %{$registrationlist})
                {
                    $registrationlist->{$id}->{id} = $id;
                    push @list, delete $registrationlist->{$id};
                }
                return \@list;
            }
        },
        {xml_parser => {GroupTags => {'registrationlist' => 'registration'}}}
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

    perldoc ScormCloud::API::Registration

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

