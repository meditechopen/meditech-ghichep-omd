# Hướng dẫn cấu hình thêm các thông số về DB trong Mysql.

## Trên agent (máy chủ cần giám sát Mysql)

#### 1. Cài đặt các gói cần thiết: 

```sh
yum install gcc glibc glibc-common gd gd-devel make net-snmp openssl-devel xinetd unzip httpd php php-fpm curl wget -y
```
	
#### 2. Tại máy chủ mysql, tạo user DB và cho phép remote DB :

```sh
GRANT SELECT, SHOW DATABASES ON *.* TO 'mysqlmonitor'@'ip-check_mk' IDENTIFIED BY 'mysqlmonitor';
```
	
#### 3. Tải plugin về :

```sh
wget https://labs.consol.de/assets/downloads/nagios/check_mysql_health-2.2.2.tar.gz
```
	
#### 4. Giải nén :

```sh
tar -xzvf check_mysql_health-2.2.2.tar.gz
```
	
#### 5. Biên dịch và cài đặt :

```sh
cd check_mysql_health-2.2.2/
./configure --prefix=/usr/lib/check_mk_agent/plugins --with-nagios-user=root --with-nagios-group=root
make && make install
```
	
#### 6. Tạo file mrpe.conf và cấu hình :

- Tạo file mrpe.conf :

	```sh
	vi /etc/check_mk/mrpe.cfg
	```
	
- Thêm vào những cấu hình như sau :

	```sh
	# check connectiontime
	mysqlhealth_connection-time /usr/lib/check_mk_agent/plugins/libexec/check_mysql_health --hostname <IP-MYSQL-SERVER> --username mysqlmonitor --password mysqlmonitor --mode connectiontime

	# check up time
	mysqlhealth_uptime /usr/lib/check_mk_agent/plugins/libexec/check_mysql_health --hostname <IP-MYSQL-SERVER> --username mysqlmonitor --password mysqlmonitor --mode uptime

	# check threadsconnected
	mysqlhealth_threads-connected /usr/lib/check_mk_agent/plugins/libexec/check_mysql_health
	--hostname <IP-MYSQL-SERVER> --username mysqlmonitor --password mysqlmonitor --mode threadsconnected

	# check threadcache-hitrate
	mysqlhealth_threadcache-hitrate /usr/lib/check_mk_agent/plugins/libexec/check_mysql_health --hostname <IP-MYSQL-SERVER> --username mysqlmonitor --password mysqlmonitor --mode threadcache-hitrate

	# check qcachehitrate
	mysqlhealth_qcache-hitrate /usr/lib/check_mk_agent/plugins/libexec/check_mysql_health --hostname <IP-MYSQL-SERVER> --username mysqlmonitor --password mysqlmonitor --mode qcachehitrate

	# check qcache-lowmem-prunes
	mysqlhealth_qcache-lowmem-prunes /usr/lib/check_mk_agent/plugins/libexec/check_mysql_health --hostname <IP-MYSQL-SERVER> --username mysqlmonitor --password mysqlmonitor --mode qcache-lowmem-prunes

	# check keycachehitrate
	mysqlhealth_keycache-hitrate /usr/lib/check_mk_agent/plugins/libexec/check_mysql_health --hostname <IP-MYSQL-SERVER> --username mysqlmonitor --password mysqlmonitor --mode keycachehitrate

	# check bufferpool-hitrate
	mysqlhealth_bufferpool-hitrate /usr/lib/check_mk_agent/plugins/libexec/check_mysql_health --hostname <IP-MYSQL-SERVER> --username mysqlmonitor --password mysqlmonitor --mode bufferpool-hitrate

	# check bufferpool-wait-free
	mysqlhealth_bufferpool-wait-free /usr/lib/check_mk_agent/plugins/libexec/check_mysql_health --hostname <IP-MYSQL-SERVER> --username mysqlmonitor --password mysqlmonitor --mode bufferpool-wait-free

	# check log-waits
	mysqlhealth_log-waits /usr/lib/check_mk_agent/plugins/libexec/check_mysql_health --hostname <IP-MYSQL-SERVER> --username mysqlmonitor --password mysqlmonitor --mode log-waits

	# check tablecache-hitrate
	mysqlhealth_tablecache-hitrate /usr/lib/check_mk_agent/plugins/libexec/check_mysql_health
	--hostname <IP-MYSQL-SERVER> --username mysqlmonitor --password mysqlmonitor --mode tablecache-hitrate

	# check table-lock-contention
	mysqlhealth_table-lock-contention /usr/lib/check_mk_agent/plugins/libexec/check_mysql_health --hostname <IP-MYSQL-SERVER> --username mysqlmonitor --password mysqlmonitor --mode table-lock-contention

	#check index-usage
	mysqlhealth_index-usage /usr/lib/check_mk_agent/plugins/libexec/check_mysql_health --
	hostname <IP-MYSQL-SERVER> --username mysqlmonitor --password mysqlmonitor --mode index-usage

	# check slow-queries
	mysqlhealth_slow-queries /usr/lib/check_mk_agent/plugins/libexec/check_mysql_health --
	hostname <IP-MYSQL-SERVER> --username mysqlmonitor --password mysqlmonitor --mode slow-queries

	# check long-running-procs
	mysqlhealth_long-running-procs /usr/lib/check_mk_agent/plugins/libexec/check_mysql_health
	--hostname <IP-MYSQL-SERVER> --username mysqlmonitor --password mysqlmonitor --mode longrunning-procs

	# check open-files
	mysqlhealth_open-files /usr/lib/check_mk_agent/plugins/libexec/check_mysql_health --
	hostname <IP-MYSQL-SERVER> --username mysqlmonitor --password mysqlmonitor --mode open-files
	```
	
Lưu ý : Thay lại <IP-MYSQL-SERVER>

## Trên OMD server :

- Discovery lại và kiểm tra thông số.
