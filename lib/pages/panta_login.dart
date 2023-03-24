import 'package:flutter_proyecto_segunda_evaluacion/imports.dart';

import 'package:flutter_proyecto_segunda_evaluacion/pages/home_admin.dart';

import 'home_user.dart';


String role = '';
class Login extends StatelessWidget {
  Duration get loginTime => Duration(milliseconds: 2250);
  


   @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      hideForgotPasswordButton: true,
      logo: AssetImage('assets/naranjitaHomosexual.png'),
      onLogin: (loginData) async {
        try {
          UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
              email: loginData.name,
              password: loginData.password,
      );
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('roles').doc(userCredential.user!.uid).get();
      String role = userDoc.get('role');

      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return 'User not exists';
      } else if (e.code == 'wrong-password') {
        return 'Password does not match';
      }
      return 'Error: ${e.message}';
    } catch (e) {
      return 'Error: ${e.toString()}';
    }
  },
  onSignup: (signupData) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: signupData.name!,
          password: signupData.password!,
      );
      FirebaseFirestore.instance.collection('roles').doc(userCredential.user!.uid).set({
        'role': 'user',
      });
      role = 'user';
      
      
      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        return 'The account already exists for that email.';
      }
      return 'Error: ${e.message}';
    } catch (e) {
      return 'Error: ${e.toString()}';
    }
  },
  
  loginProviders: <LoginProvider>[

    LoginProvider(
    
      icon: FontAwesomeIcons.google,
      //Color
      
      
      

          label: 'Google',
          callback: () async {
            try {
              final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
              final GoogleSignInAuthentication googleAuth = await googleUser!.authentication;
              final OAuthCredential credential = GoogleAuthProvider.credential(
                accessToken: googleAuth.accessToken,
                idToken: googleAuth.idToken,
              );
              await FirebaseAuth.instance.signInWithCredential(credential);
              DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('roles').doc(FirebaseAuth.instance.currentUser!.uid).get();
              if(userDoc.exists){
                role = userDoc.get('role');
              }else{
                FirebaseFirestore.instance.collection('roles').doc(FirebaseAuth.instance.currentUser!.uid).set({
                  'role': 'user',
                });
                role = 'user';
      }
      
              return null;
            } on FirebaseAuthException catch (e) {
              if (e.code == 'account-exists-with-different-credential') {
                return 'The account already exists with a different credential.';
              } else if (e.code == 'invalid-credential') {
                return 'Error occurred while accessing credentials. Try again.';
              }
              return 'Error: ${e.message}';
            } catch (e) {
              return 'Error: ${e.toString()}';
            }}
    ),
    

  ],
  onSubmitAnimationCompleted: () {

    if (role == 'admin') {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => HomeAdmin(),
      ));
    } else {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => HomeUser(),
      ));
    }
    
  }, 
  onRecoverPassword: (String ) {  },
 
 
);
}



}