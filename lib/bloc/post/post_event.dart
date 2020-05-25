part of 'post_bloc.dart';

@immutable
abstract class PostEvent {}
class PostIndex extends PostEvent{}
class PostCreate extends PostEvent{
  final PostModel model;
  final String token;
  final File thumbnail;
  PostCreate({
    @required this.model,
    @required this.token,
    @required this.thumbnail,
  });
}
class PostUpdate extends PostEvent{
  final int id;
  final PostModel model;
  final String token;
  final File thumbnail;
  PostUpdate({
    @required this.id,
    @required this.model,
    @required this.token,
    @required this.thumbnail,
  });
}
class PostDelete extends PostEvent{
  final int id;
  PostDelete({@required this.id});
}