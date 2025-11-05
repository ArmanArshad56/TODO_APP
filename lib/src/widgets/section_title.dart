import 'package:flutter/material.dart';

class SectionTitle extends StatelessWidget {
  final String text;
  final List<Widget> actions;
  const SectionTitle(this.text, {super.key, this.actions = const []});
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          text,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            letterSpacing: -0.5,
          ),
        ),
        const Spacer(),
        ...actions,
      ],
    );
  }
}
