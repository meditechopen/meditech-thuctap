# Kiến trúc Network trong OpenStack (Open vSwitch)

## Mục lục

[1. Provider Network](#provider)

[2. Self-service Network](#self-service)

------------

<a name ="provider"></a>
## 1. Provider Network

Dưới đây là mô hình kiến trúc tổng quan của network trong OpenStack sử dụng provider network:

<img src="http://i.imgur.com/vN2KkKV.png">

**Instance Networking**

Gói tin sẽ bắt đầu từ card `eth0` trên máy ảo, nó được kết nối với `tap` device trên host. `tap` device này ở trên Linux bridge. Sở dĩ có 1 layer Linux Bridge là vì OpenStack sử dụng các rules của iptables trên tap devices để thực hiện security groups. Trước đây khi mà OpenvSwitch chưa hỗ trợ iptables thì nó buộc dùng thêm một layer là Linux Bridge nữa dù lí tưởng nhất vẫn là interface của VM gán trực tiếp vào bridge intergration (br-int) của OVS.

Ở các phiên bản gần đây, OpenvSwitch đã hỗ trợ iptables vì thế nó sẽ không cần thêm một layer của LB nữa. Bạn có thể xem thêm về cách khai báo cho OVS sử dụng iptables [tại đây](https://docs.openstack.org/ocata/networking-guide/config-ovsfwdriver.html)

Mặc dù vậy nhưng OpenStack vẫn để trên [docs](https://docs.openstack.org/newton/networking-guide/deploy-ovs-provider.html) của mình mô hình với layer có LB do nó đã được kiểm chứng là khá stable. Ở đây mình sẽ vẫn đi sâu vào mô hình có layer Linux Bridge.

Nếu bạn xem các rules trên node compute nơi chứa máy ảo thì bạn sẽ thấy được có vài rules liên quan tới `tap` device:

``` sh
[root@compute2 ~]# iptables -S | grep tap5652dd5f-cd
-A neutron-openvswi-FORWARD -m physdev --physdev-out tap5652dd5f-cd --physdev-is-bridged -m comment --comment "Direct traffic from the VM interface to the security group chain." -j neutron-openvswi-sg-chain
-A neutron-openvswi-FORWARD -m physdev --physdev-in tap5652dd5f-cd --physdev-is-bridged -m comment --comment "Direct traffic from the VM interface to the security group chain." -j neutron-openvswi-sg-chain
-A neutron-openvswi-INPUT -m physdev --physdev-in tap5652dd5f-cd --physdev-is-bridged -m comment --comment "Direct incoming traffic from VM to the security group chain." -j neutron-openvswi-o5652dd5f-c
-A neutron-openvswi-sg-chain -m physdev --physdev-out tap5652dd5f-cd --physdev-is-bridged -m comment --comment "Jump to the VM specific chain." -j neutron-openvswi-i5652dd5f-c
-A neutron-openvswi-sg-chain -m physdev --physdev-in tap5652dd5f-cd --physdev-is-bridged -m comment --comment "Jump to the VM specific chain." -j neutron-openvswi-o5652dd5f-c
```

`neutron-openvswi-sg-chain` là nơi chứa neutron-managed security groups. `neutron-openvswi-FORWARD` điều khiển outbound traffic từ VM ra ngoài trong khi đó `neutron-openvswi-i5652dd5f-c` sẽ điều khiển inbound traffic  tới VM.

Ở đây mình đã mở port 22 trong security group nên các rules sẽ như thế này:

``` sh
-A neutron-openvswi-i5652dd5f-c -m state --state RELATED,ESTABLISHED -m comment --comment "Direct packets associated with a known session to the RETURN chain." -j RETURN
-A neutron-openvswi-i5652dd5f-c -s 10.10.10.2/32 -p udp -m udp --sport 67 -m udp --dport 68 -j RETURN
-A neutron-openvswi-i5652dd5f-c -m set --match-set NIPv4db2f6d52-5e02-4ab4-949d- src -j RETURN
-A neutron-openvswi-i5652dd5f-c -p tcp -m tcp -m multiport --dports 1:65535 -j RETURN
-A neutron-openvswi-i5652dd5f-c -p icmp -j RETURN
-A neutron-openvswi-i5652dd5f-c -p tcp -m tcp --dport 22 -j RETURN
```

Interface thứ 2 gán vào Linux Bridge có tên `qvb...`, interface này sẽ nối LB tới integration bridge (br-int).

**Integration Bridge**

Bridge này thường có tên là `br-int` thường được dùng để "tag" và "untag" VLAN cho traffic vào và ra VM. Lúc này br-int sẽ trông như sau:

``` sh
#ovs-vsctl show
...........
Bridge br-int
            Interface int-br-provider
                type: patch
                options: {peer=phy-br-provider}
        Port br-int
            Interface br-int
                type: internal
        Port "qvo5652dd5f-cd"
            tag: 1
            Interface "qvo5652dd5f-cd"
```

Interface `qvo...` là điểm đến của `qvb...` và nó sẽ chịu trách nhiệm với các traffic vào và ra khỏi layer LB. Nếu bạn sử dụng VLAN, sẽ có thêm `tag:1`. Interface `int-br-provider` kết nối tới `phy-br-provider` trên layer bridge external.

**External bridge**

Bridge này sẽ được gán với interface external để đi ra ngoài internet (có thể dùng bond hoặc không). Nó sẽ trông như sau:

``` sh
#ovs-vsctl show
.........
Bridge br-provider
        Controller "tcp:127.0.0.1:6633"
            is_connected: true
        fail_mode: secure
        Port phy-br-provider
            Interface phy-br-provider
                type: patch
                options: {peer=int-br-provider}
        Port br-provider
            Interface br-provider
                type: internal
        Port "bond0"
            Interface "bond0"
```

<a name ="self-service"></a>
## 2. Self-service Network

Mô hình self-service Network sẽ phức tạp hơn khi mà traffic còn phải đi qua một router được đặt trên node controller. Dưới đây là mô hình:

<img src="http://i.imgur.com/QMgxaqd.png">
