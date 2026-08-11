-- Fix Cover Image field in Properties/propriedades.
-- The field must be optional at creation time; users can add images later.

update directus_fields
set required = false,
    hidden = false
where collection in ('propriedades', 'properties')
  and lower(replace(field, ' ', '_')) in ('cover_image', 'image');

do $$
begin
  if exists (
    select 1 from information_schema.columns
    where table_schema = 'public'
      and table_name = 'propriedades'
      and column_name = 'cover_image'
  ) then
    alter table public.propriedades alter column cover_image drop not null;
  end if;

  if exists (
    select 1 from information_schema.columns
    where table_schema = 'public'
      and table_name = 'propriedades'
      and column_name = 'Image'
  ) then
    alter table public.propriedades alter column "Image" drop not null;
  end if;

  if exists (
    select 1 from information_schema.columns
    where table_schema = 'public'
      and table_name = 'properties'
      and column_name = 'cover_image'
  ) then
    alter table public.properties alter column cover_image drop not null;
  end if;
end $$;
