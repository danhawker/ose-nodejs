# Kickstart for RHEL 6.7

#version=DEVEL
install
reboot
url --url=http://download.lab.bos.redhat.com/released/RHEL-6/6.7/Server/s390x/os/
lang en_US.UTF-8
rootpw  --iscrypted $6$lh5puq2inbkzURqF$lCco4EGpp9TUY6X20VnAp74yv9JGPZ/Uv971x8F/K.6I9OXoM0GfiBI8sa9yJ41bPmHCfm8wQul93aMYm.R1P1
firewall --service=ssh
authconfig --enableshadow --passalgo=sha512
selinux --enforcing
timezone --utc Europe/London
bootloader --location=mbr --driveorder=dasdb,dasdc --append="crashkernel=auto"

# The following is the partition information you requested
# Note that any partitions you deleted are not expressed
# here so unless you clear all partitions first, this is
# not guaranteed to work

# Ensure the disks are cleared.
zerombr
clearpart --all --initlabel --drives=dasdb,dasdc
#clearpart --linux --drives=dasdb,dasdc
ignoredisk --only-use=dasdc,dasdb

# partition the 2 disks
part pv.094005 --grow --size=1
part pv.094009 --grow --size=1

volgroup vg_train5 --pesize=4096 pv.094005 pv.094009
logvol /boot --fstype=ext4 --name=lv_boot --vgname=vg_train5 --size=500
logvol / --fstype=ext4 --name=lv_root --vgname=vg_train5 --grow --size=1024 --maxsize=51200
logvol swap --name=lv_swap --vgname=vg_train5 --grow --size=469 --maxsize=469


%packages
@core
@server-policy

%post --interpreter=/bin/bash

# Add local repo(s)
cat > /etc/yum.repo.d/rhel67.repo <<\EOF
[RHEL67]
name=Red Hat Enterprise Linux $releasever - $basearch
baseurl=http://download.lab.bos.redhat.com/released/RHEL-6/6.7/Server/s390x/os/
enabled=1
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-redhat-release
EOF



%end
