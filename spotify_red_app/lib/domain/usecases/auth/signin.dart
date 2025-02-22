import 'package:dartz/dartz.dart';
import 'package:spotify_red_app/core/usecase/usecase.dart';
import 'package:spotify_red_app/data/models/auth/signin_user_req.dart';
import 'package:spotify_red_app/domain/repository/auth/auth.dart';
import 'package:spotify_red_app/service_locator.dart';

class SigninUseCase implements Usecase<Either,SigninUserReq> {
  @override
  Future<Either> call({SigninUserReq ? params}) async {
    return sl<AuthRepository>().signin(params!);
  }
}