import 'package:flutter/material.dart';
import 'package:tvcastor/device_widgets.dart';
import 'package:upnp2/upnp.dart' as upnp;

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _deviceDiscover = upnp.DeviceDiscoverer();
  bool isBusy = false;
  List<upnp.Device> _devices = [];

  void _discoverDevices() async {
    if (isBusy) return;
    setState(() {
      isBusy = true;
      _devices.clear();
    });
    print('start');
    await _deviceDiscover.start(ipv4: true, ipv6: true);
    _deviceDiscover
        .quickDiscoverClients(
      unique: true,
    )
        .listen(
      (client) async {
        var device = await client.getDevice();
        if (device == null) return;
        print(device);
        setState(() {
          _devices.add(device);
        });
      },
    ).onDone(
      () {
        setState(() {
          isBusy = false;
        });
        print('end');
        _deviceDiscover.stop();
      },
    );
  }

  @override
  void initState() {
    super.initState();
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
            onPressed: _discoverDevices,
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
