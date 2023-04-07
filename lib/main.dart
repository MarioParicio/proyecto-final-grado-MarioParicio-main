import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_proyecto_segunda_evaluacion/imports.dart';

import 'package:flutter_proyecto_segunda_evaluacion/pages/home_admin.dart';
import 'package:flutter_proyecto_segunda_evaluacion/pages/home_user.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
   await dotenv.load(fileName: ".env");
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: MyTheme.getTheme(),
      home: AnimatedSplashScreen(
        splash: Image.asset('assets/naranjitaHomosexual.png'),
        nextScreen: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // caso base mientras se espera la respuesta del Future
              return Scaffold(body: Center(child: CircularProgressIndicator()));
            } else if (snapshot.hasData) {
              // el usuario ya está logueado
              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance.collection('roles').doc(snapshot.data!.uid).get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // caso base mientras se espera la respuesta del Future
                    return Scaffold(body: Center(child: CircularProgressIndicator()));
                  } else if (snapshot.hasData) {
                    if (snapshot.data!.get('role') == 'admin') {
                      return HomeAdmin();
                    } else {
                      return HomeUser();
                    }
                  } else {
                    return Login();
                  }
                },
              );
            } else {
              // el usuario no está logueado
              return Login();
            }
          },
        ),
        splashTransition: SplashTransition.slideTransition,
        pageTransitionType: PageTransitionType.rightToLeft,
        backgroundColor: Colors.orange,
        duration: 2000,
      ),
    );
  }
}
