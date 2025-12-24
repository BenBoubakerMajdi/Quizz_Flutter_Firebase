import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tp1_quizz_app/business_logic/blocs/quizz_cubit.dart';
import 'package:tp1_quizz_app/data/repositories/quizz_repository.dart'; // Import important !
import 'package:tp1_quizz_app/presentation/pages/home_page.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'firebase_options.dart'; // Généré par flutterfire configure

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialisation avec les options spécifiques à la plateforme
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Création de l'instance du repository
    final quizRepository = QuizRepository();

    return MultiBlocProvider(
      providers: [
        // On passe le repository au Cubit ici
        BlocProvider(create: (context) => QuizCubit(quizRepository)),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false, // Optionnel : enlève la bannière debug
        title: 'TP Flutter Avancé',
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('fr', 'FR'),
          Locale('en', 'US'),
        ],
        locale: const Locale('fr', 'FR'),
        theme: ThemeData(primarySwatch: Colors.blueGrey),
        home: const ProfileHomePage(),
      ),
    );
  }
}