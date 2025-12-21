# TÀI LIỆU ĐẶC TẢ YÊU CẦU PHẦN MỀM (SRS)

**Tên dự án:** SmartHydro - Ứng dụng Theo dõi & Tối ưu Hóa Việc Uống Nước
**Phiên bản:** 1.1
**Ngày lập:** 21/12/2025
**Cập nhật lần cuối:** 21/12/2025

---

## 1. GIỚI THIỆU (INTRODUCTION)

### 1.1. Mục đích

Xây dựng ứng dụng di động (iOS/Android) không chỉ theo dõi lượng nước uống mà còn đóng vai trò là trợ lý sức khỏe, tự động điều chỉnh mục tiêu dựa trên sinh học và môi trường, đồng thời giáo dục người dùng thông qua các kiến thức khoa học chuẩn xác.

### 1.2. Phạm vi sản phẩm

* Tính toán mục tiêu nước động (Dynamic Goal).
* Ghi chép nước thông minh với chỉ số hấp thụ (Hydration Score).
* Hệ thống nhắc nhở thích ứng hành vi.
* Cổng thông tin khoa học (Science Hub).
* Gamification (Trò chơi hóa) với nhân vật ảo.

### 1.3. Định nghĩa & Thuật ngữ

| Thuật ngữ | Định nghĩa |
|-----------|------------|
| **BHI** | Beverage Hydration Index - Chỉ số đo khả năng hydrat hóa thực tế của đồ uống |
| **Dynamic Goal** | Mục tiêu nước thay đổi theo thời gian thực dựa trên các yếu tố môi trường |
| **Silent Period** | Khoảng thời gian tạm dừng nhắc nhở sau khi user đã uống nước |
| **Streak** | Chuỗi ngày liên tiếp đạt mục tiêu uống nước |
| **Buddy** | Nhân vật ảo đồng hành phản ánh trạng thái hydration của user |

---

## 2. MÔ TẢ TỔNG QUAN (OVERALL DESCRIPTION)

### 2.1. Chân dung người dùng (User Personas)

| Persona | Đặc điểm | Nhu cầu chính |
|---------|----------|---------------|
| **Người làm văn phòng** | Ít vận động, hay quên uống nước | Nhắc nhở tinh tế không làm phiền, tracking đơn giản |
| **Người tập thể thao** | Hoạt động cường độ cao, mất nước nhiều | Bù nước chính xác dựa trên lượng mồ hôi/calo tiêu thụ |
| **Người quan tâm sức khỏe** | Muốn hiểu cơ sở khoa học | Thông tin BHI chi tiết, kiến thức dinh dưỡng |
| **Phụ nữ mang thai/cho con bú** | Nhu cầu nước tăng cao | Mục tiêu điều chỉnh theo trạng thái sinh học |

### 2.2. Các giả định và phụ thuộc

* **Quyền truy cập cần thiết:**
  * Dữ liệu sức khỏe (Apple Health/Google Fit)
  * Vị trí (để lấy dữ liệu Thời tiết)
  * Thông báo (Push Notification)

* **Kết nối mạng:**
  * Cần Internet để cập nhật thời tiết và đồng bộ Cloud
  * Các tính năng cơ bản (log nước, xem tiến độ) phải hoạt động **Offline**

---

## 3. YÊU CẦU CHỨC NĂNG (FUNCTIONAL REQUIREMENTS)

### 3.1. Module Onboarding & Thiết lập hồ sơ

Hệ thống phải thu thập các chỉ số đầu vào để khởi chạy thuật toán gốc.

#### 3.1.1. Input Fields

| Field | Kiểu dữ liệu | Bắt buộc | Ghi chú |
|-------|--------------|----------|---------|
| Giới tính | Enum (Nam/Nữ) | ✅ | |
| Năm sinh | Year | ✅ | Để tính tuổi |
| Cân nặng | Float (kg/lbs) | ✅ | Hỗ trợ chuyển đổi đơn vị |
| Chiều cao | Float (cm/ft) | ❌ | Để tính BMI phụ trợ |
| Giờ thức dậy | Time | ✅ | Default: 07:00 |
| Giờ đi ngủ | Time | ✅ | Default: 23:00 |
| Mang thai | Boolean | ❌ | Chỉ hiện nếu Giới tính = Nữ |
| Đang cho con bú | Boolean | ❌ | Chỉ hiện nếu Giới tính = Nữ |

#### 3.1.2. Output

* Hiển thị "Mục tiêu cơ bản trong ngày" ngay lập tức sau khi hoàn thành onboarding
* Animation giải thích cách tính mục tiêu (educational)

---

### 3.2. Module Thuật toán cốt lõi & Mục tiêu động (Core Algorithm)

Đây là "bộ não" của ứng dụng, xử lý tự động không cần user can thiệp.

#### 3.2.1. Công thức nền (Base Calculation)

Sử dụng công thức điều chỉnh theo lứa tuổi và cân nặng (W tính bằng kg):

| Độ tuổi | Công thức | Ví dụ (70kg) |
|---------|-----------|--------------|
| Dưới 30 tuổi | `Goal_base = W × 40` (ml) | 2800ml |
| 30 - 55 tuổi | `Goal_base = W × 35` (ml) | 2450ml |
| Trên 55 tuổi | `Goal_base = W × 30` (ml) | 2100ml |

#### 3.2.2. Biến số điều chỉnh (Dynamic Adjustments)

Hệ thống tự động cộng dồn vào `Goal_base` theo thời gian thực:

**1. Thời tiết (Weather API):**

| Điều kiện | Điều chỉnh | Logic |
|-----------|------------|-------|
| Nhiệt độ > 30°C | +10% của Goal_base | Cơ thể mất nước qua mồ hôi |
| Nhiệt độ > 35°C | +15% của Goal_base | Nguy cơ mất nước cao |
| Độ ẩm < 40% (Hanh khô) | +5% của Goal_base | Da và hô hấp mất nước nhanh hơn |

*Ví dụ: Nếu Goal_base = 2500ml, nhiệt độ 36°C → Cộng thêm 375ml → Tổng = 2875ml*

**2. Vận động (HealthKit/Google Fit API):**

| Loại vận động | Thời gian | Điều chỉnh |
|---------------|-----------|------------|
| Cường độ trung bình (đi bộ nhanh, yoga) | 30 phút | +250ml |
| Cường độ cao (chạy, gym, bơi) | 30 phút | +350ml |
| Cường độ rất cao (HIIT, marathon) | 30 phút | +500ml |

**3. Trạng thái sinh học (User setting):**

| Trạng thái | Điều chỉnh | Cơ sở khoa học |
|------------|------------|----------------|
| Mang thai | +300ml cố định | Tăng thể tích máu, nước ối |
| Cho con bú | +500ml cố định | Sản xuất sữa cần nhiều nước |

#### 3.2.3. Công thức tổng hợp

```
Goal_final = Goal_base 
           + Weather_adjustment 
           + Activity_adjustment 
           + Biology_adjustment
```

#### 3.2.4. Thông báo điều chỉnh mục tiêu

Khi mục tiêu thay đổi, hiển thị thông báo friendly:

* **Thời tiết nóng:** *"Hôm nay trời đổ lửa 🔥, mình đã thêm 1 cốc nước vào mục tiêu giúp bạn không bị mệt nhé!"*
* **Sau vận động:** *"Tuyệt vời! Bạn vừa đốt cháy 300 calo 💪 Uống thêm 350ml để bù khoáng nào!"*

---

### 3.3. Module Ghi chép thông minh (Smart Logging)

Khắc phục nhược điểm "mọi loại nước đều như nhau".

#### 3.3.1. Danh mục đồ uống & Chỉ số Hydrat hóa (BHI)

| Loại đồ uống | BHI | Tính toán | Ghi chú UI |
|--------------|-----|-----------|------------|
| Nước lọc | 1.00 | 100ml → 100ml | *(mặc định)* |
| Nước có gas | 0.95 | 100ml → 95ml | |
| Sữa tươi | 1.10 | 100ml → 110ml | "Tốt cho hydration!" |
| Nước dừa | 1.15 | 100ml → 115ml | "Điện giải tự nhiên!" |
| Trà (không đường) | 0.90 | 100ml → 90ml | |
| Cà phê | 0.85 | 100ml → 85ml | "Nhớ uống thêm nước lọc nhé" |
| Nước ngọt | 0.70 | 100ml → 70ml | "Đường cao, hạn chế nhé" |
| Nước ép trái cây | 0.80 | 100ml → 80ml | |
| Rượu/Bia | 0.50 | 100ml → 50ml | ⚠️ "Gây mất nước!" |
| Nước tăng lực | 0.60 | 100ml → 60ml | ⚠️ "Caffeine cao" |

#### 3.3.2. Chức năng Quick Add

**Widget màn hình chính:**
* Preset buttons: 150ml | 250ml | 500ml
* Custom input: Nhập số ml tùy ý
* Beverage picker: Chọn loại đồ uống (icon-based)

**Voice Log (Phase 4):**
* Siri: *"Hey Siri, log 250ml water"*
* Google Assistant: *"Hey Google, I drank coffee"*

**NFC Tag (Phase 4):**
* Chạm điện thoại vào sticker NFC trên bình nước
* Auto-log với dung tích đã cài đặt

#### 3.3.3. Feedback sau khi log

Hiển thị ngay lập tức:
* Animation nước đổ vào (satisfying)
* Progress ring update
* Buddy reaction (vui/buồn tùy % hoàn thành)
* Tip ngắn nếu đồ uống có BHI thấp: *"Cà phê làm bạn mất nước nhẹ, nhớ uống thêm ngụm nước lọc tráng miệng nhé."*

---

### 3.4. Module Nhắc nhở thông minh (Smart Notification System)

#### 3.4.1. Logic phân chia thời gian

```
Hourly_goal = Goal_final / (Bedtime - Wake_time)

Ví dụ: 2400ml / 16 giờ = 150ml/giờ
```

#### 3.4.2. Cơ chế "Silent Period" (Chống làm phiền)

| Trigger | Hành động |
|---------|-----------|
| User vừa log nước | Tắt nhắc nhở trong **90 phút** tiếp theo |
| Trong giờ ngủ (Bedtime → Wake_time) | **Không nhắc** |
| User đã đạt 100% mục tiêu | Chỉ nhắc nếu có thêm vận động |

#### 3.4.3. Context-aware Messages

Kết hợp dữ liệu từ HealthKit để tạo thông báo phù hợp ngữ cảnh:

| Context | Trigger | Message mẫu |
|---------|---------|-------------|
| Sedentary | Ngồi > 2 tiếng liên tục | *"Bạn đã ngồi làm việc 2 tiếng rồi, đứng dậy vươn vai và làm ngụm nước nào!"* |
| Morning | 30 phút sau Wake_time | *"Chào buổi sáng! Một cốc nước ấm giúp đánh thức cơ thể nhé 🌅"* |
| Post-workout | 15 phút sau kết thúc vận động | *"Workout xong rồi! Bù nước ngay để cơ bắp phục hồi nhanh 💪"* |
| Hot weather | Nhiệt độ > 32°C | *"Trời nóng quá! Đừng để cơ thể khát mới uống nhé 🌡️"* |
| Evening | 2 tiếng trước Bedtime | *"Sắp đến giờ ngủ rồi, uống nhẹ để không phải dậy giữa đêm nhé 🌙"* |

#### 3.4.4. Notification Template Engine

**Cấu trúc template:**
```json
{
  "id": "reminder_sedentary_01",
  "category": "sedentary",
  "mood": "friendly",
  "time_of_day": "any",
  "template": "Bạn đã ngồi {sedentary_minutes} phút rồi, {name}! Đứng dậy làm ngụm nước nào 💧",
  "placeholders": ["sedentary_minutes", "name"]
}
```

**Placeholders hỗ trợ:**
* `{name}` - Tên user
* `{remaining_ml}` - Lượng nước còn thiếu
* `{streak_count}` - Số ngày streak hiện tại
* `{sedentary_minutes}` - Thời gian ngồi liên tục
* `{buddy_name}` - Tên nhân vật Buddy

**Yêu cầu:**
* Lưu trữ **50+ mẫu câu** trong database
* Randomize trong cùng category để tránh nhàm chán
* Hỗ trợ đa ngôn ngữ (i18n)

---

### 3.5. Module "Science Hub" (Cơ sở khoa học & Blog)

Thiết kế dạng thẻ bài (Cards) vuốt ngang hoặc Feed (như News).

#### 3.5.1. Cấu trúc dữ liệu bài viết

| Field | Kiểu | Mô tả |
|-------|------|-------|
| title | String | Tiêu đề hấp dẫn |
| summary | String (max 100 chars) | Tóm tắt 2 dòng |
| content_html | Rich Text | Nội dung chi tiết (hình ảnh, bold, italic) |
| thumbnail_url | URL | Ảnh đại diện |
| category | Enum | Phân loại bài viết |
| medical_sources | Array[String] | Nguồn trích dẫn khoa học |
| read_time_minutes | Int | Thời gian đọc ước tính |

#### 3.5.2. Danh mục bài viết

* 💧 Kiến thức cơ bản
* 🥗 Dinh dưỡng & Hydration
* ⚖️ Giảm cân & Detox
* 🫘 Thận & Hệ tiết niệu
* 🏃 Thể thao & Vận động
* 🤰 Mang thai & Cho con bú

#### 3.5.3. Tính năng

* **"Fact of the day"**: Hiển thị 1 fact ngắn tại Dashboard mỗi ngày
* **Bookmarks**: Lưu bài viết yêu thích
* **Share**: Chia sẻ qua social media
* **Related articles**: Gợi ý bài viết liên quan

---

### 3.6. Module Gamification & Visual (Giao diện trực quan)

#### 3.6.1. Hệ thống Mascot đa dạng (Mascot Collection System)

**🎭 Tính năng Chọn & Thay đổi Mascot**

SmartHydro không chỉ có 1 mascot duy nhất mà là **"Water Creature Universe"** với nhiều mascots khác nhau:

**Yêu cầu:**
* User có thể **chọn mascot yêu thích** từ Gallery
* User có thể **thay đổi mascot bất cứ lúc nào** trong Settings
* Mỗi mascot có **tính cách riêng** (personality, quotes, animations)
* Mascots được **unlock** qua streaks, challenges, hoặc premium IAP
* Hệ thống phải **dễ mở rộng** để thêm mascots mới sau này

**Launch Mascots (3 options):**

| Mascot | Rarity | Unlock | Personality | Best for |
|--------|--------|--------|-------------|----------|
| **Aqua-Axo** 🦎 | Common | Default | Vui vẻ, hài hước | Mọi user |
| **Celestial Drop** 🌟 | Rare | 7-day streak | Sang trọng, mơ mộng | Users thích nghệ thuật |
| **Liquid Chibi-Bot** 💎 | Epic | Connect Health app | Thông minh, hiệu quả | Users yêu công nghệ |

**Future Mascots (Wave 2+):**

| Mascot | Rarity | Unlock | Description |
|--------|--------|--------|-------------|
| **Coral Guardian** 🪸 | Rare | 30-day streak | Hình san hô, quan tâm sâu sắc |
| **Glacier Spirit** ❄️ | Uncommon | Seasonal (Winter) | Tinh thể băng, thanh tịnh |
| **Lava Drop** 🔥 | Epic | Summer Event | Năng động, nhiệt huyết |
| **Royal Aquamarine** 👑 | Legendary | Premium IAP | Vương miện kim cương, exclusive |

**Trạng thái Mascot (áp dụng cho tất cả):**

| % Mục tiêu | Trạng thái | Visual (chung) |
|------------|------------|----------------|
| 0-25% | Dehydrated | Xẹp, nhăn nheo, màu xám |
| 25-50% | Thirsty | Mệt mỏi, màu nhạt |
| 50-75% | Okay | Trung lập, màu bình thường |
| 75-99% | Good | Cười, màu tươi sáng |
| 100%+ | Hydrated | Phát sáng, nhảy múa, hiệu ứng đặc biệt |

**Mascot Gallery UI:**
* **Vị trí:** Settings → "My Mascot Collection"
* **Layout:** Grid 2 cột, hiển thị cả locked & unlocked
* **Locked mascots:** Hiển thị silhouette + unlock condition
* **Tap mascot:** Xem chi tiết + Set as Active
* **Filters:** All / Unlocked / Rarity / Seasonal

**Tiến hóa & Rewards:**

| Milestone | Reward |
|-----------|--------|
| Streak 7 ngày | Unlock Celestial Drop mascot |
| Streak 30 ngày | Unlock Coral Guardian mascot |
| Streak 100 ngày | Unlock Tsunami Titan (Legendary) |
| Connect Health App | Unlock Liquid Chibi-Bot mascot |
| Hoàn thành Challenge | Badge đặc biệt + Seasonal mascot |
| 1000ml đầu tiên | Achievement "First Drop" |
| Unlock 5 mascots | Achievement "Collector" |
| Unlock All mascots | Achievement "Completionist" |

#### 3.6.2. Chế độ Challenge (Thử thách)

| Challenge | Thời gian | Mục tiêu | Reward |
|-----------|-----------|----------|--------|
| Detox Challenge | 7 ngày | Uống đủ 100% mỗi ngày | Badge "Detox Master" |
| Summer Challenge | 14 ngày | Uống đủ trong mùa hè | Skin "Sunny Buddy" |
| Consistency King | 30 ngày | Streak không gián đoạn | Buddy mới "Golden Drop" |
| Team Challenge (Phase 3) | 7 ngày | So sánh với bạn bè | Leaderboard position |

#### 3.6.3. Biểu đồ & Thống kê

* **Daily Progress Ring**: Vòng tròn tiến độ theo ngày
* **Weekly Line Chart**: So sánh mục tiêu vs thực tế theo tuần
* **Beverage Breakdown**: Pie chart % các loại đồ uống
* **Streak Calendar**: Heatmap theo tháng (như GitHub contributions)
* **Monthly Report**: Tổng hợp tháng với insights

---

## 4. YÊU CẦU PHI CHỨC NĂNG (NON-FUNCTIONAL REQUIREMENTS)

### 4.1. Hiệu năng (Performance)

| Metric | Yêu cầu |
|--------|---------|
| Cold start | < 2 giây |
| Log nước | Instant feedback (< 100ms) |
| Sync data | Background, không block UI |
| Animation | 60fps, không giật lag |

### 4.2. Khả năng sử dụng (Usability)

* Giao diện hỗ trợ **Dark Mode** (tự động theo hệ thống)
* Số thao tác tối đa để log nước: **1 chạm** (qua Widget) hoặc **2 chạm** (trong App)
* Hỗ trợ **Haptic feedback** khi log thành công
* Font size có thể điều chỉnh (Accessibility)

### 4.3. Bảo mật & Riêng tư (Security & Privacy)

* Dữ liệu sức khỏe cá nhân được **mã hóa cục bộ** (AES-256)
* Tuân thủ **GDPR** (EU) và **CCPA** (California)
* Quyền xóa toàn bộ dữ liệu (Right to be forgotten)
* Không bán dữ liệu cho bên thứ 3

### 4.4. Offline & Data Synchronization

#### 4.4.1. Offline Capabilities

| Tính năng | Offline Support |
|-----------|-----------------|
| Log nước | ✅ Hoàn toàn |
| Xem tiến độ hôm nay | ✅ Hoàn toàn |
| Xem lịch sử | ✅ Data đã cache |
| Nhắc nhở | ✅ Local notification |
| Đọc bài viết | ⚠️ Chỉ bài đã cache |
| Cập nhật thời tiết | ❌ Cần mạng |

#### 4.4.2. Sync Strategy

```
┌─────────────────────────────────────────────────────┐
│                   SYNC QUEUE                         │
├─────────────────────────────────────────────────────┤
│  1. User thao tác offline                           │
│  2. Lưu vào Local DB + Sync Queue                   │
│  3. Khi có mạng → Process queue theo thứ tự         │
│  4. Conflict Resolution: Last-Write-Wins            │
│  5. Xóa khỏi queue khi sync thành công              │
└─────────────────────────────────────────────────────┘
```

**Data Priority:**

| Priority | Data Type | Sync Frequency |
|----------|-----------|----------------|
| 🔴 High | WaterLogs | Ngay lập tức khi có mạng |
| 🟡 Medium | UserProfile, Streaks | Mỗi 6 tiếng |
| 🟢 Low | ScienceArticles | Cache 24 tiếng, prefetch khi WiFi |

### 4.5. UX Edge Cases

| Tình huống | Xử lý |
|------------|-------|
| **Timezone Change** | Recalculate giờ ngủ/thức, giữ nguyên logs theo UTC |
| **Goal Exceeded** | Animation đặc biệt (confetti), Buddy nhảy múa |
| **First Launch** | Tutorial onboarding với animation giải thích BHI |
| **Permission Denied (Health)** | Cho phép nhập thủ công: "Hôm nay bạn có vận động không?" |
| **Permission Denied (Location)** | Hỏi thủ công: "Thời tiết hôm nay thế nào?" (Nóng/Mát/Lạnh) |
| **Midnight Reset** | Reset progress ring, giữ streak nếu hôm qua đạt 100% |
| **App not opened for days** | Welcome back message, reset streak với động viên |

---

## 5. CẤU TRÚC DỮ LIỆU (DATA MODEL)

### 5.1. Core Tables

**Table: Users**
```sql
users (
  user_id         UUID PRIMARY KEY,
  email           VARCHAR(255) UNIQUE,
  name            VARCHAR(100),
  gender          ENUM('male', 'female'),
  birth_year      INT,
  weight_kg       FLOAT,
  height_cm       FLOAT,
  wake_time       TIME DEFAULT '07:00',
  sleep_time      TIME DEFAULT '23:00',
  is_pregnant     BOOLEAN DEFAULT FALSE,
  is_breastfeeding BOOLEAN DEFAULT FALSE,
  timezone        VARCHAR(50),
  created_at      TIMESTAMP,
  updated_at      TIMESTAMP
)
```

**Table: WaterLogs**
```sql
water_logs (
  log_id          UUID PRIMARY KEY,
  user_id         UUID REFERENCES users(user_id),
  logged_at       TIMESTAMP,
  beverage_type   ENUM('water', 'coffee', 'tea', 'milk', 'juice', 'soda', 'alcohol', 'coconut', 'energy_drink', 'other'),
  volume_ml       INT,
  bhi_factor      FLOAT,
  hydration_ml    FLOAT,  -- volume_ml * bhi_factor
  synced_at       TIMESTAMP,
  created_at      TIMESTAMP
)
```

**Table: DailyGoals**
```sql
daily_goals (
  goal_id                 UUID PRIMARY KEY,
  user_id                 UUID REFERENCES users(user_id),
  date                    DATE,
  base_goal_ml            INT,
  weather_adjustment_ml   INT DEFAULT 0,
  activity_adjustment_ml  INT DEFAULT 0,
  biology_adjustment_ml   INT DEFAULT 0,
  total_goal_ml           INT,
  temperature_c           FLOAT,
  humidity_percent        FLOAT,
  achieved_ml             INT DEFAULT 0,
  is_completed            BOOLEAN DEFAULT FALSE,
  created_at              TIMESTAMP,
  updated_at              TIMESTAMP
)
```

### 5.2. Gamification Tables

**Table: Streaks**
```sql
streaks (
  user_id             UUID PRIMARY KEY REFERENCES users(user_id),
  current_streak      INT DEFAULT 0,
  longest_streak      INT DEFAULT 0,
  last_completed_date DATE,
  updated_at          TIMESTAMP
)
```

**Table: Challenges**
```sql
challenges (
  challenge_id    UUID PRIMARY KEY,
  name            VARCHAR(100),
  description     TEXT,
  duration_days   INT,
  goal_type       ENUM('streak', 'total_ml', 'consistency'),
  goal_value      INT,
  reward_type     ENUM('badge', 'skin', 'buddy', 'points'),
  reward_id       VARCHAR(50),
  is_active       BOOLEAN DEFAULT TRUE
)
```

**Table: UserChallenges**
```sql
user_challenges (
  id              UUID PRIMARY KEY,
  user_id         UUID REFERENCES users(user_id),
  challenge_id    UUID REFERENCES challenges(challenge_id),
  start_date      DATE,
  end_date        DATE,
  current_progress INT DEFAULT 0,
  status          ENUM('in_progress', 'completed', 'failed'),
  completed_at    TIMESTAMP
)
```

**Table: BuddyStatus**
```sql
buddy_status (
  user_id         UUID PRIMARY KEY REFERENCES users(user_id),
  buddy_type      VARCHAR(50) DEFAULT 'default_drop',
  current_skin    VARCHAR(50) DEFAULT 'basic',
  unlocked_skins  JSONB DEFAULT '["basic"]',
  unlocked_buddies JSONB DEFAULT '["default_drop"]',
  badges          JSONB DEFAULT '[]',
  total_points    INT DEFAULT 0
)
```

### 5.3. Content Tables

**Table: ScienceArticles**
```sql
science_articles (
  article_id      UUID PRIMARY KEY,
  title           VARCHAR(255),
  summary         VARCHAR(200),
  content_html    TEXT,
  thumbnail_url   VARCHAR(500),
  category        ENUM('basic', 'nutrition', 'weight_loss', 'kidney', 'sports', 'pregnancy'),
  medical_sources JSONB,
  read_time_min   INT,
  is_published    BOOLEAN DEFAULT FALSE,
  published_at    TIMESTAMP,
  created_at      TIMESTAMP
)
```

**Table: NotificationTemplates**
```sql
notification_templates (
  template_id     UUID PRIMARY KEY,
  category        ENUM('reminder', 'sedentary', 'morning', 'evening', 'achievement', 'weather'),
  mood            ENUM('friendly', 'serious', 'playful'),
  time_of_day     ENUM('morning', 'afternoon', 'evening', 'any'),
  template_text   TEXT,
  placeholders    JSONB,
  language        VARCHAR(10) DEFAULT 'vi',
  is_active       BOOLEAN DEFAULT TRUE
)
```

---

## 6. LỘ TRÌNH PHÁT TRIỂN (DEVELOPMENT ROADMAP)

### Phase 1: MVP (8-10 tuần)

| Tuần | Deliverables |
|------|--------------|
| 1-2 | Onboarding flow, User profile setup |
| 3-4 | Core algorithm (Base + Weather adjustment) |
| 5-6 | Smart logging với BHI |
| 7-8 | Smart notifications (Silent Period, Basic templates) |
| 9-10 | Basic Dashboard, Progress ring, Testing & Bug fixes |

**MVP Features:**
* ✅ Tính toán mục tiêu cơ bản + Thời tiết
* ✅ Smart Reminder với Silent Period
* ✅ Log nước với BHI
* ✅ Basic Science Hub (5-10 bài viết)

### Phase 2: Enhanced Experience (6-8 tuần)

* Tích hợp Apple Health/Google Fit (Vận động)
* Home Screen Widget (iOS + Android)
* Context-aware notifications
* Buddy system (basic states)
* Weekly/Monthly statistics

### Phase 3: Gamification Deep (6-8 tuần)

* Challenge system
* Streak rewards & Badges
* Buddy evolution & Skin shop
* Social features (Challenge bạn bè)
* PDF Health Report

### Phase 4: High-tech (TBD)

* Voice command (Siri/Google Assistant)
* NFC Tag integration
* Apple Watch / WearOS app
* AI-powered insights

---

## 7. ACCEPTANCE CRITERIA

### 7.1. Functional Acceptance

| Feature | Criteria |
|---------|----------|
| Onboarding | User có thể hoàn thành setup trong < 2 phút |
| Dynamic Goal | Mục tiêu tự động cập nhật khi thời tiết/vận động thay đổi |
| Smart Logging | Log nước trong ≤ 2 tap, hiển thị hydration value đúng |
| Notifications | Không nhắc trong Silent Period và giờ ngủ |
| Offline | Tất cả logs được sync sau khi có mạng |

### 7.2. Performance Acceptance

| Metric | Threshold |
|--------|-----------|
| App launch | < 2s (cold), < 500ms (warm) |
| Log action | < 100ms response |
| Battery usage | < 2% per day (background) |
| Storage | < 50MB (excluding cached articles) |

---

## 8. APPENDIX

### A. Beverage BHI Reference Sources

* Maughan RJ, et al. "A randomized trial to assess the potential of different beverages to affect hydration status." *Am J Clin Nutr.* 2016
* Shirreffs SM, Maughan RJ. "Rehydration and recovery of fluid balance after exercise." *Exerc Sport Sci Rev.* 2000

### B. Water Intake Calculation References

* European Food Safety Authority (EFSA). "Scientific Opinion on Dietary Reference Values for water." 2010
* Institute of Medicine (IOM). "Dietary Reference Intakes for Water." 2005

---

### Tổng kết

Bản SRS v1.1 này đã được cập nhật với:
1. **Công thức chi tiết** và ví dụ cụ thể
2. **Data Model đầy đủ** (10 tables)
3. **Offline Sync Strategy** rõ ràng
4. **UX Edge Cases** được định nghĩa
5. **Notification Template Engine** chi tiết
6. **Challenge/Gamification** system hoàn chỉnh

Đây là nền tảng vững chắc để đội ngũ phát triển xây dựng một ứng dụng không chỉ "đếm số" mà còn thực sự **chăm sóc** và **giáo dục** người dùng về hydration.
