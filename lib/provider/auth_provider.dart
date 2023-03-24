import 'package:flutter_proyecto_segunda_evaluacion/imports.dart';

class AuthProvider extends ChangeNotifier {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  AuthType _authType = AuthType.signIn;
  AuthType get authType => _authType;

  setAuthType() {
    _authType =
        _authType == AuthType.signIn ? AuthType.signUp : AuthType.signIn;
  }

  // REGISTRAR UN USUARIO
  registrarUsuario(BuildContext context) async {
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('La contraseña es muy débil'),
          backgroundColor: Colors.red,
        ));
      } else if (e.code == 'email-already-in-use') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Este correo ya existe'),
          backgroundColor: Colors.red,
        ));
      }
    } catch (e) {
      print(e);
    }
    notifyListeners();
  }

  // LOGUEAR USUARIO CON EMAIL/PASSWORD
}

enum AuthType { signUp, signIn }
