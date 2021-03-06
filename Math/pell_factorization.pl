#!/usr/bin/perl

# Daniel "Trizen" Șuteu
# Date: 03 February 2019
# https://github.com/trizen

# A simple integer factorization method, using square root convergents.

# See also:
#   https://en.wikipedia.org/wiki/Pell%27s_equation

use 5.020;
use strict;
use warnings;

use ntheory qw(:all);
use experimental qw(signatures);

sub pell_factorization ($n) {

    my $x = sqrtint($n);
    my $y = $x;
    my $z = 1;
    my $r = 2 * $x;
    my $w = $r;

    return $n if is_prime($n);
    return $x if is_square($n);

    my ($f1, $f2) = (1, $x);

    for (; ;) {

        $y = $r * $z - $y;
        $z = ($n - $y * $y) / $z;
        $r = int(($x + $y) / $z);

        ($f1, $f2) = ($f2, addmod(mulmod($r, $f2, $n), $f1, $n));

        my $u = $f1;
        my $v = mulmod($u, $u, $n);

        if ($v > $w) {
            $v = ($n - $v);
        }

        if (is_square($v)) {
            my $g = gcd($u - sqrtint($v), $n);
            if ($g > 1 and $g < $n) {
                return $g;
            }
        }

        return $n if ($z == 1);
    }
}

for (1 .. 10) {
    my $n = random_nbit_prime(25) * random_nbit_prime(25);
    say "PellFactor($n) = ", pell_factorization($n);
}

__END__
PellFactor(607859142082991) = 20432749
PellFactor(926859728053057) = 33170069
PellFactor(523709106944971) = 19544953
PellFactor(379392152082407) = 18361823
PellFactor(397926699623521) = 22529261
PellFactor(596176048102421) = 27540133
PellFactor(556290216898421) = 21828529
PellFactor(799063586749279) = 27381929
PellFactor(513015423767879) = 25622173
PellFactor(964450431874939) = 30653317
