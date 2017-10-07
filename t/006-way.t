#!/usr/bin/perl
use warnings;
use strict;

use Test::Simple tests => 1;
use Test::More;

use Geo::OSM::API;

my $osm_api = Geo::OSM::API->new();

$osm_api->testing(1);
print $osm_api->get_way(4303648993);

ok('TODO');
