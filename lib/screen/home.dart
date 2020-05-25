import 'package:charity_app_new/bloc/event/event_bloc.dart';
import 'package:charity_app_new/screen/auth/sign_in.dart';
import 'package:charity_app_new/screen/event/event_home.dart';
import 'package:charity_app_new/screen/post/post_all.dart';
import 'package:charity_app_new/screen/post/post_home.dart';
import 'package:charity_app_new/screen/user/user_all.dart';
import 'package:charity_app_new/style/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffold = new GlobalKey<ScaffoldState>();
  EventBloc _eventBloc;
  String _name ="to Charity App";
  String _token,_isAdmin;
  _loadSession() async{
    SharedPreferences _pref = await SharedPreferences.getInstance();
    setState(() {
      _token = _pref.getString("token")??null;
      _name = _pref.getString("name")??null;
      _isAdmin = _pref.getString("isAdmin")??null;
    });
  }
  _flushSession()async{
    SharedPreferences _pref = await SharedPreferences.getInstance();
    setState(() {
      _pref.remove("token");
      _pref.remove("name");
      _pref.remove("isAdmin");
    });
    Navigator.pop(context);
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>HomeScreen()));
    Fluttertoast.showToast(msg: "Success");
  }
  _modalLogout(){
    return showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: Center(child: Text("Logout",style: TextStyle(fontWeight: FontWeight.bold,fontSize:30),)),
          backgroundColor: Theme.of(context).primaryColor,
          children: <Widget>[
            CupertinoDialogAction(
              child: Text("Yes",style: TextStyle(color: Colors.red),),
              onPressed: () {
                Navigator.pop(context);
                _flushSession();
              },
            ),
            CupertinoDialogAction(
              child: Text("No",style: TextStyle(color: Colors.black),),
              onPressed: () => Navigator.pop(context),
            )
          ],
        );
      },
    );
  }
  @override
  void initState() {
    _eventBloc = BlocProvider.of<EventBloc>(context);
    // _postBloc = BlocProvider.of<PostBloc>(context);
    _eventBloc.add(EventIndex());
    _loadSession();
    super.initState();
  }
  @override
  void dispose() {
    // _eventBloc.close();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffold,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).accentColor,
        leading: IconButton(
          icon: Icon(Icons.menu,color: Theme.of(context).primaryColor,),
          onPressed: () {
            _scaffold.currentState.openDrawer();
          },
        ),
      ),
      drawer: Drawer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            DrawerHeader(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Theme.of(context).accentColor,
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).accentColor,
                    offset: Offset(0, 1),
                    blurRadius: 1
                  )
                ]
              ),
              child: Stack(
                children: <Widget>[
                  Positioned.fill(
                    top: 10,
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: CircleAvatar(
                        maxRadius: 40,
                        child: Icon(
                          Icons.person,
                          size: 40,
                          color: Theme.of(context).accentColor,
                        )
                      ),
                    ),
                  ),
                  Positioned.fill(
                    bottom: 10,
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: accentText((_token != null)?"$_name":"",fontSize: 18)
                    ),
                  ),
                ],
              ),
            ),
            (_isAdmin == "1")
            ?Card(
              color: Theme.of(context).accentColor,
              child: ListTile(
                leading: FaIcon(FontAwesomeIcons.users,color: Theme.of(context).primaryColor,),
                title: accentText("List Users"),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_)=>UserAll()));
                },
              ),
            ):SizedBox.shrink(),
            Expanded(child: SizedBox.shrink(),),
            (_token == null)
            ?Card(
              color: Theme.of(context).accentColor,
              child: ListTile(
                leading: FaIcon(FontAwesomeIcons.signInAlt,color: Theme.of(context).primaryColor,),
                title: accentText("Sign In"),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_)=>SignIn()));
                },
              ),
            )
            :Card(
              color: Theme.of(context).accentColor,
              child: ListTile(
                leading: FaIcon(FontAwesomeIcons.signOutAlt,color: Theme.of(context).primaryColor,),
                title: accentText("Sign Out"),
                onTap: () {
                  _modalLogout();
                },
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
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
                        (_name == null)
                        ?"Welcome to\n My App":"Welcome back\n $_name",
                        fontSize: 25,
                        maxLines: 3,
                        textAlign: TextAlign.center
                      )
                    ),
                  ),
                ],
              ),
            ),
            EventHome(),
            SizedBox(height: 20,),
            PostHome(),
          ],
        ),
      )
    );
  }
}