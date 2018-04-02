## Configuration multiwan

/interface list
add name=ISP-2

add name=ISP-all include=ISP-1,ISP-2

### this only example --->
/interface list member
add list=ISP-2 interface=ether2

### this only example <---

### unclude address list bogon from https://wiki.mikrotik.com/wiki/BOGON_Address_List

/ip firewall address-list
add list="BOGONS" address=0.0.0.0/8
add list="BOGONS" address=10.0.0.0/8
add list="BOGONS" address=100.64.0.0/10
add list="BOGONS" address=127.0.0.0/8
add list="BOGONS" address=169.254.0.0/16
add list="BOGONS" address=172.16.0.0/12
add list="BOGONS" address=192.0.0.0/24
add list="BOGONS" address=192.0.2.0/24
add list="BOGONS" address=192.168.0.0/16
add list="BOGONS" address=198.18.0.0/15
add list="BOGONS" address=198.51.100.0/24
add list="BOGONS" address=203.0.113.0/24
add list="BOGONS" address=224.0.0.0/3

/ip firewall mangle

add chain=prerouting in-interface-list=ISP-2 connection-state=new dst-address-type=unicast src-address-list=ISP-2 action=mark-connection new-connection-mark=Conn-ISP-2 passthrough=no
add chain=output connection-mark=Conn-ISP-2 action=mark-routing new-routing-mark=Routing-ISP-2 passthrough=no
add chain=output src-address-list=ISP-2 dst-address-list=!BOGONS action=mark-routing new-routing-mark=Routing-ISP-2 passthrough=no
add chain=prerouting in-interface-list=!ISP-2 action=mark-routing new-routing-mark=Routing-ISP-2 passthrough=no

###### Setting ISP-1 ----->

/interface list
add name=ISP-1

/interface list member
add list=ISP-1 interface=ether1

/ip firewall mangle
add chain=prerouting in-interface-list=ISP-1 connection-state=new dst-address-type=unicast src-address-list=ISP-1 action=mark-connection new-connection-mark=Conn-ISP-1 passthrough=no
add chain=output connection-mark=Conn-ISP-1 action=mark-routing new-routing-mark=Routing-ISP-1 passthrough=no
add chain=output src-address-list=ISP-1 dst-address-list=!BOGONS action=mark-routing new-routing-mark=Routing-ISP-1 passthrough=no
add chain=prerouting in-interface-list=!ISP-1 action=mark-routing new-routing-mark=Routing-ISP-1 passthrough=no

/ip firewall address-list
add list=ISP-1 address=1.1.1.0/24

/ip firewall nat
## if network used one ip address -->
add chain=srcnat ipsec-policy=out,none out-interface-list=ISP-1 action=masquerade
## if network used one ip address <--
add chain=srcnat ipsec-policy=out,none out-interface-list=ISP-1 action=src-nat to-address=1.1.1.2
###### Setting ISP-1 <-----