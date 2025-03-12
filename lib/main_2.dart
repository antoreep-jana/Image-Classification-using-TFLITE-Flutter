// // import 'dart:io';
// // import 'package:flutter/material.dart';
// // import 'package:image_picker/image_picker.dart';
// // import 'package:tflite_flutter/tflite_flutter.dart' as tfl;
// // import 'package:tflite_flutter_helper/tflite_flutter_helper.dart';
// // import 'dart:developer' as devtools;
// //
// // void main() {
// //   runApp(const MyApp());
// // }
// //
// // class MyApp extends StatelessWidget {
// //   const MyApp({super.key});
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return MaterialApp(
// //       title: 'Mango Disease Detection',
// //       theme: ThemeData(
// //         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
// //       ),
// //       home: MyHomePage(),
// //     );
// //   }
// // }
// //
// // class MyHomePage extends StatefulWidget {
// //   const MyHomePage({super.key});
// //
// //   @override
// //   State<MyHomePage> createState() => _MyHomePageState();
// // }
// //
// // class _MyHomePageState extends State<MyHomePage> {
// //   File? filePath;
// //   double confidence = 0.0;
// //   String label = '';
// //   late tfl.Interpreter interpreter;
// //   late List<String> labels;
// //
// //   Future<void> _tfliteInit() async {
// //     try {
// //       interpreter = await tfl.Interpreter.fromAsset('model_unquant.tflite');
// //       labels = await File('assets/labels.txt').readAsLines();
// //       devtools.log("Model Loaded Successfully");
// //     } catch (e) {
// //       devtools.log("Failed to load model: $e");
// //     }
// //   }
// //
// //   Future<void> pickImageGallery() async {
// //     final ImagePicker picker = ImagePicker();
// //     final XFile? image = await picker.pickImage(source: ImageSource.gallery);
// //
// //     if (image == null) return;
// //     setState(() {
// //       filePath = File(image.path);
// //     });
// //
// //     await classifyImage(filePath!);
// //   }
// //
// //   Future<void> classifyImage(File image) async {
// //     // Load image and preprocess
// //     var imageProcessor = ImageProcessorBuilder()
// //         .add(ResizeOp(224, 224, ResizeMethod.BILINEAR))
// //         .add(NormalizeOp(0, 255))
// //         .build();
// //
// //     var inputImage = TensorImage.fromFile(image);
// //     inputImage = imageProcessor.process(inputImage);
// //
// //     // Prepare input and output tensors
// //     var outputBuffer = TensorBuffer.createFixedSize([1, labels.length], TfLiteType.float32);
// //     interpreter.run(inputImage.buffer, outputBuffer.buffer);
// //
// //     // Process output
// //     var outputData = outputBuffer.getDoubleList();
// //     int maxIndex = outputData.indexWhere((value) => value == outputData.reduce((a, b) => a > b ? a : b));
// //
// //     setState(() {
// //       confidence = outputData[maxIndex] * 100;
// //       label = labels[maxIndex];
// //     });
// //   }
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     _tfliteInit();
// //   }
// //
// //   @override
// //   void dispose() {
// //     interpreter.close();
// //     super.dispose();
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(title: Text("Mango Disease Detection")),
// //       body: SingleChildScrollView(
// //         child: Center(
// //           child: Column(
// //             children: [
// //               const SizedBox(height: 12),
// //               Card(
// //                 elevation: 20,
// //                 clipBehavior: Clip.hardEdge,
// //                 child: SizedBox(
// //                   width: 300,
// //                   child: Column(
// //                     children: [
// //                       SizedBox(height: 18),
// //                       Container(
// //                           height: 280,
// //                           width: 280,
// //                           decoration: BoxDecoration(
// //                             color: Colors.white,
// //                             borderRadius: BorderRadius.circular(12),
// //                             image: const DecorationImage(
// //                               image: AssetImage('assets/upload.jpg'),
// //                             ),
// //                           ),
// //                           child: filePath == null ? const Text('') :
// //                           Image.file(filePath!, fit: BoxFit.fill,)
// //                       ),
// //                       SizedBox(height: 12),
// //                       Padding(
// //                         padding: const EdgeInsets.all(8.0),
// //                         child: Column(
// //                           children: [
// //                             Text(
// //                               label,
// //                               style: TextStyle(
// //                                 fontSize: 18,
// //                                 fontWeight: FontWeight.bold,
// //                               ),
// //                             ),
// //                             const SizedBox(height: 12),
// //                             Text(
// //                               "Accuracy: ${confidence.toStringAsFixed(0)}%",
// //                               style: const TextStyle(
// //                                 fontSize: 18,
// //                               ),
// //                             ),
// //                             const SizedBox(height: 12),
// //                           ],
// //                         ),
// //                       ),
// //                     ],
// //                   ),
// //                 ),
// //               ),
// //               const SizedBox(height: 8),
// //               ElevatedButton(
// //                 onPressed: pickImageGallery,
// //                 style: ElevatedButton.styleFrom(
// //                   padding: const EdgeInsets.symmetric(horizontal: 300, vertical: 10),
// //                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
// //                   foregroundColor: Colors.black,
// //                 ),
// //                 child: const Text("Pick from Gallery"),
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'package:flutter_tflite/flutter_tflite.dart';
// import 'package:image_picker/image_picker.dart';
//
// import 'dart:developer' as devtools;
//
// void main() {
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//       ),
//       home: MyHomePage(),
//     );
//   }
// }
//
// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key});
//
//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<MyHomePage> {
//
//   File? filePath;
//
//   double confidence = 0.0;
//   String label = '';
//
//
//   Future<void> _tfliteInit() async{
//     String? res = await Tflite.loadModel(
//         model: "assets/model_unquant.tflite",
//         labels: "assets/labels.txt",
//         numThreads: 1, // defaults to 1
//         isAsset: true, // defaults to true, set to false to load resources outside assets
//         useGpuDelegate: false // defaults to false, set to true to use GPU delegate
//     );
//   }
//
//   pickImageGallery() async{
//     final ImagePicker picker = ImagePicker();
// // Pick an image.
//     final XFile? image = await picker.pickImage(source: ImageSource.gallery);
//
//     if(image == null){
//       return;
//     }
//
//     var imageMap = File(image.path);
//
//     setState(() {
//       filePath = imageMap;
//     });
//
//
//
//     var recognitions = await Tflite.runModelOnImage(
//         path: image.path,   // required
//         imageMean: 0.0,   // defaults to 117.0
//         imageStd: 255.0,  // defaults to 1.0
//         numResults: 2,    // defaults to 5
//         threshold: 0.2,   // defaults to 0.1
//         asynch: true      // defaults to true
//     );
//
//     if(recognitions == null){
//       //print("Recognitions is Null");
//       devtools.log("Recognitions is Null");
//       return;
//     }
//
//     //print(recognitions);
//     devtools.log(recognitions.toString());
//
//     setState(() {
//       confidence = (recognitions[0]['confidence'] * 100);
//       label = (recognitions[0]['label'].toString());
//     });
//   }
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     _tfliteInit();
//   }
//
//
//   @override
//   void dispose() {
//     // TODO: implement dispose
//     super.dispose();
//     Tflite.close();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Mango Dresses Detection")),
//       body: SingleChildScrollView(
//         child: Center(
//           child: Column(
//             children: [
//               const SizedBox(height: 12),
//               Card(
//                 elevation: 20,
//                 clipBehavior: Clip.hardEdge,
//                 child: SizedBox(
//                   width: 300,
//                   child: SingleChildScrollView(
//                     child: Column(
//                       children: [
//                         SizedBox(height: 18),
//                         Container(
//                             height: 280,
//                             width: 280,
//                             decoration: BoxDecoration(
//                               color: Colors.white,
//                               borderRadius: BorderRadius.circular(12),
//                               image: const DecorationImage(
//                                 image: AssetImage('assets/upload.jpg'),
//                               ),
//                             ),
//                             child: filePath==null? const Text(''):
//                             Image.file(filePath!, fit: BoxFit.fill,)
//                         ),
//                         SizedBox(height: 12),
//                         Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Column(
//                             children: [
//                               Text(
//                                 //"Label",
//                                 label,
//                                 style: TextStyle(
//                                   fontSize: 18,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                               const SizedBox(height: 12),
//                               Text(
//                                 "The Accuracy is ${confidence.toStringAsFixed(0)}", //90%",
//                                 style: const TextStyle(
//                                   fontSize: 18,
//                                   //fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                               const SizedBox(height: 12),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 8),
//
//               ElevatedButton(
//                 onPressed: () {
//
//                 },
//                 style: ElevatedButton.styleFrom(
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 300,
//                       vertical: 10,
//                     ),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(13),
//                     ),
//                     foregroundColor: Colors.black
//                 ),
//                 child: const Text("Take a photo"),
//               ),
//               const SizedBox(
//                 height: 8,
//               ),
//               ElevatedButton(
//                 onPressed: () {
//                   pickImageGallery();
//                 },
//                 style: ElevatedButton.styleFrom(
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 300,
//                       vertical: 10,
//                     ),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(13),
//                     ),
//                     foregroundColor: Colors.black
//                 ),
//                 child: const Text("Pick from Gallery"),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
