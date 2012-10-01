## NFS for Mac OS X

 /etc/exports

 /Users/hvolkmer/Priv/code/openstack-smartos -network 192.168.83.0  -mask 255.255.255.0

sudo nfsd enable

showmount -e

## Setup code vm
mkdir /openstack; mount 192.168.83.1:/Users/hvolkmer/Priv/code/openstack-smartos /openstack


## Img stuff
  - needs to be raw

  - 169.254.169.254


## Remove old zfs snapshots 

this should be done by OS or vmadm itself:

    zfs list -t snapshot | egrep "@(.*)-disk0" | awk '{print $1}' | while read FS; do zfs destroy $FS; done
