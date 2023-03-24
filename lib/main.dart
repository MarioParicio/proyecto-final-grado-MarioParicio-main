








import 'package:flutter_proyecto_segunda_evaluacion/imports.dart';

import 'package:flutter_proyecto_segunda_evaluacion/pages/home_admin.dart';
import 'package:flutter_proyecto_segunda_evaluacion/pages/home_user.dart';





Future<void> main() async {
  
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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: MyTheme.getTheme(),
      home: AnimatedSplashScreen(
        
        splash: Image.asset('assets/naranjitaHomosexual.png'),
        
        
        
        nextScreen: StreamBuilder(
  stream: FirebaseAuth.instance.authStateChanges(),
  builder: (context, snapshot) {
    if (snapshot.hasData) {
      // El usuario ya está logueado
      return StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection('roles').doc(snapshot.data!.uid).snapshots(),
        builder: (context, userSnapshot) {
          if (!userSnapshot.hasData) {
            // El documento de usuario aún no está disponible
            return Placeholder();
          } else {
            // Obtener el rol del usuario del documento de usuario
            String role = userSnapshot.data!.get('role');
            if (role == 'admin') {
              // El usuario tiene el rol de administrador
              return HomeAdmin();
            } else {
              // El usuario tiene el rol de usuario
              return HomeUser();
            }
          }
        },
      );
    } else {
      // El usuario no está logueado
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