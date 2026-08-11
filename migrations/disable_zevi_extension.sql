-- Temporarily disable Zevi Photo Gallery extension for property_images field
-- The extension prevents creating new items because it checks if primaryKey exists
-- This allows form submission to proceed, then photos can be added after property creation

UPDATE directus_fields
SET interface = 'list-o2m'
WHERE collection = 'properties' 
  AND field = 'property_images';

-- Verify the change
SELECT collection, field, interface, required, hidden
FROM directus_fields
WHERE collection = 'properties' 
  AND (field = 'property_images' OR field = 'photos');

