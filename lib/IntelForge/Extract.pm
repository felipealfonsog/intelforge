package IntelForge::Extract;
use strict;
use warnings;

use IntelForge::Types qw(is_sha256 is_ipv4 is_domain);
use IntelForge::Util qw(iso_utc_now trim);

sub extract_iocs_from_docs {
  my ($class, $docs) = @_;

  my @out;

  for my $doc (@$docs) {
    my $text = $doc->{text} // '';
    next unless length $text;

    my $src = $doc->{source} || {};
    my $base_source = {
      name       => ($src->{name} // 'unknown'),
      type       => ($src->{type} // 'unknown'),
      path       => ($src->{path}),
      fetched_at => ($doc->{fetched_at} // iso_utc_now()),
      confidence => 0.6,
    };

    my %seen;
    my @candidates;

    # SHA256
    while ($text =~ /([A-Fa-f0-9]{64})/g) {
      push @candidates, $1;
    }

    # IPv4
    while ($text =~ /(?<!\d)(\d{1,3}(?:\.\d{1,3}){3})(?!\d)/g) {
      push @candidates, $1;
    }

    # Domains (simple)
    while ($text =~ /(?<![\w\-])([A-Za-z0-9][A-Za-z0-9\-]{0,62}(?:\.[A-Za-z0-9][A-Za-z0-9\-]{0,62})+)(?![\w\-])/g) {
      push @candidates, $1;
    }

    for my $c (@candidates) {
      $c = trim($c);
      next if $seen{$c}++;
      my ($type, $value);

      if (is_sha256(lc $c)) { $type = 'sha256'; $value = lc $c; }
      elsif (is_ipv4($c))   { $type = 'ip';     $value = $c; }
      elsif (is_domain(lc $c)) { $type = 'domain'; $value = lc $c; }
      else { next; }

      push @out, {
        type       => $type,
        value      => $value,
        first_seen => ($doc->{fetched_at} // iso_utc_now()),
        sources    => [ $base_source ],
        tags       => [],
        evidence   => {
          doc_id => $doc->{doc_id},
        },
      };
    }
  }

  return \@out;
}

1;
