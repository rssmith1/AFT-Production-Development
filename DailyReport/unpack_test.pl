#!/usr/bin/perl -w
use strict;



# this prgram needs to parse the settlement numbers from the CME download and also turn the contract labels into the same one used by IB
#             maturity  open      high      low       last     settle  change      vol
              #0         1          2        3         4         5         6         7         8         9         0    
              #01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
my $string1 = "DEC14....1.5911....1.5937 ...1.5771 ...1.5819....1.5777..-.0105..... 141612.....1.5882.......72579      149429";
my $string2 = "MAR15    1.5900    1.5922B...1.5761A...  ----....1.5765..-.0104.....    416     1.5869         160        2075";
#JUN15    1.5807    1.5901B   1.5751A     ----    1.5752..-.0102           1     1.5854                     112
#SEP15      ----    1.5847B   1.5753A     ----    1.5740..-.0100                 1.5840                      29

#                     1   2   3  4    5
my $unpackTemplate = "A5x4A6x4A7x3A7x3A6x4A6x2A6x5A7x5A6x7A7A*";
my @fieldNames = qw(maturity open high low last settle change vol psettle pvol oi);
my $result = doUnpack($unpackTemplate,$string1,"String1",\@fieldNames);
printResults($result);
doUnpack($unpackTemplate,$string2,"String2",\@fieldNames);
printResults($result);


sub printResults {
    my $results = shift;
    for (my $i=0; $i <= $#$results; $i++ ) {
        print $fieldNames[$i] . ":" . $$results[$i] . "\n";
    }
}

sub doUnpack {
    my $template = shift;
    my $input = shift;
    my $label = shift;
    my $fieldNames = shift;
    my @fields = unpack($unpackTemplate, $input);
    #my ($field1, $field2,$field3,$field4,$field5,$field6,$field7,$field8,$field9,$field10,$field11) = unpack($unpackTemplate, $input);
    #print "$label:  $$fieldNames[0]:$field1 $$fieldNames[1]:$field2 $$fieldNames[2]:$field3 $$fieldNames[3]:$field4 $$fieldNames[4]:$field5 $$fieldNames[5]:$field6 $$fieldNames[6]:$field7 $$fieldNames[7]:$field8 $$fieldNames[8]:$field9 $$fieldNames[9]:$field10 $$fieldNames[10]:$field11\n";
    #return;
    return \@fields;
}
