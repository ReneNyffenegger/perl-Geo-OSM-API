#!/usr/bin/perl
use strict;
use warnings;

use Test::Simple tests => 8;
use Test::More;

use Geo::OSM::API;

my $osm_api = Geo::OSM::API->new();

$osm_api->testing(1);
$osm_api->authenticate($ENV{TQ84_OSM_USERNAME_TEST}, $ENV{TQ84_OSM_PW_TEST});


my $changeset_id = $osm_api -> create_changeset('t/changeset.t');
print "changeset_id = $changeset_id\n";

my $node_1 = $osm_api->create_node($changeset_id, 47.5338878, 8.5870243);
my $node_2 = $osm_api->create_node($changeset_id, 47.5339802, 8.5870404);
my $node_3 = $osm_api->create_node($changeset_id, 47.5339657, 8.5871852);
my $node_4 = $osm_api->create_node($changeset_id, 47.5338806, 8.5871691);

ok($node_1);
ok($node_2);
ok($node_3);
ok($node_4);

like($node_1, qr/^\d+$/);
like($node_2, qr/^\d+$/);
like($node_3, qr/^\d+$/);
like($node_4, qr/^\d+$/);

print $osm_api->close_changeset($changeset_id), "\n";

$changeset_id = $osm_api -> create_changeset('t/changeset.t');

print $osm_api->delete_node($changeset_id, $node_1);
print $osm_api->delete_node($changeset_id, $node_3);

print $osm_api->close_changeset($changeset_id), "\n";

# print $osm_api->create_way(qq{
#   <way changeset="$changeset_id">  
#     <tag k="note" v="tq84 way"/>
#     <nd ref="4307076618" />
#     <nd ref="4307076620" />
#   </way>
# }
# );

# print $osm_api->delete_way($changeset_id, 4303826678);



