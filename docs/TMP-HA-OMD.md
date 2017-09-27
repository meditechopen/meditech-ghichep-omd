## HA cho OMD

### Part.1  Chuẩn bị server

- Các thành phần, yếu tố cần thiết:
	- OMD
	- DRBD
	- LVM
	- Pacemaker/Corosync
- Mục đích của việc cài đặt
	- HA theo mô hình Active-Passive
	- Khi node Active bị lỗi:
		- Thiết bị DRBD sẽ được kích hoạt trên node còn lại
		- Dữ liệu OMD lưu trên thiết bị và được mount lên 
		- Sử dụng một Virtual IP
		- Site của OMD
- Các bước cài đặt:
	- Set hostname cho từng node
	- Ghi thông tin vào file host từng node
	- Cấu hình LVM
	- Cài đặt DRBD
	- Cài đặt Pacemaker và Corosync
	- Cài đặt OMD
		- File cấu hình APACHE của OMD là:  /etc/apache/conf.d/zzz_omd.confg
	- Tạo một site trên OMD
		
		```
		omd create site1
		```
		
		- Khi tạo site, OMD sẽ tạo thêm 1 user để quản lý site đó. Chúng ta phải sang Server còn lại, tạo site tương tự.
			
			```
			root@omd1:~# id site1
			uid=114(site1) gid=512(site1) Gruppen=512(site1),103(omd)
			```
			
			```
			root@omd2:~# id site1
			omd create site1 -u 114 -g 512
			```
		- Khởi động site:
		
		```
		omd start site1
		```
		
		- Dừng hoạt động site:
		
		```
		omd stop site1
		```
	
### Part.2 Cấu hình
	