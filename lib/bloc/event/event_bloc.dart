import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:charity_app_new/model/event_model.dart';
import 'package:charity_app_new/repository/event_respository.dart';
import 'package:meta/meta.dart';

part 'event_event.dart';
part 'event_state.dart';

EventRepository event = EventRepository();

class EventBloc extends Bloc<EventEvent, EventState> {
  @override
  EventState get initialState => EventInitial();

  @override
  Stream<EventState> mapEventToState(
    EventEvent event,
  ) async* {
    if(event is EventIndex){
      yield* _eventIndex();
    }if(event is EventCreate){
      yield* _eventCreate(event.model, event.token, event.thumbnail);
    }if(event is EventUpdate){
      yield* _eventUpdate(event.id, event.model, event.token, event.thumbnail);
    }if(event is EventDelete){
      yield* _eventDelete(event.id);
    }
  }
}
Stream<EventState> _eventIndex() async*{
  yield EventWaiting();
  try{
    List<EventModel> model = await event.index();
    yield EventLoad(model: model);
  }catch(e){
    yield EventError(messege: e.toString());
  }
}
Stream<EventState> _eventCreate(model,token,thumbnail) async*{
  yield EventWaiting();
  try{
    int status = await event.create(model: model,thumbnail: thumbnail,token:token);
    yield EventSuccess(messege: status.toString());
  }catch(e){
    yield EventError(messege: e.toString());
  }
}
Stream<EventState> _eventUpdate(id,model,token,thumbnail) async*{
  yield EventWaiting();
  try{
    int status = await event.update(id:id,model:model,token:token,thumbnail:thumbnail);
    yield EventSuccess(messege: status.toString());
  }catch(e){
    yield EventError(messege: e.toString());
  }
}
Stream<EventState> _eventDelete(id) async*{
  yield EventWaiting();
  try{
    int s = await event.delete(id:id);
    yield EventSuccess(messege: s.toString());
  }catch(e){
    yield EventError(messege: e.toString());
  }
}
