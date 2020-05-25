part of 'event_bloc.dart';

@immutable
abstract class EventState {}

class EventInitial extends EventState {}
class EventWaiting extends EventState {}
class EventLoad extends EventState{
  final List<EventModel> model;
  EventLoad({this.model});
}
class EventSuccess extends EventState{
  final String messege;
  EventSuccess({this.messege});
}
class EventError extends EventState{
  final String messege;
  EventError({this.messege});
}