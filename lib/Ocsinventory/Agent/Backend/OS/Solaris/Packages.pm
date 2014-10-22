package Ocsinventory::Agent::Backend::OS::Solaris::Packages;

use strict;
use warnings;

sub check {
  my $params = shift;

  # Do not run an package inventory if there is the --nosoft parameter
  return if ($params->{config}->{nosoft});

  can_run("pkginfo");
}

sub run {
  my $params = shift;
  my $inventory = $params->{inventory};

  my $name;
  my $version;
  my $comments;
  my $publisher;
  foreach (`pkginfo -l`) {
    if (/^\s*$/) {
      $inventory->addSoftware({
          'NAME'          => $name,
          'VERSION'       => $version,
          'COMMENTS'      => $comments,
          'PUBLISHER'      => $publisher,
          });

      $name = '';
      $version = '';
      $comments = '';
      $publisher = '';

    } elsif (/PKGINST:\s+(.+)/) {
      $name = $1;
    } elsif (/VERSION:\s+(.+)/) {
      $version = $1;
    } elsif (/VENDOR:\s+(.+)/) {
      $publisher = $1;
    } elsif (/DESC:\s+(.+)/) {
      $comments = $1;
    }
  }
}

1;
