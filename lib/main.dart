import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BluetoothScreen(),
    );
  }
}

class BluetoothScreen extends StatefulWidget {
  @override
  _BluetoothScreenState createState() => _BluetoothScreenState();
}

class _BluetoothScreenState extends State<BluetoothScreen> {
  // Initialize the Bluetooth service
  FlutterBlue flutterBlue = FlutterBlue.instance;

  // List to store the available devices
  List<ScanResult> scanResults = <ScanResult>[];

  // Variable to store the selected device
  BluetoothDevice? selectedDevice;

  // Variable to store the connection state
  bool isConnected = false;

  // UUID for the characteristic you want to write to
  final String characteristicUuid = "0000";

  @override
  void initState() {
    super.initState();
// Start scanning for devices
    flutterBlue.startScan(timeout: Duration(seconds: 5));
    flutterBlue.scanResults.listen((results) {
      setState(() {
        scanResults = results;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Smart Belt'),
      ),
      body: Column(
        children: <Widget>[
// List to display the available devices
          Expanded(
            child: ListView.builder(
              itemCount: scanResults.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(scanResults[index].device.name),
                  onTap: () {
// Store the selected device
                    selectedDevice = scanResults[index].device;
                    setState(() {});
                  },
                );
              },
            ),
          ),
// Button to connect to the selected device
          selectedDevice != null
              ? ElevatedButton(
                  child: Text('Connect'),
                  onPressed: () async {
// Connect to the selected device
                    await selectedDevice?.connect();
                    setState(() {
                      isConnected = true;
                    });
                  },
                )
              : Container(),
// Buttons to send data to control the direction of the device
          isConnected
              ? Column(
                  children: <Widget>[
                    ElevatedButton(
                      child: Text('UP'),
                      onPressed: () async {
// Send data to the connected device to move it up
                        List<int> data = [1];
                        await selectedDevice
                            ?.discoverServices()
                            .then((services) {
                          services.forEach((service) {
                            service.characteristics.forEach((characteristic) {
                              if (characteristic.uuid.toString() ==
                                  characteristicUuid) {
                                characteristic.write(data);
                              }
                            });
                          });
                        });
                      },
                    ),
                    ElevatedButton(
                      child: Text('DOWN'),
                      onPressed: () async {
// Send data to the connected device to move it down
                        List<int> data = [2];
                        await selectedDevice
                            ?.discoverServices()
                            .then((services) {
                          services.forEach((service) {
                            service.characteristics.forEach((characteristic) {
                              if (characteristic.uuid.toString() ==
                                  characteristicUuid) {
                                characteristic.write(data);
                              }
                            });
                          });
                        });
                      },
                    ),
                    ElevatedButton(
                      child: Text('LEFT'),
                      onPressed: () async {
// Send data to the connected device to move it left
                        List<int> data = [3];
                        await selectedDevice
                            ?.discoverServices()
                            .then((services) {
                          services.forEach((service) {
                            service.characteristics.forEach((characteristic) {
                              if (characteristic.uuid.toString() ==
                                  characteristicUuid) {
                                characteristic.write(data);
                              }
                            });
                          });
                        });
                      },
                    ),
                    ElevatedButton(
                      child: Text('RIGHT'),
                      onPressed: () async {
// Send data to the connected device to move it right
                        List<int> data = [4];
                        await selectedDevice
                            ?.discoverServices()
                            .then((services) {
                          services.forEach((service) {
                            service.characteristics.forEach((characteristic) {
                              if (characteristic.uuid.toString() ==
                                  characteristicUuid) {
                                characteristic.write(data);
                              }
                            });
                          });
                        });
                      },
                    ),
                    ElevatedButton(
                      child: Text('Disconnect'),
                      onPressed: () async {
// Disconnect from the connected device
                        await selectedDevice?.disconnect();
                        setState(() {
                          isConnected = false;
                        });
                      },
                    )
                  ],
                )
              : Container(),
        ],
      ),
    );
  }
}