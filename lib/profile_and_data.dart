import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:math' as math;
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sawm/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:sawm/signing.dart';
import 'one.dart';
import 'package:video_player/video_player.dart';
import 'package:fl_chart/fl_chart.dart';

enum Gender {
  male,
  female,
}

String name = '';


class MainProfileData extends StatefulWidget {
  @override
  _MainProfileDataState createState() => _MainProfileDataState();
}

class _MainProfileDataState extends State<MainProfileData> {
  String welcome = 'أهلاً وسهلاً \n ما إسمك؟';
  String name ='';
  final User? user = FirebaseAuth.instance.currentUser;
  void saveMainData() async {
    String? identifier;
    if (user == null) {
      return null;
    }
    final signInMethod = user?.providerData.first.providerId;
    if (signInMethod == 'phone') {
      identifier = user?.phoneNumber;
    } else if (signInMethod == 'google.com') {
      // For email/password login
      identifier = user?.email;
    }
    if (user != null) {
      await FirebaseFirestore.instance.collection('users').doc(identifier).set(
        {
          'Name': name,
          'Reason1': reason1,
          'Reason2': reason2,
          'Reason3': reason3,
        },
      );
    }
  }

  int step = 0;
  bool reason1 = false;
  bool reason2 = false;
  bool reason3 = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: _buildStepContent(),
        ),
      ),
    );
  }

  Widget _buildStepContent() {
    switch (step) {
      case 0:
        return SafeArea(
          child: Scaffold(
            resizeToAvoidBottomInset: true,
            backgroundColor: Colors.white,
            body: Column(children: [
              const Expanded(
                  child: SizedBox(
                height: 50,
              )
              ),
              Expanded(
                  child: Row(
                textDirection: TextDirection.rtl,
                children: [
                  Image(image: AssetImage('images/name.jpeg')),
                  SizedBox(
                    width: 10,
                  ),
                  Column(
                    children: [
                      Typing(
                          text: Text(
                        welcome,
                        textDirection: TextDirection.rtl,
                        style: TextStyle(fontSize: 24, fontFamily: 'Cairo'),
                      )),
                    ],
                  )
                ],
              )),
              Expanded(
                  child: TextField(
                onChanged: (val) {
                  setState(() {
                    name = val;
                  });
                },
                decoration: InputDecoration(
                    labelText: 'ما الإسم الذي تفضل أن نناديك به ؟'),
              )),
              const SizedBox(height: 50),
              ElevatedButton(
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.blue)),
                onPressed: () {
                  if (name != '') {
                    setState(() {
                      step++;
                    });
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('نود التعرف عليك، نرجو إدخال الإسم!')));
                  }
                },
                child: Text(
                  'استمرار',
                  style: TextStyle(fontFamily: 'Cairo'),
                ),
              ),
              const SizedBox(
                height: 100,
              )
            ]),
          ),
        );
      case 1:
        return SafeArea(
            child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 70,
            ),
            const Text(
              'ما هو هدفك من الصيام؟',
              style: TextStyle(fontFamily: 'Cairo', fontSize: 28),
            ),
            SizedBox(
              height: 40,
            ),
            Container(
              padding: EdgeInsets.all(10),
              width: 300,
              height: 100,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: Colors.white,
                  border: Border.all(
                    color: (reason1)
                        ? Colors.blueAccent
                        : Colors.blue,
                    width: 2,
                  )),
              child: Center(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      reason1 = !reason1;
                    });
                  },
                  child: Center(
                      child: Row(
                    textDirection: TextDirection.rtl,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (reason1)
                        Icon(
                          Icons.check,
                          color: Colors.blueAccent,
                        ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'إنقاص الوزن',
                        textDirection: TextDirection.rtl,
                        style: TextStyle(
                            fontSize: 24,
                            fontFamily: 'Cairo',
                            color: Colors.black),
                      ),
                      if (reason1)
                        SizedBox(
                          width: 30,
                        ),
                    ],
                  )),
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              padding: EdgeInsets.all(10),
              width: 299,
              height: 99,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: Colors.white,
                  border: Border.all(
                    color: (reason2)
                        ? Colors.blueAccent
                        : Colors.blue,
                    width: 2,
                  )),
              child: Center(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      reason2 = !reason2;
                    });
                  },
                  child: Center(
                      child: Row(
                    textDirection: TextDirection.rtl,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (reason2)
                        Icon(
                          Icons.check,
                          color: Colors.blueAccent,
                        ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'تحسين الحالة الصحية',
                        textDirection: TextDirection.rtl,
                        style: TextStyle(
                            fontSize: 24,
                            fontFamily: 'Cairo',
                            color: Colors.black),
                      ),
                      if (reason2)
                        SizedBox(
                          width: 30,
                        ),
                    ],
                  )),
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              padding: EdgeInsets.all(10),
              width: 300,
              height: 100,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: Colors.white,
                  border: Border.all(
                    color: (reason3)
                        ? Colors.blueAccent
                        : Colors.blue,
                    width: 2,
                  )),
              child: Center(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      reason3 = !reason3;
                    });
                  },
                  child: Center(
                      child: Row(
                    textDirection: TextDirection.rtl,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (reason3)
                        Icon(
                          Icons.check,
                          color: Colors.blueAccent,
                        ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'زيادة الطاقة والحيوية',
                        textDirection: TextDirection.rtl,
                        style: TextStyle(
                            fontSize: 24,
                            fontFamily: 'Cairo',
                            color: Colors.black),
                      ),
                      if (reason3)
                        SizedBox(
                          width: 30,
                        ),
                    ],
                  )),
                ),
              ),
            ),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                if (reason1 || reason2 || reason3) {
                  saveMainData();
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SliderPage()));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('يرجى إختيار هدفك من الصيام!')));
                }
              },
              child: Text(
                'إستمرار',
                style: TextStyle(fontFamily: 'Cairo', fontSize: 16),
              ),
            ),
            SizedBox(
              height: 30,
            )
          ],
        ));
      default:
        return SizedBox.shrink();
    }
  }
}


class CompleteData extends StatefulWidget {
  const CompleteData({Key? key}) : super(key: key);

  @override
  State<CompleteData> createState() => _CompleteDataState();
}

class _CompleteDataState extends State<CompleteData>{
  final User? user = FirebaseAuth.instance.currentUser;
  late VideoPlayerController _controller;
  late List<double> weights;
  DateTime birthDate = DateTime(DateTime.now().year - 20, 1, 1);
  TimeOfDay firstMealTime = TimeOfDay(hour: 8, minute: 0);
  TimeOfDay lastMealTime = TimeOfDay(hour: 20, minute: 0);
  TimeOfDay wakeTime = TimeOfDay(hour: 7, minute: 0);
  TimeOfDay sleepTime = TimeOfDay(hour: 22, minute: 0);
  Duration totalSleepHours = Duration(hours: 8);
  int step = 0;
  int selectedHeight = 160;
  int selectedWeight = 60;
  Gender? selectedGender;
  num? age;
  bool _hasDiabetes = false;
  bool _hasHighBloodPressure = false;
  bool _hasImmuneDiseases = false;
  bool _hasHypothyroidism = false;
  double bmi = 25;
  double calorieIntake = 1400;
  int suggestedHours = 14;
  double targetWeight = 0.0;
  int weekConsuming = 0;
  bool _isPregnant = false;
  bool _isBreastFeeding = false;
  String womenStatus = '';
  String? thename;

  void callName() async {
    String? identifier;
    if (user == null) {
      return null;
    }
    final signInMethod = user?.providerData.first.providerId;
    if (signInMethod == 'phone') {
      identifier = user?.phoneNumber;
    } else if (signInMethod == 'google.com') {
      // For email/password login
      identifier = user?.email;
    }
    if (user != null) {
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance.collection('users').doc(identifier).get();
      thename = documentSnapshot.get('Name');
    }
  }

  void saveCompleteData() async {
    String? identifier;
    if (user == null) {
      return null;
    }
    final signInMethod = user?.providerData.first.providerId;
    if (signInMethod == 'phone') {
      identifier = user?.phoneNumber;
    } else if (signInMethod == 'google.com') {
      // For email/password login
      identifier = user?.email;
    }
    if (user != null) {
      await FirebaseFirestore.instance.collection('users').doc(identifier).set({
        'Gender': '$selectedGender',
        'Age': '$age',
        'Weight': '$selectedWeight',
        'Height': '$selectedHeight',
        'BMI': '$bmi',
        'Birthday': '$birthDate',
        'Diabetes': '$_hasDiabetes',
        'BloodPressure': '$_hasHighBloodPressure',
        'ImmuneDis': '$_hasImmuneDiseases',
        'hypoThyroide': '$_hasHypothyroidism',
        'WakeTime': '$wakeTime',
        'SleepTime': '$sleepTime',
        'weekConsuming': '$weekConsuming'
      }, SetOptions(merge: true));
    }
  }

  String subtractHours(TimeOfDay time, int hours) {
    final now = DateTime.now();

    // Convert TimeOfDay to DateTime
    DateTime dateTime =
        DateTime(now.year, now.month, now.day, time.hour, time.minute);

    // Subtract hours
    DateTime subtractedDateTime = dateTime.subtract(Duration(hours: hours));

    // Format to "HH:mm"
    String formattedTime =
        '${subtractedDateTime.hour.toString().padLeft(2, '0')}:${subtractedDateTime.minute.toString().padLeft(2, '0')}';

    return formattedTime;
  }

  Duration totalSleep(TimeOfDay start, TimeOfDay end) {
    final now = DateTime.now();

    // Convert TimeOfDay to DateTime
    DateTime startTime =
        DateTime(now.year, now.month, now.day, start.hour, start.minute);
    DateTime endTime =
        DateTime(now.year, now.month, now.day, end.hour, end.minute);

    // If endTime is before startTime, it means the endTime is on the next day
    if (endTime.isBefore(startTime)) {
      endTime = endTime.add(Duration(days: 1));
    }

    // Return the difference
    return endTime.difference(startTime);
  }

  void calculateCalorieInBMI() {
    bmi = selectedWeight / pow(selectedHeight / 100, 2);
    bmi = double.parse(bmi!.toStringAsFixed(2));
    targetWeight = 22.0 * pow(selectedHeight / 100, 2);
    targetWeight = double.parse(targetWeight.toStringAsFixed(2));
    weekConsuming = ((selectedWeight - targetWeight) / 0.5).round();
    if (selectedGender == Gender.male) {
      calorieIntake = 260 +
          (9.65 * selectedWeight) +
          (5.73 * selectedHeight) -
          (5.08 * int.parse(age.toString()));
      calorieIntake = double.parse(calorieIntake.toStringAsFixed(0));
    } else if (selectedGender == Gender.female) {
      calorieIntake = 43 +
          (7.38 * selectedWeight) +
          (6.07 * selectedHeight) -
          (2.31 * int.parse(age.toString()));
      calorieIntake = double.parse(calorieIntake.toStringAsFixed(0));
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: _buildStepContent(),
        ),
      ),
    );
  }

  Widget _buildStepContent() {
    callName();
    double targetKg = 50.0; // initial kg value
    int targetGrams =
        0; // initial grams valuedouble targetKg = 40.0; // initial kg value
    final ending = subtractHours(wakeTime, -2);
    final starting = subtractHours(
        sleepTime, (suggestedHours - totalSleepHours!.inHours - 2));
    switch (step) {
      case 0:
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 70,
              ),
              const Text(
                'إختر الجنس ',
                style: TextStyle(fontFamily: 'Cairo', fontSize: 36),
              ),
              SizedBox(
                height: 40,
              ),
              Container(
                padding: EdgeInsets.all(10),
                width: 239,
                height: 119,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: (selectedGender == Gender.male)
                        ? Colors.blueAccent
                        : Colors.white,
                    border: Border.all(
                      color: Colors.blueAccent,
                      width: 2,
                    )),
                child: Center(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedGender = Gender.male;
                      });
                    },
                    child: Column(
                      children: [
                        Text(
                          'ذكر',
                          textDirection: TextDirection.rtl,
                          style: TextStyle(
                              fontSize: 24,
                              fontFamily: 'Cairo',
                              color: Colors.black),
                        ),
                        Icon(
                          Icons.male,
                          color: Colors.black,
                          size: 28,
                        )
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                padding: EdgeInsets.all(10),
                width: 239,
                height: 119,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: (selectedGender == Gender.female)
                        ? Color(0xFFFF8B8B)
                        : Colors.blueAccent,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(50),
                  color: (selectedGender == Gender.female)
                      ? Color(0xFFFF8B8B)
                      : Colors.white,
                ),
                child: Center(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedGender = Gender.female;
                      });
                    },
                    child: Column(
                      children: [
                        Text(
                          'أنثى',
                          textDirection: TextDirection.rtl,
                          style: TextStyle(
                              fontSize: 24,
                              fontFamily: 'Cairo',
                              color: Colors.black),
                        ),
                        Icon(
                          Icons.female,
                          color: Colors.black,
                          size: 28,
                        )
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 40,
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    if (selectedGender != null) {
                      if (selectedGender == Gender.female) {
                        step = 10;
                      } else {
                        step++;
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('يرجى إختيار الجنس!')));
                    }
                  });
                },
                child: Text(
                  'إستمرار',
                  style: TextStyle(fontFamily: 'Cairo', fontSize: 16),
                ),
              ),
              SizedBox(
                height: 30,
              )
            ],
          ),
        );
      case 1:
        return SafeArea(
          child: Column(
            children: [
              SizedBox(
                height: 150,
              ),
              Text('إختر تاريخ الميلاد',
                  style: TextStyle(fontFamily: 'Cairo', fontSize: 28)),
              SizedBox(
                height: 100,
              ),
              Expanded(
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.date,
                  initialDateTime: birthDate,
                  onDateTimeChanged: (DateTime newDateTime) {
                    setState(() {
                      birthDate = newDateTime;
                    });
                  },
                ),
              ),
              SizedBox(height: 50),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    step++;
                    age = DateTime.now().year - birthDate.year;
                    print('age = {$age}');
                  });
                },
                child: Text(
                  'إستمرار',
                  style: TextStyle(fontFamily: 'Cairo', fontSize: 16),
                ),
              ),
              SizedBox(
                height: 40,
              ),
            ],
          ),
        );
      case 2:
        return SafeArea(
            child: Column(
          children: [
            const SizedBox(height: 150),
            const Text(
              'إختر الطول ',
              style: TextStyle(fontFamily: 'Cairo', fontSize: 28),
            ),
            const SizedBox(height: 60),
            Expanded(
              child: CupertinoPicker(
                itemExtent: 32.0,
                onSelectedItemChanged: (index) {
                  setState(() {
                    selectedHeight = 100 + index;
                  });
                },
                children: List<Widget>.generate(
                    151, (index) => Text('${100 + index} cm')),
              ),
            ),
            const SizedBox(height: 60),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  step++;
                });
              },
              child: Text(
                'إستمرار',
                style: TextStyle(fontFamily: 'Cairo', fontSize: 16),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ));
      case 3:
        return SafeArea(
          child: Column(
            children: [
              SizedBox(
                height: 100,
              ),
              Text(
                'إختر الوزن ',
                style: TextStyle(fontFamily: 'Cairo', fontSize: 28),
              ),
              SizedBox(
                height: 60,
              ),
              Expanded(
                child: CupertinoPicker(
                  itemExtent: 32.0,
                  onSelectedItemChanged: (index) {
                    setState(() {
                      selectedWeight = 30 + index;
                      calculateCalorieInBMI();
                    });
                  },
                  children: List<Widget>.generate(
                      171, (index) => Text('${30 + index} kg')),
                ),
              ),
              SizedBox(
                height: 60,
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    calculateCalorieInBMI();
                    step++;
                  });
                },
                child: Text(
                  'إستمرار',
                  style: TextStyle(fontFamily: 'Cairo', fontSize: 16),
                ),
              ),
              SizedBox(height: 40),
            ],
          ),
        );
      case 4:
        return SafeArea(
            child: Column(
          children: [
            SizedBox(
              height: 120,
            ),
            Container(
              width: 400,
              child: Column(
                children: [
                  Row(
                    textDirection: TextDirection.rtl,
                    children: [
                      Text('مؤشر كتلة الجسم ',
                          style: TextStyle(fontFamily: 'Cairo', fontSize: 20)),
                      Text(' (BMI) ',
                          style: TextStyle(fontFamily: 'Cairo', fontSize: 20)),
                      Text(' $bmi ',
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 20,
                            color: (bmi > 25 || bmi < 18.5)
                                ? Colors.redAccent
                                : Colors.green,
                          ))
                    ],
                  ),
                  if (bmi < 18.5)
                    Text(
                        'هذا يعني أن وزنك أقل من المعدل الطبيعي، هل أنت متأكد من الإستمرار؟',
                        textDirection: TextDirection.rtl,
                        style: TextStyle(fontFamily: 'Cairo', fontSize: 28)),
                  if (bmi >= 18.5 && bmi <= 25)
                    Row(
                      textDirection: TextDirection.rtl,
                      children: [
                        Text('وزنك ضمن المعدل الطبيعي',
                            textDirection: TextDirection.rtl,
                            style:
                                TextStyle(fontFamily: 'Cairo', fontSize: 20)),
                      ],
                    ),
                  if (bmi > 25)
                    Text(
                      'سيساعدك الصيام المتقطع على التحكم بوزنك، والوصول للوزن المستهدف \n ونحن سنساعدك من خلال النصائح الطبية الموثوقة و التذكير المستمر',
                      style: TextStyle(fontFamily: 'Cairo', fontSize: 20),
                      textDirection: TextDirection.rtl,
                    ),
                  if (bmi > 30)
                    Text(
                      'مع ذلك، ننصحك بالمتابعة مع طبيب متخصص!',
                      style: TextStyle(fontFamily: 'Cairo', fontSize: 20),
                      textDirection: TextDirection.rtl,
                    ),
                ],
              ),
            ),
            SizedBox(
              height: 40,
            ),
            Text(
              'إختر الوزن المستهدف',
              style: TextStyle(fontFamily: 'Cairo', fontSize: 28),
            ),
            SizedBox(
              height: 40,
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: CupertinoPicker(
                      itemExtent: 32.0,
                      onSelectedItemChanged: (index) {
                        setState(() {
                          targetKg = 40.0 + index;
                          targetWeight = targetKg +
                              targetGrams / 1000.0; // kg increments by 1
                        });
                      },
                      children: List<Widget>.generate(
                          61,
                          (index) => Text(
                              '${(40.0 + index).toStringAsFixed(0)} kg')), // assuming 40 to 100 kg range
                    ),
                  ),
                  Expanded(
                    child: CupertinoPicker(
                      itemExtent: 32.0,
                      onSelectedItemChanged: (index) {
                        setState(() {
                          targetGrams = index * 100;
                          targetWeight = targetKg +
                              targetGrams / 1000.0; // grams increments by 100
                        });
                      },
                      children: List<Widget>.generate(
                          10,
                          (index) =>
                              Text('${index * 100} g')), // 0 to 900 grams
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 40,
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  if (targetWeight > selectedWeight) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text('الوزن المستهدف أعلى من وزنك الحالي!')),
                    );
                  } else {
                    step++;
                  }
                });
              },
              child: Text(
                'إستمرار',
                style: TextStyle(fontFamily: 'Cairo', fontSize: 16),
              ),
            ),
            SizedBox(height: 40),
          ],
        ));
      case 5:
        return SafeArea(
          child: Column(
            children: [
              SizedBox(
                height: 100,
              ),
              Text(
                'وقت الإستيقاظ',
                style: TextStyle(fontSize: 24, fontFamily: 'Cairo'),
              ),
              SizedBox(height: 40),
              Expanded(
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.time,
                  use24hFormat: true,
                  initialDateTime:
                      DateTime(2000, 1, 1, wakeTime.hour, wakeTime.minute),
                  onDateTimeChanged: (DateTime newDateTime) {
                    setState(() {
                      wakeTime = TimeOfDay.fromDateTime(newDateTime);
                    });
                  },
                ),
              ),
              SizedBox(
                height: 40,
              ),
              Text('وقت النوم',
                  style: TextStyle(fontSize: 24, fontFamily: 'Cairo')),
              SizedBox(height: 40),
              Expanded(
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.time,
                  use24hFormat: true,
                  initialDateTime:
                      DateTime(2000, 1, 1, sleepTime.hour, sleepTime.minute),
                  onDateTimeChanged: (DateTime newDateTime) {
                    setState(() {
                      sleepTime = TimeOfDay.fromDateTime(newDateTime);
                    });
                  },
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    step++;
                    totalSleepHours = totalSleep(sleepTime, wakeTime);
                    totalSleepHours!.inHours;
                    print(totalSleepHours);
                    print(wakeTime);
                    print(sleepTime);
                  });
                },
                child: Text(
                  'إستمرار',
                  style: TextStyle(fontFamily: 'Cairo', fontSize: 16),
                ),
              ),
              SizedBox(height: 40),
            ],
          ),
        );
      case 6:
        return SafeArea(
            child: Column(
          children: [
            SizedBox(
              height: 100,
            ),
            Text('وقت تناول الوجبة الأولى',
                style: TextStyle(fontSize: 24, fontFamily: 'Cairo')),
            SizedBox(height: 40),
            Expanded(
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.time,
                use24hFormat: true,
                initialDateTime: DateTime(
                    2000, 1, 1, firstMealTime.hour, firstMealTime.minute),
                onDateTimeChanged: (DateTime newDateTime) {
                  setState(() {
                    firstMealTime = TimeOfDay.fromDateTime(newDateTime);
                  });
                },
              ),
            ),
            SizedBox(
              height: 40,
            ),
            Text('وقت تناول الوجبة الأخيرة',
                style: TextStyle(fontSize: 24, fontFamily: 'Cairo')),
            SizedBox(height: 40),
            Expanded(
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.time,
                use24hFormat: true,
                initialDateTime: DateTime(
                    2000, 1, 1, lastMealTime.hour, lastMealTime.minute),
                onDateTimeChanged: (DateTime newDateTime) {
                  setState(() {
                    lastMealTime = TimeOfDay.fromDateTime(newDateTime);
                  });
                },
              ),
            ),
            SizedBox(
              height: 40,
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  if (firstMealTime.hour < wakeTime.hour ||
                      lastMealTime.hour > sleepTime.hour) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('وقت الوجبات ضمن أوقات النوم!')),
                    );
                  } else {
                    step++;
                    print(firstMealTime);
                    print(lastMealTime);
                  }
                });
              },
              child: Text(
                'إستمرار',
                style: TextStyle(fontFamily: 'Cairo', fontSize: 16),
              ),
            ),
            SizedBox(height: 40),
          ],
        ));
      case 7:
        return SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 70,
                ),
                const Text(
                  'هل تعاني من أمراض مزمنة؟ أخبرنا!',
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 24,
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _hasDiabetes = !_hasDiabetes;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.all(10),
                    width: 300,
                    height: 100,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: Colors.white,
                        border: Border.all(
                          color:
                              (_hasDiabetes) ? Colors.blueAccent : Colors.blue,
                          width: 2,
                        )),
                    child: Center(
                        child: Row(
                      textDirection: TextDirection.rtl,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (_hasDiabetes)
                          Icon(
                            Icons.check,
                            color: Colors.blueAccent,
                          ),
                        SizedBox(
                          width: 12,
                        ),
                        Text(
                          'السكري',
                          textDirection: TextDirection.rtl,
                          style: TextStyle(
                              fontSize: 24,
                              fontFamily: 'Cairo',
                              color: Colors.black),
                        ),
                        if (_hasDiabetes)
                          SizedBox(
                            width: 28,
                          ),
                      ],
                    )),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _hasHighBloodPressure = !_hasHighBloodPressure;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.all(10),
                    width: 300,
                    height: 100,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: Colors.white,
                        border: Border.all(
                          color: (_hasHighBloodPressure)
                              ? Colors.blueAccent
                              : Colors.blue,
                          width: 2,
                        )),
                    child: Center(
                        child: Row(
                      textDirection: TextDirection.rtl,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (_hasHighBloodPressure)
                          Icon(
                            Icons.check,
                            color: Colors.blueAccent,
                          ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          'إرتفاع ضغط الدم',
                          textDirection: TextDirection.rtl,
                          style: TextStyle(
                              fontSize: 24,
                              fontFamily: 'Cairo',
                              color: Colors.black),
                        ),
                        if (_hasHighBloodPressure)
                          SizedBox(
                            width: 28,
                          ),
                      ],
                    )),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _hasHypothyroidism = !_hasHypothyroidism;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.all(10),
                    width: 300,
                    height: 100,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: Colors.white,
                        border: Border.all(
                          color: (_hasHypothyroidism)
                              ? Colors.blueAccent
                              : Colors.blue,
                          width: 2,
                        )),
                    child: Center(
                        child: Row(
                      textDirection: TextDirection.rtl,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (_hasHypothyroidism)
                          Icon(
                            Icons.check,
                            color: Colors.blueAccent,
                          ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          'كسل الغدة الدرقية',
                          textDirection: TextDirection.rtl,
                          style: TextStyle(
                              fontSize: 24,
                              fontFamily: 'Cairo',
                              color: Colors.black),
                        ),
                        if (_hasHypothyroidism)
                          SizedBox(
                            width: 28,
                          ),
                      ],
                    )),
                  ),
                ),
                SizedBox(height: 30),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _hasImmuneDiseases = !_hasImmuneDiseases;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.all(10),
                    width: 300,
                    height: 100,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: Colors.white,
                        border: Border.all(
                          color: (_hasImmuneDiseases)
                              ? Colors.blueAccent
                              : Colors.blue,
                          width: 2,
                        )),
                    child: Center(
                        child: Row(
                      textDirection: TextDirection.rtl,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (_hasImmuneDiseases)
                          Icon(
                            Icons.check,
                            color: Colors.blueAccent,
                          ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          'أمراض المناعة الذاتية',
                          textDirection: TextDirection.rtl,
                          style: TextStyle(
                              fontSize: 24,
                              fontFamily: 'Cairo',
                              color: Colors.black),
                        ),
                        if (_hasImmuneDiseases)
                          SizedBox(
                            width: 28,
                          ),
                      ],
                    )),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      step++;
                      if (_hasDiabetes && age! >= 55) {
                        suggestedHours = 12;
                      } else if (age! <= 35 && !_hasDiabetes && !_hasImmuneDiseases && !_hasHypothyroidism) {
                        suggestedHours = 16;
                      } else {
                        suggestedHours = 14;
                      }
                    });
                  },
                  child: Text(
                    'إستمرار',
                    style: TextStyle(fontFamily: 'Cairo', fontSize: 16),
                  ),
                ),
                SizedBox(
                  height: 30,
                )
              ],
            ),
          ),
        );
      case 8:
        return Scaffold(
          body: Stack(
            children: [
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('images/EvidenceBased.jpeg'),
                  ),
                ),
              ),
              // Close icon
              Positioned(
                top: 20.0,
                right: 20.0,
                child: IconButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.white),
                  ),
                  onPressed: () {
                    setState(() {
                      step++;
                    });
                  },
                  icon: Icon(Icons.skip_next, size: 30,),
                ),
              ),
            ],
          ),
        );
      case 9:
        return SafeArea(
            child: SingleChildScrollView(
          child: Column(
            textDirection: TextDirection.rtl,
            children: [
              SizedBox(
                height: 60,
              ),
              Row(
                textDirection: TextDirection.rtl,
                children: [
                  Text(selectedGender == Gender.male ? 'عزيزي' : 'عزيزتي',
                      style: TextStyle(
                          fontFamily: 'Cairo', fontSize: 24
                      ),
                  ),
                  SizedBox(width: 10,),
                  Text('$thename',
                    style: TextStyle(
                        fontFamily: 'Cairo', fontSize: 24
                    ),
                  ),
                ],
              ),
              Text(
                '\n الصيام المتقطع هو خطوة مهمة في حياتك للحفاظ على صحتك والوصول لوزن مناسب',
                style: TextStyle(fontFamily: 'Cairo', fontSize: 24),
                textDirection: TextDirection.rtl,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'نسعد بمساندتك من أجل النجاح في هذه الخطوة             ',
                style: TextStyle(fontSize: 24, fontFamily: 'Cairo'),
                textDirection: TextDirection.rtl,
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                width: 400,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.white,
                  border: Border.all(
                    color: Colors.yellow,
                    width: 2,
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      textDirection: TextDirection.rtl,
                      children: [
                        Text(
                          'مدة الصيام ',
                          style: TextStyle(fontSize: 22, fontFamily: 'Cairo'),
                          textDirection: TextDirection.rtl,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          ' $suggestedHours ',
                          style: TextStyle(fontSize: 22, fontFamily: 'Cairo'),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          'ساعة',
                          style: TextStyle(fontSize: 22, fontFamily: 'Cairo'),
                          textDirection: TextDirection.rtl,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      textDirection: TextDirection.rtl,
                      children: [
                        Text('وقت الصيام يبدأ ',
                            style:
                                TextStyle(fontSize: 20, fontFamily: 'Cairo')),
                        SizedBox(
                          width: 10,
                        ),
                        Text('$starting',
                            style:
                                TextStyle(fontSize: 20, fontFamily: 'Cairo')),
                        SizedBox(
                          width: 10,
                        ),
                        Text('وينتهي',
                            style:
                                TextStyle(fontSize: 20, fontFamily: 'Cairo')),
                        SizedBox(
                          width: 10,
                        ),
                        Text('$ending',
                            style: TextStyle(fontSize: 20, fontFamily: 'Cairo'))
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      '** سيكون الصيام أسهل مع الوقت، وفى المستقبل سيمكنك اتباع خطط ذات فترات صيام أطول**',
                      style: TextStyle(fontSize: 20, fontFamily: 'Cairo'),
                      textDirection: TextDirection.rtl,
                    ),
                    SizedBox(
                      height: 10,
                    )
                  ],
                ),
              ),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.all(10),
                width: 400,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.white,
                  border: Border.all(
                    color: Colors.yellow,
                    width: 2,
                  ),
                ),
                child: Column(
                  textDirection: TextDirection.rtl,
                  children: [
                    Text(
                      'هدفنا خلال الأسبوع الأول هو خسارة 0.4  كيلوجرام',
                      style: TextStyle(fontFamily: 'Cairo', fontSize: 18),
                      textDirection: TextDirection.rtl,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'في حال الإلتزام بالصيام و النصائح، سنحقق هدفنا بخسارة بين 0.3 و 0.7 كغ أسبوعياً',
                      style: TextStyle(fontFamily: 'Cairo', fontSize: 18),
                      textDirection: TextDirection.rtl,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                padding: EdgeInsets.all(10),
                width: 400,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.white,
                  border: Border.all(
                    color: Colors.yellow,
                    width: 2,
                  ),
                ),
                child: Column(
                  textDirection: TextDirection.rtl,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      textDirection: TextDirection.rtl,
                      children: [
                        Text(
                          'مؤشر كتلة الجسم الحالي  ',
                          style: TextStyle(fontSize: 18, fontFamily: 'Cairo'),
                          textDirection: TextDirection.rtl,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          ' $bmi ',
                          style: TextStyle(fontSize: 18, fontFamily: 'Cairo'),
                        )
                      ],
                    ),
                    if (bmi > 25 && weekConsuming <= 26)
                      Row(
                        textDirection: TextDirection.rtl,
                        children: [
                          Text(
                            'سنصل إلى الوزن المستهدف ',
                            style: TextStyle(fontSize: 16, fontFamily: 'Cairo'),
                          ),
                          Text(
                            ' $targetWeight ',
                            style: TextStyle(fontSize: 16),
                          ),
                          Text(
                            ' كغ خلال ',
                            style: TextStyle(fontSize: 16, fontFamily: 'Cairo'),
                          ),
                          if (weekConsuming >= 24)
                            Text(
                              ' 24 ',
                              style: TextStyle(fontSize: 16),
                            ),
                          if (weekConsuming < 24)
                            Text(
                              ' $weekConsuming ',
                              style: TextStyle(fontSize: 16),
                            ),
                          Text(
                            'أسبوعاً',
                            style: TextStyle(fontFamily: 'Cairo', fontSize: 16),
                            textDirection: TextDirection.rtl,
                          ),
                        ],
                      ),
                    if (bmi > 25 && weekConsuming > 26)
                      Column(
                        children: [
                          Text(
                            'دعنا نحدد معا هدفا يمكن تحقيقه خلال ١٦ أسبوعا',
                            style: TextStyle(fontSize: 18, fontFamily: 'Cairo'),
                            textDirection: TextDirection.rtl,
                          ),
                          Row(
                            textDirection: TextDirection.rtl,
                            children: [
                              Text(
                                'سنصل إلى ',
                                style: TextStyle(
                                    fontSize: 16, fontFamily: 'Cairo'),
                              ),
                              Text(
                                ' ' + (selectedWeight - 7).toString() + ' ',
                                style: TextStyle(fontSize: 16),
                              ),
                              Text(
                                ' كغ خلال 16 أسبوعاً',
                                style: TextStyle(
                                    fontSize: 16, fontFamily: 'Cairo'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    if (bmi < 25)
                      Text(
                        'وزنك ضمن المعدل الطبيعي، لكن الصيام سيسهم أيضا في تحسين حالتك الصحية و إحساسك بالمزيد من الحيوية',
                        style: TextStyle(fontFamily: 'Cairo', fontSize: 18),
                        textDirection: TextDirection.rtl,
                      ),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                padding: EdgeInsets.all(10),
                width: 400,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.white,
                  border: Border.all(
                    color: Colors.yellow,
                    width: 2,
                  ),
                ),
                child: Column(
                  textDirection: TextDirection.rtl,
                  children: [
                    Row(
                      textDirection: TextDirection.rtl,
                      children: [
                        Text(
                          'إحرص على تناول الأدوية وفق تعليمات الطبيب',
                          style: TextStyle(fontSize: 16, fontFamily: 'Cairo'),
                          textDirection: TextDirection.rtl,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    if (_hasDiabetes)
                      Text(
                        'لا تردد في إنهاء الصيام في حالة ظهور أي أعراض مرتبطة بهبوط السكر',
                        style: TextStyle(fontSize: 16, fontFamily: 'Cairo'),
                        textDirection: TextDirection.rtl,
                      ),
                    SizedBox(
                      height: 5,
                    ),
                    if (_hasHypothyroidism)
                      Row(
                        textDirection: TextDirection.rtl,
                        children: [
                          Text(
                            'لا تنس الثيروكسين!',
                            textDirection: TextDirection.rtl,
                            style: TextStyle(fontFamily: 'Cairo', fontSize: 16),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              if (_hasDiabetes || _hasHighBloodPressure)
                Container(
                  padding: EdgeInsets.all(10),
                  width: 400,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.white,
                    border: Border.all(
                      color: Colors.yellow,
                      width: 2,
                    ),
                  ),
                  child: Column(
                    textDirection: TextDirection.rtl,
                    children: [
                      SizedBox(
                        height: 5,
                      ),
                      if (_hasDiabetes)
                        Text(
                          'شاركنا قراءات السكر، السكر الصيامي، والسكر التراكمي',
                          style: TextStyle(fontSize: 16, fontFamily: 'Cairo'),
                          textDirection: TextDirection.rtl,
                        ),
                      SizedBox(
                        height: 5,
                      ),
                      if (_hasHighBloodPressure)
                        Row(
                          textDirection: TextDirection.rtl,
                          children: [
                            Text(
                              'شاركنا قراءات الضغط!',
                              style:
                                  TextStyle(fontSize: 16, fontFamily: 'Cairo'),
                              textDirection: TextDirection.rtl,
                            ),
                          ],
                        ),
                      SizedBox(
                        height: 10,
                      ),
                      if (_hasHighBloodPressure || _hasDiabetes)
                        Text(
                          'تستطيع إدخال القراءات بأي وقت في صفحة ملفي الشخصي!',
                          style: TextStyle(fontSize: 16, fontFamily: 'Cairo'),
                          textDirection: TextDirection.rtl,
                        ),
                      SizedBox(
                        height: 5,
                      ),
                    ],
                  ),
                ),
              SizedBox(
                height: 10,
              ),
              Container(
                padding: EdgeInsets.all(10),
                width: 400,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.white,
                  border: Border.all(
                    color: Colors.yellow,
                    width: 2,
                  ),
                ),
                child: Column(
                  textDirection: TextDirection.rtl,
                  children: [
                    Text(
                      'تعتمد حاجتك من السعرات الحرارية على مدى نشاطك خلال اليوم!',
                      style: TextStyle(fontSize: 16, fontFamily: 'Cairo'),
                      textDirection: TextDirection.rtl,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      textDirection: TextDirection.rtl,
                      children: [
                        Text(
                          'حاجتك من السعرات الحرارية ',
                          style: TextStyle(fontSize: 16, fontFamily: 'Cairo'),
                          textDirection: TextDirection.rtl,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(' $calorieIntake ')
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    if (selectedGender == Gender.female && calorieIntake > 1400)
                      Text(
                        'بإمكانك تخفيض كمية السعرات اليومية ولكن بما لا يقل عن 1400 كيلو كالوري          ',
                        style: TextStyle(fontSize: 16, fontFamily: 'Cairo'),
                        textDirection: TextDirection.rtl,
                      ),
                    if (selectedGender == Gender.male && calorieIntake > 1800)
                      Text(
                        'بإمكانك تخفيض كمية السعرات اليومية ولكن بما لا يقل عن 1800 كيلو كالوري          ',
                        style: TextStyle(fontSize: 16, fontFamily: 'Cairo'),
                        textDirection: TextDirection.rtl,
                      ),
                    Text(
                      'مارس الرياضة بشكل منتظم، إن لم تستطع فحاول صعود الدرج بدلا من إستخدام المصعد!',
                      style: TextStyle(fontSize: 16, fontFamily: 'Cairo'),
                      textDirection: TextDirection.rtl,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      textDirection: TextDirection.rtl,
                      children: [
                        Text(
                          'مارس المشي يوميا بما لا يقل عن ٤٠٠٠ خطوة !',
                          style: TextStyle(fontSize: 16, fontFamily: 'Cairo'),
                          textDirection: TextDirection.rtl,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: () {
                  saveCompleteData();
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => HomeScreen()));
                },
                child: Text(
                  'لنبدأ',
                  style: TextStyle(fontFamily: 'Cairo', fontSize: 24),
                ),
              ),
              SizedBox(height: 30),
            ],
          ),
        ));
      case 10:
        return SafeArea(
            child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 50,
            ),
            const Text(
              'هل أنتِ حامل؟',
              textDirection: TextDirection.rtl,
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 28,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  _isPregnant = !_isPregnant;
                });
              },
              child: Container(
                padding: EdgeInsets.all(10),
                width: 300,
                height: 100,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.white,
                    border: Border.all(
                      color: (_isPregnant) ? Colors.blueAccent : Colors.blue,
                      width: 2,
                    )),
                child: Center(
                    child: Row(
                  textDirection: TextDirection.rtl,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (_isPregnant)
                      Icon(
                        Icons.check,
                        color: Colors.blueAccent,
                      ),
                    SizedBox(
                      width: 12,
                    ),
                    Text(
                      'نعم',
                      textDirection: TextDirection.rtl,
                      style: TextStyle(
                          fontSize: 24,
                          fontFamily: 'Cairo',
                          color: Colors.black),
                    ),
                    if (_isPregnant)
                      SizedBox(
                        width: 28,
                      ),
                  ],
                )),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  _isPregnant = !_isPregnant;
                });
              },
              child: Container(
                padding: EdgeInsets.all(10),
                width: 300,
                height: 100,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.white,
                    border: Border.all(
                      color: (_isPregnant) ? Colors.blueAccent : Colors.blue,
                      width: 2,
                    )),
                child: Center(
                    child: Row(
                  textDirection: TextDirection.rtl,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (!_isPregnant)
                      Icon(
                        Icons.check,
                        color: Colors.blueAccent,
                      ),
                    SizedBox(
                      width: 12,
                    ),
                    Text(
                      'لا',
                      textDirection: TextDirection.rtl,
                      style: TextStyle(
                          fontSize: 24,
                          fontFamily: 'Cairo',
                          color: Colors.black),
                    ),
                    if (!_isPregnant)
                      SizedBox(
                        width: 28,
                      ),
                  ],
                )),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            if (!_isPregnant)
              Column(
                children: [
                  const Text(
                    'هل أنتِ مرضع؟',
                    textDirection: TextDirection.rtl,
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 28,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _isBreastFeeding = !_isBreastFeeding;
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.all(10),
                      width: 300,
                      height: 100,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: Colors.white,
                          border: Border.all(
                            color: (_isBreastFeeding)
                                ? Colors.blueAccent
                                : Colors.blue,
                            width: 2,
                          )),
                      child: Center(
                          child: Row(
                        textDirection: TextDirection.rtl,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (_isBreastFeeding)
                            Icon(
                              Icons.check,
                              color: Colors.blueAccent,
                            ),
                          SizedBox(
                            width: 12,
                          ),
                          Text(
                            'نعم',
                            textDirection: TextDirection.rtl,
                            style: TextStyle(
                                fontSize: 24,
                                fontFamily: 'Cairo',
                                color: Colors.black),
                          ),
                          if (_isBreastFeeding)
                            SizedBox(
                              width: 28,
                            ),
                        ],
                      )),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _isBreastFeeding = !_isBreastFeeding;
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.all(10),
                      width: 300,
                      height: 100,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: Colors.white,
                          border: Border.all(
                            color: (_isBreastFeeding)
                                ? Colors.blueAccent
                                : Colors.blue,
                            width: 2,
                          )),
                      child: Center(
                          child: Row(
                        textDirection: TextDirection.rtl,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (!_isBreastFeeding)
                            Icon(
                              Icons.check,
                              color: Colors.blueAccent,
                            ),
                          SizedBox(
                            width: 12,
                          ),
                          Text(
                            'لا',
                            textDirection: TextDirection.rtl,
                            style: TextStyle(
                                fontSize: 24,
                                fontFamily: 'Cairo',
                                color: Colors.black),
                          ),
                          if (!_isBreastFeeding)
                            SizedBox(
                              width: 28,
                            ),
                        ],
                      )),
                    ),
                  ),
                ],
              ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  if (_isBreastFeeding || _isPregnant) {
                    step++;
                  } else {
                    step = 1;
                  }
                });
              },
              child: Text(
                'إستمرار',
                style: TextStyle(fontFamily: 'Cairo', fontSize: 20),
              ),
            ),
            SizedBox(
              height: 30,
            )
          ],
        ));
      case 11:
        return SafeArea(
            child: Scaffold(
                body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 100,
              ),
              Row(
                textDirection: TextDirection.rtl,
                children: [
                  Text(
                    'عزيزتي  ',
                    style: TextStyle(fontSize: 24, fontFamily: 'Cairo'),
                  ),
                  Text(
                    ' $name ',
                    style: TextStyle(fontSize: 24, fontFamily: 'Cairo'),
                  ),
                ],
              ),
              SizedBox(
                height: 30,
              ),
              Text(
                  'تطبيق صوم مخصص للنصائح الطبية الموثوقة  والمساعدة على إدارة الصيام المتقطع',
                  textDirection: TextDirection.rtl,
                  style: TextStyle(fontFamily: 'Cairo', fontSize: 28)),
              if (_isPregnant)
                Text(
                    'باعتبارك حامل لا يمكننا تقديم نصائح لك بخصوص الصيام المتقطع؛ لأنه غير مناسب لك!',
                    textDirection: TextDirection.rtl,
                    style: TextStyle(fontFamily: 'Cairo', fontSize: 28)),
              if (_isBreastFeeding)
                Text(
                    'باعتبارك مرضع لا يمكننا تقديم نصائح لك بخصوص الصيام المتقطع من خلال التطبيق!',
                    textDirection: TextDirection.rtl,
                    style: TextStyle(fontFamily: 'Cairo', fontSize: 28)),
              SizedBox(
                height: 30,
              ),
              Text('راجعي الطبيب واطلبي منه النصائح بخصوص حالتك',
                  textDirection: TextDirection.rtl,
                  style: TextStyle(fontFamily: 'Cairo', fontSize: 28)),
              SizedBox(
                height: 10,
              ),
              Text('نرحب بكِ دوما في تطبيق صَوم',
                  textDirection: TextDirection.rtl,
                  style: TextStyle(fontFamily: 'Cairo', fontSize: 28)),
              SizedBox(
                height: 10,
              ),
              Text('نأمل أن نراكِ قريباً ',
                  textDirection: TextDirection.rtl,
                  style: TextStyle(fontFamily: 'Cairo', fontSize: 28)),
              SizedBox(
                height: 30,
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MyWelcomePage()));
                  });
                },
                child: Text(
                  'خروج',
                  style: TextStyle(fontFamily: 'Cairo', fontSize: 28),
                ),
              ),
              SizedBox(
                height: 40,
              )
            ],
          ),
        )));

      default:
        return HomeScreen();
    }
  }
}





class Typing extends StatefulWidget {
  final Text text;
  final Duration duration;

  Typing(
      {required this.text, this.duration = const Duration(milliseconds: 100)});

  @override
  _TypingState createState() => _TypingState();
}

class _TypingState extends State<Typing> {
  // Corrected here
  String get targetText => widget.text.data ?? ''; // Extract the text data
  String displayedText = "";
  int currentIndex = 0;
  late Timer _timer;

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(widget.duration, (timer) {
      if (currentIndex < targetText.length) {
        setState(() {
          displayedText += targetText[currentIndex];
          currentIndex++;
        });
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel(); // Always cancel timers to prevent memory leaks
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      displayedText,
      style: widget.text.style, // Apply the given text style
    );
  }
}


class ClockPainter extends CustomPainter {
  final double startValue;
  final double endValue;
  final ImageProvider overlayImage;
  ImageInfo? _imageInfo;

  ClockPainter({
    required this.startValue,
    required this.endValue,
    required this.overlayImage,
  }) {
    _resolveImage();
  }

  void _resolveImage() {
    final ImageStream newStream =
        overlayImage.resolve(ImageConfiguration.empty);
    final ImageStreamListener listener = ImageStreamListener(
      (ImageInfo imageInfo, bool synchronousCall) {
        _imageInfo = imageInfo;
      },
    );
    newStream.addListener(listener);
  }

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final double startAngle = 2 * pi * startValue / 12 - pi / 2;
    final double sweepAngle = 2 * pi * (endValue - startValue) / 12;

    final matrix = Matrix4.identity()
      ..scale(size.width / _imageInfo!.image.width,
          size.height / _imageInfo!.image.height);

    final Paint overlayImagePaint = _imageInfo != null
        ? (Paint()
          ..shader = ImageShader(
            _imageInfo!.image,
            TileMode.clamp,
            TileMode.clamp,
            matrix.storage,
          ))
        : Paint();

    canvas.drawArc(Rect.fromCircle(center: center, radius: radius),
        startAngle + sweepAngle, 2 * pi - sweepAngle, true, overlayImagePaint);

    final Paint pointerPaint = Paint()
      ..color = Colors.black
      ..strokeWidth = 5;
    final startHourLength = radius - 20;
    final endHourLength = radius - 40;

    final startHourHandOffset = Offset(
      center.dx + startHourLength * cos(startAngle),
      center.dy + startHourLength * sin(startAngle),
    );
    final endHourHandOffset = Offset(
      center.dx + endHourLength * cos(startAngle + sweepAngle),
      center.dy + endHourLength * sin(startAngle + sweepAngle),
    );

    canvas.drawLine(center, startHourHandOffset, pointerPaint);
    canvas.drawLine(center, endHourHandOffset, pointerPaint);
  }

  @override
  bool shouldRepaint(ClockPainter oldDelegate) {
    if (overlayImage != oldDelegate.overlayImage) {
      _resolveImage();
    }
    return true;
  }
}

class ClockPage extends StatefulWidget {
  final double start;
  final double end;

  ClockPage({required this.start, required this.end});

  @override
  _ClockPageState createState() => _ClockPageState();
}

class _ClockPageState extends State<ClockPage> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    );

    _animation =
        Tween<double>(begin: widget.start, end: widget.end).animate(_controller)
          ..addListener(() {
            setState(() {});
          });

    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: 150,
          height: 150,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              image: AssetImage('images/TheFirst.jpeg'),
              fit: BoxFit.cover,
            ),
          ),
          child: CustomPaint(
            painter: ClockPainter(
              startValue: widget.start,
              endValue: _animation.value,
              overlayImage: AssetImage('images/TheSecond.jpeg'),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

// ClockPage(start: int.parse(ending.toString()[1]).toDouble(), end: int.parse(starting.toString()[1]).toDouble(),),



class Profile {
  final String name;
  final String gender;
  final String weight;
  final String height;
  final String bmi;
  final String age;

  Profile({
    required this.name,
    required this.gender,
    required this.weight,
    required this.height,
    required this.bmi,
    required this.age
  });

  factory Profile.fromMap(Map<String, dynamic>? data) {
    if (data == null) {
      throw ArgumentError('The provided data is null');
    }
    return Profile(
      name: data['Name'] ?? '',
      gender: data['Gender'] ?? '',
      weight: data['Weight'] ?? '',
      height: data['Height'] ?? '',
      bmi: data['BMI'] ?? '',
      age: data['Age'] ?? '',
    );
  }

}



class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Profile? _profile;
  bool _loading = true;
  DateTime? creationTime;
  final User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }
  Future<void> _signOut(BuildContext context) async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    try {
      await _auth.signOut();
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => MyWelcomePage(),
      ));

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('تم تسجيل الخروج بنجاح',
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
  Future<void> _creationTime() async {
    final User? user = FirebaseAuth.instance.currentUser;
    DateTime? creationTime = await user?.metadata.creationTime;
  }

  Future<void> _loadProfile() async {
    _creationTime();
    final User? user = FirebaseAuth.instance.currentUser;

    String? identifier;
    if (user == null) {return null;}
    final signInMethod = user.providerData.first.providerId;
    if (signInMethod == 'phone') {
      identifier = user.phoneNumber;
    } else if (signInMethod == 'google.com'){  // For email/password login
      identifier = user.email;
    }
    try {
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance.collection('users').doc(identifier).get();
      if (documentSnapshot.exists) {
        _profile = Profile.fromMap(documentSnapshot.data() as Map<String, dynamic>?);
      }
    } catch (e) {
      print('Error loading profile: $e');
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ملفي الشخصي', 
          textDirection: TextDirection.rtl, 
          style: TextStyle(fontFamily: 'Cairo', fontSize: 16),
        ),),
      body: _loading
          ? Center(child: LoadingPage())
          : SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20,),
            Container(
              width: 400,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.white,
                border: Border.all(
                  color: Colors.blue,
                  width: 2,
                ),
              ),
              child: Column(
                children: [
                  Row(
                    textDirection: TextDirection.rtl,
                    children: [
                      SizedBox(width: 10,),
                      Text('الإسم',
                          textDirection: TextDirection.rtl,
                          style: TextStyle(fontSize: 18, fontFamily: 'Cairo')
                      ),
                      Text(' : '),
                      SizedBox(width: 5,),
                      Text('${_profile?.name ?? ''}',
                          textDirection: TextDirection.rtl,
                          style: TextStyle(fontSize: 18, fontFamily: 'Cairo')
                      )
                    ],
                  ),
                  Row(
                    textDirection: TextDirection.rtl,
                    children: [
                      SizedBox(width: 10,),
                      Text('الجنس',
                          textDirection: TextDirection.rtl,
                          style: TextStyle(fontSize: 18, fontFamily: 'Cairo')
                      ),
                      Text(' : ', style: TextStyle(fontSize: 18),),
                      SizedBox(width: 5,),
                      Text(
                        _profile?.gender == 'Gender.male' ? 'ذكر' :
                        _profile?.gender == 'Gender.female' ? 'أنثى' : '',
                        textDirection: TextDirection.rtl,
                        style: TextStyle(fontSize: 18, fontFamily: 'Cairo'),
                      )

                    ],
                  ),
                  Row(
                    textDirection: TextDirection.rtl,
                    children: [
                      SizedBox(width: 10,),
                      Text('العمر',
                          textDirection: TextDirection.rtl,
                          style: TextStyle(fontSize: 18, fontFamily: 'Cairo')
                      ),
                      Text(' : ', style: TextStyle(fontSize: 18),),
                      SizedBox(width: 5,),
                      Text('${_profile?.age ?? ''}',
                          textDirection: TextDirection.rtl,
                          style: TextStyle(fontSize: 18, fontFamily: 'Cairo')
                      ),
                    ],
                  ),
                  Row(
                    textDirection: TextDirection.rtl,
                    children: [
                      SizedBox(width: 10,),
                      Text('الطول',
                          textDirection: TextDirection.rtl,
                          style: TextStyle(fontSize: 18, fontFamily: 'Cairo')
                      ),
                      Text(' : ', style: TextStyle(fontSize: 18),),
                      SizedBox(width: 5,),
                      Text('${_profile?.height ?? ''}',
                          textDirection: TextDirection.rtl,
                          style: TextStyle(fontSize: 18, fontFamily: 'Cairo')
                      ),
                    ],
                  ),
                  Row(
                    textDirection: TextDirection.rtl,
                    children: [
                      SizedBox(width: 10,),
                      Text('الوزن',
                          textDirection: TextDirection.rtl,
                          style: TextStyle(fontSize: 18, fontFamily: 'Cairo')
                      ),
                      Text(' : ', style: TextStyle(fontSize: 18),),
                      SizedBox(width: 5,),
                      Text('${_profile?.weight ?? ''}',
                          textDirection: TextDirection.rtl,
                          style: TextStyle(fontSize: 18, fontFamily: 'Cairo')
                      ),
                    ],
                  ),
                  Row(
                    textDirection: TextDirection.rtl,
                    children: [
                      SizedBox(width: 10,),
                      Text('مؤشر كتلة الجسم',
                          textDirection: TextDirection.rtl,
                          style: TextStyle(fontSize: 18, fontFamily: 'Cairo')
                      ),
                      Text(' : ', style: TextStyle(fontSize: 18),),
                      SizedBox(width: 5,),
                      Text('${_profile?.bmi ?? ''}',
                          textDirection: TextDirection.rtl,
                          style: TextStyle(fontSize: 18, fontFamily: 'Cairo')
                      ),
                    ],
                  ),
              ],),
            ),
            SizedBox(height: 20,),
            Container(
              width: 400,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.white,
                border: Border.all(
                  color: Colors.blue,
                  width: 2,
                ),
              ),
              child: Center(
                child: GestureDetector(
                  onTap: () {Navigator.push(context, MaterialPageRoute(builder: (context) => EditProfilePage()));},
                  child: Text('تعديل معلومات الملف الشخصي', style: TextStyle(color: Colors.red),),
                ),
              )
            ),
            SizedBox(height: 20,),
            Container(
              width: 400,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.white,
                border: Border.all(
                  color: Colors.blue,
                  width: 2,
                ),
              ),
              child: Column(
                children: [
                  Text('إشترك في صوم بلس من أجل المزيد من الإمتيازات والخدمات',
                    textDirection: TextDirection.rtl,
                    style: TextStyle(fontSize: 18, fontFamily: 'Cairo'),
                  ),
                  Row(
                    textDirection: TextDirection.rtl,
                    children: [
                      Icon(Icons.check, color: Colors.green, weight: 16,),
                      SizedBox(width: 5,),
                      Text('خطة صيام خاصة بك',
                        textDirection: TextDirection.rtl,
                        style: TextStyle(fontSize: 14, fontFamily: 'Cairo'),
                      )
                    ],
                  ),
                  Row(
                    textDirection: TextDirection.rtl,
                    children: [
                      Icon(Icons.check, color: Colors.green, weight: 16,),
                      SizedBox(width: 5,),
                      Text('متابعة مع طبيب متخصص و إجراء محادثة معه',
                        textDirection: TextDirection.rtl,
                        style: TextStyle(fontSize: 14, fontFamily: 'Cairo'),
                      )
                    ],
                  ),
                  Row(
                    textDirection: TextDirection.rtl,
                    children: [
                      Icon(Icons.check, color: Colors.green, weight: 16,),
                      SizedBox(width: 5,),
                      Text('تحليل بيانات الساعة الذكية من قبل طبيب',
                        textDirection: TextDirection.rtl,
                        style: TextStyle(fontSize: 14, fontFamily: 'Cairo'),
                      )
                    ],
                  ),
                  Row(
                    textDirection: TextDirection.rtl,
                    children: [
                      Icon(Icons.check, color: Colors.green, weight: 16,),
                      SizedBox(width: 5,),
                      Text('تتبع الوجبات والسعرات الحرارية ومعدل النشاط',
                        textDirection: TextDirection.rtl,
                        style: TextStyle(fontSize: 14, fontFamily: 'Cairo'),
                      )
                    ],
                  ),
                  SizedBox(height: 10,),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => PremiumPage()));
                    },
                    child: Text(
                      'إشتراك',
                      style: TextStyle(fontFamily: 'Cairo', fontSize: 18),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30,),
            Center(
              child: GestureDetector(
                onTap: () {_signOut(context);},
                child: Text('تسجيل الخروج',
                  textDirection: TextDirection.rtl,
                  style: TextStyle(fontSize: 14, fontFamily: 'Cairo'),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}






class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String? identifier;
  void identifiying() {
    final User? user = FirebaseAuth.instance.currentUser;
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
  }


  String? _name;
  double? _weight;
  @override
  Widget build(BuildContext context) {
    identifiying();
    return Scaffold(
      appBar: AppBar(
        title: Text('تحديث الملف الشخصي', style: TextStyle(fontFamily: 'Cairo'),),
      ),
      body: StreamBuilder<DocumentSnapshot>(
          stream: _firestore.collection('users').doc(identifier).snapshots(),
          builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text('Error fetching data'));
            }

            if (snapshot.connectionState == ConnectionState.active) {
              var userDocument = snapshot.data;
              return Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          initialValue: userDocument?["Name"] ?? '',
                          decoration: InputDecoration(labelText: 'الإسم'),
                          validator: (value) => value!.isEmpty ? 'لا تترك الخانة فارغة' : null,
                          onSaved: (value) => _name = value,
                        ),
                        TextFormField(
                          initialValue: userDocument?["Weight"].toString() ?? '',
                          decoration: InputDecoration(labelText: 'الوزن'),
                          validator: (value) => value!.isEmpty ? 'لا تترك الخانة فارغة' : null,
                          onSaved: (value) => _weight = double.tryParse(value!),
                        ),
                        SizedBox(height: 20,),
                        ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState?.save();
                              await _firestore.collection('users').doc(identifier).update({
                                'Name': _name,
                                'Weight': '$_weight',
                              });
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('تم التحديث بنجاح')));
                            }
                          },
                          child: Text('حفظ التغييرات', style: TextStyle(fontFamily: 'Cairo'),),
                        ),
                        SizedBox(height: 20,),
                        Expanded(
                          child: Container(
                              width: 400,
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.white,
                                border: Border.all(
                                  color: Colors.blue,
                                  width: 2,
                                ),
                              ),
                              child: Center(
                                child: TextButton(
                                    onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context) => BloodPressureInputPage()));},
                                    child: Text(
                                      'إدخال قراءة ضغط الدم',
                                      style: TextStyle(fontFamily: 'Cairo', fontSize: 18),)
                                ),
                              )
                          ),
                        ),
                        Expanded(child: SizedBox(height: 20,)),
                        Expanded(child: Container(
                            width: 400,
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.white,
                              border: Border.all(
                                color: Colors.blue,
                                width: 2,
                              ),
                            ),
                            child: Center(
                              child: TextButton(
                                  onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context) => GlucoseInputPage()));},
                                  child: Text(
                                    'إدخال قراءة سكر الدم',
                                    style: TextStyle(fontFamily: 'Cairo', fontSize: 18),)
                              ),
                            )
                        )),
                        Expanded(child: SizedBox(height: 20,)),
                        Expanded(child: Container(
                            width: 400,
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.white,
                              border: Border.all(
                                color: Colors.blue,
                                width: 2,
                              ),
                            ),
                            child: Center(
                              child: TextButton(
                                  onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context) => HbA1cInputPage()));},
                                  child: Text(
                                    'إدخال قراءة السكر التراكمي',
                                    style: TextStyle(fontFamily: 'Cairo', fontSize: 18),)
                              ),
                            )
                        )),
                        SizedBox(height: 30,)
                      ],
                    ),
                  ),
                );
            }

            return LoadingPage();
          },
        ),
    );
  }
}





class BloodPressureInputPage extends StatefulWidget {
  @override
  _BloodPressureInputPageState createState() => _BloodPressureInputPageState();
}

class _BloodPressureInputPageState extends State<BloodPressureInputPage> {
  final User? user = FirebaseAuth.instance.currentUser;
  String now = DateTime.now().toString();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _bloodPressureController = TextEditingController();
  String? _storedBloodPressure; // Variable to store the blood pressure value

  @override
  void dispose() {
    _bloodPressureController.dispose();
    super.dispose();
  }

  void _storeCurrentInput() async {
    setState(() {
      _storedBloodPressure = _bloodPressureController.text;
    });
    String? identifier;
    if (user == null) {
      return null;
    }
    final signInMethod = user?.providerData.first.providerId;
    if (signInMethod == 'phone') {
      identifier = user?.phoneNumber;
    } else if (signInMethod == 'google.com') {
      // For email/password login
      identifier = user?.email;
    }
    if (user != null) {
      await FirebaseFirestore.instance.collection('data').doc(identifier).set({
        '$now': 'Blood Pressure: $_storedBloodPressure'
      }, SetOptions(merge: true) );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: TextFormField(
                  controller: _bloodPressureController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'أدخل ضغط الدم (مثال 120/80)',
                    labelText: 'ضغط الدم',
                  ),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your blood pressure';
                    }
                    // Validate the format of the blood pressure
                    RegExp regExp = RegExp(r'^\d{1,3}\/\d{1,3}$');
                    if (!regExp.hasMatch(value)) {
                      return 'Please enter a valid format (e.g., 120/80)';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8),
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      // If the form is valid, display a snackbar and store the data
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('تم إدخال القراءة بنجاح')),
                      );
                      _storeCurrentInput();
                      print('$_storedBloodPressure');
                    }
                  },
                  child: Center(child: Text('إدخال')),
                ),
              ),
            ],
          ),
        ),
    );
  }
}




class GlucoseInputPage extends StatefulWidget {
  @override
  _GlucoseInputPageState createState() => _GlucoseInputPageState();
}

class _GlucoseInputPageState extends State<GlucoseInputPage> {
  final User? user = FirebaseAuth.instance.currentUser;
  String now = DateTime.now().toString();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _glucoseController = TextEditingController();
  String? _storedGlucose;

  @override
  void dispose() {
    _glucoseController.dispose();
    super.dispose();
  }


  void _storeCurrentInput() async {
    setState(() {
      _storedGlucose = _glucoseController.text;
    });
    String? identifier;
    if (user == null) {
      return null;
    }
    final signInMethod = user?.providerData.first.providerId;
    if (signInMethod == 'phone') {
      identifier = user?.phoneNumber;
    } else if (signInMethod == 'google.com') {
      // For email/password login
      identifier = user?.email;
    }
    if (user != null) {
      await FirebaseFirestore.instance.collection('data').doc(identifier).set({
        '$now': 'Glucose: $_storedGlucose'
      }, SetOptions(merge: true));
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: TextFormField(
                  controller: _glucoseController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'أدخل قراءة سكر الدم',
                    labelText: '(mg/dL) سكر الدم',
                  ),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your glucose level';
                    }
                    // You can add more specific validation here (e.g., range checks)
                    return null;
                  },
                ),
              ),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('تم إدخال القراءة بنجاح')),
                      );
                      _storeCurrentInput();
                    }
                  },
                  child: Text('إدخال'),
                ),
              ),
            ],
          ),
        ),
    );
  }
}


class HbA1cInputPage extends StatefulWidget {
  @override
  _HbA1cInputPageState createState() => _HbA1cInputPageState();
}

class _HbA1cInputPageState extends State<HbA1cInputPage> {
  final User? user = FirebaseAuth.instance.currentUser;
  String now = DateTime.now().toString();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _hba1cController = TextEditingController();
  String? _storedHbA1c;

  @override
  void dispose() {
    _hba1cController.dispose();
    super.dispose();
  }

  void _storeCurrentInput() async {
    setState(() {
      _storedHbA1c = _hba1cController.text;
    });
    String? identifier;
    if (user == null) {
      return null;
    }
    final signInMethod = user?.providerData.first.providerId;
    if (signInMethod == 'phone') {
      identifier = user?.phoneNumber;
    } else if (signInMethod == 'google.com') {
      // For email/password login
      identifier = user?.email;
    }
    if (user != null) {
      await FirebaseFirestore.instance.collection('data').doc(identifier).set({
        '$now': 'HbA1c: $_storedHbA1c'
      }, SetOptions(merge: true));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: TextFormField(
                  controller: _hba1cController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter your HbA1c level',
                    labelText: 'HbA1c (%)',
                  ),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your HbA1c level';
                    }
                    // You can add more specific validation here (e.g., range checks)
                    return null;
                  },
                ),
              ),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('تم إدخال القراءة بنجاح')),
                      );
                      _storeCurrentInput();
                    }
                  },
                  child: Text('إدخال'),
                ),
              ),
            ],
          ),
      ),
    );
  }
}




class PremiumPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('صوم بلس'),
      ),
      body: Center(
        child: Image.asset('images/soon.png'),
      ),
    );
  }
}


class RewardsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF7951AD),
        title: Text(''),
      ),
      body: Center(
        child: Image.asset('images/rewards.png'),
      ),
    );
  }
}


class AddArticlePage extends StatefulWidget {
  @override
  _AddArticlePageState createState() => _AddArticlePageState();
}

class _AddArticlePageState extends State<AddArticlePage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _articleController = TextEditingController();
  final CollectionReference articles = FirebaseFirestore.instance.collection('articles');

  Future<void> addArticle() async {
    String title = _titleController.text;
    String content = _articleController.text;

    // Check if title or content is empty
    if (title.isEmpty || content.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Title and Article content are required!')),
      );
      return;
    }

    try {
      await articles.doc(title).set({
        'content': content,
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Article added successfully!')),
      );
      _titleController.clear();
      _articleController.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add article. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Article'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Article Title'),
            ),
            SizedBox(height: 16),
            Expanded(
              child: TextField(
                controller: _articleController,
                maxLines: null,
                expands: true,
                decoration: InputDecoration(labelText: 'Article Content'),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: addArticle,
              child: Text('Add Article'),
            ),
            SizedBox(height: 5,),
            ElevatedButton(
              onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context) => DeleteArticlePage()));},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red, // Background color for the delete button
              ),
              child: Text('Delete Article'),
            ),

          ],
        ),
      ),
    );
  }
}



class ArticlesList extends StatefulWidget {
  @override
  _ArticlesListState createState() => _ArticlesListState();
}

class _ArticlesListState extends State<ArticlesList> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: GestureDetector(
            child: Text('مقالات', style: TextStyle(fontFamily: 'Cairo', fontSize: 14),),
            onTap: () {
              if (user?.phoneNumber == '+962790899125')
                Navigator.push(context, MaterialPageRoute(builder: (context) => AddArticlePage()));
              },)
      ),
      body: StreamBuilder(
        stream: _firestore.collection('articles').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) return Text('Error: ${snapshot.error}');
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return CircularProgressIndicator();
            default:
              return ListView(
                children: snapshot.data!.docs.map((DocumentSnapshot document) {
                  return ListTile(
                    title: Text(document.id, textDirection: TextDirection.rtl,
                      style: TextStyle(fontSize: 18, fontFamily: 'Cairo'),),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ArticleDetail(title: document.id, content: document.get('content')),
                        ),
                      );
                    },
                  );
                }).toList(),
              );
          }
        },
      ),
    );
  }
}




class ArticleDetail extends StatelessWidget {
  final String title;
  final String content;

  ArticleDetail({required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('مقالات',
          textDirection: TextDirection.rtl,
          style: TextStyle(fontFamily: 'Cairo', fontSize: 18),),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              textDirection: TextDirection.rtl,
              style: TextStyle(fontFamily: 'Cairo', fontSize: 18),
            ),
            SizedBox(height: 16),
            Text(content,
              textDirection: TextDirection.rtl,
              style: TextStyle(fontFamily: 'Cairo', fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}


class DeleteArticlePage extends StatefulWidget {
  @override
  _DeleteArticlePageState createState() => _DeleteArticlePageState();
}

class _DeleteArticlePageState extends State<DeleteArticlePage> {
  final CollectionReference articles = FirebaseFirestore.instance.collection('articles');
  String? selectedTitle;

  Future<void> deleteSelectedArticle() async {
    if (selectedTitle == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select an article to delete.')),
      );
      return;
    }

    try {
      await articles.doc(selectedTitle).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Article deleted successfully!')),
      );
      setState(() {
        selectedTitle = null;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete article. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Delete Article'),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: articles.snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return CircularProgressIndicator();

                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot doc = snapshot.data!.docs[index];
                    return ListTile(
                      title: Text(doc.id), // Displaying article title (which is the doc id)
                      onTap: () {
                        setState(() {
                          selectedTitle = doc.id;
                        });
                      },
                      selected: selectedTitle == doc.id,
                    );
                  },
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: deleteSelectedArticle,
            child: Text('Delete Selected Article'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
          )
        ],
      ),
    );
  }
}