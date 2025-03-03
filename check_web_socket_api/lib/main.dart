import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

typedef OnDataReceived = void Function(String data);

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IoT WebSocket App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: WebSocketScreen(),
    );
  }
}

class WebSocketScreen extends StatefulWidget {
  @override
  _WebSocketScreenState createState() => _WebSocketScreenState();
}

class _WebSocketScreenState extends State<WebSocketScreen> {
  final WebSocketChannel channel = IOWebSocketChannel.connect(
      'wss://9obzmamyn7.execute-api.ap-southeast-1.amazonaws.com/prod?device_id=master');
  List<Map<String, dynamic>> receivedData = [];

  @override
  void initState() {
    super.initState();
    channel.stream.listen((data) {
      try {
        Map<String, dynamic> jsonData = jsonDecode(data);
        setState(() {
          receivedData.add(jsonData);
        });
      } catch (e) {
        print('Error parsing JSON: $e');
      }
    });
  }

  @override
  void dispose() {
    channel.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('WebSocket IoT Data')),
      body: receivedData.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: receivedData.length,
              itemBuilder: (context, index) {
                var data = receivedData[index];
                return ListTile(
                  title: Text(
                      'Location: ${data["location"]}, Device: ${data["device_id"]}'),
                  subtitle: Text(
                      'PM1.0: ${data["values"]["pm1_0"]}, PM2.5: ${data["values"]["pm2_5"]}, PM10: ${data["values"]["pm10"]}'),
                );
              },
            ),
    );
  }
}
