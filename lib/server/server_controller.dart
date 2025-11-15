import 'dart:io';
import 'package:get/get.dart';

class ServerController extends GetxController {
  ServerSocket? _server;
  RawDatagramSocket? _udp;
  final RxBool isRunning = false.obs;
  final RxList<String> messages = <String>[].obs;
  final List<Socket> _clients = [];

  // Start server (TCP + UDP broadcast)
  Future<void> startServer({int tcpPort = 4040, int udpPort = 4444}) async {
    try {
      // TCP Server
      _server = await ServerSocket.bind(InternetAddress.anyIPv4, tcpPort);
      isRunning.value = true;
      messages.add("Server started on ${_server!.address.address}:$tcpPort");

      _server!.listen((client) {
        _clients.add(client);
        messages.add("Client connected: ${client.remoteAddress.address}");

        client.listen((data) {
          final msg = String.fromCharCodes(data).trim();
          messages.add("Client: $msg");
        }, onDone: () {
          messages.add("Client disconnected");
          _clients.remove(client);
        });
      });

      // UDP broadcaster
      _udp = await RawDatagramSocket.bind(InternetAddress.anyIPv4, udpPort);
      _udp!.broadcastEnabled = true;

      final serverIp = await _getLocalIp();
      messages.add("Broadcasting server IP: $serverIp on UDP $udpPort");

      // Keep broadcasting
      Future.doWhile(() async {
        if (_udp == null) return false;
        _udp!.send(serverIp.codeUnits, InternetAddress("255.255.255.255"), udpPort);
        await Future.delayed(Duration(seconds: 5));
        return true;
      });
    } catch (e) {
      messages.add("Error starting server: $e");
    }
  }

  // Stop server
  void stopServer() {
    for (var c in _clients) {
      c.destroy();
    }
    _clients.clear();
    _server?.close();
    _server = null;

    _udp?.close();
    _udp = null;

    isRunning.value = false;
    messages.add("Server stopped");
  }

  // Send message to all clients
  void sendMessage(String message) {
    for (var client in _clients) {
      client.write(message);
    }
    messages.add("Server: $message");
  }
  // Helper to get local IP
  Future<String> _getLocalIp() async {
    final interfaces = await NetworkInterface.list(
      includeLoopback: false,
      type: InternetAddressType.IPv4,
    );
    return interfaces.first.addresses.first.address;
  }
}