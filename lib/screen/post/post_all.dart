import 'package:charity_app_new/bloc/post/post_bloc.dart';
import 'package:charity_app_new/screen/post/post_add.dart';
import 'package:charity_app_new/screen/post/post_detail.dart';
import 'package:charity_app_new/style/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

class PostAll extends StatefulWidget {
  @override
  _PostAllState createState() => _PostAllState();
}

class _PostAllState extends State<PostAll> {
  PostBloc _bloc;
  String _isAdmin;
  _loadSession()async{
    SharedPreferences _pref = await SharedPreferences.getInstance();
    setState(() {
      _isAdmin = _pref.getString("isAdmin")??null;
    });
  }
  @override
  void initState() {
    _bloc = BlocProvider.of<PostBloc>(context);
    _bloc.add(PostIndex());
    _loadSession();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Theme.of(context).accentColor,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios,color: Theme.of(context).primaryColor,),
            onPressed: () {
              Navigator.pop(context);
              _bloc.add(PostIndex());
            },
          ),
          actions: <Widget>[
            (_isAdmin == "1")
            ?IconButton(
              icon: FaIcon(FontAwesomeIcons.plus,color: Theme.of(context).primaryColor,), 
              onPressed: (){
                Navigator.push(context,
                  MaterialPageRoute(builder: (_)=>PostAdd())
                );
              }
            ):SizedBox.shrink()
          ],
        ),
        body: SingleChildScrollView(
          child: RefreshIndicator(
            onRefresh: () async {
              _bloc.add(PostIndex());
            },
            child: Column(
              children: <Widget>[
                Container(
                  height: 200,
                  width: double.infinity,
                  color: Theme.of(context).accentColor,
                  child: Stack(
                    children: <Widget>[
                      Positioned.fill(
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: FlutterLogo(
                            size: 60,
                          ),
                        ),
                      ),
                      Positioned.fill(
                        child: Align(
                          alignment: Alignment.center,
                          child: accentText(
                            "All Post",
                            fontSize: 25,
                            maxLines: 3,
                            textAlign: TextAlign.center
                          )
                        ),
                      ),
                    ],
                  ),
                ),
                BlocBuilder<PostBloc, PostState>(
                  builder: (context, state) {
                    if(state is PostWaiting){
                      return _loading(state);
                    }
                    if(state is PostLoad){
                      return Container(
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height-200,
                        child: CupertinoScrollbar(
                          child: ListView.builder(
                            itemCount: state.model.length,
                            itemBuilder: (context,index){
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(context, 
                                    MaterialPageRoute(builder: (_)=>PostDetail(postModel: state.model[index],))
                                  );
                                },
                                child: Container(
                                  height: 100,
                                  padding: EdgeInsets.only(left: 5,right: 5),
                                  child: Card(
                                    child: Row(
                                      children: <Widget>[
                                        Container(
                                          padding: EdgeInsets.all(3),
                                          height: 100,
                                          width: MediaQuery.of(context).size.width*(2/5),
                                          child: Hero(
                                            tag: state.model[index].thumbnail, 
                                            child: ClipRRect(
                                              child: Image(
                                                image: NetworkImage(state.model[index].thumbnail),
                                                fit: BoxFit.cover,
                                              ),
                                            )
                                          ),
                                        ),
                                        Container(
                                            padding: EdgeInsets.all(6),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: <Widget>[
                                                primaryText(
                                                  state.model[index].title.toUpperCase(),
                                                  maxLines: 2,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15
                                                ),
                                                Row(
                                                  children: <Widget>[
                                                    primaryText("Detail",fontSize: 13),
                                                    Icon(Icons.arrow_forward_ios,size: 15,)
                                                  ],
                                                )
                                              ],
                                            ),
                                          )
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    }
                    return _loading(state);
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
  Column _loading(PostState state) {
    return Column(
      children: <Widget>[
        Shimmer.fromColors(
          baseColor: Colors.white,
          highlightColor: Theme.of(context).scaffoldBackgroundColor,
          child: Container(
            height: 100,
            padding: EdgeInsets.only(left:5,right:5),
            width: double.infinity,
            child: Card(),
          ),
        ),
        Shimmer.fromColors(
          baseColor: Colors.white,
          highlightColor: Theme.of(context).scaffoldBackgroundColor,
          child: Container(
            height: 100,
            padding: EdgeInsets.only(left:5,right:5),
            width: double.infinity,
            child: Card(),
          ),
        ),
        Shimmer.fromColors(
          baseColor: Colors.white,
          highlightColor: Theme.of(context).scaffoldBackgroundColor,
          child: Container(
            height: 100,
            padding: EdgeInsets.only(left:5,right:5),
            width: double.infinity,
            child: Card(),
          ),
        ),
        Shimmer.fromColors(
          baseColor: Colors.white,
          highlightColor: Theme.of(context).scaffoldBackgroundColor,
          child: Container(
            height: 100,
            padding: EdgeInsets.only(left:5,right:5),
            width: double.infinity,
            child: Card(),
          ),
        ),
      ],
    );
  }
}