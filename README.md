## Các ghi chép về OMD - Check MK

### Cấu trúc thư mục:

- `docs`: Nơi lưu trữ những bài viết về cài đặt, vận hành OMD
- `images`: Nơi lưu trữ các hình ảnh phục vụ cho các bài viết
- `tools`: Nơi lưu trữ source code của OMD được tải từ trang chủ
- `script`: Lưu trữ các script tự động cài đặt OMD và một số plugin nhóm tự viết

### Nội dung tài liệu.

# Phần 1: Các ghi chép về OMD.

- [1. Hướng dẫn cài đặt](#1) <a name="1"></a>
	- [1.1. CentOS 7](docs/1.1.Setup-OMD-CentOS7.md)
	- [1.2. Ubuntu 16.04](docs/1.2.Setup-OMD-U16.04.md)
	- [1.3. Ubuntu 14.04](docs/1.3.Setup-OMD-U14.04.md)
- [2. Cài đặt Agent trên host cần giám sát](docs/2.Install-agent.md)
- [3. Cấu hình Active Check dịch vụ](docs/3.Active-check.md)
- [4. Đặt ngưỡng cảnh báo cho dịch vụ](docs/4.Set-threshold.md)
- [5. Cấu hình cảnh báo]()
	- [5.1 Cấu hình gửi mail cảnh báo sử dụng Gmail](docs/5.1.Send-Noitify.md)
	- [5.2 Cấu hình gửi cảnh báo mail sử dụng ssmtp](docs/5.2.Send-mail-via-ssmtp.md)
	- [5.3. Cấu hình gửi cảnh báo qua Slack](/docs/5.3-Send-Noitify_Slack.md)
	- [5.4. Sửa nội dung mail cảnh báo](/docs/5.4.Edit-Mail-Notify.md)
	- [5.5. Cấu hình cảnh báo qua Telegram](/docs/5.5.Send-notify-via-telegram.md)
- [6. Thêm plugin vào OMD](docs/6.Add-plugins.md)
- [7. Distributed Monitoring](docs/7.Distributed.md)
- [8. Cấu hình giám sát một số dịch vụ]()
	- [8.1. Cấu hình giám sát RabbitMQ](/docs/8.1.Monitor-RabbitMQ.md)
	- [8.2. Cấu hình giám sát với Mysql](/docs/8.2.Monitor-MySQL.md)
	- [8.3. Cấu hình giám sát apache](/docs/8.3.Monitor-apache.md)
	- [8.4. Cấu hình giám sát Filesystem](/docs/8.4.Monitor-Filesystem.md)
	- [8.5. Cấu hình giám sát số lượng process của dịch vụ](/docs/8.5.Monitor-numbers.md)
	- [8.6. Cấu hình giám sát Oracle Database](/docs/8.6.Monitor-OracleDB.md)
	- [8.7. Cấu hình giám sát máy chủ Linux thông qua SNMP](/docs/8.7.Monitor-host-linux-via-SNMP.md)
	- [8.8. Giám sát thông số nhiệt độ](/docs/8.8.Monitor-temperature.md)
- [9. Hướng dẫn sử dụng Nagvis](/docs/9.Huong-dan-add-va-su-dung-Shape.md)
- [10. Backup OMD]()
	- [10.1. Manage backup site on web](/docs/10.1.Manage-Backup-site-on-web.md)
	- [10.2. Backup site sử dụng CMD](/docs/10.2.Backup-site-use-CMD.md)
- [11. ]()
- [12. HA-cluster](/docs/12.HA-Cluster-OMD.md)
- [13. Đẩy dữ liệu ra Mysql](/docs/13.Pull-data-to-Mysql.md)
- [14. Nâng cấp phiên bản check_mk](14.Update-version.md)

# Phần 2 : Các ghi chép liên quan.

- [1. Plugin check_icmp và check_http](/prepare/1.Check_icmp+check_http.md)
- [2. Hướng dẫn sử dụng Nagvis](/prepare/2.Huong-dan-add-va-su-dung-Shape.md)
- [3. Hướng dẫn bật Inventory để kiểm tra thông số phần mềm và phần cứng](/prepare/3.Inventory.md)
- [4. Đẩy dữ liệu ra Mysql](/prepare/4.pull-data-to-mysql.md)
- [5. Thư mục và cách tổ chức dữ liệu trong OMD](/prepare/5.Thu-muc-va-cach-to-chuc-du-lieu-trong-OMD.md)
- [6. Một số thủ thuật với OMD](/prepare/6.Mot-so-thu-thuat-voi-OMD.md)


	
(C) MediTech JSC,. - https://meditech.vn
