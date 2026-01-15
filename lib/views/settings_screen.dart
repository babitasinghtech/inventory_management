import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../utils/database_helper.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSectionHeader('App Information'),
          _buildInfoCard(
            icon: Icons.info_outline,
            title: 'App Name',
            subtitle: 'Inventory Management System',
            color: Colors.blue,
          ),
          _buildInfoCard(
            icon: Icons.code,
            title: 'Version',
            subtitle: '1.0.0',
            color: Colors.green,
          ),
          _buildInfoCard(
            icon: Icons.architecture,
            title: 'Architecture',
            subtitle: 'MVVM + Riverpod',
            color: Colors.purple,
          ),
          const SizedBox(height: 24),
          _buildSectionHeader('Features'),
          _buildFeatureCard(
            icon: Icons.inventory_2,
            title: 'Product Management',
            description: 'Add, edit, delete products',
            color: Colors.orange,
          ),
          _buildFeatureCard(
            icon: Icons.qr_code_scanner,
            title: 'QR Code Scanner',
            description: 'Quick product lookup',
            color: Colors.teal,
          ),
          _buildFeatureCard(
            icon: Icons.history,
            title: 'Stock History',
            description: 'Track all stock movements',
            color: Colors.indigo,
          ),
          _buildFeatureCard(
            icon: Icons.storage,
            title: 'Local Database',
            description: 'Offline data storage',
            color: Colors.cyan,
          ),
          const SizedBox(height: 24),
          _buildSectionHeader('Database Management'),
          Card(
            child: ListTile(
              leading: const Icon(Icons.delete_forever, color: Colors.red),
              title: const Text(
                'Clear All Data',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: const Text('Delete all products and history'),
              onTap: () => _showClearDataDialog(context),
            ),
          ),
          const SizedBox(height: 24),
          _buildSectionHeader('About'),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Packages Used:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildPackageItem('flutter_riverpod', 'State management'),
                  _buildPackageItem('sqflite', 'Local database'),
                  _buildPackageItem('image_picker', 'Image handling'),
                  _buildPackageItem('mobile_scanner', 'QR code scanning'),
                  _buildPackageItem('uuid', 'Unique ID generation'),
                  _buildPackageItem('intl', 'Date & number formatting'),
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 8),
                  const Text(
                    '© 2024 Inventory Management System',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, top: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.blue,
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.1),
          child: Icon(icon, color: color),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(subtitle),
      ),
    );
  }

  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required String description,
    required Color color,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          description,
          style: const TextStyle(fontSize: 12),
        ),
      ),
    );
  }

  Widget _buildPackageItem(String name, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          const Icon(Icons.check_circle, size: 16, color: Colors.green),
          const SizedBox(width: 8),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(color: Colors.black87, fontSize: 14),
                children: [
                  TextSpan(
                    text: name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: ' - $description',
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showClearDataDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Clear All Data'),
        content: const Text(
          'Are you sure you want to delete all products and history? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await DatabaseHelper.instance.close();

              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('All data cleared successfully'),
                ),
              );
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
