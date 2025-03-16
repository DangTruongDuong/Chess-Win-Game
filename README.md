<div align="center">
♟️ PHÂN TÍCH VÀ DỰ ĐOÁN NƯỚC ĐI TRONG CỜ VUA
</div> <div align="center"> <img src="images/logo.png" alt="Logo Đại học Đại Nam" width="200"/> </div> <h3 align="center">🔍 Ứng dụng Apache Spark và Machine Learning trong phân tích cờ vua</h3> <p align="center"> Dự án bài tập lớn môn Dữ liệu lớn - Khoa Công nghệ Thông tin, Đại học Đại Nam. </p>

🏗️ Mô tả dự án
Dự án phân tích hơn 160,000 ván cờ từ tập dữ liệu chess_games.csv (nguồn: Kaggle) để:

- Thống kê Elo rating, khai cuộc phổ biến và các giai đoạn ván đấu.
- Dự đoán kết quả trận đấu bằng mô hình Random Forest.
- Gợi ý nước đi tiếp theo dựa trên lịch sử ván đấu.

✨ Tính năng chính
- Phân tích dữ liệu: Biểu đồ phân bố Elo, top 10 khai cuộc phổ biến.
- Dự đoán kết quả: Độ chính xác trên 80% với Random Forest.
- Gợi ý nước đi: Đề xuất nước đi tiếp theo dựa trên tần suất lịch sử.

🔧 Công nghệ sử dụng
- Ngôn ngữ: R (thư viện sparklyr, dplyr, ggplot2, stringr, viridis)
- Framework: Apache Spark (MLlib)
- Dữ liệu: chess_games.csv

📥 Cài đặt

🛠️ Yêu cầu
- R 4.0+
- Apache Spark 3.x
- RAM 4GB+
- Dung lượng lưu trữ 1GB+

⚙️ Hướng dẫn cài đặt

Cài đặt R và Spark:
```bash
sudo apt install r-base
wget https://archive.apache.org/dist/spark/spark-3.5.0/spark-3.5.0-bin-hadoop3.tgz
tar -xzf spark-3.5.0-bin-hadoop3.tgz
```

Cài đặt thư viện R:
```r
install.packages(c("sparklyr", "dplyr", "ggplot2", "stringr", "viridis"))
```

Kết nối Spark:
```r
library(sparklyr)
sc <- spark_connect(master = "local")
```

🚀 Sử dụng
- Tải tập dữ liệu chess_games.csv và đặt vào thư mục dự án.
- Chạy mã nguồn:
```r
source("chess_analysis.R")
```

📊 Kết quả
- **Phân bố Elo**: Người chơi có Elo trung bình ~1500-2000.
- **Top khai cuộc**: Sicilian Defense, French Defense, Italian Game.
- **Dự đoán**:
  - Trắng (Elo 2000) vs Đen (Elo 1900): Trắng thắng (xác suất ~70%).
  - Chuỗi nước đi e4 e5 Nf3 Nc6: Gợi ý Bb5.

📂 Cấu trúc thư mục
```
├── chess_games.csv      # Tập dữ liệu cờ vua
├── chess_analysis.R     # Mã nguồn R
├── report.pdf           # Báo cáo bài tập lớn
└── README.md            # File này
```

📈 Hiệu suất & Hạn chế
- **Hiệu suất**: Random Forest đạt độ chính xác >80%.
- **Hạn chế**: Chỉ dự đoán dựa trên Elo và lịch sử nước đi, chưa xét yếu tố chiến thuật phức tạp.
- **Cải tiến**: Tích hợp mô hình sâu (LSTM/Transformer) để dự đoán chính xác hơn.

📝 Thông tin nhóm
- **Đề tài**: Phân tích và dự đoán nước đi trong cờ vua
- **Giảng viên**: TS. Trần Quý Nam, ThS. Lê Thị Thùy Trang
- **Thành viên**:
  - Đinh Thế Thành (1671020292)
  - Đặng Trường Dương (1671020072)
  - Trịnh Hoàng Hà (1671020087)
  - Nguyễn Thanh Sơn (1671020278)
- **Thời gian**: Tháng 2/2025
- **Trường**: Đại học Đại Nam, Khoa CNTT

📚 Tài liệu
- Hướng dẫn cài đặt
- Hướng dẫn sử dụng

📝 Bản quyền
© 2025 Nhóm 5 sinh viên CNTT_16-01, Khoa Công nghệ Thông tin, Đại học Đại Nam.

