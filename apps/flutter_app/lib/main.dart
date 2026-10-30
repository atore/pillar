import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const PillarApp());
}

class PillarApp extends StatelessWidget {
  const PillarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pillar Sync Pro',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        useMaterial3: true,
      ),
      home: const SyncHomePage(),
    );
  }
}

class SyncHomePage extends StatefulWidget {
  const SyncHomePage({super.key});

  @override
  State<SyncHomePage> createState() => _SyncHomePageState();
}

class _SyncHomePageState extends State<SyncHomePage> {
  String role = 'slave';
  String status = 'offline';
  String message = 'Nessuna sincronizzazione ancora eseguita';

  Future<void> pingServer() async {
    try {
      final response = await http.get(Uri.parse('http://localhost:3000/sync/devices'));
      if (response.statusCode == 200) {
        setState(() {
          status = 'online';
          message = 'Connessione al master riuscita';
        });
      }
    } catch (_) {
      setState(() {
        status = 'offline';
        message = 'Server non raggiungibile';
      });
    }
  }

  Future<void> sendSyncEvent() async {
    final payload = {
      'deviceId': 'device-${DateTime.now().millisecondsSinceEpoch}',
      'role': role,
      'action': 'create',
      'entity': 'site',
      'payload': {
        'name': 'Cantiere Nord',
        'progress': 42,
      },
      'timestamp': DateTime.now().toIso8601String(),
      'version': 1,
    };

    try {
      final response = await http.post(
        Uri.parse('http://localhost:3000/sync/event'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(payload),
      );

      setState(() {
        message = response.statusCode == 200 || response.statusCode == 201
            ? 'Evento sincronizzato correttamente'
            : 'Errore di sincronizzazione (${response.statusCode})';
      });
    } catch (_) {
      setState(() {
        message = 'Impossibile inviare dato: server offline';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pillar Sync Pro'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Modalità device', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            SegmentedButton<String>(
              segments: const [
                ButtonSegment(value: 'master', label: Text('Master')),
                ButtonSegment(value: 'slave', label: Text('Slave')),
              ],
              selected: {role},
              onSelectionChanged: (selection) {
                setState(() {
                  role = selection.first;
                });
              },
            ),
            const SizedBox(height: 24),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Stato server: $status', style: Theme.of(context).textTheme.bodyLarge),
                    const SizedBox(height: 8),
                    Text(message),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: pingServer,
                  icon: const Icon(Icons.wifi_find_rounded),
                  label: const Text('Controlla sync'),
                ),
                const SizedBox(width: 12),
                FilledButton.icon(
                  onPressed: sendSyncEvent,
                  icon: const Icon(Icons.sync),
                  label: const Text('Invia sync'),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              role == 'master'
                  ? 'Master: può approvare e distribuire tutte le modifiche.'
                  : 'Slave: può inviare dati e ricevere solo autorizzazioni assegnate.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
