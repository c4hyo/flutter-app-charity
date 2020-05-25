part of 'user_bloc.dart';

@immutable
abstract class UserEvent {}
class UserLogin extends UserEvent{
  final UserModel model;
  UserLogin({@required this.model});
}
class UserRegistration extends UserEvent{
  final UserModel model;
  UserRegistration({@required this.model});
}
class UserIndex extends UserEvent{}
class UserUpdate extends UserEvent{
  final int id;
  final UserModel model;
  UserUpdate({@required this.id,@required this.model});
}
class UserDelete extends UserEvent{
  final int id;
  UserDelete({@required this.id});
}