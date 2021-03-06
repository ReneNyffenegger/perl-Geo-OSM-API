# Encoding and name

=encoding utf8
=head1 NAME
Geo::OSM::API

Encapsulate the Open Street Map API for Perl scripts.

=cut
#
package Geo::OSM::API;

use warnings;
use strict;

use utf8;
use Carp;
use Encode;

use LWP::UserAgent;
use HTTP::Request;
use XML::XPath;

our $VERSION = 0.01;
#_{ Synopsis

=head1 SYNOPSIS
    use Geo::OSM::API;
=cut
#_}
#_{ Methods

=head1 METHODS
=cut

sub new { #_{
#_{ POD

=head2 new

    my $osm_api = Geo::OSM::API->new();

=cut

#_}

  my $class    = shift;

  my $self = {};
  bless $self, $class;
  croak "Wrong class $class" unless $self->isa('Geo::OSM::API');

  $self->{ua} = LWP::UserAgent->new();

  return $self;

} #_}
sub authenticate { #_{
#_{ POD

=head2 authenticate

    $osm_api->authenticate('username', 'password');

=cut

#_}

  my $self     = shift;
  my $username = shift;
  my $password = shift;

  $self->{ua}->credentials($self->_server_api . ':443', 'Web Password', $username => $password); # or croak "Could not authenticate $username";

} #_}
sub user_details { #_{
#_{ POD

=head2 user_details

    my $user_details = $osm_api->user_details;

    printf("user id        : %d\n", $user_prefs->{user_id});
    printf("changeset count: %d\n", $user_prefs->{changeset_count});

Return preferences of the logged in user.

B<TODO> finish me!

=cut

#_}
  
  my $self = shift;
  my $answer = $self->_request('GET', '/user/details');

  my $xp = XML::XPath->new(xml=>$answer);

  my $ret = {};

  $ret->{user_id        } = $xp->findvalue('/osm/user/@id');
  $ret->{changeset_count} = $xp->findvalue('/osm/changeset/@count');

  return $ret;

} #_}
sub user_preferences { #_{
#_{ POD

=head2 user_preferences

    my $user_prefs = $osm_api->user_preferences;


=cut


#_}
  
  my $self = shift;
  my $answer = $self->_request('GET', '/user/preferences');

# my $xp = XML::XPath->new(xml=>$answer);

  return $answer;


} #_}
sub testing { #_{
#_{ POD

=head2 testing

    $osm_api->testing(1);
    $osm_api->testing(0);

In order to test something, C<< $osm_api->testing(1) >> should be called so that the API is resolved against
L<https://master.apis.dev.openstreetmap.org/> rather than L<https://api.openstreetmap.org/>.

=cut

#_}

  my $self          = shift;
  my $testing       = shift;

  croak unless defined $testing;

  $self->{testing}  = $testing;

} #_}
sub capabilities { #_{
#_{ POD

=head2 capabilities


    my $capabilities = $osm_api -> capabilities;

    print $capabilities -> {version_minumum            };
    print $capabilities -> {version_maximum            };
    print $capabilities -> {area_maximum               };
    print $capabilities -> {note_area                  };
    print $capabilities -> {tracepoints_per_page       };
    print $capabilities -> {waynodes_maximum           };
    print $capabilities -> {changesets_maximum_elements};
    print $capabilities -> {timeout_seconds            };
    print $capabilities -> {status_database            };
    print $capabilities -> {status_api                 };
    print $capabilities -> {status_gpx                 };

=cut

#_}

  my $self = shift;

  my $answer = $self->_request('GET', 'capabilities', {no_version=>1});

  my $xp = XML::XPath->new(xml=>$answer);

  my $ret = {};

  $ret -> {version_minumum            } = $xp->findvalue('/osm/api/version/@minimum'            );
  $ret -> {version_maximum            } = $xp->findvalue('/osm/api/version/@maximum'            );
  $ret -> {area_maximum               } = $xp->findvalue('/osm/api/area/@maximum'               );
  $ret -> {note_area                  } = $xp->findvalue('/osm/api/note/@maximum'               );
  $ret -> {tracepoints_per_page       } = $xp->findvalue('/osm/api/tracepoints/@per_page'       );
  $ret -> {waynodes_maximum           } = $xp->findvalue('/osm/api/waynodes_maximum'            );
  $ret -> {changesets_maximum_elements} = $xp->findvalue('/osm/api/changesets/@maximum_elements');
  $ret -> {timeout_seconds            } = $xp->findvalue('/osm/api/timeout/@seconds'            );
  $ret -> {status_database            } = $xp->findvalue('/osm/api/status/@database'            );
  $ret -> {status_api                 } = $xp->findvalue('/osm/api/status/@api'                 );
  $ret -> {status_gpx                 } = $xp->findvalue('/osm/api/status/@gpx'                 );

  return $ret;
} #_}
sub permissions { #_{
#_{ POD

=head2 permissions


    my $permissions = $osm_api -> permissions;


=cut

#_}

  my $self = shift;

  my $answer = $self->_request('GET', 'permissions');

  print $answer;

  my $xp = XML::XPath->new(xml=>$answer);

  my $ret = {};


  return $ret;
} #_}
sub bounding_box { #_{
#_{ POD

=head2 bounding_box

    my $lon_left   =  7.67394;
    my $lat_bottom = 45.98071;
    my $lon_right  =  7.68022;
    my $lat_top    = 45.98332;

    my … = $osm_api->bounding_box($lon_left, $lat_bottom, $lon_right, $lat_top);

=cut

#_}

  my $self = shift;

  my $lon_left   = shift;
  my $lat_bottom = shift;
  my $lon_right  = shift;
  my $lat_top    = shift;

  croak "wrong coordinates" unless _check_bbox_coordinates($lon_left, $lat_bottom, $lon_right, $lat_top);

# TODO …
  my $answer = $self->_request('GET', "map?bbox=$lon_left,$lat_bottom,$lon_right,$lat_top");

  return $answer;
} #_}
sub bounding_box_notes { #_{
#_{ POD

=head2 bounding_box_notes

    my $lon_left   =  7.67394;
    my $lat_bottom = 45.98071;
    my $lon_right  =  7.68022;
    my $lat_top    = 45.98332;

    my … = $osm_api->bounding_box_notes($lon_left, $lat_bottom, $lon_right, $lat_top);

=cut

#_}

  my $self = shift;

  my $lon_left   = shift;
  my $lat_bottom = shift;
  my $lon_right  = shift;
  my $lat_top    = shift;

  croak "wrong coordinates" unless _check_bbox_coordinates($lon_left, $lat_bottom, $lon_right, $lat_top);

# TODO …
  my $answer = $self->_request('GET', "notes?bbox=$lon_left,$lat_bottom,$lon_right,$lat_top");

  return $answer;
} #_}
sub get_primitive { #_{
#_{ POD

=head2 get_primitive

    my way = $osm_api->primitive('way', 4303648993);

Gets the given primitive (here: C<< 'way' >>) with the given id (here: C<< 4303648993 >>).

=cut

#_}

  my $self      = shift;
  my $primitive = shift;
  my $id        = shift;

  _check_primitive($primitive);

  my $answer = $self->_request('GET', "$primitive/$id");
  return $answer;

} #_}
sub get_way { #_{
#_{ POD

=head2 get_way

    my way = $osm_api->get_way(4303648993);

=cut

#_}

  my $self   = shift;
  my $way_id = shift;

  return $self->get_primitive('way', $way_id);

# TODO …
# my $answer = $self->_request('GET', "way/$way_id");

# return $answer;
} #_}
sub create_changeset { #_{
#_{ POD

=head2 create_changeset

    my changeset_id = $osm_api->create_changeset($comment);

    $osm-api->create_node    ($changeset_id, …);
    $osm_api->create_way     ($changeset_id, …);
    $osm_api->create_relation($changeset_id, …);

    $osm-api->delete_node    ($changeset_id, …);
    $osm_api->delete_way     ($changeset_id, …);
    $osm_api->delete_relation($changeset_id, …);

    $osm_api->close_changeset($changeset_id);

=cut

#_}

  my $self    = shift;
  my $comment = shift;

  my $who_am_I = _who_am_I();

# TODO …
  my $answer = $self->_request('PUT', "changeset/create", 
    {xml=> "<changeset>
  <tag k='created_by' v='$who_am_I' />
  <tag k='comment' v='$comment' />
</changeset>" });

  return $answer;
} #_}
sub close_changeset { #_{
#_{ POD

=head2 close_changeset

    my changeset_id = $osm_api->create_changeset;

    $osm_api->close_changeset($changeset_id);

Close the changeset that was created with L</create_changeset>.

=cut

#_}

  my $self         = shift;
  my $changeset_id = shift;

  croak "id of changeset needed" unless $changeset_id;


# TODO …
  my $answer = $self->_request('PUT', "changeset/$changeset_id/close", {xml=> "<changeset></changeset>" });

} #_}

sub create_node { #_{
#_{ POD

=head2 create_node

    my changeset_id = $osm_api->create_changeset($comment);

    $osm-db->create_node($changeset_id,
      $lat, $lon

=cut

#_}
  my $self         = shift;
  my $changeset_id = shift;
  my $lat          = shift;
  my $lon          = shift;
  my $key_val_ref  = shift; # TODO!

  my $xml  = XML::XPath->new(xml=>'<node/>');
  my ($node) = $xml->findnodes('/node');


  _xml_node_add_attribute($node, 'changeset', $changeset_id);
  _xml_node_add_attribute($node, 'lat'      , $lat         );
  _xml_node_add_attribute($node, 'lon'      , $lon         );

  my $answer = $self->_request('PUT', "node/create", {xml=> $xml->findnodes_as_string('/') });
  return $answer; # new node id

} #_}
sub create_way { #_{
#_{ POD

=head2 create_way

    …

=cut

#_}

  my $self = shift;
  my $xml  = shift;


# TODO …
  my $answer = $self->_request('PUT', "way/create", {xml=> $xml });

} #_}
sub delete_primitive { #_{

  my $self         = shift;
  my $primitive    = shift;
  my $changeset_id = shift;
  my $id           = shift;

  _check_primitive($primitive);

  my $answer = $self->get_primitive($primitive, $id);

  my $xp = XML::XPath->new(xml=>$answer);

  my $version = $xp->findvalue("/osm/$primitive/\@version");

  my $xml = qq{<$primitive id="$id" changeset="$changeset_id" version="$version" />};


  $answer = $self->_request('DELETE', "$primitive/$id", {xml=> $xml });
  return $answer;

} #_}
sub delete_node { #_{
#_{ POD

=head2 delete_node

    …

=cut

#_}

  my $self         = shift;
  my $changeset_id = shift;
  my $id           = shift;

  $self->delete_primitive('node', $changeset_id, $id);


} #_}
sub delete_way { #_{
#_{ POD

=head2 delete_way

    …

=cut

#_}

  my $self         = shift;
  my $changeset_id = shift;
  my $id           = shift;

  my $answer = $self->get_way($id);

  my $xp = XML::XPath->new(xml=>$answer);

  my $version = $xp->findvalue('/osm/way/@version');

  my $xml = qq{<way id="$id" changeset="$changeset_id" version="$version" />};


# TODO …
  $answer = $self->_request('DELETE', "way/$id", {xml=> $xml });
  return $answer;

} #_}

sub set_tag { #_{
#_{ POD

=head2 set_tag

    $osm_api->set_tag('way', 'name', 'foo');

=cut

#_}
  
  my $self         = shift;
  my $changeset_id = shift;
  my $primitive    = shift;
  my $primitive_id = shift;
  my $key          = shift;
  my $val          = shift;

  _check_primitive($primitive);

  my $answer = $self->get_primitive($primitive, $primitive_id);
  my $xp = XML::XPath->new(xml=>$answer);

  $xp->setNodeText("/osm/$primitive/tag[\@k='$key']/\@v", $val);
  $xp->setNodeText("/osm/$primitive/\@changeset", $changeset_id);

  my ($primitive_xml) = $xp->findnodes("/osm/$primitive");

# print $primitive_xml-> toString();

# my $primitive_xml = $xp->getNodeValu
# print $answer;
# my $version = $xp->findvalue('/osm/way/@version');
#

# $xp->setNodeText('/osm/
# my $val_of_key = $xp->findvalue("/osm/way/t

#   if ($primitive eq 'way') {
# #   my $version = $xp->findvalue("/osm/$primitive/\@version");
#   }
#   else {
#     die "Implement $primitive in set_tag";
#   }

#   my $xml = sprintf(
# qq{<!-- <osmChange version="%s" generator="%s"> -->
# <modify>
#   <$primitive id="$primitive_id" changeset="$changeset_id" version="$version">
#     <tag k="$key" v="$val" />
# 
#   </$primitive>
# </modify>
# <!--  </osmChange> -->
#   },
#   _version(),
#   _who_am_I()
#   );
# 
# 
 
    print "Calling _request\n";
    $self->_request('POST', "changeset/$changeset_id/upload", {xml_change => '<modify>' . $primitive_xml->toString() . '</modify>' });

} #_}
sub _xml_node_add_attribute {
#_{ POD

=head2 _xml_node_add_attribute

    …

=cut

  my $node      = shift;
  my $attr_name = shift;
  my $attr_val  = shift;

  my $attr = XML::XPath::Node::Attribute->new($attr_name, $attr_val);
  $node->appendAttribute($attr);

#_}

}
sub _request { #_{
#_{ POD

=head2 _request 

    $self->_request('GET', 'capabilities', {no_version=>1});
    $self->_request('GET', 'map?bbox=$left,$bottom,$right,$top');

    $self->_request('PUT', 'changeset/create', {xml=> '...'});

    $self->_request('PUT', '...'             , {xml_change=> '...');
    … etc …

Use the C<< xml_change=>1 >> option pass xml with an C<< <osmChange> … </osmChange> >> xml structure.

=cut

#_}

  my $self   = shift;
  my $method = shift;
  my $path   = shift;
  my $opts   = shift;


  my $version = _version() . '/';
  if ($opts and $opts->{no_version}) {
    $version = '';
  }

  croak "Unsupported method $method" unless grep { $method eq $_ } qw(GET PUT DELETE POST);

  my $url = $self->_url_api . "api/$version${path}";

  my $req = HTTP::Request->new($method => $url) or croak;

  if (exists $opts->{xml_change}) {
    $req->content_type('text/xml');
    $req->content(encode("utf8", "<osmChange>$opts->{xml_change}</osmChange>"));
  }
  if (exists $opts->{xml}) {
    $req->content_type('text/xml');
    $req->content(encode("utf8", "<osm>$opts->{xml}</osm>"));
  }

  my $res = $self->{ua}->request($req) or croak;

  return $res->content           if $res->code == 200;
  croak "User is not authorized" if $res->code == 401;

  croak "$method $url caused status " . $res->status_line . " [" . $res->content . "]" unless $res->code == 200;


} #_}
sub _server_api { #_{
#_{ POD

=head2 _server_api

    $self->testing(…);
    …
    my $server = $self->_server_api();

If testing was enabled with C<< $self->testing(1) >>, this method returns C<master.apis.dev.openstreetmap.org>.
Otherwise, it returns C<api.openstreetmap.org>.

=cut

#_}
  
  my $self = shift;

  return 'master.apis.dev.openstreetmap.org' if $self->{testing};
  return 'api.openstreetmap.org';

} #_}
sub _url_api { #_{
#_{ POD

=head2 _url_api

    $self->testing();
    …
    my $url = $self->_url_api();

If testing was enabled with C<< $self->testing(1) >>, this method returns C<https://master.apis.dev.openstreetmap.org/>.
Otherwise, it returns C<https://api.openstreetmap.org/>.

=cut

#_}
  
  my $self   = shift;
  my $server = $self->_server_api;

  return "https://${server}/" if $self->{testing};
  return "https://${server}/";

} #_}
sub _check_bbox_coordinates { #_{
#_{ POD

=head2 _check_bbox_coordinates

    croak … unless Geo::OSM::API::_check_bbox_coordinates(
      $lon_left,
      $lat_bottom,
      $lon_right,
      $lat_top
    );

Apparently, OSM is very picky obout the the right ordering of the left/right and top/bottom coordinates in bounding boxes (L</bounding_box>, L</bounding_box_notes>).
This method checks if these are correct.

=cut

#_}
  

  my $lon_left   = shift;
  my $lat_bottom = shift;
  my $lon_right  = shift;
  my $lat_top    = shift;

  return 0 if $lon_left    >= $lon_right;
  return 0 if $lat_bottom  >= $lat_top;
  return 1;

} #_}
sub _check_primitive { #_{
#_{ POD

=head2 _check_primitive

    my $primitive='node';

    croak … unless Geo::OSM::API::_check_primitive($primitive);


Checks wheather the passed primitive is C<< 'node' >>, C<< 'way' >>
or C<< 'relation' >>.

=cut

#_}

  my $primitive = shift;

  croak "unknown primitive $primitive" unless grep {$primitive eq $_ } qw(node way relation);

} #_}
sub _version { #_{
#_{ POD

=head2 _version


    my version =  Geo::OSM::API::_version;


Returns the version of the API, not the version of C<< Geo::OSM::API >>.

=cut

#_}

  return '0.6';

} #_}
sub _who_am_I { #_{
#_{ POD

=head2 _who_am_I

Returns a meaningful string, such as C<< Perl module Geo::OSM::API >>.

=cut

#_}

  return 'Perl module Geo::OSM::API';

} #_}

#_}
#_{ POD: Copyright

=head1 Copyright
Copyright © 2017 René Nyffenegger, Switzerland. All rights reserved.
This program is free software; you can redistribute it and/or modify it
under the terms of the the Artistic License (2.0). You may obtain a
copy of the full license at: L<http://www.perlfoundation.org/artistic_license_2_0>
=cut

#_}
#_{ POD: Source Code

=head1 Source Code

The source code is on L<< github|https://github.com/ReneNyffenegger/perl-Geo-OSM-API >>. Meaningful pull requests are welcome.

=cut

#_}
#_{ See also

=head1 See also

L<http://wiki.openstreetmap.org/wiki/User:GranD/API_Perl_example> was helpful.

=cut

#_}

'tq84';
