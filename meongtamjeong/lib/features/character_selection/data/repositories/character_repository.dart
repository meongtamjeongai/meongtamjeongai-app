import 'package:meongtamjeong/features/character_selection/logic/models/character_model.dart';

class CharacterRepository {
  // 실제로는 API에서 가져오거나 로컬 데이터베이스에서 가져올 수 있음
  List<CharacterModel> getCharacters() {
    return [
      CharacterModel(
        id: 'detective_1',
        name: '멍탐정',
        personality: '사랑스러움',
        specialty: '애교',
        description: '친근하고 따뜻한 성격의 탐정이에요. 어려운 상황에서도 차분하게 도와드립니다.',
        imagePath: 'assets/images/characters/detective_main.png',
        conversationExamples: [
          '안녕하세요~~ 혜혜',
          '잘 지냈어?',
          '아니요ㅋㅋㅋ',
          '보고싶어서 잘 못지냈어요',
        ],
        greeting: '안녕하세요~~ 혜혜',
      ),
      CharacterModel(
        id: 'detective_2',
        name: '진돗개 탐정',
        personality: '총명함',
        specialty: '사법 바라기',
        description: '정의감이 강하고 직설적인 성격의 탐정입니다.',
        imagePath: 'assets/images/characters/detective_2.png',
        conversationExamples: ['무슨 일이야?', '빨리 말해봐', '이해했어', '다음엔 조심해'],
        greeting: '무슨 일이야?',
      ),
      CharacterModel(
        id: 'detective_3',
        name: '웰시코기 탐정',
        personality: '정보수집 능력',
        specialty: '정보 수집가',
        description: '꼼꼼하고 정보 수집에 뛰어난 탐정입니다.',
        imagePath: 'assets/images/characters/detective_3.png',
        conversationExamples: [
          '자세히 설명해주세요',
          '더 많은 정보가 필요해요',
          '분석 중입니다...',
          '결과를 알려드릴게요',
        ],
        greeting: '자세히 설명해주세요',
      ),
      CharacterModel(
        id: 'detective_4',
        name: '풍산개 탐정',
        personality: '총직함',
        specialty: '사법 바라기',
        description: '용감하고 정의로운 성격의 탐정입니다.',
        imagePath: 'assets/images/characters/detective_4.png',
        conversationExamples: [
          '걱정하지 마세요',
          '제가 도와드릴게요',
          '안전이 최우선이에요',
          '함께 해결해요',
        ],
        greeting: '걱정하지 마세요',
      ),
      CharacterModel(
        id: 'detective_5',
        name: '치와와 탐정',
        personality: '정보수집',
        specialty: '정보 수집가',
        description: '차분하고 분석적인 성격의 탐정입니다.',
        imagePath: 'assets/images/characters/detective_5.png',
        conversationExamples: [
          '천천히 말씀해주세요',
          '차근차근 살펴봅시다',
          '이런 경우가 있었어요',
          '예방이 중요해요',
        ],
        greeting: '천천히 말씀해주세요',
      ),
      CharacterModel(
        id: 'detective_6',
        name: '진돗개 탐정',
        personality: '총직함',
        specialty: '사법 바라기',
        description: '똑똑하고 논리적인 성격의 탐정입니다.',
        imagePath: 'assets/images/characters/detective_6.png',
        conversationExamples: [
          '논리적으로 접근해봅시다',
          '증거를 찾아보죠',
          '이게 핵심이에요',
          '결론적으로 말하면',
        ],
        greeting: '논리적으로 접근해봅시다',
      ),
    ];
  }
}
