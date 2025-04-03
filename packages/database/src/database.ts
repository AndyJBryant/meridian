import { drizzle } from 'drizzle-orm/postgres-js';
import postgres from 'postgres';

import * as schema from './schema';

export const client = (url: string, options?: postgres.Options<{}> | undefined) => {
  console.log('Attempting database connection with:', {
    // Sanitize the URL to hide password
    sanitizedUrl: url.replace(/:([^:@]{1,})?@/, ':****@')
  });
  return postgres(url, options);
};

export const getDb = (url: string, options?: postgres.Options<{}> | undefined) =>
  drizzle(client(url, options), { schema });
