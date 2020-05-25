import 'package:charity_app_new/bloc/event/event_bloc.dart';
import 'package:charity_app_new/screen/event/event_all.dart';
import 'package:charity_app_new/screen/event/event_detail.dart';
import 'package:charity_app_new/style/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

class EventHome extends StatefulWidget {
  @override
  _EventHomeState createState() => _EventHomeState();
}

class _EventHomeState extends State<EventHome> {
  EventBloc _bloc;
  @override
  void initState() {
    _bloc = BlocProvider.of<EventBloc>(context);
    _bloc.add(EventIndex());
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child: BlocBuilder<EventBloc, EventState>(
        builder: (context, state) {
          if(state is EventLoad){
            return _eventLoad(state);
          }
          if(state is EventWaiting){
            return _loading(state);
          }
          return _eventLoad(state);
        },
      )
    );
  }

  Column _eventLoad(EventLoad state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(10),
          child: primaryText("Event",fontSize: 22,fontWeight: FontWeight.bold),
        ),
        Container(
          padding: EdgeInsets.all(10),
          height: 255,
          child: ListView.builder(
            itemCount: 4,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return (index <3)
              ?GestureDetector(
              onTap: () {
                Navigator.push(context,
                  MaterialPageRoute(builder: (_)=>EventDetail(eventModel: state.model[index],))
                );
              },
                child: Container(
                  padding: EdgeInsets.only(left:10,right:10),
                  child: Container(
                    height: 300,
                    width: 240,
                    child: Stack(
                      children: <Widget>[
                        Positioned.fill(
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Theme.of(context).accentColor,
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.elliptical(80, 70),
                                  bottomRight: Radius.elliptical(80, 70)
                                )
                              ),
                              child: Center(
                                child: accentText(
                                  state.model[index].title,
                                  maxLines: 1,
                                  fontSize: 17
                                ),
                              ),
                              height: 50,
                              width: 250,
                            ),
                          ),
                        ),
                        Positioned.fill(
                          child: Align(
                            alignment: Alignment.topCenter,
                            child: Container(
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Theme.of(context).accentColor,
                                    blurRadius: 6,
                                    offset: Offset(2,0)
                                  ),
                                ]
                              ),
                              height: 190,
                              width: 240,
                              child: Hero(
                                tag: state.model[index].id,
                                child: ClipRRect(
                                  child: Image(
                                    image: NetworkImage(state.model[index].thumbnail),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              )
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ),
              ):GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_)=>EventAll()));
                },
                child: Container(
                  height: 100,
                  width: 75,
                  decoration: BoxDecoration(
                    color: Theme.of(context).accentColor,
                    borderRadius: BorderRadius.only(
                      // bottomLeft: Radius.elliptical(70, 80),
                      // topLeft: Radius.elliptical(70, 80),
                      bottomRight: Radius.elliptical(70, 130),
                      topRight: Radius.elliptical(70, 130),
                    )
                  ),
                  child: RotatedBox(
                    quarterTurns: -1,
                    child: Center(
                      child: accentText("See All",fontSize: 20)
                    ),
                  ),
                ),
              );
            },
          )
        )
      ],
    );
  }

  Column _loading(EventState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(10),
          child: primaryText("Event",fontSize: 22,fontWeight: FontWeight.bold),
        ),
        Container(
          padding: const EdgeInsets.all(10.0),
          height: 255,
          width: double.infinity,
          child: Center(child: CircularProgressIndicator()),
        ),
      ],
    );
  }

}