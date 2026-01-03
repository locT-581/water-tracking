Đây là **SmartHydro System Blueprint (v1.0)**. Tài liệu này đóng vai trò là "Hiến pháp" của dự án. Mọi quyết định về thiết kế (Design), lập trình (Dev), và nội dung (Content) sau này đều phải chiếu theo tài liệu này để đảm bảo tính nhất quán.

---

# 📘 SMARTHYDRO SYSTEM BLUEPRINT

**Version:** 1.0
**Status:** Foundation
**Tech Stack:** Flutter (Mobile) | Next.js (Web Admin/Blog) | Supabase (Backend/DB)

---

## 1. Core Purpose & Mission

* **Core Purpose:** Chuyển đổi việc uống nước từ một hành động sinh tồn vô thức thành một thói quen khoa học, thú vị và được cá nhân hóa sâu sắc.
* **Mission:** Cung cấp giải pháp hydrat hóa chính xác nhất (Biological Accuracy) nhưng với trải nghiệm ít ma sát nhất (Zero-Friction), giúp người dùng khỏe mạnh mà không cảm thấy bị áp lực.
* **Slogan:** "Hydration tuned to your biology."

---

## 2. Philosophy

### 2.1. Product Philosophy: "Adaptive & Empathic"

* **Adaptive (Thích ứng):** App không bao giờ tĩnh. Mục tiêu nước thay đổi theo thời tiết và vận động. Không bắt người dùng tuân theo con số chết cứng.
* **Empathic (Thấu cảm):** App hiểu ngữ cảnh. Không làm phiền khi người dùng đang ngủ hoặc vừa mới uống. Không trách móc khi người dùng quên, chỉ khích lệ.

### 2.2. Design Philosophy: "Fluid & Organic"

* **Fluidity (Sự trôi chảy):** Mọi chuyển động trong app phải mượt mà như nước. Tránh các cạnh sắc nhọn, sử dụng đường cong (border-radius lớn).
* **Clarity (Sự trong suốt):** Thông tin hiển thị phải trong trẻo, dễ đọc, không rườm rà, giống như một ly nước tinh khiết.

---

## 3. UX Patterns & Navigation Model

### 3.1. Mobile App (Flutter)

* **Navigation Structure:** Bottom Navigation Bar (3-4 tabs).
* `Home` (Dashboard, Quick Log, Character).
* `Analysis` (Charts, History).
* `Science` (Blog/Knowledge Cards).
* `Settings` (Profile, Reminders).


* **Primary Action (FAB/Widget):** "Quick Log" phải luôn truy cập được trong vòng 1 giây. Sử dụng gesture "Swipe up" hoặc "Long press" để log nhanh các lượng nước preset.
* **Onboarding Pattern:** Progressive Disclosure (Tiết lộ dần dần). Chỉ hỏi những gì cần thiết nhất để tính công thức ban đầu.

### 3.2. Web Admin (Next.js)

* **Structure:** Sidebar Dashboard (Left panel fixed).
* **Focus:** Soạn thảo nội dung (Rich Text Editor) và Quản trị dữ liệu user (Data Grid).

---

## 4. UI Visual System

Xem chi tiết ở file [VISUAL_DESIGN](VISUAL_DESIGN.md)
---

## 5. Interaction Principles

* **Feedback Loop:** Mọi hành động `Tap` đều phải có phản hồi tức thì (Visual hoặc Haptic).
* **Forgiveness:** Cho phép `Undo` (Hoàn tác) nhanh nếu lỡ log nhầm (trong vòng 5s).
* **Context Awareness:** Nếu trời nóng, app tự động đổi background sang tông màu nắng hoặc hiện icon mặt trời để báo hiệu mục tiêu đã tăng.

---

## 6. Tone & Microcopy Rules

* **Tone:** Thông minh, Dí dỏm, Khoa học nhưng Bình dân.
* **Do & Don't:**
* *Don't:* "Lỗi! Bạn chưa uống nước." (Cứng nhắc).
* *Do:* "Cây của bạn đang khát kìa, tưới cho nó một chút nhé!" (Ẩn dụ).
* *Don't:* "Uống 200ml."
* *Do:* "Nạp 200ml." hoặc "Tự thưởng 1 cốc."


* **Scientific Terms:** Khi dùng thuật ngữ (như Electrolytes/Điện giải), luôn có tooltips hoặc link giải thích ngắn gọn.

---

## 7. Modules & Feature Groups

1. **Hydration Engine (Core Logic - Dart):**
* Input: Profile + Weather API + HealthKit.
* Process: Tính toán  và  (dựa trên BHI).


2. **Smart Logger (Input):**
* Widget, In-app logger, Voice input (Future).


3. **Mascot Collection System (Gamification):**
* **Đa dạng hóa:** Không chỉ 1 mascot duy nhất, mà là hệ sinh thái mascots với tính cách riêng
* **Personalization:** User chọn mascot yêu thích, tạo emotional attachment mạnh mẽ
* **Extensibility:** Kiến trúc Registry + Factory Pattern để dễ dàng thêm mascots mới
* **Unlock Mechanics:** Mascots được unlock qua streaks, challenges, seasons, hoặc premium
* **Render Engine:** 3D-style rendering với Phong lighting, subsurface scattering, jelly physics
* **State Management:** Mỗi mascot có 5+ states (Hydrated, Thirsty, Dehydrated, etc.)
* **Personality System:** Mỗi mascot có quotes, reactions, animations riêng biệt
* **Gallery UI:** User-friendly interface để browse, preview, và switch mascots
* **Progression:** Mascots có thể "lớn lên" theo thời gian sử dụng (future feature)


4. **Notification Manager (System):**
* Scheduler (Lên lịch), Silent Period logic.


5. **Science Hub (Content - Next.js Source):**
* CMS, API fetcher, Article Reader UI.



---

## 8. Scope, Boundaries & Non-negotiables

* **In Scope:** Theo dõi nước, caffeine, cồn. Widget iOS/Android. Blog sức khỏe.
* **Out of Scope (v1.0):** Theo dõi Calo đồ ăn. Mạng xã hội/Chat. Bác sĩ tư vấn trực tiếp.
* **Non-negotiables (Bắt buộc):**
* App phải mở được trong < 1.5 giây.
* Chức năng Log nước phải hoạt động Offline 100%.
* Không được spam thông báo (Max 8 noti/ngày).



---

## 9. User Roles & Flow Principles

* **Roles:**
  * *User (Mobile):* Người uống nước.
  * *Guest User:* Người dùng thử, chưa đăng nhập, data lưu local.
  * *Editor (Web):* Người viết bài blog.
  * *Admin (Supabase):* Quản lý hệ thống.

* **Guest Mode Flow:**
  1. Splash Screen → Login Screen
  2. User chọn "Dùng thử ngay" (không bắt buộc đăng nhập)
  3. Onboarding (thu thập info cơ bản)
  4. Home Screen với banner nhắc liên kết tài khoản
  5. Sau 3 ngày: Dialog nhắc nhở backup data

* **Golden Flow Principle:** "1-Tap Logging". Giảm thiểu số bước để log nước xuống mức tối thiểu. Từ lúc mở khóa màn hình đến lúc log xong không quá 3 giây.

---

## 10. Quality Bar & Constraints

* **Code Quality:** Tuân thủ Clean Architecture (Flutter) và Component-based (Next.js). Tách biệt UI và Logic.
* **UI Consistency:** Tất cả icon phải cùng một bộ (Outline hoặc Filled, bo tròn). Không dùng icon tạp nham.
* **Testing:** Unit test cho Hydration Engine là bắt buộc (vì liên quan sức khỏe).

---

## 11. AI Generation Guidelines (Prompting Rules)

*Khi yêu cầu AI tạo màn hình hoặc code sau này, hãy bắt buộc tuân theo format này:*

> **"SYSTEM INSTRUCTION: You are acting as the Lead Developer/Designer for the SmartHydro project. Refer strictly to the SmartHydro Blueprint v1.0. Use Flutter for Mobile, Next.js for Web, Supabase for Backend. Colors must match the defined Palette. Typography is Rounded Sans. Focus on 'Fluid & Organic' design philosophy."**

---

## 12. Output Format Definition (Standard Screen Spec)

*Mỗi khi định nghĩa một màn hình mới, sử dụng cấu trúc này:*

**[SCREEN NAME]**

* **Route:** `/route_name`
* **Purpose:** (Mục đích chính của màn hình này là gì?)
* **State Management:** (Dữ liệu nào cần theo dõi? Ví dụ: `waterLevel`, `isLoading`)
* **UI Components:**
* *Header:*...
* *Body:*...
* *Footer/FAB:*...


* **Logic & Interactions:**
* *On Load:* (Gọi API nào? Lấy data local nào?)
* *On Action:* (Điều gì xảy ra khi user bấm nút?)


* **Visual Style:** (Màu sắc chủ đạo, animation đặc biệt nếu có)
* **Supabase Query:** (Câu lệnh SQL/API cần thiết)

---

*Tài liệu này được phê duyệt để làm cơ sở phát triển cho SmartHydro.*