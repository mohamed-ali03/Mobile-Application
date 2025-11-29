import 'package:flutter/material.dart';
import 'package:shoeshop/core/size_config.dart';
import 'package:shoeshop/utils/my_button.dart';

class IntroPage extends StatefulWidget {
  const IntroPage({super.key});

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(SizeConfig.defaultSize! * 2),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //image
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: SizeConfig.defaultSize! * 10,
                  horizontal: SizeConfig.defaultSize! * 5,
                ),
                child: Image.asset('assets/images/nikelogo.png'),
              ),
              // text
              Text(
                'Just Do It',
                style: TextStyle(
                  fontSize: SizeConfig.defaultSize! * 2,
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(height: SizeConfig.defaultSize! * 1),
              // text
              Text(
                'Brand new sneakers and custom nike made with premuim quailty',
                style: TextStyle(
                  fontSize: SizeConfig.defaultSize!,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: SizeConfig.defaultSize! * 3),
              // button
              MyButton(
                text: 'Shop Now',
                onPressed: () => Navigator.pushNamed(context, '/homepage'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
