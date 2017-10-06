#!/usr/bin/perl
use warnings;
use strict;

use Test::Simple tests => 3;
use Test::More;

use Geo::OSM::API;

my $osm_api = Geo::OSM::API->new();

is('https://api.openstreetmap.org/', $osm_api->_url_api);

$osm_api->testing(1);
is('https://master.apis.dev.openstreetmap.org/', $osm_api->_url_api);

$osm_api->testing(0);
is('https://api.openstreetmap.org/', $osm_api->_url_api);
