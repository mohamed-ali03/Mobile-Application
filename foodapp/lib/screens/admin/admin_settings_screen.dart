import 'package:flutter/material.dart';

class AdminSettingsScreen extends StatefulWidget {
  const AdminSettingsScreen({super.key});

  @override
  State<AdminSettingsScreen> createState() => _AdminSettingsScreenState();
}

class _AdminSettingsScreenState extends State<AdminSettingsScreen> {
  String _selectedLanguage = 'English';
  TimeOfDay _workStart = const TimeOfDay(hour: 9, minute: 0);
  TimeOfDay _workEnd = const TimeOfDay(hour: 17, minute: 0);
  bool _isDarkMode = false;
  bool _notificationsEnabled = true;
  bool _autoBackup = false;
  String _currency = 'USD';
  double _taxRate = 10.0;

  final List<String> _languages = [
    'English',
    'Spanish',
    'French',
    'German',
    'Arabic',
  ];
  final List<String> _currencies = ['USD', 'EUR', 'GBP', 'JPY', 'AED'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildSectionHeader('General Settings'),
          _buildLanguageSelector(),
          _buildThemeToggle(),

          const SizedBox(height: 24),
          _buildSectionHeader('Work Hours'),
          _buildWorkHours(),

          const SizedBox(height: 24),
          _buildSectionHeader('Business Settings'),
          _buildCurrencySelector(),
          _buildTaxRateSlider(),

          const SizedBox(height: 24),
          _buildSectionHeader('System Settings'),
          _buildNotificationToggle(),
          _buildAutoBackupToggle(),

          const SizedBox(height: 24),
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }

  Widget _buildLanguageSelector() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Language',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _selectedLanguage,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
              ),
              items: _languages.map((String language) {
                return DropdownMenuItem<String>(
                  value: language,
                  child: Text(language),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedLanguage = newValue!;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeToggle() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Dark Mode',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            Switch(
              value: _isDarkMode,
              onChanged: (bool value) {
                setState(() {
                  _isDarkMode = value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWorkHours() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Working Hours',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => _selectTime('start'),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: [
                          const Text(
                            'Start Time',
                            style: TextStyle(fontSize: 12),
                          ),
                          Text(
                            _workStart.format(context),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: GestureDetector(
                    onTap: () => _selectTime('end'),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: [
                          const Text(
                            'End Time',
                            style: TextStyle(fontSize: 12),
                          ),
                          Text(
                            _workEnd.format(context),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrencySelector() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Currency',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _currency,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
              ),
              items: _currencies.map((String currency) {
                return DropdownMenuItem<String>(
                  value: currency,
                  child: Text(currency),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _currency = newValue!;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTaxRateSlider() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Tax Rate',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                Text(
                  '${_taxRate.toStringAsFixed(1)}%',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Slider(
              value: _taxRate,
              min: 0,
              max: 30,
              divisions: 30,
              onChanged: (double value) {
                setState(() {
                  _taxRate = value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationToggle() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Push Notifications',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            Switch(
              value: _notificationsEnabled,
              onChanged: (bool value) {
                setState(() {
                  _notificationsEnabled = value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAutoBackupToggle() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Auto Backup',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            Switch(
              value: _autoBackup,
              onChanged: (bool value) {
                setState(() {
                  _autoBackup = value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Settings saved successfully!')),
              );
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            ),
            child: const Text(
              'Save Settings',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () {
              _resetToDefaults();
            },
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text(
              'Reset to Defaults',
              style: TextStyle(fontSize: 16),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _selectTime(String type) async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: type == 'start' ? _workStart : _workEnd,
    );

    if (picked != null) {
      setState(() {
        if (type == 'start') {
          _workStart = picked;
        } else {
          _workEnd = picked;
        }
      });
    }
  }

  void _resetToDefaults() {
    setState(() {
      _selectedLanguage = 'English';
      _workStart = const TimeOfDay(hour: 9, minute: 0);
      _workEnd = const TimeOfDay(hour: 17, minute: 0);
      _isDarkMode = false;
      _notificationsEnabled = true;
      _autoBackup = false;
      _currency = 'USD';
      _taxRate = 10.0;
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Settings reset to defaults')));
  }
}
