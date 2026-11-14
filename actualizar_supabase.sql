-- Ejecuta este bloque en Supabase > Editor SQL > Nueva consulta.
-- Agrega campos complementarios SIN borrar las columnas ni operaciones existentes.
alter table public.trades
  add column if not exists session text,
  add column if not exists context_tf text,
  add column if not exists entry_tf text,
  add column if not exists outcome text,
  add column if not exists zone text,
  add column if not exists market_view text,
  add column if not exists on_time boolean not null default false,
  add column if not exists risk_ok boolean not null default false,
  add column if not exists confirmation_ok boolean not null default false,
  add column if not exists followed boolean not null default false,
  add column if not exists image_paths text[] not null default '{}';

-- Mantiene la columna existente cumplio_plan sincronizada con followed.
update public.trades
set followed = coalesce(cumplio_plan, false)
where followed = false;

-- Índice para cargar el historial de cada usuario más rápido.
create index if not exists trades_user_fecha_idx
on public.trades (user_id, fecha desc);

-- Verifica que RLS siga habilitado.
alter table public.trades enable row level security;
