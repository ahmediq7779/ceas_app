import 'dart:convert';

/// Model representing stored local unit prices for engineering materials & works
class RateSettingsModel {
  final String currency;
  final double cementBagPrice; // Price per 50kg bag
  final double sandPricePerM3; // Price per m³
  final double gravelPricePerM3; // Price per m³
  final double readyMixConcretePerM3; // Price per m³
  final double blockPricePerThousand; // Price per 1000 blocks
  final double rebarPricePerTon; // Price per Metric Ton
  final double formworkPricePerM2; // Price per m² of contact area
  final double excavationPricePerM3; // Price per m³
  final double backfillPricePerM3; // Price per m³

  const RateSettingsModel({
    this.currency = 'SAR',
    this.cementBagPrice = 25.0,
    this.sandPricePerM3 = 35.0,
    this.gravelPricePerM3 = 45.0,
    this.readyMixConcretePerM3 = 240.0,
    this.blockPricePerThousand = 2200.0,
    this.rebarPricePerTon = 3100.0,
    this.formworkPricePerM2 = 40.0,
    this.excavationPricePerM3 = 18.0,
    this.backfillPricePerM3 = 25.0,
  });

  RateSettingsModel copyWith({
    String? currency,
    double? cementBagPrice,
    double? sandPricePerM3,
    double? gravelPricePerM3,
    double? readyMixConcretePerM3,
    double? blockPricePerThousand,
    double? rebarPricePerTon,
    double? formworkPricePerM2,
    double? excavationPricePerM3,
    double? backfillPricePerM3,
  }) {
    return RateSettingsModel(
      currency: currency ?? this.currency,
      cementBagPrice: cementBagPrice ?? this.cementBagPrice,
      sandPricePerM3: sandPricePerM3 ?? this.sandPricePerM3,
      gravelPricePerM3: gravelPricePerM3 ?? this.gravelPricePerM3,
      readyMixConcretePerM3: readyMixConcretePerM3 ?? this.readyMixConcretePerM3,
      blockPricePerThousand: blockPricePerThousand ?? this.blockPricePerThousand,
      rebarPricePerTon: rebarPricePerTon ?? this.rebarPricePerTon,
      formworkPricePerM2: formworkPricePerM2 ?? this.formworkPricePerM2,
      excavationPricePerM3: excavationPricePerM3 ?? this.excavationPricePerM3,
      backfillPricePerM3: backfillPricePerM3 ?? this.backfillPricePerM3,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'currency': currency,
      'cementBagPrice': cementBagPrice,
      'sandPricePerM3': sandPricePerM3,
      'gravelPricePerM3': gravelPricePerM3,
      'readyMixConcretePerM3': readyMixConcretePerM3,
      'blockPricePerThousand': blockPricePerThousand,
      'rebarPricePerTon': rebarPricePerTon,
      'formworkPricePerM2': formworkPricePerM2,
      'excavationPricePerM3': excavationPricePerM3,
      'backfillPricePerM3': backfillPricePerM3,
    };
  }

  factory RateSettingsModel.fromMap(Map<String, dynamic> map) {
    return RateSettingsModel(
      currency: map['currency'] ?? 'SAR',
      cementBagPrice: (map['cementBagPrice'] as num?)?.toDouble() ?? 25.0,
      sandPricePerM3: (map['sandPricePerM3'] as num?)?.toDouble() ?? 35.0,
      gravelPricePerM3: (map['gravelPricePerM3'] as num?)?.toDouble() ?? 45.0,
      readyMixConcretePerM3: (map['readyMixConcretePerM3'] as num?)?.toDouble() ?? 240.0,
      blockPricePerThousand: (map['blockPricePerThousand'] as num?)?.toDouble() ?? 2200.0,
      rebarPricePerTon: (map['rebarPricePerTon'] as num?)?.toDouble() ?? 3100.0,
      formworkPricePerM2: (map['formworkPricePerM2'] as num?)?.toDouble() ?? 40.0,
      excavationPricePerM3: (map['excavationPricePerM3'] as num?)?.toDouble() ?? 18.0,
      backfillPricePerM3: (map['backfillPricePerM3'] as num?)?.toDouble() ?? 25.0,
    );
  }

  String toJson() => json.encode(toMap());

  factory RateSettingsModel.fromJson(String source) =>
      RateSettingsModel.fromMap(json.decode(source));
}
