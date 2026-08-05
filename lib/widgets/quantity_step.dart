import 'package:flutter/material.dart';

import 'common/app_text_field.dart';
import 'common/card_container.dart';
import 'common/primary_button.dart';
import 'common/progress_header.dart';
import 'common/secondary_button.dart';

class QuantityStep extends StatefulWidget {
  final int initialValue;
  final ValueChanged<int> onNext;
  final VoidCallback onBack;

  const QuantityStep({super.key,required this.initialValue,required this.onNext,required this.onBack});

  @override
  State<QuantityStep> createState()=>_QuantityStepState();
}

class _QuantityStepState extends State<QuantityStep>{
  final quantities=[200,500,1000,5000,10000];
  int? selected;
  bool custom=false;
  late final TextEditingController c;

  @override
  void initState(){
    super.initState();
    if(quantities.contains(widget.initialValue)){selected=widget.initialValue;}
    else if(widget.initialValue>0){custom=true;}
    c=TextEditingController(text:custom?widget.initialValue.toString():'');
  }

  @override
  void dispose(){c.dispose();super.dispose();}

  void next(){
    widget.onNext(custom?(int.tryParse(c.text.trim())??0):(selected??0));
  }

  @override
  Widget build(BuildContext context){
    return CardContainer(child:Column(children:[
      const ProgressHeader(currentStep:5,totalSteps:7,title:'ما كمية الطباعة؟',subtitle:'يمكنك تركها غير محددة.',icon:Icons.numbers_rounded),
      const SizedBox(height:24),
      Wrap(spacing:12,runSpacing:12,children:[
        ...quantities.map((q)=>ChoiceChip(label:Text('$q'),selected:!custom&&selected==q,onSelected:(_){setState((){custom=false;selected=q;});})),
        ChoiceChip(label:const Text('كمية أخرى'),selected:custom,onSelected:(_){setState((){custom=true;selected=null;});})
      ]),
      if(custom)...[
        const SizedBox(height:20),
        AppTextField(controller:c,label:'اكتب الكمية',keyboardType:TextInputType.number,icon:Icons.numbers),
      ],
      const SizedBox(height:28),
      Row(children:[
        Expanded(child:SecondaryButton(text:'رجوع',icon:Icons.arrow_back,onPressed:widget.onBack)),
        const SizedBox(width:12),
        Expanded(flex:2,child:PrimaryButton(text:'التالي',icon:Icons.arrow_forward,onPressed:next)),
      ])
    ]));
  }
}
