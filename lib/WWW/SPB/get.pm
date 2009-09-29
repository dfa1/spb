# get.pm -- download packages
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

our $total_size;
our $final_data = "";
our $pid;
our $sigint_count = 0;
our $skip_mirror = 0;

sub get {
  my ($package, $version, $mirror) = @_;
  my @mirrors;

  @mirrors = mirrors($package, $version);
  return "package $package ($version) not found" unless @mirrors;

  # prepend user preferred mirror
  unshift @mirrors, $mirror if $mirror;

  $|++;				   # auto-flush

  foreach (@mirrors) {
    $skip_mirror = 0;
    next if $skip_mirror;
    last if $sigint_count == 3;
    next if /^ftp/;		# XXX: FTP support not implemented
    my @url = split /\//, $_;
    $url[0] =~  s/:$//;
    print "trying with $url[2] ($url[0])...\n";

    if ($pid = fork) {
      # parent catches INT and prepare for next download
      local $SIG{INT} =
	sub {
	  $final_data = "";
	  $sigint_count++;
	  $skip_mirror = 1;
	  print "\nCaught keyboard interrupt ($sigint_count/3)\n";
	  kill 9, $pid;
	};

      waitpid($pid, 0);
      return "Ok" if $? == 0;
    } else {
      die "cannot fork: $!" unless defined $pid;
      # child ignores INT and does it's work
      $SIG{INT} = "IGNORE";
      my $res = pretty_mirror($_);
      print "\n";
      if ($res->is_success) {
	open F, ">$package.tgz";
	print F $final_data;
	close F;
	exit 0;
      } else {
	print "Error!\n";
	exit 1;
      }
    }
  }

  return "unable to get '$package' ($version)";
}

# Stolen from:
#   http://hacks.oreilly.com/pub/h/943
sub pretty_mirror {
  my $url = $_[0];
  my $ua = LWP::UserAgent->new;
  $total_size = $ua->head($url)->headers->content_length;
  return $ua->get($url, ':content_cb' => \&get_callback );
}

sub get_callback {
  my ($data, $response, $protocol) = @_;
  $final_data .= $data;
  print progress_bar(length($final_data), $total_size);
}

sub progress_bar {
  my ($got, $total) = @_;
  my $width = 25;
  my $char = '=';
  my $num_width = length $total;

  sprintf "\r|%-${width}s| Got %${num_width}s bytes of %s (%.2f%%)",
    $char x (($width - 1) * $got / $total) . '>',
      $got, $total, 100 * $got /+ $total;
}

1;
