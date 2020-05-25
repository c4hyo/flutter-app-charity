import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:charity_app_new/model/user_model.dart';
import 'package:charity_app_new/repository/user_repository.dart';
import 'package:meta/meta.dart';

part 'user_event.dart';
part 'user_state.dart';

UserRepository _user = UserRepository();

class UserBloc extends Bloc<UserEvent, UserState> {
  @override
  UserState get initialState => UserInitial();

  @override
  Stream<UserState> mapEventToState(
    UserEvent event,
  ) async* {
    if(event is UserLogin){
      yield* _userLogin(event.model);
    }else if(event is UserRegistration){
      yield* _userRegistration(event.model);
    }else if(event is UserIndex){
      yield* _userIndex();
    }else if(event is UserUpdate){
      yield* _userUpdate(event.id,event.model);
    }else if(event is UserDelete){
      yield* _userDelete(event.id);
    }
  }
}
Stream<UserState> _userLogin(model) async*{
  yield UserWaiting();
  try{
    UserModel models = await _user.login(model: model);
    yield UserLoginSuccess(model: models);
  }catch(e){
    yield UserError(message: e.toString());
  }
}
Stream<UserState> _userRegistration(model) async*{
  yield UserWaiting();
  try{
    int status = await _user.register(model: model);
    yield UserSuccess(message: status.toString());
  }catch(e){
    yield UserError(message: e.toString());
  }
}
Stream<UserState> _userIndex() async*{
  yield UserWaiting();
  try{
    List<UserModel> models = await _user.index();
    yield UserLoad(model: models);
  }catch(e){
    yield UserError(message: e.toString());
  }
}
Stream<UserState> _userUpdate(id,model) async*{
  yield UserWaiting();
  try{
    int status = await _user.update(id: id,model: model);
    yield UserSuccess(message: status.toString());
  }catch(e){
    yield UserError(message: e.toString());
  }
}
Stream<UserState> _userDelete(id) async*{
  yield UserWaiting();
  try{
    int status = await _user.delete(id:id);
    yield UserSuccess(message: status.toString());
  }catch(e){
    yield UserError(message: e.toString());
  }
}