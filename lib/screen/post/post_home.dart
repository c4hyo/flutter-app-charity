import 'package:charity_app_new/bloc/post/post_bloc.dart';
import 'package:charity_app_new/screen/post/post_all.dart';
import 'package:charity_app_new/style/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:charity_app_new/screen/post/post_detail.dart';

class PostHome extends StatefulWidget {
  @override
  _PostHomeState createState() => _PostHomeState();
}

class _PostHomeState extends State<PostHome> {
  PostBloc _bloc;
  @override
  void initState() {
    _bloc = BlocProvider.of<PostBloc>(context);
    _bloc.add(PostIndex());
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Container(

      child: BlocBuilder<PostBloc, PostState>(
        builder: (context, state) {
          if(state is PostLoad){
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(10),
                      child: primaryText("Post",fontSize: 22,fontWeight: FontWeight.bold),
                    ),
                    GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (_)=>PostAll()));
                      },
                      child: Container(
                        padding: EdgeInsets.all(10),
                        child: primaryText("All Post",fontSize: 17),
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.only(left:10,right:10),
                  height: 330,
                  width: double.infinity,
                  child: ListView.builder(
                    itemCount: 3,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(context, 
                            MaterialPageRoute(
                              builder: (_)=> PostDetail(postModel: state.model[index],)
                            )
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.only(top:5,bottom:5),
                          height: 110,
                          child: Card(
                            child: Row(
                              children: <Widget>[
                                Container(
                                  height: MediaQuery.of(context).size.height,
                                  width: MediaQuery.of(context).size.width*(2/5),
                                  child: Hero(
                                    tag: state.model[index].thumbnail,
                                    child: ClipRRect(
                                      child: Image(
                                        image: NetworkImage(state.model[index].thumbnail),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10,),
                                Container(
                                  padding: EdgeInsets.all(5),
                                  height: MediaQuery.of(context).size.height,
                                  width: MediaQuery.of(context).size.width*(2/5),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      primaryText(state.model[index].title.toUpperCase(),fontSize: 15,fontWeight: FontWeight.bold),
                                      primaryText(state.model[index].createdAt,fontSize: 13)
                                    ],
                                  )
                                ),
                              ],
                            ),
                          )
                        ),
                      );
                    },
                  ),
                )
              ],
            );
          }if(state is PostWaiting){
            return _waiting();
          }
          return Text(state.toString());
        },
      ),
    );
  }

  Column _waiting() {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(10),
              child: primaryText("Post",fontSize: 22,fontWeight: FontWeight.bold),
            ),
            GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (_)=>PostAll()));
              },
              child: Container(
                padding: EdgeInsets.all(10),
                child: primaryText("All Post",fontSize: 17),
              ),
            ),
          ],
        ),
        Container(
          height: 330,
          width: double.infinity,
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ],
    );
  }
}