import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sickle_cell_app/models/user.dart';
import 'package:sickle_cell_app/services/doctor_service.dart';

class DoctorNotifier extends StateNotifier<AsyncValue<List<User>>> {
  DoctorNotifier() : super(const AsyncValue.loading());

  Future<void> fetchDoctors() async {
    try {
      state = const AsyncValue.loading(); // Set state to loading
      DoctorService doctorService = DoctorService();
      final doctors = await doctorService.getAllDoctors();
      state = AsyncValue.data(doctors); // Set state to data
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace); // Set state to error
    }
  }

  Future<void> fetchAvailableDoctorSByPatientId(String patientId) async {
    try {
      state = const AsyncValue.loading(); // Set state to loading
      DoctorService doctorService = DoctorService();
      final doctors = await doctorService.getAvailableDoctorSByPatientId(patientId);
      state = AsyncValue.data(doctors); // Set state to data
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace); // Set state to error
    }
  }
}

final doctorProvider =
    StateNotifierProvider<DoctorNotifier, AsyncValue<List<User>>>((ref) {
  return DoctorNotifier();
});
