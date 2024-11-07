import 'package:flutter/material.dart';

class HomeScreenAppModel {
  final List<String>? items;
  final Function()? launchFunction;
  final ImageProvider? image;
  final Function()? removeFunction;
  final String? packageName;

  HomeScreenAppModel(
      {this.items,
      this.launchFunction,
      this.image,
      this.removeFunction,
      this.packageName});
}
