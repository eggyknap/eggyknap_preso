#!perl -w

use strict;
use warnings;

#T1A01 (C) [97.1]
#Which of the following is a purpose of the Amateur Radio Service as stated in the FCC rules and regulations?
#A. Providing personal radio communications for as many citizens as possible
#B. Providing communications for international non-profit organizations
#C. Advancing skills in the technical and communication phases of the radio art
#D. All of these choices are correct 

my $in_question = 0;
my ($section, $answer);
my @text;
my %choices;
while (<>) {
    my $line = $_;
    next unless $in_question or /^(T\d[A-Z]\d+) \s \(([A-Z])\)/x;
    if (! $in_question) {
        $in_question = 1;
        $section = $1;
        $answer = $2;
        print STDERR "Found question $section with answer $answer\n";
    }
    else {
        if (/^~~/) {
            $in_question = 0;
            print join " ", @text;
            print "\t$answer\t";
            print join "\t", map { $choices{$_}; } sort keys %choices;
            print "\t$section\n";
            %choices = ();
            $section = undef;
            $answer = undef;
            @text = ();
        }
        else {
            if (/^([A-Z])\. /) {
                chomp $line;
                $choices{$1} = $line;
            }
            else {
                chomp $line;
                push @text, $line;
            }
        }
    }
}
