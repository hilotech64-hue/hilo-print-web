import 'package:flutter/material.dart';

class ServiceStep extends StatefulWidget {
  final ValueChanged<String> onNext;
  final VoidCallback onBack;

  const ServiceStep({
    super.key,
    required this.onNext,
    required this.onBack,
  });

  @override
  State<ServiceStep> createState() => _ServiceStepState();
}

class _ServiceStepState extends State<ServiceStep> {
  String? selectedService;

  final List<Map<String, dynamic>> services = [
    {
      'title': 'ملصق منتج',
      'icon': Icons.sell_rounded,
    },
    {
      'title': 'شعار',
      'icon': Icons.palette_rounded,
    },
    {
      'title': 'بطاقة أعمال',
      'icon': Icons.badge_rounded,
    },
    {
      'title': 'فلاير',
      'icon': Icons.description_rounded,
    },
    {
      'title': 'شيء آخر',
      'icon': Icons.edit_rounded,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final bool isMobile = MediaQuery.sizeOf(context).width < 600;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isMobile ? 22 : 36),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 30,
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            'HILO PRINT',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.2,
              color: Color(0xFF1565C0),
            ),
          ),
          const SizedBox(height: 18),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: const LinearProgressIndicator(
              value: 0.16,
              minHeight: 8,
              backgroundColor: Color(0xFFEAF0F7),
              valueColor: AlwaysStoppedAnimation(
                Color(0xFF1565C0),
              ),
            ),
          ),
          const SizedBox(height: 30),
          Text(
            'ما الذي تريد تصميمه؟',
            textAlign: TextAlign.center,
            textDirection: TextDirection.rtl,
            style: TextStyle(
              fontSize: isMobile ? 27 : 34,
              fontWeight: FontWeight.w900,
              color: const Color(0xFF102A43),
            ),
          ),
          const SizedBox(height: 28),
          ...services.map((service) {
            final String title = service['title'] as String;
            final IconData icon = service['icon'] as IconData;
            final bool isSelected = selectedService == title;

            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: InkWell(
                borderRadius: BorderRadius.circular(18),
                onTap: () {
                  setState(() {
                    selectedService = title;
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 17,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFFEAF3FF)
                        : const Color(0xFFF9FBFD),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: isSelected
                          ? const Color(0xFF1565C0)
                          : const Color(0xFFDDE6F1),
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Row(
                    textDirection: TextDirection.rtl,
                    children: [
                      Container(
                        width: 46,
                        height: 46,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xFF1565C0)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Icon(
                          icon,
                          color: isSelected
                              ? Colors.white
                              : const Color(0xFF1565C0),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(
                          title,
                          textDirection: TextDirection.rtl,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF183B56),
                          ),
                        ),
                      ),
                      if (isSelected)
                        const Icon(
                          Icons.check_circle_rounded,
                          color: Color(0xFF1565C0),
                        ),
                    ],
                  ),
                ),
              ),
            );
          }),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: widget.onBack,
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(56),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'رجوع',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: selectedService == null
                      ? null
                      : () => widget.onNext(selectedService!),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(56),
                    backgroundColor: const Color(0xFF1565C0),
                    disabledBackgroundColor: const Color(0xFFC7D4E3),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'التالي',
                    textDirection: TextDirection.rtl,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}