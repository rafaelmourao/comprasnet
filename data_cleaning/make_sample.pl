#!/usr/bin/perl 
#This script makes samples from the data files

use strict;
use warnings;

my @files = <"*utf8.csv">;
print "@files\n";

foreach my $file (@files){
    print $file;
    (my $file_prefix) = $file =~ m/(.*)\.utf8/;
    my $new_file = $file_prefix . ".sample.csv";
    open my $fh, '<:encoding(utf8)', $file or die('Input file not found');
    open my $fh_out, '>:encoding(utf8)', $new_file or die('Output file not found');
    print $fh_out 'sep=\t' . "\n";
    while (my $line = <$fh>) {
		last unless 1..500;
		print $fh_out $line;
    }
}
