import 'package:atagon_mobile_dev/model/profile.dart';
import 'package:atagon_mobile_dev/pages/login.dart';
import 'package:atagon_mobile_dev/pages/register.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:atagon_mobile_dev/model/profile.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';


class Home extends StatelessWidget {
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
                title: Text('เข้าสู่ระบบ'),
              ),
              body: Container(
                child: Form(
                  key: formKey,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      children: [
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
                        SizedBox(
                          child: ElevatedButton.icon(
                              onPressed: () async {
                                if (formKey.currentState!.validate()) {
                                  formKey.currentState?.save();

                                  try {
                                    await FirebaseAuth.instance
                                        .signInWithEmailAndPassword(
                                        email: profile.email,
                                        password: profile.password)
                                        .then(
                                          (value) {
                                        formKey.currentState?.reset();
                                        Navigator.pushReplacement(context,
                                            MaterialPageRoute(
                                                builder: (context) {
                                                  return Login();
                                                }));
                                      },
                                    );
                                    // Navigator.pushReplacement(context,
                                    //     MaterialPageRoute(builder: (context) {
                                    //   return Login();
                                    // }));
                                  } on FirebaseAuthException catch (e) {
                                    Fluttertoast.showToast(
                                        msg: e.message.toString(),
                                        gravity: ToastGravity.CENTER);
                                    print(e.message);
                                  }
                                }
                              },
                              icon: Icon(Icons.login),
                              label: Text('เข้าสู่ระบบ')),
                          width: double.infinity,
                        ),
                        Text(
                          'หรือเข้าสู่ระบบด้วย',
                          style: TextStyle(fontSize: 17),
                        ),

                        SizedBox(
                          child: ElevatedButton.icon(
                              onPressed: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                      return Register();
                                    }));
                              },
                              icon: Icon(Icons.add),
                              label: Text('สมัครสมาชิก')),
                          width: double.infinity,
                        )
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

