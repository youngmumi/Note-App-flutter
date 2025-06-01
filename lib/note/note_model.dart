import 'package:flutter/material.dart';

class Note {
  final String id;
  String title;
  String content;
  String date;
  Color color;
  bool favorite;

  Note({
    required this.id,
    required this.title,
    required this.content,
    required this.date,
    required this.color,
    this.favorite = false,
  });
}
