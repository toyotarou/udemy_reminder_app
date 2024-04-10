import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../general/general.dart';
import 'home_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController nameEditingController = TextEditingController();
  TextEditingController emailEditingController = TextEditingController();
  TextEditingController passwordEditingController = TextEditingController();
  TextEditingController confPasswordEditingController = TextEditingController();

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
                    'Sign Up Here',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                const SizedBox(height: 30),
                const Text('Name'),
                CupertinoTextField(
                  controller: nameEditingController,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(225, 225, 225, 1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const SizedBox(height: 50),
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
                const Text('conf password'),
                CupertinoTextField(
                  controller: confPasswordEditingController,
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
                        onPressed: () {
                          if (passwordEditingController.text.trim().isNotEmpty) {
                            if (passwordEditingController.text.trim() == confPasswordEditingController.text.trim()) {
                              if (nameEditingController.text.trim().isNotEmpty && emailEditingController.text.trim().isNotEmpty) {
                                setState(() {
                                  isLoading = true;
                                });

                                signUpUser();
                              } else {
                                Fluttertoast.showToast(msg: 'all fields are required');
                              }
                            } else {
                              Fluttertoast.showToast(msg: 'the password do not match');
                            }
                          } else {
                            Fluttertoast.showToast(msg: 'the password cannot be empty');
                          }
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

  ///
  Future<void> signUpUser() async {
    User? currentUser;

    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: emailEditingController.text, password: passwordEditingController.text)
        .then((value) {
      currentUser = value.user;
    }).catchError((error) {
      Navigator.pop(context);

      Fluttertoast.showToast(msg: 'the user failed to sign up');
    });

    if (currentUser != null) {
      FirebaseFirestore.instance.collection('users').doc(currentUser!.uid).set({
        'uid': currentUser!.uid,
        'email': currentUser!.email,
        'name': nameEditingController.text,
        'status': 'approved',
        'token': '',
      });
    }

    sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences!.setString('uid', currentUser!.uid);
    await sharedPreferences!.setString('email', currentUser!.email!);
    await sharedPreferences!.setString('name', nameEditingController.text);
    await sharedPreferences!.setString('status', 'approved');

    setState(() {
      isLoading = false;

      sharedPreferences;
    });

    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomeScreen()));
  }
}
