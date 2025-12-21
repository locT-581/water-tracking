// Generated Supabase types for SmartHydro
// Run: npx supabase gen types typescript --project-id <your-project-id> > types/database.ts

export type Json =
  | string
  | number
  | boolean
  | null
  | { [key: string]: Json | undefined }
  | Json[]

export interface Database {
  public: {
    Tables: {
      users: {
        Row: {
          user_id: string
          email: string
          name: string | null
          gender: 'male' | 'female' | null
          birth_year: number | null
          weight_kg: number | null
          height_cm: number | null
          wake_time: string
          sleep_time: string
          is_pregnant: boolean
          is_breastfeeding: boolean
          timezone: string | null
          created_at: string
          updated_at: string
        }
        Insert: {
          user_id?: string
          email: string
          name?: string | null
          gender?: 'male' | 'female' | null
          birth_year?: number | null
          weight_kg?: number | null
          height_cm?: number | null
          wake_time?: string
          sleep_time?: string
          is_pregnant?: boolean
          is_breastfeeding?: boolean
          timezone?: string | null
          created_at?: string
          updated_at?: string
        }
        Update: {
          user_id?: string
          email?: string
          name?: string | null
          gender?: 'male' | 'female' | null
          birth_year?: number | null
          weight_kg?: number | null
          height_cm?: number | null
          wake_time?: string
          sleep_time?: string
          is_pregnant?: boolean
          is_breastfeeding?: boolean
          timezone?: string | null
          created_at?: string
          updated_at?: string
        }
      }
      water_logs: {
        Row: {
          log_id: string
          user_id: string
          logged_at: string
          beverage_type: string
          volume_ml: number
          bhi_factor: number
          hydration_ml: number
          synced_at: string | null
          created_at: string
        }
        Insert: {
          log_id?: string
          user_id: string
          logged_at?: string
          beverage_type: string
          volume_ml: number
          bhi_factor: number
          hydration_ml: number
          synced_at?: string | null
          created_at?: string
        }
        Update: {
          log_id?: string
          user_id?: string
          logged_at?: string
          beverage_type?: string
          volume_ml?: number
          bhi_factor?: number
          hydration_ml?: number
          synced_at?: string | null
          created_at?: string
        }
      }
      daily_goals: {
        Row: {
          goal_id: string
          user_id: string
          date: string
          base_goal_ml: number
          weather_adjustment_ml: number
          activity_adjustment_ml: number
          biology_adjustment_ml: number
          total_goal_ml: number
          temperature_c: number | null
          humidity_percent: number | null
          achieved_ml: number
          is_completed: boolean
          created_at: string
          updated_at: string
        }
        Insert: {
          goal_id?: string
          user_id: string
          date: string
          base_goal_ml: number
          weather_adjustment_ml?: number
          activity_adjustment_ml?: number
          biology_adjustment_ml?: number
          total_goal_ml: number
          temperature_c?: number | null
          humidity_percent?: number | null
          achieved_ml?: number
          is_completed?: boolean
          created_at?: string
          updated_at?: string
        }
        Update: {
          goal_id?: string
          user_id?: string
          date?: string
          base_goal_ml?: number
          weather_adjustment_ml?: number
          activity_adjustment_ml?: number
          biology_adjustment_ml?: number
          total_goal_ml?: number
          temperature_c?: number | null
          humidity_percent?: number | null
          achieved_ml?: number
          is_completed?: boolean
          created_at?: string
          updated_at?: string
        }
      }
      streaks: {
        Row: {
          user_id: string
          current_streak: number
          longest_streak: number
          last_completed_date: string | null
          updated_at: string
        }
        Insert: {
          user_id: string
          current_streak?: number
          longest_streak?: number
          last_completed_date?: string | null
          updated_at?: string
        }
        Update: {
          user_id?: string
          current_streak?: number
          longest_streak?: number
          last_completed_date?: string | null
          updated_at?: string
        }
      }
      science_articles: {
        Row: {
          article_id: string
          title: string
          summary: string | null
          content_html: string | null
          thumbnail_url: string | null
          category: string
          medical_sources: Json | null
          read_time_min: number | null
          is_published: boolean
          published_at: string | null
          created_at: string
        }
        Insert: {
          article_id?: string
          title: string
          summary?: string | null
          content_html?: string | null
          thumbnail_url?: string | null
          category: string
          medical_sources?: Json | null
          read_time_min?: number | null
          is_published?: boolean
          published_at?: string | null
          created_at?: string
        }
        Update: {
          article_id?: string
          title?: string
          summary?: string | null
          content_html?: string | null
          thumbnail_url?: string | null
          category?: string
          medical_sources?: Json | null
          read_time_min?: number | null
          is_published?: boolean
          published_at?: string | null
          created_at?: string
        }
      }
      notification_templates: {
        Row: {
          template_id: string
          category: string
          mood: string
          time_of_day: string
          template_text: string
          placeholders: Json | null
          language: string
          is_active: boolean
        }
        Insert: {
          template_id?: string
          category: string
          mood: string
          time_of_day: string
          template_text: string
          placeholders?: Json | null
          language?: string
          is_active?: boolean
        }
        Update: {
          template_id?: string
          category?: string
          mood?: string
          time_of_day?: string
          template_text?: string
          placeholders?: Json | null
          language?: string
          is_active?: boolean
        }
      }
    }
    Views: {
      [_ in never]: never
    }
    Functions: {
      [_ in never]: never
    }
    Enums: {
      gender: 'male' | 'female'
      beverage_type: 'water' | 'coffee' | 'tea' | 'milk' | 'juice' | 'soda' | 'alcohol' | 'coconut' | 'energy_drink' | 'other'
      article_category: 'basic' | 'nutrition' | 'weight_loss' | 'kidney' | 'sports' | 'pregnancy'
    }
  }
}

