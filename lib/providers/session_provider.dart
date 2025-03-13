import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sickle_cell_app/models/session.dart';
import 'package:sickle_cell_app/services/session_service.dart';

class SessionNotifier extends StateNotifier<AsyncValue<List<Session>>> {
  SessionNotifier() : super(const AsyncValue.loading());

  Future<void> fetchSessionsByDoctorId(String doctorId) async {
    try {
      state = const AsyncValue.loading(); 
      SessionService sessionService = SessionService();
      final sessions = await sessionService.getAllSessionByDoctorId(doctorId);
      state = AsyncValue.data(sessions); 
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace); 
    }
  }

  Future<void> fetchSessionsByChatIdAndDoctorId(
      String chatId, String doctorId) async {
    try {
      state = const AsyncValue.loading(); 
      SessionService sessionService = SessionService();
      final sessions = await sessionService.getAllSessionByChatIdAndDoctorId(
          chatId, doctorId);
      state = AsyncValue.data(sessions); 
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace); 
    }
  }

  Future<void> fetchSessionsByChatIdAndPatientId(
      String chatId, String patientId) async {
    try {
      state = const AsyncValue.loading(); 
      SessionService sessionService = SessionService();
      final sessions = await sessionService.getAllSessionByChatIdAndPatientId(
          chatId, patientId);
      state = AsyncValue.data(sessions);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace); 
    }
  }

  Future<void> acceptSession(String sessionId) async {
    try {
      state = const AsyncValue.loading(); 
      SessionService sessionService = SessionService();
      final updatedSession =
          await sessionService.acceptSessionByrequestId(sessionId);


      state.whenData((sessions) {
        final updatedSessions = sessions.map((session) {
          if (session.sessionId == sessionId) {
            return updatedSession; 
          }
          return session;
        }).toList();
        state = AsyncValue.data(updatedSessions);
      });
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> declineSession(String sessionId) async {
    try {
      state = const AsyncValue.loading();
      SessionService sessionService = SessionService();
      final updatedSession =
          await sessionService.declineSessionByrequestId(sessionId);

      state.whenData((sessions) {
        final updatedSessions = sessions.map((session) {
          if (session.sessionId == sessionId) {
            return updatedSession;
          }
          return session;
        }).toList();
        state = AsyncValue.data(updatedSessions);
      });
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace); 
    }
  }
}

final sessionProvider =
    StateNotifierProvider<SessionNotifier, AsyncValue<List<Session>>>((ref) {
  return SessionNotifier();
});
