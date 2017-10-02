Check_MK lưu trữ tất cả dữ liệu theo một cách đặc biệt là RRDs (Round Robin Data bases). RRDTool được phát triển bởi Tobi-Oetiker là một phần mềm mã nguồn mở, sử dụng khá rộng dãi.

Những lợi thế của RRDs so với cách lưu trữ MySQL cổ điển:

- Lưu trữ dữ liệu chặt chẽ, cô đọng và hiệu quả
- Dung lượng lưu trữ của mỗi metric là tĩnh, vì vậy có thể xác định được không gian lưu trữ
- Việc xử lý dữ liệu khá nhanh 

## 1. Dữ liệu được tổ chức trong RRDs

- Mặc định, hiệu suất của mỗi Metric được Check_MK ghi lại trong khoảng thời gian 4 năm.
- Quãng thời gian mỗi lần check cách nhau 1 phút. Điều này sẽ đảm dảo tính tính xác trong quá trình phân tích.
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
- Mỗi metric có dung lượng là 384,952 byte
	- Được tính như sau: 
	- 2880 + 2880 + 4320 + 5840 (lần đo)
	- Nhân với 3 giá trị (Tối đa, tối thiểu và trung bình)
	- Nhân với 8 bytes dữ liệu - Dung lượng của metric
	- Cộng thêm 2872 bytes cho phần Metadata (Tiêu đề của dữ liệu)
- Theo tính toán, nếu do metric theo từng phút thì một năm. Một metric dữ liệu chiếm khoảng 4MB. (365 * 24 * 60 * 8)

2. Ghi dữ liệu ra rrdcached

- Check_MK không ghi các dữ liệu trực tiếp vào nơi lưu trữ (Như SAN, NAS,...) mà chuyển dữ liệu sang rrdcache. Như vậy sẽ giảm số lượng truy xuất dữ liệu.
- ...