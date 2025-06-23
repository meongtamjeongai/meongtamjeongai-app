import 'package:flutter/material.dart';
import 'package:meongtamjeong/core/services/phishing_simulation_service.dart';
import 'package:meongtamjeong/core/utils/phishing_label_loader.dart';
import 'package:meongtamjeong/features/phishing/presentation/widgets_simulation/simulation_message_bubble.dart';
import 'package:meongtamjeong/features/phishing/logic/model/simulation_session_model.dart';

class SimulationMainScreen extends StatefulWidget {
  final VoidCallback onBack;
  final int personaId; // ✅ 캐릭터 ID를 받는다

  const SimulationMainScreen({
    super.key,
    required this.onBack,
    required this.personaId,
  });

  @override
  State<SimulationMainScreen> createState() => _SimulationMainScreenState();
}

class _SimulationMainScreenState extends State<SimulationMainScreen> {
  final _messages = <_SimulationMessage>[];
  final _phishingService = PhishingSimulationService();

  SimulationSession? _session;
  List<String> _categoryCodes = [];
  bool _isLoading = true;
  bool _isStarted = false;

  @override
  void initState() {
    super.initState();
    _fetchInitialCategoryCodes();
  }

  Future<void> _fetchInitialCategoryCodes() async {
    try {
      final codes = await _phishingService.fetchPhishingCategoryCodes();
      setState(() {
        _categoryCodes = codes;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _categoryCodes = [];
        _isLoading = false;
      });
      _messages.add(_SimulationMessage(text: '❌ 카테고리 로드 실패', isUser: false));
    }
  }

  Future<void> _startSimulation(String code) async {
    setState(() => _isStarted = true);
    try {
      final session = await _phishingService.startSimulationWithCategory(
        categoryCode: code,
        personaId: widget.personaId, // ✅ 선택한 캐릭터 ID 사용
      );
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
        _messages.add(_SimulationMessage(text: '❌ 시뮬레이션 시작 실패', isUser: false));
      });
    }
  }

  Widget _buildInitialPrompt() {
    return Column(
      children: [
        const SizedBox(height: 40),
        const Text(
          '멍탐정이 시뮬레이션할래?',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => setState(() => _isStarted = true),
              child: const Text('예'),
            ),
            const SizedBox(width: 16),
            OutlinedButton(
              onPressed: () => widget.onBack(),
              child: const Text('아니오'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCategoryButtons() {
    return Wrap(
      spacing: 10,
      runSpacing: 12,
      children:
          _categoryCodes
              .map(
                (code) => ElevatedButton(
                  onPressed: () => _startSimulation(code),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                      side: const BorderSide(color: Colors.black26),
                    ),
                  ),
                  child: Text(PhishingLabelLoader.getLabel(code)),
                ),
              )
              .toList(),
    );
  }

  Widget _buildMessageList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _messages.length,
      itemBuilder: (context, index) {
        final msg = _messages[index];
        return SimulationMessageBubble(
          text: msg.text,
          isUser: msg.isUser,
          botName: _session?.persona.name ?? '시뮬봇',
          botImagePath: 'assets/images/characters/example_meong.png',
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : !_isStarted
              ? _buildInitialPrompt()
              : Column(
                children: [
                  Expanded(child: _buildMessageList()),
                  if (_session == null)
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: _buildCategoryButtons(),
                    ),
                ],
              ),
    );
  }
}

class _SimulationMessage {
  final String text;
  final bool isUser;

  _SimulationMessage({required this.text, required this.isUser});
}
