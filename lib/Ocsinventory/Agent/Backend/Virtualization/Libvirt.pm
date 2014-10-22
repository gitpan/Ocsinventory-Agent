package Ocsinventory::Agent::Backend::Virtualization::Libvirt;

use strict;

use XML::Simple;

sub check { can_run('virsh') }

sub run {
    my $params = shift;
    my $inventory = $params->{inventory};


    foreach (`virsh list --all`) {
        if (/^\s+(\d+|\-)\s+(\S+)\s+(\S.+)/) {
            my $name = $2;
            my $status = $3;

            my $status =~ s/^shut off/off/;
            my $xml = `virsh dumpxml $name`;
            my $data = XMLin($xml);

            my $vcpu = $data->{vcpu};
            my $uuid = $data->{uuid};
            my $vmtype = $data->{type};
            my $memory = $1 if $data->{currentMemory} =~ /(\d+)\d{3}$/;

            my $machine = {

                MEMORY => $memory,
                NAME => $name,
                UUID => $uuid,
                STATUS => $status,
                SUBSYSTEM => "libvirt",
                VMTYPE => $vmtype,
                VCPU   => $vcpu,

            };

            $inventory->addVirtualMachine($machine);

        }
    }

}

1;
