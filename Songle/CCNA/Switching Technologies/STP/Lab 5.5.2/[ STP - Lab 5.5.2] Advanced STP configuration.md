# STP Lab 5.5.2 : Challenge Spanning Tree Protocol


![Imgur](https://i.imgur.com/FpSbL0R.jpg)

![Imgur](https://i.imgur.com/KqcR5IV.jpg)

![Imgur](https://i.imgur.com/g8iAKCM.jpg)

### Learning Objectives


Upon completion of this lab, you will be able to:

• Cable a network according to the topology diagram
• Erase the startup configuration and reload the default configuration, setting a switch to the default
state
• Perform basic configuration tasks on a switch
• Configure VLAN Trunking Protocol (VTP) on all switches
• Observe and explain the default behavior of Spanning Tree Protocol (STP, 802.1D)
• Modify the placement of the spanning tree root
• Observe the response to a change in the spanning tree topology
• Explain the limitations of 802.1D STP in supporting continuity of service
• Configure Rapid STP (802.1W)
• Observe and explain the improvements offered by Rapid STP

### Task 1: Prepare the Network

#### Step 1: Cable a network that is similar to the one in the topology diagram.

You can use any current switch in your lab as long as it has the required interfaces shown in the topology
diagram. The output shown in this lab is based on Cisco 2960 switches. Other switch models may
produce different output.
Set up console connections to all three switches.
Step 2: Clear any existing configurations on the switches.
Clear NVRAM, delete the vlan.dat file, and reload the switches. Refer to Lab 2.5.1 for the procedure. After
the reload is complete, use the show vlan privileged EXEC command to confirm that only default VLANs
exist and that all ports are assigned to VLAN 1.


S1#show vlan

```
VLAN Name           	Status           Ports
---- -------------------------------- --------- -----------------------------
1  default 				active       Fa0/1, Fa0/2, Fa0/3, Fa0/4
									 Fa0/5, Fa0/6, Fa0/7, Fa0/8
									 Fa0/9, Fa0/10, Fa0/11, Fa0/12
									 Fa0/13, Fa0/14, Fa0/15,Fa0/16
									 Fa0/17, Fa0/18, Fa0/19,Fa0/20
									 Fa0/21, Fa0/22, Fa0/23,Fa0/24
									 Gig1/1, Gig1/2
1002 fddi-default 		active
1003 token-ring-default active
1004 fddinet-default	active
1005 trnet-default 		active
```

#### Step 3: Disable all ports by using the shutdown command.


Ensure that the initial switch port states are inactive with the shutdown command. 
Use the interfacerange command to simplify this task.

```
S1(config)#interface range fa0/1-24
S1(config-if-range)#shutdown
S1(config-if-range)#interface range gi0/1-2
S1(config-if-range)#shutdown
S2(config)#interface range fa0/1-24
S2(config-if-range)#shutdown
S2(config-if-range)#interface range gi0/1-2
S2(config-if-range)#shutdown
S3(config)#interface range fa0/1-24
S3(config-if-range)#shutdown
S3(config-if-range)#interface range gi0/1-2
S3(config-if-range)#shutdown
```


#### Step 4: Re-enable the user ports on S2 in access mode.

Refer to the topology diagram to determine which switch ports on S2 are activated for end-user device
access. These three ports will be configured for access mode and enabled with the no shutdown
command.

```
S2(config)#interface range fa0/6, fa0/11, fa0/18
S2(config-if-range)#switchport mode access
S2(config-if-range)#no shutdown
```


### Task 2: Perform Basic Switch Configurations


Configure the S1, S2, and S3 switches according to the following guidelines:
• Configure the switch hostname.
• Disable DNS lookup.
• Configure an EXEC mode password of class.
• Configure a password of cisco for console connections.
• Configure a password of cisco for vty connections.
(Output for S1 shown)

```
Switch>enable
Switch#configure terminal
Enter configuration commands, one per line. End with CNTL/Z.
Switch(config)#hostname S1
S1(config)#enable secret class
S1(config)#no ip domain-lookup
S1(config)#line console 0
S1(config-line)#password cisco
S1(config-line)#login
S1(config-line)#line vty 0 15
S1(config-line)#password cisco
S1(config-line)#login
S1(config-line)#end
%SYS-5-CONFIG_I: Configured from console by console
S1#copy running-config startup-config
Destination filename [startup-config]?
Building configuration...
[OK]
```

### Task 3: Configure Host PCs


Configure the Ethernet interfaces of PC1, PC2, and PC3 with the IP address, subnet mask, and gateway
indicated in the addressing table at the beginning of the lab.


### Task 4: Configure VLANs


#### Step 1: Configure VTP.
Configure VTP on the three switches using the following table. Remember that VTP domain names and
passwords are case-sensitive. The default operating mode is server.


|Switch Name|VTP Operating Mode|VTP Domain|VTP Password|
|----------|------------------|----------|------------|
|S1| Server| Lab5 |cisco|
|S2 |Client |Lab5 |cisco|
|S3 |Client| Lab5 |cisco|


```
S1(config)#vtp mode server
Device mode already VTP SERVER.
S1(config)#vtp domain Lab5
Changing VTP domain name from NULL to Lab5
S1(config)#vtp password cisco
Setting device VLAN database password to cisco
S1(config)#end
S2(config)#vtp mode client
Setting device to VTP CLIENT mode
S2(config)#vtp domain Lab5
Changing VTP domain name from NULL to Lab5
S2(config)#vtp password cisco
Setting device VLAN database password to cisco
S2(config)#end
S3(config)#vtp mode client
Setting device to VTP CLIENT mode
S3(config)#vtp domain Lab5
Changing VTP domain name from NULL to Lab5
S3(config)#vtp password cisco
Setting device VLAN database password to cisco
S3(config)#end
```

#### Step 2: Configure Trunk Links and Native VLAN

Configure trunking ports and native VLAN. For each switch, configure ports Fa0/1 through Fa0/4 as
trunking ports. Designate VLAN 99 as the native VLAN for these trunks. Use the interface range
command in global configuration mode to simplify this task. Remember that these ports were disabled in
a previous step and must be re-enabled using the no shutdown command.

```
S1(config)#interface range fa0/1-4
S1(config-if-range)#switchport mode trunk
S1(config-if-range)#switchport trunk native vlan 99
S1(config-if-range)#no shutdown
S1(config-if-range)#end
```

```
S2(config)# interface range fa0/1-4
S2(config-if-range)#switchport mode trunk
S2(config-if-range)#switchport trunk native vlan 99
S2(config-if-range)#no shutdown
S2(config-if-range)#end
```

```
S3(config)# interface range fa0/1-4
S3(config-if-range)#switchport mode trunk
S3(config-if-range)#switchport trunk native vlan 99
S3(config-if-range)#no shutdown
S3(config-if-range)#end
```


#### Step 3: Configure the VTP server with VLANs.


VTP allows you to configure VLANs on the VTP server and have those VLANs populated to the VTP
clients in the domain. This ensures consistency in the VLAN configuration across the network.
Configure the following VLANS on the VTP server:


|VLAN |VLAN Name|
|-----|---------|
|VLAN 99 |management|
|VLAN 10 |faculty-staff|
|VLAN 20 |students|
|VLAN 30 |guest|

```
S1(config)#vlan 99
S1(config-vlan)#name management
S1(config-vlan)#exit
S1(config)#vlan 10
S1(config-vlan)#name faculty-staff
S1(config-vlan)#exit
S1(config)#vlan 20
S1(config-vlan)#name students
S1(config-vlan)#exit
S1(config)#vlan 30
S1(config-vlan)#name guest
S1(config-vlan)#exit
```


#### Step 4: Verify the VLANs.

Use the **show vlan brief** command on S2 and S3 to verify that all four VLANs have been distributed to
the client switches

![Imgur](https://i.imgur.com/Rla5u0m.jpg)


#### Step 5: Configure the management interface address on all three switches.

```
S1(config)#interface vlan99
S1(config-if)#ip address 172.17.99.11 255.255.255.0
S1(config-if)#no shutdown
```

```
S2(config)#interface vlan99
S2(config-if)#ip address 172.17.99.12 255.255.255.0
S2(config-if)#no shutdown
```

```
S3(config)#interface vlan99
S3(config-if)#ip address 172.17.99.13 255.255.255.0
S3(config-if)#no shutdown
```

Verify that the switches are correctly configured by pinging between them. From S1, ping the
management interface on S2 and S3. From S2, ping the management interface on S3.
Were the pings successful? ___________________________________________
If not, troubleshoot the switch configurations and try again.



#### Step 6: Assign switch ports to the VLANs.

Assign ports to VLANs on S2. Refer to the port assignments table at the beginning of the lab.

```
S2(config)#interface range fa0/5-10
S2(config-if-range)#switchport access vlan 30
S2(config-if-range)#interface range fa0/11-17
S2(config-if-range)#switchport access vlan 10
S2(config-if-range)#interface range fa0/18-24
S2(config-if-range)#switchport access vlan 20
S2(config-if-range)#end
S2#copy running-config startup-config
Destination filename [startup-config]? [enter]
Building configuration...
[OK]
S2#
```


### Task 5: Configure Spanning Tree


#### Step 1: Examine the default configuration of 802.1D STP.

On each switch, display the spanning tree table with the show spanning-tree command. The output is
shown for S1 only. Root selection varies depending on the BID of each switch in your lab

![Imgur](https://i.imgur.com/s92EHuU.jpg)

![Imgur](https://i.imgur.com/lsBUUAc.jpg)

![Imgur](https://i.imgur.com/4gl00PQ.jpg)

#### Step 2: Examine the output.

Answer the following questions based on the output.

1. What is the bridge ID priority for switches S1, S2, and S3 on VLAN 99?

a. S1 _______
b. S2 _______
c. S3 _______

2. What is the bridge ID priority for S1 on VLANs 10, 20, 30, and 99?

b. VLAN 20______
c. VLAN 30______
d. VLAN 99______

3. Which switch is the root for the VLAN 99 spanning tree? ________________

4. On VLAN 99, which spanning tree ports are in the blocking state on the root switch?
_________________

5. On VLAN 99, which spanning tree ports are in the blocking state on the non-root switches?
________________________

6. How does STP elect the root switch? _________________________

7. Since the bridge priorities are all the same, what else does the switch use to determine the root?
________________________

### Task 6: Optimizing STP

Because there is a separate instance of the spanning tree for every active VLAN, a separate root election
is conducted for each instance. If the default switch priorities are used in root selection, the same root is
elected for every spanning tree, as we have seen. This could lead to an inferior design. Some reasons to
control the selection of the root switch include:

• The root switch is responsible for generating BPDUs in STP 802.1D and is the focal point for
spanning tree control traffic. The root switch must be capable of handling this additional
processing load.

• The placement of the root defines the active switched paths in the network. Random placement is
likely to lead to suboptimal paths. Ideally the root is in the distribution layer.

• Consider the topology used in this lab. Of the six trunks configured, only two are carrying traffic.
While this prevents loops, it is a waste of resources. Because the root can be defined on the
basis of the VLAN, you can have some ports blocking for one VLAN and forwarding for another.
This is demonstrated below.

In this example, it has been determined that the root selection using default values has led to underutilization of the available switch trunks. Therefore, it is necessary to force another switch to become the
root switch for VLAN 99 to impose some load-sharing on the trunks.
Selection of the root switch is accomplished by changing the spanning-tree priority for the VLAN.
Because the default root switch may vary in your lab environment, we will configure S1 and S3 to be the
root switches for specific VLANs. The default priority, as you have observed, is 32768 plus the VLAN ID.
The lower number indicates a higher priority for root selection. Set the priority for VLAN 99 on S3 to 4096.

```
S3(config)#spanning-tree vlan 99 ?
forward-time Set the forward delay for the spanning tree
hello-time Set the hello interval for the spanning tree
max-age Set the max age interval for the spanning tree
priority Set the bridge priority for the spanning tree
root Configure switch as root
<cr>
```

```
S3(config)#spanning-tree vlan 99 priority ?
<0-61440> bridge priority in increments of 4096
S3(config)#spanning-tree vlan 99 priority 4096
S3(config)#exit
```


Set the priority for VLANs 1, 10, 20, and 30 on S1 to 4096. Once again, the lower number indicates a
higher priority for root selection.

```
S1(config)#spanning-tree vlan 1 priority 4096
S1(config)#spanning-tree vlan 10 priority 4096
S1(config)#spanning-tree vlan 20 priority 4096
S1(config)#spanning-tree vlan 30 priority 4096
S1(config)#exit
```


Give the switches a little time to recalculate the spanning tree and then check the tree for VLAN 99 on
switch S1 and switch S3.

![Imgur](https://i.imgur.com/46GSJPH.jpg)

![Imgur](https://i.imgur.com/GUCOCms.jpg)

Which switch is the root for VLAN 99? _____________
On VLAN 99, which spanning tree ports are in the blocking state on the new root switch? ____________
On VLAN 99, which spanning tree ports are in the blocking state on the old root switch? ____________
Compare the S3 VLAN 99 spanning tree above with the S3 VLAN 10 spanning tree.


S3#show spanning-tree vlan 10

```
VLAN0010
Spanning tree enabled protocol ieee
Root ID Priority 4106
Address 0019.068d.6980
Cost 19
Port 1 (FastEthernet0/1)
Hello Time 2 sec Max Age 20 sec Forward Delay 15 sec
Bridge ID Priority 32778 (priority 32768 sys-id-ext 10)
Address 001b.5303.1700
Hello Time 2 sec Max Age 20 sec Forward Delay 15 sec
Aging Time 300
Interface Role  Sts  Cost  Prio.Nbr  Type
-----------------------------------------------------------
Fa0/1     Root  FWD   19   128.1     P2p
Fa0/2     Altn  BLK   19   128.2     P2p
Fa0/3     Altn  BLK   19   128.3     P2p
Fa0/4     Altn  BLK   19   128.4     P2p
```


Note that S3 can now use all four ports for VLAN 99 traffic as long as they are not blocked at the other
end of the trunk. However, the original spanning tree topology, with three of four S3 ports in blocking
mode, is still in place for the four other active VLANs. By configuring groups of VLANs to use different
trunks as their primary forwarding path, we retain the redundancy of failover trunks, without having to
leaves trunks totally unused.


### Task 7: Observe the response to the topology change in 802.1D STP


To observe continuity across the LAN during a topology change, first reconfigure PC3, which is
connected to port S2 Fa0/6, with IP address 172.17.99.23 255.255.255.0. Then reassign S2 port fa0/6 to
VLAN 99. This allows you to continuously ping across the LAN from the host.

```
S2(config)# interface fa0/6
S2(config-if)#switchport access vlan 99
```


Verify that the switches can ping the host.

```
S2#ping 172.17.99.23
Type escape sequence to abort.
Sending 5, 100-byte ICMP Echos to 172.17.99.23, timeout is 2 seconds:
!!!!!
Success rate is 100 percent (5/5), round-trip min/avg/max = 1/202/1007 ms
```

```
S1#ping 172.17.99.23
Type escape sequence to abort.
Sending 5, 100-byte ICMP Echos to 172.17.99.23, timeout is 2 seconds:
!!!!!
Success rate is 100 percent (5/5), round-trip min/avg/max = 1/202/1007 ms
```

Put S1 in spanning-tree event debug mode to monitor changes during the topology change.

```
S1#debug spanning-tree events
Spanning Tree event debugging is on
```

Open a command window on PC3 and begin a continuous ping to the S1 management interface with the
command **ping –t 172.17.99.11**. Now disconnect the trunks on S1 Fa0/1 and Fa0/3. Monitor the pings.
They will begin to time out as connectivity across the LAN is interrupted. As soon as connectivity has
been re-established, terminate the pings by pressing Ctrl-C.
Below is a shortened version of the debug output you will see on S1 (several TCNs are omitted for
brevity).

```
S1#debug spanning-tree events
Spanning Tree event debugging is on
S1#
6d08h: STP: VLAN0099 new root port Fa0/2, cost 19
6d08h: STP: VLAN0099 Fa0/2 -> listening
6d08h: %LINEPROTO-5-UPDOWN: Line protocol on Interface FastEthernet0/1,
changed state to down
6d08h: %LINK-3-UPDOWN: Interface FastEthernet0/1, changed state to down
6d08h: STP: VLAN0099 sent Topology Change Notice on Fa0/2
6d08h: STP: VLAN0030 Topology Change rcvd on Fa0/2
6d08h: %LINEPROTO-5-UPDOWN: Line protocol on Interface FastEthernet0/3,
changed state to down
6d08h: %LINK-3-UPDOWN: Interface FastEthernet0/3, changed state to down
6d08h: STP: VLAN0001 Topology Change rcvd on Fa0/4
6d08h: STP: VLAN0099 Fa0/2 -> learning
6d08h: STP: VLAN0099 sent Topology Change Notice on Fa0/2
6d08h: STP: VLAN0099 Fa0/2 -> forwarding
6d08h: STP: VLAN0001 Topology Change rcvd on Fa0/4
```


Recall that when the ports are in listening and learning mode, they are not forwarding frames, and the
LAN is essentially down. The spanning tree recalculation can take up to 50 seconds to complete – a
significant interruption in network services. The output of the continuous pings shows the actual
interruption time. In this case, it was about 30 seconds. While 802.1D STP effectively prevents switching
loops, this long restoration time is considered a serious drawback in the high availability LANs of today.

![Imgur](https://i.imgur.com/n3uBRwL.jpg)

### Task 8: Configure PVST Rapid Spanning Tree Protocol


Cisco has developed several features to address the slow convergence times associated with standard
STP. PortFast, UplinkFast, and BackboneFast are features that, when properly configured, can
dramatically reduce the time required to restore connectivity dramatically. Incorporating these features
requires manual configuration, and care must be taken to do it correctly. The longer term solution is Rapid
STP (RSTP), 802.1w, which incorporates these features among others. RSTP-PVST is configured as
follows:

`S1(config)#spanning-tree mode rapid-pvst`

Configure all three switches in this manner.
Use the command **show spanning-tree summary** to verify that RSTP is enabled.

### Task 9: Observe the convergence time of RSTP


Begin by restoring the trunks you disconnected in Task 7, if you have not already done so (ports Fa0/1
and Fa0/3 on S1). Then follow these steps in Task 7:

- Set up host PC3 to continuously ping across the network.
- Enable spanning-tree event debugging on switch S1.
- Disconnect the cables connected to ports Fa0/1 and Fa0/3.
- Observe the time required to re-establish a stable spanning tree.

Below is the partial debug output:

```
S1#debug spanning-tree events
Spanning Tree event debugging is on
S1#
6d10h: RSTP(99): updt rolesroot port Fa0/3 is going down
6d10h: RSTP(99): Fa0/2 is now root port Connectivity has been restored; less than 1
second interruption
6d10h: RSTP(99): syncing port Fa0/1
6d10h: RSTP(99): syncing port Fa0/4
6d10h: RSTP(99): transmitting a proposal on Fa0/1
6d10h: RSTP(99): transmitting a proposal on Fa0/4
6d10h: %LINEPROTO-5-UPDOWN: Line protocol on Interface FastEthernet0/3,
changed state to down
6d10h: %LINEPROTO-5-UPDOWN: Line protocol on Interface FastEthernet0/1,
changed state to down
```


The restoration time with RSTP enabled was less than a second, and not a single ping was dropped.


### Task 10: Clean Up


Erase the configurations and reload the default configurations for the switches. Disconnect and store the
cabling. For PC hosts that are normally connected to other networks (such as the school LAN or to the
Internet), reconnect the appropriate cabling and restore the TCP/IP settings.
Final Configurations


**Switch S1**

```
hostname S1
!
enable secret class
!
no ip domain-lookup
!
spanning-tree mode rapid-pvst
spanning-tree extend system-id
spanning-tree vlan 1 priority 4096
spanning-tree vlan 10 priority 4096
spanning-tree vlan 20 priority 4096
spanning-tree vlan 30 priority 4096
!
interface FastEthernet0/1
switchport trunk native vlan 99
switchport mode trunk
!
interface FastEthernet0/2
switchport trunk native vlan 99
switchport mode trunk
!
interface FastEthernet0/3
switchport trunk native vlan 99
switchport mode trunk
!
interface FastEthernet0/4
switchport trunk native vlan 99
switchport mode trunk
!
interface FastEthernet0/5
shutdown
!
interface FastEthernet0/6
shutdown
!
interface FastEthernet0/7
shutdown
!
(remaining port configuration ommitted - all non-used ports are shutdown)
!
!
interface Vlan1
no ip address
no ip route-cache
!
interface Vlan99
ip address 172.17.99.11 255.255.255.0
no ip route-cache
!
line con 0
password cisco
login
line vty 0 4
password cisco
login
line vty 5 15
password cisco
login
!
end
```


**Switch S2**

```
hostname S2
!
enable secret class
!
no ip domain-lookup
!
interface FastEthernet0/1
switchport trunk native vlan 99
switchport mode trunk
!
interface FastEthernet0/2
switchport trunk native vlan 99
switchport mode trunk
!
interface FastEthernet0/3
switchport trunk native vlan 99
switchport mode trunk
!
interface FastEthernet0/4
switchport trunk native vlan 99
switchport mode trunk
!
interface FastEthernet0/5
switchport access vlan 30
!
interface FastEthernet0/6
switchport access vlan 30
!
interface FastEthernet0/7
switchport access vlan 30
!
interface FastEthernet0/8
switchport access vlan 30
!
interface FastEthernet0/9
switchport access vlan 30
!
interface FastEthernet0/10
switchport access vlan 30
!
interface FastEthernet0/11
switchport access vlan 10
!
interface FastEthernet0/12
switchport access vlan 10
!
interface FastEthernet0/13
switchport access vlan 10
!
interface FastEthernet0/14
switchport access vlan 10
!
interface FastEthernet0/15
switchport access vlan 10
!
interface FastEthernet0/16
switchport access vlan 10
!
interface FastEthernet0/17
switchport access vlan 10
!
interface FastEthernet0/18
switchport access vlan 20
switchport mode access
!
interface FastEthernet0/19
switchport access vlan 20
!
interface FastEthernet0/20
switchport access vlan 20
!
interface FastEthernet0/21
switchport access vlan 20
!
interface FastEthernet0/22
switchport access vlan 20
!
interface FastEthernet0/23
switchport access vlan 20
!
interface FastEthernet0/24
switchport access vlan 20
!
interface GigabitEthernet0/1
!
interface GigabitEthernet0/2
!
interface Vlan1
no ip address
no ip route-cache
!
interface Vlan99
ip address 172.17.99.12 255.255.255.0
no ip route-cache
!
line con 0
line vty 0 4
password cisco
login
line vty 5 15
password cisco
login
!
end
```


**Switch S3**

```
hostname S3
!
enable secret class
!
no ip domain-lookup
!
spanning-tree mode rapid-pvst
spanning-tree extend system-id
spanning-tree vlan 99 priority 4096
!
interface FastEthernet0/1
switchport trunk native vlan 99
switchport mode trunk
!
interface FastEthernet0/2
switchport trunk native vlan 99
switchport mode trunk
!
interface FastEthernet0/3
switchport trunk native vlan 99
switchport mode trunk
!
interface FastEthernet0/4
switchport trunk native vlan 99
switchport mode trunk
!
interface FastEthernet0/5
shutdown
!
interface FastEthernet0/6
shutdown
!
interface FastEthernet0/7
shutdown
!
(remaining port configuration ommitted - all non-used ports are shutdown)
!
interface Vlan1
no ip address
no ip route-cache
shutdown
!
interface Vlan99
ip address 172.17.99.13 255.255.255.0
no ip route-cache
!
line con 0
password cisco
login
line vty 0 4
password cisco
login
line vty 5 15
password cisco
login
!
end
```