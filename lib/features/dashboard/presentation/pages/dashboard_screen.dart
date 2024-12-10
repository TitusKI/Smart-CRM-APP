import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_crm_app/core/resources/generic_state.dart';
import 'package:smart_crm_app/features/dashboard/domain/entities/dashboarddata.dart';
import '../../../../config/theme/colors.dart';
import '../bloc/dashboard_cubit.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    context.read<DashboardCubit>().fetchDashboardData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<DashboardCubit, GenericState>(
        builder: (context, state) {
          if (state.isSuccess) {
            return _buildDashboardContent(context, state.data);
          } else if (state.failure != null && state.failure!.isNotEmpty) {
            return Center(child: Text(state.failure.toString()));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Widget _buildDashboardContent(BuildContext context, DashboardData data) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Statistics Cards
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _statCard(
                title: 'Contacts',
                value: data.totalContacts.toString(),
                color: AppColors.accentColor,
              ),
              _statCard(
                title: 'Active Leads',
                value: data.activeLeads.toString(),
                color: Colors.green,
              ),
              _statCard(
                title: 'Pending Leads',
                value: data.pendingLeads.toString(),
                color: Colors.orange,
              ),
            ],
          ),
          SizedBox(height: 20.h),

          // Recent Activities
          Text(
            'Recent Activities',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10.h),
          ...data.recentActivities.map((activity) => _recentActivityTile(
                title: activity['title']!,
                timestamp: activity['timestamp']!,
              )),
          SizedBox(height: 20.h),

          // Leads Pie Chart
          Text(
            'Leads Overview',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10.h),
          _buildPieChartWithLegend(data),
          SizedBox(height: 20.h),

          // Leads Bar Chart
          Text(
            'Leads Distribution',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10.h),
          SizedBox(
            height: 200.h,
            child: _buildBarChart(data),
          ),
        ],
      ),
    );
  }

  Widget _statCard(
      {required String title, required String value, required Color color}) {
    return Container(
      width: 100.w,
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.2),
            offset: const Offset(0, 3),
          )
        ],
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10.w),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          SizedBox(height: 5.h),
          Text(
            title,
            style: TextStyle(
              fontSize: 14.sp,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _recentActivityTile(
      {required String title, required String timestamp}) {
    return ListTile(
      leading: const Icon(Icons.notifications, color: AppColors.accentColor),
      title: Text(title, style: TextStyle(fontSize: 14.sp)),
      subtitle: Text(timestamp, style: TextStyle(fontSize: 12.sp)),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
    );
  }

  Widget _buildPieChartWithLegend(DashboardData data) {
    final totalLeads =
        data.activeLeads + data.pendingLeads + data.rejectedLeads;

    return Column(
      children: [
        SizedBox(
          height: 200.h,
          child: PieChart(
            PieChartData(
              sectionsSpace: 0,
              centerSpaceRadius: 50,
              sections: [
                PieChartSectionData(
                  color: Colors.green,
                  value: data.activeLeads.toDouble(),
                  title:
                      '${(data.activeLeads / totalLeads * 100).toStringAsFixed(1)}%',
                  radius: 50,
                ),
                PieChartSectionData(
                  color: Colors.orange,
                  value: data.pendingLeads.toDouble(),
                  title:
                      '${(data.pendingLeads / totalLeads * 100).toStringAsFixed(1)}%',
                  radius: 50,
                ),
                PieChartSectionData(
                  color: Colors.red,
                  value: data.rejectedLeads.toDouble(),
                  title:
                      '${(data.rejectedLeads / totalLeads * 100).toStringAsFixed(1)}%',
                  radius: 50,
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 10.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildLegendItem('Active', data.activeLeads, Colors.green),
            _buildLegendItem('Pending', data.pendingLeads, Colors.orange),
            _buildLegendItem('Rejected', data.rejectedLeads, Colors.red),
          ],
        ),
      ],
    );
  }

  Widget _buildLegendItem(String title, int value, Color color) {
    return Row(
      children: [
        Container(
          width: 10.w,
          height: 10.w,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        SizedBox(width: 5.w),
        Text(
          '$title: $value',
          style: TextStyle(fontSize: 12.sp),
        ),
      ],
    );
  }

  Widget _buildBarChart(DashboardData data) {
    return BarChart(
      BarChartData(
        barGroups: [
          BarChartGroupData(
            x: 0,
            barRods: [
              BarChartRodData(
                toY: data.activeLeads.toDouble(),
                color: Colors.green,
              ),
            ],
          ),
          BarChartGroupData(
            x: 1,
            barRods: [
              BarChartRodData(
                toY: data.pendingLeads.toDouble(),
                color: Colors.orange,
              ),
            ],
          ),
          BarChartGroupData(
            x: 2,
            barRods: [
              BarChartRodData(
                toY: data.rejectedLeads.toDouble(),
                color: Colors.red,
              ),
            ],
          ),
        ],
        titlesData: FlTitlesData(
          leftTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: true),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                switch (value.toInt()) {
                  case 0:
                    return const Text('Active');
                  case 1:
                    return const Text('Pending');
                  case 2:
                    return const Text('Rejected');
                  default:
                    return const Text('');
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
