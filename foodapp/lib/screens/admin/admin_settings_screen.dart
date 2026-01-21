import 'package:flutter/material.dart';
import 'package:foodapp/l10n/app_localizations.dart';
import 'package:foodapp/screens/common/settings_screen.dart';

class AdminSettingsScreen extends StatefulWidget {
  const AdminSettingsScreen({super.key});

  @override
  State<AdminSettingsScreen> createState() => _AdminSettingsScreenState();
}

class _AdminSettingsScreenState extends State<AdminSettingsScreen> {
  TimeOfDay _workStart = const TimeOfDay(hour: 9, minute: 0);
  TimeOfDay _workEnd = const TimeOfDay(hour: 17, minute: 0);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).t('settings')),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          SettingsScreen(),

          const SizedBox(height: 24),
          _buildSectionHeader(AppLocalizations.of(context).t('workingHours')),
          _buildWorkHours(),
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

  Widget _buildWorkHours() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
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
                      Text(
                        AppLocalizations.of(context).t('startTime'),
                        style: const TextStyle(fontSize: 12),
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
                      Text(
                        AppLocalizations.of(context).t('endTime'),
                        style: const TextStyle(fontSize: 12),
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
      ),
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
}
