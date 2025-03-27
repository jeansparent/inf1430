FQDN='vm-reseau-docker.inf1430'

# iperf for udp
echo "Starting udp test with $FQDN"
echo ""
iperf3 -c $FQDN -u -b 0 -n 5G -f m
echo ""
echo "******************************************"

# iperf for tcp
echo "Starting tcp test with $FQDN"
echo ""
iperf3 -c $FQDN -n 5G -b 0 -f m
echo ""
echo "******************************************"
