import 'package:flutter/material.dart';
import '../models/order_model.dart';
import '../state/kantin_state.dart';
import '../widgets/app_image.dart';

class CartScreen extends StatefulWidget {
  final Function(int) onNavigateTab;

  const CartScreen({super.key, required this.onNavigateTab});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  String _orderType = 'Makan di Tempat';
  String _selectedTable = 'Meja 01';
  String _paymentMethod = 'KantinPay';
  final TextEditingController _voucherController = TextEditingController();

  final List<String> _tableOptions = [
    'Meja 01',
    'Meja 02',
    'Meja 03',
    'Meja 04',
    'Meja 05',
    'Meja 06',
    'Area Bar Kantin',
  ];

  // Status ketersediaan meja (true = penuh, false = tersedia)
  final Map<String, bool> _tableOccupied = {
    'Meja 01': false,
    'Meja 02': true, // Contoh: Meja 02 terisi penuh
    'Meja 03': false,
    'Meja 04': false,
    'Meja 05': true, // Contoh: Meja 05 terisi penuh
    'Meja 06': false,
    'Area Bar Kantin': false,
  };

  bool get _allTablesFull =>
      _tableOptions.every((table) => _tableOccupied[table] == true);

  String get _safeSelectedTable {
    if (_tableOptions.contains(_selectedTable) &&
        _tableOccupied[_selectedTable] != true) {
      return _selectedTable;
    }
    for (final table in _tableOptions) {
      if (_tableOccupied[table] != true) return table;
    }
    return 'Meja Penuh';
  }

  @override
  void dispose() {
    _voucherController.dispose();
    super.dispose();
  }

  void _showOrderSuccessDialog(BuildContext context, OrderModel order) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle_rounded,
                  color: Colors.green,
                  size: 64,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Pesanan Berhasil Dibuat!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Nomor Antrean Anda:',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.deepOrange.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.deepOrange.shade200),
                ),
                child: Text(
                  order.queueNumber,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    color: Colors.deepOrange,
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Text(
                'ID: ${order.orderId}\n${order.orderType} • ${order.tableNumber}\nMetode: ${order.paymentMethod}',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12, height: 1.4),
              ),
              const SizedBox(height: 10),
              Text(
                'Total: Rp ${order.totalAmount.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepOrange,
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    widget.onNavigateTab(2); // Go to Orders tab
                  },
                  child: const Text('Lacak Status Pesanan'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = KantinScope.of(context);
    final theme = Theme.of(context);

    if (state.cartItems.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Keranjang Belanja'),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.shopping_cart_outlined,
                  size: 80,
                  color: Colors.grey.shade400,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Keranjang Belanja Masih Kosong',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'Pilih aneka makanan dan minuman lezat dari Kantin Bu Sari!',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey.shade600),
                ),
                const SizedBox(height: 24),
                FilledButton.icon(
                  onPressed: () => widget.onNavigateTab(0),
                  icon: const Icon(Icons.restaurant_menu),
                  label: const Text('Mulai Pesan Sekarang'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Keranjang (${state.cartCount} item)'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            tooltip: 'Kosongkan Keranjang',
            onPressed: () {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Kosongkan Keranjang?'),
                  content: const Text('Semua pesanan di keranjang akan dihapus.'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx),
                      child: const Text('Batal'),
                    ),
                    FilledButton(
                      onPressed: () {
                        state.clearCart();
                        Navigator.pop(ctx);
                      },
                      child: const Text('Hapus'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Widget 1: Order Items List (Card with Quantity Counter)
          const Text(
            'Daftar Pesanan',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          ...List.generate(state.cartItems.length, (index) {
            final cartItem = state.cartItems[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Item thumbnail
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: AppImage(
                        imageUrl: cartItem.item.imageUrl,
                        width: 70,
                        height: 70,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Item Details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            cartItem.item.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 4),
                          if (cartItem.spicyLevel > 0)
                            Text(
                              'Pedas Level ${cartItem.spicyLevel}',
                              style: const TextStyle(
                                fontSize: 11,
                                color: Colors.deepOrange,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          if (cartItem.selectedToppings.isNotEmpty)
                            Text(
                              'Topping: ${cartItem.selectedToppings.join(', ')}',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          if (cartItem.note.isNotEmpty)
                            Text(
                              'Catatan: "${cartItem.note}"',
                              style: TextStyle(
                                fontSize: 11,
                                fontStyle: FontStyle.italic,
                                color: Colors.grey.shade700,
                              ),
                            ),
                          const SizedBox(height: 8),
                          Text(
                            'Rp ${cartItem.unitPrice.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Quantity Counter Control
                    Column(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.close, size: 18),
                          onPressed: () => state.removeFromCart(index),
                          visualDensity: VisualDensity.compact,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              InkWell(
                                onTap: () => state.updateCartQuantity(index, -1),
                                child: const Padding(
                                  padding: EdgeInsets.all(4.0),
                                  child: Icon(Icons.remove, size: 16),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text(
                                  '${cartItem.quantity}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () => state.updateCartQuantity(index, 1),
                                child: const Padding(
                                  padding: EdgeInsets.all(4.0),
                                  child: Icon(Icons.add, size: 16),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }),

          const SizedBox(height: 12),

          // Widget 2: SegmentedButton for Order Type
          const Text(
            'Tipe Pesanan',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          SegmentedButton<String>(
            segments: const [
              ButtonSegment<String>(
                value: 'Makan di Tempat',
                label: Text('Makan di Tempat'),
                icon: Icon(Icons.table_restaurant),
              ),
              ButtonSegment<String>(
                value: 'Bungkus (Take Away)',
                label: Text('Bungkus'),
                icon: Icon(Icons.takeout_dining),
              ),
            ],
            selected: {_orderType},
            onSelectionChanged: (Set<String> newSelection) {
              setState(() {
                _orderType = newSelection.first;
              });
            },
          ),

          const SizedBox(height: 16),

          // Widget 3: Table Chips Selection with (Penuh) status & alert
          if (_orderType == 'Makan di Tempat') ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Icon(Icons.chair_alt, size: 20, color: Color(0xFFE65100)),
                    SizedBox(width: 6),
                    Text(
                      'Pilih Meja Pemesanan:',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                // Tombol simulasi status penuh untuk pengujian praktikum
                TextButton.icon(
                  style: TextButton.styleFrom(
                    visualDensity: VisualDensity.compact,
                    padding: EdgeInsets.zero,
                  ),
                  onPressed: () {
                    setState(() {
                      final makeAllFull = !_allTablesFull;
                      for (final t in _tableOptions) {
                        _tableOccupied[t] = makeAllFull;
                      }
                      if (!makeAllFull) {
                        _tableOccupied['Meja 02'] = true;
                        _tableOccupied['Meja 05'] = true;
                        _selectedTable = 'Meja 01';
                      }
                    });
                  },
                  icon: Icon(
                    _allTablesFull ? Icons.refresh : Icons.tune,
                    size: 14,
                  ),
                  label: Text(
                    _allTablesFull ? 'Reset Meja' : 'Tes Meja Penuh',
                    style: const TextStyle(fontSize: 11),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Horizontal Table Chips
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _tableOptions.map((table) {
                  final isOccupied = _tableOccupied[table] == true;
                  final isSelected = _selectedTable == table && !isOccupied;

                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ChoiceChip(
                      avatar: Icon(
                        isOccupied
                            ? Icons.block
                            : (isSelected ? Icons.check : Icons.chair_alt),
                        size: 16,
                        color: isOccupied
                            ? Colors.red.shade400
                            : (isSelected ? Colors.white : const Color(0xFFE65100)),
                      ),
                      label: Text(
                        isOccupied ? '$table (Penuh)' : table,
                        style: TextStyle(
                          color: isOccupied
                              ? Colors.red.shade700
                              : (isSelected ? Colors.white : Colors.black87),
                          fontWeight: isSelected || isOccupied
                              ? FontWeight.bold
                              : FontWeight.normal,
                          decoration:
                              isOccupied ? TextDecoration.lineThrough : null,
                        ),
                      ),
                      selected: isSelected,
                      selectedColor: const Color(0xFFE65100),
                      backgroundColor: isOccupied ? Colors.red.shade50 : null,
                      side: BorderSide(
                        color: isOccupied
                            ? Colors.red.shade300
                            : (isSelected
                                ? const Color(0xFFE65100)
                                : Colors.grey.shade300),
                      ),
                      onSelected: (selected) {
                        if (isOccupied) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                '⚠️ $table sedang PENUH! Silakan pilih meja lain yang tersedia.',
                              ),
                              backgroundColor: Colors.red.shade700,
                              duration: const Duration(seconds: 2),
                            ),
                          );
                          return;
                        }
                        if (selected) {
                          setState(() {
                            _selectedTable = table;
                          });
                        }
                      },
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 10),

            // Tampilan Keterangan / Tulisan Meja Penuh
            if (_allTablesFull)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.red.shade300),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.error_outline, color: Colors.red, size: 22),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Text(
                        'Semua Meja Penuh! Area makan di tempat saat ini penuh kapasitas. Silakan pilih opsi "Bungkus (Take Away)".',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            else
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.orange.shade200),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.orange.shade800, size: 16),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Meja bertanda "(Penuh)" terisi pelanggan. Meja Anda terpilih: $_safeSelectedTable',
                        style: TextStyle(
                          color: Colors.orange.shade900,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 16),
          ],

          // Widget 4: RadioListTile for Payment Methods
          const Text(
            'Metode Pembayaran',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Column(
              children: [
                // ignore: deprecated_member_use
                RadioListTile<String>(
                  title: const Text('KantinPay (Dompet Digital Mahasiswa)'),
                  subtitle: Text(
                    'Saldo Anda: Rp ${state.userBalance.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}',
                    style: TextStyle(
                      color: state.userBalance >= state.finalTotal
                          ? Colors.green
                          : Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  secondary: const Icon(Icons.account_balance_wallet, color: Colors.blue),
                  value: 'KantinPay',
                  // ignore: deprecated_member_use
                  groupValue: _paymentMethod,
                  // ignore: deprecated_member_use
                  onChanged: (val) => setState(() => _paymentMethod = val!),
                ),
                const Divider(height: 1),
                // ignore: deprecated_member_use
                RadioListTile<String>(
                  title: const Text('QRIS Instan (BCA / GoPay / OVO / Dana)'),
                  subtitle: const Text('Scan QR Code langsung dari meja'),
                  secondary: const Icon(Icons.qr_code_scanner, color: Colors.deepOrange),
                  value: 'QRIS',
                  // ignore: deprecated_member_use
                  groupValue: _paymentMethod,
                  // ignore: deprecated_member_use
                  onChanged: (val) => setState(() => _paymentMethod = val!),
                ),
                const Divider(height: 1),
                // ignore: deprecated_member_use
                RadioListTile<String>(
                  title: const Text('Bayar Tunai di Kasir Bu Sari'),
                  subtitle: const Text('Bayar langsung saat mengambil pesanan'),
                  secondary: const Icon(Icons.point_of_sale, color: Colors.green),
                  value: 'Tunai di Kasir',
                  // ignore: deprecated_member_use
                  groupValue: _paymentMethod,
                  // ignore: deprecated_member_use
                  onChanged: (val) => setState(() => _paymentMethod = val!),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Widget 5: Voucher Promo Code Field
          const Text(
            'Kupon Diskon',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _voucherController,
                  textCapitalization: TextCapitalization.characters,
                  decoration: InputDecoration(
                    hintText: 'Masukkan kode promo (ex: MHSHEMAT)',
                    prefixIcon: const Icon(Icons.local_offer_outlined),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                onPressed: () {
                  final code = _voucherController.text.trim();
                  if (code.isEmpty) return;
                  final success = state.applyVoucher(code);
                  if (success) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Kupon "$code" berhasil digunakan!'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Kode voucher tidak valid. Gunakan: MHSHEMAT'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                child: const Text('Pakai'),
              ),
            ],
          ),

          if (state.appliedVoucher.isNotEmpty) ...[
            const SizedBox(height: 8),
            Chip(
              backgroundColor: Colors.green.shade50,
              label: Text(
                'Voucher Aktif: ${state.appliedVoucher} (- Rp 5.000)',
                style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
              ),
              deleteIcon: const Icon(Icons.cancel, size: 18),
              onDeleted: () => state.removeVoucher(),
            ),
          ],

          const SizedBox(height: 20),

          // Widget 6: Rincian Pembayaran Card
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 1,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildSummaryRow(
                    'Subtotal Menu',
                    'Rp ${state.subtotal.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}',
                  ),
                  const SizedBox(height: 8),
                  _buildSummaryRow(
                    'Pajak Kantin (10%)',
                    'Rp ${state.taxAmount.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}',
                  ),
                  if (state.voucherDiscount > 0) ...[
                    const SizedBox(height: 8),
                    _buildSummaryRow(
                      'Diskon Kupon Mahasiswa',
                      '- Rp ${state.voucherDiscount.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}',
                      isDiscount: true,
                    ),
                  ],
                  const Divider(height: 20),
                  _buildSummaryRow(
                    'Total Pembayaran',
                    'Rp ${state.finalTotal.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}',
                    isTotal: true,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Widget 7: Checkout Button
          FilledButton.icon(
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            icon: const Icon(Icons.check_circle_outline),
            label: Text(
              'Konfirmasi & Bayar (Rp ${state.finalTotal.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')})',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            onPressed: () {
              if (_orderType == 'Makan di Tempat') {
                if (_allTablesFull || _tableOccupied[_selectedTable] == true) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        '⚠️ Meja sedang PENUH! Silakan pilih meja yang kosong atau pilih opsi Bungkus (Take Away).',
                      ),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }
              }

              if (_paymentMethod == 'KantinPay' &&
                  state.userBalance < state.finalTotal) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Saldo KantinPay tidak mencukupi! Silakan top up di profil.'),
                    backgroundColor: Colors.red,
                  ),
                );
                return;
              }

              final order = state.placeOrder(
                orderType: _orderType,
                tableNumber: _orderType == 'Makan di Tempat' ? _selectedTable : 'Take Away',
                paymentMethod: _paymentMethod,
              );

              _showOrderSuccessDialog(context, order);
            },
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value,
      {bool isDiscount = false, bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 16 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isTotal ? 18 : 14,
            fontWeight: isTotal ? FontWeight.w900 : FontWeight.w600,
            color: isDiscount
                ? Colors.green
                : (isTotal ? const Color(0xFFE65100) : null),
          ),
        ),
      ],
    );
  }
}
