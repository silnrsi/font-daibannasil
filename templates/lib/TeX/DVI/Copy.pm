
=head1 NAME

TeX::DVI::Copy - A parser that copies input to output

=cut

package TeX::DVI::Copy;

$VERSION = '0.1';

@ISA = qw( TeX::DVI::Parse );

my $COMMANDS = \@TeX::DVI::Parse::COMMANDS;

sub set_char
{
	my ($self, $ord, $char) = @_;
#	print "Set ch\t$ord, $char";
#	print " '", chr $char, "'" if $char >= 32 and $char <= 255;
#	print "\n";
    if ($char < 128)
    { $self->{'fh'}->print(pack('C', $char)); }
    else
    { $self->paramout(128, $char); }
}
sub set_rule
{
	my ($self, $ord, $height, $width) = @_;
#	print "Set rul\t$ord, height: $height, width: $width\n";
    $self->{'fh'}->print(pack('CNN', 132, $height, $width));
}
sub put_char
{
	my ($self, $ord, $char) = @_;
#	print "Put ch\t$ord, $char";
#	print " '", chr $ord, "'" if $ord >= 32 and $ord <= 255;
#	print "\n";
    $self->paramout(133, $char);
}
sub put_rule
{
#	my ($self, $ord, $height, $width) = @_;
#	print "Put rul\t$ord, height: $height, width: $width\n";
    $self->{'fh'}->print(pack('CNN', 137, $height, $width));
}
sub nop
#	{ my ($self, $ord) = @_; print "Nop\t$ord\n"; }
{ $_[0]->print(pack('C', 138)); }
sub bop
{
	my ($self, $ord, @numbers) = @_;
#	$prev_page = pop @numbers;
#	print "Bop\t$ord, id: [@numbers], previous page: $prev_page\n";
    my $prev = $self->{'ppage'} || -1;
    $self->{'ppage'} = tell($self->{'fh'});
    $self->{'fh'}->print(pack('CN11', 139, @numbers[0..9], $prev));
}
sub eop
#	{ my ($self, $ord) = @_; print "Eop\t$ord\n"; }
{ $_[0]->print(pack('C', 140)); }
sub push
#	{ my ($self, $ord) = @_; print "Push\t$ord\n"; }
{ $_[0]->print(pack('C', 141)); }
sub pop
#	{ my ($self, $ord) = @_; print "Pop\t$ord\n"; }
{ $_[0]->print(pack('C', 142)); }
sub right
{
    my ($self, $ord, $value) = @_; 
#   print "Right\t$ord, value: $value\n";
    $self->paramout(143, $value);
}
sub move_w
{
	my ($self, $ord, $value) = @_;
#	$value = 'no_b' unless defined $value;
#	print "Move w\t$ord, value: $value\n";
    $self->paramout0(147, $value);
}
sub move_x
{
	my ($self, $ord, $value) = @_;
#	$value = 'no_b' unless defined $value;
#	print "Move x\t$ord, value: $value\n";
    $self->paramout0(152, $value);
}
sub down
{
	my ($self, $ord, $value) = @_;
#	print "Down\t$ord, value: $value\n";
    $self->paramout(157, $value);
}
sub move_y
{
	my ($self, $ord, $value) = @_;
#	$value = 'no_b' unless defined $value;
#	print "Move y\t$ord, value: $value\n";
    $self->paramout0(161, $value);
}
sub move_z
{
	my ($self, $ord, $value) = @_;
#	$value = 'no_b' unless defined $value;
#	print "Move z\t$ord, value: $value\n";
    $self->paramout0(166, $value);
}
sub fnt_num
{
	my ($self, $ord, $k) = @_;
#	print "Fnt num\t$ord, k: $k\n";
    if ($k < 64)
    { $self->{'fh'}->print(pack('C', 171 + $k)); }
    else
    { $self->paramout(235, $k); }
}
sub special
{
	my ($self, $ord, $len, $text) = @_;
#	print "Spec\t$ord, len: $len\n\t`$text'\n";
    $len = Byte::length($text);
    $self->paramout(239, $len);
    $self->{'fh'}->print($text);
}
sub fnt_def
{
	my ($self, $ord, $k, $c, $s, $d, $a, $l, $name) = @_;
#	print "Fnt def\t$ord, k: $k, name: $name\n";
    $self->paramout(243, $k);
    $self->{'fh'}->print(pack('NNNCCa*', $c, $s, $d, $a, $l, $name));
}
sub preamble
{
	my ($self, $ord, $i, $num, $den, $mag, $k, $text) = @_;
#	print "Pream\t$ord, i: $i, num: $num, den: $den, mag: $mag, k: $k\n\t`$text'\n";
    $self->{'fh'}->print(pack('CNNNCa*', $i, $num, $den, $mag, Byte::length($text), $text);
}
sub post
{
	my ($self, $ord, $prev, $num, $den, $mag, $l, $u, $s, $t) = @_;
#	print "Post\t$ord, prev: $prev, num: $num, den: $den, mag: $mag, \n\tl: $l, u: $u, s: $s, t: $t\n";
    $self->{'ppost'} = tell($self->{'fh'});
    $self->{'fh'}->print(pack('NNNNNNnn', $self->{'ppage'} || -1, $num, $den, $mag, $l, $u, $s, $t);
}
sub post_post
{
	my ($self, $ord, $q, $i, $rest) = @_;
#	print "PPost\t$ord, q: $q, i: $i\n";
#	print "\tWrong end of DVI\n"
#		unless $rest =~ /^\337{4,7}$/;
    my ($loc) = tell($self->{'fh'});
    my ($pad) = 4 - (($loc + 9) % 4);
    $self->{'fh'}->print(pack('NCCCCC', $self->{'ppost'}, $self->{'version'}, (223) x 4);
    $self->{'fh'}->print(pack('C$pad', (223) x $pad)) if ($pad < 4);
}
sub undefined_command
	{
	print "Undefined command\n";
	}


sub paramout
{
    my ($self, $base, $char) = @_;
    if ($char < 256)
    { $self->{'fh'}->print(pack('CC', $base, $char)); }
    elsif ($char < 65536)
    { $self->{'fh'}->print(pack('Cn', $base + 1, $char)); }
    elsif ($char < 16777216)
    {
        my ($f) = $char / 65536;
        $char >>= 8;
        $self->{'fh'}->print(pack('CCn', $base + 2, $f, $char));
    }
    else
    { $self->{'fh'}->print(pack('CN', $base + 3, $char)); }
}

sub paramout0
{
    my ($self, $base, $value) = @_;
    if ($base)
    { $self->paramout($base + 1, $value); }
    else
    { $self->{'fh'}->print(pack('C', $base)); }
}


1;

=head1 SYNOPSIS

	use TeX::DVI::Parse;
	my $dvi_parse = new TeX::DVI::Parse("test.dvi");
	$dvi_parse->parse();

=head1 DESCRIPTION

I have created this module on request from Mirka Misáková. She wanted
to do some post-processing on the DVI file and I said that it will be
better to parse the DVI file directly, instead of the output of the
B<dvitype> program.

As the result there is this module B<TeX::DVI::Parse> that recognizes
all commands from the DVI file and for each command found it calls
method of appropriate name, if defined in the class.

The example above is not very reasonable because the core
B<TeX::DVI::Parse> module doesn't itself define any methods for the
DVI commands. You will probably want to inherit a new class and define
the functions yourself:

	packages My_Parse_DVI;
	use TeX::DVI::Parse;
	@ISA = qw( TeX::DVI::Parse );

	sub set_char
		{
		my ($self, $ord, $char) = @_;
		## print the info or something;
		}

As an example there is class B<TeX::DVI::Print> coming in this file,
so you can do

	use TeX::DVI::Parse;
	my $dvi_parse = new TeX::DVI::Print("test.dvi");
	$dvi_parse->parse();

and get listing of DVI's content printed in (hopefully) readable form.

=head2 Methods

For creating new classes, a documentation of expected methods names
and their parameters is necessary, so here is the list. The names come
from the B<dvitype> documentation and that is also the basic reference
for the meaning of the parameters. Note that each method receives as
the first two parameters I<$self> and I<$ord>, reference to the parsing
object and the byte value of the command as found in the DVI file.
These are mandatory so only the other parameters to each method are
listed below.

=over 4

=item set_char -- typeset character and shift right by its width

I<$char> -- specifies the ordinal value of the character.

=item put_char -- as B<set_char> but without moving

I<$char> -- ordinal value of the character.

=item set_rule -- typeset black rectangle and shift to the right

I<$height>, I<$width> -- dimensions of the rectangle.

=item put_rule -- as B<set_rule> without moving

I<$height>, I<$width> -- dimensions of the rectangle.

=item nop -- no operation

no parameter

=item bop -- begin of page

I<$number[0]> .. I<$number[9]>, I<$prev_page> -- the ten numbers
that specify the page, the pointer to the start of the previous page.

=item eop -- end of page

no parameter

=item push -- push to the stack

no parameter

=item pop -- pop from the stack

no parameter

=item right -- move right

I<$value> -- how much to move.

=item move_w, move_x, down, move_y, move_z -- move position

all take one parameter, I<$value>.

=item fnt_def -- define font

I<$k>, I<$c>, I<$s>, I<$d>, I<$a>, I<$l>, I<$n> -- number of the font, 
checksum, scale factor, design size, length of the directory and length
of the filename, name of the font.

=item fnt_num -- select font

I<$k> -- number of the font.

=item special -- generic DVI primitive 

I<$k>, I<$x> -- length of the special and its data.

=item preamble

I<$i>, I<$num>, I<$den>, I<$mag>, I<$k>, I<$x> -- ID of the format,
numerator and denumerator of the multiplication fraction,
magnification, length of the comment and comment.

=item post -- postamble

I<$p>, I<$num>, I<$den>, I<$mag>, I<$l>, I<$u>, I<$s>, I<$t> -- pointer
to the last page, the next three are as in preamble, maximal dimensions
(I<$l> and I<$u>), maximal depth of the stack and the final page number.

=item post_post -- post postamble

I<$q>, I<$i>, I<$dummy> -- pointer to the postamble, ID and the last fill.

=item undefined_command -- for byte that has no other meaning

no parameter

=back

=head1 VERSION

0.110

=head1 SEE ALSO

Font::TFM(3), TeX::DVI(3), perl(1).

=head1 AUTHOR

(c) 1997--1998, 2004 Jan Pazdziora, adelton@fi.muni.cz,
http://www.fi.muni.cz/~adelton/

=cut

