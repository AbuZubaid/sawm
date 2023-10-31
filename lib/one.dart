import 'package:flutter/material.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sawm/main.dart';
import 'package:sawm/profile_and_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:video_player/video_player.dart';


class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late VideoPlayerController _controller;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final User? user = FirebaseAuth.instance.currentUser;
  Future<Map<String, dynamic>> get fastingDetails async {
    final User? user = FirebaseAuth.instance.currentUser;
    String? identifier;
    if (user == null) {
      return {};
    }
    final signInMethod = user.providerData.first.providerId;
    if (signInMethod == 'phone') {
      identifier = user.phoneNumber;
    } else if (signInMethod == 'google.com') {
      // For email/password login
      identifier = user.email;
    }
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(identifier)
        .get();
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return {
      'isFasting': data['isFasting'] as bool?,
      'selectedTime': data['selectedTime'] as String?,
      'startTime': data['startTime'] as Timestamp?,
    };
  }

  String selectedHours = '12';
  String remainingTime = '';
  int totalTime = 0;
  bool isFasting = false;
  bool isCancelConfirmed = false;
  Timer? timer;

  void startTimer() async {
    final now = DateTime.now();
    final User? user = FirebaseAuth.instance.currentUser;
    String? identifier;
    if (user == null) {
      return null;
    }
    final signInMethod = user.providerData.first.providerId;
    if (signInMethod == 'phone') {
      identifier = user.phoneNumber;
    } else if (signInMethod == 'google.com') {
      // For email/password login
      identifier = user.email;
    }
    if (user != null) {
      await FirebaseFirestore.instance.collection('users').doc(identifier).set(
          {'startTime': now, 'selectedTime': selectedHours, 'isFasting': true},
          SetOptions(merge: true));
    }

    setState(() {
      isFasting = true;
    });

    timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      setState(() {
        if (totalTime <= 0) {
          t.cancel();
          isFasting = false;
        } else {
          totalTime--;
          remainingTime = formatTime(totalTime);
        }
      });
    });
  }

  void endTimer() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance.collection('users').doc(user.email).set(
          {'startTime': '', 'selectedTime': '', 'isFasting': false},
          SetOptions(merge: true));
    }

    setState(() {
      isFasting = false;
    });
  }

  void stopTimer() {
    if (totalTime > 0 && !isCancelConfirmed) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'إنهاء الصيام',
              textDirection: TextDirection.rtl,
            ),
            content: Text('هل أنت متأكد أنك تريد إيقاف فترة الصيام الحالية؟',
                textDirection: TextDirection.rtl),
            actions: [
              TextButton(
                onPressed: () {
                  resetTimer();
                  Navigator.of(context).pop();
                  setState(() {
                    isCancelConfirmed = true;
                  });
                },
                child: Text(
                  'نعم',
                  style: TextStyle(fontSize: 30),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  'لا',
                  style: TextStyle(fontSize: 30),
                ),
              ),
            ],
          );
        },
      );
    }
  }

  void resetTimer() async {
    final User? user = FirebaseAuth.instance.currentUser;
    String? identifier;
    if (user == null) {
      return null;
    }
    final signInMethod = user.providerData.first.providerId;
    if (signInMethod == 'phone') {
      identifier = user.phoneNumber;
    } else if (signInMethod == 'google.com') {
      // For email/password login
      identifier = user.email;
    }
    if (user != null) {
      await FirebaseFirestore.instance.collection('users').doc(identifier).set(
          {'startTime': '', 'selectedTime': '', 'isFasting': false},
          SetOptions(merge: true));
    }
    setState(() {
      timer?.cancel();
      isFasting = false;
      isCancelConfirmed = false;
      remainingTime = '';
    });
  }

  Future<void> _signOut(BuildContext context) async {
    try {
      await _auth.signOut();
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => MyWelcomePage(),
      ));

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'تم تسجيل الخروج بنجاح',
            textDirection: TextDirection.rtl,
            style: TextStyle(fontFamily: 'Cairo'),
          ),
        ),
      );
      // Optionally, navigate to another page (e.g., Login or Home) after sign-out.
      // Navigator.of(context).pushReplacementNamed('/login');
    } catch (e) {
      print(e); // print the exception to the console
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error signing out: $e'),
        ),
      );
    }
  }

  String formatTime(int time) {
    int hours = time ~/ 3600;
    int minutes = (time % 3600) ~/ 60;
    int seconds = time % 60;
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }


  @override
  // This is for the background Video Animation
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('images/vid4.mp4');
    _controller.initialize().then((_) {
      _controller.setLooping(true);
      _controller.play();
    });
  }

  @override
  Widget build(BuildContext context) {
    List<String> hours = [
      '1',
      '12',
      '13',
      '14',
      '15',
      '16',
      '17',
      '18',
      '19',
      '20',
      '21',
      '22'
    ];
    return FutureBuilder<dynamic>(
      future: fastingDetails,
      builder: (BuildContext context, AsyncSnapshot<dynamic?> snapshot) {
        // 1. Check if the Future is still running
        if (snapshot.data != null && snapshot.data['isFasting'] == true) {
          Timestamp x = snapshot.data['startTime'];
          isFasting = snapshot.data['isFasting'];
          selectedHours = snapshot.data['selectedTime'];
          Duration difference = DateTime.now().difference(x.toDate());
          // You can now use 'difference'
          totalTime = difference.inSeconds;
          // Convert hours to seconds
          remainingTime =
              formatTime((int.parse(selectedHours) * 60 * 60) - totalTime);
          if (((int.parse(selectedHours) * 60 * 60) - totalTime) <= 0) {
            resetTimer();
          } else {
            timer = Timer.periodic(Duration(seconds: 1), (t) {
              setState(() {
                totalTime--;
                remainingTime = formatTime(totalTime);
              });
            });
          }
          return SafeArea(
            child: Scaffold(
              body: Stack(
                children: [
                  VideoPlayer(_controller),
                  Center(
                    child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 30),
                      const Text(
                        'فترة الصوم سوف تنتهي بعد',
                        style: TextStyle(fontSize: 25, fontFamily: 'Cairo'),
                      ),
                      SizedBox(
                        width: 250,
                        // Adjust the width to make the circle wider
                        height: 250,
                        // Adjust the height to make the circle taller
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Transform.scale(
                              scale: 6,
                              // Adjust the scale factor to make the circle larger
                              child: CircularProgressIndicator(
                                value: totalTime /
                                    (int.parse(snapshot.data['selectedTime']) *
                                        60 *
                                        60),
                                strokeWidth: 2,
                                // Adjust the strokeWidth if needed
                                backgroundColor: Colors.grey[300],
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.teal),
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  remainingTime,
                                  style: TextStyle(fontSize: 35),
                                ),
                                Text(
                                  'ساعة',
                                  style: TextStyle(
                                      fontSize: 30, fontFamily: 'Cairo'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          stopTimer();
                        },
                        child: Text(
                          'إنهاء الصيام',
                          style: TextStyle(fontSize: 30, fontFamily: 'Cairo'),
                        ),
                      ),
                      SizedBox(height: 200,)
                    ],
                ),
                  )
                ],
              ),
              bottomNavigationBar: BottomNavigationBar(
                backgroundColor: Colors.white,
                currentIndex: 0,
                onTap: (int index) {
                  if (index == 0) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ArticlesList()));
                  } else if (index == 1) {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => RewardsPage()));
                  } else if (index == 2) {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => ProfilePage()));
                  }
                },
                items: [
                  BottomNavigationBarItem(
                      icon: Image(
                        image: AssetImage('images/book.png'),
                        width: 30,
                        height: 30,
                      ),
                      label: ''),
                  BottomNavigationBarItem(
                      icon: Image(
                        image: AssetImage('images/cups.png'),
                        width: 30,
                        height: 30,
                      ),
                      label: ''),
                  BottomNavigationBarItem(
                      icon: Image(
                        image: AssetImage('images/profile.jpeg'),
                        width: 30,
                        height: 30,
                      ),
                      label: ''),
                ],
              ),
            ),
          );
        } else {
          return SafeArea(
              child: Scaffold(
                backgroundColor: Colors.white,
                body: Stack(
                  children: [
                    VideoPlayer(_controller),
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              const Text(
                                'اختر عدد الساعات التي ترغب بصومها',
                                style: TextStyle(fontSize: 18, fontFamily: 'Cairo'),
                              ),
                              const SizedBox(height: 20),
                              CupertinoPicker(
                                backgroundColor: Colors.transparent,
                                itemExtent: 100.0,
                                onSelectedItemChanged: (int index) {
                                  setState(() {
                                    selectedHours = hours[index];
                                  });
                                  },
                                children: hours.map((String value) {
                                  return Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(' ساعة ', style: TextStyle(fontSize: 30, fontFamily: 'Cairo'),),
                                      Text(value, style: TextStyle(fontSize: 30),),
                                    ],
                                  );
                                }).toList(),
                          ),
                              SizedBox(height: 20,),
                              ElevatedButton(
                                onPressed: () {startTimer();},
                                child: Text('ابدأ', style: TextStyle(fontSize: 30, fontFamily: 'Cairo'),),
                              ),
                              SizedBox(height: 200,)
                        ],
                      ),
                        ],
                      ),
                    ),
                  ],
                ),
                bottomNavigationBar: BottomNavigationBar(
                  backgroundColor: Colors.white,
                  currentIndex: 0,
                  onTap: (int index) {
                    if (index == 0) {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => ArticlesList()));
                    } else if (index == 1) {Navigator.push(context, MaterialPageRoute(builder: (context) => RewardsPage()));
                    } else if (index == 2) {Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage()));}
                    },
              items: [
                BottomNavigationBarItem(
                    icon: Image(
                      image: AssetImage('images/book.png'),
                      width: 30,
                      height: 30,
                    ),
                    label: ''),
                BottomNavigationBarItem(
                    icon: Image(
                      image: AssetImage('images/cups.png'),
                      width: 30,
                      height: 30,
                    ),
                    label: ''),
                BottomNavigationBarItem(
                    icon: Image(
                      image: AssetImage('images/profile.jpeg'),
                      width: 30,
                      height: 30,
                    ),
                    label: ''),
              ],
            ),
          ));
        }
      },
    );
  }
}




class SliderPage extends StatefulWidget {
  @override
  _SliderPageState createState() => _SliderPageState();
}

class _SliderPageState extends State<SliderPage> {
  int _currentPage = 0;
  final List<String> _images = [
    'images/safe.jpeg',
    'images/natural.jpeg',
    'images/diseases.jpeg',
    'images/metabolism.jpeg'
  ];

  Timer? _timer;
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();

    // _timer = Timer.periodic(Duration(seconds: 3), (timer) {
    //   if (_currentPage == _images.length - 1) {
    //     _currentPage = 0;
    //     _pageController.jumpToPage(0); // jump to the first page
    //   } else {
    //     _currentPage++;
    //     _pageController.nextPage(duration: Duration(milliseconds: 350), curve: Curves.easeIn);
    //   }
    //   setState(() {}); // call setState
    // });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            Center(
              child: Column(children: [
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: (page) {
                      _currentPage = page;
                      setState(() {});
                    },
                    itemCount: _images.length,
                    itemBuilder: (context, index) => Container(
                      child: Image.asset(_images[index]),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        for (int i = 0; i < _images.length; i++)
                          Container(
                            width: 10.0,
                            height: 10.0,
                            margin: EdgeInsets.all(2.0),
                            decoration: BoxDecoration(
                              color:
                                  i == _currentPage ? Colors.blue : Colors.grey,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ]),
            ),
            Positioned(
              top: 20.0,
              right: 20.0,
              child: IconButton(
                icon: Icon(
                  Icons.skip_next,
                  color: Colors.black,
                  size: 30,
                ), // The "X" icon
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => CompleteData()));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
