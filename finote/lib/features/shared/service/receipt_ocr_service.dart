import 'dart:io';

import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class ReceiptOCRService {
  final textRecognizer =
      TextRecognizer(script: TextRecognitionScript.latin);

  Future<String> scanText(File image) async {
    final inputImage = InputImage.fromFile(image);
    final recognizedText =
        await textRecognizer.processImage(inputImage);

    return recognizedText.text;
  }

  void dispose() {
    textRecognizer.close();
  }
}
