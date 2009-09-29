# search.pm -- PB's search.php interface
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

use constant SEARCH_URL     => 'http://packages.slackware.it/search.php';
use constant SEARCH_PARAMS  => '?v=%s&t=%s&q=%s';
use constant SEARCH_PACKAGE => 1;
use constant SEARCH_FILE    => 2;

sub search_query {
  my ($item, $version, $type, $index) = @_;
  my $params;

  $params = sprintf(SEARCH_PARAMS, $version, $type,  $item);
  $params .= "&p=$index" if defined $index;
  return fetch(SEARCH_URL . $params);
}

sub get_packages {
  my @packages;

  foreach ($_[0]->find_by_attribute('class', 'result')) {
    my ($name, $category) = split /in /,
      $_->find_by_attribute('class', 'pkgtitle')->as_text;
    push @packages, "$category/$name";
  }

  return @packages;
}

sub get_all_packages {
  my $page;
  my $root;
  my @packages;

  $page = search_query(@_);
  return "spb: unknown Slackware version '$_[1]'"
    if $page =~ /no version/;

  $root = HTML::TreeBuilder->new->parse($page);
  @packages = get_packages($root);

  # get other pages, if needed...
  my $last = 1;
  foreach ($root->find_by_tag_name('select')) {
    next if $_->attr('name') ne 'p';
    my @options = $_->find_by_tag_name('option');
    $last = $options[-1]->as_text if $#options > 1;
    last;
  }

  for (my $i = 2; $i <= $last; $i++) {
    push @packages, 
      get_packages(HTML::TreeBuilder->new->parse(search_query(@_, $i)));
  }

  return @packages;
}

sub files {
  return get_all_packages(@_, SEARCH_FILE);
}

sub packages {
  return get_all_packages(@_, SEARCH_PACKAGE);
}

1;
