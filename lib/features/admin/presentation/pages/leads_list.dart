import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:smart_crm_app/features/leads/domain/entities/lead_entity.dart';
import 'package:smart_crm_app/features/leads/presentation/bloc/leads_cubit.dart';

import '../../../../config/theme/colors.dart';
import '../../../../core/resources/generic_state.dart';

class LeadsList extends StatefulWidget {
  const LeadsList({super.key});

  @override
  State<LeadsList> createState() => _LeadsListState();
}

class _LeadsListState extends State<LeadsList>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    context.read<LeadCubit>().fetchLeads(); // Fetch leads when the screen loads
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TabBar(
        indicatorColor: AppColors.accentColor,
        dividerColor: AppColors.accentColor,
        controller: _tabController,
        tabs: const [
          Tab(text: "Pending"),
          Tab(text: "Approved"),
          Tab(text: "Rejected"),
        ],
      ),
      body: BlocBuilder<LeadCubit, GenericState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.failure != null && state.failure!.isNotEmpty) {
            return Center(child: Text("Error: ${state.failure}"));
          } else if (state.data == null || state.data!.isEmpty) {
            return const Center(child: Text("No leads available."));
          }

          final List<LeadEntity> leads = state.data!;
          final pendingLeads =
              leads.where((lead) => lead.status == "Pending").toList();
          final approvedLeads =
              leads.where((lead) => lead.status == "Approved").toList();
          final rejectedLeads =
              leads.where((lead) => lead.status == "Rejected").toList();

          return TabBarView(
            controller: _tabController,
            children: [
              _buildLeadsTable(pendingLeads, context, true),
              _buildLeadsTable(approvedLeads, context, false),
              _buildLeadsTable(rejectedLeads, context, false),
            ],
          );
        },
      ),
    );
  }

  Widget _buildLeadsTable(
      List<LeadEntity> leads, BuildContext context, bool isLeadPending) {
    if (leads.isEmpty) {
      return const Center(child: Text("No leads in this category."));
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        shadowColor: Colors.grey.withOpacity(0.5),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: DataTable2(
                  columnSpacing: 12,
                  horizontalMargin: 12,
                  minWidth: 800,
                  headingRowColor: WidgetStateProperty.resolveWith(
                    (states) => AppColors.accentColor.withOpacity(0.5),
                  ),
                  headingTextStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.accentColor,
                  ),
                  columns: [
                    const DataColumn(label: Text('ID')),
                    const DataColumn(label: Text('Title')),
                    const DataColumn(label: Text('Description')),
                    const DataColumn(label: Text('Status')),
                    if (isLeadPending) const DataColumn(label: Text('Actions')),
                  ],
                  rows: leads.map((lead) {
                    return DataRow(
                      cells: [
                        DataCell(Text(lead.id ?? "-")),
                        DataCell(Text(lead.title)),
                        DataCell(Text(lead.description)),
                        DataCell(Text(
                          lead.status ?? "Pending",
                          style: TextStyle(
                            color: lead.status == "Approved"
                                ? Colors.green
                                : lead.status == "Rejected"
                                    ? Colors.red
                                    : Colors.orange,
                            fontWeight: FontWeight.bold,
                          ),
                        )),
                        if (isLeadPending)
                          DataCell(Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.check,
                                    color: Colors.green),
                                onPressed: () {
                                  _approveLead(context, lead);
                                },
                              ),
                              IconButton(
                                icon:
                                    const Icon(Icons.cancel, color: Colors.red),
                                onPressed: () {
                                  _rejectLead(context, lead);
                                },
                              ),
                            ],
                          )),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _approveLead(BuildContext context, LeadEntity lead) {
    context.read<LeadCubit>().approveLead(lead);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Lead approved successfully!")),
    );
  }

  void _rejectLead(BuildContext context, LeadEntity lead) {
    final rejectionNoteController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Reject Lead"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Provide a rejection note:"),
            const SizedBox(height: 10),
            TextField(
              controller: rejectionNoteController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Rejection Note",
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: const Color.fromARGB(99, 255, 255, 255),
              foregroundColor: Colors.black,
            ),
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromRGBO(150, 40, 33, 1),
            ),
            onPressed: () {
              final rejectionNote = rejectionNoteController.text;
              if (rejectionNote.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text("Rejection note cannot be empty")),
                );
                return;
              }
              final updatedLead = LeadEntity(
                id: lead.id,
                title: lead.title,
                description: lead.description,
                status: "Rejected",
                rejectionNotes: rejectionNote,
              );
              context.read<LeadCubit>().rejectLead(updatedLead);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Lead rejected successfully!")),
              );
            },
            child: const Text(
              "Reject",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
