import 'package:flutter/material.dart';

class MovieUpdateNotifier {
  static final ValueNotifier<int> notifier = ValueNotifier(0);

  static void notify() {
    notifier.value++;
  }
}