Hãy hướng dẫn chi tiết cách tích hợp AWS Cognito vào ứng dụng viết bằng Flutter để cho nhiều người dùng. Ứng dụng hướng đến việc cho phép mỗi người dùng có thể quản lý các thiết bị IoT của họ. Cụ thể:
1. Cách tạo và cấu hình một User Pool, App Client, Domain trong AWS Cognito.
2. Ví dụ code bằng Flutter để:
  - Đăng ký tài khoản mới (Sign Up)
  - Xác thực tài khoản (Confirm Sign Up)
  - Đăng nhập (Sign In)
  - Refresh token và quản lý phiên đăng nhập
  - Đăng xuất (Sign Out)
  - ... cùng với chi tiết các use case gợi ý trong khối mã markdown:
```md
## **5.2 Use Case Details**
Chi tiết các trường hợp sử dụng chính của hệ thống **RBC Smart AIoT** được mô tả dưới đây.

### **5.2.1 Quản lý tài khoản**
#### **UC-01: Người dùng đăng nhập vào ứng dụng**
- **Mô tả:** Người dùng cung cấp email và mật khẩu để truy cập hệ thống.
- **Tác nhân chính:** Người dùng.
- **Điều kiện tiên quyết:**
  - Người dùng đã có tài khoản trong hệ thống.
  - Email và mật khẩu hợp lệ.
- **Luồng công việc chính:**
  1. Người dùng mở ứng dụng và nhập email cùng mật khẩu.
  2. Hệ thống gửi yêu cầu xác thực tới AWS Cognito.
  3. AWS Cognito xác nhận thông tin và trả về token truy cập.
  4. Hệ thống hiển thị giao diện chính của ứng dụng.
- **Luồng công việc phụ:**
  - Người dùng chưa có tài khoản → Chuyển đến UC-02.
  - Người dùng quên mật khẩu → Chuyển đến UC-04.
- **Luồng ngoại lệ:**
  - Email hoặc mật khẩu không chính xác → Hiển thị thông báo lỗi.
  - Tài khoản bị khóa → Hiển thị thông báo và hướng dẫn liên hệ hỗ trợ.
- **Kết quả mong đợi:**
  - Người dùng được đăng nhập thành công và chuyển đến giao diện chính.

---

#### **UC-02: Người dùng đăng ký tài khoản mới**
- **Mô tả:** Người dùng cung cấp thông tin để tạo tài khoản mới.
- **Tác nhân chính:** Người dùng.
- **Điều kiện tiên quyết:** 
  - Người dùng chưa có tài khoản với email cung cấp.
- **Luồng công việc chính:**
  1. Người dùng chọn "Đăng ký" trên giao diện ứng dụng.
  2. Nhập các thông tin: email, mật khẩu, số điện thoại.
  3. Hệ thống gửi mã OTP qua email/số điện thoại.
  4. Người dùng nhập mã OTP để xác minh.
  5. Hệ thống tạo tài khoản trên AWS Cognito và lưu thông tin cơ bản vào DynamoDB.
  6. Hiển thị thông báo thành công.
- **Luồng công việc phụ:**
  - Người dùng đã có tài khoản → Chuyển đến UC-01.
- **Luồng ngoại lệ:**
  - Email đã tồn tại → Hiển thị thông báo lỗi.
  - Mã OTP không chính xác → Yêu cầu nhập lại mã OTP.
- **Kết quả mong đợi:**
  - Người dùng đăng ký tài khoản thành công và được chuyển đến màn hình đăng nhập.

---

#### **UC-03: Người dùng thay đổi mật khẩu**
- **Mô tả:** Người dùng có thể thay đổi mật khẩu hiện tại của mình.
- **Tác nhân chính:** Người dùng.
- **Điều kiện tiên quyết:**
  - Người dùng đã đăng nhập vào hệ thống.
- **Luồng công việc chính:**
  1. Người dùng chọn "Thay đổi mật khẩu" trong menu cài đặt.
  2. Nhập mật khẩu cũ và mật khẩu mới.
  3. Hệ thống gửi yêu cầu thay đổi mật khẩu tới AWS Cognito.
  4. AWS Cognito xác nhận mật khẩu cũ và cập nhật mật khẩu mới.
  5. Hiển thị thông báo thành công.
- **Luồng công việc phụ:** 
  - Người dùng quên mật khẩu → Chuyển đến UC-04.
- **Luồng ngoại lệ:**
  - Mật khẩu cũ không chính xác → Hiển thị thông báo lỗi.
- **Kết quả mong đợi:**
  - Người dùng cập nhật mật khẩu thành công.

---

#### **UC-04: Người dùng quên mật khẩu**
- **Mô tả:** Người dùng yêu cầu đặt lại mật khẩu qua email xác nhận.
- **Tác nhân chính:** Người dùng.
- **Điều kiện tiên quyết:**
  - Người dùng đã đăng ký tài khoản.
- **Luồng công việc chính:**
  1. Người dùng chọn "Quên mật khẩu
  2. Nhập email đã đăng ký.
  3. Hệ thống gửi mã OTP qua email.
  4. Người dùng nhập mã OTP và mật khẩu mới.
  5. Hệ thống cập nhật mật khẩu mới trong Cognito.
  6. Hiển thị thông báo thành công.
- **Luồng công việc phụ:**
  - Người dùng muốn thay đổi mật khẩu → Chuyển đến UC-03.
- **Luồng ngoại lệ:**
  - Email không tồn tại → Hiển thị thông báo lỗi.
  - Mã OTP không chính xác → Yêu cầu nhập lại mã OTP.
- **Kết quả mong đợi:**
  - Người dùng cập nhật mật khẩu thành công.

---

#### **UC-05: Người dùng cập nhật thông tin cá nhân**
- **Mô tả:** Người dùng cập nhật thông tin cá nhân như tên, số điện thoại, và địa chỉ.
- **Tác nhân chính:** Người dùng.
- **Điều kiện tiên quyết:**
  - Người dùng đã đăng nhập vào hệ thống.
- **Luồng công việc chính:**
  1. Người dùng chọn "Cập nhật thông tin" trong menu cài đặt.
  2. Nhập thông tin mới: tên, số điện thoại, địa chỉ.
  3. Hệ thống cập nhật thông tin vào DynamoDB.
  4. Hiển thị thông báo thành công.
- **Luồng công việc phụ:** 
  - Người dùng muốn thay đổi mật khẩu → Chuyển đến UC-03.
- **Luồng ngoại lệ:**
  - Thông tin không hợp lệ → Hiển thị thông báo lỗi.
- **Kết quả mong đợi:**
  - Thông tin cá nhân được cập nhật thành công.

---

#### **UC-06: Người dùng đăng xuất khỏi ứng dụng**
- **Mô tả:** Người dùng đăng xuất khỏi hệ thống và chuyển về man hình đăng nhập.
- **Tác nhân chính:** Người dùng.
- **Điều kiện tiên quyết:**
  - Người dùng đã đăng nhập vào hệ thống.
- **Luồng công việc chính:**
  1. Người dùng chọn "Đăng xuất" trong menu cài đặt.
  2. Hệ thống xác nhận yêu cầu và xóa token truy cập.
  3. Hiển thị thông báo đăng xuất thành công.
  4. Chuyển về màn hình đăng nhập.
- **Luồng công việc phụ:**
  - Người dùng không muốn đăng xuất
- **Luồng ngoại lệ:**
  - Lỗi hệ thống → Hiển thị thông báo lỗi.
- **Kết quả mong đợi:**
  - Người dùng đăng xuất khỏi hệ thống và chuyển về màn hình đăng nhập.

---
```
3. Hướng dẫn cách bảo vệ các route/endpoint trong ứng dụng (bằng token hoặc session).
4. Các best practices liên quan đến bảo mật, cấu hình nâng cao (MFA, Email/SMS Verification…), và quản lý người dùng trong AWS Cognito.
5. Nếu có thể, đưa ra một số lưu ý về chi phí, giới hạn dịch vụ và cách tối ưu.