import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import 'auth_remote_data_source.dart';

/// Fallback data source used when Firebase has not been configured with
/// native assets (such as google-services.json) or in offline demo environments.
/// Ensures the app never crashes with `[core/no-app]` and allows full UI/UX
/// evaluation of login, registration, and logout flows.
class LocalDemoAuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  static const String _sessionUserKey = 'local_demo_auth_user_session';
  final SharedPreferences _prefs;
  final StreamController<UserModel?> _controller =
      StreamController<UserModel?>.broadcast();

  LocalDemoAuthRemoteDataSourceImpl(this._prefs) {
    _init();
  }

  void _init() {
    final user = _loadUserFromPrefs();
    _controller.add(user);
  }

  UserModel? _loadUserFromPrefs() {
    final userJson = _prefs.getString(_sessionUserKey);
    if (userJson != null) {
      try {
        final Map<String, dynamic> map =
            jsonDecode(userJson) as Map<String, dynamic>;
        return UserModel.fromJson(map);
      } catch (_) {
        return null;
      }
    }
    return null;
  }

  @override
  Stream<UserModel?> get authStateChanges => _controller.stream;

  @override
  Future<UserModel?> getCurrentUser() async {
    return _loadUserFromPrefs();
  }

  @override
  Future<UserModel> loginWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final trimmedEmail = email.trim();
    final name = trimmedEmail.split('@').first;
    final formattedName = name.isEmpty
        ? 'Employee User'
        : '${name[0].toUpperCase()}${name.substring(1)}';

    final user = UserModel(
      id: 'demo-user-${trimmedEmail.hashCode.abs()}',
      email: trimmedEmail,
      displayName: formattedName,
    );

    await _prefs.setString(_sessionUserKey, jsonEncode(user.toJson()));
    _controller.add(user);
    return user;
  }

  @override
  Future<UserModel> registerWithEmailAndPassword({
    required String email,
    required String password,
    String? displayName,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final trimmedEmail = email.trim();
    final user = UserModel(
      id: 'demo-user-${DateTime.now().millisecondsSinceEpoch}',
      email: trimmedEmail,
      displayName: (displayName != null && displayName.trim().isNotEmpty)
          ? displayName.trim()
          : trimmedEmail.split('@').first,
    );

    await _prefs.setString(_sessionUserKey, jsonEncode(user.toJson()));
    _controller.add(user);
    return user;
  }

  @override
  Future<UserModel> signInWithGoogle() async {
    await Future.delayed(const Duration(milliseconds: 500));
    const user = UserModel(
      id: 'google-demo-user-101',
      email: 'demo.employee@gmail.com',
      displayName: 'Demo Google User',
      photoUrl:
          'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde',
    );

    await _prefs.setString(_sessionUserKey, jsonEncode(user.toJson()));
    _controller.add(user);
    return user;
  }

  @override
  Future<void> sendPasswordResetEmail({required String email}) async {
    await Future.delayed(const Duration(milliseconds: 400));
  }

  @override
  Future<void> signOut() async {
    await Future.delayed(const Duration(milliseconds: 200));
    await _prefs.remove(_sessionUserKey);
    _controller.add(null);
  }
}
