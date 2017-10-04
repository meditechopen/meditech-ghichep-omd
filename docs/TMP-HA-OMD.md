## HA cho OMD

<img src="/images/HA-OMD-check_mk.png" width=70% />

### Part.1  Chuẩn bị server

- Đồng nhất về thời gian:
	
	```
	timedatectl set-timezone Asia/Ho_Chi_Minh
	yum install ntp -y
	ntpdate pool.ntp.org
	```
	
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
	- Đồng nhất thời gian giữa 2 server
	- Set hostname cho từng node
	- Ghi thông tin vào file host từng node
	- Cấu hình LVM
	- Cài đặt DRBD
	- Cài đặt Pacemaker và Corosync
	- Cài đặt OMD
		- File cấu hình APACHE của OMD là:  `/etc/apache/conf.d/zzz_omd.conf`
	- Tạo một site trên OMD
		
		```
		omd create site1
		```
		
		- Khi tạo site, OMD sẽ tạo thêm 1 user để quản lý site đó. 
			
			```
			root@omd1:~# id site1
			uid=114(site1) gid=512(site1) Gruppen=512(site1),103(omd)
			```
		- Chúng ta phải sang Server còn lại, tạo site tương tự với UID và GID với 2 parameter `-u`, `-g`.
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
	
### Part.2 Cấu hình Pacemaker/Corosync

- Cấu hình Pacemaker/Corosync để tạo 2 node thành 1 cluster.
- Tham khảo bước `2.2` và `2.3` ở [bài này](https://github.com/hoangdh/ghichep-HA/blob/master/Pacemaker_Corosync/2.Huong-dan-Pacemaker-Corosync-cho-Web-DRBD-CentOS.md#22-cài-đặt-pacemaker-và-corosync-)

### Part.3 Thêm Recource vào Pacemaker

- Thêm VIP
- Thêm Apache
- Thêm DRBD
- Thêm filesystem từ thiết bị DRBD (Mount tại /opt/omddata)

### Part.4 Cấu hình OMD tạo thành Recource trong Pacemaker

*Thực hiện trên cả 2 node*

- Không cho phép OMD khởi động cùng hệ thống 

```
chkconfig omd off
HOẶC
echo "AUTOSTART=0" > /etc/default/omd
```
- Đầu tiên, dừng hoạt động `site1`

```
omd stop site1
umount tmpfs
```

- Chuyển dữ liệu sang thiết bị DRBD (Làm trên node mà DRBD đang hoạt động)

```
cd /opt/omd/
mv apache/ /opt/omddata/
mv sites/ /opt/omddata/
ln -s /opt/omddata/apache/ apache
ln -s /opt/omddata/sites/ sites
```

- Tạo symlink `versions` trong thư mục `/opt/omddata/`

```
cd /opt/omddata
mdkir /opt/omddata/versions
ln -s /opt/omd/versions/1.2.8p21.cre /opt/omddata/versions/1.2.8p21.cre
```

- Xóa dữ liệu trên node secondary DRBD (Node còn lại)

```
cd /opt/omd
rm -rf apache
rm -rf sites
ln -s /opt/omddata/apache/ /opt/omd/apache 
ln -s /opt/omddata/sites/ /opt/omd/sites
```

*Làm trên cả 2 node*

- Copy OCF Agent vào thư viện

Link download [OMD](http://blog.simon-meggle.de/assets/omd-cluster-pacemaker-4/OMD.txt#)

- Tạo thư mục chứa agent

```
mkdir /usr/lib/ocf/resource.d/simon-meggle
wget http://blog.simon-meggle.de/assets/omd-cluster-pacemaker-4/OMD.txt -O OMD
chmod +x OMD
```

- Tạo resource OMD trên Pacemaker

```
pcs resource create omd-site1 ocf:simon-meggle:OMD site=site1 op monitor interval="10s" timeout="20s"  op start interval="0s" timeout="90s" op stop interval="0s" timeout="100s"
```

- Cấu hình RRDCached

Sửa file `vi /opt/omd/sites/site1/etc/rrdcached.conf`

```
# Data is written to disk every TIMEOUT seconds. If this option is
# not specified the default interval of 300 seconds will be used.
#TIMEOUT=3600
TIMEOUT=180

# rrdcached will delay writing of each RRD for a random
# number of seconds in the range [0,delay). This will avoid too many
# writes being queued simultaneously. This value should be no
# greater than the value specified in TIMEOUT.
#RANDOM_DELAY=1800
RANDOM_DELAY=90

# Every FLUSH_TIMEOUT seconds the entire cache is searched for old
values
# which are written to disk. This only concerns files to which
# updates have stopped, so setting this to a high value, such as
# 3600 seconds, is acceptable in most cases.
#FLUSH_TIMEOUT=7200
FLUSH_TIMEOUT=360
```

- Khởi động lại dịch vụ

```
omd reload site1 rrdcached 
```
	
### Part.5 Tạo sự ràng buộc

- Khi DrbdFS khởi động xong thì omd-site1 khởi động

```
pcs constraint colocation add DrbdFS with omd-site1
pcs constraint order DrbdFS then omd-site1
```

### Part.6 Tạo một site mới khi đã cấu hình HA

- **Bước 1:** Tạo một site mới trên node đang hoạt động (Ví dụ: `omd1`)

```
[root@omd1 ~]# omd create site2
```

- **Bước 2:** Xem thông tin user `site2`

```
[root@omd1 ~]# cat /etc/fstab | grep site2 && cat /etc/passwd | grep site2
tmpfs  /opt/omd/sites/site2/tmp tmpfs noauto,user,mode=755,uid=site2,gid=site2 0 0
site2:x:992:1002:OMD site site2:/omd/sites/site2:/bin/bash
```

- **Bước 3:** Sang server `omd2`, ghi thông tin `site2` vào `/etc/fstab`

```
[root@omd2 ~]# echo "tmpfs  /opt/omd/sites/site2/tmp tmpfs noauto,user,mode=755,uid=site2,gid=site2 0 0" >> /etc/fstab
```

- **Bước 3:** Tạo thông tin cho user `site2` (Trên `omd2`)

```
[root@omd2 ~]# groupadd -g 1002 site2
[root@omd2 ~]# usermod -aG site2 apache
[root@omd2 ~]# useradd -u 992 site2 -d '/omd/sites/site2' -g site2 -G omd -s '/bin/bash'
```

- **Bước 4:** Tạo resource cho `site2` và cấu hình ràng buộc (Cấu hình trên server bất kỳ)

```
[root@omd2 ~]# pcs resource create omd-site2 ocf:simon-meggle:OMD site=site2 op monitor interval="10s" timeout="20s"  op start interval="0s" timeout="90s" op stop interval="0s" timeout="100s"

[root@omd2 ~]# pcs constraint colocation add DrbdFS with omd-site2
[root@omd2 ~]# pcs constraint order DrbdFS then omd-site2

[root@omd2 ~]# pcs resource cleanup --all
```

- **Bước 5:** Cấu hình RRDCached của OMD

Sửa file `vi /opt/omd/sites/site1/etc/rrdcached.conf`

```
# Data is written to disk every TIMEOUT seconds. If this option is
# not specified the default interval of 300 seconds will be used.
#TIMEOUT=3600
TIMEOUT=180

# rrdcached will delay writing of each RRD for a random
# number of seconds in the range [0,delay). This will avoid too many
# writes being queued simultaneously. This value should be no
# greater than the value specified in TIMEOUT.
#RANDOM_DELAY=1800
RANDOM_DELAY=90

# Every FLUSH_TIMEOUT seconds the entire cache is searched for old
values
# which are written to disk. This only concerns files to which
# updates have stopped, so setting this to a high value, such as
# 3600 seconds, is acceptable in most cases.
#FLUSH_TIMEOUT=7200
FLUSH_TIMEOUT=360
```

- Khởi động lại dịch vụ

```
omd reload site2 rrdcached 
```