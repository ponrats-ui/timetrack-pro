import 'package:share_plus/share_plus.dart';

import '../domain/report_export.dart';

class ReportShareService {
  const ReportShareService();

  Future<void> share(ReportExportFile file) async {
    await SharePlus.instance.share(
      ShareParams(
        files: [
          XFile.fromData(
            file.bytes,
            name: file.fileName,
            mimeType: file.mimeType,
          ),
        ],
        fileNameOverrides: [file.fileName],
        subject: file.fileName,
        text: 'TimeTrack Pro HR Report',
        downloadFallbackEnabled: true,
      ),
    );
  }
}
