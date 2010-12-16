package ScormCloud::API::Reporting;

use Moose::Role;

with 'ScormCloud::API';

=head1 NAME

ScormCloud::API::Reporting - ScormCloud API "reporting" namespace

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

    my $account_info = $ScormCloud->getAccountInfo;

    print "The contact email for "
      . $account_info->{company} . " is "
      . $account_info->{email} . "\n";

    print "There are "
      . $account_info->{usage}->{totalcourses}
      . " courses and "
      . $account_info->{usage}->{totalregistrations}
      . " registrations available.\n";

=head1 DESCRIPTION

This module defines L<ScormCloud> API methods in the "course"
namespace.  See L<ScormCloud> for more info.

=cut

requires 'process_request';

=head1 METHODS

=head2 getAccountInfo

Return a hashref containing account info.
The hash might be empty in case of failure.

=cut

sub getAccountInfo
{
    my ($self) = @_;

    return $self->process_request(
        {method => 'reporting.getAccountInfo'},
        sub {
            my ($response) = @_;

            return $response->{account};
        }
    );
}

1;

=head1 SEE ALSO

L<ScormCloud>

__END__

=head1 AUTHOR

Larry Leszczynski, C<< <larryl at cpan.org> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-scormcloud at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=ScormCloud>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc ScormCloud::API::Reporting

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

