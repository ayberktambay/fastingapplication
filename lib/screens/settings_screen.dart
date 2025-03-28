import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/prayer_times_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              'Ayarlar',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
            ),
            const SizedBox(height: 24),
            _buildSection(
              context,
              title: 'Genel Ayarlar',
              children: [
                _buildSettingTile(
                  context,
                  icon: Icons.notifications_outlined,
                  title: 'Bildirimler',
                  subtitle: 'Namaz vakitleri için bildirimleri yönetin',
                  onTap: () {},
                ),
                _buildSettingTile(
                  context,
                  icon: Icons.language,
                  title: 'Dil',
                  subtitle: 'Uygulama dilini değiştirin',
                  onTap: () {},
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildSection(
              context,
              title: 'Görünüm',
              children: [
                _buildSettingTile(
                  context,
                  icon: Icons.palette_outlined,
                  title: 'Tema',
                  subtitle: 'Uygulama temasını değiştirin',
                  onTap: () {},
                ),
                _buildSettingTile(
                  context,
                  icon: Icons.text_fields,
                  title: 'Yazı Boyutu',
                  subtitle: 'Uygulama yazı boyutunu ayarlayın',
                  onTap: () {},
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildSection(
              context,
              title: 'Hakkında',
              children: [
                _buildSettingTile(
                  context,
                  icon: Icons.info_outline,
                  title: 'Uygulama Bilgisi',
                  subtitle: 'Versiyon ve diğer bilgiler',
                  onTap: () {},
                ),
                _buildSettingTile(
                  context,
                  icon: Icons.privacy_tip_outlined,
                  title: 'Gizlilik Politikası',
                  subtitle: 'Gizlilik politikasını görüntüleyin',
                  onTap: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w600,
                ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }

  Widget _buildSettingTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.green.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          icon,
          color: Colors.green,
          size: 24,
        ),
      ),
      title: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
      ),
      subtitle: Text(
        subtitle,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[600],
            ),
      ),
      trailing: const Icon(
        Icons.chevron_right,
        color: Colors.grey,
      ),
      onTap: onTap,
    );
  }
} 