import 'package:flutter/material.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'one.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:video_player/video_player.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'profile_and_data.dart';
import 'package:flutter/cupertino.dart';
import 'dart:math';

//SignUp Page

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
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
                Positioned(
                  top: 40, // adjust as needed
                  left: 10, // adjust as needed
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context); // to go back
                    },
                    child: const Icon(
                      Icons.arrow_back,
                      color: Colors.blue, // or whatever color you prefer
                      size: 40, // adjust size as needed
                    ),
                  ),
                ),
                Center(
                  child: Column(
                    children: [
                      Container(
                        width: 400,
                        height: 400,
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle, color: Colors.transparent),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text('أسلوب حياة .. وليس حمية',
                          style: TextStyle(decoration: TextDecoration.none, color: Colors.blue[400], fontSize: 28, fontFamily: 'Cairo', fontWeight: FontWeight.bold)),
                      const SizedBox(
                        height: 40,
                      ),
                      Container(
                        width: 270,
                        height: 60,
                        decoration: BoxDecoration(
                            color: Colors.blue[400],
                            borderRadius: BorderRadius.circular(50)),
                        child: GestureDetector(
                          child: Center(
                            child: const Text('تسجيل بواسطة الهاتف',
                                style: TextStyle(
                                    decoration: TextDecoration.none,
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontFamily: 'Cairo')),
                          ),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SignUpWithPhone()));
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Container(
                        width: 270,
                        height: 60,
                        decoration: BoxDecoration(
                            color: Colors.blue[400],
                            borderRadius: BorderRadius.circular(50)),
                        child: GoogleSignUpButton(),
                      ),
                      SizedBox(
                        height: 50,
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}

class SignUpWithPhone extends StatefulWidget {
  @override
  _SignUpWithPhoneState createState() => _SignUpWithPhoneState();
}

class _SignUpWithPhoneState extends State<SignUpWithPhone> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _smsController = TextEditingController();
  String? _verificationId;
  PhoneNumber _phoneNumber = PhoneNumber(isoCode: 'JO'); // Default to US
  bool _isVerificationPage = false;

  Future<void> _verifyPhoneNumber() async {
    // Check if user already exists in Firestore with the given phone number
    String fullPhoneNumber = _phoneNumber.phoneNumber!;
    DocumentSnapshot userDoc =
        await _firestore.collection('users').doc(fullPhoneNumber).get();

    if (userDoc.exists) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
          "أنت مسجل معنا بالفعل، إذهب إلى صفحة تسجيل الدخول",
          textDirection: TextDirection.rtl,
        )),
      );
    } else {
      String fullPhoneNumber = _phoneNumber.phoneNumber!;

      await _auth.verifyPhoneNumber(
        phoneNumber: fullPhoneNumber,
        timeout: const Duration(seconds: 60),
        verificationCompleted: (PhoneAuthCredential phoneAuthCredential) async {
          await _auth.signInWithCredential(phoneAuthCredential);
        },
        verificationFailed: (FirebaseAuthException authException) {
          print("Error: ${authException.message}");
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Error: ${authException.message}")),
          );
        },
        codeSent: (String verificationId, [int? forceResendingToken]) async {
          _verificationId = verificationId;
          setState(() {
            _isVerificationPage = true;
          });
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          _verificationId = verificationId;
        },
      );
    }
  }

  Future<void> _signUpWithPhoneNumber() async {
    try {
      // Before attempting to sign up, check if the user with this phone number already exists
      QuerySnapshot userDoc = await _firestore
          .collection('users')
          .where('phoneNumber', isEqualTo: _phoneController.text)
          .get();

      if (userDoc.docs.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text(
            "أنت مسجل معنا بالفعل، إذهب إلى صفحة تسجيل الدخول",
            textDirection: TextDirection.rtl,
          )),
        );
        return; // Exit the method if user exists
      }

      final PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: _smsController.text,
      );

      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user != null) {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => MainProfileData()));
      } else {}
    } catch (e) {
      print("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
            title: const Text(
          'تسجيل عبر الهاتف',
          style: TextStyle(fontFamily: 'Cairo'),
        )),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: _isVerificationPage
                ? [
                    TextField(
                      controller: _smsController,
                      decoration: const InputDecoration(
                          hintText: 'أدخل رمز التحقق',
                          hintStyle: TextStyle(fontFamily: 'Cairo')),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        _signUpWithPhoneNumber();
                      },
                      child: const Text('تسجيل'),
                    ),
                  ]
                : [
                    const SizedBox(height: 20),
                    InternationalPhoneNumberInput(
                      onInputChanged: (PhoneNumber number) {
                        _phoneNumber = number;
                      },
                      onInputValidated: (bool value) {},
                      selectorConfig: const SelectorConfig(
                        selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                      ),
                      ignoreBlank: false,
                      autoValidateMode: AutovalidateMode.disabled,
                      selectorTextStyle: const TextStyle(color: Colors.black),
                      initialValue: _phoneNumber,
                      textFieldController: _phoneController,
                      formatInput: false,
                      keyboardType: const TextInputType.numberWithOptions(
                          signed: true, decimal: true),
                      inputBorder: const OutlineInputBorder(),
                      onSaved: (PhoneNumber? number) {},
                      locale: 'ar', // Setting the locale to Arabic
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        print(_phoneNumber);
                        _verifyPhoneNumber(); // This is the corrected line.
                      },
                      child: const Text(
                        'أرسل رمز التحقق',
                        style: TextStyle(fontFamily: 'Cairo'),
                      ),
                    ),
                  ],
          ),
        ),
      ),
    );
  }
}

class SignUpEmail extends StatefulWidget {
  @override
  _SignUpEmailState createState() => _SignUpEmailState();
}

class _SignUpEmailState extends State<SignUpEmail> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text(
        'التسجيل بواسطة البريد الإلكتروني',
        style: TextStyle(fontFamily: 'Cairo'),
      )),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'البريد الإلكتروني'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'الرقم السري'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              child: const Text(
                'تسجيل',
                style: TextStyle(fontFamily: 'Cairo'),
              ),
              onPressed: _signUp,
            ),
          ],
        ),
      ),
    );
  }

  void _signUp() async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم التسجيل بنجاح .. أهلا وسهلا!')));

      // Navigate to the home screen
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => SliderPage()));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('أنت معنا بالفعل.. انت حبيبي من أيام الجيزة!')));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(e.message ?? 'An error occurred.')));
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}

class GoogleSignUpButton extends StatefulWidget {
  @override
  _GoogleSignUpButtonState createState() => _GoogleSignUpButtonState();
}

class _GoogleSignUpButtonState extends State<GoogleSignUpButton> {
  GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _googleSignIn.onCurrentUserChanged.listen(
        (GoogleSignInAccount? account) async {
      if (account != null) {
        final GoogleSignInAuthentication googleAuth =
            await account.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        final UserCredential authResult =
            await _auth.signInWithCredential(credential);
        final User? user = authResult.user;

        if (user != null) {
          // Check if user exists in Firestore
          DocumentSnapshot doc =
              await _firestore.collection('users').doc(user.email).get();

          if (doc.exists) {
            // User exists in Firebase, show SnackBar and navigate to SignInPage
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
                'أنت مسجل معنا بالفعل، إذهب إلى صفحة تسجيل الدخول',
                textDirection: TextDirection.rtl,
              ),
            ));
          } else {
            // User doesn't exist, store user data in Firestore and navigate to HomeScreen
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => MainProfileData()));
          }
        }
      }
    }, onError: (error) {
      // Handle error
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: () {
        _handleSignIn();
      },
      child: Center(
        child: const Text('تسجيل بواسطة جوجل',
            style: TextStyle(
                decoration: TextDecoration.none,
                color: Colors.white,
                fontSize: 18,
                fontFamily: 'Cairo')),
      ),
    );
  }

  Future<void> _handleSignIn() async {
    try {
      await _googleSignIn.signIn();
    } catch (error) {}
  }
}

//SignIn Page

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
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
              Positioned(
                top: 40, // adjust as needed
                left: 10, // adjust as needed
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context); // to go back
                  },
                  child: Icon(
                    Icons.arrow_back,
                    color: Colors.blue, // or whatever color you prefer
                    size: 40, // adjust size as needed
                  ),
                ),
              ),
              Center(
                child: Column(
                  children: [
                    Container(
                      width: 400,
                      height: 400,
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle, color: Colors.transparent),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text('أسلوب حياة .. وليس حمية',
                        style: TextStyle(decoration: TextDecoration.none, color: Colors.blue[400], fontSize: 28, fontFamily: 'Cairo', fontWeight: FontWeight.bold)),
                    const SizedBox(
                      height: 40,
                    ),
                    Container(
                      width: 270,
                      height: 60,
                      decoration: BoxDecoration(
                          color: Colors.blue[400],
                          borderRadius: BorderRadius.circular(50)),
                      child: GestureDetector(
                        child: Center(
                          child: const Text('تسجيل الدخول عبر الهاتف',
                              style: TextStyle(
                                  decoration: TextDecoration.none,
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontFamily: 'Cairo')),
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SignInWithPhone()));
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Container(
                      width: 270,
                      height: 60,
                      decoration: BoxDecoration(
                          color: Colors.blue[400],
                          borderRadius: BorderRadius.circular(50)),
                      child: GoogleSignInButton(),
                    ),
                    const SizedBox(height: 50,)
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class GoogleSignInPage extends StatefulWidget {
  @override
  _GoogleSignInPageState createState() => _GoogleSignInPageState();
}

class _GoogleSignInPageState extends State<GoogleSignInPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  _signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();

      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );
        final UserCredential authResult = await _auth.signInWithCredential(credential);
        final User? user = authResult.user;

        if (user != null) {
          // User is signed in
          Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()));
        }
      } else {
        // Google sign-in was cancelled or failed
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "ليس لديك حساب، إذهب إلى صفحة التسجيل",
              textDirection: TextDirection.rtl,
            ),
          ),
        );
      }
    } catch (error) {
      // Handle other potential errors here
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "تسجيل الدخول بواسطة جوجل",
          style: TextStyle(fontFamily: 'Cairo'),
        ),
      ),
      body: Center(
        child: ElevatedButton(
          child: const Text('تسجيل الدخول بواسطة جوجل'),
          onPressed: () {
            _signInWithGoogle();
          },
        ),
      ),
    );
  }
}

class SignInWithPhone extends StatefulWidget {
  @override
  _SignInWithPhoneState createState() => _SignInWithPhoneState();
}

class _SignInWithPhoneState extends State<SignInWithPhone> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance; // Added
  PhoneNumber? _phoneNumber;
  String? _verificationId;
  TextEditingController _smsController = TextEditingController();

  Future<bool> isPhoneNumberRegistered(String phoneNumber) async {
    final CollectionReference users = _firestore.collection('users');
    final DocumentSnapshot doc = await users.doc(phoneNumber).get();
    return doc.exists;
  }

  Future<void> _verifyPhoneNumber() async {
    if (_phoneNumber != null && _phoneNumber!.phoneNumber != null) {
      String fullPhoneNumber = _phoneNumber!.phoneNumber!;
      print("Verifying phone number: $fullPhoneNumber");

      final PhoneVerificationCompleted verificationCompleted =
          (PhoneAuthCredential phoneAuthCredential) async {
        await _auth.signInWithCredential(phoneAuthCredential);
        print(
            "Phone number automatically verified and user signed in: ${_auth.currentUser!.uid}");
        // Navigate to home screen after automatic successful sign-in.
      };

      final PhoneVerificationFailed verificationFailed =
          (FirebaseAuthException authException) {
        print(
            'Phone number verification failed. Code: ${authException.code}. Message: ${authException.message}');
      };

      final PhoneCodeSent codeSent =
          (String verificationId, [int? forceResendingToken]) async {
        print('Please check your phone for a verification code.');
        setState(() {
          _verificationId = verificationId;
        });
        _navigateToVerificationScreen();
      };

      final PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
          (String verificationId) {};

      await _auth.verifyPhoneNumber(
          phoneNumber: fullPhoneNumber,
          timeout: const Duration(seconds: 60),
          verificationCompleted: verificationCompleted,
          verificationFailed: verificationFailed,
          codeSent: codeSent,
          codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
    }
  }

  void _navigateToVerificationScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) {
        return Scaffold(
          appBar: AppBar(
            title: Text('رمز التحقق'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: _smsController,
                  decoration: InputDecoration(hintText: 'أدخل رمز التحقق'),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _signInWithPhoneNumber,
                  child: Text('تسجيل الدخول'),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Future<void> _signInWithPhoneNumber() async {
    try {
      final PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: _smsController.text,
      );

      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      final User? theUser = userCredential.user;

      if (theUser != null) {
        print("Successfully signed in UID: ${theUser.phoneNumber}");
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    HomeScreen())); // Return to the main screen
      } else {
        print("Failed to sign in.");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('تسجيل الدخول عبر الهاتف')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            InternationalPhoneNumberInput(
              initialValue: PhoneNumber(isoCode: 'JO'),
              onInputChanged: (PhoneNumber number) {
                _phoneNumber = number;
              },
              formatInput: true,
              hintText: 'أدخل رقم الهاتف ',
              selectorConfig: SelectorConfig(
                selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                showFlags: true, // Display country flags
                useEmoji:
                    false, // Use emoji flags (can be set to true if preferred)
              ),
              locale: 'ar', // To display country names in Arabic
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if (_phoneNumber != null && _phoneNumber!.phoneNumber != null) {
                  bool isRegistered =
                      await isPhoneNumberRegistered(_phoneNumber!.phoneNumber!);
                  if (isRegistered) {
                    _verifyPhoneNumber();
                  } else {
                    // Display an error message to the user that the number is not registered
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text(
                              'رقم الهاتف غير مسجل، إذهب إلى صفحة التسجيل')),
                    );
                  }
                }
              },
              child: Text('أرسل رمز التحقق'),
            ),
          ],
        ),
      ),
    );
  }
}

class SignInEmail extends StatefulWidget {
  @override
  _SignInEmailState createState() => _SignInEmailState();
}

class _SignInEmailState extends State<SignInEmail> {
  final _auth = FirebaseAuth.instance;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<void> _signIn() async {
    try {
      final user = await _auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      if (user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      }
    } catch (e) {
      if (e is FirebaseAuthException && e.code == 'user-not-found') {
      } else {}
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Center(
              child: Text(
        "تسجيل الدخول عبر البريد الإلكتروني",
        style: TextStyle(fontFamily: 'Cairo'),
      ))),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: "البريد الإلكتروني"),
            ),
            SizedBox(height: 16),
            TextField(
              obscureText: true,
              controller: _passwordController,
              decoration: InputDecoration(labelText: "كلمة السر"),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _signIn,
              child: Text("دخول"),
            ),
          ],
        ),
      ),
    );
  }
}

class GoogleSignInButton extends StatefulWidget {
  @override
  _GoogleSignInButtonState createState() => _GoogleSignInButtonState();
}

class _GoogleSignInButtonState extends State<GoogleSignInButton> {
  GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

  @override
  void initState() {
    super.initState();
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
      if (account != null) {
        // User signed in
        // You can access the user's details via `account` object
        // For example: account.displayName, account.email, etc.
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => GoogleSignInPage()));
      }
    }, onError: (error) {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: () {
        _handleSignIn();
      },
      child: Center(
        child: const Text('تسجيل الدخول عبر جوجل',
            style: TextStyle(
                decoration: TextDecoration.none,
                color: Colors.white,
                fontSize: 18,
                fontFamily: 'Cairo')),
      ),
    );
  }

  Future<void> _handleSignIn() async {
    try {
      await _googleSignIn.signIn();
    } catch (error) {}
  }
}
