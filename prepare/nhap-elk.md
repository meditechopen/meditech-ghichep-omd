# Monitor ELK bên cục.

- Tải check_mk agent :

	```sh
	wget http://172.17.40.52/monitoring/check_mk/agents/check-mk-agent_1.4.0p22-1_all.rpm
	```
	
- Cài check_mk_agent trên ELK :

	```sh
	rpm -Uvh check_mk_*
	```
	
- Cài đặt xinetd :

	```sh
	yum install -y xinetd
	```
	
- Sửa lại file cấu hình xinetd  trên ELK để cho phép check_mk lấy thông tin từ ELK :

![](/images/nhap-elk.png)

- Cấu hình rule iptables mở port 6556 :

	```sh
	iptables -I INPUT -p tcp -m tcp --dport 6556 -j ACCEPT
	iptables -I OUTPUT -p tcp -m tcp --sport 6556 -j ACCEPT
	```
	
- Cấu hình trên WATO, add node bình thường.
