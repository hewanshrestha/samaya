import 'dart:async';

import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Time",
      theme: ThemeData(primaryColor: Colors.green[800]),      
      home: Homepage(),      
    );
  }
}
class Homepage extends StatefulWidget {
  
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage>  with TickerProviderStateMixin{

  String _timeString;
  TabController tb;
  int hour = 0;
  int min = 0;
  int sec = 0;
  bool started = true;
  bool stopped = true;
  int timeForTimer = 0;
  String timeToDisplay = "";
  bool checkTimer = true;

  @override
  void initState(){
    tb = TabController(
      length: 3,
      vsync: this,
    );
    _timeString = "${DateTime.now().hour} : ${DateTime.now().minute} : ${DateTime.now().second}";
    Timer.periodic(Duration(seconds: 1), (Timer t) => _getCurrentTime());
    super.initState();
  }

  void _getCurrentTime(){
    setState((){
      _timeString = "${DateTime.now().hour} : ${DateTime.now().minute} : ${DateTime.now().second}";
    });
  }

  void start(){
    setState((){
      started = false;
      stopped = false;
    });

    timeForTimer = (hour * 60 * 60)+(min*60)+sec;
    Timer.periodic(Duration(
      seconds: 1,
    ),(Timer t){
      setState((){
        if(timeForTimer < 1 || checkTimer == false){
          t.cancel();
          Navigator.pushReplacement(context, MaterialPageRoute(
            builder: (context) => Homepage(),
          ));
        }
        else if(timeForTimer < 60){
          timeToDisplay = timeForTimer.toString();
          timeForTimer = timeForTimer -1;
        }
        else if(timeForTimer < 3600){
          int m = timeForTimer ~/ 60;
          int s = timeForTimer - (60 * m);
          timeToDisplay = m.toString() + ":" + s.toString();
          timeForTimer = timeForTimer - 1;
        }
        else{
          int h = timeForTimer ~/ 3600;
          int t = timeForTimer - (3600 * h);
          int m = t ~/ 60;
          int s = t - (60 * m);
          timeToDisplay =  h.toString() + ":" + m.toString() + ":" + s.toString();
          timeForTimer = timeForTimer - 1;

        }
      });
    });
  }
  void stop(){
    setState((){
      started = true;
      stopped = true;
      checkTimer = false;
    });

  }



  Widget timer(){
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            flex: 6,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(
                        bottom: 10.0
                      ),
                      child: Text(
                        "HH",
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    NumberPicker.integer(
                      initialValue: hour,
                      minValue: 0,
                      maxValue: 23,
                      listViewWidth: 60.0,
                      onChanged: (val){
                        setState((){
                          hour= val;
                        });
                      }
                    )
                  ],
                ),

                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(
                        bottom: 10.0
                      ),
                      child: Text(
                        "MM",
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    NumberPicker.integer(
                      initialValue: min,
                      minValue: 0,
                      maxValue: 23,
                      listViewWidth: 60.0,
                      onChanged: (val){
                        setState((){
                          min= val;
                        });
                      }
                    )
                  ],
                ),

                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(
                        bottom: 10.0
                      ),
                      child: Text(
                        "SS",
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    NumberPicker.integer(
                      initialValue: sec,
                      minValue: 0,
                      maxValue: 23,
                      listViewWidth: 60.0,
                      onChanged: (val){
                        setState((){
                          sec= val;
                        });
                      }
                    )
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              timeToDisplay,
              style: GoogleFonts.pacifico(
                textStyle: TextStyle(fontSize: 35.0, color: Colors.black, fontWeight: FontWeight.w500),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                RaisedButton.icon(
                  onPressed: started ? start: null,
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.0,
                    vertical: 10.0,
                  ),
                  color: Colors.green,
                  label: Text(
                    "Start",
                    style: GoogleFonts.pacifico(
                      textStyle: TextStyle(color: Colors.white, fontSize: 15.0,),
                    ),
                    
                  ),
                  icon: Icon(Icons.power_settings_new, color:Colors.white,),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                RaisedButton.icon(
                  onPressed: stopped?null:stop,
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.0,
                    vertical: 10.0,
                  ),
                  color: Colors.red,
                  label: Text(
                    "Stop",
                    style: GoogleFonts.pacifico(
                      textStyle: TextStyle(color: Colors.white, fontSize: 15.0,),
                    ),
                  ),
                  icon: Icon(Icons.stop, color:Colors.white,),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  bool startispressed = true;
  bool stopispressed = true;
  bool resetispressed = true;
  String stoptimetodisplay = "00:00:00";
  var swatch = Stopwatch();
  final dur = const Duration(seconds: 1);


  void starttimer(){
    Timer(dur,keeprunning);
  }

  void keeprunning(){
    if(swatch.isRunning){
      starttimer();
    }
    setState((){
      stoptimetodisplay = swatch.elapsed.inHours.toString().padLeft(2,"0")+":"+
                          (swatch.elapsed.inMinutes%60).toString().padLeft(2,"0")+":"+
                          (swatch.elapsed.inSeconds%60).toString().padLeft(2,"0");
    });
  }

  void startstopwatch(){
    setState((){
      stopispressed = false;
      startispressed = false;
    });
    swatch.start();
    starttimer();
  }

  void stopstopwatch(){
    setState((){
      stopispressed = true;
      resetispressed = false;
    });
    swatch.stop();
  }

  void resetstopwatch(){
    setState((){
      startispressed = true;
      resetispressed = true;
    });
    swatch.reset();
    stoptimetodisplay = "00:00:00";
  }

  Widget stopwatch(){
    return Container(
      child: Column(
        children: <Widget>[
          Expanded(
            flex: 6,
            child: Container(
              alignment: Alignment.center,
              child: Text(
                stoptimetodisplay,
                style: GoogleFonts.pacifico(
                  textStyle: TextStyle(fontSize: 60.0, color: Colors.black, fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      RaisedButton.icon(
                        onPressed: stopispressed ? null: stopstopwatch,
                        color: Colors.red,
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.0,
                          vertical: 10.0,
                        ),
                        label: Text(
                          "Stop",
                          style: GoogleFonts.pacifico(
                            textStyle: TextStyle(color: Colors.white, fontSize: 15.0,),
                          ),                    
                        ),
                        icon: Icon(Icons.stop, color:Colors.white,),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      RaisedButton.icon(
                        onPressed: resetispressed ? null : resetstopwatch,
                        color: Colors.teal,
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.0,
                          vertical: 10.0,
                        ),
                        label: Text(
                          "Reset",
                          style: GoogleFonts.pacifico(
                            textStyle: TextStyle(color: Colors.white, fontSize: 15.0,),
                          ),  
                        ),
                        icon: Icon(Icons.autorenew, color:Colors.white,),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ],
                  ),
                  RaisedButton.icon(
                    onPressed: startispressed ? startstopwatch :  null,
                    color: Colors.green,
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.0,
                      vertical: 10.0,
                    ),
                    label: Text(
                      "Start",
                      style: GoogleFonts.pacifico(
                        textStyle: TextStyle(color: Colors.white, fontSize: 15.0,),
                      ),  
                    ),
                    icon: Icon(Icons.power_settings_new, color:Colors.white,),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget clock(){
    return Container(
      child: Center(
        child: Text(
          _timeString,
          style: GoogleFonts.pacifico(
            textStyle: TextStyle(fontSize: 60.0, color: Colors.black, fontWeight: FontWeight.w700),
          ),
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey[800],
        title: Text(
          "Samaya",
          style: GoogleFonts.piedra(
            textStyle: TextStyle(fontSize: 25, color: Colors.white, fontWeight: FontWeight.w700),
          ),
        ),
        centerTitle: true,
        bottom: TabBar(
          tabs: <Widget>[
            Text(
              "Clock",
              style: GoogleFonts.satisfy(
                textStyle: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600),
              ),
            ),
            Text(
              "Timer",
              style: GoogleFonts.satisfy(
                textStyle: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600),
              ),
            ),
            Text(
              "Stopwatch",
              style: GoogleFonts.satisfy(
                textStyle: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600),
              ),
            ),
          ],
          labelPadding: EdgeInsets.only(
            bottom: 10.0,
          ),
          labelStyle: TextStyle(
            fontSize: 18.0,
          ),
          unselectedLabelColor: Colors.white54,
          controller: tb,
        ),
      ),
      body: TabBarView(
        children: <Widget>[
          clock(),
          timer(),
          stopwatch(),
        ],
        controller: tb,
        
      ),
    );
  }
}