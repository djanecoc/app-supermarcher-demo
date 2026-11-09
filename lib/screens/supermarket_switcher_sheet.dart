import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/market_provider.dart';

class SupermarketSwitcherSheet extends StatefulWidget {
  const SupermarketSwitcherSheet({super.key});

  @override
  State<SupermarketSwitcherSheet> createState() => _SupermarketSwitcherSheetState();
}

class _SupermarketSwitcherSheetState extends State<SupermarketSwitcherSheet> {
  bool _isCustomMode = false;
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;
  late Color _customColor;

  final List<Color> _brandColors = const [
    Color(0xFF1E88E5), // Blue Hayat
    Color(0xFFD32F2F), // Red CDCI
    Color(0xFF0072CE), // Carrefour Blue
    Color(0xFF2E7D32), // Green Sococe
    Color(0xFFFF6D00), // Orange
    Color(0xFF6A1B9A), // Purple
  ];

  @override
  void initState() {
    super.initState();
    final current = context.read<MarketProvider>().activeSupermarket;
    _nameController = TextEditingController(text: current.name);
    _phoneController = TextEditingController(text: current.phone);
    _addressController = TextEditingController(text: current.address);
    _customColor = current.primaryColor;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<MarketProvider>();
    final activeId = provider.activeSupermarket.id;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle bar
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Title
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '🏬 Choisir le Supermarché',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () => setState(() => _isCustomMode = !_isCustomMode),
                    icon: Icon(_isCustomMode ? Icons.list_rounded : Icons.edit_rounded, size: 16),
                    label: Text(_isCustomMode ? 'Préréglages' : 'Personnaliser'),
                  ),
                ],
              ),
              Text(
                'Changez l\'enseigne instantanément avant d\'entrer en rendez-vous client.',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
              ),
              const SizedBox(height: 16),

              if (!_isCustomMode) ...[
                // Presets list
                ...provider.allSupermarkets.map((sm) {
                  final isSelected = activeId == sm.id;
                  return GestureDetector(
                    onTap: () {
                      provider.setSupermarket(sm);
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isSelected ? sm.primaryColor.withValues(alpha: 0.08) : Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected ? sm.primaryColor : Colors.grey.shade200,
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 18,
                            backgroundColor: sm.primaryColor,
                            child: const Icon(Icons.store, color: Colors.white, size: 18),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  sm.name,
                                  style: TextStyle(
                                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                                    fontSize: 14,
                                    color: isSelected ? sm.primaryColor : Colors.black87,
                                  ),
                                ),
                                Text(
                                  sm.address,
                                  style: TextStyle(color: Colors.grey.shade600, fontSize: 11),
                                ),
                              ],
                            ),
                          ),
                          if (isSelected)
                            Icon(Icons.check_circle_rounded, color: sm.primaryColor, size: 20),
                        ],
                      ),
                    ),
                  );
                }),
              ] else ...[
                // Custom store form
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Nom du Supermarché',
                    prefixIcon: const Icon(Icons.storefront_rounded),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _addressController,
                  decoration: InputDecoration(
                    labelText: 'Quartier / Adresse',
                    prefixIcon: const Icon(Icons.location_on_outlined),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: 'Numéro WhatsApp du gérant',
                    prefixIcon: const Icon(Icons.phone),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                const SizedBox(height: 14),
                const Text('Couleur de la marque :', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                const SizedBox(height: 8),
                Row(
                  children: _brandColors.map((color) {
                    final isPicked = _customColor.toARGB32() == color.toARGB32();
                    return GestureDetector(
                      onTap: () => setState(() => _customColor = color),
                      child: Container(
                        margin: const EdgeInsets.only(right: 12),
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                          border: isPicked ? Border.all(color: Colors.black87, width: 3) : null,
                        ),
                        child: isPicked ? const Icon(Icons.check, color: Colors.white, size: 18) : null,
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 18),
                SizedBox(
                  width: double.infinity,
                  height: 46,
                  child: ElevatedButton(
                    onPressed: () {
                      provider.updateSupermarketCustom(
                        name: _nameController.text.trim().isEmpty ? 'Mon Supermarché' : _nameController.text.trim(),
                        slogan: 'Courses en ligne & livraison rapide',
                        primaryColor: _customColor,
                        phone: _phoneController.text.trim(),
                        address: _addressController.text.trim(),
                      );
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _customColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text('Appliquer à l\'application', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

