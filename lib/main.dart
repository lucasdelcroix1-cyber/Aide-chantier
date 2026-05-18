import 'package:flutter/material.dart';

import 'core/models/renovation_project.dart';
import 'core/services/calculation_service.dart';

void main() {
  runApp(const RenovPrixApp());
}

class RenovPrixApp extends StatelessWidget {
  const RenovPrixApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'RénovPrix',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final nameController = TextEditingController();
  final lengthController = TextEditingController();
  final widthController = TextEditingController();
  final heightController = TextEditingController(text: '2.5');

  QualityLevel qualityLevel = QualityLevel.standard;
  RenovationType renovationType = RenovationType.carrelage;

  CalculationResult? result;

  void calculateProject() {
    final project = RenovationProject(
      name: nameController.text.isEmpty
          ? 'Projet rénovation'
          : nameController.text,
      roomType: RoomType.salon,
      renovationType: renovationType,
      length: double.tryParse(lengthController.text) ?? 0,
      width: double.tryParse(widthController.text) ?? 0,
      height: double.tryParse(heightController.text) ?? 2.5,
      wastePercent: 10,
      qualityLevel: qualityLevel,
      includeTools: true,
      includeConsumables: true,
      installedByArtisan: false,
    );

    setState(() {
      result = CalculationService.calculate(project);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('RénovPrix'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Assistant rénovation intérieure',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Nom du projet',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: lengthController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Longueur (m)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: widthController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Largeur (m)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: heightController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Hauteur (m)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<RenovationType>(
              value: renovationType,
              decoration: const InputDecoration(
                labelText: 'Type de rénovation',
                border: OutlineInputBorder(),
              ),
              items: RenovationType.values.map((type) {
                return DropdownMenuItem(
                  value: type,
                  child: Text(type.name),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  renovationType = value!;
                });
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<QualityLevel>(
              value: qualityLevel,
              decoration: const InputDecoration(
                labelText: 'Niveau de gamme',
                border: OutlineInputBorder(),
              ),
              items: QualityLevel.values.map((level) {
                return DropdownMenuItem(
                  value: level,
                  child: Text(level.name),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  qualityLevel = value!;
                });
              },
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: calculateProject,
                child: const Text('Calculer le projet'),
              ),
            ),
            const SizedBox(height: 24),
            if (result != null)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Surface : ${result!.surface.toStringAsFixed(2)} m²',
                      ),
                      Text(
                        'Matériaux : ${result!.materialQuantity.toStringAsFixed(2)} m²',
                      ),
                      Text(
                        'Colle : ${result!.glueQuantity.toStringAsFixed(2)} kg',
                      ),
                      Text(
                        'Joints : ${result!.jointQuantity.toStringAsFixed(2)} kg',
                      ),
                      Text(
                        'Peinture : ${result!.paintQuantity.toStringAsFixed(2)} L',
                      ),
                      Text(
                        'Plinthes : ${result!.skirtingQuantity.toStringAsFixed(2)} m',
                      ),
                      const Divider(),
                      Text(
                        'Budget estimé : ${result!.estimatedBudget.toStringAsFixed(2)} €',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
