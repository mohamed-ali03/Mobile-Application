import 'package:flutter/material.dart';

TabBar adminTabBar(
  TabController controller,
  Function(int) onTap,
  List<String> tapTitles,
) {
  return TabBar(
    isScrollable: true,
    labelColor: Colors.orange,
    unselectedLabelColor: Colors.grey,
    indicatorColor: Colors.orange,
    controller: controller,
    dividerColor: Colors.grey.shade400,
    onTap: onTap,
    tabs: tapTitles.map((title) => Tab(text: title)).toList(),
  );
}
