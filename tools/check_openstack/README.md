# Giải thích cách hoạt động, check của plugin

## I. Các dịch vụ

### 1. Cinder

- Đầu tiên, check dịch vụ `openstack-cinder-api`
	- Nếu DOWN, cảnh báo Cirtical
	- Nếu chạy, check tiếp các dịch vụ bằng câu lệnh `openstack volume service list`
		- Kiểm tra lần lượt các dịch vụ DOWN (trên từng node)
			- cinder-backup 
			- cinder-volume 
			- cinder-scheduler
			
### 2. Glance

- Check lần lượt 2 dịch vụ `openstack-glance-api` và `openstack-glance-registry`
	- Nếu 1 trong 2 dịch vụ DOWN -> Cảnh báo Warning
	- Cả 2 dịch vụ DOWN -> Cảnh báo Cirtical
	 
	
### 3. Keystone

- Đầu tiên, check dịch vụ `httpd`
	- Nếu DOWN, cảnh báo Cirtical
	- Nếu chạy, check tiếp 2 port 5000 và 35357
		- Nếu chạy, Lấy token
			- Nếu chạy -> OK
			- Nếu không chạy, Báo lỗi File biến Môi trường
		- Không chạy -> Warning

### 4. Neutron

- Đầu tiên, check dịch vụ `neutron-server`
	- Nếu DOWN, cảnh báo Cirtical
		- Nếu chạy, check tiếp các dịch vụ bằng câu lệnh `openstack network agent list`
		- Kiểm tra lần lượt các dịch vụ DOWN (trên từng node)
			- neutron-dhcp-agent
			- neutron-l3-agent
			- neutron-metadata-agent
			- neutron-metering-agent
			- neutron-openvswitch-agent
### 5. Nova

- Đầu tiên, check dịch vụ `openstack-nova-api`
	- Nếu DOWN, cảnh báo Cirtical
		- Nếu chạy, check tiếp các dịch vụ bằng câu lệnh `openstack compute service list`
		- Kiểm tra lần lượt các dịch vụ DOWN (trên từng node)
			- nova-cert 
			- nova-compute 
			- nova-conductor 
			- nova-consoleauth 
			- nova-scheduler
			
## II. Tài nguyên

### 1. Liệt kê tổng số Image

- Sử dụng lệnh `openstack image list`
- Đếm số Image

### 2. Liệt kê số Network

- Sử dụng lệnh `openstack ip availability list`
- Đếm số dải mạng
- Thống kê IP đã sử dụng theo từng dải mạng

### 3. Đếm số VMs đang hoạt động

- Sử dụng lệnh `openstack server list --all-projects`
- Đếm số VM
	- Tổng số VM
	- Số VM đang hoạt động
	- Số VM không hoạt động (Shutoff, error,...)
	
### 4. Đếm số Volume

- Sử dụng lệnh `openstack volume list --all`
- Đếm số Volume:
	- Tổng số
	- Đang được sử dụng
	- Chưa được sử dụng