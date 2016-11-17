#!/usr/bin/perl 
# Fixes cases where the separator "\t" is part of the
# content of a field for the D_ITFN_ITEM_FORNECEDOR table

use strict;
use warnings;

$| =1;
my $infile = "D_ITFN_ITEM_FORNECEDOR.utf8.csv"; 
open my $fh, '<:encoding(utf8)', $infile or die('Input file not found');
open my $fh_out, '>:encoding(utf8)', $infile . ".fixed" or die('Input file not found');
my $count;
my $maxcol = 13;
my %ncol_log;
while (my $line = <$fh>) {
	$count++;
	my $ncol = () = $line =~ m/\t/g;
	$ncol_log{$ncol}++;
	if ($maxcol == $ncol || $count == 1 ) {
		print $fh_out "$line"; 
	} else {
		my @line = split(/\t/, $line, -1);
		print $fh_out join("\t",(@line[0..4],@line[-9..-1]));
	}
}
print "File: $infile\n";
print "number of lines: $count \n";
foreach (sort keys %ncol_log) {
	print "$_ : $ncol_log{$_}\n";
}
