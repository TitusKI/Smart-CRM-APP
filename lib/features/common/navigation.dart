import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_crm_app/core/constants/exports.dart';
import 'package:smart_crm_app/core/resources/generic_state.dart';
import 'package:smart_crm_app/features/common/drawer.dart';
import 'package:smart_crm_app/features/common/presentation/profile_screen.dart';
import 'package:smart_crm_app/features/contacts/presentation/pages/contacts_screen.dart';
import 'package:smart_crm_app/features/dashboard/presentation/pages/dashboard_screen.dart';
import 'package:smart_crm_app/features/leads/presentation/pages/leads_screen.dart';
import 'package:smart_crm_app/features/notifications/presentation/bloc/notification_cubit.dart';

import '../admin/presentation/pages/admin_dashboard.dart';
import '../admin/presentation/pages/contacts_list.dart';
import '../admin/presentation/pages/leads_list.dart';
import '../admin/presentation/pages/users_screen.dart';
import '../../config/theme/colors.dart';
import '../../injection_container.dart';
import '../auth/presentation/widgets/common_widgets.dart';
import '../notifications/domain/entities/notification_entity.dart';
import '../notifications/presentation/pages/notification_list.dart';
import 'bottom_navigation/bottom_navigation_bloc.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final String? role = sl<StorageServices>().getRole(); // Fetch role

  @override
  void initState() {
    super.initState();
    context.read<NotificationCubit>().fetchNotifications();
    _tabController = TabController(
      length: role == "users" ? 4 : 4, // Adjust number of tabs based on role
      vsync: this,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BottomNavigationBloc, BottomNavigationState>(
      builder: (context, state) {
        final bool isUser = role == "user";
        String appBarTitle;
        List<Widget> appBarActions = [];
        Widget? leading;
        Widget? drawer;

        // Determine titles and actions based on role and selected index
        switch (state.navIndex) {
          case 0:
            appBarTitle = isUser ? "Smart CRM" : "Admin Dashboard";
            appBarActions = [
              if (isUser)
                Badge(
                  child: IconButton(
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true, // Allows custom height
                        builder: (context) {
                          return FractionallySizedBox(
                            heightFactor:
                                0.9, // Adjust this value for the desired height
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Align(
                                    alignment: Alignment.topCenter,
                                    child: Container(
                                      width: 60,
                                      height: 5,
                                      decoration: BoxDecoration(
                                        color: Colors.grey[300],
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                ),
                                const Expanded(
                                  child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 16.0),
                                    child: NotificationList(),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                    icon: Badge(
                      label: BlocBuilder<NotificationCubit, GenericState>(
                        builder: (context, state) {
                          if (state.isSuccess) {
                            final List<NotificationEntity> notifications =
                                state.data!;
                            int unreadCount =
                                notifications.where((n) => !n.isRead).length;
                            return Text(
                              unreadCount.toString(),
                              style: const TextStyle(
                                color: AppColors.primaryBackground,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          } else {
                            return const Text(
                              "",
                              style: TextStyle(
                                color: AppColors.primaryBackground,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          }
                        },
                      ),
                      backgroundColor: Colors.red,
                      alignment: Alignment.topRight,
                      child: const Icon(
                        Icons.notifications_active_rounded,
                        color: AppColors.primaryBackground,
                      ),
                    ),
                  ),
                ),
            ];
            leading = IconButton(
              icon: const Icon(
                Icons.menu_outlined,
                color: AppColors.primaryBackground,
              ),
              onPressed: () {
                _scaffoldKey.currentState?.openDrawer();
              },
            );
            drawer = const AppDrawer();
            break;
          case 1:
            appBarTitle = isUser ? "Contacts" : "Users";
            appBarActions = [
              if (isUser)
                IconButton(
                  icon: const Icon(Icons.add_circle_outline_outlined,
                      color: AppColors.primaryBackground, size: 28),
                  onPressed: () => showAddOrEditContactForm(context),
                ),
            ];
            break;
          case 2:
            appBarTitle = isUser ? "Leads" : "Contacts";
            appBarActions = [
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {},
              ),
            ];
            break;
          case 3:
            appBarTitle = isUser ? "Profile" : "Leads";
            break;

          default:
            appBarTitle = "Smart CRM";
        }

        // Determine bottom navigation tabs
        final tabs = isUser
            ? [
                const TabItem(
                  icon: Icon(
                    Icons.dashboard_outlined,
                    color: AppColors.primaryBackground,
                  ),
                  title: "Dashboard",
                ),
                const TabItem(
                  icon: Icon(
                    Icons.person_outline_outlined,
                    color: AppColors.primaryBackground,
                  ),
                  title: "Contacts",
                ),
                const TabItem(
                  icon: Icon(
                    Icons.leaderboard_outlined,
                    color: AppColors.primaryBackground,
                  ),
                  title: "Leads",
                ),
                const TabItem(
                  icon: Icon(
                    Icons.settings,
                    color: AppColors.primaryBackground,
                  ),
                  title: "Profile",
                ),
              ]
            : [
                const TabItem(
                  icon: Icon(
                    Icons.dashboard_outlined,
                    color: AppColors.primaryBackground,
                  ),
                  title: "Dashboard",
                ),
                const TabItem(
                  icon: Icon(
                    Icons.group,
                    color: AppColors.primaryBackground,
                  ),
                  title: "Users",
                ),
                const TabItem(
                  icon: Icon(
                    Icons.contacts_outlined,
                    color: AppColors.primaryBackground,
                  ),
                  title: "Contacts",
                ),
                const TabItem(
                  icon: Icon(
                    Icons.leaderboard_outlined,
                    color: AppColors.primaryBackground,
                  ),
                  title: "Leads",
                ),
              ];

        // Determine the body tabs
        final bodyTabs = isUser
            ? const [
                DashboardScreen(),
                ContactsScreen(),
                LeadsScreen(),
                ProfileScreen(),
              ]
            : const [
                AdminDashboard(),
                UsersScreen(), // Replace with your admin-specific screen
                ContactsList(),
                LeadsList(),
              ];

        return Scaffold(
          key: _scaffoldKey,
          drawer: drawer,
          appBar: buildAppBarLarge(appBarTitle,
              actions: appBarActions, leading: leading),
          bottomNavigationBar: ConvexAppBar(
            controller: _tabController,
            style: TabStyle.react,
            backgroundColor: AppColors.accentColor,
            items: tabs,
            initialActiveIndex: state.navIndex,
            onTap: (int i) {
              context
                  .read<BottomNavigationBloc>()
                  .add(BottomNavigationEvent(i));
            },
          ),
          body: TabBarView(
            controller: _tabController,
            physics: const NeverScrollableScrollPhysics(),
            children: bodyTabs,
          ),
        );
      },
    );
  }
}
