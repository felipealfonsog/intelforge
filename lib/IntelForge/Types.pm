package IntelForge::Types;
use strict;
use warnings;

sub is_sha256 {
  my ($s) = @_;
  return defined $s && $s =~ /\A[a-f0-9]{64}\z/i;
}

sub is_ipv4 {
  my ($s) = @_;
  return 0 unless defined $s;
  return 0 unless $s =~ /\A(\d{1,3}\.){3}\d{1,3}\z/;
  my @o = split /\./, $s;
  for my $x (@o) { return 0 if $x > 255; }
  return 1;
}

sub is_domain {
  my ($s) = @_;
  return 0 unless defined $s;
  return 0 if length($s) > 253;
  return 0 unless $s =~ /\A[a-z0-9](?:[a-z0-9\-]{0,61}[a-z0-9])?(?:\.[a-z0-9](?:[a-z0-9\-]{0,61}[a-z0-9])?)+\z/i;
  return 1;
}

1;
