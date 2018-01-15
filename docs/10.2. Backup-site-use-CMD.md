## Quản lý site trên OMD

Trước khi thực hiện bước này, vui lòng cài đặt server OMD theo hướng dẫn sau: 

- [1. Hướng dẫn cài đặt](../README.md#1)
	- [Ubuntu 14.04](1.3.Setup-OMD-U14.04.md)
	- [Ubuntu 16.04](1.2.Setup-OMD-U16.04.md)
	- [CentOS 7](1.1.Setup-OMD-CentOS7.md)

### Menu

- [1. Giới thiệu](#1)
- [2. Thêm site mới](#2)
- [3. Cấu hình site](#3)
- [4. Khởi động site](#4)
- [5. Xem trạng thái của site](#5)
- [6. Đổi mật khẩu mặc định cho omdadmin](#6)
- [7. Backup dữ liệu của site](#7)
- [8. Dừng hoạt động của site](#8)
- [9. Xóa site](#9)
- [10. Restore dữ liệu sang site mới](#10)
- [11. Reset mật khẩu omdadmin khi đăng nhập Web UI](#11)

<a name="1" ></a>
### 1. Giới thiệu

OMD sử dụng lệnh `omd <option>`
Trong đó, các `option` được liệt kê ra như sau:

```
omd help
```

```
omd help                               Show general help
omd setup                              Prepare operating system for OMD (installs packages)
omd uninstall                          Remove OMD and all sites!
omd setversion VERSION                 Sets the default version of OMD which will be used by new sites
omd version    [SITE]                  Show version of OMD
omd versions                           List installed OMD versions
omd sites                              Show list of sites
omd create     SITE                    Create a new site (-u UID, -g GID)
omd init       SITE                    Populate site directory with default files and enable the site
omd rm         SITE                    Remove a site (and its data)
omd disable    SITE                    Disable a site (stop it, unmount tmpfs, remove Apache hook)
omd enable     SITE                    Enable a site (reenable a formerly disabled site)
omd mv         SITE NEWNAME            Rename a site
omd cp         SITE NEWNAME            Make a copy of a site
omd update     SITE                    Update site to other version of OMD
omd start      [SITE] [SERVICE]        Start services of one or all sites
omd stop       [SITE] [SERVICE]        Stop services of site(s)
omd restart    [SITE] [SERVICE]        Restart services of site(s)
omd reload     [SITE] [SERVICE]        Reload services of site(s)
omd status     [SITE] [SERVICE]        Show status of services of site(s)
omd config     SITE ...                Show and set site configuration parameters
omd diff       SITE ([RELBASE])        Shows differences compared to the original version files
omd su         SITE                    Run a shell as a site-user
omd umount     [SITE]                  Umount ramdisk volumes of site(s)
omd backup     SITE SITE [-|ARCHIVE_PATH] Create a backup tarball of a site, writing it to a file or stdout
omd restore    [SITE] [-|ARCHIVE_PATH] Restores the backup of a site to an existing site or creates a new site
```
<a name="2" ></a>
### 2. Thêm site mới

Trước khi sử dụng, chúng ta phải khai báo một `site`:

```
omd create site1
```

<img src="../images/c7-4-create-site.png" />

Như vậy một site có tên là `site1` đã được tạo ra và phần thông tin trong hình. Mặc định, username được cấp là `omdadmin` và password là `omd`.

**Chú ý:** Có thể tạo nhiều `site` và tên được chọn tùy ý bằng bao gồm ký tự `A-Z`, `a-z`, `0-9` và ký tự `_`.

<a name="3" ></a>
### 3. Cấu hình site

```
omd config site1
```

<img src="../images/22-site-config-1.png" />

- Trong đó:
	- `Basic`: Cấu hình core của OMD
	
	<img src="../images/22-site-config-basic.png" />
	
	- `Web UI`: Cấu hình về Web UI
	
	<img src="../images/22-site-config-gui.png" />
	
	- `Addons`: Cấu hình các addon
	
	<img src="../images/22-site-config-addons.png" />
	
	- `Distributed Monitoring`: Cấu hình giám sát tập trung
	
	<img src="../images/22-site-config-dm.png" />

<a name="4" ></a>
### 4. Khởi động site

Sau khi tạo xong `site`, chúng ta kích hoạt site đó và đăng nhập thử trên Web UI.

#### Kích hoạt `site`
    
```
omd start site1
```

<img src="../images/c7-4-active-site.png" />

#### Truy cập vào Web UI và đăng nhập bằng `omdadmin/omd`
   
```
http://địa-chỉ-ip/site1
```

<img src="../images/login-1.png" />

Sau khi chọn xong, chúng ta sẽ thấy một giao diện khá hoàn hảo với đầy đủ những chức năng cần thiết.

<img src="../images/login-2.png" />

<a name="5" ></a>
### 5. Xem trạng thái của site

```
omd status site1
```

<img src="../images/22-site-status.png" />


<a name="6" ></a>
### 6. Đổi mật khẩu mặc định cho `omdadmin`

Mặc định, user và password được cấp cho `site` mới là `omdadmin/omd`. Để đảm bảo tính an toàn, chúng ta thay đổi bằng cách:

Vào Menu, trong `WATO - Configuration`, chọn `User` (1), chọn tiếp chỉnh sửa (2)

<img src="../images/8.pass1.png" />

Kéo xuống phần `Security` và thay đổi thông tin

<img src="../images/8.pass2.png" />

Sau đó bấm `SAVE` để lưu lại thông tin.

<a name="7" ></a>
### 7. Backup dữ liệu cho site

Ở bài hướng dẫn này, tôi đã theo dõi [Active check](3.Active-check.md) với YouTube và cũng thêm 1 [user](5.Send-Noitify.md#22) trên site là `userhn`.

Thông tin trên site `site1`

<img src="../images/host-hn.png" />

<img src="../images/user-hn.png" />

Chúng ta backup lại thông tin theo các bước sau:

Đầu tiên trên Web UI `site1`, chúng ta tìm đến **WATO - Configuration**, **Backup & Restore**, **Create Snapshot**

<img src="../images/dm-bk-1.png" />

Sau đó, tải bản backup (Snapshot) về máy tính của bạn. Chúng ta nhìn vào thông báo, và chọn đúng thời gian chúng ta backup.

<img src="../images/dm-bk-2.png" />

<img src="../images/dm-bk-3.png" />

Lưu lại trên máy tính của bạn, ở đây tôi đã đổi tên file là `site1-backup.tar`

<img src="../images/dm-bk-4.png" />

<a name="8" ></a>
### 8. Dừng hoạt động của site

```
omd stop site1
```

<img src="../images/22-site-stop.png" />

<a name="9" ></a>
### 9. Xóa site

```
omd rm site1
```

Gõ `YES` để đồng ý xóa site.

<img src="../images/22-site-remove.png" />

<a name="10" ></a>
### 10. Restore dữ liệu của site

Ở bước này, chúng ta cần tạo một site mới có tên là `site1_backup` theo [hướng dẫn bên trên.](#2) Sau đó kích hoạt nó ở [bước 4](#4) và restore lại dữ liệu của `site1` mà ta đã xóa ở **bước 7**.

Đầu tiên, chúng ta đăng nhập vào Web UI của site và kích hoạt tính năng restore dữ liệu kém bảo mật. **Tại sao phải bật tính năng này?** Câu trả lời là mỗi site sẽ được gán cho một hash và file backup (Snapshot) sẽ gắn liền với site. Khi chúng ta tạo site mới thì hash này cũng thay đổi, vì vậy chúng ta phải kích hoạt tính năng này để Restore lại dữ liệu của site cũ.

Trên tab **WATO Configuration**, chúng ta chọn **Global Settings** chọn mục **Administration Tools (WATO)** và chỉnh **Allow upload of insecure WATO snapshots** từ `OFF` sang `ON` như hình.

<img src="../images/23-rt-1.png" />

Kích hoạt xong, chúng ta bấm vào **Backup & Restore** trên tab **WATO Configuration** và chọn file backup lúc trước ở bước 7. 

<img src="../images/23-rt-2.png" />

Sau khi chọn file xong, chúng ta bấm vào nút **Restore from file**.

<img src="../images/23-rt-3.png" />

Như đã giải thích ở trên, do đây là file backup của một site khác nên hash của chúng không trùng nhau vì thế OMD báo là *Untrust* - hình tròn màu đỏ. Bỏ qua điều này, chúng ta bấm vào **Restore snapshot**

<img src="../images/23-rt-4.png" />

<img src="../images/23-rt-5.png" />

Sau đó chúng ta thấy thông báo Restore thành công và lưu lại những thay đổi.

<img src="../images/23-rt-6.png" />

<img src="../images/23-rt-7.png" />

<img src="../images/23-rt-8.png" />

Sau đó, chúng ta kiểm tra lại thông tin host và user.

<img src="../images/23-rt-9.png" />

<img src="../images/23-rt-10.png" />

<a name="11" ></a>
### 11. Reset mật khẩu omdadmin khi đăng nhập Web UI

Trong một số trường hợp, chúng ta [thay đổi password](#6) cho omdadmin nhưng lại quên mật khẩu điều này gây rắc rối cho ta khá nhiều. Đừng lo lắng về điều đó, tôi sẽ hướng dẫn các bạn cách để khôi phục lại mật khẩu trong vòng 'một nốt nhạc'.

Mở file lưu trữ mật khẩu đăng nhập:

```
vi /opt/omd/sites/site1/etc/htpasswd
```

**Chú ý**: 
- `site1` là tên site của bạn
- `/opt/omd` là thư mục cài đặt mặc định của OMD

Sửa file với nội dung:

```
omdadmin:M29dfyFjgy5iA
```

Lưu file và đăng nhập lại trên web UI bằng *omdadmin/omd*.

## Tham khảo những bài viết khác:

- [2. Cài đặt Agent trên host cần giám sát](2.Install-agent.md)
- [3. Cấu hình Active Check dịch vụ](3.Active-check.md)
- [4. Đặt ngưỡng cảnh báo cho dịch vụ](4.Set-threshold.md)
- [5. Cấu hình gửi mail cảnh báo sử dụng Gmail](5.Send-Noitify.md)
- [6. Thêm plugin vào OMD](6.Add-plugins.md)
- [7. Distributed Monitoring](7.Distributed.md)