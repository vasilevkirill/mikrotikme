/ip firewall filter
add chain=input in-interface-list=ISP connection-state=invalid action=drop
add chain=input in-interface-list=ISP connection-state=established,related,untracked action=accept
add chain=input in-interface-list=ISP protocol=tcp dst-port=22 action=jump jump-target=ssh_bruteforce
add chain=input in-interface-list=ISP protocol=tcp dst-port=8291 action=accept
add chain=input in-interface-list=ISP action=drop

add chain=forward in-interface-list=ISP ipsec-policy=in,ipsec action=accept
add chain=forward in-interface-list=ISP connection-state=invalid action=drop
add chain=forward in-interface-list=ISP connection-state=established,related,untracked action=accept
add chain=forward in-interface-list=ISP connection-nat-state=dstnat action=accept
add chain=forward in-interface-list=ISP action=drop

add chain=ssh_bruteforce src-address-list=ssh_bruteforce_stop action=drop
add chain=ssh_bruteforce src-address-list=ssh_bruteforce_st_4 action=add-src-to-address-list address-list=ssh_bruteforce_stop address-list-timeout=500m
add chain=ssh_bruteforce src-address-list=ssh_bruteforce_st_3 action=add-src-to-address-list address-list=ssh_bruteforce_st_4 address-list-timeout=10m
add chain=ssh_bruteforce src-address-list=ssh_bruteforce_st_2 action=add-src-to-address-list address-list=ssh_bruteforce_st_3 address-list-timeout=10m
add chain=ssh_bruteforce src-address-list=ssh_bruteforce_st_1 action=add-src-to-address-list address-list=ssh_bruteforce_st_2 address-list-timeout=10m
add chain=ssh_bruteforce action=add-src-to-address-list address-list=ssh_bruteforce_st_1 address-list-timeout=10m
add chain=ssh_bruteforce action=accept
