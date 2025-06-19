// features/phishing/presentation/screens/simulation_main_screen.dart
import 'package:flutter/material.dart';
import 'package:meongtamjeong/core/services/phishing_services/phishing_simulation_service.dart';
import 'package:meongtamjeong/features/phishing/logic/model/phishing_category_model.dart';
import 'package:meongtamjeong/features/phishing/logic/model/phishing_case_model.dart';
import 'package:meongtamjeong/features/phishing/presentation/widgets_simulation/simulation_category_selector.dart';
import 'package:meongtamjeong/features/phishing/presentation/widgets_simulation/simulation_message_bubble.dart';

class SimulationMainScreen extends StatefulWidget {
  final VoidCallback onBack;

  const SimulationMainScreen({super.key, required this.onBack});

  @override
  State<SimulationMainScreen> createState() => _SimulationMainScreenState();
}

class _SimulationMainScreenState extends State<SimulationMainScreen> {
  bool _hasCategorySelected = false;
  PhishingCategory? _selectedCategory;
  List<_SimulationMessage> messages = [];

  List<PhishingCase> _cases = [];
  bool _isLoadingCases = true;

  void _handleCategorySelected(PhishingCategory category) async {
    setState(() {
      _hasCategorySelected = true;
      _selectedCategory = category;
      _isLoadingCases = true;

      messages.add(
        _SimulationMessage(
          text: '"${category.description}" 시뮬레이션을 시작합니다!',
          isUser: false,
        ),
      );
    });

    try {
      final cases = await PhishingSimulationService().fetchCasesByCategory(
        category.code.name,
      );
      setState(() {
        _cases = cases;
        _isLoadingCases = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingCases = false;
      });
      messages.add(_SimulationMessage(text: '❌ 사례 목록 불러오기 실패', isUser: false));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('피싱 시뮬레이션'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: widget.onBack,
        ),
      ),
      body:
          _hasCategorySelected
              ? _buildChatScreen()
              : SimulationCategorySelector(
                onCategorySelected: _handleCategorySelected,
              ),
    );
  }

  Widget _buildChatScreen() {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 16),
            itemCount: messages.length,
            itemBuilder: (context, index) {
              final msg = messages[index];
              return SimulationMessageBubble(
                text: msg.text,
                isUser: msg.isUser,
                botName: '시뮬봇',
                botImagePath: 'assets/images/characters/example_meong.png',
              );
            },
          ),
        ),
        if (_isLoadingCases)
          const Padding(
            padding: EdgeInsets.all(16),
            child: CircularProgressIndicator(),
          )
        else
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Wrap(
              spacing: 10,
              runSpacing: 10,
              children:
                  _cases.map((c) {
                    return ElevatedButton(
                      onPressed: () {
                        setState(() {
                          messages.add(
                            _SimulationMessage(text: c.title, isUser: true),
                          );
                          // TODO: 이후 /cases/{id}로부터 대화 시뮬레이션 불러오기
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                          side: const BorderSide(color: Colors.black12),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                        elevation: 0,
                        textStyle: const TextStyle(fontSize: 16),
                      ),
                      child: Text(c.title),
                    );
                  }).toList(),
            ),
          ),
      ],
    );
  }
}

class _SimulationMessage {
  final String text;
  final bool isUser;

  _SimulationMessage({required this.text, required this.isUser});
}
