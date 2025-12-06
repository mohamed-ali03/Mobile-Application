import 'package:flutter/material.dart';
import 'package:somedia/core/utils/size_config.dart';

class PostTile extends StatelessWidget {
  final Map<String, dynamic> post;
  const PostTile({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        left: SizeConfig.defaultSize!,
        right: SizeConfig.defaultSize!,
        top: SizeConfig.defaultSize!,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.tertiary,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        title: Text(post['postContent']),
        subtitle: Text(post['makerEmail']),
      ),
    );
  }
}
