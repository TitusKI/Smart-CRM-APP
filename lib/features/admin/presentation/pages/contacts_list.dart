import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:smart_crm_app/features/contacts/domain/entities/contact_entity.dart';
import 'package:smart_crm_app/features/contacts/presentation/bloc/contact_cubit.dart';

import '../../../../config/theme/colors.dart';
import '../../../../core/resources/generic_state.dart';

class ContactsList extends StatefulWidget {
  const ContactsList({super.key});

  @override
  State<ContactsList> createState() => _ContactsListState();
}

class _ContactsListState extends State<ContactsList> {
  @override
  void initState() {
    super.initState();
    context.read<ContactCubit>().fetchContacts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocBuilder<ContactCubit, GenericState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state.failure != null && state.failure!.isNotEmpty) {
              return Center(child: Text("Error: ${state.failure}"));
            } else if (state.data == null || state.data!.isEmpty) {
              return const Center(child: Text("No contacts available."));
            }

            final List<ContactEntity> contacts = state.data!;
            return Card(
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
                    const Text(
                      "Contacts",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
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
                        columns: const [
                          DataColumn(label: Text('Name')),
                          DataColumn(label: Text('Phone')),
                          DataColumn(label: Text('Address')),
                          DataColumn(label: Text('Role')),
                        ],
                        rows: contacts.map((contact) {
                          return DataRow(
                            cells: [
                              DataCell(Text(contact.name)),
                              DataCell(Text(contact.phone)),
                              DataCell(Text(contact.address ?? "N/A")),
                              DataCell(Text(contact.role ?? "N/A")),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
