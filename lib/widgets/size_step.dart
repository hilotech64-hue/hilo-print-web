import 'package:flutter/material.dart';

import 'common/app_text_field.dart';
import 'common/card_container.dart';
import 'common/primary_button.dart';
import 'common/progress_header.dart';
import 'common/secondary_button.dart';

class SizeStep extends StatefulWidget {
  final String shape;
  final String width;
  final String height;
  final String diameter;
  final Function({
  required String width,
  required String height,
  required String diameter,
  }) onNext;
  final VoidCallback onBack;

  const SizeStep({
    super.key,
    required this.shape,
    required this.width,
    required this.height,
    required this.diameter,
    required this.onNext,
    required this.onBack,
  });

  @override
  State<SizeStep> createState()=>_SizeStepState();
}

class _SizeStepState extends State<SizeStep>{
  late final TextEditingController w;
  late final TextEditingController h;
  late final TextEditingController d;

  @override
  void initState(){
    super.initState();
    w=TextEditingController(text: widget.width);
    h=TextEditingController(text: widget.height);
    d=TextEditingController(text: widget.diameter);
  }

  @override
  void dispose(){w.dispose();h.dispose();d.dispose();super.dispose();}

  void next(){
    widget.onNext(
      width: w.text.trim(),
      height: h.text.trim(),
      diameter: widget.shape=="دائري"?d.text.trim():"",
    );
  }

  @override
  Widget build(BuildContext context){
    return CardContainer(
      child: Column(
        children:[
          const ProgressHeader(
            currentStep:4,
            totalSteps:7,
            title:'أبعاد الملصق',
            subtitle:'يمكنك ترك الحقول فارغة والمتابعة.',
            icon: Icons.straighten_rounded,
          ),
          const SizedBox(height:24),
          if(widget.shape=="دائري")
            AppTextField(controller:d,label:'قطر الدائرة (سم)',keyboardType:TextInputType.number,icon:Icons.circle_outlined)
          else ...[
            AppTextField(controller:w,label:'العرض (سم)',keyboardType:TextInputType.number,icon:Icons.width_normal_rounded),
            const SizedBox(height:16),
            AppTextField(controller:h,label:'الارتفاع (سم)',keyboardType:TextInputType.number,icon:Icons.height_rounded),
          ],
          const SizedBox(height:28),
          Row(children:[
            Expanded(child:SecondaryButton(text:'رجوع',icon:Icons.arrow_back,onPressed:widget.onBack)),
            const SizedBox(width:12),
            Expanded(flex:2,child:PrimaryButton(text:'التالي',icon:Icons.arrow_forward,onPressed:next)),
          ])
        ],
      ),
    );
  }
}
