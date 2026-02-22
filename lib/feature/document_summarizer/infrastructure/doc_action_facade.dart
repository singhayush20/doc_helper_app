import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:doc_helper_app/core/common/constants/enums.dart';
import 'package:doc_helper_app/core/exception_handling/server_exception.dart';
import 'package:doc_helper_app/feature/document_summarizer/domain/interface/i_doc_action_facade.dart';
import 'package:file_picker/file_picker.dart' as file_picker;
import 'package:injectable/injectable.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';

@LazySingleton(as: IDocActionFacade)
class DocActionFacade implements IDocActionFacade {
  @override
  Future<Either<ServerException, String?>> saveSummaryAsPdf({
    required String content,
    required String fileName,
  }) async {
    try {
      final pdf = pw.Document();

      final List<pw.Widget> contentWidgets = [];
      final lines = content.split('\n');

      for (var line in lines) {
        final trimmedLine = line.trim();
        if (trimmedLine.isEmpty) {
          contentWidgets.add(pw.SizedBox(height: 8));
          continue;
        }

        // Handle Headers
        if (trimmedLine.startsWith('# ')) {
          contentWidgets.add(pw.Padding(
            padding: const pw.EdgeInsets.only(top: 12, bottom: 6),
            child: pw.Text(
              trimmedLine.substring(2),
              style: pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold),
            ),
          ));
        } else if (trimmedLine.startsWith('## ')) {
          contentWidgets.add(pw.Padding(
            padding: const pw.EdgeInsets.only(top: 10, bottom: 5),
            child: pw.Text(
              trimmedLine.substring(3),
              style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
            ),
          ));
        } else if (trimmedLine.startsWith('### ')) {
          contentWidgets.add(pw.Padding(
            padding: const pw.EdgeInsets.only(top: 8, bottom: 4),
            child: pw.Text(
              trimmedLine.substring(4),
              style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
            ),
          ));
        }
        // Handle Unordered Lists
        else if (trimmedLine.startsWith('- ') || trimmedLine.startsWith('* ')) {
          contentWidgets.add(pw.Padding(
            padding: const pw.EdgeInsets.only(left: 10, bottom: 4),
            child: pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text('• ', style: const pw.TextStyle(fontSize: 12)),
                pw.Expanded(
                  child: pw.RichText(
                    text: _processInlineStyles(trimmedLine.substring(2)),
                  ),
                ),
              ],
            ),
          ));
        }
        // Handle Regular Paragraphs
        else {
          contentWidgets.add(pw.Padding(
            padding: const pw.EdgeInsets.only(bottom: 6),
            child: pw.RichText(
              text: _processInlineStyles(trimmedLine),
            ),
          ));
        }
      }

      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(40),
          build: (pw.Context context) => [
            pw.Header(
              level: 0,
              child: pw.Text(
                'Document Summary',
                style:
                    pw.TextStyle(fontSize: 26, fontWeight: pw.FontWeight.bold),
              ),
            ),
            pw.Divider(),
            ...contentWidgets,
          ],
        ),
      );

      final pdfBytes = await pdf.save();

      final filePath = await file_picker.FilePicker.platform.saveFile(
        dialogTitle: 'Save summary as PDF',
        fileName: fileName,
        type: file_picker.FileType.custom,
        allowedExtensions: const ['pdf'],
        bytes: pdfBytes,
      );

      if (filePath == null) {
        return const Right(null);
      }

      if (!Platform.isAndroid && !Platform.isIOS) {
        final file = File(filePath);
        await file.writeAsBytes(pdfBytes);
      }

      return Right(filePath);
    } catch (e) {
      return const Left(
        ServerException(exceptionType: ServerExceptionType.unknown),
      );
    }
  }

  /// Processes inline styles like **bold** and returns a RichText span
  pw.InlineSpan _processInlineStyles(String text) {
    final List<pw.InlineSpan> spans = [];
    final regex = RegExp(r'\*\*(.*?)\*\*');
    int lastMatchEnd = 0;

    for (final match in regex.allMatches(text)) {
      if (match.start > lastMatchEnd) {
        spans.add(pw.TextSpan(
          text: text.substring(lastMatchEnd, match.start),
          style: const pw.TextStyle(fontSize: 12),
        ));
      }
      spans.add(pw.TextSpan(
        text: match.group(1),
        style: pw.TextStyle(
          fontSize: 12,
          fontWeight: pw.FontWeight.bold,
        ),
      ));
      lastMatchEnd = match.end;
    }

    if (lastMatchEnd < text.length) {
      spans.add(pw.TextSpan(
        text: text.substring(lastMatchEnd),
        style: const pw.TextStyle(fontSize: 12),
      ));
    }

    if (spans.isEmpty) {
      return pw.TextSpan(
        text: text,
        style: const pw.TextStyle(fontSize: 12),
      );
    }

    return pw.TextSpan(children: spans);
  }

  @override
  Future<Either<ServerException, Unit>> shareSummaryAsText({
    required String content,
    required String subject,
  }) async {
    try {
      await SharePlus.instance.share(
        ShareParams(text: content, subject: subject),
      );
      return const Right(unit);
    } catch (e) {
      return left(
        const ServerException(exceptionType: ServerExceptionType.unknown),
      );
    }
  }
}
