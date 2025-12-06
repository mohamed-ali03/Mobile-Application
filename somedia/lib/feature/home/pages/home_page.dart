import 'package:flutter/material.dart';
import 'package:somedia/core/common_functions.dart';
import 'package:somedia/core/utils/size_config.dart';
import 'package:somedia/core/widgets/custom_text_field.dart';
import 'package:somedia/feature/home/database_service/database_service.dart';
import 'package:somedia/feature/home/widgets/custom_drawer.dart';
import 'package:somedia/feature/home/widgets/post_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController postController = TextEditingController();

  void sendPost(BuildContext context) async {
    try {
      if (postController.text.isNotEmpty) {
        await DatabaseService.sendPost(postController.text);
        postController.clear();
      }
    } catch (e) {
      if (!mounted) return;
      showCustomDialog(e.toString(), context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home page'), centerTitle: true),
      drawer: CustomDrawer(),
      body: Column(
        children: [
          // creating post section
          _creatingPostSection(),

          // showing the current posts
          Expanded(child: _showCurrentPosts()),
        ],
      ),
    );
  }

  //
  Widget _creatingPostSection() {
    return Padding(
      padding: EdgeInsets.all(SizeConfig.defaultSize!),
      child: Row(
        children: [
          Expanded(
            child: CustomTextField(
              controller: postController,
              hint: 'Let\'ts create new post...',
              obscureText: false,
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: SizeConfig.defaultSize!),
            decoration: BoxDecoration(
              color: Colors.greenAccent,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              onPressed: () => sendPost(context),
              icon: Icon(Icons.send),
            ),
          ),
        ],
      ),
    );
  }

  Widget _showCurrentPosts() {
    return StreamBuilder(
      stream: DatabaseService.getPosts(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: const Text('ERROR'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(
              color: Theme.of(context).colorScheme.inversePrimary,
            ),
          );
        }

        return ListView(
          children: snapshot.data!
              .map<Widget>((post) => PostTile(post: post))
              .toList(),
        );
      },
    );
  }
}
