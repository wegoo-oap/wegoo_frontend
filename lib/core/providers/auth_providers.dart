import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Firebase instances
final firebaseAuthProvider = Provider<FirebaseAuth>(
  (_) => FirebaseAuth.instance,
);

final firestoreProvider = Provider<FirebaseFirestore>(
  (_) => FirebaseFirestore.instance,
);

// Auth state stream — drives the splash redirect
final authStateProvider = StreamProvider<User?>(
  (ref) => ref.watch(firebaseAuthProvider).authStateChanges(),
);

// Stores verificationId between phone entry and OTP screens
final verificationIdProvider = StateProvider<String?>((_) => null);

// Stores phone number for display on OTP screen
final phoneNumberProvider = StateProvider<String?>((_) => null);
