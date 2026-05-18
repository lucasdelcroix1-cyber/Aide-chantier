import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;

import '../models/renovation_project.dart';
import 'calculation_service.dart';

class PdfService {
  static Future<File> generate(
    RenovationProject project,
    CalculationResult result,
  ) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'Devis estimatif rénovation',
                style: pw.TextStyle(fontSize: 24),
              ),
              pw.SizedBox(height: 20),
              pw.Text('Projet : ${project.name}'),
              pw.Text('Surface : ${result.surface.toStringAsFixed(2)} m²'),
              pw.Text(
                'Matériaux : ${result.materialQuantity.toStringAsFixed(2)}',
              ),
              pw.Text(
                'Budget estimé : ${result.estimatedBudget.toStringAsFixed(2)} €',
              ),
              pw.SizedBox(height: 30),
              pw.Text(
                'Les prix sont estimatifs et peuvent varier selon les enseignes.',
              ),
            ],
          );
        },
      ),
    );

    final directory = await getApplicationDocumentsDirectory();

    final file = File('${directory.path}/devis-renovprix.pdf');

    await file.writeAsBytes(await pdf.save());

    return file;
  }
}
