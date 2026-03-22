import 'package:flutter/foundation.dart';

/// Supabase environment configuration.
/// Switch [_isDev] to false when shipping to production.
class SupabaseConfig {
  SupabaseConfig._();

  // ── Toggle this flag for release builds ──────────────────────────────────
  static const bool isDev = false; // ← change to false for production

  // ── Environment URLs & Keys ──────────────────────────────────────────────
  static const String _devUrl = 'https://kkgqsxjfuppvqhxiuejw.supabase.co';
  static const String _devKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImtrZ3FzeGpmdXBwdnFoeGl1ZWp3Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzMxNjA1MDMsImV4cCI6MjA4ODczNjUwM30.9oFqzGcUs03GZMLHDYVkrbAot5SeoCd3CokqHk7IEQY';

  static const String _prodUrl = 'https://dxyjubecrnjxahzvcwbs.supabase.co';
  static const String _prodKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImR4eWp1YmVjcm5qeGFoenZjd2JzIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzM1MDU2NTQsImV4cCI6MjA4OTA4MTY1NH0.Q2Gyr7zgsvWnZMgbQcsCJZc_fxi1jLFg0gp2XbWQP9w';

  static String get supabaseUrl => isDev ? _devUrl : _prodUrl;
  static String get supabaseAnonKey => isDev ? _devKey : _prodKey;

  // ── Table Prefixing ──────────────────────────────────────────────────────
  static String get userProfilesTable =>
      isDev ? 'dev_user_profiles' : 'prod_user_profiles';

  static String get environment => isDev ? 'DEVELOPMENT' : 'PRODUCTION';
}
