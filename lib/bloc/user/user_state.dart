part of 'user_bloc.dart';

@immutable
abstract class UserState {}

class UserInitial extends UserState {}
class UserWaiting extends UserState {}
class UserSuccess extends UserState{
  final String message;
  UserSuccess({this.message});
}
class UserError extends UserState{
  final String message;
  UserError({this.message});
}
class UserLoginSuccess extends UserState{
  final UserModel model;
  UserLoginSuccess({this.model});
}
class UserLoad extends UserState{
  final List<UserModel> model;
  UserLoad({this.model});
}
