import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sickle_cell_app/models/health_record.dart';

class HealthrecordNotifier extends StateNotifier<HealthRecord?> {
  HealthrecordNotifier() : super(null);

  void setRecord(HealthRecord healthRecord) {
    state = healthRecord;
  }

}

final healthRecordProvider =
    StateNotifierProvider<HealthrecordNotifier, HealthRecord?>((ref) {
  return HealthrecordNotifier();
});
