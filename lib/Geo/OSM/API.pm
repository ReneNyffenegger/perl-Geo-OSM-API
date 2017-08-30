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
sub _request { #_{
#_{ POD

=head2 _request 

    $self->_request('PUT', 'capabilities', {no_version=>1});
    $self->_request('PUT', 'map?bbox=$left,$bottom,$right,$top');
    … etc …

=cut

#_}

  my $self   = shift;
  my $method = shift;
  my $path   = shift;
  my $opts   = shift;


  my $version = '0.6/';
  if ($opts and $opts->{no_version}) {
    $version = '';
  }

  croak "Unsupported method $method" unless $method eq 'GET' or $method eq 'PUT';

  my $url = "http://api.openstreetmap.org/api/$version${path}";

  my $req = HTTP::Request->new($method => $url) or croak;

  my $res = $self->{ua}->request($req) or croak;

  croak "$url caused status " . $res->status_line unless $res->code == 200;

  return $res->content;

} #_}
sub capabilities_ { #_{
#_{ POD

=head2 capabilities_ 

    TODO

=cut

#_}

  my $self = shift;

  return $self;

} #_}
sub capabilities { #_{
#_{ POD

=head2 new

    my $osm_api = Geo::OSM::API->new($username, $password);

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
