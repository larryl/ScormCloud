package ScormCloud::API::Debug;

use Moose::Role;

with 'ScormCloud::API';

=head1 NAME

ScormCloud::API::Debug - ScormCloud API "debug" namespace

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

    print "Service is alive\n" if $ScormCloud->ping;

    print "Auth is valid\n"    if $ScormCloud->authPing;

=head1 DESCRIPTION

This module defines L<ScormCloud> API methods in the "debug"
namespace.  See L<ScormCloud> for more info.

=cut

requires 'process_request';

=head1 METHODS

=head2 ping

Returns true if the API service is reachable.

=cut

sub ping
{
    my ($self) = @_;

    return $self->process_request(
        {method => 'debug.ping'},
        sub {
            my ($response) = @_;

            return ref($response->{pong}) eq 'HASH' ? 1 : 0;
        }
    );
}

=head2 authPing

Returns true if the API service is reachable, and both the
application ID and secret key are valid.

=cut

sub authPing
{
    my ($self) = @_;

    return $self->process_request(
        {method => 'debug.authPing'},
        sub {
            my ($response) = @_;

            return ref($response->{pong}) eq 'HASH' ? 1 : 0;
        }
    );
}

=head2 getTime

Returns the current time at the API service host.  The time is in
UTC and is formatted as "YYYYMMDDhhmmss".

=cut

sub getTime
{
    my ($self) = @_;

    return $self->process_request(
        {method => 'debug.getTime'},
        sub {
            my ($response) = @_;

            return $response->{currenttime}->{content};
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

    perldoc ScormCloud::API::Debug

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

