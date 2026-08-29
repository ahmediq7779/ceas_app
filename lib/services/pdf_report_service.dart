import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../models/boq_item_model.dart';
import '../core/utils/number_formatter.dart';

/// Project metadata for the generated engineering report
class ProjectMetadata {
  final String projectName;
  final String engineerName;
  final String clientName;
  final String location;
  final String notes;

  const ProjectMetadata({
    this.projectName = 'مشروع إنشائي جديد',
    this.engineerName = 'المهندس الإنشائي',
    this.clientName = 'المالك',
    this.location = 'موقع العمل',
    this.notes = 'تم إعداد هذا التقرير وجدول الكميات التقديري بواسطة منظومة الهندسة المدنية (CEAS).',
  });
}

/// PDF Report Generator and Exporter Service
class PdfReportService {
  PdfReportService._();

  /// Generates the complete PDF document bytes
  static Future<Uint8List> generateBoqReport({
    required List<BoqItemModel> items,
    required ProjectMetadata metadata,
    required String currency,
  }) async {
    final pdf = pw.Document();

    // Use custom or standard fallback font
    final arabicFont = await PdfGoogleFonts.cairoMedium();
    final arabicBoldFont = await PdfGoogleFonts.cairoBold();

    final totalCost = items.fold<double>(0.0, (sum, item) => sum + item.totalPrice);
    final totalQty = items.fold<double>(0.0, (sum, item) => sum + item.quantity);

    // Primary Colors
    const primaryColor = PdfColor.fromInt(0xFFF97316); // Safety Orange
    const slateDark = PdfColor.fromInt(0xFF0F172A);
    const slateLight = PdfColor.fromInt(0xFFF1F5F9);
    const textDark = PdfColor.fromInt(0xFF1E293B);

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        textDirection: pw.TextDirection.rtl,
        theme: pw.ThemeData.withFont(
          base: arabicFont,
          bold: arabicBoldFont,
        ),
        margin: const pw.EdgeInsets.all(28),
        header: (pw.Context context) {
          return pw.Column(
            children: [
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        'CEAS - منظومة الهندسة المدنية المتكاملة',
                        style: pw.TextStyle(
                          font: arabicBoldFont,
                          fontSize: 16,
                          color: primaryColor,
                        ),
                      ),
                      pw.Text(
                        'Civil Engineering Application Suite',
                        style: const pw.TextStyle(
                          fontSize: 9,
                          color: PdfColors.grey700,
                        ),
                      ),
                    ],
                  ),
                  pw.Container(
                    padding: const pw.EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: pw.BoxDecoration(
                      color: slateDark,
                      borderRadius: const pw.BorderRadius.all(pw.Radius.circular(6)),
                    ),
                    child: pw.Text(
                      'تقرير جدول الكميات (BOQ)',
                      style: pw.TextStyle(
                        font: arabicBoldFont,
                        fontSize: 11,
                        color: PdfColors.white,
                      ),
                    ),
                  ),
                ],
              ),
              pw.SizedBox(height: 8),
              pw.Divider(color: primaryColor, thickness: 1.5),
              pw.SizedBox(height: 10),
            ],
          );
        },
        footer: (pw.Context context) {
          return pw.Container(
            alignment: pw.Alignment.center,
            margin: const pw.EdgeInsets.only(top: 14),
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text(
                  'الصفحة ${context.pageNumber} من ${context.pagesCount}',
                  style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey600),
                ),
                pw.Text(
                  'تم الإنشاء عبر تطبيق CEAS الإنشائي',
                  style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey600),
                ),
              ],
            ),
          );
        },
        build: (pw.Context context) {
          return [
            // Project Information Box
            pw.Container(
              padding: const pw.EdgeInsets.all(12),
              decoration: pw.BoxDecoration(
                color: slateLight,
                borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
                border: pw.Border.all(color: const PdfColor.fromInt(0xFFCBD5E1)),
              ),
              child: pw.Column(
                children: [
                  pw.Row(
                    children: [
                      pw.Expanded(
                        child: _buildInfoField('اسم المشروع:', metadata.projectName, arabicBoldFont),
                      ),
                      pw.Expanded(
                        child: _buildInfoField('المهندس المسؤول:', metadata.engineerName, arabicBoldFont),
                      ),
                    ],
                  ),
                  pw.SizedBox(height: 6),
                  pw.Row(
                    children: [
                      pw.Expanded(
                        child: _buildInfoField('المالك / العميل:', metadata.clientName, arabicBoldFont),
                      ),
                      pw.Expanded(
                        child: _buildInfoField('الموقع:', metadata.location, arabicBoldFont),
                      ),
                    ],
                  ),
                  pw.SizedBox(height: 6),
                  pw.Row(
                    children: [
                      pw.Expanded(
                        child: _buildInfoField(
                          'تاريخ التقرير:',
                          DateTime.now().toString().split(' ').first,
                          arabicBoldFont,
                        ),
                      ),
                      pw.Expanded(
                        child: _buildInfoField('العملة المعتمدة:', currency, arabicBoldFont),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            pw.SizedBox(height: 14),

            // Financial Summary KPI Cards
            pw.Row(
              children: [
                pw.Expanded(
                  child: _buildSummaryCard(
                    'إجمالي التكلفة التقديرية',
                    '${NumberFormatter.format(totalCost)} $currency',
                    primaryColor,
                    arabicBoldFont,
                  ),
                ),
                pw.SizedBox(width: 10),
                pw.Expanded(
                  child: _buildSummaryCard(
                    'عدد البنود المسجلة',
                    '${items.length} بنود',
                    slateDark,
                    arabicBoldFont,
                  ),
                ),
              ],
            ),
            pw.SizedBox(height: 16),

            // Table of Quantities
            pw.Text(
              'جدول تفاصيل البنود والكميات:',
              style: pw.TextStyle(
                font: arabicBoldFont,
                fontSize: 13,
                color: textDark,
              ),
            ),
            pw.SizedBox(height: 8),

            pw.TableHelper.fromTextArray(
              headers: ['م', 'القسم', 'بيان البند والمواصفة', 'الوحدة', 'الكمية', 'سعر الوحدة ($currency)', 'الإجمالي ($currency)'],
              headerStyle: pw.TextStyle(
                font: arabicBoldFont,
                fontSize: 9.5,
                color: PdfColors.white,
              ),
              headerDecoration: const pw.BoxDecoration(color: slateDark),
              rowDecoration: const pw.BoxDecoration(
                border: pw.Border(
                  bottom: pw.BorderSide(color: PdfColor.fromInt(0xFFE2E8F0), width: 0.5),
                ),
              ),
              cellAlignment: pw.Alignment.center,
              cellAlignments: {
                0: pw.Alignment.center,
                1: pw.Alignment.center,
                2: pw.Alignment.centerRight,
                3: pw.Alignment.center,
                4: pw.Alignment.center,
                5: pw.Alignment.center,
                6: pw.Alignment.centerLeft,
              },
              cellStyle: const pw.TextStyle(fontSize: 8.5),
              data: List<List<dynamic>>.generate(items.length, (index) {
                final item = items[index];
                return [
                  '${index + 1}',
                  item.category.shortName,
                  item.title.isNotEmpty ? item.title : item.description,
                  item.unit,
                  NumberFormatter.format(item.quantity),
                  NumberFormatter.format(item.unitPrice),
                  NumberFormatter.format(item.totalPrice),
                ];
              }),
            ),

            // Total Summary Row
            pw.Container(
              padding: const pw.EdgeInsets.all(10),
              decoration: const pw.BoxDecoration(
                color: slateLight,
                border: pw.Border(
                  bottom: pw.BorderSide(color: primaryColor, width: 2),
                ),
              ),
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                    'الإجمالي العام لجدول الكميات:',
                    style: pw.TextStyle(font: arabicBoldFont, fontSize: 11),
                  ),
                  pw.Text(
                    '${NumberFormatter.format(totalCost)} $currency',
                    style: pw.TextStyle(
                      font: arabicBoldFont,
                      fontSize: 12,
                      color: primaryColor,
                    ),
                  ),
                ],
              ),
            ),
            pw.SizedBox(height: 20),

            // Engineering Notes
            if (metadata.notes.isNotEmpty) ...[
              pw.Text(
                'ملاحظات واعتمادات هندسية:',
                style: pw.TextStyle(font: arabicBoldFont, fontSize: 10),
              ),
              pw.SizedBox(height: 4),
              pw.Text(
                metadata.notes,
                style: const pw.TextStyle(fontSize: 8.5, color: PdfColors.grey800),
              ),
              pw.SizedBox(height: 24),
            ],

            // Signatures block
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Column(
                  children: [
                    pw.Text('توقيع المهندس المسؤول', style: pw.TextStyle(font: arabicBoldFont, fontSize: 9)),
                    pw.SizedBox(height: 30),
                    pw.Container(width: 130, height: 1, color: PdfColors.grey600),
                  ],
                ),
                pw.Column(
                  children: [
                    pw.Text('اعتماد واستلام المالك', style: pw.TextStyle(font: arabicBoldFont, fontSize: 9)),
                    pw.SizedBox(height: 30),
                    pw.Container(width: 130, height: 1, color: PdfColors.grey600),
                  ],
                ),
              ],
            ),
          ];
        },
      ),
    );

    return pdf.save();
  }

  /// Print or show print preview dialog
  static Future<void> printReport({
    required List<BoqItemModel> items,
    required ProjectMetadata metadata,
    required String currency,
  }) async {
    final pdfBytes = await generateBoqReport(
      items: items,
      metadata: metadata,
      currency: currency,
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdfBytes,
      name: 'CEAS_BOQ_Report_${DateTime.now().millisecondsSinceEpoch}.pdf',
    );
  }

  /// Share PDF file directly to external apps (WhatsApp, Email, Drive)
  static Future<void> shareReport({
    required List<BoqItemModel> items,
    required ProjectMetadata metadata,
    required String currency,
  }) async {
    final pdfBytes = await generateBoqReport(
      items: items,
      metadata: metadata,
      currency: currency,
    );

    await Printing.sharePdf(
      bytes: pdfBytes,
      filename: 'CEAS_BOQ_${metadata.projectName.replaceAll(' ', '_')}.pdf',
    );
  }

  static pw.Widget _buildInfoField(String label, String value, pw.Font boldFont) {
    return pw.Row(
      mainAxisSize: pw.MainAxisSize.min,
      children: [
        pw.Text(
          '$label ',
          style: pw.TextStyle(font: boldFont, fontSize: 9, color: PdfColors.grey800),
        ),
        pw.Text(
          value,
          style: const pw.TextStyle(fontSize: 9, color: PdfColors.black),
        ),
      ],
    );
  }

  static pw.Widget _buildSummaryCard(String title, String value, PdfColor color, pw.Font boldFont) {
    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      decoration: pw.BoxDecoration(
        color: color,
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(6)),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            title,
            style: const pw.TextStyle(fontSize: 8.5, color: PdfColors.white),
          ),
          pw.SizedBox(height: 4),
          pw.Text(
            value,
            style: pw.TextStyle(font: boldFont, fontSize: 13, color: PdfColors.white),
          ),
        ],
      ),
    );
  }
}
