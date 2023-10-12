import 'package:flutter/material.dart';

class OrderHistoryPage extends StatefulWidget {
  @override
  _OrderHistoryPageState createState() => _OrderHistoryPageState();
}

class _OrderHistoryPageState extends State<OrderHistoryPage> {
  // สร้างเมธอดหรือโค้ดในการดึงข้อมูลประวัติการสั่งซื้อหรือปรับแต่งหน้าตามความเหมาะสม
  // ตัวอย่าง:
  List<Order> orderHistory = [
    Order(orderId: 1, date: '2023-10-01', totalAmount: 150.00),
    Order(orderId: 2, date: '2023-09-15', totalAmount: 200.00),
    // เพิ่มรายการประวัติการสั่งซื้ออื่น ๆ ตามความเหมาะสม
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ประวัติการสั่งซื้อ'),
      ),
      body: ListView.builder(
        itemCount: orderHistory.length,
        itemBuilder: (context, index) {
          final order = orderHistory[index];
          return ListTile(
            title: Text('รายการสั่งซื้อ #${order.orderId}'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('วันที่: ${order.date}'),
                Text('ราคารวม: ฿${order.totalAmount.toStringAsFixed(2)}'),
              ],
            ),
            // ตัวอย่างการเพิ่มการนำทางไปยังรายละเอียดประวัติการสั่งซื้อเมื่อคลิกที่รายการ
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => OrderHistoryDetailsPage(order: order),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

// สร้างคลาส Order เพื่อเก็บข้อมูลประวัติการสั่งซื้อ
class Order {
  final int orderId;
  final String date;
  final double totalAmount;

  Order({required this.orderId, required this.date, required this.totalAmount});
}

// สร้างหน้ารายละเอียดประวัติการสั่งซื้อ (หรือประวัติการสั่งซื้อเพิ่มเติม)
class OrderHistoryDetailsPage extends StatelessWidget {
  final Order order;

  OrderHistoryDetailsPage({required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('รายละเอียดประวัติการสั่งซื้อ #${order.orderId}'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('วันที่: ${order.date}'),
            Text('ราคารวม: ฿${order.totalAmount.toStringAsFixed(2)}'),
            // ปรับแต่งเพิ่มเติมเพื่อแสดงข้อมูลเพิ่มเติมของรายการสั่งซื้อ
          ],
        ),
      ),
    );
  }
}
