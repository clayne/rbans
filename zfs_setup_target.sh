# Script for setting up ZFS pools necessary to store all the data

sudo apt-get install -y software-properties-common

# Add zfs to sources list
sed -i 's/main/main contrib non-free/g' /etc/apt/sources.list
sudo apt-get install linux-headers-amd64
sudo apt-get install zfs-dkms zfsutils-linux

# Install ZFS pool with appropriate options
cd /dev/disk
sudo zpool create -f tank -o ashift=12 -o autoreplace=on -o autoexpand=on raidz2 $(find "$(pwd)" -name "scsi-*" -printf "%f ")
sudo zfs set atime=off tank
sudo zfs set acltype=posixacl tank
sudo zfs set xattr=sa tank
sudo zfs set compression=lz4 tank
sudo zfs set dedup=off tank

# Create a zvol for connecting via iSCSI
sudo zfs create -o dedup=off -o volblocksize=32K -V 13T tank/primary_pool

# TargetCLI iscsi setup, see this link:
# https://www.rootusers.com/how-to-configure-an-iscsi-target-and-initiator-in-linux/

# Open TCP 3260 to allow all connections
sudo apt-get install -y firewalld

firewall-cmd --permanent --add-port=3260/tcp
firewall-cmd --reload

