import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';

class FirebaseSetupScreen extends StatelessWidget {
  const FirebaseSetupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Firebase & Veritabanı Mimarisi'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: auth.isFirebaseLive ? const Color(0xFFF0FDF4) : const Color(0xFFFFFBEB),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: auth.isFirebaseLive ? const Color(0xFF86EFAC) : const Color(0xFFFDE68A),
                  width: 2,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: auth.isFirebaseLive ? const Color(0xFFDCFCE7) : const Color(0xFFFEF3C7),
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Text(auth.isFirebaseLive ? '🔥' : '⚡', style: const TextStyle(fontSize: 26)),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          auth.isFirebaseLive
                              ? 'Firebase Firestore & Auth Bağlı'
                              : 'Yerel NoSQL Simülasyonu Aktif',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                            color: auth.isFirebaseLive ? const Color(0xFF15803D) : const Color(0xFFB45309),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          auth.isFirebaseLive
                              ? 'Tüm ilerleme ve kullanıcı verileri Google Cloud Firestore ile gerçek zamanlı senkronize ediliyor.'
                              : 'Veriler cihaz üzerinde SharedPreferences ile kalıcı olarak saklanıyor. Firebase yapılandırıldığında otomatik senkronize olur.',
                          style: const TextStyle(fontSize: 12, color: Color(0xFF64748B), fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),

            const Text(
              'Firestore Veri Koleksiyonları (NoSQL Schema)',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Color(0xFF1E293B)),
            ),
            const SizedBox(height: 12),

            _buildSchemaItem(
              collection: 'users/{parentId}',
              desc: 'Ebeveyn ana hesap kaydı, e-posta, abonelik durumu ve bildirim tercihleri.',
            ),
            _buildSchemaItem(
              collection: 'users/{parentId}/children/{childId}',
              desc: 'Çocuk alt profilleri (Takma ad, yaş, yaş grubu, toplam XP, günlük süre limitleri).',
            ),
            _buildSchemaItem(
              collection: 'progress/{childId_lessonId}',
              desc: 'Tamamlanan dersler, başarı puanı (0-100), harcanan süre ve kazanılan yıldızlar (1-3).',
            ),
            _buildSchemaItem(
              collection: 'achievements/{childId_badgeId}',
              desc: 'Açılan başarı rozetleri (İlk Adım, Sayılar Büyücüsü, 3 Günlük Seri vb.).',
            ),
            _buildSchemaItem(
              collection: 'daily_logs/{childId_YYYY-MM-DD}',
              desc: 'Günlük harcanan dakikalar, tamamlanan ders sayıları ve pedagojik yetkinlik logları.',
            ),
            const SizedBox(height: 24),

            const Text(
              'Flutter Projesinde Canlı Firebase’i Etkinleştirme',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Color(0xFF1E293B)),
            ),
            const SizedBox(height: 12),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '1. Firebase CLI ile entegrasyon:',
                    style: TextStyle(color: Color(0xFFFBBF24), fontWeight: FontWeight.w700, fontSize: 13),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'flutterfire configure',
                    style: TextStyle(color: Colors.white, fontFamily: 'monospace', fontSize: 14),
                  ),
                  SizedBox(height: 12),
                  Text(
                    '2. main.dart içinde Firebase başlatma:',
                    style: TextStyle(color: Color(0xFFFBBF24), fontWeight: FontWeight.w700, fontSize: 13),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'await Firebase.initializeApp(\n  options: DefaultFirebaseOptions.currentPlatform,\n);',
                    style: TextStyle(color: Colors.white, fontFamily: 'monospace', fontSize: 13),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSchemaItem({required String collection, required String desc}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('📁', style: TextStyle(fontSize: 18)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  collection,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF6366F1),
                    fontFamily: 'monospace',
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  desc,
                  style: const TextStyle(fontSize: 12, color: Color(0xFF64748B), fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
