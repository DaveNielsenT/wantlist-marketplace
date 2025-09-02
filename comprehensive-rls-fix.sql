-- Comprehensive RLS fix for users table
-- Run this in your Supabase SQL Editor

-- Step 1: Check current RLS status
SELECT schemaname, tablename, rowsecurity 
FROM pg_tables 
WHERE tablename = 'users';

-- Step 2: Check existing policies
SELECT * FROM pg_policies WHERE tablename = 'users';

-- Step 3: Temporarily disable RLS to test if that's the issue
ALTER TABLE users DISABLE ROW LEVEL SECURITY;

-- Step 4: Try to create a test user profile manually to see if there are other issues
-- (This will help identify if the problem is RLS or something else)

-- Step 5: If the manual insert works, re-enable RLS with proper policies
-- ALTER TABLE users ENABLE ROW LEVEL SECURITY;

-- Step 6: Drop all existing policies
DROP POLICY IF EXISTS "Users can view their own profile" ON users;
DROP POLICY IF EXISTS "Users can insert their own profile" ON users;
DROP POLICY IF EXISTS "Users can update their own profile" ON users;
DROP POLICY IF EXISTS "Users can delete their own profile" ON users;
DROP POLICY IF EXISTS "Enable read access for all users" ON users;
DROP POLICY IF EXISTS "Enable insert for authenticated users only" ON users;
DROP POLICY IF EXISTS "Enable update for users based on user_id" ON users;
DROP POLICY IF EXISTS "Enable delete for users based on user_id" ON users;

-- Step 7: Create a simple, permissive policy for testing
CREATE POLICY "Allow all operations for authenticated users" ON users
FOR ALL USING (auth.role() = 'authenticated');

-- Alternative: Create specific policies if you want more security
-- CREATE POLICY "Users can insert their own profile" ON users
-- FOR INSERT WITH CHECK (auth.uid()::text = user_id);

-- CREATE POLICY "Users can view their own profile" ON users
-- FOR SELECT USING (auth.uid()::text = user_id);

-- CREATE POLICY "Users can update their own profile" ON users
-- FOR UPDATE USING (auth.uid()::text = user_id);

-- Step 8: Verify the new policy
SELECT * FROM pg_policies WHERE tablename = 'users';
