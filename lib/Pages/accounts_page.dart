import 'package:flutter/material.dart';
import 'package:wallpapers/Pages/homescreen.dart';
import 'package:wallpapers/utils/apptexts.dart';
import 'package:wallpapers/utils/apptheme.dart';

class AccountsPage extends StatefulWidget {
  const AccountsPage({super.key});

  @override
  State<AccountsPage> createState() => _AccountsPageState();
}

class _AccountsPageState extends State<AccountsPage> {
  bool _pushNotificationsEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryColor,

      appBar: AppBar(
        title: CustomText().heavyText(
          text: 'Settings',
          color: AppTheme.secondaryColor,
          size: 20,
          weight: FontWeight.w700,
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: AppTheme.secondaryColor),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
              (route) => false,
            );
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Row(
              children: [
                CustomText().lightText(
                  text: 'Login/SingUp',
                  color: AppTheme.secondaryColor,
                  size: 12,
                  weight: FontWeight.w300,
                ),
                const SizedBox(width: 5),
                Container(
                  key: const Key('notificationIcon'),
                  child: Image.asset(
                    'assets/settings_icons/logout.png',
                    width: 24,
                    height: 24,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Container(
              key: const Key('profileContainer'),
              height: MediaQuery.of(context).size.height * 0.25,
              width: MediaQuery.of(context).size.width * 0.9,
              decoration: BoxDecoration(
                color: AppTheme.secondaryColor,
                borderRadius: BorderRadius.circular(50),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.15),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 25,
                ),
                child: Row(
                  children: [
                    // Profile Image Placeholder
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppTheme.primaryColor,
                        border: Border.all(
                          color: AppTheme.tertiaryColor,
                          width: 3,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.2),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Icon(
                              Icons.person,
                              size: 60,
                              color: AppTheme.tertiaryColor,
                            ),
                            const SizedBox(width: 2),
                            Icon(
                              Icons.edit,
                              size: 15,
                              color: AppTheme.tertiaryColor,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    // User Information
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          // Name
                          CustomText().semiboldText(
                            text: 'Dewashish hatekar',
                            size: 18,
                            color: AppTheme.primaryColor,
                            weight: FontWeight.w700,
                          ),
                          const SizedBox(height: 15),
                          // Login Method
                          CustomText().lightText(
                            text: 'Logged in using Email & Password',
                            size: 12,
                            color: AppTheme.tertiaryColor,
                            weight: FontWeight.w400,
                          ),
                          const SizedBox(height: 12),
                          // UID Section
                          Row(
                            children: [
                              CustomText().lightText(
                                text: 'UID: ',
                                size: 11,
                                color: AppTheme.tertiaryColor,
                                weight: FontWeight.w500,
                              ),
                              Expanded(
                                child: CustomText().lightText(
                                  text: 'abc123xyz456',
                                  size: 11,
                                  color: AppTheme.tertiaryColor,
                                  weight: FontWeight.w300,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 15),
            Container(
              key: const Key('settingsContainer'),
              height: MediaQuery.of(context).size.height * 0.57,
              width: MediaQuery.of(context).size.width * 0.9,
              decoration: BoxDecoration(
                color: AppTheme.primaryColor,
                borderRadius: BorderRadius.circular(50),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.15),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 25,
                  vertical: 20,
                ),
                child: Column(
                  children: [
                    // Push Notifications with Switch
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 8,
                      ),
                      child: Row(
                        children: [
                          Image.asset(
                            'assets/settings_icons/bell_notification.png',
                            width: 28,
                            height: 28,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: CustomText().semiboldText(
                              text: 'Push Notifications',
                              size: 15,
                              color: AppTheme.secondaryColor,
                              weight: FontWeight.w500,
                            ),
                          ),
                          Switch(
                            value: _pushNotificationsEnabled,
                            onChanged: (value) {
                              setState(() {
                                _pushNotificationsEnabled = value;
                              });
                            },
                            thumbColor: WidgetStateProperty.resolveWith<Color>((
                              states,
                            ) {
                              if (states.contains(WidgetState.selected)) {
                                return AppTheme.primaryColor;
                              }
                              return AppTheme.secondaryColor;
                            }),
                            trackColor: WidgetStateProperty.resolveWith<Color>((
                              states,
                            ) {
                              if (states.contains(WidgetState.selected)) {
                                return Colors.lightGreen;
                              }
                              return AppTheme.tertiaryColor.withValues(
                                alpha: 0.3,
                              );
                            }),
                          ),
                        ],
                      ),
                    ),
                    const Divider(color: AppTheme.tertiaryColor, height: 1),
                    _buildSettingsItem(
                      icon: 'assets/settings_icons/invite.png',
                      title: 'Invite a Friend',

                      onTap: () {},
                    ),
                    const Divider(color: AppTheme.tertiaryColor, height: 1),
                    _buildSettingsItem(
                      icon: 'assets/settings_icons/ratethisapp.png',
                      title: 'Rate this App',
                      onTap: () {},
                    ),
                    const Divider(color: AppTheme.tertiaryColor, height: 1),
                    _buildSettingsItem(
                      icon: 'assets/settings_icons/feedback.png',
                      title: 'Feedback and Bugs',
                      onTap: () {},
                    ),
                    const Divider(color: AppTheme.tertiaryColor, height: 1),
                    _buildSettingsItem(
                      icon: 'assets/settings_icons/terms-and-conditions.png',
                      title: 'Terms and Conditions',
                      onTap: () {},
                    ),
                    const Divider(color: AppTheme.tertiaryColor, height: 1),
                    _buildSettingsItem(
                      icon: 'assets/settings_icons/privacy.png',
                      title: 'Privacy Policy',
                      onTap: () {},
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsItem({
    required String icon,
    required String title,
    required VoidCallback onTap,
    Color color = AppTheme.secondaryColor,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        child: Row(
          children: [
            Image.asset(icon, width: 28, height: 28, color: color),
            const SizedBox(width: 16),
            Expanded(
              child: CustomText().semiboldText(
                text: title,
                size: 15,
                color: color,
                weight: FontWeight.w500,
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: AppTheme.tertiaryColor,
            ),
          ],
        ),
      ),
    );
  }
}
