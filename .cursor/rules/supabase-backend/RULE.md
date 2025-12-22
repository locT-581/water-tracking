---
description: "Supabase backend and database rules for SmartHydro"
globs: ["**/supabase/**", "**/*.sql", "**/migrations/**"]
alwaysApply: false
---

# Supabase Backend Rules

You are managing the SmartHydro backend using Supabase.

## Database Schema

### Core Tables

```sql
-- Users table
CREATE TABLE users (
  user_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  email VARCHAR(255) UNIQUE NOT NULL,
  name VARCHAR(100),
  gender VARCHAR(10) CHECK (gender IN ('male', 'female')),
  birth_year INT,
  weight_kg FLOAT,
  height_cm FLOAT,
  wake_time TIME DEFAULT '07:00',
  sleep_time TIME DEFAULT '23:00',
  is_pregnant BOOLEAN DEFAULT FALSE,
  is_breastfeeding BOOLEAN DEFAULT FALSE,
  timezone VARCHAR(50) DEFAULT 'Asia/Ho_Chi_Minh',
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Water logs table
CREATE TABLE water_logs (
  log_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES users(user_id) ON DELETE CASCADE,
  logged_at TIMESTAMPTZ DEFAULT NOW(),
  beverage_type VARCHAR(20) CHECK (beverage_type IN (
    'water', 'coffee', 'tea', 'milk', 'juice', 'soda', 
    'alcohol', 'coconut', 'energy_drink', 'sparkling', 'other'
  )),
  volume_ml INT NOT NULL CHECK (volume_ml > 0),
  bhi_factor FLOAT NOT NULL DEFAULT 1.0,
  hydration_ml FLOAT GENERATED ALWAYS AS (volume_ml * bhi_factor) STORED,
  synced_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Daily goals table
CREATE TABLE daily_goals (
  goal_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES users(user_id) ON DELETE CASCADE,
  date DATE NOT NULL,
  base_goal_ml INT NOT NULL,
  weather_adjustment_ml INT DEFAULT 0,
  activity_adjustment_ml INT DEFAULT 0,
  biology_adjustment_ml INT DEFAULT 0,
  total_goal_ml INT GENERATED ALWAYS AS (
    base_goal_ml + weather_adjustment_ml + activity_adjustment_ml + biology_adjustment_ml
  ) STORED,
  temperature_c FLOAT,
  humidity_percent FLOAT,
  achieved_ml INT DEFAULT 0,
  is_completed BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(user_id, date)
);
```

### Gamification Tables

```sql
-- Streaks table
CREATE TABLE streaks (
  user_id UUID PRIMARY KEY REFERENCES users(user_id) ON DELETE CASCADE,
  current_streak INT DEFAULT 0,
  longest_streak INT DEFAULT 0,
  last_completed_date DATE,
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Challenges table
CREATE TABLE challenges (
  challenge_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name VARCHAR(100) NOT NULL,
  description TEXT,
  duration_days INT NOT NULL,
  goal_type VARCHAR(20) CHECK (goal_type IN ('streak', 'total_ml', 'consistency')),
  goal_value INT NOT NULL,
  reward_type VARCHAR(20) CHECK (reward_type IN ('badge', 'skin', 'buddy', 'points')),
  reward_id VARCHAR(50),
  is_active BOOLEAN DEFAULT TRUE
);

-- User challenges junction table
CREATE TABLE user_challenges (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES users(user_id) ON DELETE CASCADE,
  challenge_id UUID REFERENCES challenges(challenge_id) ON DELETE CASCADE,
  start_date DATE NOT NULL,
  end_date DATE NOT NULL,
  current_progress INT DEFAULT 0,
  status VARCHAR(20) DEFAULT 'in_progress' CHECK (status IN ('in_progress', 'completed', 'failed')),
  completed_at TIMESTAMPTZ,
  UNIQUE(user_id, challenge_id, start_date)
);

-- Buddy status table
CREATE TABLE buddy_status (
  user_id UUID PRIMARY KEY REFERENCES users(user_id) ON DELETE CASCADE,
  buddy_type VARCHAR(50) DEFAULT 'puru_default',
  current_skin VARCHAR(50) DEFAULT 'basic',
  unlocked_skins JSONB DEFAULT '["basic"]',
  unlocked_buddies JSONB DEFAULT '["puru_default"]',
  badges JSONB DEFAULT '[]',
  total_points INT DEFAULT 0
);
```

### Content Tables

```sql
-- Science articles table
CREATE TABLE science_articles (
  article_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  slug VARCHAR(255) UNIQUE NOT NULL,
  title VARCHAR(255) NOT NULL,
  summary VARCHAR(200),
  content_html TEXT,
  thumbnail_url VARCHAR(500),
  category VARCHAR(20) CHECK (category IN (
    'basic', 'nutrition', 'weight_loss', 'kidney', 'sports', 'pregnancy'
  )),
  medical_sources JSONB DEFAULT '[]',
  read_time_min INT DEFAULT 3,
  is_published BOOLEAN DEFAULT FALSE,
  published_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Notification templates table
CREATE TABLE notification_templates (
  template_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  category VARCHAR(20) CHECK (category IN (
    'reminder', 'sedentary', 'morning', 'evening', 'achievement', 'weather', 'post_workout'
  )),
  mood VARCHAR(20) DEFAULT 'friendly' CHECK (mood IN ('friendly', 'serious', 'playful')),
  time_of_day VARCHAR(20) DEFAULT 'any' CHECK (time_of_day IN ('morning', 'afternoon', 'evening', 'any')),
  template_text TEXT NOT NULL,
  placeholders JSONB DEFAULT '[]',
  language VARCHAR(10) DEFAULT 'vi',
  is_active BOOLEAN DEFAULT TRUE
);
```

## Row Level Security (RLS)

```sql
-- Enable RLS on all tables
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE water_logs ENABLE ROW LEVEL SECURITY;
ALTER TABLE daily_goals ENABLE ROW LEVEL SECURITY;
ALTER TABLE streaks ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_challenges ENABLE ROW LEVEL SECURITY;
ALTER TABLE buddy_status ENABLE ROW LEVEL SECURITY;

-- Users can only access their own data
CREATE POLICY "Users can view own profile" ON users
  FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can update own profile" ON users
  FOR UPDATE USING (auth.uid() = user_id);

-- Water logs policies
CREATE POLICY "Users can view own logs" ON water_logs
  FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own logs" ON water_logs
  FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can delete own logs" ON water_logs
  FOR DELETE USING (auth.uid() = user_id);

-- Public read for articles
CREATE POLICY "Anyone can read published articles" ON science_articles
  FOR SELECT USING (is_published = TRUE);

-- Admin policy for articles (service role)
CREATE POLICY "Service role full access to articles" ON science_articles
  FOR ALL USING (auth.role() = 'service_role');
```

## Useful Functions

```sql
-- Function to update streak on goal completion
CREATE OR REPLACE FUNCTION update_streak_on_goal_complete()
RETURNS TRIGGER AS $$
BEGIN
  IF NEW.is_completed = TRUE AND OLD.is_completed = FALSE THEN
    INSERT INTO streaks (user_id, current_streak, longest_streak, last_completed_date)
    VALUES (NEW.user_id, 1, 1, NEW.date)
    ON CONFLICT (user_id) DO UPDATE SET
      current_streak = CASE
        WHEN streaks.last_completed_date = NEW.date - INTERVAL '1 day' 
        THEN streaks.current_streak + 1
        ELSE 1
      END,
      longest_streak = GREATEST(
        streaks.longest_streak,
        CASE
          WHEN streaks.last_completed_date = NEW.date - INTERVAL '1 day'
          THEN streaks.current_streak + 1
          ELSE 1
        END
      ),
      last_completed_date = NEW.date,
      updated_at = NOW();
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger
CREATE TRIGGER on_goal_complete
  AFTER UPDATE ON daily_goals
  FOR EACH ROW
  EXECUTE FUNCTION update_streak_on_goal_complete();

-- Function to calculate achieved_ml from water_logs
CREATE OR REPLACE FUNCTION calculate_daily_achieved(p_user_id UUID, p_date DATE)
RETURNS INT AS $$
  SELECT COALESCE(SUM(hydration_ml)::INT, 0)
  FROM water_logs
  WHERE user_id = p_user_id
    AND DATE(logged_at) = p_date;
$$ LANGUAGE sql;
```

## Edge Functions

### Daily Goal Reset (Cron)
```typescript
// supabase/functions/reset-daily-goals/index.ts
import { createClient } from '@supabase/supabase-js';

Deno.serve(async () => {
  const supabase = createClient(
    Deno.env.get('SUPABASE_URL')!,
    Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!
  );

  const today = new Date().toISOString().split('T')[0];
  
  // Get all active users
  const { data: users } = await supabase
    .from('users')
    .select('user_id, birth_year, weight_kg, is_pregnant, is_breastfeeding');

  for (const user of users || []) {
    const age = new Date().getFullYear() - user.birth_year;
    const baseGoal = age < 30 
      ? user.weight_kg * 40 
      : age <= 55 
        ? user.weight_kg * 35 
        : user.weight_kg * 30;
    
    const biologyAdjustment = 
      (user.is_pregnant ? 300 : 0) + 
      (user.is_breastfeeding ? 500 : 0);

    await supabase.from('daily_goals').upsert({
      user_id: user.user_id,
      date: today,
      base_goal_ml: Math.round(baseGoal),
      biology_adjustment_ml: biologyAdjustment,
    }, { onConflict: 'user_id,date' });
  }

  return new Response('Daily goals reset complete');
});
```

## Common Queries

```typescript
// Get today's progress
const { data } = await supabase
  .from('daily_goals')
  .select(`
    *,
    logs:water_logs(*)
  `)
  .eq('user_id', userId)
  .eq('date', today)
  .single();

// Get weekly stats
const { data } = await supabase
  .from('daily_goals')
  .select('date, total_goal_ml, achieved_ml, is_completed')
  .eq('user_id', userId)
  .gte('date', startOfWeek)
  .lte('date', endOfWeek)
  .order('date');

// Get random notification template
const { data } = await supabase
  .from('notification_templates')
  .select('*')
  .eq('category', 'reminder')
  .eq('is_active', true)
  .limit(1)
  .order('random()');
```

## Storage Buckets

```sql
-- Create buckets
INSERT INTO storage.buckets (id, name, public)
VALUES 
  ('avatars', 'avatars', true),
  ('article-thumbnails', 'article-thumbnails', true),
  ('buddy-assets', 'buddy-assets', true);

-- Policies
CREATE POLICY "Avatar upload" ON storage.objects
  FOR INSERT WITH CHECK (
    bucket_id = 'avatars' AND 
    auth.uid()::text = (storage.foldername(name))[1]
  );

CREATE POLICY "Public avatar read" ON storage.objects
  FOR SELECT USING (bucket_id = 'avatars');
```

