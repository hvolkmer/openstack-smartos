DEV_MACHINE_IP=$1
LOCAL_DEV_PATH=$2

mkdir -p /openstack
mount ${DEV_MACHINE_IP}:${LOCAL_DEV_PATH} /openstack
/opt/local/bin/pkgin -y import /openstack/devsetup/controller-packages.txt
/opt/local/bin/easy_install-2.7 pip

# Setup glance
CFLAGS="-m64" /opt/local/bin/pip install -r /openstack/glance/tools/pip-requires

mkdir -p /glance
svccfg import /openstack/smf/glance.xml

# Setup nova
CFLAGS="-m64" /opt/local/bin/pip install -r /openstack/nova/tools/pip-requires

svccfg import /openstack/smf/nova.xml
svcadm enable mysql nova-api nova-scheduler nova-network

mysqladmin -u root create nova
GRANT ALL ON nova.* TO 'nova'@`nova-controller.local` IDENTIFIED BY 'novapwd';


/openstack/nova/bin/nova-manage --config-file=/openstack/cfg/nova.conf db sync

/openstack/nova/bin/nova-manage --config-file=/openstack/cfg/nova.conf network create --label=public --fixed_range_v4=192.168.83.0/24  --vlan=101

/openstack/nova/bin/nova-manage --config-file=/openstack/cfg/nova.conf fixed reserve 192.168.83.1   # host ip
/openstack/nova/bin/nova-manage --config-file=/openstack/cfg/nova.conf fixed reserve 192.168.83.2   # nat router
/openstack/nova/bin/nova-manage --config-file=/openstack/cfg/nova.conf fixed reserve 192.168.83.100 # controller
/openstack/nova/bin/nova-manage --config-file=/openstack/cfg/nova.conf fixed reserve 192.168.83.101 # keystone
/openstack/nova/bin/nova-manage --config-file=/openstack/cfg/nova.conf fixed reserve 192.168.83.129 # compute node itself

/opt/local/bin/pip install python-novaclient
