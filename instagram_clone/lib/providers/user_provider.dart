import 'package:flutter/cupertino.dart';
import 'package:instagram_clone/models/user_model.dart';

import '../resources/auth_methods.dart';

class UserProvider with ChangeNotifier {
  UserModel? _user;
  final AuthMethods _authMethods = AuthMethods();

  UserModel? get getUser => _user;

  Future<void> refreshUser() async {
    UserModel user = await _authMethods.getUserDetail();
    _user = user;
    notifyListeners();
  }
}
