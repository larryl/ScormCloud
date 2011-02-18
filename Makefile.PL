use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME          => 'WebService::ScormCloud',
    AUTHOR        => q{Larry Leszczynski <larryl@cpan.org>},
    VERSION_FROM  => 'lib/WebService/ScormCloud.pm',
    ABSTRACT_FROM => 'lib/WebService/ScormCloud.pm',
    ($ExtUtils::MakeMaker::VERSION >= 6.3002 ? ('LICENSE' => 'perl') : ()),
    PL_FILES  => {},
    PREREQ_PM => {
                  'Carp'                         => 0,
                  'Data::Dump'                   => 0,
                  'Digest::MD5'                  => 0,
                  'ExtUtils::MakeMaker'          => 0,
                  'File::Spec'                   => 0,
                  'HTTP::Request::Common'        => 0,
                  'LWP::UserAgent'               => 0,
                  'Moose::Role'                  => 0,
                  'Moose::Util::TypeConstraints' => 0,
                  'Moose'                        => 0,
                  'POSIX'                        => 0,
                  'Readonly'                     => 0,
                  'Test::Exception'              => 0,
                  'Test::More'                   => 0,
                  'Try::Tiny'                    => 0,
                  'URI'                          => 0,
                  'XML::Simple'                  => 0,
                 },
    dist  => {COMPRESS => 'gzip -9f', SUFFIX => 'gz'},
    clean => {FILES    => 'ScormCloud-*'},
             );
