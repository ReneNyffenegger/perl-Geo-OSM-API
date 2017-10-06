#!/usr/bin/perl
use strict;
use warnings;
use utf8;

use Test::Simple tests => 1;
use Test::More;

use Geo::OSM::API;

my $osm_api = Geo::OSM::API->new();


$osm_api -> testing(1);
$osm_api->authenticate($ENV{TQ84_OSM_USERNAME_TEST}, $ENV{TQ84_OSM_PW_TEST});

print "bla\n";

my $todo = $osm_api->permissions;

ok(1)
