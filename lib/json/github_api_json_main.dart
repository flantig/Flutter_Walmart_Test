import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'github_api_json_user.dart';

class GithubAPIMain {
  String title;
  String body;
  bool state;
  String id;
  GithubAPIUser user;

  GithubAPIMain({
    this.title,
    this.body,
    this.state,
    this.id,
    this.user
  });

  GithubAPIMain.fromJson(dynamic json){
    title = json['title'];
    body = json['body'];
    state = json['state'];
    id = json['id'];
    user = json['user'] != null ? GithubAPIUser.fromJson(json["user"]) : null;
  }

  }


