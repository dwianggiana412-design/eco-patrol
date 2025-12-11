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

  // Fungsi tambah laporan
  Future<void> addReport(ReportModel report) async {
    final dbHelper = ref.read(dbHelperProvider);
    await dbHelper.insertReport(report);

    // update state dengan menambah laporan baru
    state = [...state, report];
  }

  // Fungsi update laporan (misal update status atau notes)
  Future<void> updateReport(ReportModel updatedReport) async {
    final dbHelper = ref.read(dbHelperProvider);
    await dbHelper.updateReport(updatedReport);

    // update state dengan mengganti laporan yang sesuai id
    state = [
      for (final report in state)
        if (report.id == updatedReport.id) updatedReport else report,
    ];
  }

  // Fungsi hapus laporan
  Future<void> deleteReport(int id) async {
    final dbHelper = ref.read(dbHelperProvider);
    await dbHelper.deleteReport(id);

    // update state dengan menghapus laporan yang sesuai id
    state = state.where((report) => report.id != id).toList();
  }
}
