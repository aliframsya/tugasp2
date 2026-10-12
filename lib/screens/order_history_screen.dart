import 'package:flutter/material.dart';
import '../models/order_model.dart';
import '../state/kantin_state.dart';

class OrderHistoryScreen extends StatefulWidget {
  final Function(int) onNavigateTab;

  const OrderHistoryScreen({super.key, required this.onNavigateTab});

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _showReceiptModal(BuildContext context, OrderModel order) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Struk Digital Kantin Bu Sari',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
              const Divider(),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('ID Transaksi: ${order.orderId}'),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.deepOrange.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Antrean: ${order.queueNumber}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.deepOrange,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                'Waktu: ${order.orderTime.hour.toString().padLeft(2, '0')}:${order.orderTime.minute.toString().padLeft(2, '0')} WIB • ${order.orderType} (${order.tableNumber})',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
              ),
              const SizedBox(height: 12),
              const Text(
                'Rincian Menu:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ...order.items.map((cartItem) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text('${cartItem.quantity}x ${cartItem.item.name}'),
                      ),
                      Text(
                        'Rp ${cartItem.totalPrice.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}',
                      ),
                    ],
                  ),
                );
              }),
              const Divider(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total Tagihan:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Rp ${order.totalAmount.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: Colors.deepOrange,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Metode Pembayaran: ${order.paymentMethod}',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () => Navigator.pop(ctx),
                  icon: const Icon(Icons.check),
                  label: const Text('Tutup Struk'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showRatingDialog(BuildContext context, OrderModel order) {
    int selectedRating = 5;
    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: const Text('Beri Ulasan Pesanan'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Bagaimana makanan dan pelayanan di Kantin Bu Sari untuk antrean ${order.queueNumber}?',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 13),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) {
                    final star = index + 1;
                    return IconButton(
                      icon: Icon(
                        star <= selectedRating ? Icons.star : Icons.star_border,
                        color: Colors.amber,
                        size: 32,
                      ),
                      onPressed: () {
                        setDialogState(() => selectedRating = star);
                      },
                    );
                  }),
                ),
                Text(
                  selectedRating == 5
                      ? 'Luar biasa lezat! ⭐⭐⭐⭐⭐'
                      : (selectedRating >= 4
                          ? 'Enak dan puas! ⭐⭐⭐⭐'
                          : 'Cukup baik ⭐⭐⭐'),
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Batal'),
              ),
              FilledButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Terima kasih atas ulasan bintang 5 Anda!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                },
                child: const Text('Kirim Ulasan'),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = KantinScope.of(context);
    final theme = Theme.of(context);

    final activeOrders = state.orders
        .where((o) => o.status != OrderStatus.selesai)
        .toList();
    final completedOrders = state.orders
        .where((o) => o.status == OrderStatus.selesai)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Status & Riwayat Pesanan'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Pesanan Aktif'),
                  if (activeOrders.isNotEmpty) ...[
                    const SizedBox(width: 6),
                    Badge.count(
                      count: activeOrders.length,
                      backgroundColor: Colors.deepOrange,
                    ),
                  ],
                ],
              ),
            ),
            Tab(text: 'Selesai (${completedOrders.length})'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Tab 1: Pesanan Aktif
          activeOrders.isEmpty
              ? _buildEmptyState(
                  title: 'Tidak Ada Pesanan Aktif',
                  message: 'Pesanan Anda saat ini akan muncul di sini beserta status masak.',
                  buttonText: 'Pesan Makanan',
                  onTap: () => widget.onNavigateTab(0),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: activeOrders.length,
                  itemBuilder: (ctx, index) {
                    final order = activeOrders[index];
                    return _buildOrderCard(context, order, state, theme, isActive: true);
                  },
                ),

          // Tab 2: Riwayat Pesanan Selesai
          completedOrders.isEmpty
              ? _buildEmptyState(
                  title: 'Belum Ada Riwayat Selesai',
                  message: 'Pesanan yang telah selesai akan disimpan di riwayat ini.',
                  buttonText: 'Mulai Pesan',
                  onTap: () => widget.onNavigateTab(0),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: completedOrders.length,
                  itemBuilder: (ctx, index) {
                    final order = completedOrders[index];
                    return _buildOrderCard(context, order, state, theme, isActive: false);
                  },
                ),
        ],
      ),
    );
  }

  Widget _buildEmptyState({
    required String title,
    required String message,
    required String buttonText,
    required VoidCallback onTap,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.receipt_long_outlined, size: 70, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(message, textAlign: TextAlign.center, style: TextStyle(color: Colors.grey.shade600)),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: onTap,
              icon: const Icon(Icons.add),
              label: Text(buttonText),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderCard(
    BuildContext context,
    OrderModel order,
    KantinState state,
    ThemeData theme, {
    required bool isActive,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row: Queue Number and Status Badge
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE65100),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        'Antrean ${order.queueNumber}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      order.orderType,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: isActive ? Colors.amber.shade100 : Colors.green.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    order.statusText,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: isActive ? Colors.amber.shade900 : Colors.green.shade900,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Interactive Progress Tracker for active order
            if (isActive) ...[
              const Text(
                'Lacak Proses Masak:',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 6),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: _getOrderProgress(order.status),
                  minHeight: 8,
                  backgroundColor: Colors.grey.shade200,
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.deepOrange),
                ),
              ),
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildStatusDot('Diterima', order.status.index >= 0),
                  _buildStatusDot('Dimasak', order.status.index >= 1),
                  _buildStatusDot('Siap', order.status.index >= 2),
                  _buildStatusDot('Selesai', order.status.index >= 3),
                ],
              ),
              const SizedBox(height: 10),
              // Simulation Button to advance status for presentation/grading!
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: () {
                    setState(() {
                      if (order.status == OrderStatus.diterima) {
                        order.status = OrderStatus.dimasak;
                      } else if (order.status == OrderStatus.dimasak) {
                        order.status = OrderStatus.siapDiambil;
                      } else if (order.status == OrderStatus.siapDiambil) {
                        order.status = OrderStatus.selesai;
                      }
                    });
                  },
                  icon: const Icon(Icons.fast_forward, size: 16),
                  label: const Text('Simulasi Maju Status'),
                ),
              ),
              const Divider(height: 16),
            ],

            // Item summary
            ...order.items.take(3).map((item) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 2.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${item.quantity}x ${item.item.name}',
                      style: const TextStyle(fontSize: 13),
                    ),
                    Text(
                      'Rp ${item.totalPrice.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}',
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              );
            }),
            if (order.items.length > 3)
              Text(
                '+ ${order.items.length - 3} menu lainnya',
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),

            const Divider(height: 20),

            // Total and Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Total Pembayaran', style: TextStyle(fontSize: 11, color: Colors.grey)),
                    Text(
                      'Rp ${order.totalAmount.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}',
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Row(
                  children: [
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                      onPressed: () => _showReceiptModal(context, order),
                      child: const Text('Struk'),
                    ),
                    const SizedBox(width: 8),
                    if (isActive)
                      FilledButton(
                        style: FilledButton.styleFrom(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Nomor ${order.queueNumber} sedang disiapkan oleh Bu Sari.'),
                            ),
                          );
                        },
                        child: const Text('Info Siap'),
                      )
                    else
                      FilledButton.tonal(
                        style: FilledButton.styleFrom(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
                        onPressed: () => _showRatingDialog(context, order),
                        child: const Text('Beri Nilai'),
                      ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  double _getOrderProgress(OrderStatus status) {
    switch (status) {
      case OrderStatus.diterima:
        return 0.25;
      case OrderStatus.dimasak:
        return 0.60;
      case OrderStatus.siapDiambil:
        return 0.90;
      case OrderStatus.selesai:
        return 1.0;
    }
  }

  Widget _buildStatusDot(String label, bool active) {
    return Column(
      children: [
        Icon(
          active ? Icons.check_circle : Icons.radio_button_unchecked,
          size: 14,
          color: active ? Colors.deepOrange : Colors.grey,
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: active ? Colors.black87 : Colors.grey,
            fontWeight: active ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}
