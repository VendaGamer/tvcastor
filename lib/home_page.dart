import 'package:flutter/material.dart';
import 'package:tvcastor/device_widgets.dart';
import 'package:castscreen/castscreen.dart' as upnp;

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isBusy = false;
  List<upnp.Device> _devices = [];

  Future<List<upnp.Device>> _discoverDevices() async {
    final devices = await upnp.CastScreen.discoverDevice(
        ipv4: true, ipv6: true, ST: 'upnp:rootdevice');
    devices.forEach(print);
    return devices;
  }

  void discovery() async {
    if (isBusy) return;
    isBusy = true;
    final found = await _discoverDevices();
    setState(() {
      _devices = found;
    });
    isBusy = false;
  }

  void ShowSideBar() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TVCastOR'),
        centerTitle: true,
        leading:
            IconButton(onPressed: ShowSideBar, icon: const Icon(Icons.menu)),
        actions: [
          IconButton(
            disabledColor: Colors.grey,
            onPressed: discovery,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: DeviceList(
        devices: _devices,
      ),
    );
  }
}
