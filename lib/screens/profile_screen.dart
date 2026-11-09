import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../providers/market_provider.dart';
import 'supermarket_switcher_sheet.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<MarketProvider>();
    final supermarket = provider.activeSupermarket;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F8FA),
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Center(
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey.shade200, width: 1),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 16, color: Colors.black87),
                padding: EdgeInsets.zero,
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ),
        ),
        centerTitle: true,
        title: const Text(
          'Profile',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.3,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Center(
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey.shade200, width: 1),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: IconButton(
                  icon: const Icon(Icons.settings_outlined, size: 20, color: Colors.black87),
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (_) => const SupermarketSwitcherSheet(),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
        child: Column(
          children: [
            // Avatar with edit button (Exact match to reference)
            Center(
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Container(
                    width: 104,
                    height: 104,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 3.5),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.08),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: Image.network(
                        'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=300&q=80',
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => CircleAvatar(
                          backgroundColor: supermarket.primaryColor,
                          child: const Icon(Icons.person, size: 52, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => _editProfileName(context, provider),
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.grey.shade200, width: 1),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.12),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Icon(Icons.edit_outlined, size: 16, color: Colors.black87),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // User Name
            Text(
              provider.customerName,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
                letterSpacing: -0.4,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Client privilégié • ${supermarket.name}',
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 22),

            // Primary Contact Info Card (Phone / Email / Address)
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.grey.shade100, width: 1),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 14,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _buildContactTile(
                    icon: Icons.phone_outlined,
                    label: 'Phone',
                    value: provider.customerPhone,
                    onTap: () => _editField(
                      context,
                      title: 'Numéro de Téléphone',
                      initialValue: provider.customerPhone,
                      onSave: (val) => provider.setCustomerInfo(name: provider.customerName, phone: val),
                    ),
                  ),
                  Divider(height: 1, thickness: 0.8, color: Colors.grey.shade100, indent: 64, endIndent: 20),
                  _buildContactTile(
                    icon: Icons.mail_outline_rounded,
                    label: 'Email',
                    value: 'client.hayat@gmail.com',
                    onTap: () => _editField(
                      context,
                      title: 'Adresse Email',
                      initialValue: 'client.hayat@gmail.com',
                      onSave: (val) {},
                    ),
                  ),
                  Divider(height: 1, thickness: 0.8, color: Colors.grey.shade100, indent: 64, endIndent: 20),
                  _buildContactTile(
                    icon: Icons.location_on_outlined,
                    label: 'Address',
                    value: provider.deliveryAddress,
                    onTap: () => _editField(
                      context,
                      title: 'Adresse de Livraison',
                      initialValue: provider.deliveryAddress,
                      onSave: (val) => provider.setDeliveryAddress(val),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 26),

            // Section Title: My documents (Matching reference layout)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'My documents',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                    letterSpacing: -0.2,
                  ),
                ),
                Icon(Icons.chevron_right_rounded, color: Colors.grey.shade400, size: 22),
              ],
            ),
            const SizedBox(height: 14),

            // 3 Square Activity Cards (Commandes, Fidélité, Bons d'achat)
            Row(
              children: [
                Expanded(
                  child: _buildSquareDocCard(
                    icon: Icons.receipt_long_outlined,
                    title: 'Commandes',
                    docCode: '3 passées',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildSquareDocCard(
                    icon: Icons.badge_outlined,
                    title: 'Fidélité',
                    docCode: '1 250 pts',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildSquareDocCard(
                    icon: Icons.confirmation_number_outlined,
                    title: 'Bons Promo',
                    docCode: '2 actifs',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 26),

            // Section Title: Banking Documents (Matching reference)
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Banking Documents',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                  letterSpacing: -0.2,
                ),
              ),
            ),
            const SizedBox(height: 14),

            // Banking / Statements & Claims Card
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.grey.shade100, width: 1),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 14,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _buildBankingRow(
                    icon: Icons.folder_outlined,
                    title: 'Statements',
                    subtitle: 'Reçus & Factures WhatsApp',
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Les factures sont automatiquement expédiées par WhatsApp lors de la commande.'),
                        ),
                      );
                    },
                  ),
                  Divider(height: 1, thickness: 0.8, color: Colors.grey.shade100, indent: 64, endIndent: 20),
                  _buildBankingRow(
                    icon: Icons.account_balance_wallet_outlined,
                    title: 'Claims',
                    subtitle: 'Moyens de Paiement (Wave, MoMo, Espèces)',
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Paiements activés : Wave, Orange Money, MTN MoMo, Espèces à la livraison.'),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 26),

            // Section Title: Supermarché & Assistance Démo
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Supermarché & Démo',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                  letterSpacing: -0.2,
                ),
              ),
            ),
            const SizedBox(height: 14),

            // Supermarket settings card
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.grey.shade100, width: 1),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 14,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
                    leading: Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: supermarket.primaryColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(Icons.storefront_rounded, color: supermarket.primaryColor, size: 22),
                    ),
                    title: const Text('Enseigne Active', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                    subtitle: Text('${supermarket.name} • Changer en 1 clic', style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                    trailing: const Icon(Icons.chevron_right_rounded, color: Colors.grey, size: 20),
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (_) => const SupermarketSwitcherSheet(),
                      );
                    },
                  ),
                  Divider(height: 1, thickness: 0.8, color: Colors.grey.shade100, indent: 64, endIndent: 20),
                  ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
                    leading: Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: const Color(0xFF25D366).withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.chat_rounded, color: Color(0xFF25D366), size: 22),
                    ),
                    title: const Text('Service Client WhatsApp', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                    subtitle: Text(supermarket.phone, style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                    trailing: const Icon(Icons.chevron_right_rounded, color: Colors.grey, size: 20),
                    onTap: () async {
                      final uri = Uri.parse('https://wa.me/${supermarket.whatsappNumber}');
                      if (await canLaunchUrl(uri)) {
                        await launchUrl(uri, mode: LaunchMode.externalApplication);
                      }
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),

            // Logout Button
            TextButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Session active en mode démonstration.'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              icon: const Icon(Icons.logout_rounded, color: Colors.redAccent, size: 18),
              label: const Text(
                'Se déconnecter',
                style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold, fontSize: 14),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildContactTile({
    required IconData icon,
    required String label,
    required String value,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
      leading: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: const Color(0xFFF7F8FA),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: Colors.black87, size: 19),
      ),
      title: Text(
        label,
        style: TextStyle(fontSize: 11, color: Colors.grey.shade500, fontWeight: FontWeight.w500),
      ),
      subtitle: Text(
        value,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.black87),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: const Icon(Icons.chevron_right_rounded, color: Colors.grey, size: 18),
      onTap: onTap,
    );
  }

  Widget _buildSquareDocCard({
    required IconData icon,
    required String title,
    required String docCode,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade100, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFF7F8FA),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: Colors.black87, size: 20),
          ),
          const SizedBox(height: 14),
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: Colors.black87),
          ),
          const SizedBox(height: 3),
          Text(
            docCode,
            style: TextStyle(color: Colors.grey.shade400, fontSize: 11, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildBankingRow({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
      leading: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: const Color(0xFFF7F8FA),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: Colors.black87, size: 19),
      ),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: Colors.black87),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
      ),
      trailing: const Icon(Icons.chevron_right_rounded, color: Colors.grey, size: 18),
      onTap: onTap,
    );
  }

  void _editProfileName(BuildContext context, MarketProvider provider) {
    _editField(
      context,
      title: 'Nom du Client',
      initialValue: provider.customerName,
      onSave: (newName) => provider.setCustomerInfo(name: newName, phone: provider.customerPhone),
    );
  }

  void _editField(
    BuildContext context, {
    required String title,
    required String initialValue,
    required ValueChanged<String> onSave,
  }) {
    final controller = TextEditingController(text: initialValue);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFFF7F8FA),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Annuler', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              final text = controller.text.trim();
              if (text.isNotEmpty) {
                onSave(text);
              }
              Navigator.pop(ctx);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF141414),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Enregistrer'),
          ),
        ],
      ),
    );
  }
}
