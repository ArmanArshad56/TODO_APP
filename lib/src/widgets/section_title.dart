import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:todo_app/src/utils/responsive.dart';

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
            fontSize: Responsive.fontSize(
              context,
              mobile: 16,
              tablet: 18,
              desktop: 10,
            ).sp,
            letterSpacing: -0.5,
          ),
        ),
        const Spacer(),
        ...actions,
      ],
    );
  }
}
