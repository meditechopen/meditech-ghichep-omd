## Hướng dẫn cài đặt OMD - Check_MK trên Ubuntu 14.04

#### Menu

- [1. Giới thiệu](#1)
- [2. Cài đặt trên Server](#2)
- [3. Cài đặt Agent trên Host giám sát](#3)
- [4. Thêm dịch vụ giám sát Active Checks](#4)

### 1. Giới thiệu  <a name="1"></a>



### 2. Cài đặt trên Server  <a name="2"></a>

- **Bước 1**: Cài đặt Repo cho OMD
    - Thêm key GPG của OMD
    
    ```
    wget -q "https://labs.consol.de/repo/stable/RPM-GPG-KEY" -O - | sudo apt-key add -
    ```
    
    - Khai báo repo của OMD 
    
    ```
    echo "deb http://labs.consol.de/repo/stable/ubuntu $(lsb_release -cs) main" > /etc/apt/sources.list.d/labs-consol-stable.list
    apt-get update
    ```
    
- **Bước 2:** Cài đặt OMD

    - Tìm kiếm phiên bản OMD hiện hành
    
    <img src="images/omd-1-search.png" />

    - Cài đặt bản `omd-1.30` bao gồm cả `Nagios`

    ```
    apt-get install omd-1.30
    ```
    
    - Trong quá trình cài đặt, phải khai báo mật khẩu cho MySQL
    
    <img src="images/2.mysql.png" />

Sau khi khai báo xong, chúng ta chờ cho OMD cài đặt đến khi hoàn tất và thực hiện bước tiếp theo để tạo mới một `site` để monitoring.

- **Bước 3:** Tạo mới một `site`

Trước khi sử dụng, chúng ta phải khai báo một `site`:

```
omd create monitoring
```

<img src="images/3.info-site.png" />

Như vậy một site có tên là `monitoring` đã được tạo ra và phần thông tin được tô đỏ trong hình. Mặc định, username được cấp là `omdadmin` và password là `omd`.

**Chú ý:** Có thể tạo nhiều `site` và tên được chọn tùy ý.

- **Bước 4:** Kích hoạt `site` vừa tạo

Sau khi tạo xong `site`, chúng ta kích hoạt site đó và đăng nhập thử trên Web UI.

#### Kích hoạt `site`
    
```
omd start monitoring
```

<img src="images/4.active-site.png" />

#### Truy cập vào Web UI và đăng nhập bằng `omdadmin/omd`
   
```
http://địa-chỉ-ip/monitoring
```

<img src="images/5.webui1.png" />
   
#### Chọn giao diện `Check_MK`
   
   <img src="images/6.webui2-checkmk.png" />

Sau khi chọn xong, chúng ta sẽ thấy một giao diện khá hoàn hảo với đầy đủ những chức năng cần thiết.

<img src="images/7.webui-main.png" />

#### Thay đổi password cho `omdadmin`

Mặc định, user và password được cấp cho `site` mới là `omdadmin/omd`. Để đảm bảo tính an toàn, chúng ta thay đổi bằng cách:

Vào Menu, trong `WATO - Configuration`, chọn `User` (1), chọn tiếp chỉnh sửa (2)

<img src="images/8.paas1.png" />

Kéo xuống phần `Security` và thay đổi thông tin

<img src="images/8.paas2.png" />

Sau đó bấm `SAVE` để lưu lại thông tin.

### 3. Cài đặt Agent trên Host giám sát  <a name="3"></a> 

Đầu tiên, chúng ta vào Web UI để tải `Agent` cho client. Ở giao diện Web, chúng ta kéo xuống phần `WATO - Configuration`, chọn tiếp `Monitoring Agent`

<img src="images/9.agent1.png" />

Ở đây, có 3 packet dành cho 3 DISTRO:

- *.deb: Dành cho các host sử dụng DEBIAN
- *.rpm: Dành cho các host sử dụng RHEL
- *.msi: Dành cho các host sử dụng MS Windows

Ở phần này, tôi sẽ giám sát host CentOS 7. Vì thế tôi sẽ tải file `RPM`.

Kiểm tra `xinet.d` đã được cài đặt.

```
rpm -qa | grep xinetd
```

<img src="images/9.xinet.png" />

Nếu câu lệnh không trả về kết quả như hình, vui lòng cài đặt theo lệnh sau:

```
yum install xinetd -y
```

Khởi động dịch vụ và cho chạy cùng hệ thống:

```
systemctl start xinetd
systemctl enable xinetd
```
Quay trở lại host cần giám sát, chúng ta tải `agent` cho nó từ server.

```
wget http://192.168.100.131/monitoring/check_mk/agents/check-mk-agent-1.2.6p12-1.noarch.rpm --user omdadmin --password omd
```

**Lưu ý:** 
- Nếu bạn đã thay đổi password ở bước trên, vui lòng thay thế password của bạn vào câu lệnh. 
- Thay thế địa chỉ IP server vào câu lệnh trên.

Cài đặt `agent` bằng lệnh

```
rpm -ivh check-mk-agent-1.2.6p12-1.noarch.rpm
```

<img src="images/9.agent2.png" />

Để cho phép OMD Server được truy cập vào host, chúng ta chỉnh sửa file cấu hình `agent` trên host

```
vi /etc/xinetd.d/check_mk
```

<img src="images/9.agent3.png" />

Có 3 thông số chúng ta cần phải chỉnh cho chính xác:

- port: 6556
- only_from: Thêm địa chỉ IP server OMD của bạn
- disable: no (Có nghĩa cho phép dịch vụ chạy)

Sau khi chỉnh xong, chúng ta lưu lại file và khởi động lại `xinetd`.

```
systemctl restart xinetd
```

Kiểm tra port đã hoạt động

```
netstat -npl | grep 6556
```

<img src="images/9.agent4.png" />

Nếu không có lệnh `netstat` vui lòng cài tiện ích `net-tools`:

```
yum install -y net-tools
```

Quay trở lại Web UI, chúng ta sẽ thêm mới 1 host. Đầu tiên, Vào Menu `WATO Configuration`, chọn `Hosts` và click vào `Create new host`

<img src="images/10.host1.png" />

Điền thông tin của host của bạn như hình:

<img src="images/10.host2.png" />

Click vào `Save & go to Services`, sau đó Server sẽ thu thập thông tin từ Agent cài trên host giám sát.

<img src="images/10.host3.png" />

Click tiếp vào `Save manual check configuration` để lưu.

Một host mới đã được thêm, bấm vào ô màu cam `2 Changes` để active những thay đổi:

<img src="images/10.host4.png" />
 
<img src="images/10.host5.png" />

<img src="images/10.host6.png" />

Các thay đổi được Appy thành công.

Tại Tab `View`, `Services` > `All Services`, click vào biểu tượng `Rerfesh` để force check dịch vụ:

<img src="images/10.host7.png" />


### 4. Thêm dịch vụ giám sát Active Checks  <a name="4"></a>

Trên Web UI, chúng ta tìm đến `WATO Configuration`, chọn `Host & Services Parameters`

<img src="images/12.ac1.png" />

Ở đây, có khá nhiều dịch vụ. Trong ví dụ này tôi chọn SSH.

<img src="images/12.ac2.png" />

Bấm vào `Create rule in folder:` để tạo 1 rule mới

<img src="images/12.ac3.png" />

Khai báo host cần giám sát, bấm save để lưu lại.

<img src="images/12.ac4.png" />

Lưu lại những thay đổi

<img src="images/12.ac5.png" />

<img src="images/12.ac6.png" />

<img src="images/10.host6.png" />

Kiểm tra lại dịch vụ đã giám sát thành công:

Tại Tab `View`, `Services` > `All Services`

<img src="images/12.ac7.png" />