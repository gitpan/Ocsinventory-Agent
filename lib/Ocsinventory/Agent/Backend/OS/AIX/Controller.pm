package Ocsinventory::Agent::Backend::OS::AIX::Controller;
use strict;

sub check {
	return unless can_run('lsdev');
	my @lsdev = `lsdev -Cc adapter -F 'name:type:description'`;	
	return 1 if @lsdev;
	0
}

sub run {
	my $params = shift;
	my $inventory = $params->{inventory};
	
	my $name;
	my $type;
	my $manufacturer;
	
	for(`lsdev -Cc adapter -F 'name:type:description'`){
		chomp($_);
		/^(.+):(.+):(.+)/;
		my $name = $1;
		my $type = $2;
		my $manufacturer = $3;
		$inventory->addController({
                        'NAME'          => $name,
                        'MANUFACTURER'  => $manufacturer,
                        'TYPE'          => $type,
                });
	}
}

1;
