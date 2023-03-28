import 'package:flutter/material.dart';

import '../survey_answer_viewmodel.dart';
import 'active_icon.dart';
import 'disable_icon.dart';

class SurveyAnswer extends StatelessWidget {
  const SurveyAnswer({
    super.key,
    required this.item,
  });

  final SurveyAnswerViewModel item;

  @override
  Widget build(BuildContext context) => Column(
        children: _buildItems(context),
      );

  List<Widget> _buildItems(BuildContext context) {
    final List<Widget> children = [
      Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
        ),
        padding: const EdgeInsets.all(15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Text(
                  item.answer,
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            Text(
              item.percent,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColorDark,
              ),
            ),
            item.isCurrentAnswer ? const ActiveIcon() : const DisableIcon(),
          ],
        ),
      ),
      const Divider(
        height: 1,
      ),
    ];
    if (item.image != null) {
      children.insert(
        0,
        Image.network(
          item.image!,
          width: 40,
        ),
      );
    }
    return children;
  }
}
