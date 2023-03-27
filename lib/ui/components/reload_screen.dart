import 'package:flutter/material.dart';

import '../helpers/i18n/resources.dart';

class ReloadScreen extends StatelessWidget {
  final String error;
  final VoidCallback reload;

  const ReloadScreen({
    super.key,
    required this.error,
    required this.reload,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(40.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            error,
            style: const TextStyle(
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 10,
          ),
          ElevatedButton(
            onPressed: reload,
            child: Text(R.strings.reload),
          )
        ],
      ),
    );
  }
}
