<div align="center">
  <h1>♟️ PHÂN TÍCH VÀ DỰ ĐOÁN NƯỚC ĐI TRONG CỜ VUA</h1>
</div>

<div align="center">
  <img src="logo.png" alt="Logo Đại học Đại Nam" width="200"/>
</div>

<h2 align="center">🔍 Ứng dụng Apache Spark và Machine Learning trong phân tích cờ vua</h2>
<p align="center">Dự án bài tập lớn môn Dữ liệu lớn - Khoa Công nghệ Thông tin, Đại học Đại Nam.</p>

---

## 🏗️ Giới thiệu Dự án
Dự án này hướng tới phân tích và dự đoán nước đi trong cờ vua bằng cách sử dụng **hơn 160,000 ván cờ** từ tập dữ liệu `chess_games.csv` (nguồn: Kaggle). Mục tiêu chính bao gồm:

- **Phân tích dữ liệu cờ vua**: Đánh giá **Elo rating**, khai cuộc phổ biến và các giai đoạn của ván đấu.
- **Dự đoán kết quả trận đấu**: Áp dụng **Random Forest** để dự đoán người chiến thắng dựa trên Elo rating và lịch sử nước đi.
- **Gợi ý nước đi tiếp theo**: Xây dựng hệ thống gợi ý dựa trên tần suất xuất hiện của các nước đi trong dữ liệu huấn luyện.

## ✨ Tính năng nổi bật
✅ **Thống kê dữ liệu**: Biểu đồ phân bố Elo, danh sách khai cuộc phổ biến.
✅ **Dự đoán kết quả**: Độ chính xác **trên 80%** bằng mô hình Random Forest.
✅ **Gợi ý nước đi**: Đề xuất nước đi tiếp theo dựa trên tần suất lịch sử và độ hiệu quả của nước đi.

## 🔧 Công nghệ sử dụng
- **Ngôn ngữ**: R (các thư viện `sparklyr`, `dplyr`, `ggplot2`, `stringr`, `viridis`).
- **Framework**: Apache Spark (MLlib).
- **Dữ liệu**: `chess_games.csv`.

---

## 📥 Cài đặt

### 🛠️ Yêu cầu hệ thống
- **R 4.0+**.
- **Apache Spark 3.x**.
- **RAM tối thiểu 4GB**.
- **Dung lượng lưu trữ tối thiểu 1GB**.

### ⚙️ Hướng dẫn cài đặt
#### 1️⃣ Cài đặt R và Apache Spark:
```bash
sudo apt install r-base
wget https://archive.apache.org/dist/spark/spark-3.5.0/spark-3.5.0-bin-hadoop3.tgz
tar -xzf spark-3.5.0-bin-hadoop3.tgz
```
#### 2️⃣ Cài đặt thư viện R:
```r
install.packages(c("sparklyr", "dplyr", "ggplot2", "stringr", "viridis"))
```
#### 3️⃣ Kết nối Apache Spark:
```r
library(sparklyr)
sc <- spark_connect(master = "local")
```

---

## 🚀 Cách sử dụng
1. **Tải tập dữ liệu `chess_games.csv`** và đặt vào thư mục dự án.
2. **Chạy mã nguồn phân tích**:
```r
source("chess_analysis.R")
```

---

## 📊 Kết quả Phân tích
- **Phân bố Elo rating**: Đa số người chơi có Elo trung bình **1500-2000**.
- **Các khai cuộc phổ biến**:
  - `Sicilian Defense`.
  - `French Defense`.
  - `Italian Game`.
- **Dự đoán kết quả trận đấu**:
  - **Trắng (Elo 2000) vs Đen (Elo 1900)**: Trắng thắng (**xác suất ~70%**).
  - **Chuỗi nước đi tiêu biểu**: `e4 e5 Nf3 Nc6` → Gợi ý **Bb5**.

## 📂 Cấu trúc thư mục dự án
```
├── chess_games.csv        # Dữ liệu ván cờ
├── code.R                 # Code           
├── NHOM_5-CNTT16-01.dox   # Báo cáo bài tập lớn
└── README.md              # Hướng dẫn sử dụng
```

---

## 📈 Hiệu suất & Hạn chế
- ✅ **Hiệu suất**: Mô hình Random Forest đạt độ chính xác **hơn 80%**.
- ❌ **Hạn chế**:
  - Không xét đến các chiến thuật phức tạp và ý đồ của đối thủ.
  - Chưa tích hợp mô hình chuyên sâu như LSTM hoặc Transformer.
- 🔄 **Cải tiến trong tương lai**:
  - Ứng dụng mô hình học sâu (LSTM/Transformer) để tăng cường khả năng dự đoán.
  - Tích hợp giao diện trực quan để hiển thị phân tích nước đi tốt nhất.

---

## 📝 Thông tin Nhóm Thực Hiện
- **Đề tài**: Phân tích và dự đoán nước đi trong cờ vua.
- **Giảng viên hướng dẫn**:
  - TS. **Trần Quý Nam**.
  - ThS. **Lê Thị Thùy Trang**.
- **Thành viên nhóm**:
  - 🏅 **Đinh Thế Thành** (1671020292).
  - 🏅 **Đặng Trường Dương** (1671020072).
  - 🏅 **Trịnh Hoàng Hà** (1671020087).
  - 🏅 **Nguyễn Thanh Sơn** (1671020278).
- **Thời gian thực hiện**: **Tháng 2/2025**.
- **Trường**: Đại học Đại Nam, Khoa Công nghệ Thông tin.

---

## 📚 Tài liệu Tham Khảo
- [Hướng dẫn cài đặt](#cài-đặt).
- [Hướng dẫn sử dụng](#sử-dụng).

## 📝 Bản quyền
© **2025 Nhóm 5 sinh viên CNTT_16-01**, Khoa Công nghệ Thông tin, Đại học Đại Nam.

