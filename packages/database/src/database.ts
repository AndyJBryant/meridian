import { drizzle } from 'drizzle-orm/postgres-js';
import postgres from 'postgres';

import * as schema from './schema';

export const client = (url: string, options?: postgres.Options<{}> | undefined) => {
  if (!url) {
    console.error('Database URL is empty! Please check your environment variables.');
    console.log('Process env:', {
      NODE_ENV: process.env.NODE_ENV,
      // Log existence of DATABASE_URL without exposing sensitive data
      HAS_DATABASE_URL: !!process.env.DATABASE_URL,
    });
    throw new Error('Database URL is required');
  }

  console.log('Attempting database connection with:', {
    sanitizedUrl: url.replace(/:([^:@]{1,})?@/, ':****@'),
    options: options ? JSON.stringify(options) : 'none'
  });
  
  return postgres(url, options);
};

export const getDb = (url: string, options?: postgres.Options<{}> | undefined) =>
  drizzle(client(url, options), { schema });
