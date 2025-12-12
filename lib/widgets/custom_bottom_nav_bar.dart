import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wallpapers/utils/apptheme.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;
  final bool isVisible;

  CustomBottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
    required this.isVisible,
  });

  final List<NavItem> _items = [
    NavItem(name: 'Home', asset: 'assets/icons_animated/home_5973558.png'),
    NavItem(name: 'All', asset: 'assets/icons_animated/all.png'),
    NavItem(name: 'Favourites', asset: 'assets/icons_animated/like.png'),
    NavItem(name: 'Categories', asset: 'assets/icons_animated/category.png'),
  ];

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: !isVisible,
      child: AnimatedSlide(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOutQuad,
        offset: isVisible ? Offset.zero : const Offset(0, 1),
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
          opacity: isVisible ? 1.0 : 0.0,
          child: Container(
            height: 55,
            margin: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: AppTheme.tertiaryColor.withValues(alpha: 0.9),
              borderRadius: BorderRadius.circular(50),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(_items.length, (index) {
                final item = _items[index];
                final isSelected = selectedIndex == index;

                return GestureDetector(
                  onTap: () => onItemSelected(index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    padding: EdgeInsets.symmetric(
                      horizontal: isSelected ? 12 : 8,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppTheme.primaryColor.withValues(alpha: 0.2)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: BackdropFilter(
                        filter: isSelected
                            ? ImageFilter.blur(sigmaX: 5, sigmaY: 5)
                            : ImageFilter.blur(sigmaX: 0, sigmaY: 0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Icon
                            SizedBox(
                              width: 22,
                              height: 22,
                              child: Image.asset(
                                item.asset,
                                color: isSelected
                                    ? AppTheme.primaryColor
                                    : AppTheme.secondaryColor,
                              ),
                            ),

                            if (isSelected) ...[
                              const SizedBox(width: 6),
                              Text(
                                item.name,
                                style: GoogleFonts.poppins(
                                  color: AppTheme.primaryColor,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}

class NavItem {
  final String name;
  final String asset;

  NavItem({required this.name, required this.asset});
}
