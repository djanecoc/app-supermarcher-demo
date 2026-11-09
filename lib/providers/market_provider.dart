import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../data/mock_data.dart';
import '../models/cart_item.dart';
import '../models/product.dart';
import '../models/supermarket.dart';

class MarketProvider extends ChangeNotifier {
  // Current Supermarket profile
  late Supermarket _activeSupermarket;
  
  // Products & Categories
  final List<Product> _allProducts = List.from(MockData.products);
  String _selectedCategoryId = 'all';
  String _searchQuery = '';
  
  // Cart
  final Map<String, CartItem> _cart = {};

  // Favorites
  final Set<String> _favoriteProductIds = {};

  // Promo code
  String? _appliedPromoCode = 'HAYAT15';
  double _promoDiscountPercent = 15.0;

  // Delivery options
  bool _isDelivery = true; // true = livraison, false = click & collect
  String _deliveryAddress = 'Cocody Angré 8ème Tranche, Abidjan';
  String _customerName = 'Mamadou Diallo';
  String _customerPhone = '+225 07 12 34 56 78';
  String _paymentMethod = 'Wave'; // Wave, Orange Money, MTN MoMo, Espèces

  MarketProvider() {
    _activeSupermarket = MockData.supermarkets.first;
  }

  // Getters
  Supermarket get activeSupermarket => _activeSupermarket;
  List<Supermarket> get allSupermarkets => MockData.supermarkets;
  String get selectedCategoryId => _selectedCategoryId;
  String get searchQuery => _searchQuery;
  Map<String, CartItem> get cart => _cart;
  bool get isDelivery => _isDelivery;
  String get deliveryAddress => _deliveryAddress;
  String get customerName => _customerName;
  String get customerPhone => _customerPhone;
  String get paymentMethod => _paymentMethod;
  String? get appliedPromoCode => _appliedPromoCode;
  double get promoDiscountPercent => _promoDiscountPercent;

  int get cartCount => _cart.values.fold(0, (sum, item) => sum + item.quantity);
  
  double get cartSubtotal => _cart.values.fold(0, (sum, item) => sum + item.totalPrice);
  
  double get promoDiscount => _appliedPromoCode != null ? (cartSubtotal * (_promoDiscountPercent / 100)) : 0;

  double get deliveryFee {
    if (!_isDelivery) return 0;
    // Livraison offerte si sous-total > 15 000 FCFA
    if (cartSubtotal >= 15000) return 0;
    return _activeSupermarket.deliveryFee;
  }
  
  double get cartTotal {
    final net = cartSubtotal - promoDiscount;
    return (net > 0 ? net : 0) + deliveryFee;
  }

  // Filtered products
  List<Product> get filteredProducts {
    return _allProducts.where((p) {
      final matchesCategory = _selectedCategoryId == 'all' || p.categoryId == _selectedCategoryId;
      final matchesSearch = _searchQuery.isEmpty ||
          p.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          p.description.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();
  }

  List<Product> get promoProducts => _allProducts.where((p) => p.isPromo).toList();

  bool isFavorite(String productId) => _favoriteProductIds.contains(productId);

  int getQuantity(String productId) => _cart[productId]?.quantity ?? 0;

  // Actions
  void setSupermarket(Supermarket supermarket) {
    _activeSupermarket = supermarket;
    notifyListeners();
  }

  void updateSupermarketCustom({
    required String name,
    required String slogan,
    required Color primaryColor,
    required String phone,
    required String address,
  }) {
    _activeSupermarket = _activeSupermarket.copyWith(
      name: name,
      slogan: slogan,
      primaryColor: primaryColor,
      phone: phone,
      whatsappNumber: phone.replaceAll(RegExp(r'[^0-9]'), ''),
      address: address,
    );
    notifyListeners();
  }

  void selectCategory(String categoryId) {
    _selectedCategoryId = categoryId;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void toggleFavorite(String productId) {
    if (_favoriteProductIds.contains(productId)) {
      _favoriteProductIds.remove(productId);
    } else {
      _favoriteProductIds.add(productId);
    }
    notifyListeners();
  }

  void addToCart(Product product) {
    if (_cart.containsKey(product.id)) {
      _cart[product.id]!.quantity += 1;
    } else {
      _cart[product.id] = CartItem(product: product, quantity: 1);
    }
    notifyListeners();
  }

  void removeFromCart(String productId) {
    if (!_cart.containsKey(productId)) return;
    if (_cart[productId]!.quantity > 1) {
      _cart[productId]!.quantity -= 1;
    } else {
      _cart.remove(productId);
    }
    notifyListeners();
  }

  void deleteFromCart(String productId) {
    _cart.remove(productId);
    notifyListeners();
  }

  void clearCart() {
    _cart.clear();
    notifyListeners();
  }

  void setDeliveryMode(bool isDelivery) {
    _isDelivery = isDelivery;
    notifyListeners();
  }

  void setDeliveryAddress(String address) {
    _deliveryAddress = address;
    notifyListeners();
  }

  void setCustomerInfo({required String name, required String phone}) {
    _customerName = name;
    _customerPhone = phone;
    notifyListeners();
  }

  void setPaymentMethod(String method) {
    _paymentMethod = method;
    notifyListeners();
  }

  void applyPromoCode(String code, {double discountPercent = 15.0}) {
    _appliedPromoCode = code.toUpperCase();
    _promoDiscountPercent = discountPercent;
    notifyListeners();
  }

  void removePromoCode() {
    _appliedPromoCode = null;
    notifyListeners();
  }

  // Format money e.g. "2 500 FCFA"
  static String formatPrice(double price) {
    final formatter = NumberFormat('#,###', 'fr_FR');
    return '${formatter.format(price.round()).replaceAll(',', ' ')} FCFA';
  }

  // Generate WhatsApp order text
  String generateOrderSummary() {
    final now = DateTime.now();
    final dateStr = DateFormat('dd/MM/yyyy à HH:mm').format(now);
    final buffer = StringBuffer();

    buffer.writeln('🛒 *NOUVELLE COMMANDE - ${_activeSupermarket.name.toUpperCase()}*');
    buffer.writeln('📅 Date: $dateStr');
    buffer.writeln('-----------------------------------');
    buffer.writeln('👤 *Client:* $_customerName');
    buffer.writeln('📞 *Contact:* $_customerPhone');
    buffer.writeln('📦 *Mode:* ${_isDelivery ? "🛵 Livraison à domicile" : "🏬 Retrait Click & Collect"}');
    if (_isDelivery) {
      buffer.writeln('📍 *Adresse:* $_deliveryAddress');
    }
    buffer.writeln('💳 *Paiement:* $_paymentMethod');
    buffer.writeln('-----------------------------------');
    buffer.writeln('🛍️ *ARTICLES COMMANDÉS :*');

    int index = 1;
    for (final item in _cart.values) {
      final lineTotal = formatPrice(item.totalPrice);
      buffer.writeln('$index. ${item.product.name}');
      buffer.writeln('   👉 ${item.quantity} x ${formatPrice(item.product.price)} = *$lineTotal*');
      index++;
    }

    buffer.writeln('-----------------------------------');
    buffer.writeln('Sous-total : ${formatPrice(cartSubtotal)}');
    if (_isDelivery) {
      buffer.writeln('Frais de livraison : ${formatPrice(deliveryFee)}');
    }
    buffer.writeln('💰 *TOTAL À PAYER : ${formatPrice(cartTotal)}*');
    buffer.writeln('-----------------------------------');
    buffer.writeln('Merci pour votre commande ! 🙏');

    return buffer.toString();
  }

  // Launch WhatsApp with order
  Future<bool> sendOrderViaWhatsApp() async {
    final message = generateOrderSummary();
    final targetPhone = _activeSupermarket.whatsappNumber.isNotEmpty
        ? _activeSupermarket.whatsappNumber
        : '2250700000000';
    
    final encodedMessage = Uri.encodeComponent(message);
    
    // Try universal wa.me link first
    final uri = Uri.parse('https://wa.me/$targetPhone?text=$encodedMessage');
    
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
      return true;
    } else {
      // Fallback to whatsapp:// scheme
      final deepUri = Uri.parse('whatsapp://send?phone=$targetPhone&text=$encodedMessage');
      if (await canLaunchUrl(deepUri)) {
        await launchUrl(deepUri);
        return true;
      }
    }
    return false;
  }
}

