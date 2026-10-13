import 'package:flutter/material.dart';
import '../models/child_profile.dart';

class SystemConstants {
  static const List<Map<String, dynamic>> avatarOptions = [
    {'id': 'fox', 'name': 'Minik Tilki', 'emoji': '🦊', 'bg': Color(0xFFFFEDD5)},
    {'id': 'bear', 'name': 'Sevimli Ayı', 'emoji': '🐻', 'bg': Color(0xFFFEF3C7)},
    {'id': 'panda', 'name': 'Bambu Panda', 'emoji': '🐼', 'bg': Color(0xFFD1FAE5)},
    {'id': 'lion', 'name': 'Cesur Aslan', 'emoji': '🦁', 'bg': Color(0xFFFEF08A)},
    {'id': 'astronaut', 'name': 'Uzay Kâşifi', 'emoji': '👨‍🚀', 'bg': Color(0xFFDBEAFE)},
    {'id': 'wizard', 'name': 'Bilim Sihirbazı', 'emoji': '🧙‍♂️', 'bg': Color(0xFFEDE9FE)},
    {'id': 'robot', 'name': 'Dost Robot', 'emoji': '🤖', 'bg': Color(0xFFCFFAFE)},
    {'id': 'unicorn', 'name': 'Büyülü Tekboynuz', 'emoji': '🦄', 'bg': Color(0xFFFCE7F3)},
  ];

  static const List<Map<String, dynamic>> systemBadges = [
    {
      'badgeId': 'first_lesson',
      'title': 'İlk Adım Kâşifi',
      'description': 'İlk dersini başarıyla tamamladın!',
      'icon': '🌟',
      'category': 'explorer',
    },
    {
      'badgeId': 'streak_3',
      'title': '3 Günlük Alev',
      'description': 'Üst üste 3 gün öğrenmeye devam ettin!',
      'icon': '🔥',
      'category': 'streak',
    },
    {
      'badgeId': 'math_wizard',
      'title': 'Sayılar Büyücüsü',
      'description': 'Matematik derslerinde 3 yıldız kazandın!',
      'icon': '🧮',
      'category': 'math',
    },
    {
      'badgeId': 'word_master',
      'title': 'Kelime Ustası',
      'description': 'Dil ve okuma görevlerini kusursuz tamamladın!',
      'icon': '📚',
      'category': 'reading',
    },
    {
      'badgeId': 'coder_junior',
      'title': 'Geleceğin Kodlayıcısı',
      'description': 'Algoritma ve blok kodlama bulmacasını çözdün!',
      'icon': '💻',
      'category': 'stem',
    },
  ];

  static const Map<String, List<String>> offlineActivitySuggestions = {
    '3-5': [
      'Evdeki nesneleri renklerine göre ayırma oyunu (Mavi çoraplar, kırmızı mandallar).',
      'Hamurdan temel geometrik şekiller (Daire, Kare, Üçgen) yapma.',
      'Birlikte sesli masal okurken karakterlerin duygularını taklit etme.',
    ],
    '6-8': [
      'Mutfak terazisi ile meyve ve sebzeleri tartıp ağırlık karşılaştırma.',
      'Evde yön bulma hazine avı haritası çizip 5 adım ileri, 2 adım sağa komutları verme.',
      'Birlikte haftalık küçük bir günlük veya 3 cümlelik resimli hikaye yazma.',
    ],
    '9-12': [
      'Kağıttan köprü projesi yaparak üzerine kaç madeni para taşıyacağını test etme (Mühendislik).',
      'Basit bir aile bütçesi tablosu hazırlayarak haftalık harcamaları grafikleştirme.',
      'Kısa bir stop-motion animasyon veya çizgi hikaye senaryosu tasarlama.',
    ],
  };

  static String getAgeGroupDescription(AgeGroup group) {
    switch (group) {
      case AgeGroup.age3To5:
        return 'Sıfır metin, büyük dokunmatik hedefler, sesli rehberlik ve motor becerileri.';
      case AgeGroup.age6To8:
        return 'Macera adası haritası, erken okuryazarlık, 4 işlem ve görsel robot kodlama.';
      case AgeGroup.age9To12:
        return 'STEM, algoritmik döngüler, bilim simülasyonları ve kritik düşünme.';
    }
  }

  static String getAgeGroupMascot(AgeGroup group) {
    switch (group) {
      case AgeGroup.age3To5:
        return '🐾 Tomi & Pamuk';
      case AgeGroup.age6To8:
        return '🚀 Kaptan Bilge';
      case AgeGroup.age9To12:
        return '⚡ Siber Kâşif';
    }
  }
}
