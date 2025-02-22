import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:spotify_red_app/data/models/auth/create_user_req.dart';
import 'package:spotify_red_app/data/models/auth/signin_user_req.dart';

abstract class AuthFirebaseService {
  Future<Either> signup(CreateUserReq createUserReq);
  Future<Either> signin(SigninUserReq signinUserReq);
}

class AuthFirebaseServiceImpl extends AuthFirebaseService {
  @override
  Future<Either> signin(SigninUserReq signinUserReq) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: signinUserReq.email,
        password: signinUserReq.password
      );

      return Right('Signin was Successful');
    } on FirebaseAuthException catch(e) {
      String message = "";

      if(e.code == 'invalid-credential') {
        message = 'Incorrect password';
      } else if(e.code == 'invalid-email') {
        message = 'Account not found';
      }

      return Left(message);
    }
  }

  @override
  Future<Either> signup(CreateUserReq createUserReq) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: createUserReq.email,
        password: createUserReq.password
      );

      return Right('Signup was Successful');
    } on FirebaseAuthException catch(e) {
      String message = "";

      if(e.code == 'weak-password') {
        message = 'The password provided is too weak';
      } else if(e.code == 'email-already-in-use') {
        message = 'An account already exists with that email';
      }

      return Left(message);
    }
  }
}