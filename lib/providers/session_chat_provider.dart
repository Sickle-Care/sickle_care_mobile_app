import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sickle_cell_app/models/session_chat.dart';
import 'package:sickle_cell_app/services/session_chat_service.dart';

class SessionChatNotifier extends StateNotifier<AsyncValue<List<SessionChat>>> {
  SessionChatNotifier() : super(const AsyncValue.loading());

  Future<void> fetchSessionChatsByDoctorId(String doctorId) async {
    try {
      state = const AsyncValue.loading();
      SessionChatService sessionChatService = SessionChatService();
      final chats = await sessionChatService.getAllChatsByDoctorId(doctorId);
      state = AsyncValue.data(chats);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> fetchSessionChatsByPatientId(String patientId) async {
    try {
      state = const AsyncValue.loading();
      SessionChatService sessionChatService = SessionChatService();
      final chats = await sessionChatService.getAllChatsByPatientId(patientId);
      state = AsyncValue.data(chats);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }
}

final sessionChatProvider =
    StateNotifierProvider<SessionChatNotifier, AsyncValue<List<SessionChat>>>(
        (ref) {
  return SessionChatNotifier();
});
