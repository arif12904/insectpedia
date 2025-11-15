import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();

  UserModel? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;

  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  AuthProvider() {
    _authService.user.listen((user) {
      _currentUser = user;
      notifyListeners();
    });
  }

  /// Register user
  Future<void> register({
    required String email,
    required String password,
    required String name,
    required String avatarPath,
  }) async {
    _setLoading(true);
    try {
      _errorMessage = null;
      final user = await _authService.register(
        email: email,
        password: password,
        name: name,
        avatarPath: avatarPath,
      );
      _currentUser = user;

      // Simpan status login
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);

    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  /// Login user
  Future<void> login(String email, String password) async {
    _setLoading(true);
    try {
      _errorMessage = null;
      final user = await _authService.login(email, password);
      _currentUser = user;

      // Simpan status login
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);

    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  /// Logout user
  Future<void> logout() async {
    await _authService.logout();
    _currentUser = null;

    // Hapus status login
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);

    notifyListeners();
  }

  Future<void> updateProfile({
    String? displayName,
    String? photoUrl,
  }) async {
    _setLoading(true);
    try {
      _errorMessage = null;

      // Panggil fungsi update di AuthService
      await _authService.updateProfile(
        displayName: displayName,
        photoUrl: photoUrl,
      );

      if (_currentUser != null) {
        _currentUser = _currentUser!.copyWith(
          displayName: displayName ?? _currentUser!.displayName,
          photoUrl: photoUrl ?? _currentUser!.photoUrl,
        );
      }

      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> deleteAccount() async {
    _setLoading(true);
    try {
      await _authService.deleteAccount();
      _currentUser = null;

      // Hapus status login
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', false);

      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
