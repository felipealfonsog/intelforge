package IntelForge::Ingest;
use strict;
use warnings;

use File::Basename qw(basename);
use IntelForge::Util qw(iso_utc_now trim);

sub ingest_local_files {
  my ($class, $files) = @_;
  my @docs;

  for my $path (@$files) {
    open my $fh, '<:raw', $path or die "Failed to open $path: $!";
    local $/ = undef;
    my $raw = <$fh>;
    close $fh;

    my $text = $raw;
    $text =~ s/\r\n/\n/g;
    $text = trim($text);

    push @docs, {
      doc_id     => "file:" . $path,
      fetched_at => iso_utc_now(),
      source     => {
        type => 'file',
        name => basename($path),
        path => $path,
      },
      content_type => 'text/plain',
      text         => $text,
    };
  }

  return \@docs;
}

1;
