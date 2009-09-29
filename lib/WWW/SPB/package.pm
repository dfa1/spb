# package.pm -- PB's package.php interface
# Copyright (C) 2006, Davide Angelocola <davide.angelocola@gmail.com>
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307,
# USA.

use strict;
use warnings;

use HTML::TreeBuilder;

require "WWW/SPB/fetch.pm";

use constant PACKAGE_URL       => 'http://packages.slackware.it/package.php';
use constant PACKAGE_PARAMS    => '?q=%s/%s';

sub package_query {
  return fetch(PACKAGE_URL . sprintf PACKAGE_PARAMS, $_[1], $_[0]);
}

sub mirrors {
  my @mirrors = ();

  my $page = package_query(@_);
  return @mirrors if $page =~ /Sorry/;

  my $root =
    HTML::TreeBuilder->new->parse($page)->find_by_attribute('id', 'pkgmirrors');

  foreach ($root->find_by_tag_name('a')) {
      my $url = $_->attr('href');
      push @mirrors, $url;
    }

  return @mirrors;
}

sub info {
  my $page = package_query(@_);
  my %info = ();

  return %info if $page =~ /Sorry/;

  my $root = HTML::TreeBuilder->new->parse($page);
  my $i = 0;			# to keep insertion order; avoid Tie::IxHash

  foreach ($root->find_by_attribute('id', 'pkghead')->find_by_tag_name('tr')) {
    my @row = $_->content_list;
    $_ = $_->as_text foreach (@row);
    $info{$i++} = sprintf "%-20s %s", $row[0], $row[1];
  }

  # $info{$i} = sprintf "%s\n %s", "description", $root->find_by_attribute('class', 'pkgdescr')->as_text;
  return %info;
}

1;
