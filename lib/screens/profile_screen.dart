import 'package:flutter/material.dart';
import '../state/kantin_state.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void _showTopUpDialog(BuildContext context, KantinState state) {
    int selectedAmount = 50000;
    final amounts = [10000, 20000, 50000, 100000];

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: const Row(
              children: [
                Icon(Icons.add_card, color: Colors.deepOrange),
                SizedBox(width: 8),
                Text('Top Up KantinPay'),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Pilih nominal saldo yang ingin ditambahkan:'),
                const SizedBox(height: 14),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: amounts.map((amt) {
                    final isSel = selectedAmount == amt;
                    return ChoiceChip(
                      label: Text(
                        'Rp ${amt.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}',
                      ),
                      selected: isSel,
                      onSelected: (val) {
                        if (val) setDialogState(() => selectedAmount = amt);
                      },
                    );
                  }).toList(),
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
                  state.topUpBalance(selectedAmount);
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Top up berhasil! Saldo bertambah Rp ${selectedAmount.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}',
                      ),
                      backgroundColor: Colors.green,
                    ),
                  );
                },
                child: const Text('Isi Saldo'),
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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil & Informasi'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Widget 1: Profile Identity Card
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 36,
                    backgroundColor: theme.colorScheme.primary.withAlpha(40),
                    child: Text(
                      'AR',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          state.studentName,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'NPM: ${state.studentNim}',
                          style: TextStyle(
                            color: Colors.grey.shade700,
                            fontSize: 13,
                          ),
                        ),
                        Text(
                          state.studentClass,
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Widget 2: KantinPay Balance & Top Up Card
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            elevation: 2,
            color: const Color(0xFF1E293B),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Saldo KantinPay',
                        style: TextStyle(color: Colors.white70, fontSize: 13),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.green.withAlpha(50),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'Aktif',
                          style: TextStyle(color: Colors.greenAccent, fontSize: 11, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Rp ${state.userBalance.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepOrange,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: () => _showTopUpDialog(context, state),
                        icon: const Icon(Icons.add, size: 18),
                        label: const Text('Isi Ulang Saldo'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Widget 3: Setting Switches
          const Text(
            'Pengaturan Aplikasi',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Column(
              children: [
                SwitchListTile(
                  secondary: const Icon(Icons.notifications_active_outlined),
                  title: const Text('Notifikasi Pesanan'),
                  subtitle: const Text('Dapatkan kabar saat pesanan sudah siap'),
                  value: state.isNotificationEnabled,
                  onChanged: (val) => state.toggleNotifications(val),
                ),
                const Divider(height: 1),
                SwitchListTile(
                  secondary: const Icon(Icons.dark_mode_outlined),
                  title: const Text('Mode Gelap (Dark Mode)'),
                  subtitle: const Text('Sesuaikan tampilan dengan kenyamanan mata'),
                  value: state.themeMode == ThemeMode.dark,
                  onChanged: (val) => state.toggleTheme(),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Widget 4: ExpansionTile Information (Informasi Kantin)
          const Text(
            'Informasi & Layanan',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Column(
              children: [
                const ExpansionTile(
                  leading: Icon(Icons.storefront_outlined, color: Colors.deepOrange),
                  title: Text('Jam Operasional & Lokasi'),
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
                      child: Text(
                        '• Hari Buka: Senin - Sabtu\n'
                        '• Jam Layanan: 07.30 - 16.30 WIB\n'
                        '• Lokasi: Gedung Kantin Utama (Lantai 1, Stand No. 04)\n'
                        '• Menyajikan masakan rumahan higienis, halal, dan harga ramah mahasiswa.',
                        style: TextStyle(height: 1.5, fontSize: 13),
                      ),
                    ),
                  ],
                ),
                const Divider(height: 1),
                ExpansionTile(
                  leading: const Icon(Icons.widgets_outlined, color: Colors.blue),
                  title: const Text('Widget Eksplorasi'),
                  subtitle: const Text('Daftar implementasi >5 widget per halaman'),
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text('1. Beranda: Scaffold, AppBar, TextField (Search), ChoiceChip (Filter), GridView, Card, Badge, FloatingActionButton.', style: TextStyle(fontSize: 12, height: 1.4)),
                          SizedBox(height: 4),
                          Text('2. Detail Menu: SliverAppBar, CheckboxListTile (Topping), TextField (Catatan), Quantity Counter, BottomAppBar.', style: TextStyle(fontSize: 12, height: 1.4)),
                          SizedBox(height: 4),
                          Text('3. Keranjang: ListView, SegmentedButton (Dine-in/Takeaway), DropdownButtonFormField (Meja), RadioListTile (Bayar), AlertDialog (Struk).', style: TextStyle(fontSize: 12, height: 1.4)),
                          SizedBox(height: 4),
                          Text('4. Riwayat: TabBar, TabBarView, LinearProgressIndicator, Stepper Tracker, BottomSheet, Rating Stars Dialog.', style: TextStyle(fontSize: 12, height: 1.4)),
                          SizedBox(height: 4),
                          Text('5. Profil: CircleAvatar, SwitchListTile (Theme & Notif), ExpansionTile, ChoiceChip (Top Up), SnackBar feedback.', style: TextStyle(fontSize: 12, height: 1.4)),
                        ],
                      ),
                    ),
                  ],
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.phone_in_talk_outlined, color: Colors.green),
                  title: const Text('Kontak WhatsApp Bu Sari'),
                  subtitle: const Text('+62 812-3456-7890'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Menghubungkan ke WhatsApp Bu Sari...'),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
