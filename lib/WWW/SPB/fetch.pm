# fetch.pm -- download html pages
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

use LWP;

sub fetch {
  my ($url) = @_;
  my $response;

  $response = LWP::UserAgent->new->get($url);
  return $response->status_line unless $response->is_success;
  return $response->content;
}

1;
