import 'package:flutter/material.dart';
void ShowSnakbar(BuildContext context, String message) {
    //this class used to use object snackbar to show message to the user
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }
