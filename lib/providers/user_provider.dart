
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sickle_cell_app/models/user.dart';

class UserNotifier extends StateNotifier<User?> {
  UserNotifier() : super(null);

  void setUser(User newUser) {
    state = newUser;
  }
}

final userProvider = StateNotifierProvider<UserNotifier, User?>((ref) {
  return UserNotifier();
});
