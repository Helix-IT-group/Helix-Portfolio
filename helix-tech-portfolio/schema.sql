-- =============================================
--  HELIX TECH — SUPABASE DATABASE SCHEMA
--  Run ALL of this in Supabase SQL Editor
-- =============================================

CREATE EXTENSION IF NOT EXISTS "pgcrypto";

CREATE TABLE IF NOT EXISTS site_settings (
  id          INTEGER PRIMARY KEY DEFAULT 1 CHECK (id = 1),
  data        JSONB   NOT NULL DEFAULT '{}'::jsonb,
  updated_at  TIMESTAMPTZ DEFAULT now()
);

INSERT INTO site_settings (data) VALUES (
  '{
    "companyName": "Helix Tech",
    "email": "hello@helixtech.io",
    "phone": "+1 (415) 555-0192",
    "address": "42 Innovation Drive, Suite 300<br>San Francisco, CA 94107",
    "heroTitle": "Building the<br><span class=\"text-transparent bg-clip-text bg-gradient-to-r from-emerald-400 via-emerald-300 to-emerald-500\">digital future</span>",
    "heroSub": "We engineer scalable IT solutions, craft immersive digital experiences, and empower businesses to thrive in an ever-evolving technological landscape.",
    "heroBadge": "Trusted by 200+ Businesses",
    "aboutP1": "Founded in 2012, Helix Tech has grown from a small dev shop into a full-service IT partner trusted by startups and Fortune 500 companies alike.",
    "aboutP2": "Our multidisciplinary team of 80+ engineers, designers, and strategists work at the intersection of innovation and pragmatism.",
    "aboutYears": "12+",
    "stats": [
      {"n":"200","l":"Clients Served"},
      {"n":"500","l":"Projects Done"},
      {"n":"12","l":"Years Experience"},
      {"n":"99","l":"% Satisfaction"}
    ],
    "partners": ["Microsoft","AWS","Google Cloud","Salesforce","Oracle","SAP","VMware","Cisco"],
    "footerDesc": "Engineering the digital future. We build, secure, and scale the technology that powers tomorrow'\''s businesses."
  }'::jsonb
) ON CONFLICT (id) DO NOTHING;

CREATE TABLE IF NOT EXISTS services (
  id          TEXT PRIMARY KEY DEFAULT gen_random_uuid()::text,
  icon        TEXT NOT NULL,
  title       TEXT NOT NULL,
  description TEXT NOT NULL,
  sort_order  INTEGER DEFAULT 0,
  created_at  TIMESTAMPTZ DEFAULT now()
);

INSERT INTO services (icon, title, description, sort_order) VALUES
  ('cloud',        'Cloud Solutions',       'Migrate, manage, and optimize your cloud infrastructure on AWS, Azure, or GCP with zero downtime.', 0),
  ('shield-check', 'Cybersecurity',         'Protect your assets with penetration testing, SIEM monitoring, compliance audits, and incident response.', 1),
  ('code-2',       'Custom Software',       'Tailor-made applications built with modern stacks — React, Next.js, Node, Python — designed for scale.', 2),
  ('brain-circuit','AI & Machine Learning',  'Leverage predictive analytics, NLP, computer vision, and LLM integrations to automate and innovate.', 3),
  ('smartphone',   'Mobile Development',    'Native and cross-platform apps for iOS and Android using React Native, Flutter, and Swift.', 4),
  ('bar-chart-3',  'Data Analytics',        'Transform raw data into actionable insights with BI dashboards, ETL pipelines, and data warehousing.', 5);

CREATE TABLE IF NOT EXISTS portfolio (
  id          TEXT PRIMARY KEY DEFAULT gen_random_uuid()::text,
  title       TEXT NOT NULL,
  description TEXT NOT NULL,
  category    TEXT NOT NULL CHECK (category IN ('web','mobile','cloud')),
  image_url   TEXT NOT NULL,
  badge_color TEXT NOT NULL DEFAULT 'emerald',
  tags        TEXT[] NOT NULL DEFAULT '{}',
  sort_order  INTEGER DEFAULT 0,
  created_at  TIMESTAMPTZ DEFAULT now()
);

INSERT INTO portfolio (title, description, category, image_url, badge_color, tags, sort_order) VALUES
  ('FinTrack Dashboard',  'Real-time financial analytics platform processing 2M+ transactions daily.',                'web',    'https://picsum.photos/seed/helix-proj1/600/340.jpg', 'emerald', ARRAY['React','Node.js','PostgreSQL'],     0),
  ('MediCare Connect',    'Telehealth platform with video consultations and e-prescriptions.',                       'mobile', 'https://picsum.photos/seed/helix-proj2/600/340.jpg', 'blue',    ARRAY['Flutter','Firebase','WebRTC'],        1),
  ('LogiSmart AI',        'AI-driven logistics optimization reducing delivery costs by 34%.',                       'cloud',  'https://picsum.photos/seed/helix-proj3/600/340.jpg', 'purple', ARRAY['Python','TensorFlow','AWS'],          2),
  ('EduVerse LMS',        'Gamified learning platform serving 500K+ students with adaptive paths.',                 'web',    'https://picsum.photos/seed/helix-proj4/600/340.jpg', 'emerald', ARRAY['Next.js','GraphQL','MongoDB'],      3),
  ('SecureVault',         'Zero-trust cloud security platform with AI threat detection.',                            'cloud',  'https://picsum.photos/seed/helix-proj5/600/340.jpg', 'purple', ARRAY['Go','K8s','Azure'],                 4),
  ('QuickBite Delivery',  'Food delivery app with real-time tracking serving 100K+ daily orders.',                   'mobile', 'https://picsum.photos/seed/helix-proj6/600/340.jpg', 'blue',    ARRAY['React Native','Redis','GCP'],       5);

CREATE TABLE IF NOT EXISTS testimonials (
  id          TEXT PRIMARY KEY DEFAULT gen_random_uuid()::text,
  name        TEXT NOT NULL,
  role        TEXT NOT NULL,
  initials    TEXT NOT NULL,
  gradient    TEXT NOT NULL DEFAULT 'from-emerald-400 to-emerald-600',
  text_color  TEXT NOT NULL DEFAULT 'text-black',
  stars       INTEGER NOT NULL DEFAULT 5 CHECK (stars BETWEEN 1 AND 5),
  quote       TEXT NOT NULL,
  sort_order  INTEGER DEFAULT 0,
  created_at  TIMESTAMPTZ DEFAULT now()
);

INSERT INTO testimonials (name, role, initials, gradient, text_color, stars, quote, sort_order) VALUES
  ('Sarah Richardson', 'CTO, FinanceFlow Inc.',   'SR', 'from-emerald-400 to-emerald-600', 'text-black', 5, 'Helix Tech transformed our legacy systems into a modern cloud architecture. Zero downtime, 40% cost reduction.',       0),
  ('Marcus Kim',       'VP Engineering, QuickBite','MK', 'from-blue-400 to-blue-600',      'text-white', 5, 'The AI recommendation engine increased our order value by 28%. Their ML team is world-class.',                      1),
  ('Aisha Patel',      'CEO, MediCare Connect',   'AP', 'from-purple-400 to-purple-600',   'text-white', 5, 'From concept to App Store in 4 months. The Flutter app is buttery smooth.',                                     2);

CREATE TABLE IF NOT EXISTS messages (
  id          TEXT PRIMARY KEY DEFAULT gen_random_uuid()::text,
  first_name  TEXT NOT NULL,
  last_name   TEXT NOT NULL,
  email       TEXT NOT NULL,
  company     TEXT,
  service     TEXT,
  message     TEXT NOT NULL,
  created_at  TIMESTAMPTZ DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_services_sort     ON services     (sort_order);
CREATE INDEX IF NOT EXISTS idx_portfolio_sort    ON portfolio    (sort_order);
CREATE INDEX IF NOT EXISTS idx_testimonials_sort ON testimonials (sort_order);
CREATE INDEX IF NOT EXISTS idx_messages_date     ON messages     (created_at DESC);

-- ROW LEVEL SECURITY
ALTER TABLE site_settings  ENABLE ROW LEVEL SECURITY;
ALTER TABLE services       ENABLE ROW LEVEL SECURITY;
ALTER TABLE portfolio      ENABLE ROW LEVEL SECURITY;
ALTER TABLE testimonials   ENABLE ROW LEVEL SECURITY;
ALTER TABLE messages       ENABLE ROW LEVEL SECURITY;

CREATE POLICY "pub_read_settings"     ON site_settings  FOR SELECT USING (true);
CREATE POLICY "pub_read_services"     ON services       FOR SELECT USING (true);
CREATE POLICY "pub_read_portfolio"    ON portfolio      FOR SELECT USING (true);
CREATE POLICY "pub_read_testimonials" ON testimonials   FOR SELECT USING (true);
CREATE POLICY "pub_insert_messages"    ON messages       FOR INSERT WITH CHECK (true);

CREATE POLICY "adm_all_services"       ON services       FOR ALL    USING (auth.role() = 'authenticated');
CREATE POLICY "adm_all_portfolio"      ON portfolio      FOR ALL    USING (auth.role() = 'authenticated');
CREATE POLICY "adm_all_testimonials"   ON testimonials   FOR ALL    USING (auth.role() = 'authenticated');
CREATE POLICY "adm_all_settings"       ON site_settings  FOR ALL    USING (auth.role() = 'authenticated');
CREATE POLICY "adm_read_messages"      ON messages       FOR SELECT USING (auth.role() = 'authenticated');
CREATE POLICY "adm_delete_messages"    ON messages       FOR DELETE USING (auth.role() = 'authenticated');

CREATE OR REPLACE FUNCTION trigger_updated_at()
RETURNS TRIGGER AS \$\$ BEGIN NEW.updated_at = now(); RETURN NEW; END; \$\$ LANGUAGE plpgsql;

CREATE TRIGGER trg_settings_updated_at
  BEFORE UPDATE ON site_settings
  FOR EACH ROW EXECUTE FUNCTION trigger_updated_at();
