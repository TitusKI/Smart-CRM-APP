import 'package:flutter/material.dart';

class LeadFormDialog extends StatefulWidget {
  final String? initialTitle;
  final String? initialDescription;
  final String? initialStatus;
  final Function(String title, String description, String status) onSubmit;

  const LeadFormDialog({
    super.key,
    this.initialTitle,
    this.initialDescription,
    this.initialStatus,
    required this.onSubmit,
  });

  @override
  State<LeadFormDialog> createState() => _LeadFormDialogState();
}

class _LeadFormDialogState extends State<LeadFormDialog> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  String? _selectedStatus;

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
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_titleController.text.isNotEmpty &&
                _descriptionController.text.isNotEmpty &&
                _selectedStatus != null) {
              widget.onSubmit(
                _titleController.text,
                _descriptionController.text,
                _selectedStatus!,
              );
              Navigator.pop(context);
            }
          },
          child: const Text('Submit'),
        ),
      ],
    );
  }
}
