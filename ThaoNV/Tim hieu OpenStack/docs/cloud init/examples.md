# Một số ví dụ với cloud-config

## Mục lục

1. Cấu hình users và groups

2. Viết ra file mới

3. Thêm yum repository

4. Cấu hình file resolv.conf

5. Thêm apt repositories

6. Chạy commands ở lần boot đầu tiên

7. Cài đặt arbitrary packages

8. Update apt database

9. Chạy câu lệnh apt hoặc yum upgrade

10. Reboot/poweroff khi kết thúc

11. Cấu hình ssh-keys

12. Set up disk

--------

## 1. Cấu hình users và groups

``` sh
# Add groups to the system
# The following example adds the ubuntu group with members foo and bar and
# the group cloud-users.
groups:
  - ubuntu: [foo,bar]
  - cloud-users

# Add users to the system. Users are added after groups are added.
users:
  - default
  - name: foobar
    gecos: Foo B. Bar
    primary-group: foobar
    groups: users
    selinux-user: staff_u
    expiredate: 2012-09-01
    ssh-import-id: foobar
    lock_passwd: false
    passwd: $6$j212wezy$7H/1LT4f9/N3wpgNunhsIqtMj62OKiS3nyNwuizouQc3u7MbYCarYeAHWYPYb2FT.lbioDm2RrkJPb9BZMN1O/
  - name: barfoo
    gecos: Bar B. Foo
    sudo: ALL=(ALL) NOPASSWD:ALL
    groups: users, admin
    ssh-import-id: None
    lock_passwd: true
    ssh-authorized-keys:
      - <ssh pub key 1>
      - <ssh pub key 2>
  - name: cloudy
    gecos: Magic Cloud App Daemon User
    inactive: true
    system: true
  - snapuser: joe@joeuser.io

# Valid Values:
#   name: The user's login name
#   gecos: The user name's real name, i.e. "Bob B. Smith"
#   homedir: Optional. Set to the local path you want to use. Defaults to
#           /home/<username>
#   primary-group: define the primary group. Defaults to a new group created
#           named after the user.
#   groups:  Optional. Additional groups to add the user to. Defaults to none
#   selinux-user:  Optional. The SELinux user for the user's login, such as
#           "staff_u". When this is omitted the system will select the default
#           SELinux user.
#   lock_passwd: Defaults to true. Lock the password to disable password login
#   inactive: Create the user as inactive
#   passwd: The hash -- not the password itself -- of the password you want
#           to use for this user. You can generate a safe hash via:
#               mkpasswd --method=SHA-512 --rounds=4096
#           (the above command would create from stdin an SHA-512 password hash
#           with 4096 salt rounds)
#
#           Please note: while the use of a hashed password is better than
#               plain text, the use of this feature is not ideal. Also,
#               using a high number of salting rounds will help, but it should
#               not be relied upon.
#
#               To highlight this risk, running John the Ripper against the
#               example hash above, with a readily available wordlist, revealed
#               the true password in 12 seconds on a i7-2620QM.
#
#               In other words, this feature is a potential security risk and is
#               provided for your convenience only. If you do not fully trust the
#               medium over which your cloud-config will be transmitted, then you
#               should use SSH authentication only.
#
#               You have thus been warned.
#   no-create-home: When set to true, do not create home directory.
#   no-user-group: When set to true, do not create a group named after the user.
#   no-log-init: When set to true, do not initialize lastlog and faillog database.
#   ssh-import-id: Optional. Import SSH ids
#   ssh-authorized-keys: Optional. [list] Add keys to user's authorized keys file
#   sudo: Defaults to none. Set to the sudo string you want to use, i.e.
#           ALL=(ALL) NOPASSWD:ALL. To add multiple rules, use the following
#           format.
#               sudo:
#                   - ALL=(ALL) NOPASSWD:/bin/mysql
#                   - ALL=(ALL) ALL
#           Note: Please double check your syntax and make sure it is valid.
#               cloud-init does not parse/check the syntax of the sudo
#               directive.
#   system: Create the user as a system user. This means no home directory.
#   snapuser: Create a Snappy (Ubuntu-Core) user via the snap create-user
#             command available on Ubuntu systems.  If the user has an account
#             on the Ubuntu SSO, specifying the email will allow snap to
#             request a username and any public ssh keys and will import
#             these into the system with username specifed by SSO account.
#             If 'username' is not set in SSO, then username will be the
#             shortname before the email domain.
#

# Default user creation:
#
# Unless you define users, you will get a 'ubuntu' user on ubuntu systems with the
# legacy permission (no password sudo, locked user, etc). If however, you want
# to have the 'ubuntu' user in addition to other users, you need to instruct
# cloud-init that you also want the default user. To do this use the following
# syntax:
#    users:
#      - default
#      - bob
#      - ....
#  foobar: ...
#
# users[0] (the first user in users) overrides the user directive.
#
# The 'default' user above references the distro's config:
# system_info:
#   default_user:
#    name: Ubuntu
#    plain_text_passwd: 'ubuntu'
#    home: /home/ubuntu
#    shell: /bin/bash
#    lock_passwd: True
#    gecos: Ubuntu
#    groups: [adm, audio, cdrom, dialout, floppy, video, plugdev, dip, netdev]
```

## 2. Viết ra file mới

``` sh
#cloud-config
# vim: syntax=yaml
#
# This is the configuration syntax that the write_files module
# will know how to understand. encoding can be given b64 or gzip or (gz+b64).
# The content will be decoded accordingly and then written to the path that is
# provided.
#
# Note: Content strings here are truncated for example purposes.
write_files:
-   encoding: b64
    content: CiMgVGhpcyBmaWxlIGNvbnRyb2xzIHRoZSBzdGF0ZSBvZiBTRUxpbnV4...
    owner: root:root
    path: /etc/sysconfig/selinux
    permissions: '0644'
-   content: |
        # My new /etc/sysconfig/samba file

        SMBDOPTIONS="-D"
    path: /etc/sysconfig/samba
-   content: !!binary |
        f0VMRgIBAQAAAAAAAAAAAAIAPgABAAAAwARAAAAAAABAAAAAAAAAAJAVAAAAAAAAAAAAAEAAOAAI
        AEAAHgAdAAYAAAAFAAAAQAAAAAAAAABAAEAAAAAAAEAAQAAAAAAAwAEAAAAAAADAAQAAAAAAAAgA
        AAAAAAAAAwAAAAQAAAAAAgAAAAAAAAACQAAAAAAAAAJAAAAAAAAcAAAAAAAAABwAAAAAAAAAAQAA
        ....
    path: /bin/arch
    permissions: '0555'
-   encoding: gzip
    content: !!binary |
        H4sIAIDb/U8C/1NW1E/KzNMvzuBKTc7IV8hIzcnJVyjPL8pJ4QIA6N+MVxsAAAA=
    path: /usr/bin/hello
    permissions: '0755'
```

## 3. Thêm yum repository

``` sh
#cloud-config
# vim: syntax=yaml
#
# Add yum repository configuration to the system
#
# The following example adds the file /etc/yum.repos.d/epel_testing.repo
# which can then subsequently be used by yum for later operations.
yum_repos:
    # The name of the repository
    epel-testing:
        # Any repository configuration options
        # See: man yum.conf
        #
        # This one is required!
        baseurl: http://download.fedoraproject.org/pub/epel/testing/5/$basearch
        enabled: false
        failovermethod: priority
        gpgcheck: true
        gpgkey: file:///etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL
        name: Extra Packages for Enterprise Linux 5 - Testing
```

## 4. Cấu hình file resolv.conf

``` sh
#cloud-config
#
# This is an example file to automatically configure resolv.conf when the
# instance boots for the first time.
#
# Ensure that your yaml is valid and pass this as user-data when starting
# the instance. Also be sure that your cloud.cfg file includes this
# configuration module in the appropriate section.
#
manage_resolv_conf: true

resolv_conf:
  nameservers: ['8.8.4.4', '8.8.8.8']
  searchdomains:
    - foo.example.com
    - bar.example.com
  domain: example.com
  options:
    rotate: true
    timeout: 1
```

## 5. Thêm apt repositories

``` sh
#cloud-config

# Add apt repositories
#
# Default: auto select based on cloud metadata
#  in ec2, the default is <region>.archive.ubuntu.com
# apt:
#   primary:
#     - arches [default]
#       uri:
#     use the provided mirror
#       search:
#     search the list for the first mirror.
#     this is currently very limited, only verifying that
#     the mirror is dns resolvable or an IP address
#
# if neither mirror is set (the default)
# then use the mirror provided by the DataSource found.
# In EC2, that means using <region>.ec2.archive.ubuntu.com
#
# if no mirror is provided by the DataSource, but 'search_dns' is
# true, then search for dns names '<distro>-mirror' in each of
# - fqdn of this host per cloud metadata
# - localdomain
# - no domain (which would search domains listed in /etc/resolv.conf)
# If there is a dns entry for <distro>-mirror, then it is assumed that there
# is a distro mirror at http://<distro>-mirror.<domain>/<distro>
#
# That gives the cloud provider the opportunity to set mirrors of a distro
# up and expose them only by creating dns entries.
#
# if none of that is found, then the default distro mirror is used
apt:
  primary:
    - arches: [default]
      uri: http://us.archive.ubuntu.com/ubuntu/
# or
apt:
  primary:
    - arches: [default]
      search:
        - http://local-mirror.mydomain
        - http://archive.ubuntu.com
# or
apt:
  primary:
    - arches: [default]
      search_dns: True
```

## 6. Chạy commands ở lần boot đầu tiên

``` sh
#cloud-config

# boot commands
# default: none
# this is very similar to runcmd, but commands run very early
# in the boot process, only slightly after a 'boothook' would run.
# bootcmd should really only be used for things that could not be
# done later in the boot process.  bootcmd is very much like
# boothook, but possibly with more friendly.
# - bootcmd will run on every boot
# - the INSTANCE_ID variable will be set to the current instance id.
# - you can use 'cloud-init-per' command to help only run once
bootcmd:
 - echo 192.168.1.130 us.archive.ubuntu.com >> /etc/hosts
 - [ cloud-init-per, once, mymkfs, mkfs, /dev/vdb ]
```

``` sh
#cloud-config

# run commands
# default: none
# runcmd contains a list of either lists or a string
# each item will be executed in order at rc.local like level with
# output to the console
# - runcmd only runs during the first boot
# - if the item is a list, the items will be properly executed as if
#   passed to execve(3) (with the first arg as the command).
# - if the item is a string, it will be simply written to the file and
#   will be interpreted by 'sh'
#
# Note, that the list has to be proper yaml, so you have to quote
# any characters yaml would eat (':' can be problematic)
runcmd:
 - [ ls, -l, / ]
 - [ sh, -xc, "echo $(date) ': hello world!'" ]
 - [ sh, -c, echo "=========hello world'=========" ]
 - ls -l /root
 - [ wget, "http://slashdot.org", -O, /tmp/index.html ]
```

## 7. Cài đặt arbitrary packages

``` sh
#cloud-config

# Install additional packages on first boot
#
# Default: none
#
# if packages are specified, this apt_update will be set to true
#
# packages may be supplied as a single package name or as a list
# with the format [<package>, <version>] wherein the specifc
# package version will be installed.
packages:
 - pwgen
 - pastebinit
 - [libpython2.7, 2.7.3-0ubuntu3.1]
```

## 8. Update apt database

``` sh
#cloud-config
# Update apt database on first boot (run 'apt-get update').
# Note, if packages are given, or package_upgrade is true, then
# update will be done independent of this setting.
#
# Default: false
# Aliases: apt_update
package_update: false
```

## 9. Chạy câu lệnh apt hoặc yum upgrade

``` sh
#cloud-config

# Upgrade the instance on first boot
# (ie run apt-get upgrade)
#
# Default: false
# Aliases: apt_upgrade
package_upgrade: true
```

## 10. Reboot/poweroff khi kết thúc

``` sh
#cloud-config

## poweroff or reboot system after finished
# default: none
#
# power_state can be used to make the system shutdown, reboot or
# halt after boot is finished.  This same thing can be acheived by
# user-data scripts or by runcmd by simply invoking 'shutdown'.
#
# Doing it this way ensures that cloud-init is entirely finished with
# modules that would be executed, and avoids any error/log messages
# that may go to the console as a result of system services like
# syslog being taken down while cloud-init is running.
#
# If you delay '+5' (5 minutes) and have a timeout of
# 120 (2 minutes), then the max time until shutdown will be 7 minutes.
# cloud-init will invoke 'shutdown +5' after the process finishes, or
# when 'timeout' seconds have elapsed.
#
# delay: form accepted by shutdown.  default is 'now'. other format
#        accepted is +m (m in minutes)
# mode: required. must be one of 'poweroff', 'halt', 'reboot'
# message: provided as the message argument to 'shutdown'. default is none.
# timeout: the amount of time to give the cloud-init process to finish
#          before executing shutdown.
# condition: apply state change only if condition is met.
#            May be boolean True (always met), or False (never met),
#            or a command string or list to be executed.
#            command's exit code indicates:
#               0: condition met
#               1: condition not met
#            other exit codes will result in 'not met', but are reserved
#            for future use.
#
power_state:
 delay: "+30"
 mode: poweroff
 message: Bye Bye
 timeout: 30
 condition: True
```

## 11. Cấu hình ssh-keys

``` sh
#cloud-config

# add each entry to ~/.ssh/authorized_keys for the configured user or the
# first user defined in the user definition directive.
ssh_authorized_keys:
  - ssh-rsa AAAAB3NzaC1yc...
  - ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEA3I7VUf2l...

# Send pre-generated ssh private keys to the server
# If these are present, they will be written to /etc/ssh and
# new random keys will not be generated
#  in addition to 'rsa' and 'dsa' as shown below, 'ecdsa' is also supported
ssh_keys:
  rsa_private: |
    -----BEGIN RSA PRIVATE KEY-----
    MIIBxwIBAAJ....
    -----END RSA PRIVATE KEY-----

  rsa_public: ssh-rsa AAAAB3NzaC1yc...

  dsa_private: |
    -----BEGIN DSA PRIVATE KEY-----
    MIIBuwIBAAKBgQDP2HLu....
    -----END DSA PRIVATE KEY-----

  dsa_public: ssh-dss AAAAB3NzaC1kc3MAAACBAM/...
```

## 12. Set up disk

``` sh
# Cloud-init supports the creation of simple partition tables and file systems
# on devices.

# Default disk definitions for AWS
# --------------------------------
# (Not implemented yet, but provided for future documentation)

disk_setup:
   ephmeral0:
       table_type: 'mbr'
       layout: True
       overwrite: False

fs_setup:
   - label: None,
     filesystem: ext3
     device: ephemeral0
     partition: auto

# Default disk definitions for Windows Azure
# ------------------------------------------

device_aliases: {'ephemeral0': '/dev/sdb'}
disk_setup:
    ephemeral0:
         table_type: mbr
         layout: True
         overwrite: False

fs_setup:
    - label: ephemeral0
      filesystem: ext4
      device: ephemeral0.1
      replace_fs: ntfs


# Default disk definitions for SmartOS
# ------------------------------------

device_aliases: {'ephemeral0': '/dev/sdb'}
disk_setup:
    ephemeral0:
         table_type: mbr
         layout: False
         overwrite: False

fs_setup:
    - label: ephemeral0
      filesystem: ext3
      device: ephemeral0.0

# Cavaut for SmartOS: if ephemeral disk is not defined, then the disk will
#    not be automatically added to the mounts.


# The default definition is used to make sure that the ephemeral storage is
# setup properly.

# "disk_setup": disk partitioning
# --------------------------------

# The disk_setup directive instructs Cloud-init to partition a disk. The format is:

disk_setup:
   ephmeral0:
       table_type: 'mbr'
       layout: 'auto'
   /dev/xvdh:
       table_type: 'mbr'
       layout:
           - 33
           - [33, 82]
           - 33
       overwrite: True

# The format is a list of dicts of dicts. The first value is the name of the
# device and the subsequent values define how to create and layout the
# partition.
# The general format is:
#    disk_setup:
#        <DEVICE>:
#            table_type: 'mbr'
#            layout: <LAYOUT|BOOL>
#            overwrite: <BOOL>
#
# Where:
#    <DEVICE>: The name of the device. 'ephemeralX' and 'swap' are special
#                values which are specific to the cloud. For these devices
#                Cloud-init will look up what the real devices is and then
#                use it.
#
#                For other devices, the kernel device name is used. At this
#                time only simply kernel devices are supported, meaning
#                that device mapper and other targets may not work.
#
#                Note: At this time, there is no handling or setup of
#                device mapper targets.
#
#    table_type=<TYPE>: Currently the following are supported:
#                    'mbr': default and setups a MS-DOS partition table
#                    'gpt': setups a GPT partition table
#
#                Note: At this time only 'mbr' and 'gpt' partition tables
#                    are allowed. It is anticipated in the future that
#                    we'll also have "RAID" to create a mdadm RAID.
#
#    layout={...}: The device layout. This is a list of values, with the
#                percentage of disk that partition will take.
#                Valid options are:
#                    [<SIZE>, [<SIZE>, <PART_TYPE]]
#
#                Where <SIZE> is the _percentage_ of the disk to use, while
#                <PART_TYPE> is the numerical value of the partition type.
#
#                The following setups two partitions, with the first
#                partition having a swap label, taking 1/3 of the disk space
#                and the remainder being used as the second partition.
#                    /dev/xvdh':
#                        table_type: 'mbr'
#                        layout:
#                            - [33,82]
#                            - 66
#                        overwrite: True
#
#                When layout is "true" it means single partition the entire
#                device.
#
#                When layout is "false" it means don't partition or ignore
#                existing partitioning.
#
#                If layout is set to "true" and overwrite is set to "false",
#                it will skip partitioning the device without a failure.
#
#    overwrite=<BOOL>: This describes whether to ride with saftey's on and
#                everything holstered.
#
#                'false' is the default, which means that:
#                    1. The device will be checked for a partition table
#                    2. The device will be checked for a file system
#                    3. If either a partition of file system is found, then
#                        the operation will be _skipped_.
#
#                'true' is cowboy mode. There are no checks and things are
#                    done blindly. USE with caution, you can do things you
#                    really, really don't want to do.
#
#
# fs_setup: Setup the file system
# -------------------------------
#
# fs_setup describes the how the file systems are supposed to look.

fs_setup:
   - label: ephemeral0
     filesystem: 'ext3'
     device: 'ephemeral0'
     partition: 'auto'
   - label: mylabl2
     filesystem: 'ext4'
     device: '/dev/xvda1'
   - cmd: mkfs -t %(filesystem)s -L %(label)s %(device)s
     label: mylabl3
     filesystem: 'btrfs'
     device: '/dev/xvdh'

# The general format is:
#    fs_setup:
#        - label: <LABEL>
#          filesystem: <FS_TYPE>
#          device: <DEVICE>
#          partition: <PART_VALUE>
#          overwrite: <OVERWRITE>
#          replace_fs: <FS_TYPE>
#
# Where:
#     <LABEL>: The file system label to be used. If set to None, no label is
#        used.
#
#    <FS_TYPE>: The file system type. It is assumed that the there
#        will be a "mkfs.<FS_TYPE>" that behaves likes "mkfs". On a standard
#        Ubuntu Cloud Image, this means that you have the option of ext{2,3,4},
#        and vfat by default.
#
#    <DEVICE>: The device name. Special names of 'ephemeralX' or 'swap'
#        are allowed and the actual device is acquired from the cloud datasource.
#        When using 'ephemeralX' (i.e. ephemeral0), make sure to leave the
#        label as 'ephemeralX' otherwise there may be issues with the mounting
#        of the ephemeral storage layer.
#
#        If you define the device as 'ephemeralX.Y' then Y will be interpetted
#        as a partition value. However, ephermalX.0 is the _same_ as ephemeralX.
#
#    <PART_VALUE>:
#        Partition definitions are overwriten if you use the '<DEVICE>.Y' notation.
#
#        The valid options are:
#        "auto|any": tell cloud-init not to care whether there is a partition
#            or not. Auto will use the first partition that does not contain a
#            file system already. In the absence of a partition table, it will
#            put it directly on the disk.
#
#            "auto": If a file system that matches the specification in terms of
#            label, type and device, then cloud-init will skip the creation of
#            the file system.
#
#            "any": If a file system that matches the file system type and device,
#            then cloud-init will skip the creation of the file system.
#
#            Devices are selected based on first-detected, starting with partitions
#            and then the raw disk. Consider the following:
#                NAME     FSTYPE LABEL
#                xvdb
#                |-xvdb1  ext4
#                |-xvdb2
#                |-xvdb3  btrfs  test
#                \-xvdb4  ext4   test
#
#            If you ask for 'auto', label of 'test, and file system of 'ext4'
#            then cloud-init will select the 2nd partition, even though there
#            is a partition match at the 4th partition.
#
#            If you ask for 'any' and a label of 'test', then cloud-init will
#            select the 1st partition.
#
#            If you ask for 'auto' and don't define label, then cloud-init will
#            select the 1st partition.
#
#            In general, if you have a specific partition configuration in mind,
#            you should define either the device or the partition number. 'auto'
#            and 'any' are specifically intended for formating ephemeral storage or
#            for simple schemes.
#
#        "none": Put the file system directly on the device.
#
#        <NUM>: where NUM is the actual partition number.
#
#    <OVERWRITE>: Defines whether or not to overwrite any existing
#        filesystem.
#
#        "true": Indiscriminately destroy any pre-existing file system. Use at
#            your own peril.
#
#        "false": If an existing file system exists, skip the creation.
#
#    <REPLACE_FS>: This is a special directive, used for Windows Azure that
#        instructs cloud-init to replace a file system of <FS_TYPE>. NOTE:
#        unless you define a label, this requires the use of the 'any' partition
#        directive.
#
# Behavior Caveat: The default behavior is to _check_ if the file system exists.
#    If a file system matches the specification, then the operation is a no-op.
```
