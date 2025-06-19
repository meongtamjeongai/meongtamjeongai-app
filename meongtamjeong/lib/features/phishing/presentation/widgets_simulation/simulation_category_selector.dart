// features/phishing/presentation/widgets_simulation/simulation_category_selector.dart
import 'package:flutter/material.dart';
import 'package:meongtamjeong/core/services/phishing_services/phishing_simulation_service.dart';
import 'package:meongtamjeong/features/phishing/logic/model/phishing_category_model.dart';

class SimulationCategorySelector extends StatefulWidget {
  final void Function(PhishingCategory selected) onCategorySelected;

  const SimulationCategorySelector({
    super.key,
    required this.onCategorySelected,
  });

  @override
  State<SimulationCategorySelector> createState() =>
      _SimulationCategorySelectorState();
}

class _SimulationCategorySelectorState
    extends State<SimulationCategorySelector> {
  late Future<List<PhishingCategory>> _categoriesFuture;

  @override
  void initState() {
    super.initState();
    _categoriesFuture = PhishingSimulationService().fetchCategories();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<PhishingCategory>>(
      future: _categoriesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return const Center(child: Text('😥 카테고리 불러오기에 실패했어요.'));
        }

        final categories = snapshot.data!;
        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            return _buildCategoryCard(category);
          },
        );
      },
    );
  }

  Widget _buildCategoryCard(PhishingCategory category) {
    return InkWell(
      onTap: () => widget.onCategorySelected(category),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.shade300),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start, // ✅ 왼쪽 정렬로 변경
          children: [
            const Icon(Icons.security, size: 34, color: Colors.blue),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                category.description,
                style: const TextStyle(
                  fontSize: 19,
                  height: 1.5,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              size: 20,
              color: Colors.grey,
            ), // ✅ 화살표 아이콘
          ],
        ),
      ),
    );
  }
}
