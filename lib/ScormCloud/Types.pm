package ScormCloud::Types;

use Moose::Util::TypeConstraints;

=head1 NAME

ScormCloud::Types - type definitions for L<ScormCloud>

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';

=head1 SYNOPSIS

    use ScormCloud::Types;

=cut

use LWP::UserAgent;
use URI;

=head2 TYPES

=head1 ScormCloud::Types::LWP::UserAgent

Subtype of L<LWP::UserAgent>.  Can be coerced from a string which
defines the C<$ua->agent>.

=cut

subtype 'ScormCloud::Types::LWP::UserAgent' => as 'LWP::UserAgent';

coerce 'ScormCloud::Types::LWP::UserAgent' => from 'Str' => via
{
    my $ua = LWP::UserAgent->new;
    $ua->agent($_);
    $ua;
};

=head1 ScormCloud::Types::URI

Subtype of L<URI>.  Can be coerced from a string representing the
URL.

=cut

subtype 'ScormCloud::Types::URI' => as 'URI';

coerce 'ScormCloud::Types::URI' => from 'Str' => via
{
    URI->new($_);
};

1;

__END__

=head1 AUTHOR

Larry Leszczynski, C<< <larryl at cpan.org> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-scormcloud at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=ScormCloud>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc ScormCloud::Types

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

