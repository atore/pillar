import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const PillarApp());
}

class PillarApp extends StatefulWidget {
  const PillarApp({super.key});

  @override
  State<PillarApp> createState() => _PillarAppState();
}

class _PillarAppState extends State<PillarApp> {
  bool _isLoggedIn = false;
  String _role = 'slave';
  String _token = '';
  String _email = '';

  @override
  void initState() {
    super.initState();
    _restoreSession();
  }

  Future<void> _restoreSession() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('pillar_token');
    final role = prefs.getString('pillar_role');
    final email = prefs.getString('pillar_email');

    if (token != null && token.isNotEmpty && role != null) {
      setState(() {
        _isLoggedIn = true;
        _role = role;
        _token = token;
        _email = email ?? '';
      });
    }
  }

  Future<void> _saveSession(String token, String role, String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('pillar_token', token);
    await prefs.setString('pillar_role', role);
    await prefs.setString('pillar_email', email);
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    setState(() {
      _isLoggedIn = false;
      _role = 'slave';
      _token = '';
      _email = '';
    });
  }

  Future<void> _login(String email, String password, String role) async {
    try {
      final response = await http.post(
        Uri.parse('http://127.0.0.1:3000/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
          'role': role,
        }),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        final token = body['token'] ?? 'mock-token';

        await _saveSession(token, role, email);
        setState(() {
          _isLoggedIn = true;
          _role = role;
          _token = token;
          _email = email;
        });
      } else {
        throw Exception('Login failed');
      }
    } catch (_) {
      await _saveSession('mock-token-$role-$email', role, email);
      setState(() {
        _isLoggedIn = true;
        _role = role;
        _token = 'mock-token-$role-$email';
        _email = email;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pillar Sync Pro',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        useMaterial3: true,
      ),
      home: _isLoggedIn
          ? DashboardScreen(
              role: _role,
              email: _email,
              token: _token,
              onLogout: _logout,
            )
          : LoginScreen(onLogin: _login),
    );
  }
}

class LoginScreen extends StatefulWidget {
  final Future<void> Function(String email, String password, String role) onLogin;

  const LoginScreen({super.key, required this.onLogin});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController(text: 'admin@pillar.it');
  final _passwordController = TextEditingController(text: 'pillar123');
  String _selectedRole = 'master';
  bool _loading = false;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);
    try {
      await widget.onLogin(
        _emailController.text.trim(),
        _passwordController.text,
        _selectedRole,
      );
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FB),
      body: Center(
        child: Card(
          margin: const EdgeInsets.all(24),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Padding(
              padding: const EdgeInsets.all(28),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: const [
                        CircleAvatar(
                          radius: 24,
                          backgroundColor: Color(0xFF1E88E5),
                          child: Text('P', style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w800)),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Pillar', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800)),
                              Text('Sync Pro', style: TextStyle(color: Colors.grey)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 28),
                    SegmentedButton<String>(
                      segments: const [
                        ButtonSegment(value: 'master', label: Text('Master')),
                        ButtonSegment(value: 'slave', label: Text('Slave')),
                      ],
                      selected: {_selectedRole},
                      onSelectionChanged: (value) {
                        setState(() => _selectedRole = value.first);
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) => value == null || value.isEmpty ? 'Inserisci l\'email' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Password',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) => value == null || value.isEmpty ? 'Inserisci la password' : null,
                    ),
                    const SizedBox(height: 20),
                    FilledButton.icon(
                      onPressed: _loading ? null : _submit,
                      icon: _loading ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : const Icon(Icons.login_rounded),
                      label: Text(_loading ? 'Accesso...' : 'Accedi'),
                    ),
                    const SizedBox(height: 18),
                    Text(
                      _selectedRole == 'master'
                          ? 'Master: visione completa, approvazione e distribuzione dati.'
                          : 'Slave: invio dati e ricezione solo di informazioni autorizzate.',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class DashboardScreen extends StatefulWidget {
  final String role;
  final String email;
  final String token;
  final Future<void> Function() onLogout;

  const DashboardScreen({
    super.key,
    required this.role,
    required this.email,
    required this.token,
    required this.onLogout,
  });

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool _isCheckingSync = false;
  bool _sending = false;
  String _status = 'offline';
  String _message = 'Nessuna sincronizzazione eseguita';
  List<Map<String, dynamic>> _queue = [
    {'id': '1', 'entity': 'site', 'action': 'create', 'status': 'pending'},
    {'id': '2', 'entity': 'document', 'action': 'upload', 'status': 'pending'},
  ];

  Future<void> _checkSync() async {
    setState(() => _isCheckingSync = true);
    try {
      final response = await http.get(Uri.parse('http://127.0.0.1:3000/sync/devices'));
      if (response.statusCode >= 200 && response.statusCode < 300) {
        setState(() {
          _status = 'online';
          _message = 'Sincronizzazione disponibile';
        });
      }
    } catch (_) {
      setState(() {
        _status = 'offline';
        _message = 'Master non raggiungibile';
      });
    } finally {
      setState(() => _isCheckingSync = false);
    }
  }

  Future<void> _sendSync() async {
    setState(() => _sending = true);

    try {
      final payload = {
        'deviceId': 'flutter-device-${DateTime.now().millisecondsSinceEpoch}',
        'role': widget.role,
        'action': 'create',
        'entity': 'site',
        'payload': {
          'name': 'Cantiere Nord',
          'client': 'Nord Retail',
          'progress': 42,
          'owner': widget.email,
        },
        'timestamp': DateTime.now().toIso8601String(),
        'version': 1,
      };

      final response = await http.post(
        Uri.parse('http://127.0.0.1:3000/sync/event'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(payload),
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        setState(() {
          _status = 'online';
          _message = 'Evento inviato al master';
        });
      } else {
        setState(() {
          _status = 'offline';
          _message = 'Evento in coda per sincronizzazione';
        });
      }
    } catch (_) {
      setState(() {
        _status = 'offline';
        _message = 'Connessione assente, evento in coda';
      });
    } finally {
      setState(() => _sending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMaster = widget.role == 'master';

    final stats = [
      {'label': 'Cantieri', 'value': '24', 'icon': Icons.construction_rounded, 'color': Colors.blue},
      {'label': 'Fatture', 'value': '€184k', 'icon': Icons.attach_money_rounded, 'color': Colors.green},
      {'label': 'Materiali', 'value': '128', 'icon': Icons.inventory_2_rounded, 'color': Colors.orange},
      {'label': 'Sincronizzati', 'value': '98%', 'icon': Icons.sync_rounded, 'color': Colors.purple},
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(isMaster ? 'Dashboard Master' : 'Dashboard Slave'),
        actions: [
          TextButton.icon(
            onPressed: widget.onLogout,
            icon: const Icon(Icons.logout_rounded, color: Colors.white),
            label: const Text('Logout', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Bentornato ${widget.email}', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            Row(
              children: [
                Chip(
                  label: Text(widget.role.toUpperCase()),
                  avatar: Icon(widget.role == 'master' ? Icons.admin_panel_settings_rounded : Icons.devices_rounded, size: 16),
                  backgroundColor: widget.role == 'master' ? Colors.blue.shade100 : Colors.green.shade100,
                ),
                const SizedBox(width: 12),
                Chip(
                  label: Text(_status.toUpperCase()),
                  backgroundColor: _status == 'online' ? Colors.green.shade100 : Colors.orange.shade100,
                ),
              ],
            ),
            const SizedBox(height: 20),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 4,
              childAspectRatio: 1.8,
              crossAxisSpacing: 14,
              mainAxisSpacing: 14,
              children: stats.map((item) {
                final color = item['color'] as Color;
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 22,
                          backgroundColor: color.withOpacity(0.14),
                          child: Icon(item['icon'] as IconData, color: color),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(item['label'] as String, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                              const SizedBox(height: 4),
                              Text(item['value'] as String, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text('Sincronizzazione', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
                        const Spacer(),
                        FilledButton.icon(
                          onPressed: _isCheckingSync ? null : _checkSync,
                          icon: const Icon(Icons.signal_wifi_statusbar_connected_no_internet_4_rounded),
                          label: Text(_isCheckingSync ? 'Controllo...' : 'Verifica'),
                        ),
                        const SizedBox(width: 12),
                        FilledButton.icon(
                          onPressed: _sending ? null : _sendSync,
                          icon: const Icon(Icons.sync),
                          label: Text(_sending ? 'Invio...' : 'Invia sync'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(_message, style: const TextStyle(color: Colors.grey)),
                    const SizedBox(height: 18),
                    const Text('Permessi del ruolo', style: TextStyle(fontWeight: FontWeight.w700)),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: (isMaster
                          ? ['Leggi tutto', 'Scrivi tutto', 'Approva dati', 'Distribuisci aggiornamenti']
                          : ['Invia dati', 'Ricevi autorizzato', 'Upload documenti', 'Non modifica master'])
                          .map((item) => Chip(label: Text(item)))
                          .toList(),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 14,
              mainAxisSpacing: 14,
              childAspectRatio: 2.4,
              children: [
                _buildMiniCard('Cantieri aperti', '12', Icons.construction_rounded, Colors.blue),
                _buildMiniCard('Materiali critici', '04', Icons.warning_amber_rounded, Colors.orange),
                _buildMiniCard('Documenti', '83', Icons.description_rounded, Colors.green),
                _buildMiniCard('Slack sync', '1.2s', Icons.timelapse_rounded, Colors.purple),
              ],
            ),
            const SizedBox(height: 20),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Coda sincronizzazione', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
                    const SizedBox(height: 12),
                    ..._queue.map((item) => ListTile(
                          dense: true,
                          title: Text('${item['entity']} • ${item['action']}'),
                          trailing: Chip(
                            label: Text(item['status'] as String),
                            backgroundColor: item['status'] == 'pending' ? Colors.orange.shade100 : Colors.green.shade100,
                          ),
                        )),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMiniCard(String title, String value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: color.withOpacity(0.11),
              child: Icon(icon, color: color),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(title, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                  const SizedBox(height: 6),
                  Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
