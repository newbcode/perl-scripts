#!/usr/bin/perl

# Author: Daniel "Trizen" Șuteu
# License: GPLv3
# Date: 15 October 2016
# Website: https://github.com/trizen

# A simple probabilistic primality test, based on Fermat's little theorem.

# Pseudoprimes are eliminated based on the following conjecture:
#
#    Let "n" be a Fermat pseudoprime to base 2, greater than 9. (OEIS: A001567)
#
#    Let "k" be:
#         ceil(sqrt(n) / log(n) * log(9) + 1)
#
#    The smallest prime factor of such "n", seems to always be smaller than:
#         nth_prime(k)
#
# Therefore, we can check "n" for divisibility with the first "k" primes only.
# As of today (15 October 2016), no counter-example was found. It was tested up to: 999986341201.

# See also:
#   https://oeis.org/A001567
#   https://oeis.org/A177415
#   https://en.wikipedia.org/wiki/Fermat%27s_little_theorem

use 5.010;
use strict;
use integer;
use warnings;

use ntheory qw(powmod prime_iterator sqrtint logint);

sub is_probably_prime {
    my ($n) = @_;

    return 1 if $n == 2;
    return 0 if powmod(2, $n - 1, $n) != 1;

    my $iter = prime_iterator(2);
    my $limit = $n >= 9 ? int(sqrtint($n) / logint($n, 9)) + 1 : sqrtint($n);

    for (my $i = $limit ; $i ; --$i) {
        ($n % $iter->()) == 0 and return 0;
    }

    return 1;
}

#
## Tests
#

say is_probably_prime(267_391);       # prime
say is_probably_prime(23_498_729);    # composite
say is_probably_prime(206_601);       # composite

my @pseudoprimes = (
                    341,          561,          645,          1105,         1387,         1729,
                    1905,         2047,         2465,         2701,         2821,         3277,
                    4033,         4369,         4371,         4681,         5461,         6601,
                    7957,         8321,         8481,         8911,         10261,        10585,
                    11305,        12801,        13741,        13747,        13981,        14491,
                    15709,        15841,        16705,        18705,        18721,        19951,
                    23001,        23377,        25761,        29341,        1194649,      16973393,
                    1568101591,   1568471813,   1568731305,   1568916311,   1569488977,   1569663271,
                    1569843451,   1571111587,   1571503801,   1572279791,   1572932089,   1573132561,
                    1573657345,   1573895701,   1574300001,   1574362441,   1574601601,   1575340921,
                    1576187713,   1576826161,   1577983489,   1578009401,   1578114721,   1579869361,
                    1580201501,   1580449201,   1580591377,   1581576641,   1581714481,   1581943837,
                    1582212101,   1582783777,   1582886341,   1583230241,   1583347105,   1583582113,
                    1583658649,   1584405649,   1584443341,   1584462331,   1586436193,   1587483001,
                    1587511245,   1587650401,   998963480593, 998986073837, 998997586201, 999016383345,
                    999034637833, 999060235097, 999095831041, 999208159621, 999219600889, 999236382301,
                    999253360153, 999292561345, 999296400961, 999301767001, 999308638021, 999406030321,
                    999407657821, 999425853361, 999431614501, 999459365053, 999504724681, 999585999413,
                    999605018701, 999607982113, 999615852901, 999629786233, 999647922737, 999666754801,
                    999710032321, 999746703869, 999776483317, 999801636961, 999814392501, 999828475651,
                    999855751441, 999857310721, 999863018281, 999971303761, 999986341201, 999986341201,
                    10231,        10237,        10238,        10239,        10249,        10261,
                    10265,        10277,        10279,        10291,        10294,        10297,
                    10299,        10306,        10307,        10315,        10319,        10327,
                    10334,        10342,        10345,        10347,        10349,        10351,
                    10358,        10361,        10363,        10367,        10371,        10378,
                    10379,        10381,        10383,        10389,        10393,        10394,
                    10397,        10401,        10403,        10405,        10407,        10409,
                    10411,        10415,        10417,        10418,        10421,        10423,
                    10435,        10441,        10445,        10447,        10451,        10454,
                    10462,        10466,        10471,        10473,        10474,        40679,
                    40681,        40682,        40691,        40694,        40701,        40706,
                    40711,        40714,        40717,        40718,        40721,        40723,
                    40727,        40731,        40735,        40738,        40741,        40747,
                    40753,        40757,        40769,        40773,        40778,        40781,
                    40783,        40786,        40789,        40791,        40798,        40799,
                    40805,        40811,        40814,        40822,        40835,        40837,
                    40839,        40855,        40857,        40861,        40862,        40871,
                    40873,        40877,        40881,        40882,
                   );

foreach my $pp (@pseudoprimes) {
    is_probably_prime($pp) && die "error for pseudoprime: $pp";
}

my $count = 0;
my $limit = 10000;
foreach my $i (0 .. $limit) {
    ++$count if is_probably_prime($i);
}

say "There are $count primes bellow $limit.";
