=head1 NAME

 WWW::SPB - fetch and report information from the Slackware Package Browser

=head1 DESCRIPTION

  This simple module is capable to query to the Slackware
  Package Browser in various ways.

=cut

package WWW::SPB;

use strict;
use warnings;

use vars qw( $VERSION );
$VERSION = '2.0';

use Exporter;

our @ISA    = qw(Exporter); 
our @EXPORT = qw(get files packages info versions);

require "WWW/SPB/get.pm";
require "WWW/SPB/search.pm";
require "WWW/SPB/package.pm";
require "WWW/SPB/versions.pm";

=head1 SYNOPSIS

 use WWW::SPB;

 @files = files($pattern [, $slackware_version])
 @package = packages($pattern [, $slackware_version])
 %info = info($package [, $slackware_version])
 get($package, $version)

=head1 WEB RESOURCES

 http://dfa.slackware.it/Spb.html
 http://packages.slackware.it

=head1 SEE ALSO

 spb(1)

=head1 AUTHOR

 Davide Angelocola <davide.angelocola@gmail.com>

=head1 COPYRIGHT

 Copyright (C), 2006 Davide Angelocola <davide.angelocola@gmail.com>

 This program is free software; you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation; either version 2 of the License, or
 any later version.

 This program is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.

 You should have received a copy of the GNU General Public License
 along with this program; if not, write to the Free Software
 Foundation, Inc., 51 Franklin St, Fifth Floor, Boston,
 MA 02110-1301 USA

=cut

