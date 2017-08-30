#!/usr/bin/perl
use strict;
use warnings;

use Test::Simple tests => 5;
use Test::More;

use Geo::OSM::API;

my $osm_api = Geo::OSM::API->new();
my $capabilities = $osm_api->capabilities();

is('0.25'   , $capabilities->{area_maximum   }, 'area_maximum'   );
is('300'    , $capabilities->{timeout_seconds}, 'timeout seconds');
is('online' , $capabilities->{status_database}, 'status database');
is('online' , $capabilities->{status_api     }, 'status api'     );
is('online' , $capabilities->{status_gpx     }, 'status gpx'     );
