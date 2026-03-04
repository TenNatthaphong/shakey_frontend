import 'package:flutter/material.dart';
import 'package:shakey/app_color.dart';
import 'package:shakey/services/language_service.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  bool _pushNotifications = true;
  bool _orderUpdates = true;
  bool _promotions = false;
  bool _soundEnabled = true;
  bool _vibrationEnabled = true;

  final _lang = LanguageService.instance;

  @override
  void initState() {
    super.initState();
    _lang.addListener(_onLanguageChanged);
  }

  @override
  void dispose() {
    _lang.removeListener(_onLanguageChanged);
    super.dispose();
  }

  void _onLanguageChanged() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(gradient: AppColor.backgroundGradient),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.arrow_back_ios_new, size: 20),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _lang.get('settings'),
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),

              // Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Notifications Section
                      _buildSectionTitle(
                        icon: Icons.notifications_outlined,
                        title: _lang.get('notifications'),
                      ),
                      const SizedBox(height: 10),
                      _buildSettingsCard([
                        _buildSwitchTile(
                          icon: Icons.notifications_active_outlined,
                          title: _lang.get('push_notifications'),
                          subtitle: _lang.get('receive_push_notif'),
                          value: _pushNotifications,
                          onChanged: (val) =>
                              setState(() => _pushNotifications = val),
                        ),
                        _buildDivider(),
                        _buildSwitchTile(
                          icon: Icons.local_shipping_outlined,
                          title: _lang.get('order_updates'),
                          subtitle: _lang.get('order_updates_msg'),
                          value: _orderUpdates,
                          onChanged: (val) =>
                              setState(() => _orderUpdates = val),
                        ),
                        _buildDivider(),
                        _buildSwitchTile(
                          icon: Icons.campaign_outlined,
                          title: _lang.get('promotions'),
                          subtitle: _lang.get('promotions_msg'),
                          value: _promotions,
                          onChanged: (val) => setState(() => _promotions = val),
                        ),
                      ]),
                      const SizedBox(height: 24),

                      // Sound & Haptics
                      _buildSectionTitle(
                        icon: Icons.volume_up_outlined,
                        title: _lang.get('sound_haptics'),
                      ),
                      const SizedBox(height: 10),
                      _buildSettingsCard([
                        _buildSwitchTile(
                          icon: Icons.music_note_outlined,
                          title: _lang.get('sound'),
                          subtitle: _lang.get('sound_msg'),
                          value: _soundEnabled,
                          onChanged: (val) =>
                              setState(() => _soundEnabled = val),
                        ),
                        _buildDivider(),
                        _buildSwitchTile(
                          icon: Icons.vibration,
                          title: _lang.get('vibration'),
                          subtitle: _lang.get('vibration_msg'),
                          value: _vibrationEnabled,
                          onChanged: (val) =>
                              setState(() => _vibrationEnabled = val),
                        ),
                      ]),
                      const SizedBox(height: 24),

                      // Language
                      _buildSectionTitle(
                        icon: Icons.language,
                        title: _lang.get('language'),
                      ),
                      const SizedBox(height: 10),
                      _buildSettingsCard([_buildLanguageTile()]),
                      const SizedBox(height: 24),

                      // About
                      _buildSectionTitle(
                        icon: Icons.info_outline,
                        title: _lang.get('about'),
                      ),
                      const SizedBox(height: 10),
                      _buildSettingsCard([
                        _buildInfoTile(
                          icon: Icons.apps,
                          title: _lang.get('version'),
                          trailing: '1.0.0',
                        ),
                        _buildDivider(),
                        _buildInfoTile(
                          icon: Icons.build_outlined,
                          title: _lang.get('build'),
                          trailing: '2026.03.04',
                        ),
                        _buildDivider(),
                        _buildInfoTile(
                          icon: Icons.flutter_dash,
                          title: _lang.get('framework'),
                          trailing: 'Flutter',
                        ),
                      ]),
                      const SizedBox(height: 24),

                      // Data & Storage
                      _buildSectionTitle(
                        icon: Icons.storage_outlined,
                        title: _lang.get('data_storage'),
                      ),
                      const SizedBox(height: 10),
                      _buildSettingsCard([
                        _buildActionTile(
                          icon: Icons.cached,
                          title: _lang.get('clear_cache'),
                          subtitle: _lang.get('clear_cache_msg'),
                          onTap: () => _showClearCacheDialog(),
                        ),
                      ]),

                      const SizedBox(height: 30),
                      Center(
                        child: Text(
                          'Shakey v1.0.0',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle({required IconData icon, required String title}) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColor.primaryRed),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsCard(List<Widget> children) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppColor.primaryRed.withOpacity(0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      thickness: 0.5,
      indent: 56,
      color: Colors.grey.shade200,
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColor.primaryRed.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppColor.primaryRed, size: 18),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColor.primaryRed,
            activeTrackColor: AppColor.primaryRed.withOpacity(0.3),
            inactiveThumbColor: Colors.grey.shade400,
            inactiveTrackColor: Colors.grey.shade200,
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageTile() {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () => _showLanguageDialog(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColor.primaryRed.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.translate,
                color: AppColor.primaryRed,
                size: 18,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _lang.get('app_language'),
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _lang.currentLanguage,
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String title,
    required String trailing,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColor.primaryRed.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppColor.primaryRed, size: 18),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: AppColor.primaryRed.withOpacity(0.08),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              trailing,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppColor.primaryRed,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColor.primaryRed.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: AppColor.primaryRed, size: 18),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  void _showLanguageDialog() {
    final languages = ['English', 'ภาษาไทย'];
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          _lang.get('select_language'),
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: languages.map((lang) {
            final isSelected = lang == _lang.currentLanguage;
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColor.primaryRed.withOpacity(0.1)
                    : Colors.grey.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected
                      ? AppColor.primaryRed.withOpacity(0.4)
                      : Colors.grey.shade200,
                  width: 1.5,
                ),
              ),
              child: ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                leading: Icon(
                  isSelected
                      ? Icons.radio_button_checked
                      : Icons.radio_button_off,
                  color: isSelected ? AppColor.primaryRed : Colors.grey,
                ),
                title: Text(
                  lang,
                  style: TextStyle(
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                    color: isSelected ? AppColor.primaryRed : Colors.black87,
                  ),
                ),
                onTap: () {
                  _lang.setLanguage(lang);
                  Navigator.of(context).pop();
                },
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showClearCacheDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          _lang.get('clear_cache'),
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        content: Text(
          _lang.get('clear_cache_msg'),
          style: const TextStyle(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              _lang.get('cancel'),
              style: const TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(this.context).showSnackBar(
                SnackBar(
                  content: Row(
                    children: [
                      const Icon(
                        Icons.check_circle,
                        color: Colors.white,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Text(_lang.get('cache_cleared_msg')),
                    ],
                  ),
                  backgroundColor: AppColor.primaryRed,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.primaryRed,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(_lang.get('clear')),
          ),
        ],
      ),
    );
  }
}
