import 'package:flutter/material.dart';

import '../services/contact_service.dart';

class RequestForm extends StatefulWidget {
  const RequestForm({super.key});

  @override
  State<RequestForm> createState() => _RequestFormState();
}

class _RequestFormState extends State<RequestForm> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _productController = TextEditingController();
  final TextEditingController _brandController = TextEditingController();
  final TextEditingController _ideaController = TextEditingController();

  bool _isSending = false;

  @override
  void dispose() {
    _productController.dispose();
    _brandController.dispose();
    _ideaController.dispose();
    super.dispose();
  }

  Future<void> _sendToWhatsApp() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSending = true;
    });

    final bool opened = await ContactService.openWhatsApp(
      product: _productController.text.trim(),
      brandName: _brandController.text.trim(),
      designIdea: _ideaController.text.trim(),
    );

    if (!mounted) return;

    setState(() {
      _isSending = false;
    });

    if (!opened) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'تعذر فتح واتساب، حاول مرة أخرى.',
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
  }

  Future<void> _openMessenger() async {
    final bool opened = await ContactService.openMessenger();

    if (!mounted) return;

    if (!opened) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'تعذر فتح ماسنجر.',
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: const [
          BoxShadow(
            blurRadius: 20,
            color: Color(0x12000000),
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'ابدأ بطلبك',
              textAlign: TextAlign.center,
              textDirection: TextDirection.rtl,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'املأ المعلومات التالية ثم أرسل طلبك مباشرة عبر واتساب.',
              textAlign: TextAlign.center,
              textDirection: TextDirection.rtl,
            ),
            const SizedBox(height: 30),
            TextFormField(
              controller: _productController,
              textDirection: TextDirection.rtl,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'ما هو منتجك؟',
                hintText: 'مثال: عسل، قهوة، مواد تنظيف...',
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'اكتب نوع المنتج';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _brandController,
              textDirection: TextDirection.rtl,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'اسم العلامة',
                hintText: 'اكتب اسم العلامة التجارية',
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'اكتب اسم العلامة';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _ideaController,
              textDirection: TextDirection.rtl,
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: 'صف لنا فكرة التصميم',
                hintText: 'اذكر الألوان، الشكل، المقاس أو أي تفاصيل مهمة',
                alignLabelWithHint: true,
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'اكتب فكرة التصميم';
                }
                return null;
              },
            ),
            const SizedBox(height: 30),
            SizedBox(
              height: 56,
              child: ElevatedButton.icon(
                onPressed: _isSending ? null : _sendToWhatsApp,
                icon: _isSending
                    ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
                    : const Icon(
                  Icons.chat_rounded,
                  color: Colors.white,
                ),
                label: Text(
                  _isSending ? 'جارٍ فتح واتساب...' : 'إرسال عبر واتساب',
                  textDirection: TextDirection.rtl,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF16A765),
                  disabledBackgroundColor: const Color(0xFF8CC9AA),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 14),
            SizedBox(
              height: 52,
              child: OutlinedButton.icon(
                onPressed: _openMessenger,
                icon: const Icon(
                  Icons.facebook_rounded,
                  color: Color(0xFF1877F2),
                ),
                label: const Text(
                  'متابعة عبر ماسنجر',
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1877F2),
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(
                    color: Color(0xFF1877F2),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}