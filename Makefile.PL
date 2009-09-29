#!/usr/bin/env perl

# Makefile.PL -- ExtUtils::MakeMaker input for spb
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

use 5.005;
use ExtUtils::MakeMaker;

WriteMakefile
  (
   NAME         => 'spb',
   ABSTRACT     => 'Perform various queries to Slackware Package Browser',
   AUTHOR       => 'Davide Angelocola <davide.angelocola@gmail.com>',
   PREREQ_PM    => { 'LWP', 'HTML::TreeBuilder' },
   VERSION_FROM => 'lib/WWW/SPB.pm',
   depend       => { Makefile => '$(VERSION_FROM)' },
   EXE_FILES    => [ 'bin/spb' ],
   dist         => { COMPRESS => 'gzip -9f' },
);
