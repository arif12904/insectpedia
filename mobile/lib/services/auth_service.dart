import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fungsi untuk registrasi akun pengguna
  Future<UserModel?> register({
    required String email,
    required String password,
    required String name,
    required String avatarPath,
  }) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await result.user!.updateDisplayName(name);
      await result.user!.updatePhotoURL(avatarPath);

      final userModel = UserModel(
        uid: result.user!.uid,
        email: email,
        displayName: name,
        photoUrl: avatarPath,
      );

      await _saveUserToFirestore(userModel);
      return userModel;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    }
  }

  // Fungsi untuk log in ke akun pengguna
  Future<UserModel?> login(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return await _getUserFromFirestore(result.user!.uid) ??
          UserModel.fromFirebase(result.user!);
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    }
  }

  // Fungsi untuk melakukan log out akun pengguna
  Future<void> logout() async {
    await _auth.signOut();
  }

  // Fungsi untuk mengambil data user
  Stream<UserModel?> get user {
    return _auth.authStateChanges().asyncMap((user) async {
      if (user == null) return null;
      return await _getUserFromFirestore(user.uid) ??
          UserModel.fromFirebase(user);
    });
  }

  // Fungsi untuk menyimpan akun pengguna ke firestore
  Future<void> _saveUserToFirestore(UserModel user) async {
    await _firestore.collection('users').doc(user.uid).set(user.toMap());
  }

  // fungsi untuk mengambil data akun pengguna dari firestore
  Future<UserModel?> _getUserFromFirestore(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    if (doc.exists) {
      return UserModel.fromMap(doc.data()!, doc.id);
    }
    return null;
  }

  // Fungsi untuk melakukan Update Profile
  Future<void> updateProfile({
    String? displayName,
    String? photoUrl,
  }) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('Tidak ada pengguna yang login');

    // Update ke Firebase Auth
    if (displayName != null) await user.updateDisplayName(displayName);
    if (photoUrl != null) await user.updatePhotoURL(photoUrl);

    // Update ke Firestore
    final updateData = <String, dynamic>{};
    if (displayName != null) updateData['displayName'] = displayName;
    if (photoUrl != null) updateData['photoUrl'] = photoUrl;

    if (updateData.isNotEmpty) {
      await _firestore.collection('users').doc(user.uid).update(updateData);
    }
  }

  // Fungsi untuk menghapus akun pengguna
  Future<void> deleteAccount() async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('Tidak ada pengguna yang login');

    // Hapus dari Firestore
    await _firestore.collection('users').doc(user.uid).delete();

    // Hapus akun di Firebase Auth
    await user.delete();
  }

}
