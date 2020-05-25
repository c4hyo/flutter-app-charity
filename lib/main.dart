import 'package:charity_app_new/bloc/event/event_bloc.dart';
import 'package:charity_app_new/bloc/post/post_bloc.dart';
import 'package:charity_app_new/bloc/user/user_bloc.dart';
import 'package:charity_app_new/screen/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers:[
        BlocProvider<UserBloc>(create: (context) => UserBloc(),),
        BlocProvider<PostBloc>(create: (context) => PostBloc(),),
        BlocProvider<EventBloc>(create: (context) => EventBloc(),)
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primaryColor: Color(0xFFFDD186),
          accentColor: Color(0xFF2F4670),
          scaffoldBackgroundColor: Color(0xFFF8ECD6),
          textTheme: GoogleFonts.robotoTextTheme(),
          buttonColor: Color(0xFF2F4670),
          hoverColor: Color(0xFF8FACE2),
        ),
        home: SafeArea(child: HomeScreen()),
      ),
    );
  }
}
