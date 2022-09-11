import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider of the Firestore instance for the whole app.
///
/// It was created in order to override it with mocked version while testing.
final firestoreProvider = Provider((_) => FirebaseFirestore.instance);
