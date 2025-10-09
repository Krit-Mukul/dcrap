import 'package:dcrap/models/scrap_item.dart';
import 'package:flutter/material.dart';

class Booking {
  final String id;
  final List<ScrapItem> items;
  final String name;
  final String phone;
  final String address;
  final String pincode;
  final DateTime? scheduledDate;
  final TimeOfDay? scheduledTime;
  final bool isAsap;
  final bool autoPickupEnabled;
  final int autoInterval;
  final String autoUnit;
  final double totalAmount;

  Booking({
    required this.id,
    required this.items,
    required this.name,
    required this.phone,
    required this.address,
    required this.pincode,
    this.scheduledDate,
    this.scheduledTime,
    required this.isAsap,
    this.autoPickupEnabled = false,
    this.autoInterval = 2,
    this.autoUnit = 'Weeks',
    required this.totalAmount,
  });
}
