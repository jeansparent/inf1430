# Start iperf3
ssh administrateur@vm-reseau-vm.inf1430 'iperf3 -s -D'

# iperf for udp
iperf3 -c vm-reseau-vm.inf1430 -u -b 0 -n 5G -f m

# iperf for tcp
iperf3 -c vm-reseau-vm.inf1430 -n 5G -b 0 -f m


