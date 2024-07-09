import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tvcastor/pages/webview_page_mobile.dart';
import 'package:castscreen/castscreen.dart' as upnp;

import 'pages/webview_page_windows.dart';

class DeviceWidget extends StatelessWidget {
  final upnp.Device device;

  const DeviceWidget({super.key, required this.device});

  @override
  Widget build(BuildContext context) {
    final friendlyName =
        device.spec.friendlyName;
    final urlBase = device.spec.URLBase;
    Widget icon;
    var iconUrl = device.spec.iconSpecs.first.url;
      print(iconUrl);
      icon = Image.network(iconUrl, width: 40, height: 40,
          errorBuilder: (context, error, stackTrace) {
        return const Icon(Icons.tv);
    });

    return GestureDetector(
      onTap: () {
        if (Platform.isWindows) {
          Navigator.of(context).push(
            MaterialPageRoute(
                builder: (context) => const WebViewPageWindows() //page webview
                ),
          );
        } else {
          Navigator.of(context).push(
            MaterialPageRoute(
                builder: (context) => const WebViewPage() //page webview
                ),
          );
        }
      },
      child: Container(
        color: Colors.amber[900],
        padding: const EdgeInsets.only(left: 20, top: 20, right: 20),
        child: Row(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                icon,
              ],
            ),
            const Spacer(),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(friendlyName),
                Text(urlBase),
              ],
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}

class DeviceList extends StatelessWidget {
  const DeviceList({super.key, required this.devices});
  final List<upnp.Device> devices;

  @override
  Widget build(BuildContext context) {
    // Access the devices from DeviceCentre singleton

    return devices.isEmpty
        ? const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('No Devices'),
                Text('Try to search'),
              ],
            ),
          )
        : ListView.builder(
            itemCount: devices.length,
            itemBuilder: (context, index) {
              return DeviceWidget(
                device: devices[index],
              );
            },
          );
  }
}
