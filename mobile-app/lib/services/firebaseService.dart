import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/web.dart';
import 'package:spendwise/models/transaction.dart';
import 'package:cloud_firestore/cloud_firestore.dart' hide Transaction;

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> login(String email, String password) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential.user;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'invalid-email':
          throw 'Invalid email format.';
        case 'user-disabled':
          throw 'User account is disabled.';
        case 'user-not-found':
          throw 'No user found with this email.';
        case 'wrong-password':
          throw 'Incorrect password.';
        default:
          Logger().e('Login failed: ${e.message}');
          throw 'Login Failed!';
      }
    } catch (e) {
      throw 'Login Failed';
    }
  }

  Future<User?> createAccount(String email, String password) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await FirebaseFirestore.instance
          .collection("users")
          .doc(credential.user?.uid)
          .set({"email": email, password: password});
      return credential.user;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'email-already-in-use':
          throw 'Email already exists.';
        case 'invalid-email':
          throw 'Invalid email format.';
        case 'operation-not-allowed':
          throw 'Email/password accounts are not enabled.';
        case 'weak-password':
          throw 'Password is too weak.';
        default:
          Logger().e('Account creation failed: ${e.message}');
          throw 'Account creation failed!';
      }
    } catch (e) {
      throw 'Account creation failed';
    }
  }

  Future<void> logout() async {
    try {
      await _auth.signOut();
    } catch (e) {
      Logger().e('Logout failed: $e');
      throw 'Logout Failed';
    }
  }

  Future<List<Transaction>> getTransactions(String userId) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection("transactions")
          .where('userId', isEqualTo: userId)
          .get();

      return querySnapshot.docs
          .map((doc) => Transaction.fromMap({"id": doc.id, ...doc.data()}))
          .toList();
    } catch (e) {
      Logger().e('Failed to fetch transactions: $e');
      throw 'Failed to fetch transactions';
    }
  }

  Future<void> createTransaction(String userId, Transaction transaction) async {
    try {
      await FirebaseFirestore.instance
          .collection("transactions")
          .doc()
          .set(transaction.toMap());
    } catch (e) {
      Logger().e('Failed to create transaction: $e');
      throw 'Failed to create transaction';
    }
  }

  Future<void> editTransaction(
    String userId,
    String txnId,
    String name,
    int amount,
  ) async {
    try {
      await FirebaseFirestore.instance
          .collection("transactions")
          .doc(txnId)
          .update({'name': name, 'amount': amount});
    } catch (e) {
      Logger().e('Failed to edit transaction: $e');
      throw 'Failed to edit transaction';
    }
  }

  Future<void> deleteTransaction(String userId, String txnId) async {
    try {
      await FirebaseFirestore.instance
          .collection("transactions")
          .doc(txnId)
          .delete();
    } catch (e) {
      Logger().e('Failed to delete transaction: $e');
      throw 'Failed to delete transaction';
    }
  }
}
