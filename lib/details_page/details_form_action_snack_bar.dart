import 'package:flutter/material.dart';

class DetailsFormActionSnackBar extends SnackBar {
  DetailsFormActionSnackBar({
    required BuildContext context,
    required String message,
    required Color backgroundColor,
    required Color textColor,
  }) : super(
         content: Text(
           message,
           style: TextStyle(color: textColor, fontSize: 16),
           textAlign: TextAlign.center,
         ),
         backgroundColor: backgroundColor,
         behavior: SnackBarBehavior.floating,
         margin: EdgeInsets.symmetric(
           horizontal: MediaQuery.of(context).size.width * 0.25,
         ),
         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
         elevation: 6,
         duration: const Duration(seconds: 1),
       );
}
