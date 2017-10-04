Check_MK lưu trữ tất cả dữ liệu theo một cách đặc biệt là RRDs (Round Robin Data bases). RRDTool được phát triển bởi Tobi-Oetiker là một phần mềm mã nguồn mở, sử dụng khá rộng dãi.

Những lợi thế của RRDs so với cách lưu trữ MySQL cổ điển:

- Lưu trữ dữ liệu chặt chẽ, cô đọng và hiệu quả
- Dung lượng lưu trữ của mỗi metric là tĩnh, vì vậy có thể xác định được không gian lưu trữ
- Việc xử lý dữ liệu khá nhanh 

## 1. Dữ liệu được tổ chức trong RRDs

- Mặc định, hiệu suất của mỗi Metric được Check_MK ghi lại trong khoảng thời gian 4 năm.
- Quãng thời gian mỗi lần check cách nhau 1 phút. Điều này sẽ đảm bảo tính chính xác trong quá trình phân tích.
- Việc thông tin metric được gửi về theo từng phút yêu cầu không gian đĩa lưu trữ phải rất lớn (Mặc dù, RDD chỉ cần 8 bytes cho mỗi metric/lần).
- Do đó, dữ liệu sẽ được nén trong vòng 48 tiếng. Từ thời điểm nén, chỉ có một giá trị sẽ được lưu trữ sau 5 phút và tăng dần lên 30 phút, 6h.
- Trong khoảng thời gian từ 10 - 90 ngày

| Phase | Duration | Resolution | Số lượt đo |
|--|--|--|--|
|1| 2 ngày | 1 phút | 2280 |
|2| 10 ngày | 5 phút | 2280 |
|3| 90 ngày | 30 phút |4320|
|4| 4 năm | 6 tiếng |5840 |


- Giá trị được lưu trữ: Giá trị ở mức tối đa (cao nhất), Giá trị tối thiểu (nhỏ nhất) và giá trị trung bình.
- Mỗi metric có dung lượng là 384,952 bytes
	- Được tính như sau: 
		- 2880 + 2880 + 4320 + 5840 (lần đo)
		- Nhân với 3 giá trị (Tối đa, tối thiểu và trung bình)
		- Nhân với 8 bytes dữ liệu - Dung lượng của metric
		- Cộng thêm 2872 bytes cho phần Metadata (Tiêu đề của dữ liệu)
- Theo tính toán: Trong vòng một năm (365 ngày), dữ liệu của một metric được thu thập theo mỗi phút có dung lượng ~ 4MB (Cách tính: 365 * 24 * 60 * 8 (Đơn vị: Byte))

## 2. Ghi dữ liệu ra rrdcached

- Dữ liệu metric của mỗi host hoặc service sẽ được lưu trữ vào file RDD riêng biệt
- Check_MK không ghi các dữ liệu trực tiếp vào nơi lưu trữ (Như SAN, NAS,...) mà chuyển dữ liệu sang rrdcache. Như vậy sẽ giảm số lượng truy xuất (đọc và ghi) dữ liệu.
- Để RRD cached daemon làm việc tối ưu và hiệu quả, chúng cần khá nhiều main memory (RAM or DISK?). Dung lượng bộ nhớ phụ thuộc vào số lượng các metric và thời gian lưu trữ
- Chúng ta có thể chỉnh sửa các thông số mặc định trong file cấu hình `etc/rrdcached.conf`. 
- Thời gian mặc định lưu trữ là 7200 giây (2 tiếng). Có thể tùy chỉnh giảm xuống trong khoảng từ 0-1800 giây.
- Toàn bộ file `etc/rrdcached.conf`

```
# Data is written to disk every TIMEOUT seconds. If this option is
# not specified the default interval of 300 seconds will be used.
TIMEOUT=3600

# rrdcached will delay writing of each RRD for a random
# number of seconds in the range [0,delay).  This will avoid too many
# writes being queued simultaneously.  This value should be no
# greater than the value specified in TIMEOUT.
RANDOM_DELAY=1800

# Every FLUSH_TIMEOUT seconds the entire cache is searched for old values
# which are written to disk. This only concerns files to which
# updates have stopped, so setting this to a high value, such as
# 3600 seconds, is acceptable in most cases.
FLUSH_TIMEOUT=7200
```

## 3. Thư mục lưu trữ:

| Thư mục | Ý nghĩa |
|--|--|
|var/check_mk/rrd |	RRDs theo định dạng mới của Check_MK (CEE) |
|var/pnp4nagios/perfdata |	RRDs dịnh dạng cũ (PNP) - CRE | 
|var/rrdcached | Các Journal log của RRD cache daemon |
|var/log/rrdcached.log	| File log của RRD cache daemon | 
|var/log/cmc.log |	File log của Check_MK core (CEE) (bao gồm các thông điệp lỗi từ RRDs) |
|etc/pnp4nagios |	File cấu hình của PNP4Nagios ( Check_MK Raw Edition) |
|etc/rrdcached.conf |	File cấu hình của RRD cache daemon |