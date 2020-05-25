import 'package:charity_app_new/bloc/user/user_bloc.dart';
import 'package:charity_app_new/model/user_model.dart';
import 'package:charity_app_new/screen/auth/register.dart';
import 'package:charity_app_new/screen/home.dart';
import 'package:charity_app_new/style/input.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  UserBloc _userBloc = new UserBloc();
  GlobalKey<FormState> _key = new GlobalKey<FormState>();
  String _email,_password;
  _setSession({String token,String name,String isAdmin}) async{
    SharedPreferences _pref = await SharedPreferences.getInstance();
    setState(() {
      _pref.setString("token", token);
      _pref.setString("name", name);
      _pref.setString("isAdmin", isAdmin);
    });
  }
  @override
  void initState() {
    _userBloc = BlocProvider.of<UserBloc>(context);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).accentColor,
        appBar: AppBar(
          backgroundColor: Theme.of(context).accentColor,
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Theme.of(context).primaryColor,
            ),
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
          ),
        ),
        body: SingleChildScrollView(
          child: BlocListener<UserBloc, UserState>(
            listener: (context, state) {
              if(state is UserLoginSuccess){
                Fluttertoast.showToast(msg: "Sukses Slurd");
                _setSession(
                  isAdmin: state.model.isAdmin,
                  name: state.model.name,
                  token: state.model.apiToken
                );
                Navigator.pop(context);
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>HomeScreen()));
              }
              if(state is UserError){
                Fluttertoast.showToast(msg:state.message);
              }
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Center(
                  child: Container(
                    child: FlutterLogo(
                      size: 100,
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    "Sign In",
                    style: GoogleFonts.kaushanScript(
                      fontSize: 45,
                      color: Theme.of(context).primaryColor
                    ),
                  ),
                ),
                SizedBox(height: 10,),
                Center(
                  child: Form(
                    key: _key,
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: TextFormField(
                            onSaved: (v)=>_email=v,
                            validator: (value) {
                              if(!EmailValidator.validate(value)){
                                return "Invalid email format";
                              }
                              if(value.isEmpty){
                                return "Email is Required";
                              }
                              return null;
                            },
                            keyboardType: TextInputType.emailAddress,
                            style: GoogleFonts.roboto(
                              color: Theme.of(context).primaryColor
                            ),
                            decoration: InputDecoration(
                              labelText: "Email",
                              labelStyle: GoogleFonts.kaushanScript(
                                color: Theme.of(context).primaryColor
                              ),
                              prefixIcon: Icon(
                                Icons.mail,
                                color: Theme.of(context).primaryColor,
                              ),
                              border: accentInputsBorder(),
                              enabledBorder: primaryInputsBorder(),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: TextFormField(
                            obscureText: true,
                            onSaved: (v)=>_password = v,
                            validator: (value) {
                              if(value.length<6){
                                return "Password must be at least 6 characters";
                              }
                              if(value.isEmpty){
                                return "Password is required";
                              }
                              return null;
                            },
                            style: GoogleFonts.roboto(
                              color: Theme.of(context).primaryColor
                            ),
                            decoration: InputDecoration(
                              labelText: "Password",
                              labelStyle: GoogleFonts.kaushanScript(
                                color: Theme.of(context).primaryColor
                              ),
                              prefixIcon: Icon(
                                Icons.lock,
                                color: Theme.of(context).primaryColor,
                              ),
                              suffixIcon: IconButton(
                                icon: FaIcon(
                                  FontAwesomeIcons.eye,
                                  color: Theme.of(context).primaryColor,
                                ),
                                onPressed: () {
                                  print("Nais");
                                },
                              ),
                              border: accentInputsBorder(),
                              enabledBorder: primaryInputsBorder(),
                            ),
                          ),
                        ),
                        BlocBuilder<UserBloc, UserState>(
                          builder: (context, state) {
                            if(state is UserWaiting){
                              return _loading(context);
                            }
                            if(state is UserLoginSuccess){
                              return _button(context);
                            }
                            if(state is UserError){
                              return Column(
                                children: <Widget>[
                                  _button(context),
                                  Text(state.message)
                                ],
                              );
                            }
                            return _button(context);
                          },
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (_)=>RegisterScreen()));
                          },
                          child: Padding(
                            padding: EdgeInsets.all(15),
                            child: Text("Register now",
                              style: GoogleFonts.kaushanScript(
                                color: Theme.of(context).primaryColor,
                                fontSize: 18
                              ),
                            ),
                          )
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Padding _button(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: MaterialButton(
        color: Theme.of(context).primaryColor,
        minWidth: 170,
        height: 50,
        splashColor: Theme.of(context).hoverColor,
        child:Text(
          "Sign In",
          style: TextStyle(
            color: Theme.of(context).accentColor,
            fontSize: 17,
            fontWeight: FontWeight.bold
          ),
        ),
        onPressed: () {
          setState(() {
            if(_key.currentState.validate()){
              _key.currentState.save();
              UserModel models = UserModel(
                email: _email,
                password: _password
              );
              _userBloc.add(UserLogin(model: models));
            }
          });
        },
      ),
    );
  }
  Padding _loading(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: MaterialButton(
        onPressed: (){
          print("ntaps");
        },
        color: Theme.of(context).primaryColor,
        minWidth: 170,
        height: 50,
        splashColor: Theme.of(context).hoverColor,
        child:CircularProgressIndicator()
      ),
    );
  }
}