set -x
set -e

LOCAL_DEV_PATH=/Users/hvolkmer/Priv/code/openstack-smartos
DEV_MACHINE_IP=192.168.83.1

mkdir -p /openstack
mount ${DEV_MACHINE_IP}:${LOCAL_DEV_PATH} /openstack
cd /
curl -k http://pkgsrc.joyent.com/sdc6/2012Q1/x86_64/bootstrap.tar.gz | gzcat | tar -xf -
/opt/local/sbin/pkg_admin rebuild
/opt/local/bin/pkgin -y up
/opt/local/bin/pkgin -y import /openstack/compute-packages.txt

imgadm update
imgadm import f9e4be48-9466-11e1-bc41-9f993f5dff36

vmadm create -f /openstack/controller.json
CONTROLLER_ZONE=$(vmadm lookup hostname=nova-controller)
alias on_controller="zlogin $CONTROLLER_ZONE"
on_controller /openstack/stack-controller.sh ${DEV_MACHINE_IP} ${LOCAL_DEV_PATH} 

ln -s /opt/local/bin/python2.7 /opt/local/bin/python
 /opt/local/bin/easy_install-2.7 pip

 CFLAGS="-m64" /opt/local/bin/pip install -r /openstack/nova/tools/pip-requires



svccfg import /openstack/smf/compute.xml
svcadm enable compute