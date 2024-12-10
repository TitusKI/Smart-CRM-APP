class DashboardData {
  final int totalContacts;
  final int activeLeads;
  final int pendingLeads;
  final int rejectedLeads;
  final List<dynamic> recentActivities;

  DashboardData({
    required this.totalContacts,
    required this.activeLeads,
    required this.pendingLeads,
    required this.rejectedLeads,
    required this.recentActivities,
  });
}

class Activity {
  final String title;
  final String timestamp;

  Activity({
    required this.title,
    required this.timestamp,
  });
}
