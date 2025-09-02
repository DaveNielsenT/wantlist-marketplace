-- Fix authentication flow issues
-- Run this in your Supabase SQL Editor

-- Step 1: Check if email confirmation is required
SELECT * FROM auth.config;

-- Step 2: Check if there are any users in auth.users
SELECT id, email, created_at, confirmed_at, last_sign_in_at 
FROM auth.users 
ORDER BY created_at DESC 
LIMIT 5;

-- Step 3: Check if there are any users in your custom users table
SELECT * FROM users ORDER BY created_at DESC LIMIT 5;

-- Step 4: If email confirmation is required, you can temporarily disable it:
-- UPDATE auth.config SET confirm_email_change = false, enable_signup = true;

-- Step 5: Check if there are any RLS policies blocking auth operations
SELECT * FROM pg_policies WHERE tablename = 'users';

-- Step 6: Ensure RLS is properly configured for the users table
-- If RLS is still enabled and causing issues, you can temporarily disable it:
-- ALTER TABLE users DISABLE ROW LEVEL SECURITY;

-- Step 7: Check for any triggers that might interfere
SELECT 
    trigger_name,
    event_manipulation,
    action_statement
FROM information_schema.triggers 
WHERE event_object_table = 'users';
