import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';

// A dedicated service class to handle all Firebase Authentication operations.
class AuthService {
  // Instances of Firebase services
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Provides a stream of user authentication state changes.
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // --- Sign up with Email & Password ---
  // This method handles creating a new user with their email and password
  // and then storing their additional details in Firestore.
  Future<User?> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
    double? weight,
    double? height,
    int? age,
  }) async {
    // This will throw a FirebaseAuthException on failure, which should be caught in the UI.
    final UserCredential userCredential = await _auth
        .createUserWithEmailAndPassword(email: email, password: password);

    final User? user = userCredential.user;

    // If user creation is successful, store the extra data.
    if (user != null) {
      await _firestore.collection('users').doc(user.uid).set({
        'name': name,
        'email': email,
        'weight_kg': weight ?? 0.0,
        'height_cm': height ?? 0.0,
        'age': age ?? 0,
        'createdAt':
            Timestamp.now(), // Good practice to store creation timestamp
      });
    }
    return user;
  }

  // --- Sign in/up with Google ---
  // This method handles the entire Google Sign-In flow.
  Future<User?> signUpWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

    // If the user cancels the sign-in, return null.
    if (googleUser == null) {
      return null;
    }

    // Obtain the auth details from the request.
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    // Create a new credential for Firebase.
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Sign in to Firebase with the Google credential.
    final UserCredential userCredential = await _auth.signInWithCredential(
      credential,
    );
    final User? user = userCredential.user;

    if (user != null) {
      // If it's a new user, create their document in Firestore.
      if (userCredential.additionalUserInfo?.isNewUser ?? false) {
        await _firestore.collection('users').doc(user.uid).set({
          'name': user.displayName,
          'email': user.email,
          'weight_kg': 0.0,
          'height_cm': 0.0,
          'age': 0,
          'createdAt': Timestamp.now(),
        });
      }
    }
    return user;
  }

  // --- Sign Out ---
  // Signs the user out from both Firebase and Google.
  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }

  Future<DocumentSnapshot?> getUserDetails() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final user = auth.currentUser;
    if (user == null) return null; // Return null if no user is logged in

    try {
      // Fetch the document from the 'users' collection with the user's UID
      return await firestore.collection('users').doc(user.uid).get();
    } catch (e) {
      print("Error fetching user details: $e");
      return null;
    }
  }

  Future<User?> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final UserCredential userCredential = await _auth
          .signInWithEmailAndPassword(email: email, password: password);
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      print("Error signing in: $e");
      return null;
    }
  }

  Future<void> saveUserGoals({
    required double calorieGoal,
    required double carbsGoal,
    required double proteinGoal,
    required double fatsGoal,
  }) async {
    final user = _auth.currentUser;
    if (user == null) return; // Can't save goals if no user is logged in

    try {
      await _firestore.collection('users').doc(user.uid).update({
        'goals': {
          'calories': calorieGoal,
          'carbs': carbsGoal,
          'protein': proteinGoal,
          'fats': fatsGoal,
        },
      });
    } catch (e) {
      print("Error saving user goals: $e");
      // Optionally, re-throw the exception to handle it in the UI
      rethrow;
    }
  }
}
