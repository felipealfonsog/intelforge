package IntelForge::Util;
use strict;
use warnings;

use Time::Piece;
use JSON::PP;

sub iso_utc_now {
  my $t = gmtime();
  return $t->datetime . 'Z';
}

sub json_encode {
  my ($data) = @_;
  my $json = JSON::PP->new->utf8->canonical(1);
  return $json->encode($data);
}

sub json_decode {
  my ($s) = @_;
  my $json = JSON::PP->new->utf8;
  return $json->decode($s);
}

sub trim {
  my ($s) = @_;
  $s //= '';
  $s =~ s/^\s+//;
  $s =~ s/\s+$//;
  return $s;
}

1;
