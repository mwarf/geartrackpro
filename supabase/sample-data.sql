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
