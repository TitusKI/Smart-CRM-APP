import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_crm_app/core/resources/generic_state.dart';
import 'package:smart_crm_app/features/auth/presentation/widgets/common_widgets.dart';
import 'package:smart_crm_app/features/contacts/domain/entities/contact_entity.dart';
import '../../../../config/theme/colors.dart';
import '../bloc/contact_cubit.dart';

void showAddOrEditContactForm(BuildContext context, {ContactEntity? contact}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (context) => Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
        top: 16,
      ),
      child: ContactForm(contact: contact),
    ),
  );
}

class ContactsScreen extends StatefulWidget {
  const ContactsScreen({super.key});

  @override
  State<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ContactCubit>().fetchContacts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<ContactCubit, GenericState>(
        builder: (context, state) {
          final cubit = context.read<ContactCubit>();

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

          final contacts = state.data as List<ContactEntity>? ?? [];

          return Column(
            children: [
              // Search Bar
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  onChanged: (value) {
                    // Optionally implement search functionality here
                  },
                  decoration: InputDecoration(
                    hintText: 'Search by name or email',
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),

              // Contact List
              Expanded(
                child: ListView.builder(
                  itemCount: contacts.length,
                  itemBuilder: (context, index) {
                    final ContactEntity contact = contacts[index];

                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8.0),
                      child: GestureDetector(
                        onTap: () {
                          // Display contact details
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ContactDetailScreen(contact: contact),
                            ),
                          );
                        },
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(12.0),
                          tileColor: Colors.grey[100],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          leading: CircleAvatar(
                            radius: 24,
                            backgroundColor: AppColors.accentColor,
                            child: Text(
                              contact.name[0].toUpperCase(), // First letter
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          title: Text(
                            contact.name,
                            style: const TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 16),
                          ),
                          subtitle: Text(contact.phone),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon:
                                    const Icon(Icons.edit, color: Colors.green),
                                onPressed: () {
                                  showAddOrEditContactForm(context,
                                      contact: contact);
                                },
                              ),
                              IconButton(
                                icon:
                                    const Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  cubit.deleteContact(contact.id!);
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class ContactForm extends StatelessWidget {
  final ContactEntity? contact;

  const ContactForm({super.key, this.contact});

  @override
  Widget build(BuildContext context) {
    final TextEditingController nameController =
        TextEditingController(text: contact?.name ?? '');
    final TextEditingController phoneController =
        TextEditingController(text: contact?.phone ?? '');
    final TextEditingController roleController =
        TextEditingController(text: contact?.role ?? '');
    final TextEditingController addressController =
        TextEditingController(text: contact?.address ?? '');

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            contact == null ? 'Add Contact' : 'Edit Contact',
            style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.accentColor),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: nameController,
            decoration: const InputDecoration(
              labelText: 'Name',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: phoneController,
            decoration: const InputDecoration(
              labelText: 'Phone',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: addressController,
            decoration: const InputDecoration(
              labelText: 'email address',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: roleController,
            decoration: const InputDecoration(
              labelText: 'role',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accentColor,
            ),
            onPressed: () {
              final cubit = context.read<ContactCubit>();
              if (contact == null) {
                cubit.addContact(ContactEntity(
                  name: nameController.text,
                  phone: phoneController.text,
                  role: roleController.text,
                  address: addressController.text,
                ));
              } else {
                cubit.updateContact(
                  ContactEntity(
                    id: contact!.id,
                    name: nameController.text,
                    phone: phoneController.text,
                    role: roleController.text,
                    address: addressController.text,
                  ),
                );
              }
              Navigator.pop(context);
            },
            child: Text(
              contact == null ? 'Add Contact' : 'Update Contact',
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

class ContactDetailScreen extends StatelessWidget {
  final ContactEntity contact;

  const ContactDetailScreen({super.key, required this.contact});

  @override
  Widget build(BuildContext context) {
    print(contact);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Contact Details",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Animation Wrapper
            Expanded(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 800),
                curve: Curves.easeInOut,
                child: ListView(
                  children: [
                    const SizedBox(height: 20),
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.accentColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border:
                            Border.all(color: AppColors.accentColor, width: 1),
                      ),
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Contact Information',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: AppColors.accentColor,
                            ),
                          ),
                          const SizedBox(height: 20),
                          _buildContactDetail(
                              title: 'Name:', value: contact.name),
                          const SizedBox(height: 12),
                          _buildContactDetail(
                              title: 'Phone:', value: contact.phone),
                          const SizedBox(height: 12),
                          _buildContactDetail(
                              title: 'Role:', value: contact.role ?? ""),
                          const SizedBox(height: 12),
                          _buildContactDetail(
                              title: 'Address:', value: contact.address ?? ""),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactDetail({required String title, required String value}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$title ',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black54,
            ),
          ),
        ),
      ],
    );
  }
}
