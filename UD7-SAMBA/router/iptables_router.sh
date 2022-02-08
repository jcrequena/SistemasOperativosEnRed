LAN=enp0s8
WAN=enp0s3

#Activar forwarding
echo 1 > /proc/sys/net/ipv4/ip_forward

iptables -A FORWARD -i $LAN -j ACCEPT
iptables -t nat -A POSTROUTING -o $WAN -j MASQUERADE 
