import 'package:flutter/material.dart';
import '../models/curriculum_models.dart';
import '../services/mock_data_service.dart';
import 'level_select_dialog.dart';

class CategoryGameHub extends StatefulWidget {
  final String title;
  final String subtitle;

  const CategoryGameHub({
    super.key,
    this.title = '🎮 Eğlenceli Oyun Merkezi',
    this.subtitle = 'Kategori seç, seviyeni belirle ve yıldızları topla!',
  });

  @override
  State<CategoryGameHub> createState() => _CategoryGameHubState();
}

class _CategoryTab {
  final String id;
  final String label;
  final String emoji;
  final Color color;

  const _CategoryTab(this.id, this.label, this.emoji, this.color);
}

class _CategoryGameHubState extends State<CategoryGameHub> {
  String _selectedCategory = 'all';

  final List<_CategoryTab> _categories = const [
    _CategoryTab('all', 'Tümü', '🌟', Color(0xFF6366F1)),
    _CategoryTab('math', 'Matematik', '🧮', Color(0xFFF59E0B)),
    _CategoryTab('visual', 'Görsel Algı', '👁️', Color(0xFFEC4899)),
    _CategoryTab('memory', 'Hafıza', '🧠', Color(0xFF8B5CF6)),
    _CategoryTab('logic', 'Mantık & Kod', '🚀', Color(0xFF10B981)),
    _CategoryTab('science', 'Fen & Doğa', '🔬', Color(0xFF06B6D4)),
  ];

  @override
  Widget build(BuildContext context) {
    final allGames = MockDataService.getAllCategorizedGames();
    final filteredGames = _selectedCategory == 'all'
        ? allGames
        : allGames.where((g) => g.categoryId == _selectedCategory).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Category Horizontal Selector Pills
        SizedBox(
          height: 46,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _categories.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final cat = _categories[index];
              final isSelected = _selectedCategory == cat.id;

              return ChoiceChip(
                showCheckmark: false,
                selected: isSelected,
                onSelected: (selected) {
                  if (selected) setState(() => _selectedCategory = cat.id);
                },
                avatar: Text(cat.emoji, style: const TextStyle(fontSize: 16)),
                label: Text(
                  cat.label,
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 13,
                    color: isSelected ? Colors.white : const Color(0xFF475569),
                  ),
                ),
                backgroundColor: Colors.white,
                selectedColor: cat.color,
                elevation: isSelected ? 4 : 1,
                pressElevation: 6,
                shadowColor: cat.color.withValues(alpha: 0.3),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(
                    color: isSelected ? Colors.transparent : const Color(0xFFE2E8F0),
                    width: 1.5,
                  ),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              );
            },
          ),
        ),
        const SizedBox(height: 18),

        // Section Title & Counter
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Oyunlar (${filteredGames.length})',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
                color: Color(0xFF1E293B),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFFEF3C7),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(
                children: [
                  Text('⭐', style: TextStyle(fontSize: 12)),
                  SizedBox(width: 4),
                  Text(
                    'Seviyeli Oyunlar',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Color(0xFFB45309)),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),

        // Square Game Cards Grid (2 columns, square aspect ratio)
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 14,
            mainAxisSpacing: 14,
            childAspectRatio: 0.88, // Square-like proportion
          ),
          itemCount: filteredGames.length,
          itemBuilder: (context, index) {
            final game = filteredGames[index];
            return _buildSquareGameCard(context, game);
          },
        ),
      ],
    );
  }

  Widget _buildSquareGameCard(BuildContext context, GameItem game) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFF1F5F9), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: game.primaryColor.withValues(alpha: 0.12),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(24),
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: () {
            LevelSelectDialog.show(
              context,
              lesson: game.lesson,
              module: game.module,
              categoryName: game.categoryName,
              maxLevels: game.maxLevels,
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon Header & Level Badge
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Large Emoji Badge
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: game.gradientColors,
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: game.primaryColor.withValues(alpha: 0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        game.icon,
                        style: const TextStyle(fontSize: 28),
                      ),
                    ),

                    // Level Chip
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: game.primaryColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '⭐ ${game.maxLevels} Lvl',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                          color: game.primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
                const Spacer(),

                // Category Tag
                Text(
                  game.categoryName.toUpperCase(),
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w900,
                    color: game.primaryColor,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 2),

                // Game Title
                Text(
                  game.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF1E293B),
                    height: 1.15,
                  ),
                ),
                const SizedBox(height: 4),

                // Bottom Action Info
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Kolaydan Zora',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    Container(
                      width: 26,
                      height: 26,
                      decoration: BoxDecoration(
                        color: game.primaryColor,
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: const Icon(
                        Icons.play_arrow_rounded,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
