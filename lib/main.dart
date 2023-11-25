import 'dart:ffi';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:tflite_flutter/tflite_flutter.dart' as tfl;
import 'package:flutter/material.dart';

// List<CameraDescription>? cameras;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // cameras = await availableCameras();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double result = 0.0;

  // initCamera() {
  //   cameraController = CameraController(cameras![0], ResolutionPreset.medium);
  //   cameraController.initialize().then((value) {
  //     if (!mounted) return;
  //     setState(() {
  //       cameraController.startImageStream((imageStream) {
  //           cameraImage = imageStream;
  //           runModel();
  //       });
  //     });
  //   });
  // }

  // loadModel() async {
  //   await Tflite.loadModel(
  //       model: "assets/number_predictor.tflite", labels: "assets/labels.txt");
  // }

  runModel(double no) async {
    final interpreter =
        await tfl.Interpreter.fromAsset('assets/number_predictor.tflite');
    final input = [
      [no]
    ];
    var output = List.filled(1, 0).reshape([1, 1]);
    interpreter.run(input, output);
    result = output[0][0];
    print(output);
    setState(() {});
    // return  as double;
  }

  @override
  void initState() {
    super.initState();
    // initCamera();
    // loadModel();
  }

  TextEditingController noController = TextEditingController();
  FocusNode noFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Number predictor"),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextFormField(
                onTapOutside: (event){
                  noFocus.unfocus();
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                controller: noController,
                inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'(^\d*\.?\d*)'))],
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), hintText: 'Enter a Number'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: MaterialButton(
                  color: Colors.black,
                  child: const Text('Process'),
                  onPressed: () {
                    runModel(double.parse(noController.text));
                  }),
            ),

            Text(
              result.toString(),
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            )
          ],
        ),
      ),
    );
  }
}
