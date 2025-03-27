# iperf for udp
iperf3 -c vm-reseau-docker.inf1430 -u -b 0 -n 5G -f m

# iperf for tcp
iperf3 -c vm-reseau-docker.inf1430 -n 5G -b 0 -f m