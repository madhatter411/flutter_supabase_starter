-- Supabase schema for users (profiles), customers, projects, invoices
create extension if not exists "pgcrypto";

create table public.users (
  id uuid primary key references auth.users(id) on delete cascade,
  email text not null unique,
  full_name text,
  avatar_url text,
  created_at timestamptz not null default now()
);

create table public.customers (
  id uuid primary key default gen_random_uuid(),
  owner_id uuid not null references public.users(id) on delete cascade,
  name text not null,
  email text,
  phone text,
  billing_address jsonb,
  notes text,
  created_at timestamptz not null default now(),
  updated_at timestamptz
);

create table public.projects (
  id uuid primary key default gen_random_uuid(),
  owner_id uuid not null references public.users(id) on delete cascade,
  customer_id uuid references public.customers(id) on delete set null,
  title text not null,
  description text,
  status text not null default 'draft', -- draft, active, paused, completed, archived
  rate numeric(12,2),
  created_at timestamptz not null default now(),
  updated_at timestamptz
);

create table public.invoices (
  id uuid primary key default gen_random_uuid(),
  owner_id uuid not null references public.users(id) on delete cascade,
  project_id uuid references public.projects(id) on delete set null,
  customer_id uuid references public.customers(id) on delete set null,
  invoice_number text not null,
  issue_date date not null default current_date,
  due_date date,
  subtotal numeric(12,2) not null default 0,
  tax numeric(12,2) not null default 0,
  total numeric(12,2) not null default 0,
  status text not null default 'draft', -- draft, sent, paid, void
  currency text not null default 'USD',
  notes text,
  created_at timestamptz not null default now(),
  updated_at timestamptz
);

create unique index invoices_owner_invoice_number_idx on public.invoices(owner_id, invoice_number);

-- row level security
alter table public.users enable row level security;
alter table public.customers enable row level security;
alter table public.projects enable row level security;
alter table public.invoices enable row level security;

-- Minimal policies (tighten/expand per your app needs)
create policy "Users can view their profile" on public.users
  for select
  using (auth.uid() = id);

create policy "Users can update their profile" on public.users
  for update
  using (auth.uid() = id);

create policy "Users can manage their customers" on public.customers
  for all
  using (auth.uid() = owner_id);

create policy "Users can manage their projects" on public.projects
  for all
  using (auth.uid() = owner_id);

create policy "Users can manage their invoices" on public.invoices
  for all
  using (auth.uid() = owner_id);
