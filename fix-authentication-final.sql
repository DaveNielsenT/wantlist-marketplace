-- Final fix for authentication issues with current Supabase version
-- Run this in your Supabase SQL Editor

-- Step 1: Check current user status (don't try to update confirmed_at)
SELECT id, email, created_at, confirmed_at, last_sign_in_at, email_confirmed_at
FROM auth.users 
ORDER BY created_at DESC 
LIMIT 5;

-- Step 2: Check if there are any RLS policies blocking the users table
SELECT * FROM pg_policies WHERE tablename = 'users';

-- Step 3: Check for foreign key constraints that might be blocking inserts
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

-- Step 4: Drop any problematic foreign key constraints
ALTER TABLE users DROP CONSTRAINT IF EXISTS users_user_id_fkey;

-- Step 5: Temporarily disable RLS on users table to test
ALTER TABLE users DISABLE ROW LEVEL SECURITY;

-- Step 6: Check the users table structure
SELECT column_name, data_type, is_nullable, column_default
FROM information_schema.columns 
WHERE table_name = 'users' 
ORDER BY ordinal_position;

-- Step 7: Try to manually insert a test user profile to see if it works
-- (Replace 'test-user-id' with an actual user ID from auth.users)
-- INSERT INTO users (username, email, user_id, created_at) 
-- VALUES ('testuser', 'test@example.com', 'test-user-id', NOW());

-- Step 8: If manual insert works, re-enable RLS with proper policies
-- ALTER TABLE users ENABLE ROW LEVEL SECURITY;
-- CREATE POLICY "Allow all operations for authenticated users" ON users
-- FOR ALL USING (auth.role() = 'authenticated');
