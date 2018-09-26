# Hướng dẫn sử dụng plugin để check CEPH

- B1. Cài đặt agent lên host cần giám sát.

Tham khảo cách cài đặt check_mk agent [tại đây](https://github.com/thaonguyenvan/meditech-ghichep-omd/blob/master/docs/2.Install-agent.md)

- B2. Clone plugin về

`wget https://raw.githubusercontent.com/HeinleinSupport/check_mk/master/ceph/agents/plugins/ceph`

Đặt tại thư mục `/usr/lib/check_mk_agent/plugins/`

Phân quyền

`chmod +x /usr/lib/check_mk_agent/plugins/ceph`

Chạy thử file plugins

```
cd /usr/lib/check_mk_agent/plugins/
.\ceph
```

<img src="https://i.imgur.com/0lYJHci.png">

- B3. Clone repo chứa plugin về trên node check_mk server

`git clone https://github.com/HeinleinSupport/check_mk.git`

Chuyển 2 file mkp cần cài đặt qua thư mục `/omd/sites/manager/` (Ở đây site của mình là `manager`)

```
cd check_mk
mv ceph/ceph-5.14.mkp json/json-1.0.mkp /omd/sites/manager/
```

Phân quyền

`chmod +x /omd/sites/manager/json-1.0.mkp /omd/sites/manager/ceph-5.14.mkp`

- B4. Cài đặt packages

```
su manager
check_mk -P install json-1.0.mkp
check_mk -P install ceph-5.14.mkp
```

Kiểm tra

```
OMD[manager]:~$ check_mk -P list ceph
/omd/sites/manager/local/share/check_mk/checks/ceph
/omd/sites/manager/local/share/check_mk/checks/cephpools
/omd/sites/manager/local/share/check_mk/checks/cephdf
/omd/sites/manager/local/share/check_mk/checks/cephosd
/omd/sites/manager/local/share/check_mk/checks/cephstatus
/omd/sites/manager/local/share/check_mk/agents/bakery/ceph
/omd/sites/manager/local/share/check_mk/agents/plugins/ceph
/omd/sites/manager/local/share/check_mk/web/plugins/wato/agent_bakery_ceph.py
/omd/sites/manager/local/share/check_mk/web/plugins/metrics/ceph.py
/omd/sites/manager/local/share/check_mk/pnp-templates/check_mk-cephdf.php
/omd/sites/manager/local/share/check_mk/pnp-templates/check_mk-cephosd.php
/omd/sites/manager/local/share/check_mk/pnp-templates/check_mk-cephpools.php
/omd/sites/manager/local/share/check_mk/pnp-templates/check_mk-cephstatus.php
```

- B5: Discover services trên WATO.

<img src="https://i.imgur.com/t6gELR9.png">
