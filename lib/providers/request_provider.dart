import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sickle_cell_app/models/doctor_request.dart';
import 'package:sickle_cell_app/services/doctor_request_service.dart';

class RequestNotifier extends StateNotifier<AsyncValue<List<DoctorRequest>>> {
  RequestNotifier() : super(const AsyncValue.loading());

  Future<void> fetchRequestsByDoctorId(String doctorId) async {
    try {
      state = const AsyncValue.loading(); // Set state to loading
      DoctorRequestService requestService = DoctorRequestService();
      final requests = await requestService.getAllRequestsByDoctorId(doctorId);
      state = AsyncValue.data(requests); // Set state to data
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace); // Set state to error
    }
  }

  Future<void> acceptRequest(String requestId) async {
    try {
      state = AsyncValue.loading();
      DoctorRequestService requestService = DoctorRequestService();
      await requestService.acceptRequestByrequestId(requestId);
      state.whenData((requests) {
        final updatedRequests = requests
            .where((request) => request.requestId != requestId)
            .toList();
        state = AsyncValue.data(updatedRequests);
      });
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> declineRequest(String requestId) async {
    try {
      state = AsyncValue.loading();
      DoctorRequestService requestService = DoctorRequestService();
      await requestService.declineRequestByrequestId(requestId);
      state.whenData((requests) {
        final updatedRequests = requests
            .where((request) => request.requestId != requestId)
            .toList();
        state = AsyncValue.data(updatedRequests);
      });
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }
}

final requestProvider =
    StateNotifierProvider<RequestNotifier, AsyncValue<List<DoctorRequest>>>(
        (ref) {
  return RequestNotifier();
});
