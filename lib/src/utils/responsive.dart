import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Responsive breakpoints
class Breakpoints {
  static const double mobile = 600;
  static const double tablet = 800;
  static const double desktop = 1200;
}

/// Responsive utility class
class Responsive {
  /// Get current screen width
  static double width(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  /// Get current screen height
  static double height(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  /// Check if device is mobile
  static bool isMobile(BuildContext context) {
    return width(context) < Breakpoints.mobile;
  }

  /// Check if device is tablet
  static bool isTablet(BuildContext context) {
    final w = width(context);
    return w >= Breakpoints.mobile && w < Breakpoints.desktop;
  }

  /// Check if device is desktop
  static bool isDesktop(BuildContext context) {
    return width(context) >= Breakpoints.desktop;
  }

  /// Get responsive value based on screen size
  static T value<T>(
    BuildContext context, {
    required T mobile,
    T? tablet,
    T? desktop,
  }) {
    if (isDesktop(context) && desktop != null) return desktop;
    if (isTablet(context) && tablet != null) return tablet;
    return mobile;
  }

  /// Get responsive padding
  static EdgeInsets padding(
    BuildContext context, {
    double? mobile,
    double? tablet,
    double? desktop,
  }) {
    final padding = value<double>(
      context,
      mobile: mobile ?? 16.0,
      tablet: tablet ?? 24.0,
      desktop: desktop ?? 32.0,
    );
    return EdgeInsets.all(padding.r);
  }

  /// Get responsive horizontal padding
  static EdgeInsets horizontalPadding(
    BuildContext context, {
    double? mobile,
    double? tablet,
    double? desktop,
  }) {
    final padding = value<double>(
      context,
      mobile: mobile ?? 16.0,
      tablet: tablet ?? 24.0,
      desktop: desktop ?? 32.0,
    );
    return EdgeInsets.symmetric(horizontal: padding.w);
  }

  /// Get responsive vertical padding
  static EdgeInsets verticalPadding(
    BuildContext context, {
    double? mobile,
    double? tablet,
    double? desktop,
  }) {
    final padding = value<double>(
      context,
      mobile: mobile ?? 16.0,
      tablet: tablet ?? 24.0,
      desktop: desktop ?? 32.0,
    );
    return EdgeInsets.symmetric(vertical: padding.h);
  }

  /// Get responsive spacing
  static double spacing(
    BuildContext context, {
    double? mobile,
    double? tablet,
    double? desktop,
  }) {
    return value<double>(
      context,
      mobile: mobile ?? 16.0,
      tablet: tablet ?? 24.0,
      desktop: desktop ?? 32.0,
    );
  }

  /// Get responsive font size
  static double fontSize(
    BuildContext context, {
    required double mobile,
    double? tablet,
    double? desktop,
  }) {
    return value<double>(
      context,
      mobile: mobile,
      tablet: tablet ?? mobile * 1.2,
      desktop: desktop ?? mobile * 1.4,
    );
  }

  /// Get responsive grid cross axis count
  static int gridCrossAxisCount(BuildContext context) {
    if (isDesktop(context)) return 4;
    if (isTablet(context)) return 3;
    return 2;
  }

  /// Get responsive max width for content
  static double maxContentWidth(BuildContext context) {
    if (isDesktop(context)) return 1400.w;
    if (isTablet(context)) return 900.w;
    return double.infinity;
  }

  /// Get responsive card padding
  static EdgeInsets cardPadding(BuildContext context) {
    return padding(context, mobile: 16.0, tablet: 20.0, desktop: 24.0);
  }

  /// Get responsive border radius
  static double borderRadius(
    BuildContext context, {
    double? mobile,
    double? tablet,
    double? desktop,
  }) {
    return value<double>(
      context,
      mobile: mobile ?? 16.0,
      tablet: tablet ?? 20.0,
      desktop: desktop ?? 24.0,
    );
  }
}

/// Responsive layout builder widget
class ResponsiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;

  const ResponsiveLayout({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
  });

  @override
  Widget build(BuildContext context) {
    if (Responsive.isDesktop(context) && desktop != null) {
      return desktop!;
    }
    if (Responsive.isTablet(context) && tablet != null) {
      return tablet!;
    }
    return mobile;
  }
}

/// Responsive grid view builder
class ResponsiveGridView extends StatelessWidget {
  final List<Widget> children;
  final double childAspectRatio;
  final double crossAxisSpacing;
  final double mainAxisSpacing;
  final EdgeInsets? padding;

  const ResponsiveGridView({
    super.key,
    required this.children,
    this.childAspectRatio = 1.0,
    this.crossAxisSpacing = 16.0,
    this.mainAxisSpacing = 16.0,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final crossAxisCount = Responsive.gridCrossAxisCount(context);
    final maxWidth = Responsive.maxContentWidth(context);

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: GridView.builder(
          padding: padding ?? Responsive.padding(context),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: crossAxisSpacing.w,
            mainAxisSpacing: mainAxisSpacing.h,
            childAspectRatio: Responsive.value<double>(
              context,
              mobile: childAspectRatio,
              tablet: childAspectRatio * 0.9,
              desktop: childAspectRatio * 0.85,
            ),
          ),
          itemCount: children.length,
          itemBuilder: (context, index) => children[index],
        ),
      ),
    );
  }
}

/// Responsive container with max width
class ResponsiveContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;

  const ResponsiveContainer({
    super.key,
    required this.child,
    this.padding,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    final maxWidth = Responsive.maxContentWidth(context);
    final containerPadding = padding ?? Responsive.padding(context);

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Container(
          padding: containerPadding,
          margin: margin,
          child: child,
        ),
      ),
    );
  }
}
