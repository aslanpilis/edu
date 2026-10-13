# 🚀 Edu Çocuk: 3-12 Yaş Çocuk Eğitim Platformu (Flutter & Firebase)

Çocukların motor, bilişsel, mantıksal ve problem çözme becerilerini oyunlaştırarak geliştiren; yaşa göre adapte olabilen ve ebeveynlere detaylı analitik sunan **Flutter & Firebase** tabanlı çoklu platform eğitim uygulaması.

---

## 📱 Yaş Segmentasyonu & Deneyim Modülleri

1. **3-5 Yaş (Okul Öncesi - Keşif & Duyu Dünyası):**
   - Sıfır metin, büyük dokunmatik hedefler, sesli yönlendirmeler.
   - Sayı sayma (meyve toplama), harf sesleri (fonetik), duygu tanıma ve şekil örüntüleri.
2. **6-8 Yaş (Erken İlkokul - Macera Adası):**
   - Macera adası görev haritası, 4 işlem, kelime bulmacaları ve görsel yönlendirme blokları.
   - Anında pozitif geri bildirim (Growth Mindset).
3. **9-12 Yaş (İleri İlkokul/Ortaokul - Ustalık & Kodlama Üssü):**
   - Blok tabanlı kodlama ve döngüler (Loops/Algorithms), uzay bilimleri simülasyonu ve problem çözme.

---

## 🔥 Firebase & Firestore NoSQL Veritabanı Mimarisi

* `users/{parentId}`: Ebeveyn ana hesabı ve abonelik durumu.
* `users/{parentId}/children/{childId}`: Ebeveyn altındaki çocuk profilleri (Takma ad, yaş, XP, günlük süre limitleri).
* `progress/{childId_lessonId}`: Tamamlanan dersler, başarı skoru (%0-100), harcanan süre ve yıldızlar (1-3 ⭐).
* `achievements/{childId_badgeId}`: Otomatik kilitlenen ve kazanılan rozetler (İlk Adım, Sayılar Büyücüsü, 3 Günlük Seri).
* `daily_logs/{childId_YYYY-MM-DD}`: Günlük öğrenme süresi ve pedagojik yetkinlik logları.

---

## 🛠️ Proje Dizin Yapısı

```
edu/
├── pubspec.yaml                     # Flutter paketleri (Firebase, Provider, Audioplayers vb.)
├── firestore.rules                  # Prodüksiyon hazır Firestore güvenlik kuralları
├── firestore.indexes.json           # Optimize edilmiş sorgu indeksleri
├── lib/
│   ├── main.dart                    # Uygulama giriş noktası ve Provider yönlendiricisi
│   ├── config/
│   │   ├── app_theme.dart           # Yaş gruplarına özel renk paletleri ve stiller
│   │   └── constants.dart           # Rozetler, avatarlar ve evde etkinlik önerileri
│   ├── models/
│   │   ├── parent_user.dart         # Ebeveyn kullanıcı modeli
│   │   ├── child_profile.dart       # Çocuk profil modeli & süre sınırları
│   │   ├── curriculum_models.dart   # Müfredat, Modül, Ders ve Aktivite modelleri
│   │   └── progress_models.dart     # İlerleme, Rozet ve Günlük Log modelleri
│   ├── services/
│   │   ├── firebase_service.dart    # Canlı Firestore/Auth ve yerel veri yöneticisi
│   │   ├── progress_service.dart    # XP, Streak, Rozet ve Analitik hesaplama motoru
│   │   ├── audio_service.dart       # Başarı tınıları ve ses efektleri
│   │   └── mock_data_service.dart   # 3-5, 6-8 ve 9-12 yaş için hazır zengin müfredat
│   ├── providers/
│   │   ├── auth_provider.dart       # Ebeveyn ve aktif çocuk State yönetimi
│   │   ├── learning_provider.dart   # İnteraktif ders akışı ve skor yöneticisi
│   │   └── parent_provider.dart     # Ebeveyn analitik ve karne State'i
│   ├── screens/
│   │   ├── auth/                    # Giriş ve Çocuk Profil Seçim Ekranları
│   │   ├── child/                   # 3-5, 6-8 ve 9-12 yaşa göre dinamik ana ekranlar
│   │   ├── learning/                # İnteraktif mini oyunlar & ders motoru
│   │   └── parent/                  # Parental Gate, Süre Sınırları & Analitik Karnesi
│   └── widgets/                     # 3D butonlar, XP barı, Rozet kartları, Süre banner'ı
```

---

## 🚀 Uygulamayı Çalıştırma

### 1. Bağımlılıkları Yükleyin:
```bash
flutter pub get
```

### 2. Uygulamayı Başlatın:
```bash
# Android veya iOS Cihaz / Emülatör:
flutter run

# Web veya Masaüstü:
flutter run -d chrome
flutter run -d windows
```

### 3. Canlı Firebase Projesini Bağlama (İsteğe Bağlı):
Uygulama varsayılan olarak sıfır konfigürasyonla çalışabilen akıllı bir yerel NoSQL katmanına sahiptir. Kendi Firebase projenizi bağlamak için:
```bash
flutterfire configure
```
komutunu çalıştırmanız yeterlidir.
