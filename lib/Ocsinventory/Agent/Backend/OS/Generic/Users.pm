package Ocsinventory::Agent::Backend::OS::Generic::Users;

sub check {
# Useless check for a posix system i guess
  my @who = `who 2>/dev/null`;
  return 1 if @who;
  return;
}

# Initialise the distro entry
sub run {
  my $params = shift;
  my $inventory = $params->{inventory};

  my %user;
  # Logged on users
  for(`who`){
    my $user = $1 if /^(\S+)./;
    $inventory->addUser ({ LOGIN => $user });
  }

}

1;
