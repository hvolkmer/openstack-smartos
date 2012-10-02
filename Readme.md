## NFS for Mac OS X

 /etc/exports

 /Users/hvolkmer/Priv/code/openstack-smartos -network 192.168.83.0  -mask 255.255.255.0

sudo nfsd enable

showmount -e


## Img stuff
  - needs to be raw

  - 169.254.169.254


## Remove old zfs snapshots

this should be done by OS or vmadm itself:

    zfs list -t snapshot | egrep "@(.*)-disk0" | awk '{print $1}' | while read FS; do zfs destroy $FS; done


## Keystone/Auth Setup

    export OS_TENANT_NAME=admin
    export OS_USERNAME=admin
    export OS_PASSWORD='secrete'
    export OS_AUTH_URL=http://192.168.83.101:5000/v2.0

## Keystone reset

    svcadm disable keystone
    rm /keystone/keystone.sqlite
    /openstack/keystone/bin/keystone-manage --config-file=/openstack/cfg/keystone.conf db_sync
    svcadm enable keystone

## reset glance

    svcadm disable glance-api  glance-registry
    rm /glance/glance.sqlite
    /openstack/glance/bin/glance-manage db_sync
    svcadm enable glance-api  glance-registry

## Adding smartOS zone image for zone tests

    curl -O https://datasets.joyent.com/datasets/f9e4be48-9466-11e1-bc41-9f993f5dff36/smartos64-1.6.3.zfs.bz2
    bunzip smartos64-1.6.3.zfs.bz2
    glance image-create --name "Smartos" --is-public true  --container-format bare --disk-format raw --property zone=true < smartos64-1.6.3.zfs


## Adding cirros test image for KVM tests

	curl -O https://launchpad.net/cirros/trunk/0.3.0/+download/cirros-0.3.0-x86_64-disk.img
    glance image-create --name "Cirros" --is-public true --container-format ovf --disk-format qcow2 < cirros-0.3.0-x86_64-disk.img

