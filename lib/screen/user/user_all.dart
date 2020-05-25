import 'package:charity_app_new/bloc/user/user_bloc.dart';
import 'package:charity_app_new/style/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserAll extends StatefulWidget {
  @override
  _UserAllState createState() => _UserAllState();
}

class _UserAllState extends State<UserAll> {
  UserBloc _bloc;
  String _isAdmin;
  _loadSession()async{
    SharedPreferences _pref = await SharedPreferences.getInstance();
    setState(() {
      _isAdmin = _pref.getString("isAdmin")??null;
    });
  }
  @override
  void initState() {
    _bloc = BlocProvider.of<UserBloc>(context);
    _bloc.add(UserIndex());
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
              Navigator.pop(context);
            },
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
                        "All User",
                        fontSize: 25,
                        maxLines: 3,
                        textAlign: TextAlign.center
                      )
                    ),
                  ),
                ],
              ),
            ),
            BlocBuilder<UserBloc, UserState>(
              builder: (context, state) {
                if(state is UserLoad){
                  return Container(
                    height: MediaQuery.of(context).size.height-200,
                    width: double.infinity,
                    child: ListView.builder(
                      itemCount: state.model.length,
                      itemBuilder: (context, index) {
                        return Card(
                          shadowColor: Theme.of(context).accentColor,
                          child: ListTile(
                            leading: CircleAvatar(
                              child: Icon(
                                Icons.person,
                                color: (state.model[index].isAdmin == "1")?Colors.red:Theme.of(context).accentColor,
                              ),
                            ),
                            title: primaryText(state.model[index].name,fontWeight: FontWeight.bold),
                            subtitle: primaryText(
                              "Email: "+state.model[index].email
                              .replaceRange(state.model[index].email.length-12, state.model[index].email.length, "xxxxxx")
                            ),

                          ),
                        );
                      },
                    ),
                  );
                }
                return Text(state.toString());
              },
            )
            ],
          ),
        ),
      ),
    );
  }
}