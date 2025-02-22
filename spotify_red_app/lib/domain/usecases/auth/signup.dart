import 'package:dartz/dartz.dart';
import 'package:spotify_red_app/core/usecase/usecase.dart';
import 'package:spotify_red_app/data/models/auth/create_user_req.dart';
import 'package:spotify_red_app/domain/repository/auth/auth.dart';
import 'package:spotify_red_app/service_locator.dart';

class SignupUseCase implements Usecase<Either,CreateUserReq> {
  @override
  Future<Either> call({CreateUserReq ? params}) async {
    return sl<AuthRepository>().signup(params!);
  }
}