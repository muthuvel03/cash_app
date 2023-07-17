import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInApi {
  static final _googleSignIn = GoogleSignIn();
  static bool isSignedIn = false;

  static Future<GoogleSignInAccount?> login() => _googleSignIn.signIn();

  static Future logout() => _googleSignIn.disconnect();

  static GoogleSignInAccount? get currentUser => _googleSignIn.currentUser;
  String? userId = GoogleSignInApi.currentUser?.id;
}
