-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Create tables
CREATE TABLE IF NOT EXISTS users (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  email TEXT UNIQUE NOT NULL,
  full_name TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS categories (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name TEXT NOT NULL,
  description TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS equipment (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES users(id) NOT NULL,
  category_id UUID REFERENCES categories(id),
  name TEXT NOT NULL,
  brand TEXT,
  model TEXT,
  serial_number TEXT,
  purchase_date DATE,
  purchase_price DECIMAL(10,2),
  condition TEXT CHECK (condition IN ('New', 'Excellent', 'Good', 'Fair', 'Poor')),
  notes TEXT,
  last_maintenance_date DATE,
  next_maintenance_date DATE,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS cases (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES users(id) NOT NULL,
  name TEXT NOT NULL,
  description TEXT,
  qr_code TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS case_items (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  case_id UUID REFERENCES cases(id) NOT NULL,
  equipment_id UUID REFERENCES equipment(id) NOT NULL,
  quantity INTEGER DEFAULT 1,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(case_id, equipment_id)
);

CREATE TABLE IF NOT EXISTS job_templates (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES users(id) NOT NULL,
  name TEXT NOT NULL,
  description TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS template_items (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  template_id UUID REFERENCES job_templates(id) NOT NULL,
  equipment_id UUID REFERENCES equipment(id) NOT NULL,
  quantity INTEGER DEFAULT 1,
  required BOOLEAN DEFAULT false,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS maintenance_logs (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  equipment_id UUID REFERENCES equipment(id) NOT NULL,
  maintenance_date DATE NOT NULL,
  description TEXT NOT NULL,
  cost DECIMAL(10,2),
  performed_by TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Make sure RLS is disabled for testing
ALTER TABLE users DISABLE ROW LEVEL SECURITY;
ALTER TABLE categories DISABLE ROW LEVEL SECURITY;
ALTER TABLE equipment DISABLE ROW LEVEL SECURITY;
ALTER TABLE cases DISABLE ROW LEVEL SECURITY;
ALTER TABLE case_items DISABLE ROW LEVEL SECURITY;
ALTER TABLE job_templates DISABLE ROW LEVEL SECURITY;
ALTER TABLE template_items DISABLE ROW LEVEL SECURITY;
ALTER TABLE maintenance_logs DISABLE ROW LEVEL SECURITY;

-- Clean up existing data in correct order
DELETE FROM maintenance_logs;
DELETE FROM template_items;
DELETE FROM job_templates;
DELETE FROM case_items;
DELETE FROM cases;
DELETE FROM equipment;
DELETE FROM categories;
DELETE FROM users;

-- Create test user
INSERT INTO users (id, email, full_name) VALUES 
  ('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', 'test@example.com', 'Test User');

-- Insert categories
INSERT INTO categories (id, name, description) VALUES
  ('b5f9d8c7-6e5d-4a3c-2b1a-9f8e7d6c5b4a', 'Cameras', 'Camera bodies and accessories'),
  ('c6e5d4f3-2b1a-9c8d-7e6f-5a4b3c2d1e0f', 'Lenses', 'Camera lenses'),
  ('d7f6e5c4-3c2b-4a9e-8f7a-6b5c4d3e2f1a', 'Lighting', 'Studio and portable lighting equipment');

-- Insert sample equipment
INSERT INTO equipment (
  user_id,
  category_id,
  name,
  brand,
  model,
  serial_number,
  purchase_date,
  purchase_price,
  condition,
  notes
) VALUES
  (
    'a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11',
    'b5f9d8c7-6e5d-4a3c-2b1a-9f8e7d6c5b4a',
    'Sony A7 III',
    'Sony',
    'ILCE-7M3',
    'SN12345678',
    '2023-01-15',
    1999.99,
    'Excellent',
    'Primary shooting camera'
  ),
  (
    'a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11',
    'c6e5d4f3-2b1a-9c8d-7e6f-5a4b3c2d1e0f',
    'Sony 24-70mm f/2.8',
    'Sony',
    'SEL2470GM',
    'SN87654321',
    '2023-01-20',
    2199.99,
    'Good',
    'Versatile zoom lens'
  ),
  (
    'a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11',
    'd7f6e5c4-3c2b-4a9e-8f7a-6b5c4d3e2f1a',
    'Aputure 120D III',
    'Aputure',
    '120D III',
    'SN11223344',
    '2023-02-01',
    899.99,
    'Excellent',
    'Main key light'
  );

-- Verify the data
SELECT 
  e.*,
  c.name as category_name,
  u.email as user_email
FROM equipment e
JOIN categories c ON e.category_id = c.id
JOIN users u ON e.user_id = u.id;
