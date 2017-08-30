use 5.006;
use strict;
use warnings;

use ExtUtils::MakeMaker;

WriteMakefile(
    NAME             => 'Geo::OSM::API',
    AUTHOR           => q{René Nyffenegger <rene.nyffenegger@adp-gmbh.ch>},
    VERSION_FROM     => 'lib/Geo/OSM/API.pm',
#   ABSTRACT_FROM    => 'lib/Geo/OSM/API.pm',
    LICENSE          => 'artistic_2',
    PL_FILES         => {},
    MIN_PERL_VERSION => 5.006,
    CONFIGURE_REQUIRES => {
        'ExtUtils::MakeMaker' => 0,
    },
    PREREQ_PM => {
      'LWP::UserAgent'        => 0,
      'HTTP::Request'         => 0
    },
    BUILD_REQUIRES => {
        'Test::Simple' => 0,
#       'Test::More'   => 0,
    },
    dist  => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean => { FILES => 'Geo-OSM-SQLite-*' },
);

