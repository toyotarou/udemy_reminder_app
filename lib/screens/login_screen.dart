import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../general/general.dart';
import 'home_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailEditingController = TextEditingController();
  TextEditingController passwordEditingController = TextEditingController();

  bool isLoading = false;

  ///
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Remind Me',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                Container(
                  alignment: Alignment.centerRight,
                  margin: const EdgeInsets.only(top: 40, right: 20),
                  child: const Text(
                    'Sign In Here',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                const SizedBox(height: 30),
                const Text('mail'),
                CupertinoTextField(
                  controller: emailEditingController,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(225, 225, 225, 1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const SizedBox(height: 50),
                const Text('password'),
                CupertinoTextField(
                  controller: passwordEditingController,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(225, 225, 225, 1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const SizedBox(height: 50),
                isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: () async {
                          if (emailEditingController.text.trim().isNotEmpty && passwordEditingController.text.trim().isNotEmpty) {
                            setState(() {
                              isLoading = true;
                            });

                            User? currentUser;

                            await FirebaseAuth.instance
                                .signInWithEmailAndPassword(
                              email: emailEditingController.text,
                              password: passwordEditingController.text,
                            )
                                .then((value) {
                              currentUser = value.user;
                            }).catchError((error) {
                              Fluttertoast.showToast(msg: 'error while signing user in');
                            });

                            if (currentUser != null) {
                              await FirebaseFirestore.instance.collection('users').doc(currentUser!.uid).get().then((value) async {
                                if (value.exists) {
                                  await sharedPreferences!.setString('status', value.data()!['status']);

                                  if (value.data()!['status'] == 'approved') {
                                    await sharedPreferences!.setString('uid', value.data()!['uid']);
                                    await sharedPreferences!.setString('name', value.data()!['name']);
                                    await sharedPreferences!.setString('email', value.data()!['email']);

                                    setState(() {
                                      isLoading = false;
                                    });

                                    await Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomeScreen()));
                                  } else {
                                    await FirebaseAuth.instance.signOut();

                                    await Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginScreen()));

                                    await Fluttertoast.showToast(msg: 'you have been blocked');
                                  }
                                }
                              });
                            }
                          } else {
                            await Fluttertoast.showToast(msg: 'email and password are required');
                          }
                        },
                        child: const Text('Sign In'),
                      ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const RegisterScreen()));
                  },
                  child: const Text('Sign Up'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
