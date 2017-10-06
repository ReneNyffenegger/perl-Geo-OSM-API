#!/usr/bin/perl
use warnings;
use strict;

use Test::Simple tests => 1;
use Test::More;

use Geo::OSM::API;

my $osm_api = Geo::OSM::API->new();
$osm_api->testing($ENV{TQ84_OSM_TESTING});
$osm_api->authenticate($ENV{TQ84_OSM_USERNAME}, $ENV{TQ84_OSM_PW});


my $preferences = $osm_api->user_preferences;

ok($preferences->{user_id});
