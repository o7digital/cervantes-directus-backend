import { Client } from "pg";

const connectionString = process.env.DATABASE_URL ?? process.env.DB_CONNECTION_STRING;

const clientConfig = connectionString
  ? { connectionString }
  : {
      host: process.env.DB_HOST,
      port: process.env.DB_PORT ? Number(process.env.DB_PORT) : 5432,
      database: process.env.DB_DATABASE,
      user: process.env.DB_USER,
      password: process.env.DB_PASSWORD,
    };

if (!connectionString && (!clientConfig.host || !clientConfig.database || !clientConfig.user)) {
  console.log("No PostgreSQL connection variables found; skipping Directus fixes.");
  process.exit(0);
}

if (process.env.DB_SSL === "true" || process.env.DB_SSL === "1") {
  clientConfig.ssl = {
    rejectUnauthorized: process.env.DB_SSL__REJECT_UNAUTHORIZED !== "false",
  };
}

const client = new Client(clientConfig);

const sql = `
  update directus_fields
  set required = false
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
`;

try {
  console.log("Applying Directus startup fixes...");
  await client.connect();
  await client.query(sql);
  console.log("Directus startup fixes applied.");
} catch (error) {
  console.error("Unable to apply Directus startup fixes.", error);
  process.exit(1);
} finally {
  await client.end().catch(() => {});
}
