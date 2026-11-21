# Quy tắc bắt buộc cho AI Agent (Project Rules)

Khi hỗ trợ viết code, thêm tính năng, hoặc chỉnh sửa bất kỳ file nào trong dự án **Order Food** (`backend/` và `mobile/`), bạn **BẮT BUỘC** phải đọc và tuân thủ tuyệt đối kiến trúc thư mục, luồng dữ liệu và quy ước code được định nghĩa trong [ARCHITECTURE.md](./ARCHITECTURE.md) dưới đây:

@[ARCHITECTURE.md](./ARCHITECTURE.md)

## Quy trình bắt buộc trước khi tạo hoặc sửa file:
1. **Kiểm tra đúng vị trí thư mục**: Đối chiếu đường dẫn file sắp tạo với cây thư mục trong `ARCHITECTURE.md` (ví dụ: không đặt nhầm `models`, `data`, `cubit`, `presentation/widgets/`, hoặc `core/`).
2. **Tái sử dụng `core/`**: Luôn kiểm tra và sử dụng màu sắc từ `core/constants/app_colors.dart`, kết nối mạng từ `core/network/api_client.dart`, và các widget/tiện ích dùng chung trong `core/`.
3. **Cập nhật tài liệu**: Nếu người dùng yêu cầu thêm một module/feature hoàn toàn mới chưa có trong `ARCHITECTURE.md`, hãy cập nhật bổ sung vào `ARCHITECTURE.md` để tài liệu luôn đồng bộ với code thực tế.
