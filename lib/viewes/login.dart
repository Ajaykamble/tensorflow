import 'package:flutter/material.dart';
import 'package:newapp/services/auth_service.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();

  String email = '';
  String password = '';
  String fullname = '';
  bool login = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(login ? 'Login' : 'Signup', style: TextStyle(color: login ? Colors.pink : Colors.blue)), // Update the title based on the login state
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Form(
            key: _formKey,
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // ======== IIT Madras Logo ========
                  Image.asset(
                    'assets/iitm_logo.jpg', // Replace with the actual image path
                    height: 100,
                    width: 100,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  // ======== Full Name ========
                  const Text(
                    "Dignose Maleria",
                    style: TextStyle(fontSize: 25, color: Colors.indigo, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text("Let's leverage AI & contribute to fulfil WHO's vision to eradicate Malaria from India & the World!!",
                      style: TextStyle(color: Colors.deepOrange, fontSize: 16, fontWeight: FontWeight.bold)),
                  SizedBox(
                    height: 20,
                  ),
                  login
                      ? Container()
                      : TextFormField(
                          key: const ValueKey('fullname'),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                            labelText: login ? "Login" : "Name",
                            hintText: 'Enter Full Name',
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please Enter Full Name';
                            } else {
                              return null;
                            }
                          },
                          onSaved: (value) {
                            setState(() {
                              fullname = value!;
                            });
                          },
                        ),
                  const SizedBox(
                    height: 20,
                  ),
                  // ======== Email ========
                  TextFormField(
                    key: const ValueKey('email'),
                    decoration: InputDecoration(
                      hintText: 'Enter Email',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                      labelText: "Email",
                    ),
                    validator: (value) {
                      if (value!.isEmpty || !value.contains('@')) {
                        return 'Please Enter valid Email';
                      } else {
                        return null;
                      }
                    },
                    onSaved: (value) {
                      setState(() {
                        email = value!;
                      });
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  // ======== Password ========
                  TextFormField(
                    key: const ValueKey('password'),
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: 'Enter Password',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                      labelText: "password",
                    ),
                    validator: (value) {
                      if (value!.length < 6) {
                        return 'Please Enter Password of min length 6';
                      } else {
                        return null;
                      }
                    },
                    onSaved: (value) {
                      setState(() {
                        password = value!;
                      });
                    },
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Container(
                    height: 55,
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(login ? Colors.pink : Colors.blue),
                      ),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          login ? AuthServices.signinUser(email, password, context) : AuthServices.signupUser(email, password, fullname, context);
                        }
                      },
                      child: Text(
                        login ? 'Login' : 'Signup',
                        style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        login = !login;
                      });
                    },
                    child: Text(login ? "Don't have an account? Signup" : "Already have an account? Login", style: TextStyle(color: login ? Colors.pink : Colors.blue)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
