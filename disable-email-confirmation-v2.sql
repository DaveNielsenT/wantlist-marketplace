-- Alternative approach to disable email confirmation
-- Run this in your Supabase SQL Editor

-- Step 1: Check if there are any existing unconfirmed users
SELECT id, email, created_at, confirmed_at, last_sign_in_at 
FROM auth.users 
WHERE confirmed_at IS NULL
ORDER BY created_at DESC;

-- Step 2: Confirm any existing unconfirmed users (this will allow them to log in)
UPDATE auth.users 
SET confirmed_at = NOW() 
WHERE confirmed_at IS NULL;

-- Step 3: Verify the changes
SELECT id, email, created_at, confirmed_at, last_sign_in_at 
FROM auth.users 
ORDER BY created_at DESC 
LIMIT 5;

-- Step 4: Check if there are any RLS policies that might be blocking auth
SELECT * FROM pg_policies WHERE tablename = 'users';

-- Step 5: If RLS is still causing issues, temporarily disable it
-- ALTER TABLE users DISABLE ROW LEVEL SECURITY;

-- Step 6: Check for any foreign key constraints that might be blocking inserts
SELECT 
    tc.constraint_name, 
    tc.table_name, 
    kcu.column_name, 
    ccu.table_name AS foreign_table_name,
    ccu.column_name AS foreign_column_name 
FROM 
    information_schema.table_constraints AS tc 
    JOIN information_schema.key_column_usage AS kcu
      ON tc.constraint_name = kcu.constraint_name
      AND tc.table_schema = kcu.table_schema
    JOIN information_schema.constraint_column_usage AS ccu
      ON ccu.constraint_name = tc.constraint_name
      AND ccu.table_schema = tc.table_schema
WHERE tc.constraint_type = 'FOREIGN KEY' 
    AND tc.table_name='users';
