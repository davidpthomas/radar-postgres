# radar-postgres
Postgres server for Project Radar providing persistent storage pertaining to every workspace created.

This server contains databases for development, test, staging, and production.

The database manages unique workspace builds (as jobs) and caches artifacts created in Rally for quick lookup.
