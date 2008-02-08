package Ocsinventory::Agent::Config;

use strict;

sub get {
  my $file = shift;
  my $config;

  @{$config->{etcdir}} = ();

  push (@{$config->{etcdir}}, '/etc/ocsinventory');
  push (@{$config->{etcdir}}, '/usr/local/etc/ocsinventory');
  push (@{$config->{etcdir}}, '/etc/ocsinventory-agent');
  push (@{$config->{etcdir}}, $ENV{HOME}.'/.ocsinventory');

  if (!$file || !-f $file) {
    foreach (@{$config->{etcdir}}) {
      $file = $_.'/ocsinventory-agent.cfg';
      last if -f $file;
    }
    return {} unless -f $file;
  }

  $config->{configfile} = $file;

  open (CONFIG, "<".$file) or return {};

  foreach (<CONFIG>) {
    s/#.+//;
    if (/(\w+)\s*=\s*([\w\.:\/]+)/) {
      my $key = $1;
      my $val = $2;
      $val =~ s/^"(.*)"$/$1/; # Remove the quote (")
      $config->{$key} = $val;
    }
  }
  close CONFIG;
  return $config;
}

1;