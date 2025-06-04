import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../logic/providers/character_provider.dart';
import '../widgets/character_card.dart';

class CharacterListScreen extends StatefulWidget {
  const CharacterListScreen({super.key});

  @override
  State<CharacterListScreen> createState() => _CharacterListScreenState();
}

class _CharacterListScreenState extends State<CharacterListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CharacterProvider>().loadCharacters();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFE6F4F9),
        title: const Text(
          '💬 대화를 원하는 멍탐정을 선택해주세요',
          style: TextStyle(fontSize: 14, color: Colors.black),
        ),
        centerTitle: false,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      backgroundColor: const Color(0xFFE6F4F9),
      body: Consumer<CharacterProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: provider.characters.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.9,
            ),
            itemBuilder: (context, index) {
              final character = provider.characters[index];
              return CharacterCard(
                character: character,
                onTap: () {
                  context.read<CharacterProvider>().selectCharacter(character);
                  context.go('/character-detail', extra: character);
                },
              );
            },
          );
        },
      ),
    );
  }
}
