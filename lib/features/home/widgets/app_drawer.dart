import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:luxe/features/shop/shop_view_model.dart';
import 'package:provider/provider.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({super.key});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  String selectedTab = 'WOMEN';

  final List<String> tabs = ['WOMEN', 'MAN', 'KIDS'];

  final List<String> categories = [
    'New',
    'Apparel',
    'Bag',
    'Shoes',
    'Beauty',
    'Accessories',
  ];

  String? get selectedApiCategory {
    switch (selectedTab) {
      case 'WOMEN':
        return "women's clothing";

      case 'MAN':
        return "men's clothing";

      case 'KIDS':
        return null;

      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.sizeOf(context).width * 0.82,
      shape: const RoundedRectangleBorder(),
      backgroundColor: Colors.white,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // CLOSE
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                alignment: Alignment.centerLeft,
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.close, size: 20),
              ),

              const SizedBox(height: 28),

              // WOMEN / MAN / KIDS
              _buildTabs(),

              const SizedBox(height: 12),

              // CATEGORIES
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    ...categories.map((category) {
                      return _buildCategory(category);
                    }),

                    const SizedBox(height: 26),

                    // PHONE
                    _buildInfoRow(
                      icon: Icons.phone_outlined,
                      text: '(786) 713-8616',
                    ),

                    const SizedBox(height: 22),

                    // LOCATION
                    _buildInfoRow(
                      icon: Icons.location_on_outlined,
                      text: 'Store locator',
                    ),

                    const SizedBox(height: 30),

                    _buildDecoration(),

                    const SizedBox(height: 22),

                    _buildSocialIcons(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabs() {
    return Row(
      children: tabs.map((tab) {
        final isSelected = selectedTab == tab;

        return Expanded(
          child: InkWell(
            onTap: () {
              setState(() {
                selectedTab = tab;
              });
            },
            child: Column(
              children: [
                Text(
                  tab,
                  style: TextStyle(
                    fontSize: 12,
                    letterSpacing: 2,
                    color: isSelected ? Colors.black87 : Colors.grey.shade400,
                  ),
                ),

                const SizedBox(height: 9),

                Container(
                  height: 1,
                  color: Colors.grey.shade200,
                  child: Align(
                    alignment: Alignment.center,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: isSelected ? 18 : 0,
                      height: 2,
                      color: const Color(0xFFDD8560),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCategory(String title) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        tilePadding: EdgeInsets.zero,
        childrenPadding: const EdgeInsets.only(left: 16, bottom: 8),
        minTileHeight: 44,

        title: Text(
          title,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
        ),

        trailing: const Icon(
          Icons.keyboard_arrow_down,
          size: 18,
          color: Colors.grey,
        ),

        children: [
          _buildSubCategory('View all', () {
            _openShop(selectedApiCategory);
          }),

          if (title == 'Apparel') ...[
            _buildSubCategory('Dresses', () {
              _openShop(selectedApiCategory);
            }),

            _buildSubCategory('Tops', () {
              _openShop(selectedApiCategory);
            }),
          ],

          if (title == 'Accessories') ...[
            _buildSubCategory('Jewelry', () {
              _openShop('jewelery');
            }),
          ],
        ],
      ),
    );
  }

  Widget _buildSubCategory(String title, VoidCallback onTap) {
    return ListTile(
      dense: true,
      contentPadding: EdgeInsets.zero,
      title: Text(
        title,
        style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
      ),
      onTap: onTap,
    );
  }

  Widget _buildInfoRow({required IconData icon, required String text}) {
    return Row(
      children: [
        Icon(icon, size: 19, color: Colors.grey.shade700),

        const SizedBox(width: 16),

        Text(text, style: TextStyle(fontSize: 13, color: Colors.grey.shade700)),
      ],
    );
  }

  Widget _buildDecoration() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(width: 45, height: 1, color: Colors.grey.shade300),

        Transform.rotate(
          angle: 0.785398,
          child: Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey.shade300),
            ),
          ),
        ),

        Container(width: 45, height: 1, color: Colors.grey.shade300),
      ],
    );
  }

  Widget _buildSocialIcons() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.flutter_dash, size: 19),

        SizedBox(width: 28),

        Icon(Icons.camera_alt_outlined, size: 19),

        SizedBox(width: 28),

        Icon(Icons.play_circle_outline, size: 19),
      ],
    );
  }

 void _openShop([String? category]) {
  final shopViewModel = context.read<ShopViewModel>();

  if (category != null) {
    shopViewModel.filterByCategory(category);
  } else {
    shopViewModel.filterByCategory('All');
  }

  Navigator.pop(context);

  context.push('/shop');
}
}
