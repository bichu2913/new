import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sunrule/view/categories_screen/category.dart';


class SplashScreen extends StatefulWidget {
  // ignore: use_key_in_widget_constructors
  const SplashScreen({Key? key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
   void initState() {
    allcatgory(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/splash.avif'),
              fit: BoxFit.fitHeight,
            ),
          ),
        ),
        
      ],
    );
  }
}
allcatgory(BuildContext context) async {
  await Future.delayed(const Duration(seconds: 4));
  // ignore: use_build_context_synchronously
  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) =>  const Allcategory()));
}