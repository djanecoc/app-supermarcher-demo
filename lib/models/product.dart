class Product {
  final String id;
  final String name;
  final String categoryId;
  final double price;
  final double? oldPrice;
  final String unit; // e.g. "kg", "pièce", "bouteille 1.5L", "pack de 6", "sac de 5 kg", "lot de 5"
  final String? packagingDetail; // e.g. "1 kg de bananes", "1 sac de 5 kg", "5 maïs doux", "1 pièce fraîche"
  final String imageUrl;
  final String description;
  final bool isPromo;
  final double rating;
  final bool inStock;

  const Product({
    required this.id,
    required this.name,
    required this.categoryId,
    required this.price,
    this.oldPrice,
    required this.unit,
    this.packagingDetail,
    required this.imageUrl,
    required this.description,
    this.isPromo = false,
    this.rating = 4.8,
    this.inStock = true,
  });

  bool get hasDiscount => oldPrice != null && oldPrice! > price;
  int get discountPercent {
    if (!hasDiscount) return 0;
    return (((oldPrice! - price) / oldPrice!) * 100).round();
  }

  /// Label décrivant le format unitaire (ex: "1 kg de bananes", "1 sac de 5 kg", "5 maïs")
  String get basePackagingLabel {
    if (packagingDetail != null && packagingDetail!.isNotEmpty) {
      return packagingDetail!;
    }
    final u = unit.trim().toLowerCase();
    if (u == 'kg' || u == '1 kg') return '1 kg de $name';
    if (u == 'pièce' || u == 'piece' || u == '1 pièce') return '1 pièce ($name)';
    if (u == 'botte') return '1 botte de $name';
    if (u.startsWith('sac')) return '1 $unit de $name';
    if (u.startsWith('lot')) return '$unit de $name';
    if (u.startsWith('pack')) return '$unit de $name';
    if (u.startsWith('plaquette')) return unit;
    if (u.startsWith('bouteille')) return '1 $unit';
    if (u.startsWith('sachet')) return '1 $unit';
    if (u.startsWith('filet')) return '1 $unit';
    return '1 $unit de $name';
  }

  /// Label court pour l'affichage sur la carte produit (ex: "le kg", "la pièce", "le sac 5kg")
  String get unitLabelForCard {
    final u = unit.trim().toLowerCase();
    if (u == 'kg' || u == '1 kg') return 'le kg';
    if (u == 'pièce' || u == 'piece') return 'la pièce';
    if (u == 'botte') return 'la botte';
    if (u.startsWith('sac')) return 'le $unit';
    if (u.startsWith('lot')) return 'le $unit';
    if (u.startsWith('pack')) return 'le $unit';
    if (u.startsWith('plaquette')) return 'la $unit';
    if (u.startsWith('bouteille')) return 'la $unit';
    if (u.startsWith('filet')) return 'le $unit';
    return 'par $unit';
  }

  /// Phrase détaillée indiquant précisément la quantité et ce qu'elle vaut
  /// Ex: "1 kg de bananes à 1 200 FCFA", "1 sac de 5 kg à 2 500 FCFA", "5 maïs doux à 500 FCFA"
  String getQuantityDetailText(int qty) {
    final u = unit.trim().toLowerCase();
    if (qty <= 1) {
      return basePackagingLabel;
    }
    if (u == 'kg' || u == '1 kg') {
      return '$qty kg de $name';
    }
    if (u == '500g') {
      final totalKg = qty * 0.5;
      final kgStr = totalKg == totalKg.roundToDouble()
          ? '${totalKg.toInt()} kg'
          : '${totalKg.toStringAsFixed(1)} kg';
      return '$qty sachets de 500g ($kgStr au total)';
    }
    if (u == 'pièce' || u == 'piece') {
      return '$qty pièces de $name';
    }
    if (u == 'botte') {
      return '$qty bottes de $name';
    }
    if (u.startsWith('sac')) {
      return '$qty sacs ($unit)';
    }
    if (u.contains('5')) {
      return '$qty lots (${qty * 5} maïs au total)';
    }
    if (u.contains('3')) {
      return '$qty lots (${qty * 3} unités au total)';
    }
    if (u.startsWith('pack')) {
      return '$qty packs ($unit)';
    }
    if (u.startsWith('plaquette')) {
      return '$qty plaquettes (${qty * 30} œufs au total)';
    }
    return '$qty x ($unit)';
  }
}

