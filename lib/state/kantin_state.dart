import 'package:flutter/material.dart';
import '../data/dummy_data.dart';
import '../models/cart_item.dart';
import '../models/menu_item.dart';
import '../models/order_model.dart';

class KantinState extends ChangeNotifier {
  // Menu data
  final List<MenuItem> _menuItems = List.from(dummyMenuItems);
  String _selectedCategory = 'Semua';
  String _searchQuery = '';
  final Set<String> _favoriteIds = {'m1', 'm8'};

  // Cart
  final List<CartItem> _cartItems = [];
  String _appliedVoucher = '';
  int _voucherDiscount = 0;

  // Active & Completed Orders
  final List<OrderModel> _orders = [
    OrderModel(
      orderId: 'ORD-20261012-001',
      queueNumber: 'A-08',
      orderTime: DateTime.now().subtract(const Duration(minutes: 25)),
      items: [
        CartItem(
          item: dummyMenuItems[0],
          quantity: 1,
          spicyLevel: 2,
          selectedToppings: ['Telur Dadar'],
        ),
        CartItem(
          item: dummyMenuItems[7],
          quantity: 1,
          spicyLevel: 0,
          selectedToppings: ['Ekstra Es'],
        ),
      ],
      totalAmount: 25000,
      orderType: 'Makan di Tempat',
      tableNumber: 'Meja 04',
      paymentMethod: 'KantinPay',
      status: OrderStatus.selesai,
    ),
  ];

  // User Profile Data (Personalized for student)
  String studentName = 'Muhammad Alif Ramsya';
  String studentNim = '065124075';
  String studentClass = 'Kelas C';
  int userBalance = 75000;
  bool isNotificationEnabled = true;
  ThemeMode themeMode = ThemeMode.light;

  // Getters
  List<MenuItem> get menuItems => _menuItems;
  String get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;
  List<CartItem> get cartItems => _cartItems;
  List<OrderModel> get orders => _orders;
  String get appliedVoucher => _appliedVoucher;
  int get voucherDiscount => _voucherDiscount;

  List<String> get categories => [
        'Semua',
        'Makanan Berat',
        'Camilan',
        'Minuman',
        'Paket Hemat',
      ];

  List<MenuItem> get filteredMenuItems {
    return _menuItems.where((item) {
      final matchesCategory = _selectedCategory == 'Semua' ||
          item.category == _selectedCategory;
      final matchesSearch = item.name
              .toLowerCase()
              .contains(_searchQuery.toLowerCase()) ||
          item.description.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();
  }

  int get cartCount =>
      _cartItems.fold(0, (total, item) => total + item.quantity);

  int get subtotal =>
      _cartItems.fold(0, (total, item) => total + item.totalPrice);

  int get taxAmount => (subtotal * 0.1).round();

  int get finalTotal {
    final amount = subtotal + taxAmount - _voucherDiscount;
    return amount < 0 ? 0 : amount;
  }

  bool isFavorite(String id) => _favoriteIds.contains(id);

  // Actions
  void setCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void toggleFavorite(String id) {
    if (_favoriteIds.contains(id)) {
      _favoriteIds.remove(id);
    } else {
      _favoriteIds.add(id);
    }
    notifyListeners();
  }

  void toggleTheme() {
    themeMode =
        themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  void toggleNotifications(bool val) {
    isNotificationEnabled = val;
    notifyListeners();
  }

  void addToCart(
    MenuItem item, {
    int quantity = 1,
    int spicyLevel = 1,
    List<String>? toppings,
    String note = '',
  }) {
    // Check if item with exact same configurations already exists
    final existingIndex = _cartItems.indexWhere(
      (element) =>
          element.item.id == item.id &&
          element.spicyLevel == spicyLevel &&
          element.note == note &&
          _areToppingsEqual(element.selectedToppings, toppings ?? []),
    );

    if (existingIndex >= 0) {
      _cartItems[existingIndex].quantity += quantity;
    } else {
      _cartItems.add(
        CartItem(
          item: item,
          quantity: quantity,
          spicyLevel: spicyLevel,
          selectedToppings: toppings != null ? List.from(toppings) : [],
          note: note,
        ),
      );
    }
    notifyListeners();
  }

  bool _areToppingsEqual(List<String> a, List<String> b) {
    if (a.length != b.length) return false;
    final setA = a.toSet();
    final setB = b.toSet();
    return setA.containsAll(setB);
  }

  void updateCartQuantity(int index, int delta) {
    if (index >= 0 && index < _cartItems.length) {
      final newQuantity = _cartItems[index].quantity + delta;
      if (newQuantity <= 0) {
        _cartItems.removeAt(index);
      } else {
        _cartItems[index].quantity = newQuantity;
      }
      notifyListeners();
    }
  }

  void removeFromCart(int index) {
    if (index >= 0 && index < _cartItems.length) {
      _cartItems.removeAt(index);
      notifyListeners();
    }
  }

  void clearCart() {
    _cartItems.clear();
    _appliedVoucher = '';
    _voucherDiscount = 0;
    notifyListeners();
  }

  bool applyVoucher(String code) {
    final clean = code.trim().toUpperCase();
    if (clean == 'MHSHEMAT' || clean == 'BUSARI5K') {
      _appliedVoucher = clean;
      _voucherDiscount = 5000;
      notifyListeners();
      return true;
    }
    return false;
  }

  void removeVoucher() {
    _appliedVoucher = '';
    _voucherDiscount = 0;
    notifyListeners();
  }

  void topUpBalance(int amount) {
    userBalance += amount;
    notifyListeners();
  }

  OrderModel placeOrder({
    required String orderType,
    required String tableNumber,
    required String paymentMethod,
  }) {
    final queueNum = 'A-${(_orders.length + 9).toString().padLeft(2, '0')}';
    final orderId = 'ORD-${DateTime.now().millisecondsSinceEpoch.toString().substring(5)}';

    final newOrder = OrderModel(
      orderId: orderId,
      queueNumber: queueNum,
      orderTime: DateTime.now(),
      items: List.from(_cartItems),
      totalAmount: finalTotal,
      orderType: orderType,
      tableNumber: tableNumber,
      paymentMethod: paymentMethod,
      status: OrderStatus.dimasak,
    );

    // If using KantinPay, deduct balance
    if (paymentMethod == 'KantinPay') {
      userBalance -= finalTotal;
      if (userBalance < 0) userBalance = 0;
    }

    _orders.insert(0, newOrder);
    clearCart();
    notifyListeners();
    return newOrder;
  }
}

// InheritedNotifier to allow any child widget to access KantinState cleanly without 3rd party packages
class KantinScope extends InheritedNotifier<KantinState> {
  const KantinScope({
    super.key,
    required KantinState state,
    required super.child,
  }) : super(notifier: state);

  static KantinState of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<KantinScope>();
    assert(scope != null, 'No KantinScope found in context');
    return scope!.notifier!;
  }
}
