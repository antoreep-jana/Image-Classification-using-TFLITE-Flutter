import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:developer' as devtools;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  File? filePath;
  String label = '';
  double confidence = 0.0;
  late Interpreter interpreter;
  List<String> labels = [];

  late Tensor inputTensor;
  late Tensor outputTensor;


  Future<void> _loadModel() async {
    //labels = await File("assets/labels.txt").readAsLines();
    String label1 = await rootBundle.loadString("assets/labels.txt");
    //String label1 = await rootBundle.loadString("assets/labels_m.txt");

    print("Label File \n${label1}");

    labels = label1.split("\n");
    print("Labels: $labels");

    interpreter = await Interpreter.fromAsset("assets/model_unquant.tflite");
    //interpreter = await Interpreter.fromAsset("assets/mobilenet_v1_1.0_224.tflite");
    //interpreter = await Interpreter.fromAsset("assets/efficientnet-tflite-lite4-fp32-v2/2.tflite");


    print("Model Loaded Successfully");
    print(interpreter.getInputTensors());
    inputTensor = interpreter.getInputTensors().first;
    print("Input Tensor : ${inputTensor}");
    print(interpreter.getOutputTensors());
    outputTensor = interpreter.getOutputTensors().first;
    print("Output Tensor : ${outputTensor}");

    //interpreter = await Interpreter.fromFile(await File("assets/model_unquant.tflite"));
      }

    List preprocessImage(String imagePath) {

  //Float32List preprocessImage(String imagePath){

    File imageFile = File(imagePath);
    print("Image Filed read --> ${imageFile.length()}" );


    List<int> imageBytes = imageFile.readAsBytesSync();
    //var imageBytes = imageFile.readAsBytesSync();


    print("Image Bytes --> ${imageBytes}");
    print("Image Bytes Length --> ${imageBytes.length}");

    img.Image? image = img.decodeImage(Uint8List.fromList(imageBytes));
    //img.Image? image = img.decodeImage(imageBytes);
    print("Image length --> ${image!.length}");
    // if (image == null) {
    //   throw Exception("Failed to decode image.");
    // }

    img.Image resizedImage = img.copyResize(image!, width: 224, height: 224);
    print("Resized Image Length --> ${resizedImage.getBytes().buffer.asFloat32List().length}");

    print("Load image as ${resizedImage.height} x ${resizedImage.width}");
    //var input = Float32List(1 * 224 * 224 * 3);
    var convertedBytes = Float32List(1 * 224 * 224 * 3);
    var input = Float32List.view(convertedBytes.buffer);

    int pixelIndex = 0;

    for (int y = 0; y < 224; y++) {
      for (int x = 0; x < 224; x++) {
        int r= resizedImage.getPixel(x, y).r.toInt();
        int g= resizedImage.getPixel(x, y).g.toInt();
        int b = resizedImage.getPixel(x, y).b.toInt();
        input[pixelIndex++] = r / 255.0;
        input[pixelIndex++] = g / 255.0;
        input[pixelIndex++] = b / 255.0;
      }
    }

    //return input;
    List<int> shape = [150528];
    //return resizedImage.getBytes().buffer.asFloat32List().reshape(shape);
      return convertedBytes.buffer.asUint8List();
  }

  Future<void> classifyImage(String imagePath) async {
    print("About to Classify!");
    var input = preprocessImage(imagePath);
    print("Labels --> ${labels}");

    var output = List.filled(1 * labels.length, 0.0).reshape([1, labels.length]);

    interpreter.run(input, output);//input, output);

    int maxIndex = 0;
    double maxConfidence = 0.0;

    for (int i = 0; i < labels.length; i++) {
      if (output[0][i] > maxConfidence) {
        maxConfidence = output[0][i];
        maxIndex = i;
      }
    }

    setState(() {
      confidence = maxConfidence * 100;
      label = labels[maxIndex];
    });
  }

  Future<void> pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: source);

    if (image == null) return;

    setState(() {
      filePath = File(image.path);
    });
    print("FilePath ${filePath}");
    await classifyImage(image.path);
  }

  @override
  void dispose() {
    interpreter.close();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _loadModel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mango Disease Detection"),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 12),
              Card(
                elevation: 20,
                clipBehavior: Clip.hardEdge,
                child: SizedBox(
                  width: 300,
                  child: Column(
                    children: [
                      const SizedBox(height: 18),
                      Container(
                        height: 280,
                        width: 280,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          image: const DecorationImage(
                            image: AssetImage('assets/upload.jpg'),
                          ),
                        ),
                        child: filePath == null
                            ? const Text('')
                            : Image.file(filePath!, fit: BoxFit.fill),
                      ),
                      const SizedBox(height: 12),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Text(
                              label,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              "The Accuracy is ${confidence.toStringAsFixed(0)}%",
                              style: const TextStyle(fontSize: 18),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () => pickImage(ImageSource.camera),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
                  foregroundColor: Colors.black,
                ),
                child: const Text("Take a Photo"),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () => pickImage(ImageSource.gallery),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
                  foregroundColor: Colors.black,
                ),
                child: const Text("Pick from gallery"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
