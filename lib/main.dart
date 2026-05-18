import 'package:flutter/material.dart';

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
        colorSchemeSeed: Colors.blue,
        useMaterial3: true,
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
  final longueurController = TextEditingController();
  final largeurController = TextEditingController();

  double surface = 0;
  double total = 0;

  void calculer() {
    final longueur = double.tryParse(longueurController.text) ?? 0;
    final largeur = double.tryParse(largeurController.text) ?? 0;

    final resultat = longueur * largeur;
    final estimation = resultat * 42;

    setState(() {
      surface = resultat;
      total = estimation;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('RénovPrix'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Estimation rapide rénovation',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: longueurController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Longueur (m)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: largeurController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Largeur (m)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: calculer,
                child: const Text('Calculer le chantier'),
              ),
            ),
            const SizedBox(height: 24),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Surface : ${surface.toStringAsFixed(2)} m²'),
                    const SizedBox(height: 8),
                    Text(
                      'Budget estimé : ${total.toStringAsFixed(2)} €',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
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
