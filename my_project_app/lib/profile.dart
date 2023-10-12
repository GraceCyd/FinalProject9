import 'package:flutter/material.dart';
import 'package:flutter_application_3/entity/cart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_application_3/app_config.dart';
import 'entity/user_model.dart';
import 'package:flutter_application_3/user_edit.dart';
import './screens/login/login.dart';
import 'package:flutter_application_3/status.dart';
import 'orderhistory.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  User? user;
  String accessToken = '';
  int userId = 0;
  String userName = '';
  String name = '';
  String email = '';
  int roleId = 0;
  String roleName = '';

  void initState() {
    super.initState();
    fetchUser();
  }

  Future<void> fetchUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Read values from SharedPreferences
    setState(() {
      accessToken = prefs.getString("access_token") ?? '';
      userId = prefs.getInt("user_id") ?? 0;
      userName = prefs.getString("user_name") ?? '';
      name = prefs.getString("name") ?? '';
      email = prefs.getString("email") ?? '';
      roleId = prefs.getInt("role_id") ?? 0;
      roleName = prefs.getString("role_name") ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('โปรไฟล์ของฉัน'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.blue,
              child: Icon(
                Icons.person,
                size: 70,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "${name}",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.edit,
                    size: 30,
                    color: Colors.red,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UserEdit(
                          userId: userId, // Replace with the actual userId
                          roleId: roleId, // Replace with the actual roleId
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              email,
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 24),
            Divider(
              color: Colors.grey,
              height: 1,
            ),
            ListTile(
              leading: Icon(Icons.shopping_cart, color: Colors.blue),
              title: Text('รถเข็นของฉัน'),
              trailing: Icon(Icons.arrow_forward_ios),
              // onTap: () {
              //     Navigator.push(
              //     context,
              //      builder: (context) => Payment(cartList: cartSelectedData),
              //   );
              // },
            ),
            ListTile(
              leading: Icon(Icons.car_crash, color: Colors.green),
              title: Text('ดูสถานะการสั่งซื้อ'),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => OrderStatusPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.history, color: Colors.orange),
              title: Text('ประวัติการสั่งซื้อ'),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => OrderHistoryPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.logout, color: Colors.black),
              title: Text('ออกจากระบบ'),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Login(logout: true)),
                );
              },
            ),
            ListTile(
              leading:
                  Icon(Icons.delete, color: Colors.red), // เลือกไอคอนที่เหมาะสม
              title: Text('ลบบัญชีผู้ใช้'),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('ยืนยันการลบบัญชีผู้ใช้'),
                      content: Text('คุณแน่ใจหรือไม่ว่าต้องการลบบัญชีผู้ใช้?'),
                      actions: <Widget>[
                        TextButton(
                          child: Text('ยกเลิก'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        TextButton(
                          child: Text('ยืนยัน'),
                          onPressed: () {
                            // เพิ่มโค้ดที่ต้องการให้มีการดำเนินการเมื่อยืนยันการลบบัญชีผู้ใช้
                            // คุณสามารถเพิ่มกระบวนการลบบัญชีผู้ใช้ที่นี่
                            // หลังจากเสร็จสิ้นให้ปิดกล่องโต้ตอบด้วยการเรียก Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
