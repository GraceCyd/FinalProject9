import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_application_3/app_config.dart';
import 'package:flutter_application_3/entity/color.dart';
import 'package:flutter_application_3/entity/size.dart';
import 'package:flutter_application_3/entity/productstock.dart';

class StockDetail extends StatefulWidget {
  const StockDetail({
    Key? key,
    required this.productId,
    required this.colorId,
    required this.sizeId,
  }) : super(key: key);

  final int productId;
  final int colorId;
  final int sizeId;

  @override
  StockDetailState createState() {
    return StockDetailState();
  }
}

class StockDetailState extends State<StockDetail> {
  List<ColorVariants> colorTypes = [];
  int? colorTypeId;
  List<SizeVariants> sizeTypes = [];
  int? sizeTypeId;
  List<ProductName> productTypes = [];
  int? productTypeId;

  final _formKey = GlobalKey<FormState>();
  final _stockController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchColor();
    fetchSize();
    fetchProduct();
  }

  void fetchColor() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final response = await http.get(
      Uri.parse("${AppConfig.SERVICE_URL}/api/color"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${prefs.getString("access_token")}',
      },
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      List<ColorVariants> store =
          List<ColorVariants>.from(json["data"].map((item) {
        return ColorVariants.fromJSON(item);
      }));

      setState(() {
        colorTypes = store;
      });
    } else {
      // Handle errors or other status codes if needed
      print("Request failed with status: ${response.statusCode}");
    }
  }

  void fetchSize() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final response = await http.get(
      Uri.parse("${AppConfig.SERVICE_URL}/api/product_size"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${prefs.getString("access_token")}',
      },
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      List<SizeVariants> store =
          List<SizeVariants>.from(json["data"].map((item) {
        return SizeVariants.fromJSON(item);
      }));

      setState(() {
        sizeTypes = store;
      });
    } else {
      // Handle errors or other status codes if needed
      print("Request failed with status: ${response.statusCode}");
    }
  }

  void fetchProduct() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final response = await http.get(
      Uri.parse("${AppConfig.SERVICE_URL}/api/products"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${prefs.getString("access_token")}',
      },
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      List<ProductName> store = List<ProductName>.from(json["data"].map((item) {
        return ProductName.fromJSON(item);
      }));

      setState(() {
        productTypes = store;
      });
    } else {
      // Handle errors or other status codes if needed
      print("Request failed with status: ${response.statusCode}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('รายละเอียดสต็อก'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            ListTile(
              title: Text('เลือกสินค้า'),
              subtitle: getProductDropdown(),
            ),
            ListTile(
              title: Text('เลือกสี'),
              subtitle: getColorDropdown(),
            ),
            ListTile(
              title: Text('เลือกไซส์'),
              subtitle: getSizeDropdown(),
            ),
            ListTile(
              title: Text('จำนวน'),
              subtitle: TextFormField(
                controller: _stockController,
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the stock';
                  }
                  return null;
                },
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (productTypeId != null &&
                    colorTypeId != null &&
                    sizeTypeId != null &&
                    _stockController.text.isNotEmpty) {
                  createVariant();
                } else {
                  // แจ้งเตือนหรือจัดการกรณีที่ค่าเป็น null ตามที่คุณต้องการ
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Missing Information'),
                        content:
                            Text('Please fill in all the required fields.'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              child: Text('เพิ่มสต็อกสินค้า'),
            ),
          ],
        ),
      ),
    );
  }

  DropdownButton<int?> getProductDropdown() {
    return DropdownButton<int?>(
      value: productTypeId,
      onChanged: (int? newValue) {
        setState(() {
          productTypeId = newValue;
        });
      },
      items: productTypes.map((product) {
        return DropdownMenuItem<int?>(
          value: product.productId, // เปลี่ยนเป็น ID ของชื่อสินค้า
          child: Text(product.productName),
        );
      }).toList(),
    );
  }

  DropdownButton<int?> getColorDropdown() {
    return DropdownButton<int?>(
      value: colorTypeId,
      onChanged: (int? newValue) {
        setState(() {
          colorTypeId = newValue;
        });
      },
      items: colorTypes.map((color) {
        return DropdownMenuItem<int?>(
          value: color.colorId,
          child: Text(color.colorName),
        );
      }).toList(),
    );
  }

  DropdownButton<int?> getSizeDropdown() {
    return DropdownButton<int?>(
      value: sizeTypeId,
      onChanged: (int? newValue) {
        setState(() {
          sizeTypeId = newValue;
        });
      },
      items: sizeTypes.map((size) {
        return DropdownMenuItem<int?>(
          value: size.sizeId,
          child: Text(size.sizeName),
        );
      }).toList(),
    );
  }

  Future<void> createVariant() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final response = await http.post(
      Uri.parse("${AppConfig.SERVICE_URL}/api/stock/add"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${prefs.getString("access_token")}',
      },
      body: jsonEncode(<String, dynamic>{
        'product_id': productTypeId, // เปลี่ยนเป็น ID ของชื่อสินค้า
        'color_id': colorTypeId, // เปลี่ยนเป็น ID ของสี
        'size_id': sizeTypeId, // เปลี่ยนเป็น ID ของไซส์
        'stock': int.parse(_stockController.text),
      }),
    );

    if (response.statusCode == 200) {
      // Handle success, e.g., show a success message
      print("Stock added successfully.");
    } else {
      // Handle errors or other status codes if needed
      print("Request failed with status: ${response.statusCode}");
    }
  }
}
