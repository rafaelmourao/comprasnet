#!/usr/bin/perl 
# This script gets everything that looks like a dictionary variable and
# write the R commands to make it a factor variable inside the main tables

use strict;
use warnings;

my $infile = "names.csv";
my $outfile = "names_dic_R.txt";

open INPUT, '<:encoding(utf8)', $infile or die('Input file not found');
open OUTPUT, '>:encoding(utf8)', $outfile or die('Could not open/create output file');

while (<INPUT>) {
    chomp;
    my @vars = split /\t/;
    my $table = @vars[0];
    @vars = grep(/^ID/,@vars);
    unless (scalar(@vars) <= 1) {
		print OUTPUT "# $table\n\n";
		foreach my $var (@vars) {
			unless ($var =~ m/$table/) {
			$var =~ m/ID(.*)/;
			my $var_aux = $1;
			print OUTPUT "$table\$$var  <- factor($table\$$var, levels = D$var_aux\$$var, labels = D$var_aux\$DS$var_aux)\n";
			}
			print OUTPUT "\n";
		}
    }
}
