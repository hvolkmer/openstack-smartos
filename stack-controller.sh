DEV_MACHINE_IP=$1
LOCAL_DEV_PATH=$2

 mkdir -p /openstack
 mount ${DEV_MACHINE_IP}:${LOCAL_DEV_PATH} /openstack
 /opt/local/bin/pkgin -y import /openstack/controller-packages.txt
 /opt/local/bin/easy_install-2.7 pip
 CFLAGS="-m64" /opt/local/bin/pip install -r /openstack/keystone/tools/pip-requires
 CFLAGS="-m64" /opt/local/bin/pip install -r /openstack/glance/tools/pip-requires
 CFLAGS="-m64" /opt/local/bin/pip install -r /openstack/nova/tools/pip-requires
 mkdir -p /glance
 mkdir -p /keystone
 svccfg import /openstack/smf/glance.xml
 svccfg import /openstack/smf/keystone.xml
 svccfg import /openstack/smf/nova.xml
 svcadm enable mysql keystone glance nova-api

mysqladmin -u root create nova
GRANT ALL ON nova.* TO 'nova'@`nova-controller.local` IDENTIFIED BY 'novapwd';

/openstack/nova/bin/nova-manage --config-file=/openstack/cfg/nova.conf db sync

pip install -e git://github.com/openstack/keystone.git@ab6be05068068b0902db44b1d60f56eea4fe1215#egg=keystone-dev
pip install python-novaclient

keystone-manage --config-file=/openstack/cfg/keystone.conf db_sync

# Setting up dev users in keystone

export SERVICE_TOKEN=012345SECRET99TOKEN012345
export SERVICE_ENDPOINT=http://192.168.83.100:35357/v2.0/
export ENABLED_SERVICES="n-api g-api n-cpu"
export KEYSTONE_CATALOG_BACKEND="sql"
bash /openstack/keystone_data.sh

-e git://github.com/openstack/python-keystoneclient@6c127df0f3ef75b1afbae6aaf991e63246f77fa7#egg=python-novaclient-dev
