#! perl

use strict;
use warnings;
use Test::More qw(no_plan);

use Data::Report;

my $rep = Data::Report::->create(type => "text", stylist => \&my_stylist);

$rep->set_layout
  ([ { name => "one", title => "One",   width => 10, },
     { name => "two", title => "Two",   width => 11, },
     { name => "thr", title => "Three", width => 12, },
     { name => "fou", title => "Four",  width => 13, },
     { name => "fiv", title => "Five",  width => 14, },
   ]);

my $ref; { undef $/; $ref = <DATA>; }
$ref =~ s/[\r\n]/\n/g;
my $out = "";

my $dd = "The quick brown fox jumps over the lazy dog.";
$dd = "$dd $dd $dd";

$rep->set_output(\$out);
$rep->start;
$rep->add({ one => $dd, two => $dd, thr => $dd, fou => $dd, fiv => $dd });
$rep->finish;

is($out, $ref);

sub my_stylist {
    my ($rep, $row, $col) = @_;

    return unless defined $col;

    return { ignore => 1, indent => 2 } if $col eq "two";
    return { indent => 1, wrap_indent => 0 } if $col eq "thr";
    return { wrap_indent => 2 } if $col eq "fou";
    return { indent => 1, wrap_indent => 2 } if $col eq "fiv";

    return;
}

__DATA__
One         Three         Four           Five
-------------------------------------------------------
The quick    The quick    The quick       The quick
brown fox   brown fox       brown fox      brown fox
jumps over  jumps over      jumps over     jumps over
the lazy    the lazy        the lazy       the lazy
dog. The    dog. The        dog. The       dog. The
quick       quick brown     quick brown    quick brown
brown fox   fox jumps       fox jumps      fox jumps
jumps over  over the        over the       over the
the lazy    lazy dog.       lazy dog.      lazy dog.
dog. The    The quick       The quick      The quick
quick       brown fox       brown fox      brown fox
brown fox   jumps over      jumps over     jumps over
jumps over  the lazy        the lazy       the lazy
the lazy    dog.            dog.           dog.
dog.
