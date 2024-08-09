unit module MIDI::Helpers;

# --------------------------------------------------------------------
# Velocity

    # (d) dynamic -> (v) velocity
sub d2v (Str $d, $new-scale?) is export {
    state $scale = %(<
        ppp 15
        pp  31
        p   47
        mp  63
        mf  79
        f   95
        ff  111
        fff 127
    >);
    $scale = $new-scale if $new-scale.defined;
    die("Key $d not found in the d2v scale.") if $scale{$d}:!exists;
    return $scale{$d};
}

=finish

# --------------------------------------------------------------------
# Note

    # | midi | piano | hbmn | freq | notes
my $pitches = q:to/END/;
    127  -    57  12543.85  G9
    126  -    56  11839.82  F♯9 G♭9 Fs9 Gf9
    125  -    55  11175.30  F9
    124  -    54  10548.08  E9
    123  -    53  9956.06   D♯9 E♭9 Ds9 Ef9
    122  -    52  9397.27   D9
    121  -    51  8869.84   C♯9 D♭9 Cs9 Df9
    120  -    50  8372.02   C9
    119  -    4b  7902.13   B8
    118  -    4a  7458.62   A♯8 B♭8 As8 Bf8
    117  -    49  7040.00   A8
    116  -    48  6644.88   G♯8 A♭8 Gs8 Af8
    115  -    47  6271.93   G8
    114  -    46  5919.91   F♯8 G♭8 Fs8 Gf8
    113  -    45  5587.65   F8
    112  -    44  5274.04   E8
    111  -    43  4978.03   D♯8 E♭8 Ds8 Ef8
    110  -    42  4698.64   D8
    109  -    41  4434.92   C♯8 D♭8 Cs8 Df8
    108  88   40  4186.01   C8
    107  87   3b  3951.07   B7
    106  86   3a  3729.31   A♯7 B♭7 As7 Bf7
    105  85   39  3520.00   A7
    104  84   38  3322.44   G♯7 A♭7 Gs7 Af7
    103  83   37  3135.96   G7
    102  82   36  2959.96   F♯7 G♭7 Fs7 Gf7
    101  81   35  2793.83   F7
    100  80   34  2637.02   E7
    99   79   33  2489.02   D♯7 E♭7 Ds7 Ef7
    98   78   32  2349.32   D7
    97   77   31  2217.46   C♯7 D♭7 Cs7 Df7
    96   76   30  2093.00   C7
    95   75   2b  1975.53   B6
    94   74   2a  1864.66   A♯6 B♭6 As6 Bf6
    93   73   29  1760.00   A6
    92   72   28  1661.22   G♯6 A♭6 Gs6 Af6
    91   71   27  1567.98   G6
    90   70   26  1479.98   F♯6 G♭6 Fs6 Gf6
    89   69   25  1396.91   F6
    88   68   24  1318.51   E6
    87   67   23  1244.51   D♯6 E♭6 Ds6 Ef6
    86   66   22  1174.66   D6
    85   65   21  1108.73   C♯6 D♭6 Cs6 Df6
    84   64   20  1046.50   C6
    83   63   1b  987.77    B5
    82   62   1a  932.33    A♯5 B♭5 As5 Bf5
    81   61   19  880.00    A5
    80   60   18  830.61    G♯5 A♭5 Gs5 Af5
    79   59   17  783.99    G5
    78   58   16  739.99    F♯5 G♭5 Fs5 Gf5
    77   57   15  698.46    F5
    76   56   14  659.26    E5
    75   55   13  622.25    D♯5 E♭5 Ds5 Ef5
    74   54   12  587.33    D5
    73   53   11  554.37    C♯5 D♭5 Cs5 Df5
    72   52   10  523.25    C5
    71   51   0b  493.88    B4
    70   50   0a  466.16    A♯4 B♭4 As4 Bf4
    69   49   09  440.00    A4
    68   48   08  415.30    G♯4 A♭4 Gs4 Af4
    67   47   07  392.00    G4
    66   46   06  369.99    F♯4 G♭4 Fs4 Gf4
    65   45   05  349.23    F4
    64   44   04  329.63    E4
    63   43   03  311.13    D♯4 E♭4 Ds4 Ef4
    62   42   02  293.66    D4
    61   41   01  277.18    C♯4 D♭4 Cs4 Df4
    60   40   00  261.63    C4
    59   39  -1b  246.94    B3
    58   38  -1a  233.08    A♯3 B♭3 As3 Bf3
    57   37  -19  220.00    A3
    56   36  -18  207.65    G♯3 A♭3 Gs3 Af3
    55   35  -17  196.00    G3
    54   34  -16  185.00    F♯3 G♭3 Fs3 Gf3
    53   33  -15  174.61    F3
    52   32  -14  164.81    E3
    51   31  -13  155.56    D♯3 E♭3 Ds3 Ef3
    50   30  -12  146.83    D3
    49   29  -11  138.59    C♯3 D♭3 Cs3 Df3
    48   28  -10  130.81    C3
    47   27  -2b  123.47    B2
    46   26  -2a  116.54    A♯2 B♭2 As2 Bf2
    45   25  -29  110.00    A2
    44   24  -28  103.83    G♯2 A♭2 Gs2 Af2
    43   23  -27  98.00     G2
    42   22  -26  92.50     F♯2 G♭2 Fs2 Gf2
    41   21  -25  87.31     F2
    40   20  -24  82.41     E2
    39   19  -23  77.78     D♯2 E♭2 Ds2 Ef2
    38   18  -22  73.42     D2
    37   17  -21  69.30     C♯2 D♭2 Cs2 Df2
    36   16  -20  65.41     C2
    35   15  -3b  61.74     B1
    34   14  -3a  58.27     A♯1 B♭1 As1 Bf1
    33   13  -39  55.00     A1
    32   12  -38  51.91     G♯1 A♭1 Gs1 Af1
    31   11  -37  49.00     G1
    30   10  -36  46.25     F♯1 G♭1 Fs1 Gf1
    29   9   -35  43.65     F1
    28   8   -34  41.20     E1
    27   7   -33  38.89     D♯1 E♭1 Ds1 Ef1
    26   6   -32  36.71     D1
    25   5   -31  34.65     C♯1 D♭1 Cs1 Df1
    24   4   -30  32.70     C1
    23   3   -4b  30.87     B0
    22   2   -4a  29.14     A♯0 B♭0 As0 Bf0
    21   1   -49  27.50     A0
    20   -   -48  25.96     G♯0 A♭0 Gs0 Af0
    19   -   -47  24.50     G0
    18   -   -46  23.12     F♯0 G♭0 Fs0 Gf0
    17   -   -45  21.83     F0
    16   -   -44  20.60     E0
    15   -   -43  19.45     D♯0 E♭0 Ds0 Ef0
    14   -   -42  18.35     D0
    13   -   -41  17.32     C♯0 D♭0 Cs0 Df0
    12   -   -40  16.35     C0
    11   -   -5b  15.43     B-1
    10   -   -5a  14.57     A♯-1 B♭-1 As-1 Bf-1
    9    -   -59  13.75     A-1
    8    -   -58  12.98     G♯-1 A♭-1 Gs-1 Af-1
    7    -   -57  12.25     G-1
    6    -   -56  11.56     F♯-1 G♭-1 Fs-1 Gf-1
    5    -   -55  10.91     F-1
    4    -   -54  10.30     E-1
    3    -   -53  9.72      D♯-1 E♭-1 Ds-1 Ef-1
    2    -   -52  9.18      D-1
    1    -   -51  8.66      C♯-1 D♭-1 Cs-1 Df-1
    0    -   -50  8.18      C-1
END

my (%m2p, %m2f, %m2n);
my (%p2m, %p2f, %p2n);
my (%n2m, %n2p, %n2f);

for $pitches.lines -> $line {
    my @words = $line.words;

    my $midi  = @words[0];
    my $piano = @words[1];
    my $freq  = @words[2];
    my @notes = @words.splice(3);

    %m2p{$midi} = $piano;
    %m2f{$midi} = $freq;
    %m2n{$midi} = @notes;

    %p2m{$piano} = $midi;
    %p2f{$piano} = $freq;
    %p2n{$piano} = @notes;

    for @notes -> $note {
        %n2m{$note} = $midi;
        %n2p{$note} = $piano;
        %n2f{$note} = $freq;
    }
}

subset UInt7 of UInt where * ≤ 127;
sub m2p (UInt7 $x) is export { %m2p{$x} !~~ '-' ?? %m2p{$x}.Int !! Nil }
sub m2f (UInt7 $x) is export { %m2f{$x}.Rat }
sub m2n (UInt7 $x) is export { %m2n{$x}.List }

subset Piano of UInt where 1 ≤ * ≤ 88;
sub p2m (Piano $x) is export { %p2m{$x}.Int }
sub p2f (Piano $x) is export { %p2f{$x}.Rat }
sub p2n (Piano $x) is export { %p2n{$x}.List }

my constant $rx-note = / ^ <[A..G]> <[♯♭sf]>? \-? \d $ /;
subset Note of Str where * ~~ $rx-note;
sub n2m (Note $x) is export { %n2m{$x}.Int}
sub n2p (Note $x) is export { %n2p{$x} !~~ '-' ?? %n2p{$x}.Int !! Nil }
sub n2f (Note $x) is export { %n2f{$x}.Rat}
