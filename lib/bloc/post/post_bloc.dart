import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:charity_app_new/model/post_model.dart';
import 'package:charity_app_new/repository/post_repository.dart';
import 'package:meta/meta.dart';

part 'post_event.dart';
part 'post_state.dart';

PostRepository _post = new PostRepository();

class PostBloc extends Bloc<PostEvent, PostState> {
  @override
  PostState get initialState => PostInitial();

  @override
  Stream<PostState> mapEventToState(
    PostEvent event,
  ) async* {
    if(event is PostIndex){
      yield* _postIndex();
    }else if(event is PostCreate){
      yield* _postCreate(event.model,event.token,event.thumbnail);
    }else if(event is PostUpdate){
      yield* _postUpdate(event.id,event.model,event.token,event.thumbnail);
    }else if(event is PostDelete){
      yield* _postDelete(event.id);
    }
  }
}
Stream<PostState>_postIndex() async*{
  yield PostWaiting();
  try{
    List<PostModel> model = await _post.index();
    yield PostLoad(model: model);
  }catch(e){
    yield PostError(message: e.toString());
  }
}
Stream<PostState>_postCreate(model,token,thumbnail) async*{
  yield PostWaiting();
  try{
    int status = await _post.create(model: model,thumbnail: thumbnail,token:token);
    yield PostSuccess(messege: status.toString());
  }catch(e){
    yield PostError(message: e.toString());
  }
}
Stream<PostState>_postUpdate(id,model,token,thumbnail) async*{
  yield PostWaiting();
  try{
    int status = await _post.update(id:id,model:model,token:token,thumbnail:thumbnail);
    yield PostSuccess(messege: status.toString());
  }catch(e){
    yield PostError(message: e.toString());
  }
}
Stream<PostState>_postDelete(id) async*{
  yield PostWaiting();
  try{
    int s = await _post.delete(id:id);
    yield PostSuccess(messege: s.toString());
  }catch(e){
    yield PostError(message: e.toString());
  }
}