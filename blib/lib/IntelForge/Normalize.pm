package IntelForge::Normalize;
use strict;
use warnings;

sub normalize_iocs {
  my ($class, $iocs) = @_;
  my @out;
  my %dedupe;

  for my $ioc (@$iocs) {
    my $type  = $ioc->{type}  // '';
    my $value = $ioc->{value} // '';
    next unless $type && $value;

    if ($type eq 'domain') {
      $value =~ s/\.+$//;
      $value = lc $value;
    }
    if ($type eq 'sha256') {
      $value = lc $value;
    }

    my $k = join('|', $type, $value);
    next if $dedupe{$k}++;

    $ioc->{value} = $value;
    push @out, $ioc;
  }

  return \@out;
}

1;
