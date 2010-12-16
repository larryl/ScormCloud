package ScormCloud::API::Course;

use Moose::Role;

with 'ScormCloud::API';

=head1 NAME

ScormCloud::API::Course - ScormCloud API "course" namespace

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

    print "Found a course\n" if $ScormCloud->courseExists('123');

    my $course_list = $ScormCloud->getCourseList;

=head1 DESCRIPTION

This module defines L<ScormCloud> API methods in the "course"
namespace.  See L<ScormCloud> for more info.

=cut

use Carp;

requires 'process_request';

=head1 METHODS

=head2 courseExists ( I<course_id> )

Given a course ID, returns true if that course exists.

=cut

sub courseExists
{
    my ($self, $course_id) = @_;

    croak "Missing course_id" unless $course_id;

    return $self->process_request(
        {method => 'course.exists', courseid => $course_id},
        sub {
            my ($response) = @_;

            return $response->{result} eq 'true' ? 1 : 0;
        }
    );
}

=head2 getMetadata ( I<course_id> )

Given a course ID, returns course metadata.

=cut

sub getMetadata
{
    my ($self, $course_id) = @_;

    croak "Missing course_id" unless $course_id;

    return $self->process_request(
        {method => 'course.getMetadata', courseid => $course_id},
        sub {
            my ($response) = @_;

            return ref($response->{package}) eq 'HASH'
              ? $response->{package}
              : undef;
        }
    );
}

=head2 getCourseList

Returns an arrayref containing a list of courses.
The returned list might be empty.

=cut

sub getCourseList
{
    my ($self) = @_;

    return $self->process_request(
        {method => 'course.getCourseList'},
        sub {
            my ($response) = @_;

            my $courselist = $response->{courselist};
            if ($courselist->{title})
            {
                return [$courselist];    # single item
            }
            else
            {
                my @list = ();
                foreach my $id (keys %{$courselist})
                {
                    $courselist->{$id}->{id} = $id;
                    push @list, delete $courselist->{$id};
                }
                return \@list;
            }
        },
        {xml_parser => {GroupTags => {'courselist' => 'course'}}}
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

    perldoc ScormCloud::API::Course

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

