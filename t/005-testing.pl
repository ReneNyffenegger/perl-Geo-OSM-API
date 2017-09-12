#!/usr/bin/perl
use warnings;
use strict;

use Test::Simple tests => 3;
use Test::More;

use Geo::OSM::API;

my $osm_api = Geo::OSM::API->new();

is('http://api.openstreetmap.org/', $osm_api->_url_api);

$osm_api->testing(1);
is('http://master.apis.dev.openstreetmap.org/', $osm_api->_url_api);

$osm_api->testing(0);
is('http://api.openstreetmap.org/', $osm_api->_url_api);
