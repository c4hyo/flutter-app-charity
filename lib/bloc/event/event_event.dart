part of 'event_bloc.dart';

@immutable
abstract class EventEvent {}
class EventIndex extends EventEvent{}
class EventCreate extends EventEvent{
  final EventModel model;
  final String token;
  final File thumbnail;
  EventCreate({
    @required this.model,
    @required this.token,
    @required this.thumbnail,
  });
}
class EventUpdate extends EventEvent{
  final int id;
  final EventModel model;
  final String token;
  final File thumbnail;
  EventUpdate({
    @required this.id,
    @required this.model,
    @required this.token,
    @required this.thumbnail,
  });
}
class EventDelete extends EventEvent{
  final int id;
  EventDelete({@required this.id});
}