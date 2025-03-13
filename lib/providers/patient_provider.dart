import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sickle_cell_app/models/user.dart';
import 'package:sickle_cell_app/services/patient_service.dart';

class PatientNotifier extends StateNotifier<AsyncValue<List<User>>> {
  PatientNotifier() : super(const AsyncValue.loading());

  Future<void> fetchPatientsByDoctorId(String doctorId) async {
    try {
      state = const AsyncValue.loading();
      PatientService patientService = PatientService();
      final doctors = await patientService.getAllPatientsByDoctorId(doctorId);
      state = AsyncValue.data(doctors);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> fetchPatients() async {
    try {
      state = const AsyncValue.loading();
      PatientService patientService = PatientService();
      final patients = await patientService.getAllPatients();
      state = AsyncValue.data(patients);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }
}

final patientProvider =
    StateNotifierProvider<PatientNotifier, AsyncValue<List<User>>>((ref) {
  return PatientNotifier();
});
