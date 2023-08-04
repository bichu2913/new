import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sunrule/view/splash.dart';
import 'package:firebase_core/firebase_core.dart';

import 'bloc/cart/cart_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => CartBloc(),
        ),
      ],
      child: MaterialApp(
        title: 'SunRule',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        debugShowCheckedModeBanner: false,
        home: const SplashScreen(),
      ),
    );
  }
}
