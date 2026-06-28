import 'package:flutter/material.dart';

/// Value returned by [ManualAddDialog] when the user confirms.
class ManualEntry {
  final String host;
  final int port;

  const ManualEntry({required this.host, required this.port});
}

/// Dialog for entering a server's IP address and port manually.
///
/// This is the fallback path when Bonjour discovery is blocked by the network.
class ManualAddDialog extends StatefulWidget {
  const ManualAddDialog({super.key});

  @override
  State<ManualAddDialog> createState() => _ManualAddDialogState();
}

class _ManualAddDialogState extends State<ManualAddDialog> {
  final _hostController = TextEditingController();
  final _portController = TextEditingController(text: '8080');
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _hostController.dispose();
    _portController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    Navigator.of(context).pop(
      ManualEntry(
        host: _hostController.text.trim(),
        port: int.parse(_portController.text.trim()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Server'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _hostController,
              decoration: const InputDecoration(
                labelText: 'IP address',
                hintText: '192.168.0.10',
              ),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              validator: (value) =>
                  (value == null || value.trim().isEmpty) ? 'Required' : null,
            ),
            TextFormField(
              controller: _portController,
              decoration: const InputDecoration(labelText: 'Port'),
              keyboardType: TextInputType.number,
              validator: (value) {
                final port = int.tryParse(value?.trim() ?? '');
                if (port == null || port <= 0 || port > 65535) {
                  return 'Invalid port';
                }
                return null;
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _submit,
          child: const Text('Add'),
        ),
      ],
    );
  }
}
