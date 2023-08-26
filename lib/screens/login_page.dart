import 'package:flutter/material.dart';
import 'outward_page.dart';
import 'package:task_easy/services/user_services.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: Center(
        child: SingleChildScrollView(
          // for mobile app to show keyboard
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            const Icon(
              Icons.phone_android,
              size: 100,
            ),
            const SizedBox(height: 75),
            const Text(
              'Welcome Back',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 36,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "Log in Siwan's Task Assistant.",
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 50),
            // user name
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: TextField(
                    controller: _usernameController,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'User name',
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            // password
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Password',
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            //sign in button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              //child: GestureDetector(
              child: ElevatedButton(
                onPressed: () async {
                  final body = {
                    "username": _usernameController.text,
                    "password": _passwordController.text
                  };
                  if (await UserService.verifyUser(body, context) == true) {
                    if (mounted) {
                      await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const OutwardPage()));
                    }
                  } else {
                    if (mounted) {
                      //mount: the process of creating the state of a StatefulWidget and attaching it to a BuildContext
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title:
                                const Text("Incorrect username or password !"),
                            content: const Text(
                                "Please input correct username and password"),
                            actions: <Widget>[
                              TextButton(
                                child: const Text("OK"),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    }
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(15), //20
                  decoration: BoxDecoration(
                    color: Colors.deepPurple,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Center(
                    child: Text(
                      'Sign In',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 25),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Not a member?',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    )),
                Text(' Register now',
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    )),
              ],
            ),
          ]),
        ),
      ),
    );
  }
}
