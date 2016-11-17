#!/usr/bin/perl
# This script checks the list of files in the (FILE) arguments and prints the number of
# lines with more separator characters than header columns. It reports how many cases where found
# for each number of separators higher than the number of columns and print these cases to
# file FILE.save.
# Usage: perl save_largest_rows file1 file2
# Output: file1.save file2.save

use strict;
use warnings;

$| = 1;
foreach my $infile (@ARGV) {
    open my $fh, '<:encoding(utf8)', $infile or die('Input file not found');
    open my $fh_out, '>:encoding(utf8)', $infile . ".save" or die('Input file not found');
    my $count;
    my $headercol;
    my %ncol_log;
    my $printrows;
    while (my $line = <$fh>) {
		$count++;
		my $ncol = () = $line =~ m/\t/g;
		$ncol_log{$ncol}++;
		$headercol = $ncol if ($count == 1);
		if ($ncol > $headercol || $count == 1 ) {
			$printrows++;
			print $fh_out "$line";
		}
    }
    print "File: $infile\n";
    print "number of lines: $count \n";
    foreach (sort keys %ncol_log) {
		print "$_ : $ncol_log{$_}\n";
    }
    print "Printed lines: $printrows\n"
}