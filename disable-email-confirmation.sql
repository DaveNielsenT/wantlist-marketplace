-- Disable email confirmation in Supabase
-- Run this in your Supabase SQL Editor

-- Step 1: Check current auth configuration
SELECT * FROM auth.config;

-- Step 2: Disable email confirmation
UPDATE auth.config SET 
    confirm_email_change = false,
    enable_signup = true,
    enable_confirmations = false;

-- Step 3: Verify the changes
SELECT * FROM auth.config;

-- Step 4: If the above doesn't work, try this alternative approach:
-- UPDATE auth.config SET 
--     confirm_email_change = false,
--     enable_signup = true,
--     enable_confirmations = false,
--     mailer_autoconfirm = true;

-- Step 5: Check if there are any existing unconfirmed users
SELECT id, email, created_at, confirmed_at, last_sign_in_at 
FROM auth.users 
WHERE confirmed_at IS NULL
ORDER BY created_at DESC;

-- Step 6: Optionally, confirm any existing unconfirmed users
-- UPDATE auth.users SET confirmed_at = NOW() WHERE confirmed_at IS NULL;
