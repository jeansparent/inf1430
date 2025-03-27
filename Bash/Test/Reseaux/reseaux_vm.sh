# Start iperf3
echo "Starting iperf3 in deamon mode remotly on vm-reseau-vm.inf1430"
ssh administrateur@vm-reseau-vm.inf1430 'iperf3 -s -D'
echo ""
echo "******************************************"

# iperf for udp
echo "Starting udp test with vm-reseau-vm.inf1430"
echo ""
iperf3 -c vm-reseau-vm.inf1430 -u -b 0 -n 5G -f m
echo ""
echo "******************************************"

# iperf for tcp
echo "Starting tcp test with vm-reseau-vm.inf1430"
echo ""
iperf3 -c vm-reseau-vm.inf1430 -n 5G -b 0 -f m
echo ""
echo "******************************************"
