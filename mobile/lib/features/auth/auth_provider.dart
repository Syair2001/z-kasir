import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'auth_service.dart';
import '../store/store_provider.dart';
import '../store/store_model.dart';

final authServiceProvider = Provider((ref) => AuthService());

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref);
});

class AuthState {
  final bool isLoading;
  final bool isAuthenticated;
  final Map<String, dynamic>? userData;
  final String? error;
  final String status; // 'approved' or 'pending'

  AuthState({
    this.isLoading = false,
    this.isAuthenticated = false,
    this.userData,
    this.error,
    this.status = 'pending',
  });

  AuthState copyWith({
    bool? isLoading,
    bool? isAuthenticated,
    Map<String, dynamic>? userData,
    String? error,
    String? status,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      userData: userData ?? this.userData,
      error: error ?? this.error,
      status: status ?? this.status,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final Ref ref;
  late final AuthService service;

  AuthNotifier(this.ref) : super(AuthState()) {
    service = ref.read(authServiceProvider);
  }

  Future<bool> login(String username, String password) async {
    state = state.copyWith(isLoading: true, error: null);

    final result = await service.login(username: username, password: password);

    if (result != null) {
      final storeData = result['store'];
      if (storeData != null) {
        final store = StoreModel.fromJson(storeData);
        ref.read(storeProvider.notifier).setStore(store);
      }

      state = state.copyWith(
        isLoading: false,
        isAuthenticated: true,
        userData: result['user'],
        status: result['status'] ?? 'pending',
      );
      return true;
    } else {
      state = state.copyWith(isLoading: false, error: "Username atau password salah");
      return false;
    }
  }

  Future<void> logout() async {
    await service.logout();
    ref.read(storeProvider.notifier).clear();
    state = AuthState();
  }
}