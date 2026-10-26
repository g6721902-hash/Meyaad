-- Meyaad starter database schema.
-- IMPORTANT: enable and test RLS policies before storing real patient data.

create extension if not exists pgcrypto;

create table if not exists public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  full_name text not null,
  phone text unique,
  role text not null check (role in ('patient', 'doctor', 'admin')),
  created_at timestamptz not null default now()
);

create table if not exists public.doctors (
  id uuid primary key references public.profiles(id) on delete cascade,
  specialty text not null,
  license_number text,
  verification_status text not null default 'pending'
    check (verification_status in ('pending', 'verified', 'rejected')),
  bio text,
  created_at timestamptz not null default now()
);

create table if not exists public.clinics (
  id uuid primary key default gen_random_uuid(),
  doctor_id uuid not null references public.doctors(id),
  name text not null,
  province text not null default 'ذي قار',
  address text not null,
  latitude double precision,
  longitude double precision,
  is_active boolean not null default true,
  created_at timestamptz not null default now(),
  check (latitude is null or latitude between -90 and 90),
  check (longitude is null or longitude between -180 and 180)
);

create table if not exists public.doctor_schedules (
  id uuid primary key default gen_random_uuid(),
  clinic_id uuid not null references public.clinics(id) on delete cascade,
  weekday smallint not null check (weekday between 0 and 6),
  start_time time not null,
  end_time time not null,
  slot_minutes integer not null default 15 check (slot_minutes > 0),
  is_active boolean not null default true,
  check (end_time > start_time)
);

create table if not exists public.appointments (
  id uuid primary key default gen_random_uuid(),
  patient_id uuid not null references public.profiles(id),
  doctor_id uuid not null references public.doctors(id),
  clinic_id uuid not null references public.clinics(id),
  appointment_time timestamptz not null,
  status text not null default 'pending'
    check (status in ('pending','confirmed','cancelled','checked_in','completed','no_show')),
  created_at timestamptz not null default now()
);

create table if not exists public.queue_entries (
  id uuid primary key default gen_random_uuid(),
  appointment_id uuid not null unique references public.appointments(id) on delete cascade,
  queue_date date not null,
  queue_number integer not null check (queue_number > 0),
  status text not null default 'waiting'
    check (status in ('waiting','in_progress','completed','skipped')),
  updated_at timestamptz not null default now(),
  unique (queue_date, queue_number, appointment_id)
);

create table if not exists public.notifications (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.profiles(id) on delete cascade,
  title text not null,
  body text not null,
  read_at timestamptz,
  created_at timestamptz not null default now()
);

create index if not exists clinics_province_active_idx
  on public.clinics (province) where is_active = true;
create index if not exists appointments_doctor_time_idx
  on public.appointments (doctor_id, appointment_time);
create index if not exists appointments_patient_time_idx
  on public.appointments (patient_id, appointment_time);
create index if not exists queue_entries_date_status_idx
  on public.queue_entries (queue_date, status);

-- Before production:
-- * Enable RLS on every table and add least-privilege policies.
-- * Assign roles server-side; never let users self-select doctor/admin.
-- * Create transaction-safe booking and queue-number functions.
-- * Prevent overlapping bookings with server-side transactions/constraints.
-- * Restrict access to appointment/patient data to the patient, assigned doctor,
--   and explicitly authorized clinic staff.
-- * Verify doctor licenses before listing a doctor publicly.
