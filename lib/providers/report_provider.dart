import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../helpers/db_helper.dart';
import '../models/report_model.dart';

// Provider Riverpod modern (NotifierProvider)
final reportProvider = NotifierProvider<ReportNotifier, List<ReportModel>>(() {
  return ReportNotifier();
});

// Notifier (ganti dari StateNotifier)
class ReportNotifier extends Notifier<List<ReportModel>> {
  @override
  List<ReportModel> build() {
    return []; // initial state
  }

  // fungsi tambah laporan
  Future<void> addReport(ReportModel report) async {
    final dbHelper = ref.read(dbHelperProvider);
    await dbHelper.insertReport(report);

    // update state
    state = [...state, report];
  }
}
