import 'package:charity_app_new/bloc/user/user_bloc.dart';
import 'package:charity_app_new/model/user_model.dart';
import 'package:charity_app_new/screen/home.dart';
import 'package:charity_app_new/style/input.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  UserBloc _bloc;
  GlobalKey<FormState> _key = new GlobalKey<FormState>();
  String _email,_password,_name,_rePassword;

  @override
  void initState() {
    _bloc = BlocProvider.of<UserBloc>(context);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Theme.of(context).accentColor,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: BlocListener<UserBloc, UserState>(
          listener: (context, state) {
            if(state is UserSuccess){
              Fluttertoast.showToast(msg: "Success");
              Navigator.pushReplacement(context, 
                MaterialPageRoute(builder: (_)=>HomeScreen())
              );
            }
            if(state is UserError){
              Fluttertoast.showToast(msg: state.message);
            }
          },
          child: SingleChildScrollView(
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
                    "Sign Up",
                    style: GoogleFonts.kaushanScript(
                      fontSize: 45,
                      color: Theme.of(context).accentColor
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
                            onSaved: (v)=>_name=v,
                            validator: (value) {
                              if(value.isEmpty){
                                return "Name is Required";
                              }
                              return null;
                            },
                            style: GoogleFonts.roboto(
                              color: Theme.of(context).accentColor
                            ),
                            decoration: InputDecoration(
                              labelText: "Name",
                              labelStyle: GoogleFonts.kaushanScript(
                                color: Theme.of(context).accentColor
                              ),
                              prefixIcon: Icon(
                                Icons.person,
                                color: Theme.of(context).accentColor,
                              ),
                              border: primaryInputsBorder(),
                              focusedBorder: accentInputsBorder(),
                              enabledBorder: accentInputsBorder()
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: TextFormField(
                            onSaved: (v)=>_email=v,
                            validator: (value) {
                              if(value.isEmpty){
                                return "Email is Required";
                              }
                              if(!EmailValidator.validate(value)){
                                return "Invalid email format";
                              }
                              return null;
                            },
                            keyboardType: TextInputType.emailAddress,
                            style: GoogleFonts.roboto(
                              color: Theme.of(context).accentColor
                            ),
                            decoration: InputDecoration(
                              labelText: "Email",
                              labelStyle: GoogleFonts.kaushanScript(
                                color: Theme.of(context).accentColor
                              ),
                              prefixIcon: Icon(
                                Icons.mail,
                                color: Theme.of(context).accentColor,
                              ),
                              focusedBorder: accentInputsBorder(),
                              border:primaryInputsBorder(),
                              enabledBorder: accentInputsBorder(),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: TextFormField(
                            obscureText: true,
                            onSaved: (v)=>_password = v,
                            validator: (value) {
                              if(value.isEmpty){
                                return "Password is required";
                              }
                              if(value.length<6){
                                return "Password must be at least 6 characters";
                              }
                              _key.currentState.save();
                              return null;
                            },
                            style: GoogleFonts.roboto(
                              color: Theme.of(context).accentColor
                            ),
                            decoration: InputDecoration(
                              labelText: "Password",
                              labelStyle: GoogleFonts.kaushanScript(
                                color: Theme.of(context).accentColor
                              ),
                              prefixIcon: Icon(
                                Icons.lock,
                                color: Theme.of(context).accentColor,
                              ),
                              border: primaryInputsBorder(),
                              enabledBorder: accentInputsBorder(),
                              focusedBorder: accentInputsBorder(),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: TextFormField(
                            obscureText: true,
                            onSaved: (v)=>_rePassword = v,
                            validator: (value) {
                              if(value.isEmpty){
                                return "Password is required";
                              }
                              if(value != _password){
                                return "Password dosen't match";
                              }
                              if(value.length<6){
                                return "Password must be at least 6 characters";
                              }
                              return null;
                            },
                            style: GoogleFonts.roboto(
                              color: Theme.of(context).accentColor
                            ),
                            decoration: InputDecoration(
                              labelText: "Confirm Password",
                              labelStyle: GoogleFonts.kaushanScript(
                                color: Theme.of(context).accentColor
                              ),
                              prefixIcon: Icon(
                                Icons.lock,
                                color: Theme.of(context).accentColor,
                              ),
                              focusedBorder: accentInputsBorder(),
                              border: primaryInputsBorder(),
                              enabledBorder: accentInputsBorder(),
                            ),
                          ),
                        ),
                        BlocBuilder<UserBloc, UserState>(
                          builder: (context, state) {
                            if(state is UserSuccess){
                              return _buttonSignUp(context);
                            }
                            if(state is UserError){
                              return _buttonSignUp(context);
                            }
                            if(state is UserWaiting){
                              return _loading(context);
                            }
                            return _buttonSignUp(context);
                          },
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Padding _loading(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: MaterialButton(
        color: Theme.of(context).accentColor,
        minWidth: 170,
        height: 50,
        splashColor: Theme.of(context).hoverColor,
        child:CircularProgressIndicator(
          backgroundColor: Theme.of(context).primaryColor,
        ),
        onPressed: () {
          print("loading");
        },
      ),
    );
  }

  Padding _buttonSignUp(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: MaterialButton(
        color: Theme.of(context).accentColor,
        minWidth: 170,
        height: 50,
        splashColor: Theme.of(context).hoverColor,
        child:Text(
          "Sign Up",
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontSize: 17,
            fontWeight: FontWeight.bold
          ),
        ),
        onPressed: () {
          setState(() {
            if(_key.currentState.validate()){
              _key.currentState.save();
              UserModel model = UserModel(
                email: _email,
                password: _password,
                name: _name,
              );
              _bloc.add(UserRegistration(model: model));
            }
          });
        },
      ),
    );
  }
}