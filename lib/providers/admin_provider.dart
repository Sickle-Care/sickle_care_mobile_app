import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sickle_cell_app/models/user.dart';
import 'package:sickle_cell_app/services/user_service.dart';

class AdminNotifier extends StateNotifier<AsyncValue<List<User>>> {
  AdminNotifier() : super(const AsyncValue.loading());

  Future<void> fetchAdmins() async {
    try {
      state = const AsyncValue.loading(); // Set state to loading
      UserService adminService = UserService();
      final admins = await adminService.getAllAdmins();
      state = AsyncValue.data(admins); // Set state to data
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace); // Set state to error
    }
  }
}

final adminProvider =
    StateNotifierProvider<AdminNotifier, AsyncValue<List<User>>>((ref) {
  return AdminNotifier();
});
