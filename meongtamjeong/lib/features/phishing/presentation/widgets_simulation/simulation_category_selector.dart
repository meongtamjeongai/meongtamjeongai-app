// features/phishing/presentation/widgets_simulation/simulation_category_selector.dart
import 'package:flutter/material.dart';
import 'package:meongtamjeong/core/utils/phishing_label_loader.dart';
import 'package:meongtamjeong/features/phishing/logic/model/phishing_category_model.dart';

class SimulationCategorySelector extends StatelessWidget {
  final void Function(PhishingCategory selected) onCategorySelected;

  const SimulationCategorySelector({
    super.key,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      itemCount: PhishingCategoryCode.values.length,
      itemBuilder: (context, index) {
        final code = PhishingCategoryCode.values[index];
        return _buildCategoryCard(code);
      },
    );
  }

  Widget _buildCategoryCard(PhishingCategoryCode code) {
    return InkWell(
      onTap:
          () => onCategorySelected(
            PhishingCategory.fromCode(
              code,
            ), // PhishingCategoryCode → PhishingCategory로 변환
          ),
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
          children: [
            const Icon(Icons.security, size: 34, color: Colors.blue),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                _getCategoryLabel(code),
                style: const TextStyle(
                  fontSize: 19,
                  height: 1.5,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 20, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  // ✅ 한글 라벨 매핑
  String _getCategoryLabel(PhishingCategoryCode code) {
    return PhishingLabelLoader.getLabel(code.name);
  }
}
