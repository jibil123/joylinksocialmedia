// import 'package:firebase_auth/firebase_auth.dart' as FirebaseAuth;
// import 'package:firebase_auth/firebase_auth.dart' show User;

// Future<User?> checkIfUserExists(String email) async {
//   try {
//     // Query the Firebase Authentication users list for the provided email
//     final userRecords = await FirebaseAuth.FirebaseAuth.instance
//         .fetchSignInMethodsForEmail(email)
//         .then((value) => value);
//     if (userRecords.isNotEmpty) {
//       // User exists
//       return FirebaseAuth.FirebaseAuth.instance.currentUser;
//     } else {
//       // User doesn't exist
//       return null;
//     }
//   } catch (e) {
//     return null;
//   }
// }
