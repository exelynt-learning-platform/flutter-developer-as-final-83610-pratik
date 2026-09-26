import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/errors/exceptions.dart';
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

  static const String _registeredUsersKey = 'local_demo_registered_users';

  Map<String, Map<String, dynamic>> _getRegisteredUsers() {
    final data = _prefs.getString(_registeredUsersKey);
    if (data != null) {
      try {
        final decoded = jsonDecode(data) as Map<String, dynamic>;
        return decoded.map((k, v) => MapEntry(k.toLowerCase(), Map<String, dynamic>.from(v as Map)));
      } catch (_) {
        return _seedDefaultUsers();
      }
    }
    return _seedDefaultUsers();
  }

  Map<String, Map<String, dynamic>> _seedDefaultUsers() {
    final initial = {
      'alex.turner@company.com': {
        'id': 'demo-user-alex',
        'displayName': 'Alex Turner',
        'password': 'Password123!',
      },
    };
    _prefs.setString(_registeredUsersKey, jsonEncode(initial));
    return initial;
  }

  @override
  Future<UserModel> loginWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final trimmedEmail = email.trim().toLowerCase();
    final registeredUsers = _getRegisteredUsers();

    if (!registeredUsers.containsKey(trimmedEmail)) {
      throw const AuthException(
        message: 'Email not registered',
        code: 'user-not-found',
      );
    }

    final userData = registeredUsers[trimmedEmail]!;
    if (userData['password'] != password) {
      throw const AuthException(
        message: 'Incorrect password',
        code: 'wrong-password',
      );
    }

    final user = UserModel(
      id: userData['id'] as String? ?? 'demo-user-${trimmedEmail.hashCode.abs()}',
      email: email.trim(),
      displayName: userData['displayName'] as String? ?? 'Employee User',
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
    await Future.delayed(const Duration(milliseconds: 400));
    final trimmedEmail = email.trim().toLowerCase();
    final registeredUsers = _getRegisteredUsers();

    final formattedName = (displayName != null && displayName.trim().isNotEmpty)
        ? displayName.trim()
        : email.trim().split('@').first;

    final user = UserModel(
      id: 'demo-user-${DateTime.now().millisecondsSinceEpoch}',
      email: email.trim(),
      displayName: formattedName,
    );

    registeredUsers[trimmedEmail] = {
      'id': user.id,
      'displayName': user.displayName,
      'password': password,
    };

    await _prefs.setString(_registeredUsersKey, jsonEncode(registeredUsers));
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
