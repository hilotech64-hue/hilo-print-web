import 'package:flutter/material.dart';

import 'common/app_text_field.dart';
import 'common/card_container.dart';
import 'common/primary_button.dart';
import 'common/progress_header.dart';
import 'common/secondary_button.dart';

class IdeaStep extends StatefulWidget{
  final String initialValue;
  final ValueChanged<String> onNext;
  final VoidCallback onBack;
  const IdeaStep({super.key,required this.initialValue,required this.onNext,required this.onBack});
  @override State<IdeaStep> createState()=>_IdeaStepState();
}
class _IdeaStepState extends State<IdeaStep>{
  late final TextEditingController c;
  @override void initState(){super.initState();c=TextEditingController(text:widget.initialValue);}
  @override void dispose(){c.dispose();super.dispose();}
  void next()=>widget.onNext(c.text.trim());
  @override Widget build(BuildContext context){
    return CardContainer(child:Column(children:[
      const ProgressHeader(currentStep:6,totalSteps:7,title:'صف لنا فكرة التصميم',subtitle:'يمكنك ترك الحقل فارغًا والمتابعة.',icon:Icons.auto_awesome_rounded),
      const SizedBox(height:24),
      AppTextField(controller:c,label:'فكرة التصميم',hint:'مثال: ألوان خضراء، تصميم فاخر...',icon:Icons.edit_note_rounded,maxLines:6,textInputAction:TextInputAction.done,onSubmitted:(_)=>next()),
      const SizedBox(height:28),
      Row(children:[
        Expanded(child:SecondaryButton(text:'رجوع',icon:Icons.arrow_back,onPressed:widget.onBack)),
        const SizedBox(width:12),
        Expanded(flex:2,child:PrimaryButton(text:'التالي',icon:Icons.arrow_forward,onPressed:next)),
      ])
    ]));
  }
}
