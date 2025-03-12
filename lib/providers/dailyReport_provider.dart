import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sickle_cell_app/models/daily_report.dart';

class DailyreportNotifier extends StateNotifier<DailyReport?> {
  DailyreportNotifier() : super(null);

  void setRecord(DailyReport report) {
    state = report;
  }
}

final dailyReportProvider =
    StateNotifierProvider<DailyreportNotifier, DailyReport?>((ref) {
  return DailyreportNotifier();
});
