part of 'post_bloc.dart';

@immutable
abstract class PostState {}

class PostInitial extends PostState {}
class PostWaiting extends PostState {}
class PostLoad extends PostState{
  final List<PostModel> model;
  PostLoad({this.model});
}
class PostSuccess extends PostState{
  final String messege;
  PostSuccess({this.messege});
}
class PostError extends PostState{
  final String message;
  PostError({this.message});
}