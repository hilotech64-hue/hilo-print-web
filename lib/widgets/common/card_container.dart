import 'package:flutter/material.dart';

class CardContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double maxWidth;

  const CardContainer({
    super.key,
    required this.child,
    this.padding,
    this.maxWidth = 560,
  });

  @override
  Widget build(BuildContext context) {
    final bool isMobile = MediaQuery.sizeOf(context).width < 600;

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: maxWidth,
      ),
      child: Container(
        width: double.infinity,
        padding: padding ??
            EdgeInsets.symmetric(
              horizontal: isMobile ? 20 : 36,
              vertical: isMobile ? 24 : 36,
            ),
        decoration: BoxDecoration(
          color: const Color(0xFFFCFCFD),
          borderRadius: BorderRadius.circular(32),
          border: Border.all(
            color: const Color(0xFFE8EDF3),
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x12000000),
              blurRadius: 60,
              spreadRadius: 4,
              offset: Offset(0, 20),
            ),
          ],
        ),
        child: child,
      ),
    );
  }
}
