# 🏗️ KIẾN TRÚC HỆ THỐNG ORDER FOOD (MONOREPO)

Tài liệu này là **Single Source of Truth (Nguồn chuẩn duy nhất)** quy định cấu trúc thư mục, quy tắc đặt tên và luồng dữ liệu cho cả **Backend (Node.js/Express)** và **Mobile (Flutter)**. Mọi tính năng mới bắt buộc phải tuân thủ kiến trúc này.

---

## 1. 🖥️ BACKEND (`backend/`) — Layered MVC + Service Architecture

```text
backend/
├── src/
│   ├── config/              # Cấu hình hệ thống (db.js kết nối MongoDB, env.js, cors.js)
│   ├── models/              # Mongoose Schemas
│   │   ├── User.js          # Người dùng (customer, admin), địa chỉ giao hàng
│   │   ├── Category.js      # Danh mục món ăn (slug, icon, order, isActive)
│   │   ├── Food.js          # Món ăn (size, toppings, calories, rating, deliveryTime)
│   │   ├── Order.js         # Đơn hàng (items, trạng thái, thanh toán, địa chỉ)
│   │   └── Voucher.js       # Mã giảm giá / Khuyến mãi (code, discountPercent, minOrder)
│   ├── controllers/         # Nhận request (req, res), gọi logic và trả JSON chuẩn
│   │   ├── authController.js
│   │   ├── foodController.js
│   │   ├── categoryController.js
│   │   ├── orderController.js
│   │   └── voucherController.js
│   ├── routes/              # Định nghĩa RESTful API endpoints (/api/...)
│   │   ├── authRoutes.js
│   │   ├── foodRoutes.js
│   │   ├── categoryRoutes.js
│   │   ├── orderRoutes.js
│   │   └── voucherRoutes.js
│   ├── middlewares/         # Xử lý trung gian
│   │   ├── authMiddleware.js    # Kiểm tra & giải mã JWT Token
│   │   ├── roleMiddleware.js    # Phân quyền (Admin / Customer)
│   │   └── errorMiddleware.js   # Bắt lỗi tập trung (Global Error Handler)
│   ├── services/            # Tách biệt nghiệp vụ phức tạp (tính tiền đơn hàng, check voucher)
│   ├── sockets/             # Socket.io cập nhật trạng thái đơn hàng realtime
│   └── utils/               # Hàm tiện ích (apiResponse.js, formatCurrency.js, seed.js)
├── index.js                 # Điểm khởi chạy Express Server
└── package.json
```

---

## 2. 📱 MOBILE (`mobile/lib/`) — Feature-First Clean Architecture (Cubit / BLoC)

Kiến trúc Mobile chia làm 2 tầng lớn:

1. **`core/`**: Hạ tầng kỹ thuật, tiện ích, giao diện & widget dùng chung cho toàn bộ app (không chứa logic nghiệp vụ của riêng màn hình nào).
2. **`features/`**: Chia theo từng module nghiệp vụ độc lập. Mỗi feature tự quản lý `data`, `models`, `cubit`, và `presentation` của riêng nó.

```text
mobile/lib/
│
├── core/                                # 🌐 HẠ TẦNG & DÙNG CHUNG TOÀN ỨNG DỤNG
│   ├── constants/
│   │   ├── app_colors.dart              # Bảng màu chuẩn (primaryRust, background, textMain...)
│   │   ├── api_endpoints.dart           # Tập trung toàn bộ đường dẫn URL API (/auth, /foods, /orders...)
│   │   ├── app_assets.dart              # Đường dẫn ảnh, icon, lottie trong assets/
│   │   └── app_strings.dart             # Chuỗi văn bản cố định, thông báo lỗi chuẩn
│   │
│   ├── network/
│   │   ├── api_client.dart              # Cấu hình Dio, BaseURL, Timeout, Interceptor gắn JWT Token
│   │   └── api_exception.dart           # Chuẩn hóa lỗi mạng & lỗi từ Backend trả về (400, 401, 500)
│   │
│   ├── storage/
│   │   ├── token_storage.dart           # Lưu/xóa JWT Token, thông tin user nhanh (SharedPreferences)
│   │   └── local_cache.dart             # Lưu lịch sử tìm kiếm, giỏ hàng tạm dưới máy
│   │
│   ├── theme/
│   │   ├── app_theme.dart               # ThemeData tổng của ứng dụng (màu sắc, AppBar, Input, Button)
│   │   └── app_text_styles.dart         # Hệ thống kiểu chữ chuẩn (Heading, Title, Body, Caption)
│   │
│   ├── utils/
│   │   ├── currency_formatter.dart      # Format tiền Việt Nam (VD: 55000 -> 55.000đ)
│   │   ├── date_formatter.dart          # Format ngày giờ đơn hàng
│   │   ├── validators.dart              # Kiểm tra hợp lệ Email, SĐT, Mật khẩu
│   │   └── app_snackbar.dart            # Hiển thị thông báo thành công / lỗi thống nhất toàn app
│   │
│   ├── routing/
│   │   └── app_router.dart              # Quản lý điều hướng (Navigation / Route names tập trung)
│   │
│   └── widgets/                         # 🧩 WIDGET DÙNG CHUNG NHIỀU MÀN HÌNH
│       ├── primary_button.dart          # Nút bấm chính bo góc chuẩn màu thương hiệu
│       ├── custom_text_field.dart       # Ô nhập liệu có validate, icon, ẩn/hiện mật khẩu
│       ├── app_network_image.dart       # Hiển thị ảnh mạng có loading shimmer & ảnh lỗi fallback
│       ├── empty_state_view.dart        # Giao diện khi danh sách trống (giỏ hàng trống, không tìm thấy món)
│       ├── error_retry_view.dart        # Giao diện báo lỗi mạng kèm nút "Thử lại"
│       └── loading_overlay.dart         # Vòng xoay loading đồng bộ
│
├── features/                            # 🍱 CÁC MODULE CHỨC NĂNG NGHIỆP VỤ
│   │
│   ├── main_shell/                      # 🧭 Khung điều hướng chính (Bottom Navigation Bar 4 tab)
│   │   └── presentation/
│   │       ├── main_shell_screen.dart   # Giữ trạng thái 4 tab: Khám phá, Đơn hàng, Giỏ hàng, Tài khoản
│   │       └── widgets/
│   │           └── main_bottom_nav_bar.dart
│   │
│   ├── auth/                            # 🔐 1. Xác thực & Tài khoản
│   │   ├── data/
│   │   │   └── auth_repository.dart     # Gọi API /api/auth/login, /register, /me
│   │   ├── models/
│   │   │   └── user_model.dart          # Model người dùng
│   │   ├── cubit/
│   │   │   ├── auth_cubit.dart          # Xử lý đăng nhập, đăng ký, tự động đăng nhập, đăng xuất
│   │   │   └── auth_state.dart
│   │   └── presentation/
│   │       ├── login_screen.dart
│   │       ├── register_screen.dart
│   │       └── widgets/
│   │           ├── auth_header.dart
│   │           └── social_login_buttons.dart
│   │
│   ├── food/                            # 🍔 2. Khám phá Món ăn & Danh mục
│   │   ├── data/
│   │   │   └── food_repository.dart     # Gọi API lấy danh mục, danh sách món, lọc, tìm kiếm, chi tiết món
│   │   ├── models/
│   │   │   ├── food_model.dart          # Món ăn, FoodOption (size, topping)
│   │   │   └── category_model.dart      # Danh mục món ăn
│   │   ├── cubit/
│   │   │   ├── home_food_cubit.dart     # Quản lý danh sách món trang chủ & lọc theo danh mục
│   │   │   ├── home_food_state.dart
│   │   │   ├── all_foods_cubit.dart     # Quản lý tìm kiếm, bộ lọc sắp xếp ở trang Xem tất cả
│   │   │   └── all_foods_state.dart
│   │   └── presentation/
│   │       ├── home_screen.dart         # Trang chủ Khám phá
│   │       ├── all_foods_screen.dart    # Trang Xem tất cả + Tìm kiếm & Lọc nâng cao
│   │       ├── food_detail_screen.dart  # Trang Chi tiết món ăn (chọn size, topping, ghi chú)
│   │       └── widgets/
│   │           ├── home_header.dart
│   │           ├── home_search_bar.dart
│   │           ├── promo_banner_card.dart
│   │           ├── category_selector.dart
│   │           ├── food_item_card.dart
│   │           └── food_option_selector.dart
│   │
│   ├── cart/                            # 🛒 3. Giỏ hàng & Mã giảm giá
│   │   ├── data/
│   │   │   └── cart_local_datasource.dart # Lưu giỏ hàng xuống máy để tắt app không mất
│   │   ├── models/
│   │   │   ├── cart_item_model.dart     # Món trong giỏ (Food + Size đã chọn + Toppings + Số lượng + Ghi chú)
│   │   │   └── voucher_model.dart       # Thông tin mã giảm giá áp dụng
│   │   ├── cubit/
│   │   │   ├── cart_cubit.dart          # Thêm/xóa món, tăng/giảm số lượng, tính tạm tính, giảm giá, tổng cộng
│   │   │   └── cart_state.dart
│   │   └── presentation/
│   │       ├── cart_screen.dart         # Màn hình giỏ hàng
│   │       └── widgets/
│   │           ├── cart_item_card.dart
│   │           ├── voucher_input_box.dart
│   │           └── cart_summary_bottom_bar.dart
│   │
│   ├── order/                           # 📦 4. Đặt hàng, Thanh toán & Theo dõi đơn
│   │   ├── data/
│   │   │   └── order_repository.dart    # Gọi API tạo đơn hàng, lấy lịch sử đơn, chi tiết đơn
│   │   ├── models/
│   │   │   ├── order_model.dart         # Đơn hàng, trạng thái (pending, preparing, delivering, completed, cancelled)
│   │   │   └── delivery_address_model.dart
│   │   ├── cubit/
│   │   │   ├── checkout_cubit.dart      # Xử lý đặt đơn
│   │   │   ├── order_list_cubit.dart    # Danh sách đơn đang giao & lịch sử đơn
│   │   │   └── order_state.dart
│   │   └── presentation/
│   │       ├── checkout_screen.dart         # Xác nhận địa chỉ, phương thức thanh toán, đặt đơn
│   │       ├── order_history_screen.dart    # Tab Đơn hàng (Đang đến / Lịch sử)
│   │       ├── order_tracking_screen.dart   # Theo dõi tiến trình đơn hàng
│   │       └── widgets/
│   │           ├── address_card.dart
│   │           ├── payment_method_selector.dart
│   │           ├── order_status_stepper.dart
│   │           └── order_history_card.dart
│   │
│   └── profile/                         # 👤 5. Hồ sơ cá nhân & Cài đặt
│       ├── data/
│       │   └── profile_repository.dart  # Cập nhật thông tin, sổ địa chỉ, món yêu thích
│       ├── cubit/
│       │   ├── profile_cubit.dart
│       │   └── profile_state.dart
│       └── presentation/
│           ├── profile_screen.dart          # Tab Tài khoản
│           ├── edit_profile_screen.dart     # Sửa tên, SĐT, ảnh đại diện
│           ├── saved_addresses_screen.dart  # Quản lý sổ địa chỉ nhận hàng
│           └── favorite_foods_screen.dart   # Danh sách món ăn đã thả tim ❤️
│
└── main.dart                            # 🚀 Khởi tạo App, MultiBlocProvider toàn cục & Điều hướng Auto-Login
```

---

## 3. 📏 QUY TẮC CODE CHUẨN (CODING CONVENTIONS & RULES)

### A. Quy tắc Mobile (Flutter)
1. **Tách biệt Giao diện & Logic (Separation of Concerns)**:
   - File trong `presentation/` chỉ lo vẽ UI và lắng nghe state từ `Cubit`.
   - Tuyệt đối không viết trực tiếp code gọi `Dio` (HTTP request) bên trong Widget/Screen; bắt buộc phải đi qua luồng: `Repository` -> `Cubit` -> `Screen`.
2. **Chia nhỏ Widget (`widgets/`)**:
   - Một file màn hình (`*_screen.dart`) không nên dài quá 300 dòng.
   - Các thành phần con (thẻ món ăn, thanh chọn danh mục, banner...) phải tách ra thư mục `presentation/widgets/` của feature đó.
   - Nếu widget dùng chung ở từ 2 feature trở lên (nút bấm chính, ô nhập liệu, ảnh mạng, màn hình trống/lỗi), bắt buộc đặt vào `core/widgets/`.
3. **Không Hardcode Màu sắc, Kiểu chữ & Tiền tệ**:
   - Luôn lấy màu từ `AppColors` (`core/constants/app_colors.dart`) và kiểu chữ từ `AppTextStyles`.
   - Luôn dùng hàm format tiền tệ thống nhất (`55.000đ`), không cộng chuỗi thủ công ở từng màn hình.
4. **Phân quyền State Toàn cục vs Cục bộ (Cubit Scope)**:
   - **State toàn cục** (`AuthCubit`, `CartCubit`, `ProfileCubit`) phải khai báo trong `MultiBlocProvider` ở `main.dart` để dữ liệu (như giỏ hàng, user) giữ nguyên khi chuyển qua lại giữa các màn hình.
   - **State cục bộ** (như tìm kiếm/lọc ở một màn hình riêng) khởi tạo tại màn hình đó để tự giải phóng bộ nhớ khi đóng trang.
5. **Chống lỗi Null & Đồng bộ MongoDB `_id` (Defensive JSON Parsing)**:
   - Mọi hàm `fromJson` trong `models/` bắt buộc phải có giá trị dự phòng (`?? ''`, `?? 0`, `?? []`), ép kiểu số an toàn (`(json['price'] ?? 0).toDouble()`).
   - Luôn đọc ID theo cả 2 chuẩn MongoDB và thường: `json['_id'] ?? json['id'] ?? ''`.

### B. Quy tắc Backend (Node.js / Express)
6. **Chuẩn hóa JSON trả về (API Response Contract)**:
   - Mọi API trả về từ Controller bắt buộc tuân theo cấu trúc thống nhất:
     ```json
     {
       "success": true,
       "message": "Thông báo rõ ràng bằng tiếng Việt",
       "data": { ... }
     }
     ```
   - Nếu là API danh sách có phân trang, bổ sung thêm `total`, `page`, `totalPages`.
7. **Bảo mật & Biến môi trường**:
   - Không bao giờ hardcode chuỗi kết nối `MONGO_URI`, `JWT_SECRET` trong code; bắt buộc lấy từ `process.env`.
   - Các API liên quan đến thông tin cá nhân, giỏ hàng, đặt đơn hàng bắt buộc phải gắn `authMiddleware`.

### C. Quy tắc Đặt tên & An toàn Hệ thống
8. **Quy ước đặt tên file (Naming Conventions)**:
   - **Flutter (`mobile/`)**: Tất cả tên file và thư mục dùng `snake_case.dart` (VD: `food_detail_screen.dart`), tên Class dùng `PascalCase` (`FoodDetailScreen`), biến và hàm dùng `camelCase`.
   - **Backend (`backend/`)**: File trong `models/` dùng `PascalCase.js` (`Food.js`, `Order.js`); các file trong `controllers/`, `routes/`, `middlewares/`, `services/` dùng `camelCase.js` (`foodController.js`, `foodRoutes.js`).
9. **An toàn mạng & Xử lý lỗi (Error Handling)**:
   - Luôn có đủ trạng thái `Loading`, `Loaded`, `Error` rõ ràng trên UI.
   - Luôn bọc `try/catch` ở cả Backend Controller và Mobile Repository để ứng dụng không bao giờ bị văng (crash) khi mất mạng hoặc khi server Render đang khởi động lại.
