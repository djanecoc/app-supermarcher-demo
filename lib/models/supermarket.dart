import 'package:flutter/material.dart';

class Supermarket {
  final String id;
  final String name;
  final String slogan;
  final Color primaryColor;
  final Color accentColor;
  final String phone;
  final String whatsappNumber; // e.g. "2250700000000"
  final String address;
  final double minOrderAmount;
  final double deliveryFee;
  final String? logoAsset;

  const Supermarket({
    required this.id,
    required this.name,
    required this.slogan,
    required this.primaryColor,
    required this.accentColor,
    required this.phone,
    required this.whatsappNumber,
    required this.address,
    this.minOrderAmount = 3000,
    this.deliveryFee = 1000,
    this.logoAsset,
  });

  Supermarket copyWith({
    String? name,
    String? slogan,
    Color? primaryColor,
    Color? accentColor,
    String? phone,
    String? whatsappNumber,
    String? address,
    double? minOrderAmount,
    double? deliveryFee,
    String? logoAsset,
  }) {
    return Supermarket(
      id: id,
      name: name ?? this.name,
      slogan: slogan ?? this.slogan,
      primaryColor: primaryColor ?? this.primaryColor,
      accentColor: accentColor ?? this.accentColor,
      phone: phone ?? this.phone,
      whatsappNumber: whatsappNumber ?? this.whatsappNumber,
      address: address ?? this.address,
      minOrderAmount: minOrderAmount ?? this.minOrderAmount,
      deliveryFee: deliveryFee ?? this.deliveryFee,
      logoAsset: logoAsset ?? this.logoAsset,
    );
  }
}
