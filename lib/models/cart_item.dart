import 'menu_item.dart';

class CartItem {
  final MenuItem item;
  int quantity;
  int spicyLevel; // 0 to 5
  List<String> selectedToppings;
  String note;

  CartItem({
    required this.item,
    this.quantity = 1,
    this.spicyLevel = 1,
    List<String>? selectedToppings,
    this.note = '',
  }) : selectedToppings = selectedToppings ?? [];

  int get toppingTotal => selectedToppings.length * 2000;

  int get unitPrice => item.price + toppingTotal;

  int get totalPrice => unitPrice * quantity;
}
