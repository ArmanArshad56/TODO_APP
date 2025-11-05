// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:todo_app/src/theme/app_theme.dart';

class SearchField extends StatelessWidget {
  final String hint;
  final ValueChanged<String>? onChanged;
  const SearchField({super.key, this.hint = 'Search', this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        onChanged: onChanged,
        style: const TextStyle(fontSize: 16),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: AppTheme.textTertiary),
          prefixIcon: Icon(Icons.search_rounded, color: AppTheme.textSecondary),
          suffixIcon: onChanged != null
              ? IconButton(
                  icon: Icon(
                    Icons.clear_rounded,
                    color: AppTheme.textSecondary,
                    size: 20,
                  ),
                  onPressed: () => onChanged?.call(''),
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
        ),
      ),
    );
  }
}
