package Ocsinventory::Agent::Backend::OS::AIX::Drives;

use strict;
sub check {can_run("df")}

sub run {
  my $params = shift;
  my $inventory = $params->{inventory};

  my $free;
  my $filesystem;
  my $total;
  my $type;
  my $volumn;  

  my @fs;
  my @fstype;
#Looking for mount points and disk space
# Aix option -kP 
  for(`df -kP`) {

    next if /^Filesystem\s*1024-blocks.*/;

    if (/^(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\n/) {
      $type = $1;
      @fs=`lsfs -c $6`;
      @fstype = split /:/,$fs[1];     
      $filesystem = $fstype[2];
      $total = sprintf("%i",($2/1024));	
      $free = sprintf("%i",($4/1024));
      $volumn = $6;	  
    }

    next if $filesystem =~ /procfs/;

    $inventory->addDrive({
	FREE => $free,
	FILESYSTEM => $filesystem,
	TOTAL => $total,
	TYPE => $type,
	VOLUMN => $volumn
	});

  }
}

1;
