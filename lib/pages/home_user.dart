import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_proyecto_segunda_evaluacion/imports.dart';

 FirebaseAuth _auth = FirebaseAuth.instance;
class HomeUser extends StatefulWidget {
  const HomeUser({super.key});

  @override
  State<HomeUser> createState() => _HomeUserState();
}

class _HomeUserState extends State<HomeUser> {
  @override
  Widget build(BuildContext context) {
    //Scaffold con boton de logout
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home User'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {

              try {
              await _auth.signOut();
              GoogleSignIn().signOut();
              } catch (e) {
                
              }

              
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => Login()),
              );
            },
          )
        ],
      ),
      body: const Placeholder(),
    );
  }
}