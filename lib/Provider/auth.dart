import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../model/http_Exption.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expredate;
  String _userId;
  Timer authTimer;
  bool get isAuth {
    return token != null;
  }

  String get userId {
    return _userId;
  }

  String get token {
    if (_expredate != null &&
        _expredate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  Future<void> sineup(String email, String password) async {
    const url =
        'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyDMyWSRAE21DYAJx8iTS8ubv_5BwLGL46M';
    try {
      final response = await http.post(url,
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true
          }));
      print(json.decode(response.body));
      final responsedata = json.decode(response.body);
      if (responsedata['error'] != null) {
        throw HttpExption(responsedata['error']['message']);
      }
      _token = responsedata['idToken'];
      _userId = responsedata['localId'];
      _expredate = DateTime.now()
          .add(Duration(seconds: int.parse(responsedata['expiresIn'])));
      outoLogOut();
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final userdata = json.encode({
        'token': _token,
        'userId': _userId,
        'expirdate': _expredate.toIso8601String()
      });
      prefs.setString('userData', userdata);
    } catch (error) {
      throw error;
    }
  }

  Future<void> sineIn(String email, String password) async {
    const url =
        'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyDMyWSRAE21DYAJx8iTS8ubv_5BwLGL46M';
    try {
      final response = await http.post(url,
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true
          }));
      print(json.decode(response.body));

      final responsedata = json.decode(response.body);
      if (responsedata['error'] != null) {
        throw HttpExption(responsedata['error']['message']);
      }
      _token = responsedata['idToken'];
      _userId = responsedata['localId'];
      _expredate = DateTime.now()
          .add(Duration(seconds: int.parse(responsedata['expiresIn'])));
      outoLogOut();
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final userdata = json.encode({
        'token': _token,
        'userId': _userId,
        'expirdate': _expredate.toIso8601String()
      });
      prefs.setString('userData', userdata);
    } catch (error) {
      throw error;
    }
  }

  Future<bool> tryToAoutoLogIn() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }
    final extracktdata =
        json.decode(prefs.getString('userdata')) as Map<String, Object>;
    final expiredate = DateTime.parse(extracktdata['expirdate']);
    if (expiredate.isBefore(DateTime.now())) {
      return false;
    }
    _token = extracktdata['token'];
    _userId = extracktdata['userId'];
    _expredate = expiredate;
    notifyListeners();
       outoLogOut();
    return true;
  }

  Future<void> logoout() async{
    _token = null;
    _expredate = null;
    _userId = null;
    if (authTimer != null) {
      authTimer.cancel();
      authTimer = null;
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
      prefs.remove('userData');// بيممسح الدادا الخاصة بالوج ان فقط
    // prefs.clear();//بيمسح كل الداتا المتخزنة مش الخاصة بالوج ان فقط 
  }

  void outoLogOut() {
    if (authTimer != null) {
      authTimer.cancel();
    }
    final timeForExpire = _expredate.difference(DateTime.now()).inSeconds;
    authTimer = Timer(Duration(seconds: timeForExpire), logoout);
  }
}
