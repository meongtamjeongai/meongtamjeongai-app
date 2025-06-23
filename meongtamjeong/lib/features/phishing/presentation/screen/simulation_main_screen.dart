// import 'package:flutter/material.dart';
// import 'package:meongtamjeong/core/services/phishing_simulation_service.dart';
// import 'package:meongtamjeong/features/phishing/logic/model/phishing_category_model.dart';
// import 'package:meongtamjeong/features/phishing/logic/model/simulation_session_model.dart';
// import 'package:meongtamjeong/features/phishing/presentation/widgets_simulation/simulation_category_selector.dart';
// import 'package:meongtamjeong/features/phishing/presentation/widgets_simulation/simulation_message_bubble.dart';

// class SimulationMainScreen extends StatefulWidget {
//   final VoidCallback onBack;

//   const SimulationMainScreen({super.key, required this.onBack});

//   @override
//   State<SimulationMainScreen> createState() => _SimulationMainScreenState();
// }

// class _SimulationMainScreenState extends State<SimulationMainScreen> {
//   bool _hasCategorySelected = false;
//   SimulationSession? _session;
//   PhishingCategory? _selectedCategory;

//   final List<_SimulationMessage> _messages = [];
//   final TextEditingController _controller = TextEditingController();
//   bool _isSending = false;

//   void _handleCategorySelected(PhishingCategory category) async {
//     setState(() {
//       _hasCategorySelected = true;
//       _selectedCategory = category;
//       _messages.clear();
//     });

//     try {
//       final session = await PhishingSimulationService()
//           .createConversationWithCategory(category.code.name);

//       setState(() {
//         _session = session;
//         _messages.add(
//           _SimulationMessage(
//             text: session.persona.startingMessage ?? '시뮬레이션을 시작합니다.',
//             isUser: false,
//           ),
//         );
//       });
//     } catch (e) {
//       setState(() {
//         _messages.add(
//           _SimulationMessage(text: '❌ 시뮬레이션 시작에 실패했습니다.', isUser: false),
//         );
//       });
//     }
//   }

//   Future<void> _sendMessage() async {
//     if (_controller.text.trim().isEmpty || _isSending || _session == null)
//       return;

//     final userMessage = _controller.text.trim();
//     setState(() {
//       _messages.add(_SimulationMessage(text: userMessage, isUser: true));
//       _controller.clear();
//       _isSending = true;
//     });

//     try {
//       final aiMessage = await PhishingSimulationService()
//           .sendMessageToSimulation(
//             conversationId: _session!.id,
//             message: userMessage,
//           );

//       setState(() {
//         _messages.add(_SimulationMessage(text: aiMessage, isUser: false));
//         _isSending = false;
//       });
//     } catch (e) {
//       setState(() {
//         _messages.add(_SimulationMessage(text: '❌ 메시지 전송 실패', isUser: false));
//         _isSending = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         title: const Text('피싱 시뮬레이션'),
//         backgroundColor: Colors.white,
//         foregroundColor: Colors.black,
//         elevation: 1,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back),
//           onPressed: widget.onBack,
//         ),
//       ),
//       body:
//           _hasCategorySelected ? _buildChatScreen() : _buildCategorySelector(),
//     );
//   }

//   Widget _buildCategorySelector() {
//     return SimulationCategorySelector(
//       onCategorySelected: _handleCategorySelected,
//     );
//   }

//   Widget _buildChatScreen() {
//     return Column(
//       children: [
//         Expanded(
//           child: ListView.builder(
//             padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
//             itemCount: _messages.length,
//             itemBuilder: (context, index) {
//               final msg = _messages[index];
//               return SimulationMessageBubble(
//                 text: msg.text,
//                 isUser: msg.isUser,
//                 botName: _session?.persona.name ?? '시뮬봇',
//                 botImagePath: 'assets/images/characters/example_meong.png',
//               );
//             },
//           ),
//         ),
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//           child: Row(
//             children: [
//               Expanded(
//                 child: TextField(
//                   controller: _controller,
//                   onSubmitted: (_) => _sendMessage(),
//                   decoration: InputDecoration(
//                     hintText: '메시지를 입력하세요',
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(30),
//                     ),
//                     contentPadding: const EdgeInsets.symmetric(
//                       horizontal: 16,
//                       vertical: 12,
//                     ),
//                   ),
//                 ),
//               ),
//               const SizedBox(width: 8),
//               IconButton(icon: const Icon(Icons.send), onPressed: _sendMessage),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }

// class _SimulationMessage {
//   final String text;
//   final bool isUser;

//   _SimulationMessage({required this.text, required this.isUser});
// }
// lib/features/phishing/presentation/screens/simulation_main_screen.dart
import 'package:flutter/material.dart';
import 'package:meongtamjeong/core/services/phishing_simulation_service.dart';
import 'package:meongtamjeong/features/phishing/logic/model/phishing_category_model.dart';
import 'package:meongtamjeong/features/phishing/logic/model/simulation_session_model.dart';
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
  SimulationSession? _session;
  PhishingCategory? _selectedCategory;

  final List<_SimulationMessage> _messages = [];
  final TextEditingController _controller = TextEditingController();
  bool _isSending = false;

  /// 카테고리 선택 후 세션 생성
  void _handleCategorySelected(PhishingCategory category) async {
    setState(() {
      _hasCategorySelected = true;
      _selectedCategory = category;
      _messages.clear();
    });

    try {
      final session = await PhishingSimulationService()
          .createSimulationSessionWithCategory(category.code.name);

      setState(() {
        _session = session;
        _messages.add(
          _SimulationMessage(
            text: session.persona.startingMessage ?? '시뮬레이션을 시작합니다.',
            isUser: false,
          ),
        );
      });
    } catch (e) {
      setState(() {
        _messages.add(
          _SimulationMessage(text: '❌ 시뮬레이션 시작에 실패했습니다.', isUser: false),
        );
      });
    }
  }

  /// 사용자 메시지 전송 및 응답 처리
  Future<void> _sendMessage() async {
    if (_controller.text.trim().isEmpty || _isSending || _session == null)
      return;

    final userMessage = _controller.text.trim();
    setState(() {
      _messages.add(_SimulationMessage(text: userMessage, isUser: true));
      _controller.clear();
      _isSending = true;
    });

    try {
      final aiMessage = await PhishingSimulationService()
          .sendMessageToSimulation(
            conversationId: _session!.id,
            message: userMessage,
          );

      setState(() {
        _messages.add(_SimulationMessage(text: aiMessage, isUser: false));
        _isSending = false;
      });
    } catch (e) {
      setState(() {
        _messages.add(_SimulationMessage(text: '❌ 메시지 전송 실패', isUser: false));
        _isSending = false;
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          '피싱 시뮬레이션',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: widget.onBack,
        ),
      ),
      body:
          _hasCategorySelected ? _buildChatScreen() : _buildCategorySelector(),
    );
  }

  Widget _buildCategorySelector() {
    return SimulationCategorySelector(
      onCategorySelected: _handleCategorySelected,
    );
  }

  Widget _buildChatScreen() {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            itemCount: _messages.length,
            itemBuilder: (context, index) {
              final msg = _messages[index];
              return SimulationMessageBubble(
                text: msg.text,
                isUser: msg.isUser,
                botName: _session?.persona.name ?? '멍탐정',
                botImagePath: 'assets/images/characters/example_meong.png',
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  onSubmitted: (_) => _sendMessage(),
                  decoration: InputDecoration(
                    hintText: '메시지를 입력하세요',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(icon: const Icon(Icons.send), onPressed: _sendMessage),
            ],
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
