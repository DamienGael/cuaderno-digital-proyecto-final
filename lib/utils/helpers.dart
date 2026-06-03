import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String formatDate(DateTime date) {
  return DateFormat('dd/MM/yyyy').format(date);
}

void showToast(BuildContext context, String message, {bool error = false}) {
  final color = error ? Colors.redAccent : Colors.green;
  final snackBar = SnackBar(
    content: Text(message),
    backgroundColor: color,
    duration: const Duration(seconds: 2),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
