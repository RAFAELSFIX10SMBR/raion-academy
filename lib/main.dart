import 'package:flutter/material.dart';

void main() => runApp(const DompetkuApp());

// ============================================================
// APP UTAMA
// ============================================================
class DompetkuApp extends StatelessWidget {
  const DompetkuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dompetku',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: AppColors.primary,
        scaffoldBackgroundColor: AppColors.background,
      ),
      home: const HomePage(),
    );
  }
}

// ============================================================
// WARNA & DATA (ditulis langsung di kode untuk Day 1)
// ============================================================
class AppColors {
  static const primary = Color.fromARGB(255, 63, 181, 94);
  static const background = Color.fromARGB(255, 232, 255, 232);
  static const textGrey = Color(0xFF9E9E9E);
}

class CategoryData {
  final String name;
  final IconData icon;
  final Color color;

  const CategoryData(this.name, this.icon, this.color);
}

const List<CategoryData> categories = [
  CategoryData('Makan', Icons.restaurant, Colors.orange),
  CategoryData('Transport', Icons.two_wheeler, Colors.blue),
  CategoryData('Kuliah', Icons.school, Colors.purple),
  CategoryData('Lainnya', Icons.more_horiz, Colors.grey),
];

class ExpenseData {
  final CategoryData category;
  final String title;
  final String time;
  final String amount;

  const ExpenseData(this.category, this.title, this.time, this.amount);
}

final List<ExpenseData> expenses = [
  ExpenseData(categories[0], 'Nasi goreng', '07.30', '-Rp15.000'),
  ExpenseData(categories[1], 'Ojek ke kampus', '08.10', '-Rp12.000'),
  ExpenseData(categories[2], 'Print tugas', '10.45', '-Rp3.000'),
  ExpenseData(categories[0], 'Es teh', '12.15', '-Rp5.000'),
];

// ============================================================
// HALAMAN 1 - HOME
// ============================================================
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Tidak pakai AppBar: bagian paling atas langsung header
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const ProfileHeader(name: 'Rafael'),
              const SizedBox(height: 20),
              BalanceCard(
                balance: 'Rp255.000',
                onCatat: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AddExpensePage()),
                  );
                },
              ),
              const SizedBox(height: 24),
              const SectionTitle(title: 'Kategori'),
              const SizedBox(height: 12),
              // 4 kategori berjejer rata ke samping
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: categories
                    .map((c) => CategoryItem(category: c))
                    .toList(),
              ),
              const SizedBox(height: 24),
              const SectionTitle(title: 'Riwayat', trailing: 'Hari ini'),
              const SizedBox(height: 12),
              const HistoryList(),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------- Header: foto profil + sapaan + nama + lonceng ----------
class ProfileHeader extends StatelessWidget {
  final String name;

  const ProfileHeader({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Foto dari folder assets (bukan internet)
        ClipOval(
          child: Image.asset(
            'assets/IMG_7740.JPG',
            width: 44,
            height: 44,
            fit: BoxFit.cover,
            // Cadangan kalau file belum ada, supaya tidak error merah
            errorBuilder: (context, error, stackTrace) => Container(
              width: 44,
              height: 44,
              color: Colors.teal.shade100,
              child: const Icon(Icons.person, color: Colors.teal),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Selamat pagi,',
                style: TextStyle(fontSize: 12, color: AppColors.textGrey),
              ),
              Text(
                name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        const Icon(Icons.notifications_none),
      ],
    );
  }
}

// ---------- Kartu sisa saldo ----------
class BalanceCard extends StatelessWidget {
  final String balance;
  final VoidCallback onCatat;

  const BalanceCard({super.key, required this.balance, required this.onCatat});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.account_balance_wallet, color: Colors.white70, size: 16),
              SizedBox(width: 6),
              Text(
                'Sisa saldo',
                style: TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            balance,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onCatat,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFEDE7F6),
                foregroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text('+ Catat Pengeluaran'),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------- Judul bagian (dipakai berulang) ----------
class SectionTitle extends StatelessWidget {
  final String title;
  final String? trailing;

  const SectionTitle({super.key, required this.title, this.trailing});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        if (trailing != null)
          Text(
            trailing!,
            style: const TextStyle(fontSize: 12, color: AppColors.textGrey),
          ),
      ],
    );
  }
}

// ---------- Item kategori: kotak ikon + nama di bawahnya ----------
class CategoryItem extends StatelessWidget {
  final CategoryData category;

  const CategoryItem({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(category.icon, color: category.color),
        ),
        const SizedBox(height: 6),
        Text(category.name, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}

// ---------- Riwayat: satu kotak, dipisah garis ----------
class HistoryList extends StatelessWidget {
  const HistoryList({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          for (int i = 0; i < expenses.length; i++) ...[
            HistoryItem(expense: expenses[i]),
            if (i != expenses.length - 1) const Divider(height: 1),
          ],
        ],
      ),
    );
  }
}

class HistoryItem extends StatelessWidget {
  final ExpenseData expense;

  const HistoryItem({super.key, required this.expense});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Icon(expense.category.icon, color: expense.category.color),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  expense.title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  expense.time,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textGrey,
                  ),
                ),
              ],
            ),
          ),
          Text(
            expense.amount,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// HALAMAN 2 - TAMBAH PENGELUARAN
// ============================================================
class AddExpensePage extends StatefulWidget {
  const AddExpensePage({super.key});

  @override
  State<AddExpensePage> createState() => _AddExpensePageState();
}

class _AddExpensePageState extends State<AddExpensePage> {
  int selectedIndex = 0; // kategori yang sedang terpilih

  @override
  Widget build(BuildContext context) {
    // AppBar otomatis punya tombol back karena halaman ini dibuka via push
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Pengeluaran'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ----- Nominal -----
            const Text(
              'Nominal',
              style: TextStyle(fontSize: 12, color: AppColors.textGrey),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Rp',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    keyboardType: TextInputType.number,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                    decoration: const InputDecoration(hintText: '0'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // ----- Pilihan kategori -----
            const Text(
              'Kategori',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (int i = 0; i < categories.length; i++)
                  CategoryChip(
                    category: categories[i],
                    selected: selectedIndex == i,
                    onTap: () => setState(() => selectedIndex = i),
                  ),
              ],
            ),
            const SizedBox(height: 24),

            // ----- Catatan (setinggi 3 baris) -----
            const TextField(
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Catatan',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),

            // ----- Tombol Simpan (selebar layar) -----
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                child: const Text('Simpan'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------- Chip kategori (dipakai 4 kali) ----------
class CategoryChip extends StatelessWidget {
  final CategoryData category;
  final bool selected;
  final VoidCallback onTap;

  const CategoryChip({
    super.key,
    required this.category,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: selected ? AppColors.primary : Colors.grey.shade300,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              category.icon,
              size: 16,
              color: selected ? Colors.white : category.color,
            ),
            const SizedBox(width: 6),
            Text(
              category.name,
              style: TextStyle(
                fontSize: 12,
                color: selected ? Colors.white : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}