### Drbd + Pacemaker

Note nhanh các bước cấu hình thêm resource cho Drbd

- Chuẩn bị LV: 5GB, lv-omd
- Cấu hình thiết bị /dev/drbd0

Full File cấu hình: `/etc/drbd.d/testdata1.res`

```
resource testdata1 {
protocol C;
on omd1 {
                device /dev/drbd0;
                disk /dev/centos/lv-omd;
                address 192.168.100.145:7788;
                meta-disk internal;
        }
on omd2 {
                device /dev/drbd0;
                disk /dev/centos/lv-omd;
                address 192.168.100.144:7788;
                meta-disk internal;
        }
}
```

- Chạy lệnh sau trên cả 2 server:

```
drbdadm create-md testdata1
```

- Khởi động DRBD

```
systemctl start drbd
systemctl enable drbd
```

- Xác định node chính: (Chạy trên server thứ 1)

```
drbdadm primary testdata1 --force
```

- Chờ đồng bộ dữ liệu, quá trình hoàn tất như sau:

```
# drbd-overview

0:testdata1/0  Connected Primary/Secondary UpToDate/UpToDate
```

- Format thiết bị:

```
mkfs.ext3 /dev/drbd0
```

## Tạo Resoure trên Pacemaker


- Thêm 1 VIP:

```
pcs resource create VirtIP ocf:heartbeat:IPaddr2 ip=192.168.2.100 cidr_netmask=32 op monitor interval=30s
```

- Cấu hình thêm Resoure Drbd trên Pacemaker

```
pcs cluster cib drbd_cfg

pcs -f drbd_cfg resource create DrbdData ocf:linbit:drbd drbd_resource=testdata1 op monitor interval=60s
# testdata1: Tên của resource khai báo cấu hình Drbd

pcs -f drbd_cfg resource master DrbdDataClone DrbdData master-max=1 master-node-max=1 clone-max=2 clone-node-max=1 notify=true
# Cho phép hoạt động đồng thời trên các node

pcs cluster cib-push drbd_cfg
# Lưu lại cấu hình
```

- Thêm Resoure FS trên Pacemaker

```
pcs cluster cib fs_cfg
pcs -f fs_cfg resource create DrbdFS Filesystem device="/dev/drbd0" directory="/opt/omd/" fstype="ext3"

pcs -f fs_cfg constraint colocation add DrbdFS with DrbdDataClone INFINITY with-rsc-role=Master

# Tạo mối liên hệ giữa DrbdFS với DrbdDataClone, DrbdDataClone khởi động xong thì DrbdFS khởi động
pcs -f fs_cfg constraint order promote DrbdDataClone then start DrbdFS

pcs cluster cib-push fs_cfg
```