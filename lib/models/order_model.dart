import 'cart_item.dart';

enum OrderStatus {
  diterima,   // Order received
  dimasak,    // Cooking / preparing
  siapDiambil,// Ready for pickup / served
  selesai,    // Completed
}

class OrderModel {
  final String orderId;
  final String queueNumber;
  final DateTime orderTime;
  final List<CartItem> items;
  final int totalAmount;
  final String orderType; // 'Makan di Tempat' or 'Bungkus (Take Away)'
  final String tableNumber;
  final String paymentMethod; // 'QRIS', 'Tunai di Kasir', 'KantinPay'
  OrderStatus status;

  OrderModel({
    required this.orderId,
    required this.queueNumber,
    required this.orderTime,
    required this.items,
    required this.totalAmount,
    required this.orderType,
    required this.tableNumber,
    required this.paymentMethod,
    this.status = OrderStatus.dimasak,
  });

  String get statusText {
    switch (status) {
      case OrderStatus.diterima:
        return 'Pesanan Diterima';
      case OrderStatus.dimasak:
        return 'Sedang Dimasak';
      case OrderStatus.siapDiambil:
        return 'Siap Diambil';
      case OrderStatus.selesai:
        return 'Selesai';
    }
  }
}
