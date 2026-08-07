import 'dart:async';

import 'package:flutter/material.dart';

import '../services/contact_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  final TextEditingController _productController = TextEditingController();
  final TextEditingController _brandController = TextEditingController();
  final TextEditingController _widthController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _diameterController = TextEditingController();
  final TextEditingController _customQuantityController = TextEditingController();
  final TextEditingController _ideaController = TextEditingController();

  final List<int> _quantities = const [200, 500, 1000, 5000, 10000];
  final List<String> portfolioImages = [
    'assets/images/portfolio/work_1.webp',
    'assets/images/portfolio/work_2.webp',
    'assets/images/portfolio/work_3.webp',
  ];

  String _labelShape = '';
  int? _selectedQuantity;
  bool _customQuantity = false;
  bool _isOpeningContact = false;
  bool _whatsAppPulse = false;
  Timer? _whatsAppAnimationTimer;
  late final AnimationController _newsTickerController;

  @override
  void initState() {
    super.initState();

    _newsTickerController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 18),
    )..repeat();

    _whatsAppAnimationTimer = Timer.periodic(
      const Duration(seconds: 4),
          (_) {
        if (!mounted || _isOpeningContact) return;

        setState(() => _whatsAppPulse = true);

        Future.delayed(const Duration(milliseconds: 420), () {
          if (mounted) {
            setState(() => _whatsAppPulse = false);
          }
        });
      },
    );
  }

  @override
  void dispose() {
    _whatsAppAnimationTimer?.cancel();
    _newsTickerController.dispose();
    _productController.dispose();
    _brandController.dispose();
    _widthController.dispose();
    _heightController.dispose();
    _diameterController.dispose();
    _customQuantityController.dispose();
    _ideaController.dispose();
    super.dispose();
  }

  String _valueOrDefault(String value) {
    final cleaned = value.trim();
    return cleaned.isEmpty ? 'غير محدد' : cleaned;
  }

  String get _formattedSize {
    if (_labelShape == 'دائري') {
      final diameter = _diameterController.text.trim();
      return diameter.isEmpty ? 'غير محدد' : 'قطر $diameter سم';
    }

    final width = _widthController.text.trim();
    final height = _heightController.text.trim();

    if (width.isEmpty && height.isEmpty) return 'غير محدد';
    if (width.isEmpty) return 'الارتفاع: $height سم';
    if (height.isEmpty) return 'العرض: $width سم';

    return '$width × $height سم';
  }

  String get _formattedQuantity {
    if (_customQuantity) {
      final value = int.tryParse(_customQuantityController.text.trim());
      return value == null || value <= 0 ? 'غير محددة' : '$value ملصق';
    }

    return _selectedQuantity == null
        ? 'غير محددة'
        : '$_selectedQuantity ملصق';
  }

  String _buildCompleteIdea() {
    return '''
اسم المنتج: ${_valueOrDefault(_productController.text)}
اسم العلامة: ${_valueOrDefault(_brandController.text)}
شكل الملصق: ${_labelShape.isEmpty ? 'غير محدد' : _labelShape}
المقاس: $_formattedSize
الكمية: $_formattedQuantity

فكرة التصميم:
${_valueOrDefault(_ideaController.text)}
''';
  }

  Future<void> _openWhatsApp() async {
    await _openContact(
      action: () => ContactService.openWhatsApp(
        product: _valueOrDefault(_productController.text),
        brandName: _valueOrDefault(_brandController.text),
        designIdea: _buildCompleteIdea(),
      ),
      errorMessage: 'تعذر فتح واتساب، حاول مرة أخرى.',
    );
  }

  Future<void> _openFacebookPage() async {
    await _openContact(
      action: ContactService.openFacebookPage,
      errorMessage: 'تعذر فتح صفحة فيسبوك، حاول مرة أخرى.',
    );
  }

  Future<void> _openContact({
    required Future<bool> Function() action,
    required String errorMessage,
  }) async {
    if (_isOpeningContact) return;

    setState(() => _isOpeningContact = true);

    try {
      final opened = await action();
      if (!mounted) return;
      if (!opened) _showError(errorMessage);
    } catch (_) {
      if (!mounted) return;
      _showError(errorMessage);
    } finally {
      if (mounted) setState(() => _isOpeningContact = false);
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

  InputDecoration _inputDecoration({
    required String label,
    String? hint,
    IconData? icon,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: icon == null ? null : Icon(icon),
      filled: true,
      fillColor: const Color(0xFFF8FAFC),
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFFD7E1EC)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFFD7E1EC)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFFF47721), width: 2),
      ),
    );
  }

  Widget _section({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: const Color(0xFFE5EBF2)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000),
            blurRadius: 35,
            offset: Offset(0, 14),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            textDirection: TextDirection.rtl,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF1E8),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: const Color(0xFFF47721)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  textAlign: TextAlign.right,
                  textDirection: TextDirection.rtl,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF181818),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget _shapeOption(String title, IconData icon) {
    final selected = _labelShape == title;

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        setState(() {
          _labelShape = title;
          if (title == 'دائري') {
            _widthController.clear();
            _heightController.clear();
          } else {
            _diameterController.clear();
          }
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFFFF1E8) : const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected ? const Color(0xFFF47721) : const Color(0xFFD7E1EC),
            width: selected ? 2 : 1,
          ),
        ),
        child: Row(
          textDirection: TextDirection.rtl,
          children: [
            Icon(icon, color: const Color(0xFFF47721)),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                title,
                textDirection: TextDirection.rtl,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF2A2A2A),
                ),
              ),
            ),
            if (selected)
              const Icon(Icons.check_circle_rounded, color: Color(0xFFF47721)),
          ],
        ),
      ),
    );
  }

  Widget _quantityOption(int quantity) {
    final selected = !_customQuantity && _selectedQuantity == quantity;

    return ChoiceChip(
      label: Text('$quantity'),
      selected: selected,
      onSelected: (_) {
        setState(() {
          _customQuantity = false;
          _selectedQuantity = quantity;
          _customQuantityController.clear();
        });
      },
      labelStyle: TextStyle(
        fontWeight: FontWeight.w800,
        color: selected ? const Color(0xFFF47721) : const Color(0xFF2A2A2A),
      ),
      selectedColor: const Color(0xFFFFF1E8),
      backgroundColor: const Color(0xFFF8FAFC),
      side: BorderSide(
        color: selected ? const Color(0xFFF47721) : const Color(0xFFD7E1EC),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
    );
  }

  Widget _topNewsTicker() {
    const tickerText =
        '📞 الهاتف: 0770105328     •     💬 WhatsApp: 0770105328     •     🔵 Facebook: Hilo Print     •     🎨 التصميم مجاني     •     🚚 التوصيل متوفر';

    return Container(
      height: 38,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Color(0xFFF47721),
      ),
      clipBehavior: Clip.hardEdge,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return AnimatedBuilder(
            animation: _newsTickerController,
            builder: (context, child) {
              final travelDistance = constraints.maxWidth + 1050;
              final x = constraints.maxWidth -
                  (_newsTickerController.value * travelDistance);
              return Stack(
                alignment: Alignment.centerLeft,
                children: [
                  Transform.translate(
                    offset: Offset(x, 0),
                    child: const Text(
                      tickerText,
                      maxLines: 1,
                      softWrap: false,
                      textDirection: TextDirection.rtl,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                        height: 1.1,
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.sizeOf(context).width < 700;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        titleSpacing: isMobile ? 16 : 28,
        title: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                'assets/images/logo.webp',
                width: 42,
                height: 42,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 10),
            const Text(
              'HILO PRINT',
              style: TextStyle(
                color: Color(0xFFF47721),
                fontSize: 19,
                fontWeight: FontWeight.w900,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: EdgeInsetsDirectional.only(end: isMobile ? 12 : 24),
            child: TextButton.icon(
              onPressed: _isOpeningContact ? null : _openWhatsApp,
              icon: const Icon(Icons.chat_rounded, color: Color(0xFF16A765)),
              label: Text(
                isMobile ? 'واتساب' : 'تواصل عبر واتساب',
                style: const TextStyle(
                  color: Color(0xFF16A765),
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(38),
          child: _topNewsTicker(),
        ),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(top: BorderSide(color: Color(0xFFE4EAF1))),
            boxShadow: [
              BoxShadow(
                color: Color(0x16000000),
                blurRadius: 20,
                offset: Offset(0, -6),
              ),
            ],
          ),
          child: AnimatedScale(
            scale: _whatsAppPulse ? 1.025 : 1.0,
            duration: const Duration(milliseconds: 210),
            curve: Curves.easeInOut,
            child: SizedBox(
              height: 58,
              child: ElevatedButton.icon(
                onPressed: _isOpeningContact ? null : _openWhatsApp,
                icon: _isOpeningContact
                    ? const SizedBox(
                  width: 21,
                  height: 21,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.4,
                    color: Colors.white,
                  ),
                )
                    : const Icon(Icons.chat_rounded, color: Colors.white),
                label: Text(
                  _isOpeningContact ? 'جاري الفتح...' : 'إرسال الطلب عبر واتساب',
                  textDirection: TextDirection.rtl,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF16A765),
                  disabledBackgroundColor: const Color(0xAA16A765),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
            isMobile ? 14 : 24,
            24,
            isMobile ? 14 : 24,
            34,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 760),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 22,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: const Color(0xFFE5EBF2),
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x12000000),
                          blurRadius: 18,
                          offset: Offset(0, 8),
                        ),
                      ],
                    ),
                    child: const Column(
                      children: [
                        Icon(
                          Icons.local_printshop_rounded,
                          size: 56,
                          color: Color(0xFFF47721),
                        ),
                        SizedBox(height: 14),
                        Text(
                          "اطلب تصميم ملصق احترافي",
                          textAlign: TextAlign.center,
                          textDirection: TextDirection.rtl,
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF181818),
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          "املأ المعلومات التي تعرفها فقط وسنتكفل نحن بالباقي.",
                          textAlign: TextAlign.center,
                          textDirection: TextDirection.rtl,
                          style: TextStyle(
                            fontSize: 15,
                            height: 1.6,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  _section(
                    title: 'من أعمالنا',
                    icon: Icons.photo_library_rounded,
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: portfolioImages.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: isMobile ? 2 : 3,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 1,
                      ),
                      itemBuilder: (context, index) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.asset(
                            portfolioImages[index],
                            fit: BoxFit.cover,
                            filterQuality: FilterQuality.medium,
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 10),
                  _section(
                    title: 'معلومات المنتج',
                    icon: Icons.inventory_2_rounded,
                    child: Column(
                      children: [
                        TextField(
                          controller: _productController,
                          textDirection: TextDirection.rtl,
                          decoration: _inputDecoration(
                            label: 'اسم المنتج — اختياري',
                            hint: 'مثال: عسل، قهوة، زيت الزيتون...',
                            icon: Icons.inventory_2_rounded,
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _brandController,
                          textDirection: TextDirection.rtl,
                          decoration: _inputDecoration(
                            label: 'اسم العلامة — اختياري',
                            hint: 'مثال: HILO PRINT',
                            icon: Icons.storefront_rounded,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  _section(
                    title: 'شكل الملصق',
                    icon: Icons.category_rounded,
                    child: Column(
                      children: [
                        _shapeOption('مستطيل', Icons.rectangle_outlined),
                        const SizedBox(height: 10),
                        _shapeOption('دائري', Icons.circle_outlined),
                        const SizedBox(height: 10),
                        _shapeOption('فورم دكوب', Icons.auto_awesome_motion_rounded),
                        const SizedBox(height: 10),
                        _shapeOption('لا أعرف', Icons.help_outline_rounded),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  _section(
                    title: 'أبعاد الملصق',
                    icon: Icons.straighten_rounded,
                    child: _labelShape == 'دائري'
                        ? TextField(
                      controller: _diameterController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      textDirection: TextDirection.rtl,
                      decoration: _inputDecoration(
                        label: 'قطر الدائرة (سم) — اختياري',
                        icon: Icons.circle_outlined,
                      ),
                    )
                        : Column(
                      children: [
                        TextField(
                          controller: _widthController,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          textDirection: TextDirection.rtl,
                          decoration: _inputDecoration(
                            label: 'العرض (سم) — اختياري',
                            icon: Icons.width_normal_rounded,
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _heightController,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          textDirection: TextDirection.rtl,
                          decoration: _inputDecoration(
                            label: 'الارتفاع (سم) — اختياري',
                            icon: Icons.height_rounded,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  _section(
                    title: 'كمية الطباعة',
                    icon: Icons.numbers_rounded,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Wrap(
                          alignment: WrapAlignment.center,
                          spacing: 10,
                          runSpacing: 10,
                          children: [
                            ..._quantities.map(_quantityOption),
                            ChoiceChip(
                              label: const Text('كمية أخرى'),
                              selected: _customQuantity,
                              onSelected: (_) {
                                setState(() {
                                  _customQuantity = true;
                                  _selectedQuantity = null;
                                });
                              },
                            ),
                          ],
                        ),
                        if (_customQuantity) ...[
                          const SizedBox(height: 10),
                          TextField(
                            controller: _customQuantityController,
                            keyboardType: TextInputType.number,
                            textDirection: TextDirection.rtl,
                            decoration: _inputDecoration(
                              label: 'اكتب الكمية — اختياري',
                              hint: 'مثال: 2000',
                              icon: Icons.numbers_rounded,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  _section(
                    title: 'فكرة التصميم',
                    icon: Icons.auto_awesome_rounded,
                    child: TextField(
                      controller: _ideaController,
                      maxLines: 6,
                      textDirection: TextDirection.rtl,
                      decoration: _inputDecoration(
                        label: 'اكتب فكرتك — اختياري',
                        hint: 'مثال: تصميم طبيعي، ألوان خضراء، خلفية زيتون...',
                        icon: Icons.edit_note_rounded,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  _section(
                    title: 'التواصل',
                    icon: Icons.chat_rounded,
                    child: Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          height: 58,
                          child: ElevatedButton.icon(
                            onPressed: _isOpeningContact ? null : _openWhatsApp,
                            icon: const Icon(Icons.chat_rounded, color: Colors.white),
                            label: const Text(
                              'إرسال الطلب عبر واتساب',
                              textDirection: TextDirection.rtl,
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF16A765),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: OutlinedButton.icon(
                            onPressed: _isOpeningContact ? null : _openFacebookPage,
                            icon: const Icon(Icons.facebook_rounded, color: Color(0xFF1877F2)),
                            label: const Text(
                              'زيارة صفحتنا على فيسبوك',
                              textDirection: TextDirection.rtl,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFF1877F2),
                              ),
                            ),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Color(0xFF1877F2)),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
