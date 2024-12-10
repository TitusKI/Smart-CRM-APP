import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_crm_app/features/leads/domain/entities/lead_entity.dart';

import '../../../../config/theme/colors.dart';
import '../../../../core/resources/generic_state.dart';
import '../bloc/leads_cubit.dart';

class LeadsScreen extends StatefulWidget {
  const LeadsScreen({super.key});

  @override
  State<LeadsScreen> createState() => _LeadsScreenState();
}

class _LeadsScreenState extends State<LeadsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    context.read<LeadCubit>().fetchLeads();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<LeadCubit>();

    return Scaffold(
      appBar: TabBar(
        indicatorColor: AppColors.accentColor,
        dividerColor: AppColors.accentColor,
        controller: _tabController,
        tabs: const [
          Tab(text: "Approved"),
          Tab(text: "Pending"),
          Tab(text: "Rejected"),
        ],
      ),
      body: BlocBuilder<LeadCubit, GenericState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.failure?.isNotEmpty == true) {
            return Center(
              child: Text(
                'Error: ${state.failure}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          // Map leads based on status
          final approvedLeads =
              state.data?.where((lead) => lead.status == "Approved").toList() ??
                  [];
          final pendingLeads =
              state.data?.where((lead) => lead.status == "Pending").toList() ??
                  [];
          final rejectedLeads =
              state.data?.where((lead) => lead.status == "Rejected").toList() ??
                  [];

          return TabBarView(
            controller: _tabController,
            children: [
              _buildLeadsList(context, approvedLeads, cubit, false),
              _buildLeadsList(context, pendingLeads, cubit, true),
              _buildLeadsList(context, rejectedLeads, cubit, false),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        foregroundColor: AppColors.accentColor,
        backgroundColor: AppColors.primaryBackground,
        onPressed: () => _showAddLeadForm(context),
        child: const Icon(
          Icons.add,
          weight: 3,
        ),
      ),
    );
  }

  Widget _buildLeadsList(
      BuildContext context, List leads, LeadCubit cubit, bool isLeadPending) {
    if (leads.isEmpty) {
      return const Center(
        child: Text('No leads found'),
      );
    }

    return ListView.builder(
      itemCount: leads.length,
      itemBuilder: (context, index) {
        final lead = leads[index];

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            elevation: 4,
            child: ListTile(
              contentPadding: const EdgeInsets.all(16.0),
              leading: CircleAvatar(
                backgroundColor: AppColors.accentColor,
                child: Text(
                  lead.title[0].toUpperCase(),
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              title: Text(
                lead.title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    lead.description,
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  Text(
                    "Status: ${lead.status}",
                    style: TextStyle(
                        color: Colors.grey[600], fontStyle: FontStyle.italic),
                  ),
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  isLeadPending
                      ? IconButton(
                          icon: const Icon(Icons.edit, color: Colors.green),
                          onPressed: () => _showEditLeadForm(context, lead),
                        )
                      : const SizedBox(),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => cubit.deleteLead(lead.id!),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showAddLeadForm(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => _LeadFormDialog(
        onSubmit: (title, description) {
          context
              .read<LeadCubit>()
              .addLead(LeadEntity(title: title, description: description));
        },
      ),
    );
  }

  void _showEditLeadForm(BuildContext context, lead) {
    showDialog(
      context: context,
      builder: (context) => _LeadFormDialog(
        initialTitle: lead.title,
        initialDescription: lead.description,
        onSubmit: (title, description) {
          context.read<LeadCubit>().updateLead(LeadEntity(
                title: title,
                description: description,
                id: lead.id,
              ));
        },
      ),
    );
  }
}

class _LeadFormDialog extends StatefulWidget {
  final String? initialTitle;
  final String? initialDescription;

  final Function(String title, String description) onSubmit;

  const _LeadFormDialog({
    super.key,
    this.initialTitle,
    this.initialDescription,
    required this.onSubmit,
  });

  @override
  State<_LeadFormDialog> createState() => _LeadFormDialogState();
}

class _LeadFormDialogState extends State<_LeadFormDialog> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.initialTitle ?? '');
    _descriptionController =
        TextEditingController(text: widget.initialDescription ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.initialTitle == null ? 'Add Lead' : 'Edit Lead'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(labelText: 'Lead Title'),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _descriptionController,
            decoration: const InputDecoration(labelText: 'Description'),
          ),
          const SizedBox(height: 16),
        ],
      ),
      actions: [
        TextButton(
          style: TextButton.styleFrom(
            foregroundColor: Colors.black,
            backgroundColor: const Color.fromARGB(221, 255, 255, 255),
          ),
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accentColor,
              foregroundColor: AppColors.primaryBackground),
          onPressed: () {
            if (_titleController.text.isNotEmpty &&
                _descriptionController.text.isNotEmpty) {
              widget.onSubmit(
                  _titleController.text, _descriptionController.text);
              Navigator.pop(context);
            }
          },
          child: const Text(
            'Submit',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
