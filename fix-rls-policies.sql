-- Fix RLS policies for users table
-- Run this in your Supabase SQL Editor

-- First, let's check the current policies
SELECT * FROM pg_policies WHERE tablename = 'users';

-- Drop existing policies if they exist
DROP POLICY IF EXISTS "Users can view their own profile" ON users;
DROP POLICY IF EXISTS "Users can insert their own profile" ON users;
DROP POLICY IF EXISTS "Users can update their own profile" ON users;
DROP POLICY IF EXISTS "Users can delete their own profile" ON users;

-- Create new policies that allow proper access

-- Policy 1: Allow users to insert their own profile
CREATE POLICY "Users can insert their own profile" ON users
FOR INSERT WITH CHECK (auth.uid() = user_id);

-- Policy 2: Allow users to view their own profile
CREATE POLICY "Users can view their own profile" ON users
FOR SELECT USING (auth.uid() = user_id);

-- Policy 3: Allow users to update their own profile
CREATE POLICY "Users can update their own profile" ON users
FOR UPDATE USING (auth.uid() = user_id);

-- Policy 4: Allow users to delete their own profile
CREATE POLICY "Users can delete their own profile" ON users
FOR DELETE USING (auth.uid() = user_id);

-- Verify the policies were created
SELECT * FROM pg_policies WHERE tablename = 'users';
