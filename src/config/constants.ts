export const AGE_GROUPS = {
  '3-5': {
    label: '3-5 Yaş (Okul Öncesi)',
    sublabel: 'Keşif & Duyu Dünyası',
    color: 'from-amber-400 to-orange-500',
    accentColor: 'bg-amber-500',
    borderColor: 'border-amber-400',
    mascotName: 'Tomi & Pamuk',
    mascotIcon: '🐾',
    theme: 'playful',
    description: 'Büyük butonlar, sıfır metin, neşeli sesli yönlendirmeler ve temel motor becerileri.',
  },
  '6-8': {
    label: '6-8 Yaş (Erken İlkokul)',
    sublabel: 'Macera & Kazanım Adası',
    color: 'from-emerald-400 to-teal-600',
    accentColor: 'bg-emerald-500',
    borderColor: 'border-emerald-400',
    mascotName: 'Kaptan Bilge',
    mascotIcon: '🚀',
    theme: 'adventure',
    description: 'Okuma-yazma, 4 işlem, görev haritası, çıkartma albümü ve eğlenceli bulmacalar.',
  },
  '9-12': {
    label: '9-12 Yaş (İleri İlkokul)',
    sublabel: 'Ustalık & Kodlama Üssü',
    color: 'from-indigo-500 to-purple-700',
    accentColor: 'bg-indigo-600',
    borderColor: 'border-indigo-400',
    mascotName: 'Siber Kâşif',
    mascotIcon: '⚡',
    theme: 'cyber',
    description: 'STEM, algoritmik kodlama, fen simülasyonları, kritik düşünme ve başarı vitrini.',
  },
} as const;

export const AVATAR_OPTIONS = [
  { id: 'fox', label: 'Minik Tilki', emoji: '🦊', bg: 'bg-orange-100 border-orange-300' },
  { id: 'bear', label: 'Sevimli Ayı', emoji: '🐻', bg: 'bg-amber-100 border-amber-300' },
  { id: 'panda', label: 'Bambu Panda', emoji: '🐼', bg: 'bg-emerald-100 border-emerald-300' },
  { id: 'lion', label: 'Cesur Aslan', emoji: '🦁', bg: 'bg-yellow-100 border-yellow-300' },
  { id: 'astronaut', label: 'Uzay Kâşifi', emoji: '👨‍🚀', bg: 'bg-blue-100 border-blue-300' },
  { id: 'wizard', label: 'Bilim Sihirbazı', emoji: '🧙‍♂️', bg: 'bg-purple-100 border-purple-300' },
  { id: 'robot', label: 'Dost Robot', emoji: '🤖', bg: 'bg-cyan-100 border-cyan-300' },
  { id: 'unicorn', label: 'Büyülü Tekboynuz', emoji: '🦄', bg: 'bg-pink-100 border-pink-300' },
];

export const SYSTEM_BADGES = [
  {
    badgeId: 'first_lesson',
    title: 'İlk Adım Kâşifi',
    description: 'İlk dersini başarıyla tamamladın!',
    icon: '🌟',
    category: 'explorer' as const,
  },
  {
    badgeId: 'streak_3',
    title: '3 Günlük Alev',
    description: 'Üst üste 3 gün öğrenmeye devam ettin!',
    icon: '🔥',
    category: 'streak' as const,
  },
  {
    badgeId: 'math_wizard',
    title: 'Sayılar Büyücüsü',
    description: 'Matematik derslerinde 3 yıldız kazandın!',
    icon: '🧮',
    category: 'math' as const,
  },
  {
    badgeId: 'word_master',
    title: 'Kelime Ustası',
    description: 'Dil ve okuma görevlerini kusursuz tamamladın!',
    icon: '📚',
    category: 'reading' as const,
  },
  {
    badgeId: 'coder_junior',
    title: 'Geleceğin Kodlayıcısı',
    description: 'Algoritma ve blok kodlama bulmacasını çözdün!',
    icon: '💻',
    category: 'stem' as const,
  },
  {
    badgeId: 'heart_friend',
    title: 'Duygu Dedektifi',
    description: 'Sosyo-duygusal empati görevlerini tamamladın!',
    icon: '💖',
    category: 'mastery' as const,
  },
];

export const OFFLINE_ACTIVITY_SUGGESTIONS: Record<string, string[]> = {
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
