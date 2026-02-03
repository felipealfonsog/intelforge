package IntelForge::Report;
use strict;
use warnings;

sub markdown_sitrep {
  my ($class, $iocs, $meta) = @_;
  $meta ||= {};

  my $count = scalar @$iocs;

  my %by_type;
  my %by_verdict;
  for my $ioc (@$iocs) {
    $by_type{$ioc->{type} // 'unknown'}++;
    $by_verdict{$ioc->{verdict} // 'unknown'}++;
  }

  my $md = "";
  $md .= "# IntelForge SITREP\n\n";
  $md .= "- Generated: " . ($meta->{generated_at} // '') . "\n";
  $md .= "- Total IOCs: $count\n\n";

  $md .= "## Breakdown\n\n";
  $md .= "- By type:\n";
  for my $t (sort keys %by_type) {
    $md .= "  - $t: $by_type{$t}\n";
  }
  $md .= "\n- By verdict:\n";
  for my $v (sort keys %by_verdict) {
    $md .= "  - $v: $by_verdict{$v}\n";
  }

  $md .= "\n## Top Indicators (sample)\n\n";
  $md .= "| Type | Value | Score | Verdict |\n";
  $md .= "|------|-------|-------|---------|\n";

  my @sorted = sort { ($b->{score} // 0) <=> ($a->{score} // 0) } @$iocs;
  my $limit = @sorted < 25 ? scalar(@sorted) : 25;

  for (my $i = 0; $i < $limit; $i++) {
    my $ioc = $sorted[$i];
    my $type = $ioc->{type} // '';
    my $val  = $ioc->{value} // '';
    my $score = sprintf("%.2f", $ioc->{score} // 0);
    my $verdict = $ioc->{verdict} // '';
    $md .= "| $type | $val | $score | $verdict |\n";
  }

  $md .= "\n---\n";
  $md .= "IntelForge is defensive-only: collection, normalization, signals, reporting.\n";

  return $md;
}

1;
