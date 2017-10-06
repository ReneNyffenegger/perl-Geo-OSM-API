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


# print $osm_api->create_way(qq{
#   <way changeset="$changeset_id">  
#     <tag k="note" v="tq84 way"/>
#     <nd ref="4307076618" />
#     <nd ref="4307076620" />
#   </way>
# }
# );

print $osm_api->delete_way($changeset_id, 4303826678);

print $osm_api->close_changeset($changeset_id), "\n";


