import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_3/category.dart';
import 'package:flutter_application_3/category_detail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'app_config.dart';
import 'package:getwidget/getwidget.dart';
import 'package:flutter_application_3/screens/product/report_order.dart';
import 'package:flutter_application_3/entity/order_list.dart';

class OrderList extends StatefulWidget {
  const OrderList({Key? key}) : super(key: key);

  @override
  OrderListState createState() => OrderListState();
}

class OrderListState extends State<OrderList> {
  int orderValue = 0;
  List<OrderListData> orderList = [];
  int orderId = 0;

  @override
  void initState() {
    fetchOrder();
    super.initState();
  }

  void fetchOrder() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final response = await http.get(
      Uri.parse("${AppConfig.SERVICE_URL}/api/orderlist/${prefs.getInt("user_id")}"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset:UTF-8',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${prefs.getString("access_token")}'
      },
    );
    print(response.body);

    final json = jsonDecode(response.body);
    print("--------");

    print(json["data"]);

    List<OrderListData> store =
        List<OrderListData>.from(json["data"].map((item) {
      return OrderListData.fromJSON(item);
    }));

    setState(() {
      print(store);
      orderList = store;
    });
  }

  // void deleteCategory() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();

  //   final response = await http.post(
  //     Uri.parse("${AppConfig.SERVICE_URL}/api/category/delete"),
  //     headers: <String, String>{
  //       'Content-Type': 'application/json; charset=UTF-8',
  //       'Accept': 'application/json',
  //       'Authorization': 'Bearer ${prefs.getString("access_token")}'
  //     },
  //     body: jsonEncode(<String, String>{'category_id': categoryId.toString()}),
  //   );

  //   final json = jsonDecode(response.body);

  //   print(json["data"]);

  //   fetchCategory();
  // }

  Widget getCategoryListView() {
    return ListView.builder(
      padding: EdgeInsets.all(8),
      itemCount: orderList.length,
      itemBuilder: (context, index) {
        OrderListData item = orderList[index];
        return Card(
          shape: RoundedRectangleBorder(
            side: BorderSide(width: 2, color: Colors.amberAccent),
            borderRadius: BorderRadius.circular(10),
          ),
          child: GFListTile(
            title: Text(
              item.productName,
              style: TextStyle(
                fontSize: 17,
              ),
            ),
            subTitleText: ("${item.productName}"),
            icon: Icon(Icons.edit),
            // onTap: () {
            //   Navigator.of(context)
            //       .push(MaterialPageRoute(
            //           builder: (context) =>
            //               CategoryDetail(categoryId: item.orderId)))
            //       .then((value) => {fetchOrderDetail()});
            // },
            onLongPress: () {
              setState(() {
                orderId = item.orderId;
              });

              showModalBottomSheet<void>(
                isScrollControlled: true,
                shape: const RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(15.0)),
                ),
                context: context,
                builder: (BuildContext context) {
                  return getConfirmPanel(context);
                },
              );
            },
          ),
        );
      },
    );
  }

  Widget getScreen() {
    return SafeArea(child: getCategoryListView());
  }

  Widget getConfirmPanel(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          children: [
            SizedBox(height: 15),
            const Text(
              "คุณแน่ใจหรือไม่ว่าต้องการลบข้อมูลนี้",
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            SizedBox(height: 15),
            ElevatedButton(
              onPressed: () {
                //   deleteOrder();
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.green,
                fixedSize: Size(150, 50),
              ),
              child: const Text(
                "ตกลง",
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
            SizedBox(height: 15), // เพิ่มระยะห่างระหว่างปุ่ม
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.red,
                fixedSize: Size(150, 50),
              ),
              child: const Text(
                "ยกเลิก",
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("รายการคำสั่งซื้อ"),
        backgroundColor: Colors.red,
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) =>
                    ReportPage(), // ใช้งาน ReportPage ที่นำเข้ามา
              ));
            },
            child: Text(
              "รายงาน",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
      body: Container(
        color:
            const Color(0xFFFFDCDF), // Set your desired background color here
        child: getScreen(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(
                  builder: (context) => const CategoryDetail(categoryId: 0)))
              .then((value) => {fetchOrder()});
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.red,
      ),
    );
  }
}
