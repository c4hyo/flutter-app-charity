import 'package:charity_app_new/bloc/post/post_bloc.dart';
import 'package:charity_app_new/model/post_model.dart';
import 'package:charity_app_new/screen/post/post_update.dart';
import 'package:charity_app_new/style/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PostDetail extends StatefulWidget {
  PostModel postModel;
  PostDetail({this.postModel});
  @override
  _PostDetailState createState() => _PostDetailState();
}

class _PostDetailState extends State<PostDetail> {
  PostBloc _bloc;
  String _isAdmin;
  _loadSession()async{
    SharedPreferences _pref = await SharedPreferences.getInstance();
    setState(() {
      _isAdmin = _pref.getString("isAdmin")??null;
    });
  }
  _diaolgDelete(){
    return showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: Text("Delete: "+widget.postModel.title),
          children: <Widget>[
            SimpleDialogOption(
              child: Text("Yes"),
              onPressed: () {
                _bloc.add(PostDelete(id: widget.postModel.id));
                Navigator.pop(context);
              },
            ),
            SimpleDialogOption(
              child: Text("No"),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }
  @override
  void initState() {
    _bloc = BlocProvider.of<PostBloc>(context);
    _loadSession();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: 
        (_isAdmin == "1")?
        FloatingActionButton(
          backgroundColor: Theme.of(context).primaryColor,
          onPressed: () => print("fsdas"),
          child: BlocBuilder<PostBloc, PostState>(
            builder: (context, state) {
              if(state is PostWaiting){
                return CircularProgressIndicator(
                  backgroundColor: Theme.of(context).accentColor,
                );
              }
              if(state is PostSuccess){
                return _buttonDelete(context);
              }
              if(state is PostError){
                return _buttonDelete(context);
              }
              return _buttonDelete(context);
            },
          )
        ):SizedBox.shrink(),
        body: BlocListener<PostBloc, PostState>(
          listener: (context, state) {
            if(state is PostSuccess){
              _bloc.add(PostIndex());
              Navigator.pop(context);
              Fluttertoast.showToast(msg: "Success");
            }
            if(state is PostError){
              Fluttertoast.showToast(msg: state.message);
            }
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                height: 300,
                child: Stack(
                  children: <Widget>[
                    Container(
                      height: 260,
                      width: double.infinity,
                      child: Hero(
                        tag: widget.postModel.thumbnail,
                        child: ClipRRect(
                          child: Image(
                            image: NetworkImage(widget.postModel.thumbnail),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 10,
                      left: 10,
                      child: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(
                          Icons.arrow_back_ios,
                          color: Theme.of(context).primaryColor,
                          size: 25,
                        ),
                      ),
                    ),
                    (_isAdmin == "1")
                    ?Positioned(
                      top: 10,
                      right: 10,
                      child: IconButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (_)=>PostUpdateScreen(model: widget.postModel,)));
                        },
                        icon: FaIcon(
                          FontAwesomeIcons.pen,
                          color: Theme.of(context).primaryColor,
                          size: 25,
                        ),
                      ),
                    ):SizedBox.fromSize(),
                    Positioned.fill(
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          height: 80,
                          width: MediaQuery.of(context).size.width-50,
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(80)
                          ),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                primaryText(
                                  widget.postModel.title.toUpperCase(),
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(20),
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        primaryText(
                          widget.postModel.createdAt.toUpperCase(),
                          fontSize: 14,
                          fontWeight: FontWeight.bold
                        ),
                        Container(
                          padding: EdgeInsets.only(top:15),
                          width: MediaQuery.of(context).size.width,
                          child: Text(
                            widget.postModel.description,
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                              color: Theme.of(context).accentColor
                            ),
                          )
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconButton _buttonDelete(BuildContext context) {
    return IconButton(
      onPressed: _diaolgDelete,
      icon: Icon(
        Icons.delete,color: Theme.of(context).accentColor,
      ),
    );
  }
}