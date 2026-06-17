import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../providers/auth_provider.dart';
import '../tabs/chat_tab.dart';
import '../tabs/code_tab.dart';
import '../tabs/chart_tab.dart';
import '../drawer/previous_chats_page.dart';
import '../drawer/plans_page.dart';
import '../drawer/account_settings_page.dart';
import '../drawer/general_settings_page.dart';
import '../drawer/support_help_page.dart';
import '../settings/settings_page.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this, initialIndex: 1);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _openDrawer() {
    _scaffoldKey.currentState?.openEndDrawer();
  }

  void _openSettings() {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const SettingsPage(),
        transitionsBuilder: (_, animation, __, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.05),
              end: Offset.zero,
            ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOut)),
            child: FadeTransition(opacity: animation, child: child),
          );
        },
        transitionDuration: const Duration(milliseconds: 200),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.background,
      endDrawer: _buildDrawer(),
      body: Column(
        children: [
          _buildAppBar(),
          _buildTabs(),
          const Divider(height: 1, thickness: 1, color: AppColors.border),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              physics: const BouncingScrollPhysics(),
              children: const [
                ChatTab(),
                CodeTab(),
                ChartTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: const BoxDecoration(
        color: AppColors.background,
        border: Border(bottom: BorderSide(color: AppColors.border, width: 0.5)),
      ),
      child: Row(
        children: [
          const SizedBox(width: 4),
          _buildLogo(),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.settings_outlined, size: 22),
            onPressed: _openSettings,
            splashRadius: 20,
            tooltip: 'Settings',
          ),
          IconButton(
            icon: const Icon(Icons.menu_rounded, size: 22),
            onPressed: _openDrawer,
            splashRadius: 20,
            tooltip: 'Menu',
          ),
        ],
      ),
    );
  }

  Widget _buildLogo() {
    return const Row(
      children: [
        Icon(Icons.auto_graph, size: 28, color: AppColors.primary),
        SizedBox(width: 8),
        Text('TrapAI', style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: AppColors.textMain,
          letterSpacing: -0.5,
        )),
      ],
    );
  }

  Widget _buildTabs() {
    return Container(
      height: 44,
      color: AppColors.background,
      child: TabBar(
        controller: _tabController,
        indicatorColor: AppColors.primary,
        indicatorWeight: 2.5,
        indicatorSize: TabBarIndicatorSize.label,
        labelColor: AppColors.textMain,
        unselectedLabelColor: AppColors.textMuted,
        labelStyle: AppTypography.labelSm.copyWith(fontWeight: FontWeight.w600),
        unselectedLabelStyle: AppTypography.labelSm,
        splashBorderRadius: BorderRadius.circular(8),
        tabs: const [
          Tab(text: 'Chat'),
          Tab(text: 'Code'),
          Tab(text: 'Chart'),
        ],
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      backgroundColor: AppColors.background,
      width: MediaQuery.of(context).size.width * 0.82,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDrawerHeader(),
            const Divider(height: 1, color: AppColors.border),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 8),
                children: [
                  _drawerItem(
                    icon: Icons.chat_bubble_outline,
                    title: 'Previous Chats',
                    onTap: () => _navigateTo(const PreviousChatsPage()),
                  ),
                  _drawerItem(
                    icon: Icons.workspace_premium_outlined,
                    title: 'Plans & Subscriptions',
                    onTap: () => _navigateTo(const PlansPage()),
                  ),
                  const Divider(height: 1, indent: 16, endIndent: 16, color: AppColors.border),
                  _drawerItem(
                    icon: Icons.person_outline,
                    title: 'Account Settings',
                    onTap: () => _navigateTo(const AccountSettingsPage()),
                  ),
                  _drawerItem(
                    icon: Icons.tune,
                    title: 'General Settings',
                    onTap: () => _navigateTo(const GeneralSettingsPage()),
                  ),
                  _drawerItem(
                    icon: Icons.help_outline,
                    title: 'Support & Help',
                    onTap: () => _navigateTo(const SupportHelpPage()),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: AppColors.border),
            _drawerItem(
              icon: Icons.logout,
              title: 'Log Out',
              onTap: () {
                Navigator.pop(context);
                context.read<AuthProvider>().logout();
                Navigator.pushReplacementNamed(context, '/login');
              },
              color: AppColors.error,
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerHeader() {
    final auth = context.watch<AuthProvider>();
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: AppColors.primary,
            child: Text(
              (auth.userName ?? 'U')[0].toUpperCase(),
              style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  auth.userName ?? 'User',
                  style: AppTypography.bodyLg.copyWith(fontWeight: FontWeight.w600),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  auth.userEmail ?? '',
                  style: AppTypography.bodySm,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _drawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? color,
  }) {
    return ListTile(
      leading: Icon(icon, size: 22, color: color ?? AppColors.textMain),
      title: Text(
        title,
        style: AppTypography.bodyMd.copyWith(color: color ?? AppColors.textMain),
      ),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );
  }

  void _navigateTo(Widget page) {
    Navigator.pop(context);
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => page,
        transitionsBuilder: (_, animation, __, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1, 0),
              end: Offset.zero,
            ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOut)),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 200),
      ),
    );
  }
}
