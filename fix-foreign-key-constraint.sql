-- Fix foreign key constraint issue for users table
-- Run this in your Supabase SQL Editor

-- Step 1: Check the current foreign key constraints
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

-- Step 2: Drop the problematic foreign key constraint
ALTER TABLE users DROP CONSTRAINT IF EXISTS users_user_id_fkey;

-- Step 3: Check if there are any other foreign key constraints
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

-- Step 4: Verify the users table structure
SELECT column_name, data_type, is_nullable, column_default
FROM information_schema.columns 
WHERE table_name = 'users' 
ORDER BY ordinal_position;

-- Step 5: If you want to re-add the foreign key constraint with proper options, uncomment this:
-- ALTER TABLE users 
-- ADD CONSTRAINT users_user_id_fkey 
-- FOREIGN KEY (user_id) 
-- REFERENCES auth.users(id) 
-- ON DELETE CASCADE 
-- DEFERRABLE INITIALLY DEFERRED;

-- Step 6: Test by trying to insert a user profile
-- (This should now work without the foreign key constraint error)
