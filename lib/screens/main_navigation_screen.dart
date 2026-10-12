import 'package:flutter/material.dart';
import '../models/order_model.dart';
import '../state/kantin_state.dart';
import 'cart_screen.dart';
import 'home_screen.dart';
import 'order_history_screen.dart';
import 'profile_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  void _navigateToTab(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = KantinScope.of(context);
    final activeOrdersCount = state.orders
        .where((o) => o.status != OrderStatus.selesai)
        .length;

    final screens = [
      HomeScreen(onNavigateTab: _navigateToTab),
      CartScreen(onNavigateTab: _navigateToTab),
      OrderHistoryScreen(onNavigateTab: _navigateToTab),
      const ProfileScreen(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: _navigateToTab,
        destinations: [
          const NavigationDestination(
            icon: Icon(Icons.storefront_outlined),
            selectedIcon: Icon(Icons.storefront),
            label: 'Menu',
          ),
          NavigationDestination(
            icon: Badge(
              isLabelVisible: state.cartCount > 0,
              label: Text('${state.cartCount}'),
              child: const Icon(Icons.shopping_bag_outlined),
            ),
            selectedIcon: Badge(
              isLabelVisible: state.cartCount > 0,
              label: Text('${state.cartCount}'),
              child: const Icon(Icons.shopping_bag),
            ),
            label: 'Keranjang',
          ),
          NavigationDestination(
            icon: Badge(
              isLabelVisible: activeOrdersCount > 0,
              label: Text('$activeOrdersCount'),
              backgroundColor: Colors.deepOrange,
              child: const Icon(Icons.receipt_long_outlined),
            ),
            selectedIcon: Badge(
              isLabelVisible: activeOrdersCount > 0,
              label: Text('$activeOrdersCount'),
              backgroundColor: Colors.deepOrange,
              child: const Icon(Icons.receipt_long),
            ),
            label: 'Pesanan',
          ),
          const NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}
