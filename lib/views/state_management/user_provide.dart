import 'package:flutter/material.dart';
import 'package:sayhi/model/user.dart';
import 'package:sayhi/viewModel/auth_method.dart';

class UserProvide extends ChangeNotifier{
  User? _user;
  final AuthMethod _authMethod = AuthMethod();

  User get getUser => _user!;

  Future<void> refreshUser() async {
    User user = await _authMethod.getUserDetails();
    _user = user;
    notifyListeners();
  }
}