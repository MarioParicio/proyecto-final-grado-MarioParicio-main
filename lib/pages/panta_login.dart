import 'package:flutter_proyecto_segunda_evaluacion/imports.dart';

import 'package:flutter_proyecto_segunda_evaluacion/pages/home_admin.dart';

import 'home_user.dart';


final String USERS_COLLECTION = "users";
final String DEFAULT_ROLE = "user";
final String DEFAULT_PLATFORM = "app";

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
    DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection(USERS_COLLECTION).doc(FirebaseAuth.instance.currentUser!.uid).get();
    Map<String, dynamic>? data = userDoc.data() as Map<String, dynamic>?;
    if (data != null && data.containsKey('state') && data['state'] == 'inactive') {
      return 'Account is inactive. Please contact support.';
    } else if (!userDoc.exists) {
      FirebaseFirestore.instance.collection(USERS_COLLECTION).doc(FirebaseAuth.instance.currentUser!.uid).set({
        'email': FirebaseAuth.instance.currentUser!.email,
        'role': 'user',
        'name' : '',
        'state' : 'active',
        'logs' : [
          {
            'platform' : DEFAULT_PLATFORM,
            'date' : DateTime.now(),
          }
        ],
      });
    } else {
      // User document already exists, so just add a new log.
      FirebaseFirestore.instance.collection(USERS_COLLECTION).doc(FirebaseAuth.instance.currentUser!.uid).update({
        'logs' : FieldValue.arrayUnion([
          {
            'platform' : DEFAULT_PLATFORM,
            'date' : DateTime.now(),
          }
        ]),
      });
    }
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
      FirebaseFirestore.instance.collection(USERS_COLLECTION).doc(userCredential.user!.uid).set({
        'role': 'user',
        'email': userCredential.user!.email,
        'name' : '',
        'state' : 'active',
        'logs' : [
          {
            'platform' : DEFAULT_PLATFORM,
            'date' : DateTime.now(),
          }
        ],
      });

      
      
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
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection(USERS_COLLECTION).doc(FirebaseAuth.instance.currentUser!.uid).get();
      if(!userDoc.exists){
        FirebaseFirestore.instance.collection(USERS_COLLECTION).doc(FirebaseAuth.instance.currentUser!.uid).set({
          'email': FirebaseAuth.instance.currentUser!.email,
          'role': 'user',
          'name' : googleUser.displayName,
          'state' : 'active',
          'logs' : [
            {
              'platform' : DEFAULT_PLATFORM,
              'date' : DateTime.now(),
            }
          ],
        });
      } else {
        // User document already exists, so just add a new log.
        FirebaseFirestore.instance.collection(USERS_COLLECTION).doc(FirebaseAuth.instance.currentUser!.uid).update({
          'logs' : FieldValue.arrayUnion([
            {
              'platform' : DEFAULT_PLATFORM,
              'date' : DateTime.now(),
            }
          ]),
        });
        
        // If state is not active, logout the user and return an error message
        if (userDoc.get('state') != 'active') {
          await FirebaseAuth.instance.signOut();
          return 'Your account is inactive. Please contact support.';
        }
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

      //Obtner rol de firebase y redirigir a la pagina correspondiente
      FirebaseFirestore.instance.collection(USERS_COLLECTION).doc(FirebaseAuth.instance.currentUser!.uid).get().then((DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          if(documentSnapshot['role'] == 'admin'){
            Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => HomeAdmin(),
            ));
          }else{
            Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => HomeUser(),
            ));
          }
        } 
      });

      

      // Navigator.of(context).pushReplacement(MaterialPageRoute(
      //   builder: (context) => HomeUser(),
      // ));
    
    
  }, 
  onRecoverPassword: (String ) {  },
 
 
);
}



}