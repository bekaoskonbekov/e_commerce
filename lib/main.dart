import 'package:e_commerce1/const/theme.dart';
import 'package:e_commerce1/firebase_helper/firebase_auth_helper.dart';
import 'package:e_commerce1/firebase_options.dart';
import 'package:e_commerce1/provider/app_provider.dart';
import 'package:e_commerce1/screens/auth/welcome_screen.dart';
import 'package:e_commerce1/widgets/custom_bottom_bar.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  Stripe.publishableKey =
      'pk_test_51LlqgDLkcWWZexAXFLmNzmawFaOwirNQ7drnCR276NXSmsAJxvdVznjT8dggfEus3A3kgPPqmX7YuB1py6YEyTeD00opxTE66f';
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppProvider(),
      child: MaterialApp(
        theme: themeData,
        debugShowCheckedModeBanner: false,
        title: 'Material App',
        home: StreamBuilder(
          stream: FirebaseAuthHelper.instance.getAuthChange,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return CustomBottomBar();
            }
            return Welcome();
          },
        ),
      ),
    );
  }
}
