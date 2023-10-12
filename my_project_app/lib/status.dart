import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_3/category.dart';
import 'package:flutter_application_3/category_detail.dart';
import 'package:flutter_application_3/order_list.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'app_config.dart';
import 'package:getwidget/getwidget.dart';
import 'package:flutter_application_3/screens/product/report_order.dart';
import 'package:flutter_application_3/entity/order_list.dart';

class OrderStatusPage extends StatefulWidget {
  @override
  _OrderStatusPageState createState() => _OrderStatusPageState();
}

class _OrderStatusPageState extends State<OrderStatusPage> {
  // สร้างเมธอดหรือโค้ดในการดึงข้อมูลสถานะการสั่งซื้อหรือปรับแต่งหน้าตามความเหมาะสม
  // ตัวอย่าง:
  List<OrderListData>order_list = [];
  
 void fetchStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final response = await http.get(
      Uri.parse("${AppConfig.SERVICE_URL}/api/orderAll"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset:UTF-8',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${prefs.getString("access_token")}'
      },
    );

    final json = jsonDecode(response.body);

    print(json["data"]);

    List<OrderListData> store = List<OrderListData>.from(json["data"].map((item) {
      return  OrderListData.fromJSON(item);
    }));

    setState(() {
      print(store);
      order_list = store;
    });
  }
  @override
  void initState() {
    super.initState();
    fetchStatus();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('สถานะการสั่งซื้อ'),
      ),
      body: ListView.builder(
        itemCount: order_list.length,
        itemBuilder: (context, index) {
          final order = order_list[index];
          return ListTile(
            title: Text('รายการสั่งซื้อ #${order.orderId}'),
            subtitle: Text('สถานะ: ${order.statusName}'),
            // ตัวอย่างการเพิ่มการนำทางไปยังรายละเอียดสถานะการสั่งซื้อเมื่อคลิกที่รายการ
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => OrderDetailsPage(order: order),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

// สร้างคลาส Order เพื่อเก็บข้อมูลสถานะการสั่งซื้อ
class Order {
  final int orderId;
  final String status;

  Order({required this.orderId, required this.status});
}

// สร้างหน้ารายละเอียดสถานะการสั่งซื้อ (หรือสถานะการสั่งซื้อเพิ่มเติม)
class OrderDetailsPage extends StatelessWidget {
  final OrderListData order;

  OrderDetailsPage({required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('รายละเอียดสถานะการสั่งซื้อ #${order.orderId}'),
      ),
      body: Center(
        child: Text('สถานะ: ${order.statusName}'),
      ),
    );
  }
}
