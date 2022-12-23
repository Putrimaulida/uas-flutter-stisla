import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:login_http/pages/addCategory.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void initState() {
    super.initState();
  }

  late var bod;

  Future _getCategories() async {
    final pref = await SharedPreferences.getInstance();
    final token = pref.getString('token');
    final getRequest = await http.get(
      Uri.parse('http://10.0.2.2:8000/api/category'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    bod = jsonDecode(getRequest.body);
    return jsonDecode(getRequest.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                child: Text("LIST CATEGORY", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: FutureBuilder(
                    future: _getCategories(),
                    builder: ((context, snapshot) {
                      if (snapshot.hasData) {
                        return ListView.separated(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: snapshot.data.length,
                            itemBuilder: ((context, index) {
                              return Container(
                                child: Text(snapshot.data[index]['name'], style: TextStyle(fontSize: 16),),
                              );
                            }),
                            separatorBuilder: (BuildContext context, int index) => const Divider(),
                            );
                            
                      } else {
                        return Text('Load');
                      }
                    })),
              ),
                  
              SizedBox(
                height: 50,
              ),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () async {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => AddCategory()),
                    );
                  },
                  child: Text('Add Category'),
                ),
              ),
              SizedBox(
                height: 8,
              ),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () async {
                    //request logout
                    final pref = await SharedPreferences.getInstance();
                    final token = pref.getString('token');

                    final logoutRequest = await http.post(
                      Uri.parse('http://10.0.2.2:8000/api/auth/logout'),
                      headers: {
                        'Content-Type': 'application/json',
                        'Accept': 'application/json',
                        'Authorization': 'Bearer $token',
                      },
                    );
                    if (!mounted) return;
                    if (logoutRequest.statusCode == 204) {
                      print("logout success");
                      //logout success
                      pref.remove('token');
                      //navigate to login page
                      Navigator.of(context).pushReplacementNamed('/');
                    }
                  },
                  child: Text('Logout'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
