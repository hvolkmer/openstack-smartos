set -x
set -e

DEV_MACHINE_IP=$1
LOCAL_DEV_PATH=$2

mkdir -p /openstack
mount ${DEV_MACHINE_IP}:${LOCAL_DEV_PATH} /openstack
/opt/local/bin/pkgin -y import /openstack/devsetup/controller-packages.txt
pkgin install gcc-compiler
/opt/local/bin/easy_install-2.7 pip
CFLAGS="-m64" /opt/local/bin/pip install -r /openstack/keystone/tools/pip-requires
mkdir -p /keystone
svccfg import /openstack/smf/keystone.xml

/openstack/keystone/bin/keystone-manage --config-file=/openstack/cfg/keystone.conf db_sync

svcadm enable keystone

# Setting up dev users in keystone

export SERVICE_TOKEN=012345SECRET99TOKEN012345
export SERVICE_ENDPOINT=http://192.168.83.101:35357/v2.0/
export ENABLED_SERVICES="n-api g-api n-cpu"
export KEYSTONE_CATALOG_BACKEND="sql"
export SERVICE_HOST="192.168.83.100"
bash /openstack/devsetup/keystone_data.sh
