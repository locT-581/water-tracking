---
description: "Next.js web admin and blog development rules for SmartHydro"
globs: ["web/**/*.tsx", "web/**/*.ts", "web/app/**", "web/components/**", "web/lib/**", "web/package.json"]
alwaysApply: false
---

# Next.js Web Admin & Blog Rules

You are developing the SmartHydro web admin dashboard and public blog using Next.js.

## Tech Stack

- **Framework:** Next.js 15.x+ (App Router + Turbopack)
- **Language:** TypeScript 5.x (strict mode)
- **Package Manager:** pnpm 9.x
- **UI:** Shadcn/UI + Tailwind CSS v4
- **State:** Zustand
- **Data Fetching:** TanStack Query + Supabase Client
- **Forms:** React Hook Form + Zod
- **Editor:** Tiptap
- **Animation:** Motion (framer-motion successor)

## Project Structure

```
web/
├── app/
│   ├── (admin)/                     # Protected admin routes
│   │   ├── dashboard/
│   │   │   └── page.tsx
│   │   ├── articles/
│   │   │   ├── page.tsx            # List articles
│   │   │   ├── new/page.tsx        # Create article
│   │   │   └── [id]/page.tsx       # Edit article
│   │   ├── notifications/
│   │   │   └── page.tsx            # Manage templates
│   │   └── layout.tsx              # Admin layout with sidebar
│   │
│   ├── (public)/                    # Public routes
│   │   ├── blog/
│   │   │   ├── page.tsx            # Blog listing
│   │   │   └── [slug]/page.tsx     # Article detail (SEO)
│   │   └── layout.tsx
│   │
│   ├── globals.css                  # Tailwind v4 CSS-first config
│   ├── layout.tsx
│   └── page.tsx
│
├── components/
│   ├── ui/                      # Shadcn components
│   ├── admin/                   # Admin-specific
│   └── blog/                    # Blog-specific
│
├── lib/
│   ├── supabase/
│   │   ├── client.ts           # Browser client
│   │   ├── server.ts           # Server client
│   │   └── admin.ts            # Service role client
│   ├── utils/
│   └── validations/            # Zod schemas
│
├── hooks/                       # Custom React hooks
├── stores/                      # Zustand stores
├── types/                       # TypeScript types
│
├── package.json
├── pnpm-lock.yaml
├── postcss.config.mjs
├── tsconfig.json
└── middleware.ts               # Auth middleware
```

## Coding Standards

### TypeScript
```typescript
// Always define types explicitly
interface Article {
  id: string;
  title: string;
  summary: string;
  content_html: string;
  thumbnail_url: string | null;
  category: ArticleCategory;
  is_published: boolean;
  published_at: Date | null;
}

// Use Zod for runtime validation
const articleSchema = z.object({
  title: z.string().min(1).max(255),
  summary: z.string().max(200),
  content_html: z.string(),
  category: z.enum(['basic', 'nutrition', 'weight_loss', 'kidney', 'sports', 'pregnancy']),
});
```

### Component Patterns
```tsx
// Use Server Components by default
// Add 'use client' only when needed

// Server Component (default)
export default async function ArticlesPage() {
  const articles = await getArticles();
  return <ArticleList articles={articles} />;
}

// Client Component (when needed)
'use client';

export function ArticleEditor({ article }: { article: Article }) {
  const [content, setContent] = useState(article.content_html);
  // ...
}
```

### Shadcn/UI + Tailwind v4

Tailwind CSS v4 sử dụng **CSS-first configuration** trong `globals.css`:

```css
/* app/globals.css */
@import "tailwindcss";

@theme {
  /* SmartHydro Brand Colors */
  --color-hydro-start: #2AF598;
  --color-hydro-end: #009EFD;
  --color-deep-ocean: #051E3E;
  --color-science: #651FFF;
  
  /* Typography */
  --font-sans: "Inter", system-ui, sans-serif;
  --font-heading: "Nunito", system-ui, sans-serif;
  
  /* Border Radius */
  --radius-3xl: 2rem;
  --radius-pill: 9999px;
}
```

```tsx
// Use Shadcn components with Tailwind customization
import { Button } from '@/components/ui/button';
import { Card, CardHeader, CardTitle, CardContent } from '@/components/ui/card';

<Card className="rounded-3xl border-none shadow-lg">
  <CardHeader>
    <CardTitle className="text-deep-ocean">Article Title</CardTitle>
  </CardHeader>
  <CardContent>
    <Button 
      className="bg-hydro-gradient rounded-pill px-8 hover:opacity-90"
    >
      Publish
    </Button>
  </CardContent>
</Card>
```

### Custom Utilities (Tailwind v4)

Định nghĩa trong `@layer utility` trong `globals.css`:

```css
@layer utility {
  .gradient-text {
    background-image: linear-gradient(135deg, var(--color-hydro-start) 0%, var(--color-hydro-end) 100%);
    -webkit-background-clip: text;
    background-clip: text;
    color: transparent;
  }

  .bg-hydro-gradient {
    background-image: linear-gradient(135deg, var(--color-hydro-start) 0%, var(--color-hydro-end) 100%);
  }

  .glass {
    background-color: rgb(255 255 255 / 0.7);
    backdrop-filter: blur(24px);
    border: 1px solid rgb(255 255 255 / 0.2);
  }
}
```

## Supabase Integration

### Client Setup
```typescript
// lib/supabase/client.ts
import { createBrowserClient } from '@supabase/ssr';

export const createClient = () =>
  createBrowserClient(
    process.env.NEXT_PUBLIC_SUPABASE_URL!,
    process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!
  );

// lib/supabase/server.ts
import { createServerClient } from '@supabase/ssr';
import { cookies } from 'next/headers';

export const createClient = async () => {
  const cookieStore = await cookies();
  return createServerClient(
    process.env.NEXT_PUBLIC_SUPABASE_URL!,
    process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!,
    {
      cookies: {
        getAll() { return cookieStore.getAll(); },
        setAll(cookiesToSet) {
          cookiesToSet.forEach(({ name, value, options }) =>
            cookieStore.set(name, value, options)
          );
        },
      },
    }
  );
};
```

### Data Fetching
```typescript
// Server Component
async function getArticles() {
  const supabase = await createClient();
  const { data, error } = await supabase
    .from('science_articles')
    .select('*')
    .eq('is_published', true)
    .order('published_at', { ascending: false });
  
  if (error) throw error;
  return data;
}

// Client Component with TanStack Query
const { data: articles, isLoading } = useQuery({
  queryKey: ['articles'],
  queryFn: async () => {
    const supabase = createClient();
    const { data } = await supabase.from('science_articles').select('*');
    return data;
  },
});
```

## Blog SEO Requirements

```tsx
// app/(public)/blog/[slug]/page.tsx
import { Metadata } from 'next';

export async function generateMetadata({ params }): Promise<Metadata> {
  const article = await getArticle(params.slug);
  
  return {
    title: `${article.title} | SmartHydro Blog`,
    description: article.summary,
    openGraph: {
      title: article.title,
      description: article.summary,
      images: [article.thumbnail_url],
      type: 'article',
    },
  };
}

export async function generateStaticParams() {
  const articles = await getPublishedArticleSlugs();
  return articles.map((article) => ({ slug: article.slug }));
}
```

## Animation với Motion

```tsx
'use client';

import { motion } from 'motion/react';

export function AnimatedCard({ children }) {
  return (
    <motion.div
      initial={{ opacity: 0, y: 20 }}
      animate={{ opacity: 1, y: 0 }}
      transition={{ duration: 0.3 }}
    >
      {children}
    </motion.div>
  );
}
```

## Admin Dashboard Features

### Article Management
- List with pagination, search, filter by category
- Draft/Published toggle
- Rich text editor with Tiptap
- Image upload to Supabase Storage
- Preview before publish

### Notification Templates
- CRUD for notification templates
- Placeholder support: `{name}`, `{remaining_ml}`, `{streak_count}`
- Category management: reminder, sedentary, morning, evening, achievement

### Analytics Dashboard
- User stats overview
- Daily active users chart
- Popular articles
- Notification engagement rates

## Key Dependencies

```json
{
  "dependencies": {
    "next": "^15.1.3",
    "react": "^19.0.0",
    "react-dom": "^19.0.0",
    "@supabase/supabase-js": "^2.47.10",
    "@supabase/ssr": "^0.5.2",
    "tailwindcss": "^4.0.0",
    "@tailwindcss/postcss": "^4.0.0",
    "zustand": "^5.0.2",
    "@tanstack/react-query": "^5.62.8",
    "react-hook-form": "^7.54.2",
    "zod": "^3.24.1",
    "@hookform/resolvers": "^3.9.1",
    "@tiptap/react": "^2.11.2",
    "date-fns": "^4.1.0",
    "recharts": "^2.15.0",
    "lucide-react": "^0.469.0",
    "motion": "^11.15.0"
  }
}
```

## PostCSS Config (Tailwind v4)

```javascript
// postcss.config.mjs
export default {
  plugins: {
    "@tailwindcss/postcss": {},
  },
};
```

## pnpm Commands

```bash
# Install dependencies
pnpm install

# Development server với Turbopack
pnpm dev

# Build for production
pnpm build

# Start production server
pnpm start

# Lint code
pnpm lint

# Type check
pnpm type-check
```

## Tailwind v4 CSS-First Config (SmartHydro Theme)

Không còn file `tailwind.config.js`. Mọi cấu hình nằm trong `globals.css`:

```css
@import "tailwindcss";

@theme {
  /* Colors */
  --color-hydro-start: #2AF598;
  --color-hydro-end: #009EFD;
  --color-deep-ocean: #051E3E;
  --color-success: #00C853;
  --color-warning: #FFD600;
  --color-danger: #FF3D00;
  --color-science: #651FFF;
  --color-light-bg: #F0F8FF;
  --color-dark-bg: #001220;
  
  /* Typography */
  --font-heading: "Nunito", system-ui, sans-serif;
  --font-sans: "Inter", system-ui, sans-serif;
  
  /* Border Radius - SmartHydro Fluid Design */
  --radius-3xl: 24px;
  --radius-4xl: 32px;
  --radius-pill: 9999px;
}
```

## Important Notes

1. **Package Manager**: Always use `pnpm` instead of `npm` or `yarn`
2. **Tailwind v4**: No `tailwind.config.js` - use CSS-first configuration in `globals.css`
3. **PostCSS**: Use `@tailwindcss/postcss` plugin in `postcss.config.mjs`
4. **Animation**: Use `motion` package (not `framer-motion`)
5. **React 19**: Use new features like Server Components by default
6. **Next.js 15**: Use `--turbopack` flag for faster dev server
