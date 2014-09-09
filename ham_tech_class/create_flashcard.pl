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
    <script type="text/javascript">
        function clickMe(evt) {
            var t = evt.currentTarget;
            var c = t.parentElement.querySelector(".clicked");
            if (c !== null) {
                c.className = c.className.replace(/\\bclicked\\b/, '');
            }
            t.className = t.className + " clicked";
        }
    </script>
</head>
<body class="full">
HEADER
;

while (<>) {
    chomp;
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
            print "<tr answerltr=\"$_\" id=\"$section-$answer_class-$_\" onclick=\"clickMe(event)\" class=\"" .
                ($answer eq $_ ? 'right' : 'wrong') .
                "\"><td class=\"answer\"><p>$answers{$_}<p></td></tr>\n";
        } sort keys %answers;
        print q{
                </table>
            </div></section>
        };
    } ('hideanswer', 'showanswer');
}

print <<FOOTER
	<script src="shower/shower.js"></script>
    <script type="text/javascript">
        var numSlides;
        numSlides = document.querySelectorAll('.hideanswer').length;

        window.shower.callback = function(slide) {
                // Current slide's ID is one greater than its slide number
            var curSlide = document.getElementById(1 + shower.getCurrentSlideNumber());

            if ((' ' + curSlide.className + ' ').indexOf(' hideanswer ') >= 0) {
                var ltr = curSlide.querySelector('.clicked');
                if (ltr !== null) {
                        // get the slide following this one
                    var nextSlide = document.getElementById(shower.getCurrentSlideNumber() + 2);
                    var ans = nextSlide.querySelector("[answerltr='" + ltr.attributes.answerltr.firstChild.data + "']");
                    ans.className = ans.className + " clicked";
                }
            }

            var c = curSlide.querySelector(".clicked");
            if (c !== null) {
                c.className = c.className.replace(/\\bclicked\\b/, '');
            }

            if ((' ' + curSlide.className + ' ').indexOf(' hideanswer ') >= 0) {
                return 'next';
            }
            else {
                    // Mulitply by 2 here because we've only counted every
                    // other slide. We only want to switch to a hideanswer
                    // slide, not the showanswer slide
                return (2 * Math.floor(Math.random() * numSlides));
            }
        }
    </script>
</body>
</html>
FOOTER
;
