package Ocsinventory::Agent::Backend::OS::Generic::Packaging::RPM;

use strict;
use warnings;

sub check {
  `rpm --version 2>&1`;
  return if ($? >> 8)!=0;
  1;
}

sub run {
  my $params = shift;
  my $inventory = $params->{inventory};

  my @list;
  my $buff;
  foreach (`rpm -qa --queryformat "%{NAME}.%{ARCH} %{VERSION}-%{RELEASE} %{SUMMARY}\n--\n"`) {
    if (! /^--/) {
      chomp;
      $buff .= $_;
    } elsif ($buff =~ s/^(\S+)\s+(\S+)\s+(.*)//) {
    $inventory->addSoftwares({
	'NAME'          => $1,
	'VERSION'       => $2,
	'COMMENTS'      => $3,
	});
  } else {
    warn "Should never go here!";
    $buff = '';
  }
  }
}

1;
