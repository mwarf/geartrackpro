-- Run these queries in Supabase SQL editor to verify data

-- Check users
SELECT * FROM users;

-- Check categories
SELECT * FROM categories;

-- Check equipment
SELECT 
  e.*,
  c.name as category_name
FROM equipment e
LEFT JOIN categories c ON e.category_id = c.id;

-- Check cases and their items
SELECT 
  c.*,
  json_agg(json_build_object(
    'equipment_id', ci.equipment_id,
    'quantity', ci.quantity,
    'equipment_name', e.name
  )) as items
FROM cases c
LEFT JOIN case_items ci ON c.id = ci.case_id
LEFT JOIN equipment e ON ci.equipment_id = e.id
GROUP BY c.id;

-- Check job templates
SELECT * FROM job_templates;
