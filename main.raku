

#=finish




use MIDI::Helpers;

say d2v('p');
say d2v('pp');

say n2m('aGf8');

=finish

say d2v('ppp');
say d2v('ppp', %(<ppp 23>));
say d2v('ppp');

say d2v('pppppp');

say m2p(120);
say m2f(120);
say m2n(120);

say p2m(12);
say p2f(12);
say p2n(1);

say n2m('Gs9');
say n2p('G9');
say n2f('G9');


=finish
my $rx-note = / <[ABCDEFG]> <[♯♭sf]>? \-? \d+ /;
'G9' ~~ $rx-note ?? say 'Yes' !! say 'No';
'Ga' ~~ $rx-note ?? say 'Yes' !! say 'No';

my $rx-note = / <[ABCDEFG]> <[♯♭sf]>? \-? \d+ /;
subset Note of Str where * ~~ $rx-note;
sub test (Note $x) { say $x }
test('G9');
test('Ga');
