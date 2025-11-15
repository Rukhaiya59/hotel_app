import 'package:flutter/material.dart';

enum EnumRoomStatus {
  available,
  busy,
  cleaning,
  blocked,
  unknown;

  static EnumRoomStatus fromString(String status) {
    switch (status.toLowerCase()) {
      case 'available':
        return EnumRoomStatus.available;
      case 'busy':
        return EnumRoomStatus.busy;
      case 'cleaning':
        return EnumRoomStatus.cleaning;
      case 'blocked':
        return EnumRoomStatus.blocked;
      default:
        return EnumRoomStatus.unknown;
    }
  }

  static Color getColor(String status) {
    EnumRoomStatus enumRoomStatus = EnumRoomStatus.fromString(status);
    switch (enumRoomStatus) {
      case EnumRoomStatus.available:
        return Colors.green;
      case EnumRoomStatus.busy:
        return Colors.red;
      case EnumRoomStatus.cleaning:
        return Colors.orange;
      case EnumRoomStatus.blocked:
        return Colors.grey;
      default:
        return Colors.blueGrey;
    }
  }
}