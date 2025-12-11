import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../helpers/db_helper.dart';
import '../models/report_model.dart';

final reportProvider = NotifierProvider<ReportNotifier, List<ReportModel>>(() {
  return ReportNotifier();
});

class ReportNotifier extends Notifier<List<ReportModel>> {
  @override
  List<ReportModel> build() {
    return [];
  }

  Future<void> loadReports() async {
    final dbHelper = ref.read(dbHelperProvider);
    state = await dbHelper.getReports();
  }

  Future<void> addReport(ReportModel report) async {
    final dbHelper = ref.read(dbHelperProvider);
    final id = await dbHelper.insertReport(report);

    final newReportWithId = report.copyWith(id: id);
    state = [...state, newReportWithId];
  }

  Future<void> updateReport(ReportModel updatedReport) async {
    final dbHelper = ref.read(dbHelperProvider);
    await dbHelper.updateReport(updatedReport);

    state = [
      for (final report in state)
        if (report.id == updatedReport.id) updatedReport else report,
    ];
  }

  Future<void> deleteReport(int id) async {
    final dbHelper = ref.read(dbHelperProvider);
    await dbHelper.deleteReport(id);

    state = state.where((report) => report.id != id).toList();
  }
}