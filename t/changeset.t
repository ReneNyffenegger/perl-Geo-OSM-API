#!/usr/bin/perl
use strict;
use warnings;

use Test::Simple tests => 1;
use Test::More;

use Geo::OSM::API;

my $osm_api = Geo::OSM::API->new();
$osm_api->testing(1);
$osm_api->authenticate($ENV{TQ84_OSM_USERNAME_TEST}, $ENV{TQ84_OSM_PW_TEST});


my $changeset_id = $osm_api -> create_changeset('t/changeset.t');
print "changeset_id = $changeset_id\n";



print $osm_api->close_changeset($changeset_id), "\n";


