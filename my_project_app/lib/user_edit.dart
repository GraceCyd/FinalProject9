import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_application_3/app_config.dart';
import 'package:flutter_application_3/entity/user_model.dart';
import 'package:crypto/crypto.dart';

class UserEdit extends StatefulWidget {
  const UserEdit({Key? key, required this.userId, required int roleId})
      : super(key: key);

  final int userId;

  @override
  UserEditState createState() => UserEditState();
}

class UserEditState extends State<UserEdit> {
  // Fields
  List<User> roles = [];
  int? roleId = 3;
  User? user;
  String accessToken = '';
  int userId = 0;
  String userName = '';
  String name = '';
  String email = '';
  String tel = '';
  String address = '';
  String password = '';

  //int roleId = 0;
  String roleName = '';

  void initState() {
    super.initState();
    fetchUser();
  }

  Future<void> fetchUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final response = await http.get(
      Uri.parse(
          "${AppConfig.SERVICE_URL}/api/users/${prefs.getInt("user_id")}"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${prefs.getString("access_token")}',
      },
    );
    final json = jsonDecode(response.body);
    print(json);

    // Read values from SharedPreferences
    setState(() {
      userId = json["data"][0]["user_id"] ?? 0;
      userName = json["data"][0]["user_name"] ?? '';
      name = json["data"][0]["name"] ?? '';
      email = json["data"][0]["email"] ?? '';
      tel = json["data"][0]["tel"] ?? '';
      address = json["data"][0]["address"] ?? '';
      roleId = json["data"][0]["role_id"] ?? 0;
      roleName = json["data"][0]["role_name"] ?? '';
      password = json["data"][0]["password"] ?? '';
    });
  }

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  final _telController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  String generateMd5(String input) {
    return md5.convert(utf8.encode(input)).toString();
  }

  // API Requests
  Future<void> fetchRole() async {
    final prefs = await SharedPreferences.getInstance();

    final response = await http.get(
      Uri.parse("${AppConfig.SERVICE_URL}/api/roles"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${prefs.getString("access_token")}',
      },
    );

    final json = jsonDecode(response.body);

    print(">>$json");
    //print(jsonDecode(response.body));
    //print(response.body);
    //final result = json.decode(response.body);

    List<User> store = List<User>.from(json["data"].map((item) {
      return User.fromJSON(item);
    }));

    setState(() {
      roles = store;
    });
  }

  Future<bool> updateUser() async {
    final prefs = await SharedPreferences.getInstance();

    final response = await http.post(
      Uri.parse("${AppConfig.SERVICE_URL}/api/users/update"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${prefs.getString("access_token")}',
      },
      body: jsonEncode(<String, String>{
        'user_id': userId.toString(),
        'name': _nameController.text,
        'role_id': roleId.toString(),
        'email': _emailController.text,
        'tel': _telController.text,
        'address': _addressController.text,
        'user_name': _usernameController.text,
        'password': _passwordController.text.isEmpty
            ? password
            : generateMd5(_passwordController.text)
      }),
    );
    print(_nameController.text);

    final json = jsonDecode(response.body);

    if (json["result"]) {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      await prefs.setString("user_name", _usernameController.text);
      await prefs.setString("name", _nameController.text);
      await prefs.setString("email", _emailController.text);

      return true;
    } else {
      return false;
    }
  }

  // Widgets
  Widget getRoleDropdown() {
    return DropdownButton<int>(
      value: roleId,
      items: roles.map((roles) {
        return DropdownMenuItem<int>(
          value: roles.roleId,
          child: Text(roles.roleName),
        );
      }).toList(),
      onChanged: (int? newValue) {
        setState(() {
          roleId = newValue!;
        });
      },
    );
  }

  Widget buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData prefixIcon,
    bool isPassword = false,
    TextInputType? keyboardType,
    TextInputFormatter? inputFormatter,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      cursorColor: Colors.black,
      style: TextStyle(color: Colors.black.withOpacity(0.9)),
      keyboardType: keyboardType,
      inputFormatters: inputFormatter != null ? [inputFormatter] : null,
      obscureText: isPassword,
      decoration: InputDecoration(
        prefixIcon: Icon(
          prefixIcon,
          color: const Color.fromARGB(179, 8, 8, 8),
        ),
        labelText: label,
        labelStyle: TextStyle(
          color: const Color.fromARGB(255, 8, 8, 8).withOpacity(0.9),
        ),
        filled: true,
        floatingLabelBehavior: FloatingLabelBehavior.never,
        fillColor: Colors.white.withOpacity(0.8),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: const BorderSide(
            width: 1, // Add a subtle border
            color: Colors.black, // Customize the border color
            style: BorderStyle.solid,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: const BorderSide(
            width: 2, // Make the border slightly thicker when focused
            color: Colors.blue, // Customize the focused border color
            style: BorderStyle.solid,
          ),
        ),
      ),
      validator: validator,
    );
  }

  Widget getForm() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            const SizedBox(height: 20),
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.blue,
              child: Icon(
                Icons.person,
                size: 70,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            buildTextField(
              controller: _nameController..text = name,
              label: "ชื่อ-นามสกุล",
              prefixIcon: Icons.person,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "กรุณากรอกชื่อ-นามสกุล";
                }
                return null;
              },
            ),
            const SizedBox(height: 10),
            buildTextField(
              controller: _emailController..text = email,
              label: "อีเมล",
              prefixIcon: Icons.email,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "กรุณากรอกอีเมล";
                }
                return null;
              },
            ),
            const SizedBox(height: 10),
            buildTextField(
              controller: _telController..text = tel,
              label: "เบอร์โทรศัพท์",
              prefixIcon: Icons.phone,
              keyboardType: TextInputType.number,
              inputFormatter: FilteringTextInputFormatter.digitsOnly,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "กรุณากรอกเบอร์โทรศัพท์";
                }
                return null;
              },
            ),
            const SizedBox(height: 10),
            buildTextField(
              controller: _addressController..text = address,
              label: "ที่อยู่",
              prefixIcon: Icons.home,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "กรุณากรอกที่อยู่";
                }
                return null;
              },
            ),
            const SizedBox(height: 10),
            buildTextField(
              controller: _usernameController..text = userName,
              label: "ชื่อผู้ใช้งาน",
              prefixIcon: Icons.person_2_outlined,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "กรุณากรอกชื่อผู้ใช้งาน";
                }
                return null;
              },
            ),
            const SizedBox(height: 10),
            buildTextField(
              controller: _passwordController,
              label: "รหัสผ่าน",
              prefixIcon: Icons.lock,
              isPassword: true,
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      bool result = await updateUser();

                      if (!result) {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return const AlertDialog(
                              content: Text("ไม่สามารถแก้ไขได้"),
                            );
                          },
                        );
                      } else {
                        Navigator.pop(context);
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green, // Set button color to green
                    onPrimary: Colors.white, // Set text color to white
                    padding: EdgeInsets.symmetric(
                        horizontal: 30, vertical: 15), // Increase button size
                    elevation: 2, // Add a subtle shadow
                  ),
                  child: const Text(
                    "บันทึก",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold, // Make the text bold
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.red, // Set button color to red
                    onPrimary: Colors.white, // Set text color to white
                    padding: EdgeInsets.symmetric(
                        horizontal: 30, vertical: 15), // Increase button size
                    elevation: 2, // Add a subtle shadow
                  ),
                  child: const Text(
                    "ยกเลิก",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold, // Make the text bold
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFDCDF),
      appBar: AppBar(
        title: Text("แก้ไขข้อมูล"),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Add widgets here
              getForm(),
            ],
          ),
        ),
      ),
    );
  }
}
