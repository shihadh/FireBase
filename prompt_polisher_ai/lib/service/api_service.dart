import 'dart:developer';

import 'package:firebase_ai/firebase_ai.dart';
import 'package:prompt_polisher_ai/constants/text_const.dart';

class ApiService {

  final FirebaseAI firebase = FirebaseAI.googleAI();

  Future<(String?,String?)> polishPrompt(String prompt)async{

    try{
      final model = firebase.generativeModel(model: 'gemini-1.5-flash');
      final responce = await model.generateContent([
        Content.text(
          "${TextConst.additional} $prompt"
          )
      ]);
      return (responce.text,null);
    }catch(e){
      log(e.toString());
      return (null,e.toString());
    }
  }
}