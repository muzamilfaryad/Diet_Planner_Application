import 'package:flutter/material.dart';
import '../services/firebase_auth_service.dart';
import '../services/food_database_service.dart';
import '../services/meal_plan_service.dart';
import 'auth/login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = FirebaseAuthService.instance;
    final user = auth.currentUser;
    final isSignedIn = auth.isSignedIn;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(0xFF00B4D8),
            const Color(0xFF90E0EF).withValues(alpha: 0.2),
            const Color(0xFFF8F9FA),
          ],
          stops: const [0.0, 0.3, 0.6],
        ),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    // Profile Picture
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Icon(
                        isSignedIn ? Icons.person : Icons.person_outline,
                        size: 64,
                        color: const Color(0xFF00B4D8),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // User Info
                    Text(
                      isSignedIn ? (user?.displayName ?? 'User') : 'Guest User',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    if (isSignedIn) ...[
                      const SizedBox(height: 4),
                      Text(
                        user?.email ?? '',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withValues(alpha: 0.9),
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              // Settings Cards
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // Account Section
                    if (!isSignedIn)
                      _buildCard(
                        context,
                        icon: Icons.login,
                        title: 'Sign In',
                        subtitle: 'Sync your data across devices',
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const LoginScreen(),
                            ),
                          );
                        },
                      ),

                    if (isSignedIn) ...[
                      _buildCard(
                        context,
                        icon: Icons.cloud_sync,
                        title: 'Cloud Sync',
                        subtitle: 'Your data is automatically synced',
                        trailing: const Icon(
                          Icons.check_circle,
                          color: Colors.green,
                        ),
                        onTap: null,
                      ),
                      const SizedBox(height: 12),
                    ],

                    // App Info
                    _buildCard(
                      context,
                      icon: Icons.info_outline,
                      title: 'About',
                      subtitle: 'Diet Planner v1.0.0',
                      onTap: () {
                        showAboutDialog(
                          context: context,
                          applicationName: 'Diet Planner',
                          applicationVersion: '1.0.0',
                          applicationLegalese: '© 2024 Muzamil Faryad',
                          children: [
                            const SizedBox(height: 16),
                            const Text(
                              'A comprehensive nutrition tracking and meal planning application.',
                            ),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 12),

                    // Privacy
                    _buildCard(
                      context,
                      icon: Icons.privacy_tip_outlined,
                      title: 'Privacy Policy',
                      subtitle: 'How we handle your data',
                      onTap: () {
                        // Show privacy policy
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Privacy Policy'),
                            content: const SingleChildScrollView(
                              child: Text(
                                'Your privacy is important to us. All data is stored securely '
                                'and used only to provide app functionality. We do not share '
                                'your personal information with third parties.',
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Close'),
                              ),
                            ],
                          ),
                        );
                      },
                    ),

                    if (isSignedIn) ...[
                      const SizedBox(height: 24),
                      const Divider(),
                      const SizedBox(height: 12),

                      // Sign Out
                      _buildCard(
                        context,
                        icon: Icons.logout,
                        title: 'Sign Out',
                        subtitle: 'Sign out of your account',
                        iconColor: Colors.orange,
                        onTap: () async {
                          final confirmed = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Sign Out'),
                              content: const Text(
                                'Are you sure you want to sign out? Your data will remain synced in the cloud.',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(context, false),
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pop(context, true),
                                  child: const Text('Sign Out'),
                                ),
                              ],
                            ),
                          );

                          if (confirmed == true && context.mounted) {
                            await auth.signOut();
                            // Clear local cache
                            FoodDatabaseService.instance.clearCache();
                            MealPlanService.instance.clearAll();
                          }
                        },
                      ),
                      const SizedBox(height: 12),

                      // Delete Account
                      _buildCard(
                        context,
                        icon: Icons.delete_forever,
                        title: 'Delete Account',
                        subtitle: 'Permanently delete your account',
                        iconColor: Colors.red,
                        onTap: () async {
                          final confirmed = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Delete Account'),
                              content: const Text(
                                'Are you sure? This action cannot be undone. '
                                'All your data will be permanently deleted.',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(context, false),
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pop(context, true),
                                  style: TextButton.styleFrom(
                                    foregroundColor: Colors.red,
                                  ),
                                  child: const Text('Delete'),
                                ),
                              ],
                            ),
                          );

                          if (confirmed == true && context.mounted) {
                            try {
                              await auth.deleteAccount();
                              FoodDatabaseService.instance.clearCache();
                              MealPlanService.instance.clearAll();
                            } catch (e) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Error deleting account: $e'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            }
                          }
                        },
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    Color? iconColor,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: (iconColor ?? const Color(0xFF00B4D8)).withValues(
              alpha: 0.1,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: iconColor ?? const Color(0xFF00B4D8)),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle),
        trailing:
            trailing ??
            (onTap != null ? const Icon(Icons.chevron_right) : null),
        onTap: onTap,
      ),
    );
  }
}
