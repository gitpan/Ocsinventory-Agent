package Ocsinventory::Agent::Backend::OS::Generic::Lspci::Sounds;
use strict;

sub run {
  my $params = shift;
  my $inventory = $params->{inventory};

  foreach(`lspci`){

    if(/audio/i && /^\S+\s([^:]+):\s*(.+?)(?:\(([^()]+)\))?$/i){

      $inventory->addSound({
	  'DESCRIPTION'  => $3,
	  'MANUFACTURER' => $2,
	  'NAME'     => $1,
	});
    
    }
  }
}
1
