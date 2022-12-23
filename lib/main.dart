import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:login_http/models/loginError.dart';
import 'package:login_http/models/token.dart';
import 'package:login_http/pages/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const MyHomePage(title: 'Flutter Demo'),
        '/home': (context) => const HomePage(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool isLoggedIn = false;
  bool isLoginInProgress = false;

  //email controller
  final TextEditingController _emailController =
      TextEditingController(text: "superadmin@gmail.com");
  //password controller
  final TextEditingController _passwordController =
      TextEditingController(text: "password");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(15.0),
              child: Text(
                "LOGIN FORM",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                ),
              ),
            ),
            // Container(
            //   padding: EdgeInsets.all(10.0),
            //   child: TextField(
            //     decoration: InputDecoration(
            //       border: OutlineInputBorder(),
            //       labelText: 'Email',
            //       hintText: 'Enter valid email id as abc@gmail.com',
            //       suffixIcon: Icon(
            //         Icons.person,
            //         color: Colors.blue,
            //       ),
            //     ),
            //   ),
            // ),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            // Container(
            //   padding: EdgeInsets.all(10.0),
            //   child: TextField(
            //     // obscureText: true,
            //     decoration: InputDecoration(
            //       border: OutlineInputBorder(),
            //       labelText: 'Password',
            //       hintText: 'Enter secure password',
            //       suffixIcon: Icon(
            //         Icons.lock,
            //         color: Colors.blue,
            //       ),
            //     ),
            //   ),
            // ),
            
            TextFormField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Password',
              ),
              obscureText: true,
            ),
            const SizedBox(
              height: 8,
            ),
            SizedBox(
              height: 50,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  setState(() {
                    isLoginInProgress = true;
                  });
                  //request login
                  Map<String, String> headers = {"Accept": "application/json"};
                  final response = await http.post(
                    Uri.parse('http://10.0.2.2:8000/api/auth/login'),
                    headers: headers,
                    body: {
                      'email': _emailController.text,
                      'password': _passwordController.text,
                      'device_name': 'android',
                    },
                  );
                  if (response.statusCode == 200) {
                    final jsonResponse = json.decode(response.body);
                    final token = Token.fromJson(jsonResponse);
                    final prefs = await SharedPreferences.getInstance();
                    print("Token From Api ${token.token}");
                    if (token.token != null) {
                      await prefs.setString('token', token.token!);
                      setState(() {
                        isLoginInProgress = false;
                        isLoggedIn = true;
                      });

                      if (!mounted) {
                        return;
                      }

                      if (isLoggedIn) {
                        Navigator.pushReplacementNamed(context, '/home');
                      }
                    }
                  } else {
                    final jsonResponse = json.decode(response.body);
                    final loginError = LoginError.fromJson(jsonResponse);
                    // print(loginError.message);
                    // print(loginError.errors?.email?.elementAt(0));
                    setState(() {
                      isLoginInProgress = false;
                      isLoggedIn = false;
                    });
                  }
                },
                child: const Text("Login"),
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            SizedBox(
              height: 50,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  final prefs = await SharedPreferences.getInstance();
                  final token = prefs.getString('token');
                  print("Token From Shared Pref $token");
                },
                child: const Text("Get Token"),
              ),
            ),
            Visibility(
              visible: isLoginInProgress,
              child: const CircularProgressIndicator(),
            ),
          ],
        ),
      ),
    );
  }
}
