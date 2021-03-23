import 'dart:convert';
import 'package:flutter/cupertino.dart';

class GithubAPIUser {
  String login;
  String avatar;
  bool admin;

  GithubAPIUser({
    this.login,
    this.avatar,
    this.admin
  });

  GithubAPIUser.fromJson(dynamic json){
    login = json['login'];
    avatar = json["avatar_url"];
    admin = json["avatar_url"];
  }

}