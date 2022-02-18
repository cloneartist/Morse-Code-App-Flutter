import 'package:flutter/material.dart';
import 'package:torch_light/torch_light.dart';
import 'morseconvert.dart';

class MorseTorch extends StatefulWidget {
  const MorseTorch({Key? key}) : super(key: key);

  @override
  State<MorseTorch> createState() => _MorseTorchState();
}

class _MorseTorchState extends State<MorseTorch> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String inputText = "";
  late var encodeMorse = "";

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: FutureBuilder<bool>(
          future: _isTorchAvailable(context),
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            if (snapshot.hasData && snapshot.data!) {
              return Column(
                children: [
                  const Spacer(
                    flex: 1,
                  ),
                  const Text(
                    "Morse Code \n Converter",
                    style: TextStyle(fontSize: 30),
                  ),
                  const Spacer(),
                  Form(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        style: const TextStyle(color: Colors.black),
                        decoration: textInputDecoration.copyWith(
                          labelText: 'Enter text to convert',
                        ),
                        onChanged: (val) {
                          setState(() => inputText = val);
                          print(inputText);
                        },
                      ),
                    ),
                  ),
                  const Spacer(),
                  Expanded(
                    child: Center(
                      child: ElevatedButton(
                        child: const Text('Encode'),
                        onPressed: () async {
                          encodeMorse = Morse().encode(inputText);
                          // encodeMorse = encodeMorse + "x";
                          print(encodeMorse); //
                          // encodeMorse.split("").forEach((ch) => ch == '.'
                          //     ? _enableMorseDit(context)
                          //     : ch == "-"
                          //         ? _enableMorseDaah(context)
                          //         : print("space"));
                          List<String> result = encodeMorse.split('');
                          // result.add("end");
                          print(result);

                          for (var x in result) {
                            print(x);

                            if (x == ".") {
                              await _enableMorseDit(context);
                            } else if (x == "-") {
                              await _enableMorseDaah(context);
                            } else {
                              await Future.delayed(const Duration(seconds: 1));
                            }
                          }
                        },
                      ),
                    ),
                  ),
                  const Spacer()
                ],
              );
            } else if (snapshot.hasData) {
              return const Center(
                child: Text('No torch available.'),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }

  Future<bool> _isTorchAvailable(BuildContext context) async {
    try {
      return await TorchLight.isTorchAvailable();
    } on Exception catch (_) {
      _showMessage(
        'Could not check if the device has an available torch',
        context,
      );
      rethrow;
    }
  }

  Future<void> _enableMorseDit(BuildContext context) async {
    try {
      print("dit");
      await TorchLight.enableTorch();
      await Future.delayed(const Duration(seconds: 1), () {});
      await TorchLight.disableTorch();
    } on Exception catch (_) {
      _showMessage('Could not enable torch', context);
    }
  }

  Future<void> _enableMorseDaah(BuildContext context) async {
    try {
      print("daah");
      await TorchLight.enableTorch();
      await Future.delayed(const Duration(seconds: 3), () {});
      await TorchLight.disableTorch();
    } on Exception catch (_) {
      _showMessage('Could not enable torch', context);
    }
  }

  void _showMessage(String message, BuildContext context) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }
}

dynamic textInputDecoration = InputDecoration(
  labelStyle: const TextStyle(
    color: Colors.black,
  ),
  fillColor: Colors.black,
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(25),
    borderSide: const BorderSide(width: 1, color: Colors.black),
  ),
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(25),
    borderSide: const BorderSide(width: 1, color: Colors.pink),
  ),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(25),
    borderSide: const BorderSide(),
  ),
);
