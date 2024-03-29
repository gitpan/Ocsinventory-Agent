package Ocsinventory::Agent::Backend::OS::BSD::IPv4;

sub check {
  my @ifconfig = `ifconfig -a 2>/dev/null`;
  return 1 if @ifconfig;
  return;
}

# Initialise the distro entry
sub run {
  my $params = shift;
  my $inventory = $params->{inventory};
  my @ip;

  # Looking for ip addresses with ifconfig, except loopback
  # *BSD need -a option
  foreach (`ifconfig -a`){
    if(/^\s*inet\s+(\S+)/){
      ($1=~/127.+/)?next:push @ip, $1
    };
  }

  my $ip=join "/", @ip;

  $inventory->setHardware({IPADDR => $ip});
}

1;
