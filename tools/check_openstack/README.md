## Hướng dẫn sử dụng vào check_mk

### Tải plugin

- Tải plugin ở 2 thư mục `check_resoucres` và `check_services`

```
https://github.com/meditechopen/meditech-ghichep-omd/tree/master/tools/check_openstack
```

Ví dụ, chúng ta tải các plugin về thư mục `/opt/check_openstack`

- Phân quyền cho các plugins

```
cd /opt/check_openstack
chmod +x *
```

### check_mk

**Chú ý**: Các bước này làm trên node `controller` của OpenStack

- **Bước 1**: Copy các file plugin

[Hướng dẫn cài check_mk Agent trên máy cần giám sát.](https://github.com/hoangdh/meditech-ghichep-omd/blob/master/docs/2.Install-agent.md)

Thư mục mặc định: `/usr/lib/check_mk_agent/plugins`

Xác định lại thư mục:

```
[root@controller ~]# check_mk_agent | grep 'PluginsDirectory'
PluginsDirectory: /usr/lib/check_mk_agent/plugins
```

- **Bước 2**: Thêm cấu hình vào file `mrpe.cfg`

	- Cú pháp như sau:

	```
	<Tên-Hiển-thị-trên-Dashboard> <Đường-dẫn-plugin>
	```
	
	- Ví dụ:
	
	```
	OPENSTACK_Cinder /usr/lib/check_mk_agent/plugins/check_cinder
	OPENSTACK_Neutron /usr/lib/check_mk_agent/plugins/check_neutron
	OPENSTACK_Keystone /usr/lib/check_mk_agent/plugins/check_keystone
	OPENSTACK_Nova /usr/lib/check_mk_agent/plugins/check_nova
	OPENSTACK_Glance /usr/lib/check_mk_agent/plugins/check_glance	
	OPENSTACK_Volume /usr/lib/check_mk_agent/plugins/check_volumes
	OPENSTACK_Images /usr/lib/check_mk_agent/plugins/check_images
	OPENSTACK_Networks /usr/lib/check_mk_agent/plugins/check_networks
	OPENSTACK_VMs_State /usr/lib/check_mk_agent/plugins/check_instances_state
	```
