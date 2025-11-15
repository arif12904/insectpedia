import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:insectpedia/utils/error_handler.dart';
import '../data/insects_detail.dart';
import '../screens/prediction_detail_screen.dart';

class PredictionProvider with ChangeNotifier {
  File? imageFile;
  String? predictionMessage;
  bool _isLoading = false;
  final ImagePicker _picker = ImagePicker();

  bool get isLoading => _isLoading;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      imageFile = File(pickedFile.path);
      predictionMessage = null;
      notifyListeners();
    }
  }

  Future<void> predictImage(BuildContext context) async {
    if (imageFile == null) return;

    setLoading(true);

    final url = Uri.parse('https://insectpedia.loca.lt/api/predict-image');
    final request = http.MultipartRequest('POST', url)
      ..files.add(await http.MultipartFile.fromPath('image', imageFile!.path));

    request.headers.addAll({'Content-Type': 'multipart/form-data'});

    try {
      final response = await request.send();
      final responseData = await response.stream.bytesToString();


      if (response.statusCode == 200) {
        final data = jsonDecode(responseData);

        if (data.containsKey('prediction')) {
          final pred = data['prediction'];

          if (pred is Map && pred.containsKey('class_index') && pred.containsKey('confidence')) {
            int classIndex = pred['class_index'];
            double confidence = (pred['confidence'] as num).toDouble();

            predictionMessage =
            'Predicted class: $classIndex\nConfidence: ${confidence.toStringAsFixed(2)}%';
            notifyListeners();

            if (classIndex >= 0 && classIndex < insects_detail.length) {
              final insect = insects_detail[classIndex];
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PredictionDetailScreen(
                    insect: insect,
                    imageFile: imageFile!,
                    confidence: confidence,
                  ),
                ),
              );
            } else {
              predictionMessage = 'Class index tidak valid.';
              ErrorHandler.showError(context, predictionMessage!);
              notifyListeners();
            }
          } else {
            predictionMessage = 'Format prediction tidak dikenali.';
            ErrorHandler.showError(context, predictionMessage!);
            notifyListeners();
          }
        } else {
          predictionMessage = 'Prediction key tidak ditemukan.';
          ErrorHandler.showError(context, predictionMessage!);
          notifyListeners();
        }
      } else {
        predictionMessage = 'Error ${response.statusCode}: $responseData';
        ErrorHandler.showError(context, predictionMessage!);
        notifyListeners();
      }
    } catch (e) {
      predictionMessage = 'Error: $e';
      ErrorHandler.showError(context, predictionMessage!);
      notifyListeners();
    } finally {
      setLoading(false);
    }
  }

  void clear() {
    imageFile = null;
    predictionMessage = null;
    notifyListeners();
  }
}
