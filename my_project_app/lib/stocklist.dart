import 'package:flutter/material.dart';
import 'package:flutter_application_3/stockdetail.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'app_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Stocklist extends StatefulWidget {
  @override
  _StocklistState createState() => _StocklistState();
}

class _StocklistState extends State<Stocklist> {
  List<dynamic> productList = [];

  @override
  void initState() {
    super.initState();
    fetchProductList();
  }

  Future<void> fetchProductList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final response = await http.get(
      Uri.parse("${AppConfig.SERVICE_URL}/api/stock"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${prefs.getString("access_token")}',
      },
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      if (json['result']) {
        setState(() {
          productList = json['data'];
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFDCDF),
      appBar: AppBar(
        title: Text('สต็อกสินค้า'),
        backgroundColor: Colors.red,
      ),
      body: productList.isEmpty
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: productList.length,
              itemBuilder: (BuildContext context, int index) {
                final product = productList[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  elevation: 2,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    title: Text(
                      '${product['product_name']}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('สี: ${product['color_name']}'),
                        Text('ไซส์: ${product['size_name']}'),
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              'คงเหลือ: ${product['stock']}',
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(
                  builder: (context) => StockDetail(
                        productId: 1,
                        colorId: 1,
                        sizeId: 1,
                      )))
              .then((value) => {fetchProductList()});
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.red,
      ),
    );
  }
}
