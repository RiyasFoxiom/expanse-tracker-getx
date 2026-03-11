import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:test_app/core/config/supabase_config.dart';
import 'package:test_app/data/models/user_profile.dart';

/// Wraps Supabase Auth operations and exposes reactive state.
class SupabaseAuthService extends GetxService {
  static SupabaseAuthService get to => Get.find();

  SupabaseClient get _client => Supabase.instance.client;

  // ── Reactive ─────────────────────────────────────────────────────────────
  final Rxn<User> currentUser = Rxn<User>();
  final Rxn<UserProfile> profile = Rxn<UserProfile>();
  final RxBool isLoggedIn = false.obs;

  @override
  void onInit() {
    super.onInit();
    _syncSession();
    _client.auth.onAuthStateChange.listen((data) {
      if (currentUser.value?.id != data.session?.user.id) {
        currentUser.value = data.session?.user;
        isLoggedIn.value = data.session != null;
        if (data.session != null) {
          _fetchProfile(data.session!.user.id);
        } else {
          profile.value = null;
        }
      }
    });
  }

  Future<void> _syncSession() async {
    final session = _client.auth.currentSession;
    currentUser.value = session?.user;
    isLoggedIn.value = session != null;
    if (session != null) {
      await _fetchProfile(session.user.id);
    } else {
      profile.value = null;
    }
  }

  Future<void> _fetchProfile(String uid) async {
    try {
      final data = await _client
          .from(SupabaseConfig.userProfilesTable)
          .select()
          .eq('id', uid)
          .maybeSingle();

      if (data != null) {
        profile.value = UserProfile.fromJson(data);
      }
    } catch (e) {
      print('Error fetching user profile: $e');
    }
  }

  // ── Sign Up ───────────────────────────────────────────────────────────────
  Future<AuthResponse> signUp({
    required String email,
    required String password,
    String? name,
  }) async {
    final data = <String, dynamic>{
      'environment': SupabaseConfig.isDev ? 'dev' : 'prod',
    };
    if (name != null && name.isNotEmpty) {
      data['display_name'] = name;
    }

    return await _client.auth.signUp(
      email: email, 
      password: password,
      data: data,
    );
  }

  // ── Sign In ───────────────────────────────────────────────────────────────
  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    return await _client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  // ── Sign Out ──────────────────────────────────────────────────────────────
  Future<void> signOut() async {
    await _client.auth.signOut();
  }

  // ── Password Reset ────────────────────────────────────────────────────────
  Future<void> resetPassword(String email) async {
    await _client.auth.resetPasswordForEmail(email);
  }

  // ── Getters ───────────────────────────────────────────────────────────────
  User? get user => _client.auth.currentUser;
  String get userEmail => profile.value?.email ?? user?.email ?? '';
  String get userDisplayName => profile.value?.displayName ?? '';
  String get userId => user?.id ?? '';
  bool get hasSession => _client.auth.currentSession != null;
}
