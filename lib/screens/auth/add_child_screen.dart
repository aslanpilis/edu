import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../config/constants.dart';
import '../../widgets/custom_button.dart';

class AddChildScreen extends StatefulWidget {
  const AddChildScreen({super.key});

  @override
  State<AddChildScreen> createState() => _AddChildScreenState();
}

class _AddChildScreenState extends State<AddChildScreen> {
  final _nameController = TextEditingController();
  int _selectedAge = 5;
  String _selectedAvatar = '🦊';

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _save() async {
    if (_nameController.text.trim().isEmpty) return;

    final auth = context.read<AuthProvider>();
    await auth.addChild(
      nickname: _nameController.text.trim(),
      age: _selectedAge,
      avatarUrl: _selectedAvatar,
    );

    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Yeni Çocuk Profili'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Avatar Seçin',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: SystemConstants.avatarOptions.map((opt) {
                final isSelected = _selectedAvatar == opt['emoji'];
                return InkWell(
                  onTap: () => setState(() => _selectedAvatar = opt['emoji']),
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: opt['bg'] as Color,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected ? const Color(0xFFF59E0B) : Colors.transparent,
                        width: 3,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(opt['emoji'], style: const TextStyle(fontSize: 32)),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 28),

            const Text(
              'Çocuğun Adı veya Takma Adı (COPPA Uyumlu)',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                hintText: 'Örn: Zeynep, Mert',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
              ),
            ),
            const SizedBox(height: 28),

            const Text(
              'Yaş',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: List.generate(10, (idx) {
                final age = idx + 3; // 3 - 12
                final isSelected = _selectedAge == age;
                return ChoiceChip(
                  label: Text('$age Yaş', style: const TextStyle(fontWeight: FontWeight.w700)),
                  selected: isSelected,
                  selectedColor: const Color(0xFFF59E0B),
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : const Color(0xFF1E293B),
                  ),
                  onSelected: (_) => setState(() => _selectedAge = age),
                );
              }),
            ),
            const SizedBox(height: 40),

            SizedBox(
              width: double.infinity,
              child: CustomChildButton(
                text: 'Profili Kaydet & Başla',
                onPressed: _save,
                backgroundColor: const Color(0xFF10B981),
                shadowColor: const Color(0xFF059669),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
