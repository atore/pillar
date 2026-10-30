import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const PillarApp());
}

class PillarApp extends StatefulWidget {
  const PillarApp({super.key});

  @override
  State<PillarApp> createState() => _PillarAppState();
}

class _PillarAppState extends State<PillarApp> {
  bool _loggedIn = false;
  String _role = 'slave';
  String _email = '';
  String _token = '';

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

    if (token != null && role != null && email != null) {
      setState(() {
        _loggedIn = true;
        _token = token;
        _role = role;
        _email = email;
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
      _loggedIn = false;
      _token = '';
      _role = 'slave';
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

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final token = data['token'] as String? ?? 'mock-token';
        await _saveSession(token, role, email);
        setState(() {
          _loggedIn = true;
          _role = role;
          _email = email;
          _token = token;
        });
      } else {
        throw Exception('Login failed');
      }
    } catch (_) {
      await _saveSession('mock-token-$role-$email', role, email);
      setState(() {
        _loggedIn = true;
        _role = role;
        _email = email;
        _token = 'mock-token-$role-$email';
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
      home: _loggedIn
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
  String _role = 'master';
  bool _loading = false;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      await widget.onLogin(_emailController.text.trim(), _passwordController.text, _role);
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEEF5FF),
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
                          radius: 25,
                          backgroundColor: Color(0xFF1E88E5),
                          child: Text('P', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 28)),
                        ),
                        SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Pillar', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800)),
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
                      selected: {_role},
                      onSelectionChanged: (selection) {
                        setState(() => _role = selection.first);
                      },
                    ),
                    const SizedBox(height: 22),
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(labelText: 'Email', border: OutlineInputBorder()),
                      validator: (value) => (value == null || value.isEmpty) ? 'Inserisci email' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(labelText: 'Password', border: OutlineInputBorder()),
                      validator: (value) => (value == null || value.isEmpty) ? 'Inserisci password' : null,
                    ),
                    const SizedBox(height: 20),
                    FilledButton.icon(
                      onPressed: _loading ? null : _submit,
                      icon: _loading ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : const Icon(Icons.login_rounded),
                      label: Text(_loading ? 'Accesso...' : 'Accedi'),
                    ),
                    const SizedBox(height: 18),
                    Text(
                      _role == 'master'
                          ? 'Master: vede tutto, approva e distribuisce le modifiche.'
                          : 'Slave: invia dati e riceve solo ciò che è stato autorizzato.',
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
  int _currentIndex = 0;
  bool _checking = false;
  bool _sending = false;
  String _status = 'offline';
  String _message = 'Nessuna sincronizzazione eseguita';

  final List<Map<String, dynamic>> _syncQueue = [
    {'entity': 'site', 'action': 'create', 'status': 'pending'},
    {'entity': 'document', 'action': 'upload', 'status': 'pending'},
    {'entity': 'material', 'action': 'update', 'status': 'pending'},
  ];

  final List<Map<String, dynamic>> _sites = [
    {'name': 'Residenza Vela', 'client': 'Vela Immobiliare', 'progress': 78, 'budget': 420000},
    {'name': 'Centro commerciale Nord', 'client': 'Nord Retail', 'progress': 58, 'budget': 680000},
    {'name': 'Palazzo San Marco', 'client': 'San Marco Group', 'progress': 66, 'budget': 540000},
  ];

  final List<Map<String, dynamic>> _materials = [
    {'name': 'Cemento', 'qty': '120 sacchi', 'status': 'OK'},
    {'name': 'Travertino', 'qty': '34 pannelli', 'status': 'Basso'},
    {'name': 'Vernice esterna', 'qty': '18 bidoni', 'status': 'Basso'},
  ];

  final List<Map<String, dynamic>> _team = [
    {'name': 'Giulia Rossi', 'role': 'Direzione lavori', 'shift': 'A'},
    {'name': 'Marco Bianchi', 'role': 'Capo cantiere', 'shift': 'B'},
    {'name': 'Stefania Neri', 'role': 'Ufficio tecnico', 'shift': 'A'},
  ];

  Future<void> _checkSync() async {
    setState(() => _checking = true);
    try {
      final response = await http.get(Uri.parse('http://127.0.0.1:3000/sync/devices'));
      if (response.statusCode >= 200 && response.statusCode < 300) {
        setState(() {
          _status = 'online';
          _message = 'Server raggiungibile';
        });
      }
    } catch (_) {
      setState(() {
        _status = 'offline';
        _message = 'Master non raggiungibile';
      });
    } finally {
      setState(() => _checking = false);
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
          'name': 'Nuovo cantiere',
          'client': 'Cliente demo',
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
          _message = 'Dati inviati al master';
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
        _message = 'Connessione offline: evento in coda';
      });
    } finally {
      setState(() => _sending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMaster = widget.role == 'master';
    final pages = <Widget>[
      _buildOverview(isMaster),
      _buildSites(),
      _buildMaterials(),
      _buildSyncPanel(),
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
      body: pages[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) => setState(() => _currentIndex = index),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.dashboard_rounded), label: 'Dashboard'),
          NavigationDestination(icon: Icon(Icons.construction_rounded), label: 'Cantieri'),
          NavigationDestination(icon: Icon(Icons.inventory_2_rounded), label: 'Materiali'),
          NavigationDestination(icon: Icon(Icons.sync_rounded), label: 'Sync'),
        ],
      ),
    );
  }

  Widget _buildOverview(bool isMaster) {
    final stats = [
      {'label': 'Cantieri', 'value': '24', 'icon': Icons.construction_rounded, 'color': Colors.blue},
      {'label': 'Fatturato', 'value': '€184k', 'icon': Icons.attach_money_rounded, 'color': Colors.green},
      {'label': 'Materiali', 'value': '128', 'icon': Icons.inventory_2_rounded, 'color': Colors.orange},
      {'label': 'Sync', 'value': '98%', 'icon': Icons.sync_rounded, 'color': Colors.purple},
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Bentornato ${widget.email}', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          Row(
            children: [
              Chip(
                label: Text(widget.role.toUpperCase()),
                backgroundColor: isMaster ? Colors.blue.shade100 : Colors.green.shade100,
              ),
              const SizedBox(width: 12),
              Chip(
                label: Text(_status.toUpperCase()),
                backgroundColor: _status == 'online' ? Colors.green.shade100 : Colors.orange.shade100,
              ),
            ],
          ),
          const SizedBox(height: 18),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 14,
            mainAxisSpacing: 14,
            childAspectRatio: 2.3,
            children: stats.map((item) {
              final color = item['color'] as Color;
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: color.withOpacity(0.12),
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
                  const Text('Permessi principali', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: (isMaster
                        ? ['Leggi tutto', 'Scrivi tutto', 'Approva dati', 'Sincronizza globale']
                        : ['Invia dati', 'Legge autorizzato', 'Upload documenti', 'Riceve assegnato'])
                        .map((item) => Chip(label: Text(item)))
                        .toList(),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Team di cantiere', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 12),
                  ..._team.map((member) => ListTile(
                        dense: true,
                        leading: CircleAvatar(
                          child: Text(member['name'].toString().split(' ').map((p) => p[0]).take(2).join()),
                        ),
                        title: Text(member['name'] as String),
                        subtitle: Text(member['role'] as String),
                        trailing: Chip(label: Text('Turno ${member['shift']}')),
                      )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSites() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(18),
      child: Column(
        children: [
          Row(
            children: [
              const Expanded(child: Text('Cantieri', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800))),
              FilledButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.add_rounded),
                label: const Text('Nuovo'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ..._sites.map((site) {
            final progress = site['progress'] as int;
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(child: Text(site['name'] as String, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18))),
                        Chip(label: Text('$progress%')),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text('Cliente: ${site['client']}'),
                    const SizedBox(height: 6),
                    Text('Budget: ${site['budget']} €'),
                    const SizedBox(height: 12),
                    LinearProgressIndicator(value: progress / 100, minHeight: 10),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildMaterials() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Materiali', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
          const SizedBox(height: 16),
          ..._materials.map((item) => Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: item['status'] == 'OK' ? Colors.green.shade100 : Colors.orange.shade100,
                    child: Icon(item['status'] == 'OK' ? Icons.check_rounded : Icons.warning_amber_rounded),
                  ),
                  title: Text(item['name'] as String),
                  subtitle: Text(item['qty'] as String),
                  trailing: Chip(label: Text(item['status'] as String)),
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildSyncPanel() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Sincronizzazione', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
          const SizedBox(height: 14),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Stato: $_status', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 8),
                  Text(_message, style: const TextStyle(color: Colors.grey)),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      FilledButton.icon(
                        onPressed: _checking ? null : _checkSync,
                        icon: const Icon(Icons.signal_wifi_statusbar_connected_no_internet_4_rounded),
                        label: Text(_checking ? 'Verifica...' : 'Verifica sync'),
                      ),
                      const SizedBox(width: 12),
                      FilledButton.icon(
                        onPressed: _sending ? null : _sendSync,
                        icon: const Icon(Icons.sync_rounded),
                        label: Text(_sending ? 'Invio...' : 'Invia cambio'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text('Coda di sincronizzazione', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
          const SizedBox(height: 12),
          ..._syncQueue.map((item) => Card(
                margin: const EdgeInsets.only(bottom: 10),
                child: ListTile(
                  title: Text('${item['entity']} • ${item['action']}'),
                  trailing: Chip(
                    label: Text(item['status'] as String),
                    backgroundColor: item['status'] == 'pending' ? Colors.orange.shade100 : Colors.green.shade100,
                  ),
                ),
              )),
        ],
      ),
    );
  }
}
