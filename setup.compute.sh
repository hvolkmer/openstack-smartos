echo "192.168.83.123   eba8c402-430a-46df-86d8-17cc607b11e7" >> /etc/hosts
svccfg import /openstack/smf/openstack-compute.xml
svcadm enable compute
mount -f lofs /zones/usr-overlay/node_modules/ /usr/vm/node_modules/
