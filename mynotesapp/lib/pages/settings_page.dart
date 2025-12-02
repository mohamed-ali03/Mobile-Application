import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mynotesapp/theme/theme_provider.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
          style: TextStyle(
            fontSize: 40,
            color: Theme.of(context).colorScheme.inversePrimary,
          ),
        ),
        centerTitle: true,
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Container(
        padding: EdgeInsets.all(25),
        decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary),
        child: Column(
          children: [
            ListTile(
              title: Text('Theme'),
              trailing: CupertinoSwitch(
                value: Provider.of<ThemeProvider>(
                  context,
                  listen: false,
                ).isDarkMode(),
                onChanged: (_) {
                  Provider.of<ThemeProvider>(
                    context,
                    listen: false,
                  ).toggleTheme();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
