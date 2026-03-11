/// Supabase environment configuration.
/// Switch [_isDev] to false when shipping to production.
class SupabaseConfig {
  SupabaseConfig._();

  // ── Toggle this flag for release builds ──────────────────────────────────
  static const bool isDev = true; // ← change to false for production

  // ── Single Project Configuration (Development & Production) ──────────────
  static const String supabaseUrl = 'https://kkgqsxjfuppvqhxiuejw.supabase.co';
  static const String supabaseAnonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImtrZ3FzeGpmdXBwdnFoeGl1ZWp3Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzMxNjA1MDMsImV4cCI6MjA4ODczNjUwM30.9oFqzGcUs03GZMLHDYVkrbAot5SeoCd3CokqHk7IEQY';

  // ── Table Prefixing ──────────────────────────────────────────────────────
  static String get userProfilesTable => isDev ? 'dev_user_profiles' : 'prod_user_profiles';

  static String get environment => isDev ? 'DEVELOPMENT' : 'PRODUCTION';
}
