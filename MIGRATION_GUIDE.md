# Firebase to Supabase Migration Guide

## Overview
This guide will help you migrate your Wantlist Marketplace application from Firebase to Supabase.

## Prerequisites
1. A Supabase account (sign up at [supabase.com](https://supabase.com))
2. Node.js and npm installed
3. Your existing Firebase project (for reference)

## Step 1: Install Supabase Dependencies

```bash
npm install @supabase/supabase-js
```

## Step 2: Set Up Supabase Project

1. **Create a new Supabase project:**
   - Go to [supabase.com](https://supabase.com)
   - Click "New Project"
   - Choose your organization
   - Enter project name (e.g., "wantlist-marketplace")
   - Enter database password (save this!)
   - Choose region closest to your users
   - Click "Create new project"

2. **Wait for project setup** (usually takes 1-2 minutes)

## Step 3: Get Supabase Credentials

1. **Go to your project dashboard**
2. **Navigate to Settings > API**
3. **Copy the following values:**
   - Project URL
   - Anon (public) key

## Step 4: Set Environment Variables

1. **Create a `.env` file in your `frontend` directory:**
```env
REACT_APP_SUPABASE_URL=your_project_url_here
REACT_APP_SUPABASE_ANON_KEY=your_anon_key_here
```

2. **Replace the placeholder values** with your actual Supabase credentials

## Step 5: Set Up Database Schema

1. **Go to your Supabase project dashboard**
2. **Navigate to SQL Editor**
3. **Copy and paste the contents of `supabase-schema.sql`**
4. **Click "Run" to execute the schema**

## Step 6: Configure Authentication

1. **Go to Authentication > Settings in your Supabase dashboard**
2. **Configure the following:**
   - Site URL: `http://localhost:3000` (for development)
   - Redirect URLs: Add your production domain when ready
   - Email templates: Customize if desired

## Step 7: Test the Migration

1. **Start your development server:**
```bash
npm start
```

2. **Test the following functionality:**
   - User registration
   - User login
   - Creating requests
   - Making offers
   - Viewing requests and offers

## Step 8: Update Production Environment

When deploying to production:

1. **Update your production environment variables**
2. **Update Site URL in Supabase Auth settings**
3. **Add your production domain to redirect URLs**

## Key Changes Made

### Authentication
- **Firebase Auth** → **Supabase Auth**
- `createUserWithEmailAndPassword` → `supabase.auth.signUp`
- `signInWithEmailAndPassword` → `supabase.auth.signInWithPassword`
- `signOut` → `supabase.auth.signOut`

### Database Operations
- **Firestore** → **Supabase Database**
- `addDoc(collection(db, 'table'))` → `supabase.from('table').insert()`
- `getDoc(doc(db, 'table', id))` → `supabase.from('table').select().eq('id', id).single()`
- `updateDoc(doc(db, 'table', id))` → `supabase.from('table').update().eq('id', id)`
- `query(collection(db, 'table'), where(), orderBy())` → `supabase.from('table').select().eq().order()`

### Field Name Changes
- `createdAt` → `created_at`
- `updatedAt` → `updated_at`
- `imageData` → `image_data`
- `requestId` → `request_id`
- `acceptedOfferId` → `accepted_offer_id`

## Troubleshooting

### Common Issues

1. **"Invalid API key" error:**
   - Check your environment variables
   - Ensure you're using the anon key, not the service role key

2. **"Table doesn't exist" error:**
   - Run the schema SQL in Supabase SQL Editor
   - Check table names match exactly

3. **Authentication not working:**
   - Verify Site URL in Supabase Auth settings
   - Check redirect URLs configuration

4. **Row Level Security errors:**
   - Ensure RLS policies are properly set up
   - Check user authentication state

### Debug Tips

1. **Check browser console** for detailed error messages
2. **Use Supabase dashboard** to inspect database tables
3. **Check Network tab** in browser dev tools for API calls
4. **Verify environment variables** are loaded correctly

## Performance Considerations

1. **Supabase uses PostgreSQL** which is generally faster than Firestore for complex queries
2. **Row Level Security** adds minimal overhead
3. **Indexes** are automatically created for better performance
4. **Real-time subscriptions** are available if needed

## Security Features

1. **Row Level Security (RLS)** ensures users can only access their own data
2. **Automatic user ID validation** prevents unauthorized access
3. **SQL injection protection** through parameterized queries
4. **JWT-based authentication** with automatic token refresh

## Next Steps

1. **Test thoroughly** in development
2. **Deploy to staging** environment
3. **Run integration tests**
4. **Deploy to production**
5. **Monitor performance** and errors
6. **Set up logging** and monitoring

## Support

- **Supabase Documentation:** [supabase.com/docs](https://supabase.com/docs)
- **Supabase Discord:** [discord.supabase.com](https://discord.supabase.com)
- **GitHub Issues:** [github.com/supabase/supabase](https://github.com/supabase/supabase)

## Rollback Plan

If you need to rollback to Firebase:

1. **Keep your Firebase project** active during migration
2. **Maintain Firebase configuration** files
3. **Use feature flags** to switch between Firebase and Supabase
4. **Test rollback procedure** before going live

---

**Note:** This migration maintains all existing functionality while providing better performance, security, and developer experience through Supabase.
