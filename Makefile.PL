use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
  NAME         => 'IntelForge',
  VERSION_FROM => 'lib/IntelForge/Version.pm',
  EXE_FILES    => ['bin/intelforge'],
  ABSTRACT     => 'Perl-first defensive CTI pipeline (CLI)',
  AUTHOR       => 'IntelForge Contributors',
  LICENSE      => 'mit',
  PREREQ_PM    => {
    'strict'            => 0,
    'warnings'          => 0,
    'Getopt::Long'      => 0,
    'File::Spec'        => 0,
    'File::Basename'    => 0,
    'File::Path'        => 0,
    'Time::Piece'       => 0,
    'JSON::PP'          => 0,
    'YAML::XS'          => 0,
    'Test::More'        => 0,
  },
);
