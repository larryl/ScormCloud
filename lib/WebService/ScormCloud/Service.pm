package WebService::ScormCloud::Service;

use Moose::Role;

=head1 NAME

WebService::ScormCloud::Service - ScormCloud API base class

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

    print "Service is alive\n" if $ScormCloud->ping;

    print "Auth is valid\n"    if $ScormCloud->authPing;

=head1 DESCRIPTION

This module defines L<WebService::ScormCloud> shared API methods.
See L<WebService::ScormCloud> for more info.

=cut

use Carp;
use Data::Dump 'dump';
use Digest::MD5 qw(md5_hex);
use HTTP::Request::Common;
use POSIX qw(strftime);
use Try::Tiny;
use XML::Simple;

=head1 METHODS

=head2 request ( I<params> [ , I<args> ] )

Make an API request:

    my $parsed_response_data =
      $ScormCloud->request(method => 'rustici.debug.authPing');

Note that you would not typically call this method directly - use
the API methods defined in the L</API CLASSES> instead.

=cut

sub request
{
    my ($self, $params, $args) = @_;

    $params                  ||= {};
    $args                    ||= {};
    $args->{request_method}  ||= 'GET';
    $args->{request_headers} ||= {};
    $args->{xml_parser}      ||= {};

    croak 'No method' unless $params->{method};

    my $top_level_namespace = $self->top_level_namespace;
    unless ($params->{method} =~ /^$top_level_namespace[.]/)
    {
        $params->{method} = $top_level_namespace . '.' . $params->{method};
    }

    $params->{appid} ||= $self->app_id;

    $params->{ts} ||= strftime '%Y%m%d%H%M%S', gmtime;

    my $sig = join '', map { $_ . $params->{$_} } sort keys %{$params};
    $params->{sig} = md5_hex($self->secret_key . $sig);

    my $uri = $self->service_url->clone;
    $uri->query_form($params);

    $self->_dump_data($uri . '') if $self->dump_request_url;

    my %request_args = %{$args->{request_headers}};
    if ($args->{request_content})
    {
        $request_args{Content_Type} = 'form-data';
        $request_args{Content}      = $args->{request_content};
    }

    my $request;
    {
        no strict 'refs';
        $request = $args->{request_method}->($uri, %request_args);
    }

    my $response = $self->lwp_user_agent->request($request);

    my $response_data = undef;

    if ($response->is_success)
    {
        try
        {
            $self->_dump_data($response->content) if $self->dump_response_xml;

            $response_data =
              XML::Simple->new->XMLin(
                                      $response->content,
                                      KeyAttr       => [],
                                      SuppressEmpty => '',
                                      %{$args->{xml_parser}}
                                     );

            # Response data should always include "stat".  Make sure it
            # exists, so callers can safely assume it is always there:
            #
            $response_data->{stat} ||= 'fail';

            # If response status is "fail", make sure "err" always
            # exists:
            #
            if ($response_data->{stat} eq 'fail')
            {
                $response_data->{err} ||= {
                                           code => 9999,
                                           msg  => 'FAIL STATUS BUT NO ERR',
                                          };
            }
        }
        catch
        {
            my $msg = 'XML PARSE FAILURE: ' . $_;

            croak $msg if $self->die_on_bad_response;

            $response_data = {
                              stat => 'fail',
                              err  => {code => 9999, msg => $msg},
                             };
        };
    }
    else
    {
        my $msg = 'BAD HTTP RESPONSE: ' . $response->status_line;

        croak $msg if $self->die_on_bad_response;

        $response_data = {
                          stat => 'fail',
                          err  => {code => 9999, msg => $msg},
                         };
    }

    $self->_dump_data($response_data) if $self->dump_response_data;

    return $response_data;
}

sub _dump_data
{
    my ($self, $data) = @_;

    print '=' x 40, "\n", dump($data), "\n", '=' x 40, "\n";
}

=head2 process_request ( I<params>, I<callback> )

Make an API request, and return desired data out of the response.

Input arguments are:

=over 4

=item params

A hashref of API request params.  At minimum must include "method".

=item callback

A callback function that extracts and returns the desired data from
the response data.  The callback should expect a single argument
"response" which is the parsed XML response data.

=item args

An optional hashref of arguments to modify the request.

=back

=cut

sub process_request
{
    my ($self, $params, $callback, $args) = @_;

    croak 'Missing request params' unless $params;
    croak 'Missing callback'       unless $callback;

    my $response = $self->request($params, $args);

    my $data = undef;

    if ($response->{stat} eq 'ok')
    {
        try
        {
            $data = $callback->($response);
        };
    }

    unless (defined $data)
    {
        confess 'Invalid API response data' if $self->die_on_bad_response;
    }

    $self->_dump_data($data) if $self->dump_api_results;

    return $data;
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

    perldoc WebService::ScormCloud::Service

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

