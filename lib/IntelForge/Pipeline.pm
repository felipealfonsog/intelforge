package IntelForge::Pipeline;
use strict;
use warnings;

use File::Spec;
use IntelForge::Config;
use IntelForge::Ingest;
use IntelForge::Extract;
use IntelForge::Normalize;
use IntelForge::Rules;
use IntelForge::Report;
use IntelForge::Util qw(iso_utc_now json_encode);

sub new {
  my ($class, %args) = @_;
  my $self = {
    config_path   => $args{config_path},
    artifacts_dir => $args{artifacts_dir} || 'artifacts',
  };
  bless $self, $class;
  return $self;
}

sub run {
  my ($self) = @_;

  my $cfg = IntelForge::Config->load($self->{config_path});
  my $art = $self->{artifacts_dir};

  my $raw_path    = File::Spec->catfile($art, 'raw.jsonl');
  my $iocs_path   = File::Spec->catfile($art, 'iocs.jsonl');
  my $norm_path   = File::Spec->catfile($art, 'iocs.norm.jsonl');
  my $scored_path = File::Spec->catfile($art, 'iocs.scored.jsonl');
  my $report_path = File::Spec->catfile($art, 'report.md');

  # 1) Ingest (local files for v0.1)
  my $docs = IntelForge::Ingest->ingest_local_files($cfg->{ingest}->{local_files});
  _write_jsonl($raw_path, $docs);

  # 2) Extract
  my $iocs = IntelForge::Extract->extract_iocs_from_docs($docs);
  _write_jsonl($iocs_path, $iocs);

  # 3) Normalize + dedupe
  my $norm = IntelForge::Normalize->normalize_iocs($iocs);
  _write_jsonl($norm_path, $norm);

  # 4) Rules + scoring
  my $scored = IntelForge::Rules->apply_rules($norm);
  _write_jsonl($scored_path, $scored);

  # 5) Report
  my $md = IntelForge::Report->markdown_sitrep($scored, { generated_at => iso_utc_now() });
  _write_text($report_path, $md);

  print "Artifacts written to: $art\n";
  print " - $raw_path\n - $iocs_path\n - $norm_path\n - $scored_path\n - $report_path\n";
}

sub _write_jsonl {
  my ($path, $rows) = @_;
  open my $fh, '>:utf8', $path or die "Failed to write $path: $!";
  for my $r (@$rows) {
    print $fh json_encode($r) . "\n";
  }
  close $fh;
}

sub _write_text {
  my ($path, $text) = @_;
  open my $fh, '>:utf8', $path or die "Failed to write $path: $!";
  print $fh $text;
  close $fh;
}

1;
