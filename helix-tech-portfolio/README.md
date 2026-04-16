# Helix Tech — Portfolio Website

## What's Inside
- **index.html** — Complete portfolio with 3D DNA helix, admin panel, Supabase integration
- **schema.sql** — Supabase database schema (tables, RLS policies, seed data)
- **assets/favicon.svg** — Site favicon

## Setup

### Without Supabase (localStorage, local only)
Just open index.html. Click the settings icon to log in (admin / admin123). Admin panel opens in admin.html.

### With Supabase (live for all visitors)
1. Create project at supabase.com
2. Run schema.sql in SQL Editor
3. Create admin user in Authentication > Users
4. Edit index.html — find SB_URL and SB_KEY, paste your credentials
5. Host on Vercel/Netlify

## Features
- 3D DNA helix of tech stacks (mouse-reactive)
- Supabase Auth for admin login
- Full CRUD: services, portfolio, testimonials
- Contact form saves to database
- Row-level security (public read, admin write)
- Falls back to localStorage if Supabase not configured

## Color Theme
Find-replace: emerald → blue/purple/orange (emerald-400, emerald-500, #10b981, #34d399, #059669)
