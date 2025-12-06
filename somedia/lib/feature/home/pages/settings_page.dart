import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:somedia/core/theme/theme_provider.dart';
import 'package:somedia/core/utils/size_config.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Settings'), centerTitle: true),
      body: Container(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(SizeConfig.defaultSize! * 0.5),
              margin: EdgeInsets.all(SizeConfig.defaultSize!),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.tertiary,
                borderRadius: BorderRadius.circular(16),
              ),
              child: ListTile(
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
            ),
          ],
        ),
      ),
    );
  }
}
