#!/usr/bin/perl
# Adds headers to the table files. The headers came in a different .csv file
use strict;
use warnings;

my $infile = "names.csv";

open INPUT, '<:encoding(utf8)', $infile or die('Input file not found');

while (my $line = <INPUT>) {
	if ($line =~ s/^([^\t]*)\t//) {
		my $file = $1 . ".utf8.csv";
		my $file_tmp = $file . ".tmp";
		print "Editing $file\n";
		open my $fh_in, '<:encoding(utf8)', $file or die('Input file not found');
		open my $fh_out, '>:encoding(utf8)', $file_tmp or die('Could not open/create output file');	
		print $fh_out $line; #header
		my $count;
		while (<$fh_in>) {
			print $fh_out $_;
		}
		close $fh_in;
		close $fh_out;
		rename $file_tmp, $file;
	}
}
