/ip firewall filter
add action=accept chain=input comment=\
    "defconf: accept established,related,untracked" connection-state=\
    established,related,untracked
add action=drop chain=input comment="defconf: drop invalid" connection-state=\
    invalid in-interface-list=WAN-IL
add action=accept chain=input comment="defconf: accept ICMP" \
    in-interface-list=!WAN-IL protocol=icmp
add action=accept chain=input comment="Input: accept management services" \
    dst-port=8291,443,22 protocol=tcp src-address-list=Admin-AddrList
add action=accept chain=input comment="Input: accept DNS for !WAN" dst-port=\
    53 in-interface-list=!WAN-IL protocol=tcp
add action=accept chain=input comment="Input: accept DNS for !WAN" dst-port=\
    53 in-interface-list=!WAN-IL protocol=udp
# add action=accept chain=input comment=\
#    "defconf: accept to local loopback (for CAPsMAN)" disabled=yes \
#    dst-address=127.0.0.1
add action=drop chain=input comment="non-defconf: drop all"
add action=accept chain=forward comment="defconf: accept in ipsec policy" \
    ipsec-policy=in,ipsec
add action=accept chain=forward comment="defconf: accept out ipsec policy" \
    ipsec-policy=out,ipsec
add action=fasttrack-connection chain=forward comment="defconf: fasttrack" \
    connection-state=established,related hw-offload=yes
add action=accept chain=forward comment=\
    "defconf: accept established,related, untracked" connection-state=\
    established,related,untracked
add action=drop chain=forward comment="defconf: drop invalid" \
    connection-state=invalid in-interface-list=WAN-IL
add action=drop chain=forward comment=\
    "defconf: drop all from WAN not DSTNATed" connection-nat-state=!dstnat \
    connection-state=new in-interface-list=WAN-IL
add action=accept chain=forward comment="Forward: Servers Networks" \
    src-address-list=Servers-AddrList
add action=drop chain=forward disabled=no log=no
#/ip firewall nat
#add action=masquerade chain=srcnat comment="defconf: masquerade" \
#    ipsec-policy=out,none out-interface=ether5-WAN src-address=192.168.0.0/20 \
#    to-addresses=192.168.1.121 disabled=yes
#add action=masquerade chain=srcnat comment="defconf: masquerade" disabled=yes \
#    dst-address=!192.168.14.0/24 ipsec-policy=out,none out-interface=\
#    ether5-WAN src-address=192.168.14.0/24 to-addresses=192.168.1.121
#add action=src-nat chain=srcnat dst-address=!192.168.16.0/24 \
#    out-interface-list=WAN src-address=192.168.16.0/24 to-addresses=\
#    95.31.12.127
