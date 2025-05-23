import { getDb } from '@meridian/database';
import { useRuntimeConfig } from '#imports';

export default defineEventHandler(async event => {
  const db = getDb(useRuntimeConfig(event).DATABASE_URL);
  const reports = await db.query.$reports.findMany();

  const config = useRuntimeConfig();
  console.log('DATABASE_URL from Nuxt Runtime Config:', config.DATABASE_URL); // Check server-side var
  console.log('DATABASE_URL from process.env:', process.env.DATABASE_URL); // Check direct env var

  // Process reports to add date and slug
  const processedReports = reports
    .map(report => {
      // Ensure createdAt is a valid Date object and work with UTC
      const createdAt = report.createdAt ? new Date(report.createdAt) : new Date();

      // Use UTC methods to avoid timezone issues
      const monthNames = [
        'January',
        'February',
        'March',
        'April',
        'May',
        'June',
        'July',
        'August',
        'September',
        'October',
        'November',
        'December',
      ];
      const month = monthNames[createdAt.getUTCMonth()];
      const day = createdAt.getUTCDate();
      const year = createdAt.getUTCFullYear();

      return {
        ...report,
        date: { month, day, year },
        slug: `${month.toLowerCase()}-${day}-${year}`,
      };
    })
    .sort((a, b) => {
      const dateA = a.createdAt ? new Date(a.createdAt).getTime() : 0;
      const dateB = b.createdAt ? new Date(b.createdAt).getTime() : 0;
      return dateB - dateA;
    });

  return processedReports;
});
