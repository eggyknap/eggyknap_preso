#!perl -w

use strict;
use warnings;
use Data::Dumper;

print <<HEADER
<!DOCTYPE HTML>
<html lang="en">
<head>
	<title>Amateur Radio Technician License</title>
    <!-- images generally found at http://www.wikipaintings.org/en/norman-rockwell/mode/all-paintings -->
	<meta charset="utf-8">
	<meta name="viewport" content="width=792, user-scalable=no">
	<meta http-equiv="x-ua-compatible" content="ie=edge">
	<link rel="stylesheet" href="shower/themes/ribbon/styles/screen.css">
	<link rel="stylesheet" href="flashcard.css">
</head>
<body class="full">
HEADER
;

while (<>) {
    my ($text, $answer, $a, $b, $c, $d, $section) = split /\t/;
    my %answers;
    @answers{qw/A B C D/} = ($a, $b, $c, $d);

    map {
        my $answer_class = $_;
        print qq{
            <section class="slide $answer_class"><div>
                <h2>$section</h2>
                <p>$text</p>
                <table class="answers">
        };
        map {
            print "<tr class=\"" .
                ($answer eq $_ ? 'right' : 'wrong') .
                "\"><td><p>$answers{$_}<p></td></tr>\n";
        } sort keys %answers;
        print q{
                </table>
            </div></section>
        };
    } ('hideanswer', 'nextrandom showanswer');
}

print <<FOOTER
	<script src="shower/shower.js"></script>
    <script type="text/javascript">
        var numSlides;
        numSlides = document.querySelectorAll('.hideanswer').length;

        window.shower.callback = function(slide) {
            if ((' ' + document.getElementById(slide.id).className + ' ').indexOf(' hideanswer ') >= 0) {
                return 'next';
            }
                // Mulitply by 2 here because we've only counted every
                // other slide. We only want to switch to a hideanswer
                // slide, not the showanswer slide
            return (2 * Math.floor(Math.random() * numSlides));
        }
    </script>
</body>
</html>
FOOTER
;
