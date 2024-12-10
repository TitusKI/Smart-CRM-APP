import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_crm_app/features/contacts/domain/entities/contact_entity.dart';
import 'package:smart_crm_app/features/leads/domain/entities/lead_entity.dart';
import 'package:smart_crm_app/features/contacts/presentation/bloc/contact_cubit.dart';
import 'package:smart_crm_app/features/leads/presentation/bloc/leads_cubit.dart';
import '../../../../config/theme/colors.dart';
import '../../../../core/resources/generic_state.dart';
import '../../../auth/domain/entities/signup_entity.dart';
import '../bloc/admin_cubit.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  @override
  void initState() {
    super.initState();
    context.read<AdminCubit>().getAllUsers();
    context.read<ContactCubit>().fetchContacts();
    context.read<LeadCubit>().fetchLeads();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Overview",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              _OverviewCards(),
              SizedBox(height: 32),
              Text(
                "Leads Statistics",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              _LeadsCharts(),
            ],
          ),
        ),
      ),
    );
  }
}

class _OverviewCards extends StatelessWidget {
  const _OverviewCards({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _OverviewCard<AdminCubit, List<UserEntity>>(
              title: "Total Users",
              icon: Icons.person,
              color: AppColors.accentColor,
              fetchData: (List<UserEntity>? state) => state?.length ?? 0,
            ),
            _OverviewCard<ContactCubit, List<ContactEntity>>(
              title: "Total Contacts",
              icon: Icons.contact_page,
              color: Colors.green,
              fetchData: (List<ContactEntity>? state) => state?.length ?? 0,
            ),
            _OverviewCard<LeadCubit, List<LeadEntity>>(
              title: "Total Leads",
              icon: Icons.leaderboard,
              color: Colors.orange,
              fetchData: (List<LeadEntity>? state) => state?.length ?? 0,
            ),
          ],
        ),
        const SizedBox(height: 16),
        const Text(
          "Leads Overview",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _OverviewCard<LeadCubit, List<LeadEntity>>(
                title: "Approved Leads",
                icon: Icons.approval_outlined,
                color: Colors.green,
                fetchData: (List<LeadEntity> state) =>
                    state.where((lead) => lead.status == "Approved").length),
            _OverviewCard<LeadCubit, List<LeadEntity>>(
                title: "Pendng Leads",
                icon: Icons.pending_actions,
                color: Colors.orange,
                fetchData: (List<LeadEntity> state) =>
                    state.where((lead) => lead.status == "Pending").length),
            _OverviewCard<LeadCubit, List<LeadEntity>>(
                title: "Rejected Leads",
                icon: Icons.cancel_outlined,
                color: Colors.red,
                fetchData: (List<LeadEntity> state) =>
                    state.where((lead) => lead.status == "Rejected").length),
          ],
        ),
      ],
    );
  }
}

class _OverviewCard<C extends Cubit<GenericState>, T> extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final int Function(T) fetchData;

  const _OverviewCard({
    required this.title,
    required this.icon,
    required this.color,
    required this.fetchData,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<C, GenericState>(
      builder: (context, state) {
        final value =
            state.isLoading ? "..." : fetchData(state.data).toString();
        return Card(
          elevation: 8,
          shadowColor: color.withOpacity(0.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: SizedBox(
            width: 100.w,
            height: 160.h,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 36, color: color),
                const SizedBox(height: 8),
                Text(value,
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: color)),
                const SizedBox(height: 4),
                Text(title, style: TextStyle(fontSize: 16, color: color)),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _LeadsCharts extends StatelessWidget {
  const _LeadsCharts({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LeadCubit, GenericState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state.failure != null && state.failure!.isNotEmpty) {
          return Center(child: Text("Error: ${state.failure}"));
        }

        final leads = state.data ?? [];
        final approved =
            leads.where((lead) => lead.status == "Approved").length;
        final rejected =
            leads.where((lead) => lead.status == "Rejected").length;
        final pending = leads.where((lead) => lead.status == "Pending").length;

        return Column(
          children: [
            SizedBox(height: 16.h),
            const Text(
              "Status Distribution",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16.h),
            _buildPieChartWithLegend(approved, rejected, pending),
            SizedBox(height: 32.h),
            const Text(
              "Status Counts",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16.h),
            _buildBarChart(approved, rejected, pending),
            SizedBox(height: 32.h),
            const Text(
              "Status Trends Over Time",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16.h),
            _buildLineChart(approved, rejected, pending),
            SizedBox(height: 32.h),
            const Text(
              "Users, Contacts, and Leads Distribution",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16.h),
            _buildUsersContactsLeadsChart(context),
            SizedBox(height: 16.h),
            SizedBox(height: 16.h),
          ],
        );
      },
    );
  }

  Widget _buildPieChartWithLegend(int approved, int rejected, int pending) {
    final data = [
      {'label': 'Approved', 'value': approved, 'color': Colors.green},
      {'label': 'Rejected', 'value': rejected, 'color': Colors.red},
      {'label': 'Pending', 'value': pending, 'color': Colors.orange},
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildPieChart(data),
        const SizedBox(width: 16),
        _buildLegend(data, approved, rejected, pending),
      ],
    );
  }

  Widget _buildPieChart(List<Map<String, dynamic>> data) {
    return SizedBox(
      width: 150,
      height: 150,
      child: PieChart(
        PieChartData(
          sections: data.map((item) {
            return PieChartSectionData(
              value: item['value'].toDouble(),
              color: item['color'],
              title: '${item['value']}',
              titleStyle: TextStyle(fontSize: 12.h),
            );
          }).toList(),
          sectionsSpace: 4,
        ),
      ),
    );
  }

  Widget _buildLegend(
    List<Map<String, dynamic>> data,
    int approved,
    int rejected,
    int pending,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: data.map((item) {
        final percentage =
            (item['value'] / (approved + rejected + pending) * 100)
                .toStringAsFixed(2);
        return Row(
          children: [
            Container(
              width: 16.w,
              height: 16.h,
              color: item['color'],
            ),
            SizedBox(width: 8.h),
            Text(
              '${item['label']} - ${item['value']} ($percentage%)',
              style: const TextStyle(fontSize: 14),
            ),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildBarChart(int approved, int rejected, int pending) {
    return SizedBox(
      width: double.infinity,
      height: 150,
      child: BarChart(
        BarChartData(
          barGroups: [
            BarChartGroupData(x: 0, barRods: [
              BarChartRodData(toY: approved.toDouble(), color: Colors.green)
            ]),
            BarChartGroupData(x: 1, barRods: [
              BarChartRodData(toY: rejected.toDouble(), color: Colors.red)
            ]),
            BarChartGroupData(x: 2, barRods: [
              BarChartRodData(toY: pending.toDouble(), color: Colors.orange)
            ]),
          ],
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, _) {
                  switch (value.toInt()) {
                    case 0:
                      return const Text('Approved');
                    case 1:
                      return const Text('Rejected');
                    case 2:
                      return const Text('Pending');
                    default:
                      return const SizedBox.shrink();
                  }
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLineChart(int approved, int rejected, int pending) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 200,
          child: LineChart(
            LineChartData(
              lineBarsData: [
                LineChartBarData(
                  spots: [
                    FlSpot(0, approved.toDouble()), // Approved
                    FlSpot(1, rejected.toDouble()), // Rejected
                    FlSpot(2, pending.toDouble()), // Pending
                  ],
                  isCurved: true,
                  color: Colors.blue,
                  belowBarData: BarAreaData(show: false),
                ),
              ],
              titlesData: const FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: true),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: false, // Hide titles at the bottom
                  ),
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 8.h), // Add some space between the chart and the row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildStatusLabel('Approved', approved),
            const SizedBox(width: 16), // Add space between the items in the row
            _buildStatusLabel('Rejected', rejected),
            const SizedBox(width: 16),
            _buildStatusLabel('Pending', pending),
          ],
        ),
      ],
    );
  }

  Widget _buildStatusLabel(String label, int value) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        Text(
          '$value',
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildUsersContactsLeadsChart(BuildContext context) {
    final usersCount = context.watch<AdminCubit>().state.data?.length ?? 0;
    final contactsCount = context.watch<ContactCubit>().state.data?.length ?? 0;
    final leadsCount = context.watch<LeadCubit>().state.data?.length ?? 0;

    final data = [
      {'label': 'Users', 'value': usersCount, 'color': AppColors.accentColor},
      {'label': 'Contacts', 'value': contactsCount, 'color': Colors.green},
      {'label': 'Leads', 'value': leadsCount, 'color': Colors.orange},
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Pie chart on the left
        Column(
          children: [
            SizedBox(
              width: 150,
              height: 150,
              child: PieChart(
                PieChartData(
                  sections: data.map((item) {
                    return PieChartSectionData(
                      value: item['value'].toDouble(),
                      color: item['color'],
                      title: '${item['value']}',
                      titleStyle: const TextStyle(fontSize: 12),
                    );
                  }).toList(),
                  sectionsSpace: 4,
                ),
              ),
            ),
          ],
        ),

        SizedBox(width: 16.w),
        // Legend on the right
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: data.map((item) {
            return Row(
              children: [
                Container(
                  width: 16,
                  height: 16,
                  color: item['color'],
                ),
                const SizedBox(width: 8),
                Text(
                  '${item['label']} - ${item['value']} (${(item['value'] / (usersCount + contactsCount + leadsCount) * 100).toStringAsFixed(2)}%)',
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }
}
