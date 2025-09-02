-- Test authentication and debug issues
-- Run this in your Supabase SQL Editor

-- Step 1: Check if there are any users in auth.users
SELECT 
    id, 
    email, 
    created_at, 
    confirmed_at, 
    last_sign_in_at,
    email_confirmed_at,
    phone_confirmed_at,
    banned_until,
    confirmation_sent_at,
    recovery_sent_at
FROM auth.users 
ORDER BY created_at DESC 
LIMIT 5;

-- Step 2: Check if there are any users in your custom users table
SELECT * FROM users ORDER BY created_at DESC LIMIT 5;

-- Step 3: Check if RLS is enabled on users table
SELECT 
    schemaname, 
    tablename, 
    rowsecurity
FROM pg_tables 
WHERE tablename = 'users';

-- Step 4: Check current RLS policies
SELECT * FROM pg_policies WHERE tablename = 'users';

-- Step 5: Check for any foreign key constraints
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

-- Step 6: Check if there are any triggers that might interfere
SELECT 
    trigger_name,
    event_manipulation,
    action_statement
FROM information_schema.triggers 
WHERE event_object_table = 'users';

-- Step 7: Try to manually create a test user profile
-- (Uncomment and replace 'test-user-id' with an actual user ID from step 1)
-- INSERT INTO users (username, email, user_id, created_at) 
-- VALUES ('testuser', 'test@example.com', 'test-user-id', NOW())
-- ON CONFLICT (user_id) DO NOTHING;
