import 'dart:io';

import 'package:charity_app_new/bloc/post/post_bloc.dart';
import 'package:charity_app_new/model/post_model.dart';
import 'package:charity_app_new/style/input.dart';
import 'package:charity_app_new/style/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PostAdd extends StatefulWidget {
  @override
  _PostAddState createState() => _PostAddState();
}

class _PostAddState extends State<PostAdd> {
  GlobalKey<FormState> _key = new GlobalKey<FormState>();
  PostBloc _bloc;
  String _title,_description,_token;
  File _thumbnail;
  _addThumbnail(){
    return showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          backgroundColor: Theme.of(context).primaryColor,
          title: Text("Add Thumbnail"),
          children: <Widget>[
            SimpleDialogOption(
              child: Row(
                children: <Widget>[
                  Icon(Icons.camera_alt,color: Theme.of(context).accentColor,),
                  primaryText(" Take Photo")
                ],
              ),
              onPressed: () {
                _handleImage(ImageSource.camera);
              },
            ),
            SimpleDialogOption(
              child: Row(
                children: <Widget>[
                  Icon(Icons.photo,color: Theme.of(context).accentColor,),
                  primaryText(" Take from gallery")
                ],
              ),
              onPressed: () {
                _handleImage(ImageSource.gallery);
              },
            ),
            (_thumbnail != null)
            ?SimpleDialogOption(
              child: Row(
                children: <Widget>[
                  Icon(Icons.remove_circle,color: Theme.of(context).accentColor,),
                  primaryText(" Remove")
                ],
              ),
              onPressed: () {
                setState(() {
                  _thumbnail = null;
                });
                Navigator.pop(context);
              },
            ):SizedBox.shrink(),
            SimpleDialogOption(
              child: Row(
                children: <Widget>[
                  Icon(Icons.cancel,color: Colors.red,),
                  Text(" Cancel",style: TextStyle(color: Colors.red),)
                ],
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
  _handleImage(ImageSource source) async{
    Navigator.pop(context);
    File imageFile = await ImagePicker.pickImage(source:source);
    if(imageFile != null){
      setState(() {
        _thumbnail = imageFile;
      });
    }
  }
  getToken() async{
    SharedPreferences _pref = await SharedPreferences.getInstance();
    setState(() {
      _token = _pref.getString("token")??null;
    });
  }
  @override
  void initState() {
    _bloc = BlocProvider.of<PostBloc>(context);
    getToken();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: primaryText("Add Post"),
          elevation: 0,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios,color: Theme.of(context).accentColor,),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: BlocListener<PostBloc, PostState>(
          listener: (context, state) {
            if(state is PostSuccess){
              Navigator.pop(context);
              _bloc.add(PostIndex());
              Fluttertoast.showToast(msg: "Success");
            }
            if(state is PostError){
              Fluttertoast.showToast(msg: state.message);
            }
          },
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Form(
                  key: _key,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          children: <Widget>[
                            primaryText("Add Thumbnail",fontWeight: FontWeight.bold),
                            SizedBox(height: 20,),
                            (_thumbnail == null)
                            ?GestureDetector(
                              onTap: _addThumbnail,
                              child: Container(
                                height: 200,
                                width: 350,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Theme.of(context).accentColor,
                                      blurRadius: 2
                                    )
                                  ]
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.add_a_photo,
                                    color: Theme.of(context).accentColor,
                                    size: 70,
                                  ),
                                ),
                              ),
                            )
                            :GestureDetector(
                              onTap: _addThumbnail,
                              child: Container(
                                height: 200,
                                width: 350,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Theme.of(context).accentColor,
                                      blurRadius: 2
                                    )
                                  ]
                                ),
                                child: Image(
                                  image: FileImage(_thumbnail),
                                  fit: BoxFit.cover,
                                )
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(20),
                        child: TextFormField(
                          onSaved: (newValue) {
                            _title = newValue;
                          },
                          validator: (value) {
                            if(value.isEmpty){
                              return "Title is Required";
                            }
                            return null;
                          },
                          style: TextStyle(
                            color: Theme.of(context).accentColor
                          ),
                          decoration: InputDecoration(
                            labelText: "Title",
                            labelStyle: GoogleFonts.roboto(
                              color: Theme.of(context).accentColor
                            ),
                            border: primaryInputsBorder(),
                            enabledBorder: accentInputsBorder(),
                            focusedBorder: accentInputsBorder()
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(20),
                        child: TextFormField(
                          onSaved: (newValue) {
                            _description = newValue;
                          },
                          validator: (value) {
                            if(value.isEmpty){
                              return "Description is Required";
                            }
                            return null;
                          },
                          maxLines: null,
                          keyboardType: TextInputType.multiline,
                          style: TextStyle(
                            color: Theme.of(context).accentColor
                          ),
                          decoration: InputDecoration(
                            labelText: "Description",
                            labelStyle: GoogleFonts.roboto(
                              color: Theme.of(context).accentColor
                            ),
                            border: primaryInputsBorder(),
                            enabledBorder: accentInputsBorder(),
                            focusedBorder: accentInputsBorder()
                          ),
                        ),
                      ),
                      BlocBuilder<PostBloc, PostState>(
                        builder: (context, state) {
                          if(state is PostWaiting){
                            return _loading(context);
                          }
                          if(state is PostSuccess){
                            return _button(context);
                          }
                          if(state is PostLoad){
                            return _button(context);
                          }
                          if(state is PostError){
                            return _button(context);
                          }
                          return Column(
                            children: <Widget>[
                              _button(context),
                              Text(state.toString())
                            ],
                          );
                        },
                      )
                    ],
                  )
                )
              ],
            ),
          ),
        )
      ),
    );
  }

  Padding _button(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: MaterialButton(
        minWidth: 170,
        height: 60,
        color: Theme.of(context).primaryColor,
        onPressed: (){
          if(_key.currentState.validate()){
            _key.currentState.save();
            PostModel model = PostModel(
              title: _title,
              description: _description
            );
            _bloc.add(
              PostCreate(
                model: model, 
                token: _token, 
                thumbnail: _thumbnail
              )
            );
          }
        },
        child: primaryText("Save",fontSize: 18),
      ),
    );
  }

  Padding _loading(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: MaterialButton(
        minWidth: 170,
        height: 60,
        color: Theme.of(context).primaryColor,
        onPressed: (){
          print("null");
        },
        child:CircularProgressIndicator()
      ),
    );
  }
}