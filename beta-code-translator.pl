#!/usr/bin/env perl

=head1 NAME

beta-code-translator

=head1 SYNOPSIS

beta-code-translator.pl input_file output_file

=head1 DESCRIPTION

A tool for conversion of Beta Code dictionaries to Unicode.

=head1 DEPENDENCIES

-Perl ( >= 5.14.2, earlier versions MIGHT work but no promises! )

=head1 CONTRIBUTIONS

Dimitrios - Georgios Kontopoulos (evolgen) is the original author,
whereas Beta Code conversion rules were provided by jennie.

=head1 LICENSE

This program is free software: you can redistribute it and/or modify 
it under the terms of the GNU General Public License as 
published by the Free Software Foundation, either version 3 of the 
License, or (at your option) any later version.

For more information, see http://www.gnu.org/licenses/.

=head1 MORE INFORMATION

-http://forum.ubuntu-gr.org/viewtopic.php?f=9&t=9983&start=10 (forum discussion)

-http://en.wikipedia.org/wiki/Beta_code (Wikipedia article)

=cut

use strict;
use warnings;

use utf8;

@ARGV == 2 or die "Usage: $0 input_file output_file\n";

my $input_file  = $ARGV[0];
my $output_file = $ARGV[1];

#Read the whole input file.#
my @content;
local $/ = "\n";
open my $fh_in, '<', $input_file or die "ERROR. Cannot open $input_file.\n";
while ( my $line = <$fh_in> )
{
    push @content, $line;
}
close $fh_in;

#Find the positions that need to be converted.#
for ( 0 .. $#content )
{
    my $text = $content[$_];
    $content[$_] = q{};

    #Run the conversion rules there.#
    while ( $text =~ /\w+/ )
    {
        if ( $text =~ /<entry key="(.+)" type/ )
        {
            $content[$_] .=
              $` . '<entry key="' . betacode_convert($1) . '" type';
            $text = $';
        }
        else
        {
            $content[$_] .= $text;
            last;
        }
    }
    $text = $content[$_];
    $content[$_] = q{};
    while ( $text =~ /\w+/ )
    {
        if ( $text =~ /lang="greek">([^>]+)</ )
        {
            $content[$_] .= $` . 'lang="greek">' . betacode_convert($1) . '<';
            $text = $';
        }
        else
        {
            $content[$_] .= $text;
            last;
        }
    }
}

#Print results to output file.#
open my $fh_out, '>', $output_file
  or die "ERROR. Cannot write to $output_file.\n";
binmode $fh_out, ':encoding(UTF-8)';
for ( 0 .. $#content )
{
    print {$fh_out} $content[$_];
}
close $fh_out;

#Betacode conversion rules, provided by jennie (Ubuntu-gr community).#
sub betacode_convert
{
    my ($input) = @_;
    $input =~ s/&\w+;//g;
    $input =~ s/[_\^]//g;
    $input =~ s/=[)]/)=/g;
    $input =~ s/=[(]/(=/g;
    $input =~ s/\/[)]/)\//g;
    $input =~ s/\/[(]/(\//g;
    $input =~ s/\\[)]/)\\/g;
    $input =~ s/\\[(]/(\\/g;
    $input =~ s/[+]\//\/+/g;
    $input =~ s/[+]\\/\\\+/g;
    $input =~ s/[+]=[(]/=+/g;
    $input =~ s/[*][+]i/Ϊ/g;
    $input =~ s/[*][+]u/Ϋ/g;
    $input =~ s/[*][)]\/a[|]/ᾌ/g;
    $input =~ s/[*][(]\/a[|]/ᾍ/g;
    $input =~ s/[*][)]=a[|]/ᾎ/g;
    $input =~ s/[*][(]=a[|]/ᾏ/g;
    $input =~ s/[*][)]\/h[|]/ᾜ/g;
    $input =~ s/[*][(]\/h[|]/ᾝ/g;
    $input =~ s/[*][)]=h[|]/ᾞ/g;
    $input =~ s/[*][(]=h[|]/ᾟ/g;
    $input =~ s/[*][)]\/w[|]/ᾬ/g;
    $input =~ s/[*][(]\/w[|]/ᾭ/g;
    $input =~ s/[*][)]=w[|]/ᾮ/g;
    $input =~ s/[*][(]=w[|]/ᾯ/g;
    $input =~ s/[*][(]\\a/Ἃ/g;
    $input =~ s/[*][)]\/a/Ἄ/g;
    $input =~ s/[*][(]\/a/Ἅ/g;
    $input =~ s/[*][)]\\e/Ἒ/g;
    $input =~ s/[*][(]\\e/Ἓ/g;
    $input =~ s/[*][)]\/e/Ἔ/g;
    $input =~ s/[*][(]\/e/Ἕ/g;
    $input =~ s/[*][)]\\h/Ἢ/g;
    $input =~ s/[*][(]\\h/Ἣ/g;
    $input =~ s/[*][)]\/h/Ἤ/g;
    $input =~ s/[*][(]\/h/Ἥ/g;
    $input =~ s/[*][)]\\i/Ἲ/g;
    $input =~ s/[*][(]\\i/Ἳ/g;
    $input =~ s/[*][)]\/i/Ἴ/g;
    $input =~ s/[*][(]\/i/Ἵ/g;
    $input =~ s/[*][)]\\o/Ὂ/g;
    $input =~ s/[*][(]\\o/Ὃ/g;
    $input =~ s/[*][)]\/o/Ὄ/g;
    $input =~ s/[*][(]\/o/Ὅ/g;
    $input =~ s/[*][(]\\u/Ὓ/g;
    $input =~ s/[*][(]\/u/Ὕ/g;
    $input =~ s/[*][)]\\w/Ὢ/g;
    $input =~ s/[*][(]\\w/Ὣ/g;
    $input =~ s/[*][)]\/w/Ὤ/g;
    $input =~ s/[*][(]\/w/Ὥ/g;
    $input =~ s/[*][)]=a/Ἆ/g;
    $input =~ s/[*][(]=a/Ἇ/g;
    $input =~ s/[*][)]=h/Ἦ/g;
    $input =~ s/[*][(]=h/Ἧ/g;
    $input =~ s/[*][)]=i/Ἶ/g;
    $input =~ s/[*][(]=i/Ἷ/g;
    $input =~ s/[*][)]=o/Ὄ/g;
    $input =~ s/[*][(]=o/Ὅ/g;
    $input =~ s/[*][(]=u/Ὗ/g;
    $input =~ s/[*][)]=w/Ὦ/g;
    $input =~ s/[*][(]=w/Ὧ/g;
    $input =~ s/[*][)]a[|]/ᾈ/g;
    $input =~ s/[*][(]a[|]/ᾉ/g;
    $input =~ s/[*][)]h[|]/ᾘ/g;
    $input =~ s/[*][(]h[|]/ᾙ/g;
    $input =~ s/[*][)]w[|]/ᾨ/g;
    $input =~ s/[*][(]w[|]/ᾩ/g;
    $input =~ s/[*][)]a/Ἁ/g;
    $input =~ s/[*][(]a/Ἁ/g;
    $input =~ s/[*]\\a/Ὰ/g;
    $input =~ s/[*]\/a/Ά/g;
    $input =~ s/[*][)]e/Ἐ/g;
    $input =~ s/[*][(]e/Ἑ/g;
    $input =~ s/[*]\\e/Ὲ/g;
    $input =~ s/[*]\/e/Έ/g;
    $input =~ s/[*][)]h/Ἠ/g;
    $input =~ s/[*][(]h/Ἡ/g;
    $input =~ s/[*]\\h/Ὴ/g;
    $input =~ s/[*]\/h/Ή/g;
    $input =~ s/[*][)]i/Ἰ/g;
    $input =~ s/[*][(]i/Ἱ/g;
    $input =~ s/[*]\\i/Ὶ/g;
    $input =~ s/[*]\/i/Ί/g;
    $input =~ s/[*][)]o/Ὀ/g;
    $input =~ s/[*][(]o/Ὁ/g;
    $input =~ s/[*]\\o/Ὸ/g;
    $input =~ s/[*]\/o/Ό/g;
    $input =~ s/[*][)]r/Ρ/g;
    $input =~ s/[*][(]r/Ῥ/g;
    $input =~ s/[*][(]u/Ὑ/g;
    $input =~ s/[*]\\u/Ὺ/g;
    $input =~ s/[*]\/u/Ύ/g;
    $input =~ s/[*][)]w/Ὠ/g;
    $input =~ s/[*][(]w/Ὡ/g;
    $input =~ s/[*]\\w/Ὼ/g;
    $input =~ s/[*]\/w/Ώ/g;
    $input =~ s/[*]a[|]/ᾼ/g;
    $input =~ s/[*]h[|]/ῌ/g;
    $input =~ s/[*]w[|]/ῼ/g;
    $input =~ s/_//g;
    $input =~ s/[*]s/Σ/g;
    $input =~ s/s([,.;:0-9])/ς$1/g;
    $input =~ s/s(\s)/ς$1/g;
    $input =~ s/s$/ς/g;
    $input =~ s/s([a-zA-Z\/\\=[+]\-'])/σ$1/g;
    $input =~ s/s([^a-zA-Z\/\\=[+]\-'])/ς$1/g;
    $input =~ s/s/σ/g;
    $input =~ s/[*][+]i/Ϊ/g;
    $input =~ s/[*][+]u/Ϋ/g;
    $input =~ s/[*][)]\/a[|]/ᾌ/g;
    $input =~ s/[*][(]\/a[|]/ᾍ/g;
    $input =~ s/[*][)]=a[|]/ᾎ/g;
    $input =~ s/[*][(]=a[|]/ᾏ/g;
    $input =~ s/[*][)]\/h[|]/ᾜ/g;
    $input =~ s/[*][(]\/h[|]/ᾝ/g;
    $input =~ s/[*][)]=h[|]/ᾞ/g;
    $input =~ s/[*][(]=h[|]/ᾟ/g;
    $input =~ s/[*][)]\/w[|]/ᾬ/g;
    $input =~ s/[*][(]\/w[|]/ᾭ/g;
    $input =~ s/[*][)]=w[|]/ᾮ/g;
    $input =~ s/[*][(]=w[|]/ᾯ/g;
    $input =~ s/[*][(]\\a/Ἃ/g;
    $input =~ s/[*][)]\/a/Ἄ/g;
    $input =~ s/[*][(]\/a/Ἅ/g;
    $input =~ s/[*][)]\\e/Ἒ/g;
    $input =~ s/[*][(]\\e/Ἓ/g;
    $input =~ s/[*][)]\/e/Ἔ/g;
    $input =~ s/[*][(]\/e/Ἕ/g;
    $input =~ s/[*][)]\\h/Ἢ/g;
    $input =~ s/[*][(]\\h/Ἣ/g;
    $input =~ s/[*][)]\/h/Ἤ/g;
    $input =~ s/[*][(]\/h/Ἥ/g;
    $input =~ s/[*][)]\\i/Ἲ/g;
    $input =~ s/[*][(]\\i/Ἳ/g;
    $input =~ s/[*][)]\/i/Ἴ/g;
    $input =~ s/[*][(]\/i/Ἵ/g;
    $input =~ s/[*][)]\\o/Ὂ/g;
    $input =~ s/[*][(]\\o/Ὃ/g;
    $input =~ s/[*][)]\/o/Ὄ/g;
    $input =~ s/[*][(]\/o/Ὅ/g;
    $input =~ s/[*][(]\\u/Ὓ/g;
    $input =~ s/[*][(]\/u/Ὕ/g;
    $input =~ s/[*][)]\\w/Ὢ/g;
    $input =~ s/[*][(]\\w/Ὣ/g;
    $input =~ s/[*][)]\/w/Ὤ/g;
    $input =~ s/[*][(]\/w/Ὥ/g;
    $input =~ s/[*][)]=a/Ἆ/g;
    $input =~ s/[*][(]=a/Ἇ/g;
    $input =~ s/[*][)]=h/Ἦ/g;
    $input =~ s/[*][(]=h/Ἧ/g;
    $input =~ s/[*][)]=i/Ἶ/g;
    $input =~ s/[*][(]=i/Ἷ/g;
    $input =~ s/[*][)]=o/Ὄ/g;
    $input =~ s/[*][(]=o/Ὅ/g;
    $input =~ s/[*][(]=u/Ὗ/g;
    $input =~ s/[*][)]=w/Ὦ/g;
    $input =~ s/[*][(]=w/Ὧ/g;
    $input =~ s/[*][)]a[|]/ᾈ/g;
    $input =~ s/[*][(]a[|]/ᾉ/g;
    $input =~ s/[*][)]h[|]/ᾘ/g;
    $input =~ s/[*][(]h[|]/ᾙ/g;
    $input =~ s/[*][)]w[|]/ᾨ/g;
    $input =~ s/[*][(]w[|]/ᾩ/g;
    $input =~ s/[*][)]a/Ἁ/g;
    $input =~ s/[*][(]a/Ἁ/g;
    $input =~ s/[*]\\a/Ὰ/g;
    $input =~ s/[*]\/a/Ά/g;
    $input =~ s/[*][)]e/Ἐ/g;
    $input =~ s/[*][(]e/Ἑ/g;
    $input =~ s/[*]\\e/Ὲ/g;
    $input =~ s/[*]\/e/Έ/g;
    $input =~ s/[*][)]h/Ἠ/g;
    $input =~ s/[*][(]h/Ἡ/g;
    $input =~ s/[*]\\h/Ὴ/g;
    $input =~ s/[*]\/h/Ή/g;
    $input =~ s/[*][)]i/Ἰ/g;
    $input =~ s/[*][(]i/Ἱ/g;
    $input =~ s/[*]\\i/Ὶ/g;
    $input =~ s/[*]\/i/Ί/g;
    $input =~ s/[*][)]o/Ὀ/g;
    $input =~ s/[*][(]o/Ὁ/g;
    $input =~ s/[*]\\o/Ὸ/g;
    $input =~ s/[*]\/o/Ό/g;
    $input =~ s/[*][)]r/Ρ/g;
    $input =~ s/[*][(]r/Ῥ/g;
    $input =~ s/[*][(]u/Ὑ/g;
    $input =~ s/[*]\\u/Ὺ/g;
    $input =~ s/[*]\/u/Ύ/g;
    $input =~ s/[*][)]w/Ὠ/g;
    $input =~ s/[*][(]w/Ὡ/g;
    $input =~ s/[*]\\w/Ὼ/g;
    $input =~ s/[*]\/w/Ώ/g;
    $input =~ s/[*]a[|]/ᾼ/g;
    $input =~ s/[*]h[|]/ῌ/g;
    $input =~ s/[*]w[|]/ῼ/g;
    $input =~ s/[*]a/Α/g;
    $input =~ s/[*]e/Ε/g;
    $input =~ s/[*]h/Η/g;
    $input =~ s/[*]i/Ι/g;
    $input =~ s/[*]o/Ο/g;
    $input =~ s/[*]u/Υ/g;
    $input =~ s/[*]w/Ω/g;
    $input =~ s/i[+]\\/ῒ/g;
    $input =~ s/i[+]\//ΐ/g;
    $input =~ s/i[+]=/ῗ/g;
    $input =~ s/u[+]\\/ῢ/g;
    $input =~ s/u[+]\//ΰ/g;
    $input =~ s/u[+]=/ῧ/g;
    $input =~ s/i[+]/ϊ/g;
    $input =~ s/u[+]/ϋ/g;
    $input =~ s/a[)]\/[|]/ᾄ/g;
    $input =~ s/a[(]\/[|]/ᾅ/g;
    $input =~ s/a[)]=[|]/ᾆ/g;
    $input =~ s/a[(]=[|]/ᾇ/g;
    $input =~ s/h[)]\/[|]/ᾔ/g;
    $input =~ s/h[(]\/[|]/ᾕ/g;
    $input =~ s/h[)]=[|]/ᾖ/g;
    $input =~ s/h[(]=[|]/ᾗ/g;
    $input =~ s/w[)]\/[|]/ᾤ/g;
    $input =~ s/w[(]\/[|]/ᾥ/g;
    $input =~ s/w[)]=[|]/ᾦ/g;
    $input =~ s/w[(]=[|]/ᾧ/g;
    $input =~ s/a[)][|]/ᾀ/g;
    $input =~ s/a[(][|]/ᾁ/g;
    $input =~ s/a\/[|]/ᾴ/g;
    $input =~ s/a=[|]/ᾷ/g;
    $input =~ s/h[)][|]/ᾐ/g;
    $input =~ s/h[(][|]/ᾑ/g;
    $input =~ s/h\/[|]/ῄ/g;
    $input =~ s/h=[|]/ῇ/g;
    $input =~ s/w[)][|]/ᾠ/g;
    $input =~ s/w[(][|]/ᾡ/g;
    $input =~ s/w\/[|]/ῴ/g;
    $input =~ s/w=[|]/ῷ/g;
    $input =~ s/a[)]\\/ἂ/g;
    $input =~ s/a[(]\\/ἃ/g;
    $input =~ s/a[)]\//ἄ/g;
    $input =~ s/a[(]\//ἅ/g;
    $input =~ s/e[)]\\/ἒ/g;
    $input =~ s/e[(]\\/ἓ/g;
    $input =~ s/e[)]\//ἔ/g;
    $input =~ s/e[(]\//ἕ/g;
    $input =~ s/h[)]\\/ἢ/g;
    $input =~ s/h[(]\\/ἣ/g;
    $input =~ s/h[)]\//ἤ/g;
    $input =~ s/h[(]\//ἥ/g;
    $input =~ s/i[)]\\/ἲ/g;
    $input =~ s/i[(]\\/ἳ/g;
    $input =~ s/i[)]\//ἴ/g;
    $input =~ s/i[(]\//ἵ/g;
    $input =~ s/o[)]\\/ὂ/g;
    $input =~ s/o[(]\\/ὃ/g;
    $input =~ s/o[)]\//ὄ/g;
    $input =~ s/o[(]\//ὅ/g;
    $input =~ s/u[)]\\/ὒ/g;
    $input =~ s/u[(]\\/ὓ/g;
    $input =~ s/u[)]\//ὔ/g;
    $input =~ s/u[(]\//ὕ/g;
    $input =~ s/w[)]\\/ὢ/g;
    $input =~ s/w[(]\\/ὣ/g;
    $input =~ s/w[)]\//ὤ/g;
    $input =~ s/w[(]\//ὥ/g;
    $input =~ s/a[)]=/ἆ/g;
    $input =~ s/a[(]=/ἇ/g;
    $input =~ s/h[)]=/ἦ/g;
    $input =~ s/h[(]=/ἧ/g;
    $input =~ s/i[)]=/ἶ/g;
    $input =~ s/i[(]=/ἷ/g;
    $input =~ s/u[)]=/ὖ/g;
    $input =~ s/u[(]=/ὗ/g;
    $input =~ s/w[)]=/ὦ/g;
    $input =~ s/w[(]=/ὧ/g;
    $input =~ s/a[)]/ἀ/g;
    $input =~ s/a[(]/ἁ/g;
    $input =~ s/a\\/ὰ/g;
    $input =~ s/a\//ά/g;
    $input =~ s/e[)]/ἐ/g;
    $input =~ s/e[(]/ἑ/g;
    $input =~ s/e\\/ὲ/g;
    $input =~ s/e\//έ/g;
    $input =~ s/h[)]/ἠ/g;
    $input =~ s/h[(]/ἡ/g;
    $input =~ s/h\\/ὴ/g;
    $input =~ s/h\//ή/g;
    $input =~ s/i[)]/ἰ/g;
    $input =~ s/i[(]/ἱ/g;
    $input =~ s/i\\/ὶ/g;
    $input =~ s/i\//ί/g;
    $input =~ s/o[)]/ὀ/g;
    $input =~ s/o[(]/ὁ/g;
    $input =~ s/o\\/ὸ/g;
    $input =~ s/o\//ό/g;
    $input =~ s/r[)]/ῤ/g;
    $input =~ s/r[(]/ῤ/g;
    $input =~ s/u[)]/ὐ/g;
    $input =~ s/u[(]/ὑ/g;
    $input =~ s/u\\/ὺ/g;
    $input =~ s/u\//ύ/g;
    $input =~ s/w[)]/ὠ/g;
    $input =~ s/w[(]/ὡ/g;
    $input =~ s/w\\/ὼ/g;
    $input =~ s/w\//ώ/g;
    $input =~ s/a=/ᾶ/g;
    $input =~ s/h=/ῆ/g;
    $input =~ s/i=/ῖ/g;
    $input =~ s/u=/ῦ/g;
    $input =~ s/w=/ῶ/g;
    $input =~ s/a[|]/ᾳ/g;
    $input =~ s/h[|]/ῃ/g;
    $input =~ s/w[|]/ῳ/g;
    $input =~ s/a/α/g;
    $input =~ s/e/ε/g;
    $input =~ s/h/η/g;
    $input =~ s/i/ι/g;
    $input =~ s/o/ο/g;
    $input =~ s/u/υ/g;
    $input =~ s/w/ω/g;
    $input =~ s/[*]b/Β/g;
    $input =~ s/[*]g/Γ/g;
    $input =~ s/[*]d/Δ/g;
    $input =~ s/[*]z/Ζ/g;
    $input =~ s/[*]q/Θ/g;
    $input =~ s/[*]k/Κ/g;
    $input =~ s/[*]l/Λ/g;
    $input =~ s/[*]m/Μ/g;
    $input =~ s/[*]n/Ν/g;
    $input =~ s/[*]c/Ξ/g;
    $input =~ s/[*]p/Π/g;
    $input =~ s/[*]r/Ρ/g;
    $input =~ s/[*]t/Τ/g;
    $input =~ s/[*]f/Φ/g;
    $input =~ s/[*]x/Χ/g;
    $input =~ s/[*]y/Ψ/g;
    $input =~ s/[*]v/Ϝ/g;
    $input =~ s/b/β/g;
    $input =~ s/g/γ/g;
    $input =~ s/d/δ/g;
    $input =~ s/z/ζ/g;
    $input =~ s/q/θ/g;
    $input =~ s/k/κ/g;
    $input =~ s/l/λ/g;
    $input =~ s/m/μ/g;
    $input =~ s/n/ν/g;
    $input =~ s/c/ξ/g;
    $input =~ s/p/π/g;
    $input =~ s/r/ρ/g;
    $input =~ s/t/τ/g;
    $input =~ s/f/φ/g;
    $input =~ s/x/χ/g;
    $input =~ s/y/ψ/g;
    $input =~ s/v/ϝ/g;
    return $input;
}
