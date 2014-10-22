package Ocsinventory::Agent::Backend::OS::Linux::Archs::m68k::CPU;
use strict;

sub check { can_read("/proc/cpuinfo") }

sub run {
    my $params = shift;
    my $inventory = $params->{inventory};

    my @cpu;
    my $current;
    open CPUINFO, "</proc/cpuinfo" or warn;
    foreach(<CPUINFO>) {
        print;
        if (/^CPU\s+:\s*:/) {

            if ($current) {
                $inventory->addCPU($current);
            }

            $current = {
                ARCH => 'm68k',
            };

        } else {

            $current->{TYPE} = $1 if /CPU:\s+(\S.*)/;
            $current->{SPEED} = $1 if /Clocking:\s+:\s+(\S.*)/;

        }
    }

    # The last one
    $inventory->addCPU($current);
}

1
