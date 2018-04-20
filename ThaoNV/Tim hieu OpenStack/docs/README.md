# Thư mục chứa các file notes trong quá trình tìm hiểu OpenStack của ThaoNV

## Mục Lục

### Tìm hiểu chung

[1. Tìm hiểu chung về OpenStack](./general/tim-hieu-chung-OpenStack.md)

[2. Tìm hiểu cấu trúc và thành phần của OpenStack](./general/cau-truc-va-thanh-phan-openstack.md)

[3. Hướng dẫn sử dụng dashboard](./general/hdsd-dashboard.md)

### Tài liệu hướng dẫn setup OPS

[1. Hướng dẫn cài đặt manual với LB bản OPS Newton](./setup/Newton/hd-caidat-openstack-newton-centos7.md)

[2. Hướng dẫn cài đặt manual với OVS và bonding bản OPS Newton](./setup/Newton/hd-caidat-openstack-newton-OVS-bonding.md)

[3. Hướng dẫn cài đặt bằng packstack bản OPS Newton](./setup/Newton/packstack-newton.md)

[4. Hướng dẫn cài đặt bằng packstack bản OPS Pike](./setup/Pike/packstack-pike.md)

[5. Hướng dẫn dựng mô hình ops ha với haproxy, pacemaker và corosync](./setup/Pike/ops-ha.md)

### Tài liệu nâng cao

[1. Hướng dẫn reset root password của máy ảo CentOS 7 trên OpenStack](./advance/Huong-dan-reset-root-password-may-ao-centos-tren-openstack.md)

[2. Tìm hiểu về migrate máy ảo trong OpenStack](./advance/migration.md)

[3. Hướng dẫn rebuild lại máy ảo trong trường hợp Compute bị chết](./advance/evacute.md)

[4. Hướng dẫn backup và restore lại controller](./advance/backup-and-restore-controller.md)

[5. Hướng dẫn đóng image trong OPS](./image-create/)

### Project Nova

[1. Tìm hiểu Compute Service - Nova](./nova/nova-overview.md)

[2. Các lệnh cơ bản thường dùng trong Nova](./nova/cli-nova.md)

[3. Tìm hiểu các main options trong file config của Nova](./nova/file-config-nova.md)

[4. Các thao tác quản trị cơ bản với Nova](./nova/manage-nova.md)

[5. Tìm hiểu cơ chế filtering và weighting của nova-scheduler](./nova/nova-scheduler.md)

[6. Quá trình khởi tạo máy ảo trong Nova](./nova/request-flow-for-provisioning-instance.md)

[7. Hướng dẫn resize máy ảo được boot từ volume](./nova/resize.md)

### Project Neutron

[1. OpenStack Networking cơ bản](./neutron/OpenStack-Networking-basic.md)

[2. Tìm hiểu Open vSwitch](./neutron/openvswitch.md)

[3. Kiến trúc Network trong OpenStack (Open vSwitch) và đường đi của gói tin trong OPS](./neutron/neutron-openvswitch.md)

[4. Tìm hiểu Network Bonding](./neutron/bonding.md)

[5. Lab cơ bản với neutron](./neutron/manage-neutron.md)

[6. Ghi chép file cấu hình Neutron](./neutron/file-config.md)

[7. Các lệnh cơ bản thường dùng trong Neutron](./neutron/cli-neutron.md)

[8. QoS network trong OPS](./neutron/qos.md)


### Project Keystone

[1. Tìm hiểu tổng quan về keystone](./keystone/Fundamental-keystone.md)

[2.Tìm hiểu về các loại Token trong keystone](./keystone/token-format.md)

[3. Tìm hiểu file config của Keystone](./keystone/configuration-file.md)

[4. Sử dụng keystone](./keystone/using-keystone.md)

[5. Các câu lệnh thường dùng trong Keystone](./keystone/cli-keystone.md)

[6. Tìm hiểu file policy.json và cách define role trong keystone](./keystone/file-policy.json.md)


### Project Glance

[1. Tìm hiểu tổng quan Image Service - Glance](./glance/glance-overview.md)

[2. Tìm hiểu các thao tác sử dụng Glance](./glance/manage-glance.md)

[3. Các lệnh cơ bản thường dùng trong Glance](./glance/cli-glance.md)

[4. Tìm hiểu file cấu hình của glance](./glance/file-config-glance.md)

### Project Cinder

[1. Tổng quan về project Cinder](./cinder/tongquan-cinder.md)

[2. Workflow của Cinder](./cinder/cinder-workflow.md)

[3. Các lệnh cơ bản với cinder](./cinder/cli-cinder.md)

[4. Cài đặt và cấu hình dịch vụ Cinder](./cinder/OPS-cinder.md)

[5. Cơ chế filter và weight của cinder-scheduler](./cinder/cinder-scheduler.md)

[6. Hướng dẫn cấu hình multiple Cinder và thực hiện tính năng migrate volume](./cinder/cinder.md)

[7. Giải thích file cấu hình Cinder](./cinder/cinder-config-explain.md)

[8. Hướng dẫn cấu hình cinder backup với backend là NFS](./cinder/cinder-backup.md)

[9. Hướng dẫn cấu hình sử dụng driver filter và weighing cho cinder scheduler](./cinder/config-cinder-scheduler.md)

### Project Telemetry

[1. Tổng quan về telemetry project trong OpenStack](./telemetry/docs/overview.md)

[2. Một số cấu hình cho Ceilometer](./telemetry/docs/configuration.md)

[3. Hướng dẫn cấu hình ceilometer kết hợp gnocchi](./telemetry/docs/gnocchi.md)

[4. Hướng dẫn sử dụng grafana để hiển thị các metrics của Ceilometer](./telemetry/docs/grafana.md)

[5. Tìm hiểu aodh](./telemetry/docs/aodh.md)

[6. Hướng dẫn bắn cảnh báo của aodh ra slack](./telemetry/docs/aodh-alarm.md)

### Cloud-init

[1. Tìm hiểu về cloud-init](./cloud-init/cloud-init-intro.md)

[2. Một số ví dụ với cloud-config](./cloud-init/examples.md)

[3. Một số module phổ biến thường được dùng trong cloud-init](./cloud-init/module.md)

[4. OpenStack nova get-password, set-password and post encrypted password to metadata service](./cloud-init/nova-get-and-set-password.md)

### Metadata

[1. Tìm hiểu về metadata service](./metadata/metadata.md)
