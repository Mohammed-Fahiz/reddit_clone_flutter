import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:reddit_clone/core/constants/constants.dart';
import 'package:reddit_clone/core/constants/firebase_constants.dart';
import 'package:reddit_clone/core/failure.dart';
import 'package:reddit_clone/core/providers/firebase_providers.dart';
import 'package:reddit_clone/core/type_def.dart';
import 'package:reddit_clone/models/userModel.dart';

final authRepositoryProvider = Provider(
  (ref) => AuthRepository(
      fireStore: ref.read(fireStoreProvider),
      googleSignIn: ref.read(googleSignInProvider),
      auth: ref.read(firebaseAuthProvider)),
);

class AuthRepository {
  final GoogleSignIn _googleSignIn;
  final FirebaseFirestore _fireStore;
  final FirebaseAuth _auth;
  AuthRepository(
      {required FirebaseFirestore fireStore,
      required GoogleSignIn googleSignIn,
      required FirebaseAuth auth})
      : _fireStore = fireStore,
        _googleSignIn = googleSignIn,
        _auth = auth;

  CollectionReference get _users =>
      _fireStore.collection(FirebaseConstants.usersCollection);

  Stream<User?> get authStateChange => _auth.authStateChanges();

  FutureEither<UserModel> signInWithGoogle() async {
    UserModel userModel;
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      final googleAuth = await googleUser?.authentication;
      AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken, idToken: googleAuth?.idToken);
      UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      User user = userCredential.user!;
      if (userCredential.additionalUserInfo!.isNewUser) {
        userModel = UserModel(
            name: user.displayName ?? "No name",
            profilePic: Constants.avatarDefault,
            banner: Constants.bannerDefault,
            isGuest: false,
            awards: [],
            karma: 0,
            uid: user.uid);
        await _users.doc(user.uid).set(userModel.toMap());
      } else {
        userModel = await getUserData(user.uid).first;
      }
      return right(userModel);
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (ex) {
      return left(
        Failure(
          message: ex.toString(),
        ),
      );
    }
  }

  Stream<UserModel> getUserData(String uid) {
    return _users.doc(uid).snapshots().map(
        (event) => UserModel.fromMap(event.data() as Map<String, dynamic>));
  }
}
