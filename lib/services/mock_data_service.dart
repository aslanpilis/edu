import 'package:flutter/material.dart';
import '../models/child_profile.dart';
import '../models/curriculum_models.dart';

class MockDataService {
  static List<Curriculum> getCurriculums(AgeGroup? ageGroup) {
    final list = [
      // 3-5 & 4-6 Yaş Özel Dünyaları
      Curriculum(
        id: 'curr_memory_brain',
        title: 'Beyin Jimnastiği & Hafıza Oyunları 🧠',
        description: 'Hafıza kartları, sıralı ışıklar ve dikkat geliştirme oyunları.',
        targetAgeGroup: AgeGroup.age3To5,
        category: SubjectCategory.math,
        icon: '🃏',
        gradientCode: 'amber',
        order: 1,
      ),
      Curriculum(
        id: 'curr_algorithm_maze',
        title: 'Minik Kâşif Algoritma & Mantık 🧩',
        description: 'Tavşan labirenti, yön bulma ve silüet gölge eşleştirme.',
        targetAgeGroup: AgeGroup.age3To5,
        category: SubjectCategory.stem,
        icon: '🐰',
        gradientCode: 'emerald',
        order: 2,
      ),
      Curriculum(
        id: 'curr_nature_science',
        title: 'Doğa, Renkler & Yaşam Laboratuvarı 🧪',
        description: 'Denge terazisi, yaşam alanları, boyut dizilimi ve renk karıştırma.',
        targetAgeGroup: AgeGroup.age3To5,
        category: SubjectCategory.sel,
        icon: '🌍',
        gradientCode: 'blue',
        order: 3,
      ),
      Curriculum(
        id: 'curr_3_5_math',
        title: 'Minik Sayılar & Şekiller Dünyası 🔢',
        description: 'Nesneleri sayma, temel renkler ve geometrik şekilleri eğlenceli dokunuşlarla keşfet.',
        targetAgeGroup: AgeGroup.age3To5,
        category: SubjectCategory.math,
        icon: '🍎',
        gradientCode: 'amber',
        order: 4,
      ),

      // 6-8 Yaş
      Curriculum(
        id: 'curr_6_8_math',
        title: 'Macera Adası: 4 İşlem & Geometri 🏝️',
        description: 'Toplama, çıkarma, ritmik sayma ve şekil örüntülerini çözerek adayı keşfet.',
        targetAgeGroup: AgeGroup.age6To8,
        category: SubjectCategory.math,
        icon: '🏝️',
        gradientCode: 'emerald',
        order: 1,
      ),
      Curriculum(
        id: 'curr_6_8_stem',
        title: 'Minik Robot Kodlama Laboratuvarı 🤖',
        description: 'Görsel blokları sıraya diz, minik robotu engellerin üzerinden geçirip hedefe ulaştır.',
        targetAgeGroup: AgeGroup.age6To8,
        category: SubjectCategory.stem,
        icon: '🤖',
        gradientCode: 'blue',
        order: 2,
      ),

      // 9-12 Yaş
      Curriculum(
        id: 'curr_9_12_stem',
        title: 'Siber Kâşif: Algoritma & Kodlama ⚡',
        description: 'Döngüler, koşullu ifadeler ve mantıksal problem çözme ile gerçek kodlama mantığını kavra.',
        targetAgeGroup: AgeGroup.age9To12,
        category: SubjectCategory.stem,
        icon: '⚡',
        gradientCode: 'purple',
        order: 1,
      ),
      Curriculum(
        id: 'curr_9_12_sci',
        title: 'Uzay & Doğa Bilimleri Simülasyonu 🪐',
        description: 'Gezegenler, yerçekimi ve ekosistem dengesini interaktif sorularla keşfet.',
        targetAgeGroup: AgeGroup.age9To12,
        category: SubjectCategory.stem,
        icon: '🪐',
        gradientCode: 'cyan',
        order: 2,
      ),
    ];

    if (ageGroup == null) return list;
    return list.where((c) => c.targetAgeGroup == ageGroup).toList();
  }

  static List<Module> getModules(String curriculumId) {
    final allModules = [
      // 1. Hafıza & Dikkat Modülleri (4-6 Yaş)
      Module(
        id: 'mod_memory_cards',
        curriculumId: 'curr_memory_brain',
        title: 'Sevimli Hayvanlar Hafıza Kartları',
        description: 'Kartları çevir, aynı hayvanları aklında tutup eşleştir.',
        icon: '🃏',
        colorHex: '#F59E0B',
        order: 1,
      ),
      Module(
        id: 'mod_simon_lights',
        curriculumId: 'curr_memory_brain',
        title: 'Sıralı Işıklar & Renk Hafızası',
        description: 'Yanan renkleri sırayla izle ve aynı sırayla dokun.',
        icon: '🎈',
        colorHex: '#EC4899',
        order: 2,
      ),
      Module(
        id: 'mod_rhythm_repeat',
        curriculumId: 'curr_memory_brain',
        title: 'Müzik & Ritim Taklidi',
        description: 'Enstrümanların çaldığı ritmi dinle ve aynısını çal.',
        icon: '🥁',
        colorHex: '#8B5CF6',
        order: 3,
      ),

      // 2. Algoritma & Mantık Modülleri (4-6 Yaş)
      Module(
        id: 'mod_maze_rabbit',
        curriculumId: 'curr_algorithm_maze',
        title: 'Tavşanın Havuç Labirenti',
        description: 'Yön oklarını ekleyerek tavşanı engellerden geçir ve havuca ulaştır.',
        icon: '🐰',
        colorHex: '#10B981',
        order: 1,
      ),
      Module(
        id: 'mod_shadow_match',
        curriculumId: 'curr_algorithm_maze',
        title: 'Gölge & Silüet Dedektifi',
        description: 'Karanlık gölgenin hangi sevimli hayvana ait olduğunu bul.',
        icon: '🕵️‍♂️',
        colorHex: '#3B82F6',
        order: 2,
      ),
      Module(
        id: 'mod_odd_one_out',
        curriculumId: 'curr_algorithm_maze',
        title: 'Farklı Olanı Bul (Sınıflandırma)',
        description: 'Gruba uymayan nesneyi mantık yürüterek keşfet.',
        icon: '🔎',
        colorHex: '#F97316',
        order: 3,
      ),

      // 3. Doğa, Renkler & Boyut Laboratuvarı (4-6 Yaş)
      Module(
        id: 'mod_balance_scale',
        curriculumId: 'curr_nature_science',
        title: 'Ağır mı Hafif mi? Denge Terazisi',
        description: 'Teraziye bakarak hangi nesnenin daha ağır olduğunu tahmin et.',
        icon: '⚖️',
        colorHex: '#0EA5E9',
        order: 1,
      ),
      Module(
        id: 'mod_habitat_sort',
        curriculumId: 'curr_nature_science',
        title: 'Kim Nerede Yaşar? (Doğa Bilgisi)',
        description: 'Hayvanları deniz, orman ve çöl yaşam alanlarına yerleştir.',
        icon: '🐠',
        colorHex: '#14B8A6',
        order: 2,
      ),
      Module(
        id: 'mod_size_ordering',
        curriculumId: 'curr_nature_science',
        title: 'Küçükten Büyüğe Boyut Sıralaması',
        description: 'Nesneleri küçükten büyüğe sırasıyla diz.',
        icon: '📏',
        colorHex: '#A855F7',
        order: 3,
      ),
      Module(
        id: 'mod_color_mixing',
        curriculumId: 'curr_nature_science',
        title: 'Sihirli Renk Laboratuvarı',
        description: 'İki rengi karıştırarak hedef sihirli rengi elde et.',
        icon: '🧪',
        colorHex: '#6366F1',
        order: 4,
      ),

      // Temel Sayma
      Module(
        id: 'mod_count_1_5',
        curriculumId: 'curr_3_5_math',
        title: '1’den 5’e Nesneleri Sayalım',
        description: 'Meyveleri sepete taşıyıp sayma pratiği yapalım.',
        icon: '🍎',
        colorHex: '#F59E0B',
        order: 1,
      ),

      // 6-8 Modülleri
      Module(
        id: 'mod_add_sub_quest',
        curriculumId: 'curr_6_8_math',
        title: 'Hazine Sandığı: Toplama & Çıkarma',
        description: 'Gizli sandığın şifresini çözmek için sayıları toplayalım ve çıkaralım.',
        icon: '🪙',
        colorHex: '#10B981',
        order: 1,
      ),
      Module(
        id: 'mod_robot_navigator',
        curriculumId: 'curr_6_8_stem',
        title: 'Robotu Hedefe Yönlendir',
        description: 'İleri, sağa, zıpla komut bloklarıyla robotu yıldıza ulaştır.',
        icon: '🤖',
        colorHex: '#3B82F6',
        order: 1,
      ),

      // 9-12 Modülleri
      Module(
        id: 'mod_algorithm_loops',
        curriculumId: 'curr_9_12_stem',
        title: 'Döngüler ve Algoritma Optimizasyonu',
        description: 'Tekrar eden adımları döngü blokları ile optimize et.',
        icon: '🔁',
        colorHex: '#6366F1',
        order: 1,
      ),
      Module(
        id: 'mod_space_science',
        curriculumId: 'curr_9_12_sci',
        title: 'Güneş Sistemi & Gezegenler',
        description: 'Gezegenlerin özellikleri ve uzay kâşifliği üzerine bilimsel meydan okuma.',
        icon: '🪐',
        colorHex: '#8B5CF6',
        order: 1,
      ),

      // Yeni Zorlayıcı Modüller
      Module(
        id: 'mod_math_challenge',
        curriculumId: 'curr_6_8_math',
        title: 'Hızlı İşlem & Matematik Yarışı',
        description: 'Zamana ve seviyeye karşı hızlı zihinden işlemler yap.',
        icon: '🧮',
        colorHex: '#F59E0B',
        order: 2,
      ),
      Module(
        id: 'mod_tangram_puzzle',
        curriculumId: 'curr_algorithm_maze',
        title: 'Tangram & Geometrik Şekil Yapbozu',
        description: 'Geometrik parçaları doğru yuvalara yerleştirip şekilleri tamamla.',
        icon: '🧩',
        colorHex: '#6366F1',
        order: 4,
      ),
      Module(
        id: 'mod_matrix_logic',
        curriculumId: 'curr_algorithm_maze',
        title: 'Mantık Matrisi & Mini Sudoku',
        description: 'Satır ve sütunlarda çakışma olmadan mantık ızgarasını doldur.',
        icon: '🔢',
        colorHex: '#0D9488',
        order: 5,
      ),
      Module(
        id: 'mod_spot_difference',
        curriculumId: 'curr_algorithm_maze',
        title: 'Görsel Fark Bulma Dedektifi',
        description: 'İki görsel arasındaki gizli ince farkları yakala.',
        icon: '🔍',
        colorHex: '#F43F5E',
        order: 6,
      ),
    ];

    return allModules.where((m) => m.curriculumId == curriculumId).toList();
  }

  static List<Lesson> getLessons(String moduleId) {
    final allLessons = [
      // 1. OYUN: Hafıza Kartları
      Lesson(
        id: 'les_memory_animals',
        moduleId: 'mod_memory_cards',
        curriculumId: 'curr_memory_brain',
        title: 'Sevimli Hayvanlar Eşleşmesi',
        description: 'Kartları çevirerek aynı hayvanları bul!',
        estimatedDurationMinutes: 3,
        xpReward: 40,
        order: 1,
        activities: [
          Activity(
            id: 'act_mem_1',
            lessonId: 'les_memory_animals',
            title: 'Hayvan Eşleştirme',
            instruction: 'Aynı olan sevimli hayvan kartlarını sırayla aç!',
            voiceInstruction: 'Hadi aynı sevimli hayvan dostlarımızı bulalım!',
            type: ActivityType.memoryMatch,
            order: 1,
            payload: {
              'pairs': [
                {'emoji': '🐶', 'label': 'Köpek'},
                {'emoji': '🐱', 'label': 'Kedi'},
                {'emoji': '🐰', 'label': 'Tavşan'},
              ],
            },
          ),
        ],
      ),

      // 2. OYUN: Tavşanın Havuç Labirenti (Algoritma)
      Lesson(
        id: 'les_maze_rabbit',
        moduleId: 'mod_maze_rabbit',
        curriculumId: 'curr_algorithm_maze',
        title: 'Tavşanın Havuç Macerası',
        description: 'Yön komutlarıyla tavşanı havuca ulaştır.',
        estimatedDurationMinutes: 4,
        xpReward: 50,
        order: 1,
        activities: [
          Activity(
            id: 'act_maze_1',
            lessonId: 'les_maze_rabbit',
            title: 'Labirent Algoritması',
            instruction: 'Okları sıraya koy ve tavşanı havuca koştur!',
            voiceInstruction: 'Okları kullanarak tavşanı engellerin etrafından geçirip havuca ulaştır!',
            type: ActivityType.mazePath,
            order: 1,
            payload: {
              'startRow': 0,
              'startCol': 0,
              'targetRow': 2,
              'targetCol': 2,
            },
          ),
        ],
      ),

      // 3. OYUN: Gölge & Silüet Eşleştirme
      Lesson(
        id: 'les_shadow_safari',
        moduleId: 'mod_shadow_match',
        curriculumId: 'curr_algorithm_maze',
        title: 'Gölge Dedektifliği',
        description: 'Karanlık silüetin kime ait olduğunu tahmin et.',
        estimatedDurationMinutes: 3,
        xpReward: 40,
        order: 1,
        activities: [
          Activity(
            id: 'act_shadow_1',
            lessonId: 'les_shadow_safari',
            title: 'Fil Silüeti',
            instruction: 'Bu devasa gölge hangi hayvana ait?',
            voiceInstruction: 'Bu sevimli gölge hangi hayvanın gölgesi?',
            type: ActivityType.shadowMatch,
            order: 1,
            payload: {
              'targetEmoji': '🐘',
              'targetName': 'Fil',
              'options': ['🐘', '🦒', '🦁', '🐻'],
            },
          ),
        ],
      ),

      // 4. OYUN: Sıralı Işıklar & Renk Hafızası (Simon)
      Lesson(
        id: 'les_simon_lights',
        moduleId: 'mod_simon_lights',
        curriculumId: 'curr_memory_brain',
        title: 'Sihirli Işık Dizilimi',
        description: 'Yanan renkleri aklında tut ve aynı sırayla bas.',
        estimatedDurationMinutes: 3,
        xpReward: 45,
        order: 1,
        activities: [
          Activity(
            id: 'act_simon_1',
            lessonId: 'les_simon_lights',
            title: '3 Adımlı Renk Hafızası',
            instruction: 'Işıkları dikkatle izle, sonra sırayla dokun!',
            voiceInstruction: 'Yanan renkleri iyi izle, sonra sırasıyla bas!',
            type: ActivityType.simonSequence,
            order: 1,
            payload: {
              'sequence': [0, 2, 1], // Kırmızı, Sarı, Mavi
            },
          ),
        ],
      ),

      // 5. OYUN: Ağır mı Hafif mi? Denge Terazisi
      Lesson(
        id: 'les_scale_heavy',
        moduleId: 'mod_balance_scale',
        curriculumId: 'curr_nature_science',
        title: 'Denge Terazisi ile Tartalım',
        description: 'Hangi nesnenin daha ağır olduğunu bul.',
        estimatedDurationMinutes: 3,
        xpReward: 40,
        order: 1,
        activities: [
          Activity(
            id: 'act_scale_1',
            lessonId: 'les_scale_heavy',
            title: 'Ağır Olanı Seç',
            instruction: 'Hangisi daha AĞIRdır? ⚖️',
            voiceInstruction: 'Sence fil mi daha ağır, yoksa elma mı?',
            type: ActivityType.balanceScale,
            order: 1,
            payload: {
              'question': 'Hangisi daha AĞIR? ⚖️',
              'targetHeavy': true,
              'leftItem': {'emoji': '🐘', 'name': 'Fil', 'weight': 100},
              'rightItem': {'emoji': '🍎', 'name': 'Elma', 'weight': 1},
            },
          ),
        ],
      ),

      // 6. OYUN: Farklı Olanı Bul (Sınıflandırma Mantığı)
      Lesson(
        id: 'les_odd_finder',
        moduleId: 'mod_odd_one_out',
        curriculumId: 'curr_algorithm_maze',
        title: 'Farklı Nesneyi Yakala',
        description: 'Grup mantığına uymayan nesneyi bul.',
        estimatedDurationMinutes: 3,
        xpReward: 40,
        order: 1,
        activities: [
          Activity(
            id: 'act_odd_1',
            lessonId: 'les_odd_finder',
            title: 'Meyveler Arasında Farklı Olan',
            instruction: 'Meyveler arasında uymayan farklı nesneyi seç!',
            voiceInstruction: 'Buradaki nesnelerden hangisi diğerlerinden farklı?',
            type: ActivityType.oddOneOut,
            order: 1,
            payload: {
              'hint': 'Meyveler arasında uymayan farklı nesneyi bul! 🔍',
              'items': [
                {'emoji': '🍎', 'label': 'Elma', 'isOdd': false},
                {'emoji': '🍌', 'label': 'Muz', 'isOdd': false},
                {'emoji': '🚗', 'label': 'Araba', 'isOdd': true},
                {'emoji': '🍇', 'label': 'Üzüm', 'isOdd': false},
              ],
            },
          ),
        ],
      ),

      // 7. OYUN: Müzik & Ritim Taklidi
      Lesson(
        id: 'les_rhythm_music',
        moduleId: 'mod_rhythm_repeat',
        curriculumId: 'curr_memory_brain',
        title: 'Sevimli Ritim Orkestrası',
        description: 'Çalınan ritmi dinle ve aynısını tekrar et.',
        estimatedDurationMinutes: 3,
        xpReward: 45,
        order: 1,
        activities: [
          Activity(
            id: 'act_rhythm_1',
            lessonId: 'les_rhythm_music',
            title: 'Davul ve Piyano Ritmi',
            instruction: 'Çalınan müzik sırasını aynı şekilde tekrar et!',
            voiceInstruction: 'Enstrümanların ritmini dinle ve aynısını çal!',
            type: ActivityType.rhythmRepeat,
            order: 1,
            payload: {
              'rhythm': [0, 1, 0, 2], // Davul, Piyano, Davul, Gitar
            },
          ),
        ],
      ),

      // 8. OYUN: Kim Nerede Yaşar? Yaşam Alanı
      Lesson(
        id: 'les_habitat_nature',
        moduleId: 'mod_habitat_sort',
        curriculumId: 'curr_nature_science',
        title: 'Doğadaki Evler',
        description: 'Canlıları ait oldukları yaşam alanlarına yerleştir.',
        estimatedDurationMinutes: 3,
        xpReward: 40,
        order: 1,
        activities: [
          Activity(
            id: 'act_habitat_1',
            lessonId: 'les_habitat_nature',
            title: 'Balığın Evi',
            instruction: 'Palyaço Balığı nerede yaşar?',
            voiceInstruction: 'Sevimli balığımız nerede yaşar?',
            type: ActivityType.habitatSort,
            order: 1,
            payload: {
              'creatureEmoji': '🐠',
              'creatureName': 'Palyaço Balığı',
              'correctHabitat': 'SEA',
              'habitats': [
                {'id': 'SEA', 'emoji': '🌊', 'name': 'Deniz'},
                {'id': 'FOREST', 'emoji': '🌲', 'name': 'Orman'},
                {'id': 'DESERT', 'emoji': '🏜️', 'name': 'Çöl'},
              ],
            },
          ),
        ],
      ),

      // 9. OYUN: Küçükten Büyüğe Boyut Dizilimi
      Lesson(
        id: 'les_size_ordering',
        moduleId: 'mod_size_ordering',
        curriculumId: 'curr_nature_science',
        title: 'Boyut Sıralama Oyunu',
        description: 'Sevimli ayıcıkları küçükten büyüğe doğru seç.',
        estimatedDurationMinutes: 3,
        xpReward: 40,
        order: 1,
        activities: [
          Activity(
            id: 'act_size_1',
            lessonId: 'les_size_ordering',
            title: 'Ayıcıkları Sırala',
            instruction: 'En KÜÇÜKTEN en BÜYÜĞE sırayla dokun!',
            voiceInstruction: 'En küçük ayıdan başlayıp en büyük ayıya doğru sırayla dokun!',
            type: ActivityType.sizeOrder,
            order: 1,
            payload: {
              'items': [
                {'size': 1, 'emoji': '🐻', 'fontSize': 32.0, 'label': 'Küçük'},
                {'size': 2, 'emoji': '🐻', 'fontSize': 48.0, 'label': 'Orta'},
                {'size': 3, 'emoji': '🐻', 'fontSize': 64.0, 'label': 'Büyük'},
              ],
            },
          ),
        ],
      ),

      // 10. OYUN: Sihirli Renk Karıştırma Laboratuvarı
      Lesson(
        id: 'les_color_mixing',
        moduleId: 'mod_color_mixing',
        curriculumId: 'curr_nature_science',
        title: 'Renk Karıştırma İksiri',
        description: 'İki rengi birleştirerek yeni bir renk keşfet.',
        estimatedDurationMinutes: 3,
        xpReward: 45,
        order: 1,
        activities: [
          Activity(
            id: 'act_color_1',
            lessonId: 'les_color_mixing',
            title: 'Mor Rengi Oluştur',
            instruction: 'Hangi 2 rengi karıştırırsak MOR olur?',
            voiceInstruction: 'Kırmızı, mavi ve sarıdan hangilerini karıştırırsak mor renk olur?',
            type: ActivityType.colorMix,
            order: 1,
            payload: {
              'targetColorName': 'Mor',
              'targetColorEmoji': '🟣',
              'requiredColor1': 'RED',
              'requiredColor2': 'BLUE',
            },
          ),
        ],
      ),

      // Sayma Dersi
      Lesson(
        id: 'les_count_apples',
        moduleId: 'mod_count_1_5',
        curriculumId: 'curr_3_5_math',
        title: '3 Kırmızı Elmayı Sepete Koy!',
        description: 'Ağaçtaki elmaları tek tek sayıp sepete taşıyalım.',
        estimatedDurationMinutes: 3,
        xpReward: 30,
        order: 1,
        difficultyLevel: 'beginner',
        activities: [
          Activity(
            id: 'act_count_1',
            lessonId: 'les_count_apples',
            title: 'Elmaları Sepete Sürükle',
            instruction: 'Tam 3 elmayı sepete bırak!',
            voiceInstruction: 'Hadi tam üç tane elmayı sepete taşıyalım!',
            type: ActivityType.countingDragDrop,
            order: 1,
            payload: {
              'targetCount': 3,
              'itemEmoji': '🍎',
              'itemName': 'Elma',
              'totalAvailable': 5,
            },
          ),
        ],
      ),

      // 6-8 Matematik Hazine Sandığı
      Lesson(
        id: 'les_treasure_math',
        moduleId: 'mod_add_sub_quest',
        curriculumId: 'curr_6_8_math',
        title: 'Hazine Sandığının Şifresi',
        description: 'Toplama işlemlerini yaparak gizli sandığı aç.',
        estimatedDurationMinutes: 5,
        xpReward: 50,
        order: 1,
        difficultyLevel: 'intermediate',
        activities: [
          Activity(
            id: 'act_math_quiz_1',
            lessonId: 'les_treasure_math',
            title: 'Hazine Toplama Sorusu',
            instruction: 'Sandık kilidi için hesapla: 7 + 5 = ?',
            type: ActivityType.scienceQuiz,
            order: 1,
            payload: {
              'question': 'Korsan haritasındaki şifre: 7 + 5 = ?',
              'options': ['11', '12', '13', '14'],
              'correctIndex': 1,
              'explanation': 'Harika! 7 + 5 = 12 eder ve sandık kilidi açıldı!',
            },
          ),
        ],
      ),

      // 6-8 Robot Kodlama
      Lesson(
        id: 'les_robot_code_step1',
        moduleId: 'mod_robot_navigator',
        curriculumId: 'curr_6_8_stem',
        title: 'Robot Bobo’yu Yıldıza Ulaştır',
        description: 'Komut bloklarını sıraya koyup robotu çalıştır.',
        estimatedDurationMinutes: 5,
        xpReward: 60,
        order: 1,
        difficultyLevel: 'intermediate',
        activities: [
          Activity(
            id: 'act_code_1',
            lessonId: 'les_robot_code_step1',
            title: 'Algoritmik Blok Dizilimi',
            instruction: 'Robotu 2 adım ileri ve 1 kez zıplatıp yıldıza ulaştır!',
            type: ActivityType.codeSequence,
            order: 1,
            payload: {
              'gridWidth': 4,
              'robotStart': 0,
              'targetPosition': 2,
              'requiredSequence': ['FORWARD', 'JUMP', 'FORWARD'],
              'availableBlocks': [
                {'id': 'FORWARD', 'label': 'İleri Git ➡️'},
                {'id': 'JUMP', 'label': 'Zıpla 🦘'},
                {'id': 'TURN_LEFT', 'label': 'Dön 🔄'},
              ],
            },
          ),
        ],
      ),

      // 9-12 Algoritma Döngüleri
      Lesson(
        id: 'les_loops_9_12',
        moduleId: 'mod_algorithm_loops',
        curriculumId: 'curr_9_12_stem',
        title: 'Döngü Optimizasyonu (Loops)',
        description: 'Tekrar eden adımları döngü bloğuyla kısalt.',
        estimatedDurationMinutes: 8,
        xpReward: 80,
        order: 1,
        difficultyLevel: 'advanced',
        activities: [
          Activity(
            id: 'act_code_loop_1',
            lessonId: 'les_loops_9_12',
            title: '4 Kez Tekrarla Döngüsü',
            instruction: 'Drone’u enerji kristaline ulaştırmak için döngü oluştur.',
            type: ActivityType.codeSequence,
            order: 1,
            payload: {
              'gridWidth': 5,
              'robotStart': 0,
              'targetPosition': 4,
              'requiredSequence': ['REPEAT_4_FORWARD'],
              'availableBlocks': [
                {'id': 'REPEAT_4_FORWARD', 'label': '🔁 4 Kez (İleri)'},
                {'id': 'FORWARD', 'label': '➡️ 1 Adım İleri'},
                {'id': 'SHIELD', 'label': '🛡️ Kalkan Aç'},
              ],
            },
          ),
        ],
      ),

      // 9-12 Uzay Bilimleri
      Lesson(
        id: 'les_space_solar',
        moduleId: 'mod_space_science',
        curriculumId: 'curr_9_12_sci',
        title: 'Güneş Sistemi & Gezegenler',
        description: 'Kızıl Gezegen ve gaz devlerinin gizemini çöz.',
        estimatedDurationMinutes: 6,
        xpReward: 70,
        order: 1,
        difficultyLevel: 'advanced',
        activities: [
          Activity(
            id: 'act_space_quiz_1',
            lessonId: 'les_space_solar',
            title: 'Kızıl Gezegen',
            instruction: 'Demir oksit nedeniyle kızıl görünen gezegen hangisidir?',
            type: ActivityType.scienceQuiz,
            order: 1,
            payload: {
              'question': 'Güneş sistemimizde "Kızıl Gezegen" olarak bilinen gezegen hangisidir?',
              'options': ['Venüs', 'Mars', 'Jüpiter', 'Merkür'],
              'correctIndex': 1,
              'explanation': 'Tebrikler! Mars, toprağındaki paslı minerallerden ötürü kızıl görünür.',
            },
          ),
        ],
      ),
      // Yeni 1: Hızlı İşlem & Matematik Yarışı
      Lesson(
        id: 'les_math_challenge',
        moduleId: 'mod_math_challenge',
        curriculumId: 'curr_6_8_math',
        title: 'Hızlı Matematik & İşlem Yarışı',
        description: 'Zamana ve seviyeye karşı hızlı zihinden işlemler yap.',
        estimatedDurationMinutes: 5,
        xpReward: 60,
        order: 1,
        difficultyLevel: 'intermediate',
        activities: [
          Activity(
            id: 'act_math_chal_1',
            lessonId: 'les_math_challenge',
            title: 'İşlem Yarışı',
            instruction: 'Doğru sonucu bul ve hızla işaretle!',
            type: ActivityType.mathChallenge,
            order: 1,
            payload: {'level': 1},
          ),
        ],
      ),

      // Yeni 2: Tangram & Geometrik Şekil Yapbozu
      Lesson(
        id: 'les_tangram_puzzle',
        moduleId: 'mod_tangram_puzzle',
        curriculumId: 'curr_algorithm_maze',
        title: 'Tangram & Geometrik Şekil Yapbozu',
        description: 'Geometrik parçaları doğru yuvalara yerleştirip şekilleri tamamla.',
        estimatedDurationMinutes: 5,
        xpReward: 60,
        order: 1,
        difficultyLevel: 'intermediate',
        activities: [
          Activity(
            id: 'act_tangram_1',
            lessonId: 'les_tangram_puzzle',
            title: 'Şekil Yuvaları',
            instruction: 'Parçaları doğru yuvalara taşı!',
            type: ActivityType.tangramPuzzle,
            order: 1,
            payload: {'level': 1},
          ),
        ],
      ),

      // Yeni 3: Mantık Matrisi & Mini Sudoku
      Lesson(
        id: 'les_matrix_logic',
        moduleId: 'mod_matrix_logic',
        curriculumId: 'curr_algorithm_maze',
        title: 'Mantık Matrisi & Mini Sudoku',
        description: 'Satır ve sütunlarda çakışma olmadan mantık ızgarasını doldur.',
        estimatedDurationMinutes: 5,
        xpReward: 60,
        order: 1,
        difficultyLevel: 'intermediate',
        activities: [
          Activity(
            id: 'act_matrix_1',
            lessonId: 'les_matrix_logic',
            title: 'Mantık Izgarası',
            instruction: 'Eksik sembolleri satır ve sütun kuralına göre tamamla!',
            type: ActivityType.matrixLogic,
            order: 1,
            payload: {'level': 1},
          ),
        ],
      ),

      // Yeni 4: Görsel Fark Bulma Dedektifi
      Lesson(
        id: 'les_spot_difference',
        moduleId: 'mod_spot_difference',
        curriculumId: 'curr_algorithm_maze',
        title: 'Görsel Fark Bulma Dedektifi',
        description: 'İki görsel arasındaki gizli ince farkları yakala.',
        estimatedDurationMinutes: 5,
        xpReward: 60,
        order: 1,
        difficultyLevel: 'intermediate',
        activities: [
          Activity(
            id: 'act_spot_diff_1',
            lessonId: 'les_spot_difference',
            title: 'Fark Dedektifi',
            instruction: 'İki resim arasındaki farkları bulup tıkla!',
            type: ActivityType.spotDifference,
            order: 1,
            payload: {'level': 1},
          ),
        ],
      ),
    ];

    return allLessons.where((l) => l.moduleId == moduleId).toList();
  }

  static Lesson? getLessonById(String lessonId) {
    final modules = [
      'mod_memory_cards',
      'mod_simon_lights',
      'mod_rhythm_repeat',
      'mod_maze_rabbit',
      'mod_shadow_match',
      'mod_odd_one_out',
      'mod_balance_scale',
      'mod_habitat_sort',
      'mod_size_ordering',
      'mod_color_mixing',
      'mod_count_1_5',
      'mod_add_sub_quest',
      'mod_robot_navigator',
      'mod_algorithm_loops',
      'mod_space_science',
      'mod_math_challenge',
      'mod_tangram_puzzle',
      'mod_matrix_logic',
      'mod_spot_difference',
    ];

    for (final module in modules) {
      final lessons = getLessons(module);
      for (final l in lessons) {
        if (l.id == lessonId) return l;
      }
    }
    return null;
  }

  static List<GameItem> getAllCategorizedGames() {
    return [
      // 🧮 MATEMATİK
      GameItem(
        id: 'game_math_challenge',
        title: 'Hızlı Matematik',
        description: 'Zamana karşı 4 işlem ve eksik sayı bulma.',
        icon: '🧮',
        categoryId: 'math',
        categoryName: 'Matematik',
        primaryColor: const Color(0xFFF59E0B),
        gradientColors: const [Color(0xFFFBBF24), Color(0xFFF59E0B)],
        maxLevels: 4,
        module: getModules('curr_6_8_math').firstWhere((m) => m.id == 'mod_math_challenge'),
        lesson: getLessons('mod_math_challenge').first,
      ),
      GameItem(
        id: 'game_counting',
        title: 'Meyve Sayma',
        description: 'Meyveleri sepete taşı ve sayıları eşleştir.',
        icon: '🍎',
        categoryId: 'math',
        categoryName: 'Matematik',
        primaryColor: const Color(0xFF10B981),
        gradientColors: const [Color(0xFF34D399), Color(0xFF10B981)],
        maxLevels: 3,
        module: getModules('curr_3_5_math').firstWhere((m) => m.id == 'mod_count_1_5'),
        lesson: getLessons('mod_count_1_5').first,
      ),
      GameItem(
        id: 'game_size_order',
        title: 'Boyut Sıralama',
        description: 'Nesneleri küçükten büyüğe sırasıyla diz.',
        icon: '📏',
        categoryId: 'math',
        categoryName: 'Matematik',
        primaryColor: const Color(0xFFA855F7),
        gradientColors: const [Color(0xFFC084FC), Color(0xFFA855F7)],
        maxLevels: 3,
        module: getModules('curr_nature_science').firstWhere((m) => m.id == 'mod_size_ordering'),
        lesson: getLessons('mod_size_ordering').first,
      ),
      GameItem(
        id: 'game_balance_scale',
        title: 'Denge Terazisi',
        description: 'Ağır ve hafif nesneleri teraziyle karşılaştır.',
        icon: '⚖️',
        categoryId: 'math',
        categoryName: 'Matematik',
        primaryColor: const Color(0xFF0EA5E9),
        gradientColors: const [Color(0xFF38BDF8), Color(0xFF0EA5E9)],
        maxLevels: 3,
        module: getModules('curr_nature_science').firstWhere((m) => m.id == 'mod_balance_scale'),
        lesson: getLessons('mod_balance_scale').first,
      ),

      // 👁️ GÖRSEL ALGI
      GameItem(
        id: 'game_tangram',
        title: 'Tangram Yapboz',
        description: 'Geometrik parçaları yuvalarına oturt.',
        icon: '🧩',
        categoryId: 'visual',
        categoryName: 'Görsel Algı',
        primaryColor: const Color(0xFF6366F1),
        gradientColors: const [Color(0xFF818CF8), Color(0xFF6366F1)],
        maxLevels: 3,
        module: getModules('curr_algorithm_maze').firstWhere((m) => m.id == 'mod_tangram_puzzle'),
        lesson: getLessons('mod_tangram_puzzle').first,
      ),
      GameItem(
        id: 'game_spot_diff',
        title: 'Fark Bulma',
        description: 'İki görsel arasındaki gizli farkları yakala.',
        icon: '🔍',
        categoryId: 'visual',
        categoryName: 'Görsel Algı',
        primaryColor: const Color(0xFFF43F5E),
        gradientColors: const [Color(0xFFFB7185), Color(0xFFF43F5E)],
        maxLevels: 3,
        module: getModules('curr_algorithm_maze').firstWhere((m) => m.id == 'mod_spot_difference'),
        lesson: getLessons('mod_spot_difference').first,
      ),
      GameItem(
        id: 'game_shadow_match',
        title: 'Gölge Dedektifi',
        description: 'Karanlık silüetleri doğru hayvanlarla eşle.',
        icon: '🕵️‍♂️',
        categoryId: 'visual',
        categoryName: 'Görsel Algı',
        primaryColor: const Color(0xFF3B82F6),
        gradientColors: const [Color(0xFF60A5FA), Color(0xFF3B82F6)],
        maxLevels: 3,
        module: getModules('curr_algorithm_maze').firstWhere((m) => m.id == 'mod_shadow_match'),
        lesson: getLessons('mod_shadow_match').first,
      ),
      GameItem(
        id: 'game_odd_one_out',
        title: 'Farklı Olanı Bul',
        description: 'Gruba uymayan nesneyi mantıkla keşfet.',
        icon: '🔎',
        categoryId: 'visual',
        categoryName: 'Görsel Algı',
        primaryColor: const Color(0xFFF97316),
        gradientColors: const [Color(0xFFFB923C), Color(0xFFF97316)],
        maxLevels: 3,
        module: getModules('curr_algorithm_maze').firstWhere((m) => m.id == 'mod_odd_one_out'),
        lesson: getLessons('mod_odd_one_out').first,
      ),
      GameItem(
        id: 'game_color_mix',
        title: 'Renk Laboratuvarı',
        description: 'İki rengi karıştırarak yeni renkler üret.',
        icon: '🧪',
        categoryId: 'visual',
        categoryName: 'Görsel Algı',
        primaryColor: const Color(0xFF8B5CF6),
        gradientColors: const [Color(0xFFA78BFA), Color(0xFF8B5CF6)],
        maxLevels: 3,
        module: getModules('curr_nature_science').firstWhere((m) => m.id == 'mod_color_mixing'),
        lesson: getLessons('mod_color_mixing').first,
      ),

      // 🧠 HAFIZA
      GameItem(
        id: 'game_memory_cards',
        title: 'Hafıza Kartları',
        description: 'Kartları çevir, aynı hayvanları eşleştir.',
        icon: '🃏',
        categoryId: 'memory',
        categoryName: 'Hafıza',
        primaryColor: const Color(0xFFF59E0B),
        gradientColors: const [Color(0xFFFCD34D), Color(0xFFF59E0B)],
        maxLevels: 4,
        module: getModules('curr_memory_brain').firstWhere((m) => m.id == 'mod_memory_cards'),
        lesson: getLessons('mod_memory_cards').first,
      ),
      GameItem(
        id: 'game_simon_lights',
        title: 'Sıralı Işıklar',
        description: 'Yanan renk dizilerini hafızanda tutup tekrar et.',
        icon: '🎈',
        categoryId: 'memory',
        categoryName: 'Hafıza',
        primaryColor: const Color(0xFFEC4899),
        gradientColors: const [Color(0xFFF472B6), Color(0xFFEC4899)],
        maxLevels: 3,
        module: getModules('curr_memory_brain').firstWhere((m) => m.id == 'mod_simon_lights'),
        lesson: getLessons('mod_simon_lights').first,
      ),
      GameItem(
        id: 'game_rhythm_repeat',
        title: 'Ritim & Müzik',
        description: 'Çalınan ritim vuruşlarını dinle ve taklit et.',
        icon: '🥁',
        categoryId: 'memory',
        categoryName: 'Hafıza',
        primaryColor: const Color(0xFF14B8A6),
        gradientColors: const [Color(0xFF2DD4BF), Color(0xFF14B8A6)],
        maxLevels: 3,
        module: getModules('curr_memory_brain').firstWhere((m) => m.id == 'mod_rhythm_repeat'),
        lesson: getLessons('mod_rhythm_repeat').first,
      ),

      // 🚀 MANTIK & KODLAMA
      GameItem(
        id: 'game_matrix_logic',
        title: 'Mantık Matrisi',
        description: 'Mini Sudoku kurallarıyla ızgarayı çöz.',
        icon: '🔢',
        categoryId: 'logic',
        categoryName: 'Mantık & Kod',
        primaryColor: const Color(0xFF0D9488),
        gradientColors: const [Color(0xFF14B8A6), Color(0xFF0D9488)],
        maxLevels: 3,
        module: getModules('curr_algorithm_maze').firstWhere((m) => m.id == 'mod_matrix_logic'),
        lesson: getLessons('mod_matrix_logic').first,
      ),
      GameItem(
        id: 'game_maze_rabbit',
        title: 'Havuç Labirenti',
        description: 'Yön komutlarıyla tavşanı hedefe ulaştır.',
        icon: '🐰',
        categoryId: 'logic',
        categoryName: 'Mantık & Kod',
        primaryColor: const Color(0xFF10B981),
        gradientColors: const [Color(0xFF34D399), Color(0xFF10B981)],
        maxLevels: 3,
        module: getModules('curr_algorithm_maze').firstWhere((m) => m.id == 'mod_maze_rabbit'),
        lesson: getLessons('mod_maze_rabbit').first,
      ),
      GameItem(
        id: 'game_robot_nav',
        title: 'Robot Kodlama',
        description: 'Komut bloklarını diz, robotu yıldıza yönlendir.',
        icon: '🤖',
        categoryId: 'logic',
        categoryName: 'Mantık & Kod',
        primaryColor: const Color(0xFF3B82F6),
        gradientColors: const [Color(0xFF60A5FA), Color(0xFF3B82F6)],
        maxLevels: 3,
        module: getModules('curr_6_8_stem').firstWhere((m) => m.id == 'mod_robot_navigator'),
        lesson: getLessons('mod_robot_navigator').first,
      ),

      // 🔬 FEN & DOĞA
      GameItem(
        id: 'game_habitat_sort',
        title: 'Yaşam Alanları',
        description: 'Hayvanları deniz, orman ve çöle yerleştir.',
        icon: '🐠',
        categoryId: 'science',
        categoryName: 'Fen & Doğa',
        primaryColor: const Color(0xFF06B6D4),
        gradientColors: const [Color(0xFF22D3EE), Color(0xFF06B6D4)],
        maxLevels: 3,
        module: getModules('curr_nature_science').firstWhere((m) => m.id == 'mod_habitat_sort'),
        lesson: getLessons('mod_habitat_sort').first,
      ),
      GameItem(
        id: 'game_space_sci',
        title: 'Uzay Bilimleri',
        description: 'Gezegenlerin gizemini çözen bilimsel test.',
        icon: '🪐',
        categoryId: 'science',
        categoryName: 'Fen & Doğa',
        primaryColor: const Color(0xFF8B5CF6),
        gradientColors: const [Color(0xFFA78BFA), Color(0xFF8B5CF6)],
        maxLevels: 3,
        module: getModules('curr_9_12_sci').firstWhere((m) => m.id == 'mod_space_science'),
        lesson: getLessons('mod_space_science').first,
      ),
    ];
  }
}
