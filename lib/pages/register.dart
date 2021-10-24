
import 'package:atagon_mobile_dev/model/profile.dart';
import 'package:atagon_mobile_dev/pages/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final formKey = GlobalKey<FormState>();
  Profile profile = Profile(password: '', email: '', name: '', cpassword: '');
  final Future<FirebaseApp> firebase = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: firebase,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Scaffold(
              appBar: AppBar(
                title: Text('Error'),
              ),
              body: Center(
                child: Text('${snapshot.error}'),
              ),
            );
          }
          if (snapshot.connectionState == ConnectionState.done) {
            return Scaffold(
              appBar: AppBar(
                title: Text('สมัครสมาชิก'),
              ),
              body: Container(
                child: Form(
                  key: formKey,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      children: [
                        TextFormField(
                          decoration: const InputDecoration(
                            icon: Icon(Icons.person),
                            hintText: 'ชื่อ-นามสกุล',
                            labelText: 'ชื่อ-นามสกุล',
                          ),
                          onSaved: (String? name) {
                            profile.name = name!;
                          },
                          validator: RequiredValidator(
                              errorText: 'กรุณากรอก ชื่อ-นามสกุล'),
                          keyboardType: TextInputType.name,
                        ),
                        TextFormField(
                          onSaved: (String? email) {
                            profile.email = email!;
                          },
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            icon: Icon(Icons.email),
                            hintText: 'Email',
                          ),
                          validator: MultiValidator([
                            RequiredValidator(errorText: 'กรุณากรอก E-mail'),
                            EmailValidator(
                                errorText: 'รูปแบบ E-mail ไม่ถูกต้อง')
                          ]),
                        ),
                        TextFormField(
                          onSaved: (String? password) {
                            profile.password = password!;
                          },
                          obscureText: true,
                          decoration: const InputDecoration(
                            icon: Icon(Icons.password),
                            hintText: 'Password',
                          ),
                          validator: RequiredValidator(
                              errorText: 'กรุณากรอก password'),
                        ),
                        TextFormField(
                          onSaved: (String? cpassword) {
                            profile.cpassword = cpassword!;
                          },
                          obscureText: true,
                          decoration: const InputDecoration(
                            icon: Icon(Icons.password),
                            hintText: 'Confirm Password',
                          ),
                          validator: RequiredValidator(
                              errorText: 'กรุณายืนยัน password'),
                        ),
                        // Text('Password ต้องประกอบไปด้วย'),
                        // Text('จำนวนอักขระรวม'),
                        // Text('ตัวอักษรพิมพ์ใหญ่ (A-Z) อย่างน้อย 1 ตัว'),
                        // Text('ตัวอักษรพิมพ์เล็ก (a-z) อย่างน้อย 1 ตัว'),
                        // Text('ตัวเลข (0-9) อย่างน้อย 1 ตัว'),
                        SizedBox(
                          child: ElevatedButton.icon(
                              onPressed: () async {
                                if (formKey.currentState!.validate()) {
                                  formKey.currentState?.save();
                                  if (profile.password == profile.cpassword &&
                                      profile.password.length >= 6) {
                                    try {
                                      await FirebaseAuth.instance
                                          .createUserWithEmailAndPassword(
                                          email: profile.email,
                                          password: profile.password)
                                          .then((value) {
                                        formKey.currentState?.reset();
                                        Navigator.pushReplacement(context,
                                            MaterialPageRoute(
                                                builder: (context) {
                                                  return Home();
                                                }));
                                      });
                                    } on FirebaseAuthException catch (e) {
                                      print(e.code);
                                      String message = '';
                                      if (e.code == 'email-already-in-use') {
                                        message = 'มีอีเมล์นี้แล้ว';
                                      }
                                      Fluttertoast.showToast(
                                          msg: message,
                                          gravity: ToastGravity.CENTER);
                                      print(e.message);
                                    }
                                  } else {
                                    Fluttertoast.showToast(
                                        msg: 'password ไม่ตรงกัน',
                                        gravity: ToastGravity.CENTER);
                                  }
                                }
                              },
                              icon: Icon(Icons.app_registration),
                              label: Text('สมัครสมาชิก')),
                          width: double.infinity,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        });
  }
}
