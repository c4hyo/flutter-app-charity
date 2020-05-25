import 'dart:io';

import 'package:charity_app_new/bloc/event/event_bloc.dart';
import 'package:charity_app_new/model/event_model.dart';
import 'package:charity_app_new/style/input.dart';
import 'package:charity_app_new/style/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class EventsUpdate extends StatefulWidget {
  EventModel model = new EventModel();
  EventsUpdate({this.model});
  @override
  _EventsUpdateState createState() => _EventsUpdateState();
}

class _EventsUpdateState extends State<EventsUpdate> {
  GlobalKey<FormState> _key = new GlobalKey<FormState>();
  EventBloc _bloc;
  String _token,_title,_description,_place,_dateEvent;
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
    _bloc = BlocProvider.of<EventBloc>(context);
    getToken();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        title: primaryText("Add Event"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios,color: Theme.of(context).accentColor,),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: BlocListener<EventBloc, EventState>(
        listener: (context, state) {
          if(state is EventSuccess){
            Navigator.pop(context);
            Navigator.pop(context);
            _bloc.add(EventIndex());
            Fluttertoast.showToast(msg: "Success");
          }
          if(state is EventError){
            Fluttertoast.showToast(msg: state.messege);
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
                                color: Theme.of(context).accentColor,
                                boxShadow: [
                                  BoxShadow(
                                    color: Theme.of(context).primaryColor,
                                    blurRadius: 2
                                  )
                                ]
                              ),
                              child: Image(
                                image: NetworkImage(widget.model.thumbnail),
                                fit: BoxFit.cover,
                              )
                            ),
                          )
                          :GestureDetector(
                            onTap: _addThumbnail,
                            child: Container(
                              height: 200,
                              width: 350,
                              decoration: BoxDecoration(
                                color: Theme.of(context).accentColor,
                                boxShadow: [
                                  BoxShadow(
                                    color: Theme.of(context).primaryColor,
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
                        initialValue: widget.model.title,
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
                        initialValue: widget.model.place,
                        onSaved: (newValue) {
                          _place = newValue;
                        },
                        validator: (value) {
                          if(value.isEmpty){
                            return "Place is Required";
                          }
                          return null;
                        },
                        style: TextStyle(
                          color: Theme.of(context).accentColor
                        ),
                        decoration: InputDecoration(
                          labelText: "Place",
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
                      padding: EdgeInsets.all(15),
                      child: MaterialButton(
                        child: Text(
                          (_dateEvent == null)
                          ?widget.model.dateEvent:"$_dateEvent"
                        ),
                        minWidth: double.infinity,
                        height: 60,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                          side:BorderSide(color: Theme.of(context).accentColor,style: BorderStyle.solid,width: 5)
                        ),
                        onPressed: (){
                          DatePicker.showDatePicker(
                            context,
                            showTitleActions: true,
                            minTime: DateTime.now(),
                            maxTime: DateTime(2050),
                            onChanged: (time) {
                              print(time);
                            },
                            onConfirm: (time) {
                              setState(() {
                                _dateEvent = time.toString();
                              });
                            },
                            onCancel: () {
                              setState(() {
                                _dateEvent =null;
                              });
                            },
                            locale: LocaleType.id
                          );
                        },
                      )
                    ),
                    Padding(
                      padding: EdgeInsets.all(20),
                      child: TextFormField(
                        initialValue: widget.model.description,
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
                    BlocBuilder<EventBloc, EventState>(
                      builder: (context, state) {
                        if(state is EventWaiting){
                          return _loading(context);
                        }
                        if(state is EventSuccess){
                          return _button(context);
                        }
                        if(state is EventError){
                          return _button(context);
                        }
                        if(state is EventLoad){
                          return _button(context);
                        }
                        return _button(context);
                      },
                    )
                  ],
                )
              ),
            ],
          ),
        ),
      )
    );
  }
  Padding _button(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: MaterialButton(
        minWidth: 170,
        height: 60,
        color: Theme.of(context).accentColor,
        onPressed: (){
          if(_key.currentState.validate()){
            _key.currentState.save();
            EventModel models = EventModel(
              place: _place,
              title: _title,
              description: _description,
              dateEvent: _dateEvent??null
            );
            _bloc.add(
              EventUpdate(id:widget.model.id,model: models, token: _token, thumbnail: _thumbnail)
            );
          }
        },
        child: accentText("Update",fontSize: 18),
      ),
    );
  }
  Padding _loading(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: MaterialButton(
        minWidth: 170,
        height: 60,
        color: Theme.of(context).accentColor,
        onPressed: (){
          if(_key.currentState.validate()){
            _key.currentState.save();
            
          }
        },
        child: CircularProgressIndicator(
          backgroundColor: Theme.of(context).primaryColor,
        ),
      ),
    );
  }
}