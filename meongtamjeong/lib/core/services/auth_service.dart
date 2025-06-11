// meongtamdjeong_flutter/lib/services/auth_service.dart

import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:meongtamjeong/core/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

// SharedPreferences 키 정의
const String _kPersistentGuestUidKey = 'persistent_guest_firebase_uid';
const String _kAppGuestModeActiveKey = 'app_is_guest_mode_active';

class AuthService with ChangeNotifier {
  final fb_auth.FirebaseAuth _firebaseAuth = fb_auth.FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  SharedPreferences? _prefs;
  final ApiService _apiService;

  fb_auth.User? _currentFirebaseUser; // 현재 Firebase SDK가 인지하는 사용자
  String? _persistentGuestUid; // 앱이 기억하는 "우리 앱의 게스트" UID
  bool _isAppGuestModeActive = false; // 앱이 현재 "게스트 모드"로 동작 중인지 여부
  bool _isLoading = true; // 초기화 또는 주요 작업 진행 중 로딩 상태

  // UI에서 사용할 getter
  fb_auth.User? get user => _currentFirebaseUser; // 현재 Firebase 사용자 객체
  bool get isLoading => _isLoading;
  bool get isAppGuestModeActive => _isAppGuestModeActive;

  // "우리 앱 서비스"에 대한 인증 상태 (AuthWrapper가 사용)
  bool get isAuthenticated {
    if (_isLoading) return false; // 로딩 중에는 미인증으로 간주
    if (_currentFirebaseUser == null) return false; // Firebase에 로그인 안되어 있으면 미인증

    if (_currentFirebaseUser!.isAnonymous) {
      // Firebase 익명 사용자라면
      // 우리 앱의 게스트 모드가 활성화되어 있고, 그 UID가 저장된 영속적 게스트 UID와 같아야 함
      return _isAppGuestModeActive &&
          _currentFirebaseUser!.uid == _persistentGuestUid;
    }
    return true; // 정식 사용자(예: 구글)는 Firebase에 로그인되어 있으면 인증된 것으로 간주
  }

  AuthService({ApiService? apiService})
    : _apiService = apiService ?? ApiService() {
    print("AuthService: Constructor called, initial _isLoading: $_isLoading");
    _initialize();
  }

  Future<void> _initialize() async {
    _setLoading(true);
    print("AuthService (_initialize): Initializing...");
    try {
      _prefs = await SharedPreferences.getInstance();
      _persistentGuestUid = _prefs?.getString(_kPersistentGuestUidKey);
      // 앱 시작 시 _isAppGuestModeActive는 SharedPreferences 값 또는 Firebase 상태에 따라 결정됨 (아래 authStateChanges에서)
      _isAppGuestModeActive = _prefs?.getBool(_kAppGuestModeActiveKey) ?? false;
      print(
        'AuthService (_initialize): SharedPreferences loaded. _persistentGuestUid: $_persistentGuestUid, initial _isAppGuestModeActive from prefs: $_isAppGuestModeActive',
      );

      _firebaseAuth.authStateChanges().listen(_onAuthStateChanged);
      print('AuthService (_initialize): authStateChanges listener SET UP.');
      // 첫 이벤트는 _onAuthStateChanged에서 _isLoading을 false로 변경할 것임
    } catch (e) {
      print("AuthService (_initialize): CRITICAL ERROR during init: $e");
      _setLoading(false);
    }
  }

  void _setLoading(bool loading) {
    if (_isLoading != loading) {
      _isLoading = loading;
      print("AuthService (_setLoading): _isLoading set to $loading");
      notifyListeners();
    }
  }

  Future<void> _updateAppGuestModeState(bool isActive) async {
    if (_isAppGuestModeActive != isActive) {
      _isAppGuestModeActive = isActive;
      await _prefs?.setBool(_kAppGuestModeActiveKey, _isAppGuestModeActive);
      print(
        'AuthService (_updateAppGuestModeState): _isAppGuestModeActive set to $_isAppGuestModeActive and saved to prefs.',
      );
      notifyListeners(); // 게스트 모드 상태 변경 시 항상 알림
    }
  }

  Future<void> _onAuthStateChanged(fb_auth.User? fbUser) async {
    print(
      'AuthService (_onAuthStateChanged): Event received. New fbUser UID: ${fbUser?.uid}. Current _isLoading: $_isLoading',
    );
    final bool initialLoad = _isLoading; // 현재 로딩 상태가 초기 로딩인지 확인

    _currentFirebaseUser = fbUser; // AuthService의 Firebase 사용자 상태 업데이트

    if (fbUser == null) {
      // Firebase에서 완전히 로그아웃된 경우
      print(
        'AuthService (_onAuthStateChanged): Firebase User is definitively signed out (fbUser is null).',
      );
      await _apiService.deleteServiceTokens();
      // _persistentGuestUid는 유지 (사용자가 앱 데이터 삭제 전까지 기억)
      await _updateAppGuestModeState(false); // 게스트 모드는 확실히 비활성화
    } else {
      // Firebase에 로그인된 사용자 발견
      print(
        'AuthService (_onAuthStateChanged): Firebase User is signed in! UID: ${fbUser.uid}, IsAnonymous: ${fbUser.isAnonymous}',
      );

      bool shouldFetchServiceToken = false;

      if (fbUser.isAnonymous) {
        // Firebase 익명 사용자가 감지됨
        if (fbUser.uid == _persistentGuestUid) {
          // 우리 앱이 기억하는 영속적 게스트인가?
          if (_isAppGuestModeActive) {
            // 그리고 앱이 현재 게스트 모드 활성 상태라면
            print(
              'AuthService (_onAuthStateChanged): Persistent guest session (UID: ${fbUser.uid}) is active in app.',
            );
            shouldFetchServiceToken = true;
          } else {
            // 영속적 게스트 UID와 일치하지만, 앱 게스트 모드는 비활성 (예: 소프트 로그아웃 후 앱 재시작)
            // 이 경우, 자동으로 서비스 토큰을 받지 않고, 사용자가 "게스트 로그인"을 다시 눌러야 함.
            // _currentFirebaseUser는 설정되었지만, isAuthenticated는 false가 됨.
            print(
              'AuthService (_onAuthStateChanged): Persistent anonymous Firebase user (UID: ${fbUser.uid}) exists, but app guest mode is NOT active.',
            );
          }
        } else {
          // 우리 앱이 기억하는 영속적 게스트가 아니거나, 처음 보는 익명 UID
          print(
            'AuthService (_onAuthStateChanged): New or unexpected anonymous Firebase user (UID: ${fbUser.uid}). Treating as new guest session.',
          );
          _persistentGuestUid = fbUser.uid; // 이 UID를 새로운 영속적 게스트로 기억
          await _prefs?.setString(
            _kPersistentGuestUidKey,
            _persistentGuestUid!,
          );
          await _updateAppGuestModeState(true); // 새 익명 사용자는 즉시 활성 게스트 모드로
          shouldFetchServiceToken = true;
        }
      } else {
        // 정식 사용자 (예: 구글)
        print(
          'AuthService (_onAuthStateChanged): Non-anonymous user (UID: ${fbUser.uid}) detected.',
        );
        shouldFetchServiceToken = true;
        if (_isAppGuestModeActive) {
          // 정식 사용자 로그인이므로, 게스트 모드였다면 비활성화
          await _updateAppGuestModeState(false);
        }
        // 정식 사용자로 전환되었으므로, _persistentGuestUid는 더 이상 "현재" 게스트를 의미하지 않음.
        // 그러나 사용자가 나중에 다시 게스트로 돌아올 수 있으므로 삭제는 하지 않음.
        // 또는, 정식 계정으로 로그인하면 _persistentGuestUid를 null로 초기화하는 정책도 가능.
        // 여기서는 우선 유지.
      }

      if (shouldFetchServiceToken) {
        print(
          'AuthService (_onAuthStateChanged): Proceeding with service token for ${fbUser.uid}',
        );
        try {
          final String? nullableFirebaseIdToken = await fbUser.getIdToken(true);
          if (nullableFirebaseIdToken == null ||
              nullableFirebaseIdToken.isEmpty) {
            throw Exception(
              'Firebase ID Token is null or empty for user ${fbUser.uid}.',
            );
          }
          final String firebaseIdToken = nullableFirebaseIdToken;

          final serviceToken = await _apiService.authenticateWithFirebaseToken(
            firebaseIdToken,
          );
          if (serviceToken == null) {
            print(
              'AuthService (_onAuthStateChanged): Failed to obtain service token for ${fbUser.uid}.',
            );
            if (fbUser.isAnonymous && _isAppGuestModeActive) {
              // 활성 게스트 모드에서 서비스 토큰 실패
              await _updateAppGuestModeState(false); // 게스트 모드 비활성화
            }
            // 필요시 Firebase 로그아웃: await _firebaseAuth.signOut();
          } else {
            print(
              'AuthService (_onAuthStateChanged): Successfully obtained service token for ${fbUser.uid}.',
            );
          }
        } catch (e) {
          // 서비스 토큰 관련 예외 처리
          print(
            'AuthService (_onAuthStateChanged): Error during service token phase for ${fbUser.uid}: $e',
          );
          await _apiService.deleteServiceTokens();
          if (fbUser.isAnonymous && _isAppGuestModeActive) {
            await _updateAppGuestModeState(false);
          }
          // await _firebaseAuth.signOut();
        }
      }
    }

    if (initialLoad) {
      // 이 리스너 콜백이 _initAuth()로부터 처음 호출된 경우
      _isLoading = false; // 초기 로딩 완료
      print(
        "AuthService (_onAuthStateChanged): Initial auth state processed, _isLoading set to false.",
      );
    }
    notifyListeners(); // 모든 상태 변경 후 최종적으로 UI 업데이트 알림
    print(
      "AuthService (_onAuthStateChanged): Listener callback finished. isLoading: $_isLoading, isAuthenticated: $isAuthenticated, _isAppGuestModeActive: $_isAppGuestModeActive, _persistentGuestUid: $_persistentGuestUid, _currentFirebaseUser: ${_currentFirebaseUser?.uid}",
    );
  }

  // --- Public API ---

  Future<fb_auth.User?> signInWithGoogle() async {
    _setLoading(true);
    try {
      fb_auth.User? firebaseUserToReturn;
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        print(
          'AuthService (signInWithGoogle): Google sign in cancelled by user.',
        );
        _setLoading(false);
        return null;
      }
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final fb_auth.AuthCredential credential = fb_auth
          .GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // 현재 사용자가 우리가 관리하는 "영속적 게스트"인지 확인
      if (_currentFirebaseUser != null &&
          _currentFirebaseUser!.isAnonymous &&
          _currentFirebaseUser!.uid == _persistentGuestUid &&
          _isAppGuestModeActive) {
        print(
          'AuthService (signInWithGoogle): Active persistent guest detected. Attempting to link Google account.',
        );
        try {
          final fb_auth.UserCredential userCredential =
              await _currentFirebaseUser!.linkWithCredential(credential);
          print(
            'AuthService (signInWithGoogle): Successfully linked Google account to existing anonymous user. New UID (should be same as guest): ${userCredential.user?.uid}',
          );
          firebaseUserToReturn = userCredential.user;
          // _persistentGuestUid는 이제 정식 계정으로 전환되었으므로 초기화 가능 (선택적)
          // await _prefs?.remove(_kPersistentGuestUidKey);
          // _persistentGuestUid = null;
          // _isAppGuestModeActive는 authStateChanges에서 false로 처리될 것임 (fbUser.isAnonymous가 false가 되므로)
        } catch (e) {
          // 연결 실패 (예: 이 구글 계정이 이미 다른 Firebase 계정에 연결된 경우)
          print(
            'AuthService (signInWithGoogle): Failed to link Google account: $e. Attempting normal Google sign-in.',
          );
          // 연결 실패 시, 일반적인 Firebase 구글 로그인 시도
          // (주의: 현재 _currentFirebaseUser가 익명이므로, signInWithCredential은 새 사용자를 만들거나 오류 발생 가능)
          // 충돌을 피하려면, 먼저 현재 익명 사용자를 로그아웃시키고 구글 로그인하는 것이 안전할 수 있음.
          // 또는, 사용자에게 선택권을 줘야 함. 여기서는 우선 일반 로그인 시도.
          try {
            // 만약 충돌이 예상되면, 먼저 로그아웃 후 signInWithCredential 시도
            // await _firebaseAuth.signOut(); // 이렇게 하면 authStateChanges가 복잡해짐
            final fb_auth.UserCredential userCredential = await _firebaseAuth
                .signInWithCredential(credential);
            firebaseUserToReturn = userCredential.user;
          } catch (signInError) {
            print(
              'AuthService (signInWithGoogle): Normal Google sign-in also failed after link failed: $signInError',
            );
            _setLoading(false);
            rethrow; // 최종 실패
          }
        }
      } else {
        // 게스트가 아니거나, 비활성 게스트거나, 다른 사용자 등: 일반 구글 로그인
        print(
          'AuthService (signInWithGoogle): No active persistent guest. Proceeding with normal Google sign-in.',
        );
        final fb_auth.UserCredential userCredential = await _firebaseAuth
            .signInWithCredential(credential);
        firebaseUserToReturn = userCredential.user;
      }

      // _isAppGuestModeActive는 authStateChanges에서 !isAnonymous일 때 false로 설정됨.
      // 서비스 토큰 요청도 authStateChanges에서 처리.
      _setLoading(false); // 이 메서드의 로딩은 여기서 종료, authStateChanges는 별도
      return firebaseUserToReturn;
    } catch (e) {
      print('AuthService (signInWithGoogle): Error: $e');
      _setLoading(false);
      rethrow;
    }
  }

  Future<fb_auth.User?> signInAnonymously() async {
    _setLoading(true);
    if (_prefs == null) {
      /* ... (_initAuth 호출 또는 오류 처리) ... */
      _setLoading(false);
      throw Exception("Prefs not initialized in signInAnonymously");
    }

    print(
      'AuthService (signInAnonymously attempt): _persistentGuestUid: $_persistentGuestUid, _currentFirebaseUser: ${_currentFirebaseUser?.uid}, _isAppGuestModeActive: $_isAppGuestModeActive',
    );

    // 1. 앱이 이미 "활성 게스트 모드"이고, 현재 Firebase 사용자가 해당 게스트와 일치
    if (_isAppGuestModeActive &&
        _currentFirebaseUser != null &&
        _currentFirebaseUser!.isAnonymous &&
        _currentFirebaseUser!.uid == _persistentGuestUid) {
      print(
        'AuthService (signInAnonymously): Already in active guest mode with UID: ${_currentFirebaseUser!.uid}.',
      );
      _setLoading(false);
      return _currentFirebaseUser;
    }

    // 2. 앱 게스트 모드는 비활성이지만, Firebase에 이전에 사용했던 "영속적 게스트" 세션이 남아있는 경우 (소프트 로그아웃 후 재시도)
    if (!_isAppGuestModeActive &&
        _persistentGuestUid != null &&
        _currentFirebaseUser != null &&
        _currentFirebaseUser!.isAnonymous &&
        _currentFirebaseUser!.uid == _persistentGuestUid) {
      print(
        'AuthService (signInAnonymously): Reactivating guest mode for persistent Firebase anonymous session (UID: ${_currentFirebaseUser!.uid}).',
      );
      try {
        final String? nullableFirebaseIdToken = await _currentFirebaseUser!
            .getIdToken(true);
        if (nullableFirebaseIdToken == null ||
            nullableFirebaseIdToken.isEmpty) {
          throw Exception(
            'Firebase ID Token is null or empty for persistent anonymous user during reactivation.',
          );
        }
        final String firebaseIdToken = nullableFirebaseIdToken;

        final serviceToken = await _apiService.authenticateWithFirebaseToken(
          firebaseIdToken,
        );
        if (serviceToken != null) {
          await _updateAppGuestModeState(
            true,
          ); // 게스트 모드 활성화 (prefs는 이미 UID 저장되어 있을 것)
          print(
            'AuthService (signInAnonymously - reactivate): Successfully reactivated guest mode.',
          );
        } else {
          throw Exception(
            'Failed to obtain service token during guest reactivation.',
          );
        }
        _setLoading(false);
        return _currentFirebaseUser;
      } catch (e) {
        print(
          "AuthService (signInAnonymously - reactivate error): $e. Will sign out from Firebase and create new anonymous session.",
        );
        await _firebaseAuth
            .signOut(); // authStateChanges가 _isAppGuestModeActive=false, _currentFirebaseUser=null로 처리
        // 새 세션 생성 시도
        return _createNewFirebaseAnonymousSessionAndActivateGuestMode();
      }
    }

    // 3. 그 외 모든 경우: 새로운 Firebase 익명 세션 생성
    print(
      'AuthService (signInAnonymously): No existing persistent guest session to reactivate, or mismatch. Creating new one.',
    );
    return _createNewFirebaseAnonymousSessionAndActivateGuestMode();
  }

  Future<fb_auth.User?>
  _createNewFirebaseAnonymousSessionAndActivateGuestMode() async {
    // _setLoading(true)는 호출부에서 이미 설정됨
    try {
      print(
        'AuthService (_createNewFirebaseAnonymousSession): Creating new Firebase anonymous user.',
      );
      final fb_auth.UserCredential userCredential =
          await _firebaseAuth.signInAnonymously();
      final fb_auth.User? newUser = userCredential.user;
      print(
        'AuthService (_createNewFirebaseAnonymousSession): New Firebase anonymous user created: ${newUser?.uid}',
      );

      if (newUser != null) {
        _persistentGuestUid = newUser.uid; // 새 UID를 영속적 게스트 UID로 저장
        await _prefs?.setString(_kPersistentGuestUidKey, _persistentGuestUid!);
        await _updateAppGuestModeState(true); // 새 게스트는 즉시 활성 게스트 모드로

        // 새 익명 사용자에 대한 서비스 토큰 즉시 요청 (authStateChanges에서도 처리되지만, 여기서도 시도 가능)
        try {
          final String? nullableFirebaseIdToken = await newUser.getIdToken(
            true,
          );
          if (nullableFirebaseIdToken == null ||
              nullableFirebaseIdToken.isEmpty) {
            throw Exception(
              'Firebase ID Token is null or empty for new anonymous user.',
            );
          }
          final String firebaseIdToken = nullableFirebaseIdToken;
          final serviceToken = await _apiService.authenticateWithFirebaseToken(
            firebaseIdToken,
          );
          if (serviceToken == null) {
            print(
              'AuthService (_createNewFirebaseAnonymousSession): Failed to get service token for new anonymous user. Deactivating guest mode.',
            );
            await _updateAppGuestModeState(false); // 실패 시 게스트 모드 다시 비활성화
          }
        } catch (e_token) {
          print(
            'AuthService (_createNewFirebaseAnonymousSession): Error getting service token: $e_token',
          );
          await _apiService.deleteServiceTokens();
          await _updateAppGuestModeState(false);
        }
      }
      _setLoading(false);
      return newUser;
    } catch (e) {
      print('AuthService (_createNewFirebaseAnonymousSession): Error: $e');
      _setLoading(false);
      rethrow;
    }
  }

  Future<void> signOut() async {
    _setLoading(true);
    final fb_auth.User? signingOutUser =
        _currentFirebaseUser; // AuthService 내부 상태 사용
    final bool wasAppGuestModeActive = _isAppGuestModeActive;

    print(
      'AuthService (signOut): Attempting to sign out. Current Firebase User (AuthService cache): ${signingOutUser?.uid}, WasAppGuestModeActive: $wasAppGuestModeActive',
    );

    try {
      if (signingOutUser != null) {
        if (signingOutUser.isAnonymous && wasAppGuestModeActive) {
          // "활성 게스트 모드"에서 로그아웃 (소프트 로그아웃)
          print(
            'AuthService (signOut): Soft-logging out guest. Deactivating app guest mode. Firebase session for UID ${signingOutUser.uid} is kept.',
          );
          await _apiService.deleteServiceTokens(); // 서비스 토큰은 삭제
          await _updateAppGuestModeState(false); // 앱 게스트 모드 비활성화 (prefs 저장됨)
          // _currentFirebaseUser는 그대로 유지 (Firebase SDK의 상태를 따름)
          // isAuthenticated getter가 false를 반환하여 AuthWrapper가 LoginPage로 보냄
        } else {
          // 정식 사용자 또는 비활성 게스트 모드의 익명 사용자 등 (완전 로그아웃)
          print(
            'AuthService (signOut): Performing full Firebase sign out for user ${signingOutUser.uid}.',
          );
          if (!signingOutUser.isAnonymous && await _googleSignIn.isSignedIn()) {
            await _googleSignIn.signOut(); // 구글 SDK 로그아웃
          }
          await _firebaseAuth
              .signOut(); // Firebase 완전 로그아웃 (authStateChanges 트리거)
          // authStateChanges 리스너에서 _currentFirebaseUser=null, _isAppGuestModeActive=false 처리
        }
      } else {
        // 이미 로그아웃된 상태 (AuthService._currentFirebaseUser가 null)
        print(
          'AuthService (signOut): No user in AuthService to sign out. Ensuring guest mode is off.',
        );
        await _updateAppGuestModeState(false); // 만약을 위해 게스트 모드 비활성화
      }
    } catch (e) {
      print('AuthService (signOut): Error: $e');
      rethrow;
    } finally {
      _setLoading(false);
    }
  }
}
