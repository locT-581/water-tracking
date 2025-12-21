# SmartHydro Supabase Backend

## 📁 Structure

```
supabase/
├── config.toml              # Supabase local dev configuration
├── migrations/              # Database migrations (auto-applied in order)
│   ├── 20250101000001_create_core_tables.sql
│   ├── 20250101000002_create_gamification_tables.sql
│   ├── 20250101000003_create_content_tables.sql
│   ├── 20250101000004_setup_rls_policies.sql
│   └── 20250101000005_setup_storage_buckets.sql
└── seed.sql                 # Sample data (optional)
```

## 🚀 Setup Instructions

### 1. Install Supabase CLI

```bash
# macOS
brew install supabase/tap/supabase

# Windows (via Scoop)
scoop bucket add supabase https://github.com/supabase/scoop-bucket.git
scoop install supabase

# Linux
brew install supabase/tap/supabase
```

### 2. Login to Supabase

```bash
supabase login
```

### 3. Link to Your Project

```bash
# Get your project ref from: https://app.supabase.com/project/<your-project-id>/settings/general
supabase link --project-ref your-project-ref
```

### 4. Run Migrations

```bash
# Push all migrations to your Supabase project
supabase db push

# Or run migrations locally for testing
supabase start
supabase db reset
```

### 5. Configure OAuth Providers

#### Google OAuth:
1. Go to [Google Cloud Console](https://console.developers.google.com/)
2. Create a new project (or select existing)
3. Enable Google+ API
4. Create OAuth 2.0 credentials
5. Add redirect URI: `https://your-project-ref.supabase.co/auth/v1/callback`
6. Copy Client ID and Secret
7. In Supabase Dashboard: Authentication → Providers → Google
8. Paste Client ID and Secret

#### Apple OAuth:
1. Go to [Apple Developer](https://developer.apple.com/)
2. Create a Service ID
3. Configure Sign in with Apple
4. Add redirect URI: `https://your-project-ref.supabase.co/auth/v1/callback`
5. Generate secret key
6. In Supabase Dashboard: Authentication → Providers → Apple
7. Configure with your credentials

### 6. Setup Storage Buckets

The migration will auto-create buckets, but you can also do it manually:

1. Go to Supabase Dashboard → Storage
2. Buckets are already created by migration:
   - `avatars` (public)
   - `article-thumbnails` (public)
   - `buddy-assets` (public)
   - `reports` (private)

## 🔒 Security

### RLS Policies

All tables have Row Level Security (RLS) enabled with the following principles:

- **Users can only access their own data**
- **Public content (articles, challenges) is readable by all**
- **Admin operations require service_role key**

### Storage Policies

- **avatars**: Users can upload/view/delete their own avatars
- **article-thumbnails**: Admins upload, everyone can view
- **buddy-assets**: Admins upload, everyone can view
- **reports**: Private, users can only access their own

## 📊 Database Schema

### Core Tables:
- `user_profiles` - User profile data (age, weight, goals, etc.)
- `water_logs` - Water intake logs
- `daily_goals` - Dynamic daily hydration goals

### Gamification Tables:
- `streaks` - User streak tracking
- `challenges` - Available challenges
- `user_challenges` - User challenge progress
- `buddy_status` - Puru buddy state
- `achievements` - Available achievements
- `user_achievements` - Unlocked achievements

### Content Tables:
- `science_articles` - Science Hub articles
- `notification_templates` - Smart notification messages

## 🔧 Useful Commands

```bash
# Start local Supabase (Docker required)
supabase start

# Stop local Supabase
supabase stop

# Reset database (WARNING: deletes all data)
supabase db reset

# Create new migration
supabase migration new migration_name

# Push migrations to remote
supabase db push

# Pull remote changes
supabase db pull

# Generate TypeScript types
supabase gen types typescript --local > types/database.ts
```

## 📝 Environment Variables

Add these to your `.env` file:

```env
SUPABASE_URL=https://your-project-ref.supabase.co
SUPABASE_ANON_KEY=your-anon-key
SUPABASE_SERVICE_ROLE_KEY=your-service-role-key
```

Get these from: Supabase Dashboard → Settings → API

## 🐛 Troubleshooting

### Migration fails:
```bash
# Check migration status
supabase migration list

# Repair migrations
supabase migration repair --status applied <version>
```

### RLS blocking queries:
- Check you're using the correct user context
- Verify RLS policies are correct
- Use service_role key for admin operations

### Storage upload fails:
- Check file size limits (5MB for avatars)
- Verify MIME types are allowed
- Ensure storage policies are applied

## 📚 Resources

- [Supabase Docs](https://supabase.com/docs)
- [RLS Best Practices](https://supabase.com/docs/guides/auth/row-level-security)
- [Storage Guide](https://supabase.com/docs/guides/storage)

