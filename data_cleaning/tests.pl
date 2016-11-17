#!/usr/bin/perl
# This script runs a diagnostic on all files in order to check if all lines contain
# the same number of separators. The script save_largest_rows.pl does the same check,
# but prints the lines that do not conform with the headers.
# Usage: perl tests.pl file1 file2 ...

use strict;
use warnings;

$| =1;
foreach my $infile (@ARGV) {
open my $fh, '<:encoding(utf8)', $infile or die('Input file not found');
	my $count;
	my $mincol = 100;
	my $maxcol = 0;
	my %ncol_log;
	while (my $line = <$fh>) {
		$count++;
		my $ncol = () = $line =~ m/\t/g;
		$ncol_log{$ncol}++;
		$maxcol = $ncol if ($maxcol < $ncol );
		if ($mincol > $ncol ) {
			$mincol = $ncol;
			#print "$line"
		}
	}
	print "File: $infile\n";
	print "number of lines: $count \n";
	print "max number of elements in line: $maxcol \n";
	print "min number of elements in line: $mincol \n";
	foreach (sort keys %ncol_log) {
		print "$_ : $ncol_log{$_}\n";
	}
}
