🌦 Weather App — Flutter

Ứng dụng dự báo thời tiết theo API OpenWeather, hỗ trợ GPS, tìm kiếm thành phố, lưu lịch sử, quản lý yêu thích, giao diện động theo điều kiện thời tiết và nhiều tính năng nâng cao.

📌 Giới thiệu

Ứng dụng Weather App được xây dựng bằng Flutter, sử dụng:

OpenWeather API

Provider (State Management)

SharedPreferences (Cache + Favorites + Search History)

Geolocator (GPS)

Dotenv để quản lý API key

Giao diện trực quan, động theo thời tiết

✨ Tính năng chính
🌍 1. Lấy thời tiết hiện tại theo:

🌐 Tên thành phố

📍 Vị trí GPS (auto-detect)

🔎 2. Tìm kiếm thành phố

Gõ tên → nhận kết quả ngay

Tự động lưu vào search history

Chọn lại nhanh từ lịch sử

❤️ 3. Favorite Cities

Thêm/Xoá thành phố yêu thích

Giới hạn tối đa 10 mục

Đồng bộ với SharedPreferences

🕒 4. Forecast (Dự báo)

Hourly Forecast (3h/step)

Daily Forecast (auto pick 12:00 mỗi ngày)

🎨 5. Dynamic UI (Tuỳ biến theo thời tiết)

Nắng ☀ → Gradient vàng–xanh

Mưa 🌧 → Xám đậm

Nhiều mây ☁ → Xám nhạt

Mặc định → Xanh lam

⚙️ 6. Settings

Chuyển đổi °C ↔ °F

Chọn định dạng thời gian 12h / 24h

Reset toàn bộ settings

💾 7. Cache offline

Lưu lại lần xem gần nhất

Khi mất mạng → hiển thị cache

🧭 8. GPS Location

Tự động xin permission

Lấy thời tiết theo vị trí hiện tại

📜 9. Lịch sử tìm kiếm

Tự lưu 10 mục gần nhất

Không trùng lặp

Nhấn để xem lại thời tiết cũ

📁 Cấu trúc thư mục chính
lib/
 ├── providers/
 │     weather_provider.dart
 │     settings_provider.dart
 │
 ├── services/
 │     weather_service.dart
 │     storage_service.dart
 │     settings_service.dart
 │
 ├── screens/
 │     home_screen.dart
 │     search_screen.dart
 │     settings_screen.dart
 │
 ├── widgets/
 │     current_weather_card.dart
 │     hourly_forecast_list.dart
 │     daily_forecast_section.dart
 │
 ├── models/
 │     weather_model.dart

🔐 Bảo mật API KEY

API Key không đẩy lên GitHub.

File .env chứa API key → không commit

File .env.example → commit để người khác tự điền key

Nội dung .env.example:

API_KEY=

📸 Screenshots

<img width="561" height="1015" alt="image" src="https://github.com/user-attachments/assets/245e650e-6f6e-41a4-9a7c-4c5af791f66c" />
<img width="1453" height="1022" alt="image" src="https://github.com/user-attachments/assets/ca3c6a35-66fb-4124-8a6c-714c69803d93" />
<img width="559" height="1014" alt="image" src="https://github.com/user-attachments/assets/ee5d8256-6121-4573-b2d5-1d9b9292f520" />
<img width="986" height="1012" alt="image" src="https://github.com/user-attachments/assets/b1e33468-c058-4d42-a7e8-6c3bd15afdc7" />
<img width="563" height="1022" alt="image" src="https://github.com/user-attachments/assets/fb9880b7-56eb-4f77-bfa7-f188408042e1" />


🔧 Cài đặt & Chạy ứng dụng
1. Clone project
git clone https://github.com/<yourname>/weather_app.git
cd weather_app

2. Tạo file .env
API_KEY=YOUR_OPENWEATHER_KEY

3. Install packages
flutter pub get

4. Run app
flutter run

📌 Công nghệ sử dụng
Công nghệ	Mục đích
Flutter	Mobile UI Framework
Provider	State Management
HTTP	Gọi API
Dotenv	Bảo mật API key
SharedPreferences	Local Storage
Geolocator	GPS & Permission
Intl	Format ngày/giờ
CachedNetworkImage	Tải icon thời tiết
📜 Mô tả API

Dùng OpenWeather API:

Hiện tại:

/weather?q=...&appid=...&units=metric


Dự báo:

/forecast?q=...&appid=...&units=metric

👨‍💻 Người thực hiện

Nguyễn Châu Thiện
MSSV : 2224801030117

=> Link video demo : https://drive.google.com/file/d/16uAIPmnPMMCvX-5i0lC_EB9-juxv0k0a/view?usp=sharing
