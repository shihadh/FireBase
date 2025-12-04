import 'package:finote/features/AddTransaction/model/transation_model.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class PDFUtils {
  /// Generates and prints/export a professional PDF for the given transactions
  static Future<void> exportTransactionsToPDF({
    required List<TransationModel> transactions,
    required int month,
    required int year,
  }) async {
    if (transactions.isEmpty) return;

    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'Transaction History',
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 5),
              pw.Text(
                '${DateFormat.MMMM().format(DateTime(0, month))} $year',
                style: pw.TextStyle(fontSize: 16, color: PdfColors.grey700),
              ),
              pw.SizedBox(height: 20),
              pw.Table.fromTextArray(
                headers: ['Date', 'Category', 'Type', 'Amount', 'Note'],
                data: transactions.map((t) {
                  return [
                    t.date ?? '',
                    t.category ?? '',
                    t.type ?? '',
                    t.amount ?? '',
                    t.note ?? '',
                  ];
                }).toList(),
                headerStyle: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.white,
                ),
                headerDecoration: pw.BoxDecoration(
                  color: PdfColors.blueGrey900,
                ),
                cellPadding: const pw.EdgeInsets.symmetric(
                    vertical: 5, horizontal: 8),
                cellAlignment: pw.Alignment.centerLeft,
                border: pw.TableBorder.all(color: PdfColors.grey300),
              ),
              pw.SizedBox(height: 20),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.end,
                children: [
                  pw.Text(
                    'Generated on: ${DateFormat('dd-MM-yyyy').format(DateTime.now())}',
                    style: pw.TextStyle(fontSize: 10, color: PdfColors.grey),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(onLayout: (format) async => pdf.save());
  }
}
