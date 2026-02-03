package IntelForge::Config;
use strict;
use warnings;

use YAML::XS qw(LoadFile);

sub load {
  my ($class, $path) = @_;
  my $cfg = LoadFile($path);

  $cfg->{ingest} ||= {};
  $cfg->{ingest}->{local_files} ||= [];
  $cfg->{project} ||= {};
  $cfg->{project}->{name} ||= 'IntelForge';

  return $cfg;
}

1;
