import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:login_http/pages/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddCategory extends StatefulWidget {
  const AddCategory({super.key});

  @override
  State<AddCategory> createState() => _AddCategory();
}

class _AddCategory extends State<AddCategory> {
  final TextEditingController _nameController =
      TextEditingController(text: " ");
  //password controlle
  _showMsg(msg) {
    final snackBarr = SnackBar(
      content: Text(msg),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBarr);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Category'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                alignment: Alignment.centerLeft,
                child: IconButton(
                    onPressed: () {
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => HomePage()));
                    },
                    icon: Icon(Icons.arrow_back)),
              ),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
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
                    final pref = await SharedPreferences.getInstance();
                    final token = pref.getString('token');

                    final addRequest = await http.post(
                      Uri.parse('http://10.0.2.2:8000/api/category'),
                      body: {
                        'name': _nameController.text,
                      },
                      headers: {
                        'Accept': 'application/json',
                        'Authorization': 'Bearer $token',
                      },
                    );
                    print(addRequest.statusCode);
                    if (addRequest.statusCode == 201) {
                      _showMsg("Berhasil Menambahkan");
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => HomePage()));
                    } else {
                      _showMsg("Gagal Menambahkan");
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AddCategory()));
                    }
                  },
                  child: Text('Tambahkan'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
