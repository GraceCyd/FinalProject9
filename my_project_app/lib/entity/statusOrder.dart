class StatusOrder{
  final int statusId;
  final String statusName;


  const StatusOrder({
    required this.statusId,
    required this.statusName,
   
  });

  factory StatusOrder.fromJSON(Map<String, dynamic> json) {
    return StatusOrder(
      statusId: json["status_id"],
      statusName: json["status_name"],
      
    );
  }
}