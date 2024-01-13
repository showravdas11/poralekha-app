// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:google_sign_in/google_sign_in.dart';

// class UserController {
//   static User? user = FirebaseAuth.instance.currentUser;
//   static GoogleSignIn _googleSignIn = GoogleSignIn();

//   static Future<User?> loginWithGoogle() async {
//     try {
//       final googleAccount = await _googleSignIn.signIn();
//       if (googleAccount == null) {
//         print("doooooooooooooooooooooooo");
//         // User canceled the sign-in process
//         return null;
//       }

//       final googleAuth = await googleAccount.authentication;

//       final credential = GoogleAuthProvider.credential(
//         accessToken: googleAuth.accessToken,
//         idToken: googleAuth.idToken,
//       );

//       final userCredential =
//           await FirebaseAuth.instance.signInWithCredential(credential);

//       user = userCredential.user; // Update cached user
//       return user;
//     } catch (e) {
//       print("Error during Google sign-in: $e");
//       print("Notooooooooooooooooooooooooooooooooooooo");
//       return null;
//     }
//   }

//   static Future<void> signOut() async {
//     try {
//       await FirebaseAuth.instance.signOut();
//       await _googleSignIn.signOut();
//       user = null; // Clear cached user
//     } catch (e) {
//       print("Error during sign-out: $e");
//     }
//   }
// }
