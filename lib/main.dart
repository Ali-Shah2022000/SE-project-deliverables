library smooth_star_rating;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:path_provider/path_provider.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import 'dart:async';
import 'dart:io';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    home: Home(),
  ));
}

class Home extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: Text("SE Project"),
          elevation: 0,
          centerTitle: true,
          backgroundColor: Colors.transparent,
        ),
        body: Stack(children: [
          FutureBuilder(
              future: _initialization,
              builder:(context,snapshot)
              {
                if (snapshot.hasError)
                  {
                    return Center(child: Text("Could not connect"),);
                  }
                if(snapshot.connectionState==ConnectionState.done)
                  {
                    return Center(child: Text(""),);
                  }

                return Center(child: Text("in progress"));
              },

          ),
        Positioned(
            width: 200,
            top: 300,
            left: 80,
            height: 70,

            child: ElevatedButton(
              onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => loginScreen()),
                  );
              }, child: Text("Login")
        )
        ),
          Positioned(
              width: 200,
              top: 400,
              left: 80,
              height: 70,

              child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => signUp()),
                    );
                  }, child: Text("Sign up")
              )
          ),
          Positioned(
            child: Container(

                height: 200,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(0),
                      bottomRight: Radius.circular(1000)),
                )),
          ),
          Align(
            alignment: Alignment(0,1),
            child: Container(

                height: 200,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(0),
                      topLeft: Radius.circular(1000)),
                )),
          ),

        ]
    )
    );
  }
}


class rateDoctor extends StatefulWidget {
  rateDoctor({Key? key}) : super(key: key);
  @override
  State<rateDoctor> createState() => _rateDoctorState();
}

class _rateDoctorState extends State<rateDoctor> {
  double ratingTotal = 0.0;
  String comments = "";
  TextEditingController commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: Text(
            'Rate the doctor',
            style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                fontFamily: 'Roboto'),
          ),
          centerTitle: true,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back),
            color: Colors.white,
          ),
        ),
        body: Stack(children: [
          Positioned(
            child: Container(
                height: 300,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(2000),
                      bottomRight: Radius.circular(2000)),
                )),
          ),
          Positioned(
              top: 100,
              left: 0,
              right: 0,
              child: CircleAvatar(
                backgroundColor: Colors.blue,
                radius: 120,
                child: CircleAvatar(
                  radius: 110,
                  backgroundImage: AssetImage('assets/doctor.jpg'),
                ),
              )),
          Positioned(
            top: 360,
            left: 120,
            right: 0,
            child: Text(
              "Doctor name",
              style: TextStyle(
                fontSize: 20,
                color: Colors.black,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Positioned(
              top: 400,
              left: 25,
              right: 0,
              child: SmoothStarRating(
                rating: ratingTotal,
                isReadOnly: false,
                color: Colors.blue,
                size: 60,
                filledIconData: Icons.star,
                halfFilledIconData: Icons.star_half,
                defaultIconData: Icons.star_border,
                borderColor: Colors.black,
                starCount: 5,
                allowHalfRating: false,
                spacing: 2.0,
                onRated: (value) {
                  ratingTotal = value;
                  ratingTotal = value;
                  print("rating value -> ${ratingTotal}");

                  setState(() {
                    ratingTotal = value;
                  });
                  // print("rating value dd -> ${value.truncate()}");
                },
              )),
          Positioned(
              top: 475,
              left: 130,
              right: 0,
              child: Text(
                "Rating $ratingTotal",
                style: TextStyle(
                    fontSize: 20, fontFamily: 'Roboto', color: Colors.black),
              )),
          Align(
            alignment: Alignment(0, 0.5),
            child: TextField(
              keyboardType: TextInputType.multiline,
              maxLines: null,
              style: TextStyle(
                  fontSize: 20, fontFamily: 'Roboto', color: Colors.black),
              controller: commentController,
              decoration: InputDecoration(
                labelText: 'Enter any comments : ',
                fillColor: Colors.white,
                filled: true,
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              ),
            ),
          ),
          Positioned(
              top: 650,
              left: 0,
              right: 0,
              child: ElevatedButton(
                  onPressed: () {

                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            SecondPage(ratingTotal, commentController.text)));
                  },
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.blue)),
                  child: Text('Submit')))
        ]));
  }

}

class SecondPage extends StatefulWidget {
  double rating;
  String comments;
  SecondPage(this.rating, this.comments);
  @override
  State<StatefulWidget> createState() {
    return SecondPageState(this.rating, this.comments);
  }
}

class SecondPageState extends State<SecondPage> {
  String data = '';
  fetchFileData() async {
    _write(comments);
    String textFromFile;
    textFromFile = await rootBundle.loadString('texts/a.txt');

    setState(() {

      data = textFromFile;
      print(data);

    });
  }

  double rating;
  String comments;
  SecondPageState(this.rating, this.comments);

  @override
  _write(String text) async {

    final Directory directory = await getApplicationDocumentsDirectory();
    final File file = File('${directory.path}/texts/a.txt');
    await file.writeAsString(text);
  }
  void initState() {
    fetchFileData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Your ratings and comments"),
        ),

      body: Align(
        alignment: Alignment(0, 0),
        child: Text(data),
      ),
    );
  }
}


class loginScreen extends StatefulWidget {
  const loginScreen({Key? key}) : super(key: key);

  @override
  State<loginScreen> createState() => _loginScreenState();
}

class _loginScreenState extends State<loginScreen> {
  TextEditingController nameCon = TextEditingController();
  TextEditingController passCon = TextEditingController();
  CollectionReference users = FirebaseFirestore.instance.collection('users');



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
        title: Text("Login Screen"),
        leading: IconButton(
        onPressed: () {
        Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => Home()));
    },
    icon: Icon(Icons.arrow_back),
    color: Colors.white,
    ),
    ),
    body: Stack(children: [
      Positioned(
          top: 30,
          left:50,
          child: Text("Enter your credentials : ",style: TextStyle(
              fontSize: 25, fontFamily: 'Roboto', color: Colors.black))
      ),
      Positioned(child:
      Container(
        padding: const EdgeInsets.fromLTRB(10, 90, 10, 0),
        child: TextField(
          controller: nameCon,
          decoration: const InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(30))),
            labelText: 'Enter your username',

          ),
        ),
      ),
      ),
      Positioned(child:
      Container(
        padding: const EdgeInsets.fromLTRB(10, 190, 10, 0),
        child: TextField(
          obscureText: true,
          controller: passCon,
          decoration: const InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(30))),

            labelText: 'Enter your password',

          ),
        ),
      ),
      ),
      Container(
          height: 340,
          width: 400,
          padding: const EdgeInsets.fromLTRB(10, 280, 10, 10),
          child: ElevatedButton(
            child: const Text('Login'),
            onPressed:(){
              FirebaseAuth.instance.signInWithEmailAndPassword(
                  email: nameCon.text, password: passCon.text).then((value) async {
                  var firebaseUser =  FirebaseAuth.instance.currentUser;

                  users.doc(nameCon.text).get().then((value) {
                    print("=======================\n\n\n\nValue ${value['email']}");

                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => afterLogin(value['name'].toString(),value['email'].toString(),value['password'].toString(),double.parse(value['age'].toString()), value['gender'].toString(),double.parse(value['height'].toString()),double.parse(value['weight'].toString()),value['address'].toString(),double.parse(value['phoneNumber'].toString()))));
                  });
                //Navigator.of(context).push(MaterialPageRoute(builder: (context) => afterLogin()));
              }).onError((error, stackTrace){
                print("${error.toString()}");
              });
            }
            )
      ),
      Container(
          height: 400,
          width: 400,
          padding: const EdgeInsets.fromLTRB(10, 350, 10, 10),
          child: Text("Create a new Account :")
      ),
      Positioned(
        top: 335,
        left: 170,
      child: TextButton(
      child: const Text('Sign up',
        style: TextStyle(fontSize: 20),
      ),
      onPressed: () {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => signUp()));
      },
    ))
    ]
    )
    );
  }

}


class signUp extends StatefulWidget {
  const signUp({Key? key}) : super(key: key);

  @override
  State<signUp> createState() => _signUpState();
}

class _signUpState extends State<signUp> {
  TextEditingController fullnameCon = TextEditingController();
  TextEditingController nameCon = TextEditingController();
  TextEditingController passCon = TextEditingController();
  TextEditingController ageCon = TextEditingController();
  TextEditingController heightCon = TextEditingController();
  TextEditingController weightCon = TextEditingController();
  TextEditingController addressCon = TextEditingController();
  TextEditingController phoneCon = TextEditingController();
  String gender = '';

  final CollectionReference users = FirebaseFirestore.instance.collection(
      'users');
  var firebaseUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text("Sign Up"),
          leading: IconButton(
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => Home()));
            },
            icon: Icon(Icons.arrow_back),
            color: Colors.white,
          ),
        ),
        body: SingleChildScrollView(
            child:
            Stack(children: [
              Positioned(
                  top: 10,
                  left: 0,
                  right: 0,
                  child: CircleAvatar(
                    backgroundColor: Colors.blue,
                    radius: 90,
                    child: CircleAvatar(
                      radius: 80,
                      backgroundImage: AssetImage('assets/patient_default.png'),
                    ),
                  )),
              Positioned(child:
              Container(
                padding: const EdgeInsets.fromLTRB(10, 200, 10, 0),
                child: TextField(
                  controller: fullnameCon,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Enter your name',

                  ),
                ),
              ),
              ),
              Positioned(child:
              Container(
                padding: const EdgeInsets.fromLTRB(10, 270, 10, 0),
                child: TextField(
                  controller: nameCon,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Enter your Email',

                  ),
                ),
              ),
              ),
              Positioned(child:
              Container(
                padding: const EdgeInsets.fromLTRB(10, 340, 10, 0),
                child: TextField(
                  controller: passCon,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Enter your password',
                  ),
                ),
              ),
              ),
              Positioned(child:
              Container(
                padding: const EdgeInsets.fromLTRB(10, 410, 10, 0),
                child: TextFormField(
                  controller: ageCon,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Enter your age',
                  ),
                ),
              ),
              ),

              Container(
                  padding: const EdgeInsets.fromLTRB(90, 520, 0, 0),
                  child: Text("Your Gender:")
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(175, 470, 0, 0),
                child:
                ListTile(
                  title: Text('Male'),
                  leading: Radio(
                      value: "male",
                      groupValue: gender,
                      onChanged: (value) {
                        setState(() {
                          gender = value.toString();
                        });
                      }
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(175, 500, 0, 0),
                child:
                ListTile(
                  title: Text('Female'),
                  leading: Radio(
                      value: "female",
                      groupValue: gender,
                      onChanged: (value) {
                        setState(() {
                          gender = value.toString();
                        });
                      }
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(175, 530, 0, 0),
                child:
                ListTile(
                  title: Text('Other'),
                  leading: Radio(
                      value: "other",
                      groupValue: gender,
                      onChanged: (value) {
                        setState(() {
                          gender = value.toString();
                        });
                      }
                  ),
                ),
              ),
              Positioned(child:
              Container(
                padding: const EdgeInsets.fromLTRB(10, 585, 10, 0),
                child: TextFormField(
                  controller: heightCon,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Enter your height',
                  ),
                ),
              ),
              ),
              Positioned(child:
              Container(
                padding: const EdgeInsets.fromLTRB(10, 655, 10, 0),
                child: TextFormField(
                  controller: weightCon,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Enter your Weight',
                  ),
                ),
              ),
              ),
              Positioned(child:
              Container(
                padding: const EdgeInsets.fromLTRB(10, 725, 10, 0),
                child: TextFormField(
                  controller: addressCon,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Enter your address',
                  ),
                ),
              ),
              ),
              Positioned(child:
              Container(
                padding: const EdgeInsets.fromLTRB(10, 795, 10, 0),
                child: TextFormField(
                  controller: phoneCon,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Enter your phone number',
                  ),
                ),
              ),
              ),
              Container(
                  height: 950,
                  width: 400,
                  padding: const EdgeInsets.fromLTRB(10, 870, 10, 10),
                  child: ElevatedButton(
                    child: const Text('Register'),
                    onPressed: () {
                      FirebaseAuth.instance.createUserWithEmailAndPassword(
                          email: nameCon.text, password: passCon.text).then((
                          value) {
                        users.doc(nameCon.text).set({
                          'name': fullnameCon.text,
                          'email': nameCon.text,
                          'password': passCon.text,
                          'age': double.parse(ageCon.text),
                          'gender': gender,
                          'height': double.parse(heightCon.text),
                          'weight': double.parse(weightCon.text),
                          'address': addressCon.text,
                          'phoneNumber': double.parse(phoneCon.text),
                        })
                            .then((value) {
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) =>
                              afterLogin(
                                  fullnameCon.text,
                                  nameCon.text,
                                  passCon.text,
                                  double.parse(ageCon.text),
                                  gender,
                                  double.parse(heightCon.text),
                                  double.parse(weightCon.text),
                                  addressCon.text,
                                  double.parse(phoneCon.text))));
                        })
                            .catchError((error) =>
                            print("Failed to add user: $error"));
                      }).onError((error, stackTrace) {
                        print('Error this ${error.toString()}');
                      });
                    },
                  )
              ),

              Container(
                  padding: const EdgeInsets.fromLTRB(20, 970, 0, 30),
                  child: Text("Already have a acciount :"
                  )
              ),
              Container(
                  padding: const EdgeInsets.fromLTRB(200, 955, 0, 0),
                  child: TextButton(
                    child: const Text('Sign in',
                      style: TextStyle(fontSize: 20),
                    ),
                    onPressed: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(
                          builder: (context) => loginScreen()));
                    },
                  )
              ),
            ]
            )
        )
    );
  }
}
class calculateBmi extends StatefulWidget {

  String name,email,password,address,gender;
  double height,weight,phoneNumber;
  double age;
  calculateBmi(this.name,this.email,this.password,this.age,this.gender,this.height,this.weight,this.address,this.phoneNumber);

  @override
  State<StatefulWidget> createState() {
    return _calculateBmiState(this.name,this.email,this.password,this.age,this.gender,this.height,this.weight,this.address,this.phoneNumber);
  }


}

class _calculateBmiState extends State<calculateBmi> {

  String name,email,password,address,gender;
  double height=192,weight=130,phoneNumber;
  double age;
  double _result=-1;
  _calculateBmiState(this.name,this.email,this.password,this.age,this.gender,this.height,this.weight,this.address,this.phoneNumber)
  {
    final CollectionReference users = FirebaseFirestore.instance.collection('users');

    users.doc(email).get().then((value) {

      this.weight=double.parse(value['weight'].toString());
      this.height=double.parse(value['height'].toString());
    });
    this._result=weight/((height/100)*(height/100)) ;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
        title: Text("BMI"),
    leading: IconButton(
    onPressed: () {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => afterLogin(this.name,this.email,this.password,this.age,this.gender,this.height,this.weight,this.address,this.phoneNumber)));
    },
    icon: Icon(Icons.arrow_back),
    color: Colors.white,
    ),
    ),
    body: Stack(
      children: [
        Positioned(
          left: 70,
          top: 20,
            child:
        Text("BMI Calculator",style: TextStyle(fontSize: 30))
        ),
        Positioned(
            left: 80,
            top: 100,
            child:
            Text("Height in centimeter",style: TextStyle(fontSize: 20,color: Colors.blue))
        ),
        Positioned(
          top: 150,
          width: 350,
          child:
           Slider(
            min:0,
            max: 300,
            onChanged: (heightA){
              setState(() {
                height=double.parse(heightA.toStringAsFixed(2));
                _result =weight/((height/100)*(height/100));

              });
            },
            value: height,
            divisions: 250,
            activeColor: Colors.blue,
            label: "$height cm",
          ),
        ),
        Positioned(
          top: 200,
            left: 80,
            child:
        Text("${height.toStringAsFixed(2)} cm or ${(height/30.48).toStringAsFixed(2)} feet",style: TextStyle(color: Colors.blue,fontSize: 20))
        ),
        Positioned(
            left: 80,
            top: 270,
            child:
            Text("Weight in kilograms",style: TextStyle(fontSize: 20,color: Colors.blue))
        ),
        Positioned(
          top: 300,
          width: 350,
          child:
          Slider(
            min:0,
            max: 300,
            onChanged: (weightA){
              setState(() {
                weight=double.parse(weightA.toStringAsFixed(2));
                _result =weight/((height/100)*(height/100));

              });
            },
            value: weight,
            divisions: 100,
            activeColor: Colors.blue,
            label: "$weight Kg",
          ),
        ),
        Positioned(
            top: 350,
            left: 130,
            child:
            Text("${weight.toStringAsFixed(2)} kg",style: TextStyle(color: Colors.blue,fontSize: 20))
        ),
        Positioned(
            top: 400,
            left: 130,
            child:
            Text("BMI is",style: TextStyle(color: Colors.blue,fontSize: 30))
        ),
        Positioned(
            top: 450,
            left: 80,
            child:
            Text(" ${_result.toStringAsFixed(2)} kg/m2",style: TextStyle(color: Colors.red,fontSize: 30))
        ),
        Positioned(
            top: 500,
            left: 120,
            child:
            Text("${getMeaning()} ",style: TextStyle(color: Colors.red,fontSize: 20))
        ),
        Positioned(
            top: 550,
            left: 25,
            child:
            Text("${explaination()} ",style: TextStyle(color: Colors.blue,fontSize: 20))
        ),

      ],
    ),

    );


  }
    getMeaning() {
    if (_result >= 25) {
      return "Overweight";
    } else if (_result >= 18.5) {
      return "Normal";
    } else {
      return "Underweight";
    }
  }
  String explaination() {
    if (_result >= 25) {
      return "You have a higher than\n normal bodyweight.";
    } else if (_result >= 18.5) {
      return "You have a normal bodyweight.\n Good job!";
    } else {
      return "You have a lower than normal\n bodyweight. Try to eat more.";
    }
  }


}


class afterLogin extends StatefulWidget {
  String name,email,password,address,gender;
  double height,weight,phoneNumber;
  double age;
  afterLogin(this.name,this.email,this.password,this.age,this.gender,this.height,this.weight,this.address,this.phoneNumber);

  @override
  State<StatefulWidget> createState() {
    return _afterLoginState(this.name,this.email,this.password,this.age,this.gender,this.height,this.weight,this.address,this.phoneNumber);
  }

}

class _afterLoginState extends State<afterLogin> {
  String name,email,password,address,gender;
  double height,weight,phoneNumber;
  double age;
  _afterLoginState(this.name,this.email,this.password,this.age,this.gender,this.height,this.weight,this.address,this.phoneNumber);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: Text("Main Screen"),
          leading: IconButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => loginScreen()));
            },
            icon: Icon(Icons.arrow_back),
            color: Colors.white,
          ),
          centerTitle: true,
          backgroundColor: Colors.white10,
        ),
        body: Stack(
          children :[
          Container(
                  padding: const EdgeInsets.only(top:  500.0,left:120),
                  child:ElevatedButton(
              child: const Text('Calculate BMI'),
                  onPressed: () {

                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) => calculateBmi(this.name,this.email,this.password,this.age,this.gender,this.height,this.weight,this.address,this.phoneNumber)));
                })
          ),
          Container(

          padding: const EdgeInsets.only(top:  200.0,left:125),
        child:ElevatedButton(
            child: const Text('Rate Doctor'),
            onPressed: () {

              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => rateDoctor()));
            })
          ),
            Container(

                padding: const EdgeInsets.only(top:  350,left:125),
                child:ElevatedButton(
                    child: const Text('Edit Profile'),
                    onPressed: () {

                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) => editProfile(this.name,this.email,this.password,this.age,this.gender,this.height,this.weight,this.address,this.phoneNumber)));
                    })
            )
        ]
        )
        );

  }
}

class editProfile extends StatefulWidget {
  String name,email,password,address,gender;
  double height,weight,phoneNumber;
  double age;
  editProfile(this.name,this.email,this.password,this.age,this.gender,this.height,this.weight,this.address,this.phoneNumber, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _editProfileState(this.name,this.email,this.password,this.age,this.gender,this.height,this.weight,this.address,this.phoneNumber);
  }

}

class _editProfileState extends State<editProfile> {
  String name,email,password,address,gender;
  double height,weight,phoneNumber;
  double age;
  TextEditingController fullnameCon = TextEditingController();
  TextEditingController nameCon = TextEditingController();
  TextEditingController passCon = TextEditingController();
  TextEditingController ageCon = TextEditingController();
  TextEditingController heightCon = TextEditingController();
  TextEditingController weightCon = TextEditingController();
  TextEditingController addressCon = TextEditingController();
  TextEditingController phoneCon = TextEditingController();
  String genderForm = '';

  _editProfileState(this.name,this.email,this.password,this.age,this.gender,this.height,this.weight,this.address,this.phoneNumber)
  {
    fullnameCon.text=this.name;
    nameCon.text=this.email;
    passCon.text = this.password;
    ageCon.text=this.age.toString();
    heightCon.text = this.height.toString();
    weightCon.text= this.weight.toString();
    addressCon.text=this.address;
    phoneCon.text=this.phoneNumber.toString();
    genderForm=this.gender;
  }

  final CollectionReference users = FirebaseFirestore.instance.collection(
      'users');
  var firebaseUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text("Edit Profile"),
          leading: IconButton(
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => afterLogin(this.name,this.email,this.password,this.age,this.gender,this.height,this.weight,this.address,this.phoneNumber)));
            },
            icon: Icon(Icons.arrow_back),
            color: Colors.white,
          ),
        ),
        body: SingleChildScrollView(
            child:
            Stack(children: [
              Positioned(
                  top: 10,
                  left: 0,
                  right: 0,
                  child: CircleAvatar(
                    backgroundColor: Colors.blue,
                    radius: 90,
                    child: CircleAvatar(
                      radius: 80,
                      backgroundImage: AssetImage('assets/patient_default.png'),
                    ),
                  )),
              Positioned(child:
              Container(
                padding: const EdgeInsets.fromLTRB(20, 210, 10, 0),
                child: Text("Your Email is  ${nameCon.text}",style: TextStyle(fontSize: 20),)
                ),
              ),
              Positioned(child:
              Container(
                  padding: const EdgeInsets.fromLTRB(20, 270, 10, 0),
                  child: Text("Your password is  ${passCon.text}",style: TextStyle(fontSize: 20),)
              ),
              ),
              Positioned(child:
              Container(
                padding: const EdgeInsets.fromLTRB(10, 340, 10, 0),
                child: TextField(
                  controller: fullnameCon,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Enter your name',

                  ),
                ),
              ),
              ),


              Positioned(child:
              Container(
                padding: const EdgeInsets.fromLTRB(10, 410, 10, 0),
                child: TextFormField(
                  controller: ageCon,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Enter your age',
                  ),
                ),
              ),
              ),

              Container(
                  padding: const EdgeInsets.fromLTRB(90, 520, 0, 0),
                  child: Text("Your Gender:")
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(175, 470, 0, 0),
                child:
                ListTile(
                  title: Text('Male'),
                  leading: Radio(
                      value: "male",
                      groupValue: genderForm,
                      onChanged: (value) {
                        setState(() {
                          genderForm = value.toString();
                        });
                      }
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(175, 500, 0, 0),
                child:
                ListTile(
                  title: Text('Female'),
                  leading: Radio(
                      value: "female",
                      groupValue: genderForm,
                      onChanged: (value) {
                        setState(() {
                          genderForm = value.toString();
                        });
                      }
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(175, 530, 0, 0),
                child:
                ListTile(
                  title: Text('Other'),
                  leading: Radio(
                      value: "other",
                      groupValue: genderForm,
                      onChanged: (value) {
                        setState(() {
                          genderForm = value.toString();
                        });
                      }
                  ),
                ),
              ),
              Positioned(child:
              Container(
                padding: const EdgeInsets.fromLTRB(10, 585, 10, 0),
                child: TextFormField(
                  controller: heightCon,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Enter your height',
                  ),
                ),
              ),
              ),
              Positioned(child:
              Container(
                padding: const EdgeInsets.fromLTRB(10, 655, 10, 0),
                child: TextFormField(
                  controller: weightCon,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Enter your Weight',
                  ),
                ),
              ),
              ),
              Positioned(child:
              Container(
                padding: const EdgeInsets.fromLTRB(10, 725, 10, 0),
                child: TextFormField(
                  controller: addressCon,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Enter your address',
                  ),
                ),
              ),
              ),
              Positioned(child:
              Container(
                padding: const EdgeInsets.fromLTRB(10, 795, 10, 0),
                child: TextFormField(
                  controller: phoneCon,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Enter your phone number',
                  ),
                ),
              ),
              ),
              Container(
                  height: 950,
                  width: 400,
                  padding: const EdgeInsets.fromLTRB(10, 870, 10, 10),
                  child: ElevatedButton(
                    child: const Text('Update'),
                    onPressed: () {
                      users.doc(nameCon.text)
                          .update({'name': fullnameCon.text,
                        'password': passCon.text,
                        'age': double.parse(ageCon.text),
                        'gender': genderForm,
                        'height': double.parse(heightCon.text),
                        'weight': double.parse(weightCon.text),
                        'address': addressCon.text,
                        'phoneNumber': double.parse(phoneCon.text)
                      },)
                          .then((value) => print("User Updated"))
                          .catchError((error) => print("Failed to update user: $error"));
                    },
                  )
              ),

              Container(
                  padding: const EdgeInsets.fromLTRB(20, 970, 0, 30),
                  child: Text("Already have a acciount :"
                  )
              ),
              Container(
                  padding: const EdgeInsets.fromLTRB(200, 955, 0, 0),
                  child: TextButton(
                    child: const Text('Sign in',
                      style: TextStyle(fontSize: 20),
                    ),
                    onPressed: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(
                          builder: (context) => loginScreen()));
                    },
                  )
              ),
            ]
            )
        )
    );
  }
}



