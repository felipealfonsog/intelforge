package IntelForge::Rules;
use strict;
use warnings;

sub apply_rules {
  my ($class, $iocs) = @_;

  for my $ioc (@$iocs) {
    my $type = $ioc->{type} // '';
    my $val  = $ioc->{value} // '';
    my @tags;

    # Basic heuristics (defensive, conservative)
    if ($type eq 'domain') {
      push @tags, 'domain';
      push @tags, 'suspicious-tld' if $val =~ /\.(zip|mov|top|xyz|click)\z/i;
    }
    if ($type eq 'ip') {
      push @tags, 'ip';
    }
    if ($type eq 'sha256') {
      push @tags, 'hash';
    }

    my $score = 0.50;
    $score += 0.10 if grep { $_ eq 'suspicious-tld' } @tags;

    # Clamp
    $score = 0.95 if $score > 0.95;
    $score = 0.05 if $score < 0.05;

    $ioc->{tags} = _uniq([ @{$ioc->{tags} || []}, @tags ]);
    $ioc->{score} = $score;

    # Optional: set a high-level verdict
    $ioc->{verdict} = $score >= 0.70 ? 'elevated' : 'normal';
  }

  return $iocs;
}

sub _uniq {
  my ($arr) = @_;
  my %s;
  my @u;
  for my $x (@$arr) {
    next unless defined $x && length $x;
    push @u, $x unless $s{$x}++;
  }
  return \@u;
}

1;
