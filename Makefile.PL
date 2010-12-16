use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'ScormCloud',
    AUTHOR              => q{Larry Leszczynski <larryl@cpan.org>},
    VERSION_FROM        => 'lib/ScormCloud.pm',
    ABSTRACT_FROM       => 'lib/ScormCloud.pm',
    ($ExtUtils::MakeMaker::VERSION >= 6.3002
      ? ('LICENSE'=> 'perl')
      : ()),
    PL_FILES            => {},
    PREREQ_PM => {
        'Test::More' => 0,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'ScormCloud-*' },
);
