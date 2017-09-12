#!/usr/bin/perl
use warnings;
use strict;

use Test::Simple tests => 1;
use Test::More;

use Geo::OSM::API;

my $osm_api = Geo::OSM::API->new();


if (1) {
  $osm_api->testing(1);
  $osm_api->authenticate($ENV{TQ84_OSM_USERNAME_TEST} . 'x', $ENV{TQ84_OSM_PW_TEST});
}
else {
  $osm_api->authenticate($ENV{TQ84_OSM_USERNAME}, $ENV{TQ84_OSM_PW});
}


print $osm_api->user_details;

ok('TODO');
