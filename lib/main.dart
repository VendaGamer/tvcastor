import 'package:castscreen/castscreen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart' as awesome;

void main() {
  runApp(const Base());
}

Future<List<Device>> discoverDevices() async {
  final devices = await CastScreen.discoverDevice();
  for (var device in devices) {
    print(device.services);
  }
  return devices;
}

class Base extends StatelessWidget {
  const Base({super.key});
  @override
  Widget build(BuildContext context) {
    List<Device> devices = [];
    Device currentDevice;
    bool isBusy = false;
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            appBar: AppBar(
              title: const Text('TVCastOR'),
              centerTitle: true,
              actions: const [
                awesome.FaIcon(
                  awesome.FontAwesomeIcons.solidBell,
                ),
              ],
            ),
            body: Column(
              children: [
                Row(
                  children: [
                    const Column(
                      children: [Text('Devices')],
                    ),
                    FilledButton(
                      onPressed: () async {
                        if (!isBusy) {
                          isBusy = true;
                          devices = await discoverDevices();
                          isBusy = false;
                        }
                      },
                      child: const awesome.FaIcon(
                          awesome.FontAwesomeIcons.satellite),
                    ),
                  ],
                ),
                const Row(
                  children: [],
                ),
                const Row(
                  children: [],
                ),
              ],
            )),
        theme: ThemeData.light().copyWith(
          colorScheme:
              const ColorScheme.light().copyWith(onPrimary: Colors.amber),
          iconTheme: const IconThemeData(size: 36.0, color: Colors.black87),
          textTheme: const TextTheme(
            bodyMedium: TextStyle(fontSize: 16.0, color: Colors.black87),
          ),
        ));
  }
}
