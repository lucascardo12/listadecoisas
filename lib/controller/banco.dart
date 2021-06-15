import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:listadecoisa/model/coisas.dart';
import 'package:listadecoisa/model/compartilha.dart';
import 'package:listadecoisa/model/user.dart';
import 'package:listadecoisa/controller/global.dart';
import 'package:translator/translator.dart';

class BancoFire {
  final translator = GoogleTranslator();
  final FirebaseFirestore db = FirebaseFirestore.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  late UserP usuario;
  BancoFire();

  criaAlteraCoisas({required Coisas coisas, required UserP user}) {
    if (coisas.idFire == null) {
      coisas.idFire = db.collection('user').doc(user.id).collection('coisas').doc().id;
    }
    db.collection('user').doc(user.id).collection('coisas').doc(coisas.idFire).set(coisas.toJson());
  }

  Future<void> criaAlteraComp({required UserP user, required Compartilha coisas}) async {
    if (coisas.idFire == null) {
      coisas.idFire = db.collection('user').doc(user.id).collection('compartilha').doc().id;
    }
    db.collection('user').doc(user.id).collection('compartilha').doc(coisas.idFire).set(coisas.toJson());
  }

  getCoisas({required UserP user}) async {
    try {
      var result = await db.collection('user').doc(user.id).collection('coisas').get();
      return result.docs;
    } catch (e) {
      var auxi = await translator.translate(e.toString(), from: 'en', to: 'pt');
      Fluttertoast.showToast(
          msg: auxi.text,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 5,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 18.0);
      return null;
    }
  }

  getComps({required UserP user}) async {
    try {
      var result = await db.collection('user').doc(user.id).collection('compartilha').get();
      return result.docs;
    } catch (e) {
      var auxi = await translator.translate(e.toString(), from: 'en', to: 'pt');
      Fluttertoast.showToast(
          msg: auxi.text,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 5,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 18.0);
      return null;
    }
  }

  removeCoisas({required Coisas cat, required UserP user}) async {
    db.collection('user').doc(user.id).collection('coisas').doc(cat.idFire).delete();
  }

  Future<DocumentSnapshot> getComp({required String idUser, required String idLista}) async {
    DocumentSnapshot result =
        await db.collection('user').doc(idUser).collection('compartilha').doc(idLista).get();

    return result;
  }

  Future<DocumentSnapshot> getCoisa({required String idUser, required String idLista}) async {
    DocumentSnapshot result = await db.collection('user').doc(idUser).collection('coisas').doc(idLista).get();

    return result;
  }

  Future<DocumentSnapshot> getUser({required String idUser}) async {
    DocumentSnapshot result = await db.collection('user').doc(idUser).get();

    return result;
  }

  Future<String> criaUser(UserP user) async {
    try {
      var userFire = await _firebaseAuth.createUserWithEmailAndPassword(
          email: user.login ?? '', password: user.senha ?? '');

      user.id = userFire.user!.uid;
      db.collection('user').doc(userFire.user!.uid).set(user.toJson());
      return userFire.user!.uid;
    } catch (erro) {
      var auxi = await translator.translate(erro.toString(), from: 'en', to: 'pt');
      Fluttertoast.showToast(
          msg: auxi.text,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 5,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 18.0);
      return '';
    }
  }

  Future<UserP?> login({required String email, required String password}) async {
    try {
      var _value = await _firebaseAuth.signInWithEmailAndPassword(email: email.trim(), password: password);

      DocumentSnapshot result = await db.collection('user').doc(_value.user!.uid).get();

      UserP auxi = new UserP(
        login: result.get('login'),
        id: result.get('id'),
        nome: result.get('nome'),
        //senha: result.data()['senha'],
      );

      return auxi;
    } catch (e) {
      var auxi = await translator.translate(e.toString(), from: 'en', to: 'pt');
      Fluttertoast.showToast(
          msg: auxi.text,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 5,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 18.0);
      return null;
    }
  }

  Future<UserP?> criaUserAnonimo() async {
    try {
      UserP user = new UserP();
      var axui = prefs.getString('userAnonimo') ?? '';
      if (axui.isNotEmpty) {
        DocumentSnapshot result = await db.collection('user').doc(prefs.getString('userAnonimo')).get();

        user.id = result.get('id');
      } else {
        var _value = await _firebaseAuth.signInAnonymously();
        user.id = _value.user!.uid;
        db.collection('user').doc(user.id).set(user.toJson());
        prefs.setString('userAnonimo', user.id ?? '');
      }

      return user;
    } catch (e) {
      var auxi = await translator.translate(e.toString(), from: 'en', to: 'pt');
      Fluttertoast.showToast(
          msg: auxi.text,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 5,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 18.0);
      return null;
    }
  }

  void resetarSenha({required UserP user}) {
    _firebaseAuth.sendPasswordResetEmail(email: user.login ?? '');
  }

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth = await googleUser!.authentication;

    // Create a new credential
    final OAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }
}
