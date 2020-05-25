import 'package:charity_app_new/bloc/event/event_bloc.dart';
import 'package:charity_app_new/model/event_model.dart';
import 'package:charity_app_new/screen/event/event_update.dart';
import 'package:charity_app_new/style/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EventDetail extends StatefulWidget {
  EventModel eventModel = new EventModel();
  EventDetail({this.eventModel});
  @override
  _EventDetailState createState() => _EventDetailState();
}

class _EventDetailState extends State<EventDetail> {
  EventBloc _bloc;
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
          title: Text("Delete: "+widget.eventModel.title),
          children: <Widget>[
            SimpleDialogOption(
              child: Text("Yes"),
              onPressed: () {
                _bloc.add(EventDelete(id: widget.eventModel.id));
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
    _bloc = BlocProvider.of<EventBloc>(context);
    _loadSession();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: 
        (_isAdmin == "1")
        ?FloatingActionButton(
          backgroundColor: Theme.of(context).primaryColor,
          onPressed: () => print(""),
          child: BlocBuilder<EventBloc, EventState>(
            builder: (context, state) {
              if(state is EventWaiting){
                return CircularProgressIndicator(
                  backgroundColor: Theme.of(context).accentColor,
                );
              }
              if(state is EventSuccess){
                return _buttonDelete(context);
              }
              if(state is EventError){
                return _buttonDelete(context);
              }
              return _buttonDelete(context);
            },
          ),
        ):SizedBox.shrink(),
        body: BlocListener<EventBloc, EventState>(
          listener: (context, state) {
            if(state is EventSuccess){
              _bloc.add(EventIndex());
              Navigator.pop(context);
              Fluttertoast.showToast(msg: "Success");
            }
            if(state is EventError){
              Fluttertoast.showToast(msg: state.messege);
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
                        tag: widget.eventModel.id,
                        child: ClipRRect(
                          child: Image(
                            image: NetworkImage(widget.eventModel.thumbnail),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
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
                          Navigator.push(context, MaterialPageRoute(builder: (_)=>EventsUpdate(model: widget.eventModel,)));
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
                                  widget.eventModel.title.toUpperCase(),
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold
                                ),
                                Divider(),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Icon(
                                      Icons.place,
                                      color: Theme.of(context).accentColor,
                                    ),
                                    primaryText(
                                      widget.eventModel.place,
                                      fontSize: 15
                                    )
                                  ],
                                )
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
                          widget.eventModel.dateEvent.toUpperCase(),
                          fontSize: 20,
                          fontWeight: FontWeight.bold
                        ),
                        Container(
                          padding: EdgeInsets.only(top:15),
                          width: MediaQuery.of(context).size.width,
                          child: Text(
                            widget.eventModel.description,
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
              (_isAdmin == "0")?
              Container(
                padding: EdgeInsets.only(
                  left: 20,
                  right: 20,
                  bottom: 10
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    MaterialButton(
                      height: 50,
                      minWidth: 150,
                      shape: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20)
                      ),
                      child: Row(
                        children: <Widget>[
                          FaIcon(FontAwesomeIcons.solidHandshake,color: Theme.of(context).primaryColor,),
                          accentText(" Join",fontSize: 15),
                        ],
                      ),
                      color: Theme.of(context).accentColor,
                      onPressed: () {
                        print("haha");
                      },
                    ),
                    MaterialButton(
                      height: 50,
                      minWidth: 150,
                      shape: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20)
                      ),
                      child: Row(
                        children: <Widget>[
                          FaIcon(FontAwesomeIcons.dollarSign,color: Theme.of(context).primaryColor,),
                          accentText(" Donate",fontSize: 15),
                        ],
                      ),
                      color: Theme.of(context).accentColor,
                      onPressed: () {
                        print("haha");
                      },
                    ),
                  ],
                ),
              ):SizedBox.shrink()
            ],
          ),
        )
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