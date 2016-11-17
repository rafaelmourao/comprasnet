#!/usr/bin/perl 
# Fixes cases where the separator "\t" is part of the
# content of a field for the D_ITCP_ITEM_COMPRA table

use strict;
use warnings;

$| = 1;
my $infile = "../D_ITCP_ITEM_COMPRA.utf8.csv";
open my $fh, '<:encoding(utf8)', $infile or die('Input file not found');
open my $fh_out, '>:encoding(utf8)', $infile . ".fixed" or die('Input file not found');
my $count;
my $maxcol = 42;
my %ncol_log;
while (my $line = <$fh>) {
	$count++;
	my $ncol = () = $line =~ m/\t/g; #         
	$ncol_log{$ncol}++;
	if ( $maxcol == $ncol || $count == 1 ) {
		print $fh_out "$line"; 
	} else {
		my @line = split(/\t/, $line, -1);
		print $fh_out join("\t",(@line[0..4],
					 join(" ",@line[5..$ncol-36]), # gathering everything in the middle and
					 "",                           # making DS_ITCP_COMPL_ITEM_COMPRA_CONT empty
					 @line[-36..-1]));
	}
}
print "File: $infile\n";
print "Number of lines: $count \n";
print "Number of separators:\n";
foreach (sort keys %ncol_log) {
	print "$_ : $ncol_log{$_}\n";
}
