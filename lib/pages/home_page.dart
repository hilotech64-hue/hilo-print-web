import 'package:flutter/material.dart';

import '../services/contact_service.dart';
import '../widgets/brand_step.dart';
import '../widgets/idea_step.dart';
import '../widgets/product_step.dart';
import '../widgets/quantity_step.dart';
import '../widgets/shape_step.dart';
import '../widgets/size_step.dart';
import '../widgets/upload_step.dart';
import '../widgets/welcome_step.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentStep = 0;

  String productName = '';
  String brandName = '';
  String labelShape = '';
  String labelWidth = '';
  String labelHeight = '';
  String circleDiameter = '';
  int quantity = 0;
  String designIdea = '';

  bool isOpeningContact = false;

  String get formattedSize {
    if (labelShape == 'دائري') {
      if (circleDiameter.isEmpty) return 'غير محدد';
      return 'قطر $circleDiameter سم';
    }

    if (labelShape == 'لا أعرف') {
      return 'أحتاج اقتراحًا مناسبًا';
    }

    if (labelWidth.isEmpty || labelHeight.isEmpty) {
      return 'غير محدد';
    }

    return '$labelWidth × $labelHeight سم';
  }

  Future<void> _openWhatsApp() async {
    await _openContact(
      action: () {
        return ContactService.openWhatsApp(
          product: productName,
          brandName: brandName,
          designIdea: _buildCompleteIdea(),
        );
      },
      errorMessage: 'تعذر فتح واتساب، حاول مرة أخرى.',
    );
  }

  Future<void> _openMessenger() async {
    await _openContact(
      action: ContactService.openMessenger,
      errorMessage: 'تعذر فتح ماسنجر، حاول مرة أخرى.',
    );
  }

  String _buildCompleteIdea() {
    return '''
شكل الملصق: $labelShape
المقاس: $formattedSize
الكمية: $quantity ملصق

فكرة التصميم:
$designIdea
''';
  }

  Future<void> _openContact({
    required Future<bool> Function() action,
    required String errorMessage,
  }) async {
    if (isOpeningContact) return;

    setState(() {
      isOpeningContact = true;
    });

    try {
      final bool opened = await action();

      if (!mounted) return;

      if (!opened) {
        _showError(errorMessage);
      }
    } catch (_) {
      if (!mounted) return;
      _showError(errorMessage);
    } finally {
      if (mounted) {
        setState(() {
          isOpeningContact = false;
        });
      }
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          textAlign: TextAlign.center,
          textDirection: TextDirection.rtl,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 32,
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 560),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 450),
                switchInCurve: Curves.easeOutCubic,
                switchOutCurve: Curves.easeInCubic,
                transitionBuilder: (child, animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0.08, 0),
                        end: Offset.zero,
                      ).animate(animation),
                      child: child,
                    ),
                  );
                },
                child: _buildStep(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStep() {
    switch (currentStep) {
      case 0:
        return WelcomeStep(
          key: const ValueKey(0),
          onStart: () {
            setState(() {
              currentStep = 1;
            });
          },
        );

      case 1:
        return ProductStep(
          key: const ValueKey(1),
          initialValue: productName,
          onBack: () {
            setState(() {
              currentStep = 0;
            });
          },
          onNext: (product) {
            setState(() {
              productName = product;
              currentStep = 2;
            });
          },
        );

      case 2:
        return BrandStep(
          key: const ValueKey(2),
          initialValue: brandName,
          onBack: () {
            setState(() {
              currentStep = 1;
            });
          },
          onNext: (brand) {
            setState(() {
              brandName = brand;
              currentStep = 3;
            });
          },
        );

      case 3:
        return ShapeStep(
          key: const ValueKey(3),
          initialValue: labelShape,
          onBack: () {
            setState(() {
              currentStep = 2;
            });
          },
          onNext: (shape) {
            setState(() {
              labelShape = shape;

              if (shape == 'لا أعرف') {
                labelWidth = '';
                labelHeight = '';
                circleDiameter = '';
                currentStep = 5;
              } else {
                currentStep = 4;
              }
            });
          },
        );

      case 4:
        return SizeStep(
          key: const ValueKey(4),
          shape: labelShape,
          width: labelWidth,
          height: labelHeight,
          diameter: circleDiameter,
          onBack: () {
            setState(() {
              currentStep = 3;
            });
          },
          onNext: ({
            required String width,
            required String height,
            required String diameter,
          }) {
            setState(() {
              labelWidth = width;
              labelHeight = height;
              circleDiameter = diameter;
              currentStep = 5;
            });
          },
        );

      case 5:
        return QuantityStep(
          key: const ValueKey(5),
          initialValue: quantity,
          onBack: () {
            setState(() {
              currentStep = labelShape == 'لا أعرف' ? 3 : 4;
            });
          },
          onNext: (selectedQuantity) {
            setState(() {
              quantity = selectedQuantity;
              currentStep = 6;
            });
          },
        );

      case 6:
        return IdeaStep(
          key: const ValueKey(6),
          initialValue: designIdea,
          onBack: () {
            setState(() {
              currentStep = 5;
            });
          },
          onNext: (idea) {
            setState(() {
              designIdea = idea;
              currentStep = 7;
            });
          },
        );

      case 7:
        return Stack(
          key: const ValueKey(7),
          children: [
            UploadStep(
              onBack: () {
                setState(() {
                  currentStep = 6;
                });
              },
              onWhatsApp: _openWhatsApp,
              onMessenger: _openMessenger,
            ),
            if (isOpeningContact)
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.78),
                    borderRadius: BorderRadius.circular(28),
                  ),
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              ),
          ],
        );

      default:
        return const SizedBox.shrink();
    }
  }
}
