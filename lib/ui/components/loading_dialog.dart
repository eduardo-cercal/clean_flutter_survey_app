import 'package:flutter/material.dart';

void loadingDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => SimpleDialog(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            CircularProgressIndicator(),
            SizedBox(
              height: 10,
            ),
            Text(
              'Aguarde...',
              textAlign: TextAlign.center,
            ),
          ],
        )
      ],
    ),
  );
}
