-- Fix Cover Image field in Properties collection
-- Issue: Field is marked as required but hidden, blocking form submissions

-- 1. Update Directus field metadata to mark Cover Image as NOT required
UPDATE directus_fields
SET required = false
WHERE collection = 'propriedades' 
  AND (field = 'cover_image' OR field = 'Cover_image' OR field = 'Cover Image');

-- 2. Ensure the column in the database is nullable (allows NULL values)
ALTER TABLE propriedades 
ALTER COLUMN cover_image DROP NOT NULL;

-- Verify the changes
SELECT collection, field, required, hidden, interface
FROM directus_fields
WHERE collection = 'propriedades' 
  AND (field ILIKE '%cover%');

-- Check column nullability
SELECT column_name, is_nullable, data_type
FROM information_schema.columns
WHERE table_name = 'propriedades'
  AND column_name ILIKE '%cover%';

