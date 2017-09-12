#!/usr/bin/perl
use strict;
use warnings;

use Test::Simple tests => 1;
use Test::More;

use Geo::OSM::API;

my $osm_api = Geo::OSM::API->new();

my $lon_left   =  7.67394;
my $lat_bottom = 45.98071;
my $lon_right  =  7.68022;
my $lat_top    = 45.98332;

my $todo = $osm_api->bounding_box_notes($lon_left, $lat_bottom, $lon_right, $lat_top);

print $todo;

ok('TODO');
