// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:todo_app/src/theme/app_theme.dart';
import 'package:todo_app/src/utils/responsive.dart';

class SearchField extends StatelessWidget {
  final String hint;
  final ValueChanged<String>? onChanged;
  const SearchField({super.key, this.hint = 'Search', this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10.r,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        onChanged: onChanged,
        style: TextStyle(fontSize: 16.sp),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
            color: AppTheme.textTertiary,
            fontSize: Responsive.fontSize(
              context,
              mobile: 16,
              tablet: 16,
              desktop: 16,
            ).sp,
          ),
          prefixIcon: Padding(
            padding: Responsive.padding(
              context,
              mobile: 16,
              tablet: 16,
              desktop: 16,
            ),
            child: Icon(
              Icons.search_rounded,
              color: AppTheme.textSecondary,
              size: Responsive.fontSize(
                context,
                mobile: 16,
                tablet: 12,
                desktop: 14,
              ).sp,
            ),
          ),
          suffixIcon: onChanged != null
              ? IconButton(
                  icon: Icon(
                    Icons.clear_rounded,
                    color: AppTheme.textSecondary,
                    size: Responsive.fontSize(
                      context,
                      mobile: 16,
                      tablet: 12,
                      desktop: 14,
                    ).sp,
                  ),
                  onPressed: () => onChanged?.call(''),
                )
              : null,
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 20.w,
            vertical: 16.h,
          ),
        ),
      ),
    );
  }
}
