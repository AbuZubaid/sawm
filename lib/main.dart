import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'signing.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'one.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'firebase_options.dart';
import 'dart:async';









void main() async {
  // This is for restrict changing the orientation
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform,);
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;




  final isPortrait = WidgetsBinding.instance.window.physicalSize.aspectRatio < 1;
  if (isPortrait) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  } else {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }
  @override
  void initState() {
    // Request permissions (iOS)
    _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // Get FCM token
    _firebaseMessaging.getToken().then((token) {
    });

    // Setup notification handlers
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    });
  }
  // Running our APP
  runApp(MaterialApp(
      home: TheApp()
  )
  );
}

class TheApp extends StatefulWidget {
  @override
  _TheAppState createState() => _TheAppState();
}

class _TheAppState extends State<TheApp> {
  final User? user = FirebaseAuth.instance.currentUser;

  Future<bool?> get fastingStatus async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return null;
    }

    String? identifier;

    // Get the provider info
    final signInMethod = user.providerData.first.providerId;
    if (signInMethod == 'phone') {
      identifier = user.phoneNumber;
    } else if (signInMethod == 'google.com'){  // For email/password login
      identifier = user.email;
    }

    if (identifier == null) {
      return null;
    }

    DocumentSnapshot snapshot;
    try {
      snapshot = await FirebaseFirestore.instance.collection('users').doc(identifier).get();
    } catch (e) {
      return null;
    }

    if (!snapshot.exists) {
      return null;
    }

    return (snapshot.data() as Map<String, dynamic>)['isFasting'] as bool?;
  }


  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: MyWelcomePage(),
      );
    } else {return FutureBuilder<bool?>(
      future: fastingStatus,
      builder: (BuildContext context, AsyncSnapshot<bool?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return LoadingPage(); // or any other loading widget
        }

        if (snapshot.hasError) {
          return const MyWelcomePage(); // or any other error widget
        }

        if (snapshot.data == true) {
          return HomeScreen(); // Consider changing this to a more appropriate widget based on the fasting status
        }

        if (snapshot.data == false) {
          return HomeScreen();
        }
        return const MyWelcomePage(); // this will be executed if snapshot.data is unexpectedly null
      },
    );}
  }
}




class LoadingPage extends StatefulWidget {
  @override
  _LoadingPageState createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> with TickerProviderStateMixin {
  AnimationController? _controller;
  Animation<double>? _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    final curvedAnimation = CurvedAnimation(parent: _controller!, curve: Curves.easeInOut);

    _animation = Tween<double>(begin: 0.4, end: 0.75).animate(curvedAnimation)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _controller!.reverse();
        } else if (status == AnimationStatus.dismissed) {
          _controller!.forward();
        }
      });

    _controller!.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: ScaleTransition(
          scale: _animation!,
          child: Image.asset('images/waitingl.jpg'),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }
}




void timeDifference() async {
  User? user = FirebaseAuth.instance.currentUser;
  Timestamp? x;
  Duration? difference;
  DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection('users').doc(user?.email).get();
  if (snapshot.exists) {
    Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;
    if (data != null && data.containsKey('startTime')) {
      x = data['startTime'];
    } else {x = Timestamp.now();}
  } else {x = Timestamp.now();}
  DateTime now = DateTime.now();
  if (x != null) {
    Duration difference = now.difference(x.toDate());
    // You can now use 'difference'
  } else {print("Timestamp is null");}
}




class MyWelcomePage extends StatefulWidget {
  const MyWelcomePage({Key? key}) : super(key: key);

  @override
  State<MyWelcomePage> createState() => _MyWelcomePageState();
}

class _MyWelcomePageState extends State<MyWelcomePage> {
  late VideoPlayerController _controller;

  @override
  // This is for the background Video Animation
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('images/vid.mp4');
    _controller.initialize().then((_) {
      _controller.setLooping(true);
      _controller.play();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SafeArea(
          child: Scaffold(
              body: Stack(
                children: [
                  VideoPlayer(_controller),
                  Center(
                    child: Column(
                      children: [
                        Container(
                          width: 400,
                          height: 400,
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.transparent
                          ),
                        ),
                        const SizedBox(height: 20,),
                        Text('أسلوب حياة .. وليس حمية',
                            style: TextStyle(decoration: TextDecoration.none, color: Colors.blue[400], fontSize: 28, fontFamily: 'Cairo', fontWeight: FontWeight.bold)),
                        const SizedBox(height: 40,),
                        Container(
                          width: 270,
                          height: 60,
                          decoration: BoxDecoration(
                              color: Colors.blue[400],
                              borderRadius: BorderRadius.circular(50)
                          ),
                          child: Builder(
                            builder: (context) =>
                                GestureDetector(
                                  child: const Center(
                                    child: Text('أنت هنا لأول مرة؟  لنبدأ',
                                        style: TextStyle(
                                            decoration: TextDecoration.none,
                                            color: Colors.white,
                                            fontSize: 22,
                                            fontFamily: 'Cairo')),
                                  ),
                                  onTap: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpPage()));
                                  },
                                ),
                          ),
                        ),
                        const SizedBox(height: 30,),
                        Container(
                          width: 270,
                          height: 60,
                          decoration: BoxDecoration(
                              color: Colors.blue[400],
                              borderRadius: BorderRadius.circular(50)
                          ),
                          child: Builder(
                            builder: (context) =>
                                GestureDetector(
                                  child: const Center(
                                    child: Text(
                                        'لديك حساب بالفعل؟  تسجيل الدخول',
                                        style: TextStyle(
                                            decoration: TextDecoration.none,
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontFamily: 'Cairo')),
                                  ),
                                  onTap: () {
                                    Navigator.push(context, MaterialPageRoute(
                                        builder: (context) => SignInPage()));
                                  },
                                ),
                          ),
                        ),
                        SizedBox(height: 50,)
                      ],
                    ),
                  ),
                ],
              )
          ),
        )
    );

  }
}