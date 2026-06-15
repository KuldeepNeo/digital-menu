import 'package:flutter/material.dart';
import '../../../../core/di/di.dart';
import '../../../menu/domain/entities/dish.dart';
import '../../../menu/domain/usecases/get_all_dishes_usecase.dart';
import '../../../menu/domain/usecases/set_special_usecase.dart';

class SetSpecialDialog extends StatefulWidget {
  const SetSpecialDialog({super.key});

  @override
  State<SetSpecialDialog> createState() => _SetSpecialDialogState();
}

class _SetSpecialDialogState extends State<SetSpecialDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();

  List<Dish> _dishes = [];
  String? _selectedDishId;
  bool _isLoading = true;
  bool _isSaving = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadDishes();
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _loadDishes() async {
    try {
      final result = await sl<GetAllDishesUseCase>().call();
      if (result.isSuccess && result.data != null) {
        setState(() {
          _dishes = result.data!.where((d) => d.isAvailable).toList();
          if (_dishes.isNotEmpty) {
            _selectedDishId = _dishes.first.id;
          }
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = result.message;
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _saveSpecial() async {
    if (!_formKey.currentState!.validate() || _selectedDishId == null) return;

    setState(() {
      _isSaving = true;
      _errorMessage = null;
    });

    try {
      // Calculate today's midnight timestamp
      final now = DateTime.now();
      final midnight = DateTime(now.year, now.month, now.day, 23, 59, 59, 999);
      final expiresAt = midnight.millisecondsSinceEpoch;

      final result = await sl<SetSpecialUseCase>().call(
        _selectedDishId!,
        _titleController.text.trim(),
        expiresAt,
      );

      if (result.isSuccess) {
        if (mounted) {
          Navigator.pop(context, true);
        }
      } else {
        setState(() {
          _errorMessage = result.message;
          _isSaving = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isSaving = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      title: const Text(
        'Configure Daily Special',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: _isLoading
          ? const SizedBox(
              height: 100,
              child: Center(child: CircularProgressIndicator()),
            )
          : Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (_errorMessage != null) ...[
                    Text(
                      _errorMessage!,
                      style: const TextStyle(color: Colors.red, fontSize: 12),
                    ),
                    const SizedBox(height: 12),
                  ],
                  if (_dishes.isEmpty)
                    const Text('No available dishes found to set as special.')
                  else ...[
                    DropdownButtonFormField<String>(
                      initialValue: _selectedDishId,
                      decoration: const InputDecoration(
                        labelText: 'Select Dish',
                        border: OutlineInputBorder(),
                      ),
                      items: _dishes.map((dish) {
                        return DropdownMenuItem<String>(
                          value: dish.id,
                          child: Text('${dish.name} (₹${dish.price.toStringAsFixed(0)})'),
                        );
                      }).toList(),
                      onChanged: (val) {
                        setState(() {
                          _selectedDishId = val;
                        });
                      },
                      validator: (value) => value == null ? 'Please select a dish' : null,
                    ),
                    const SizedBox(height: 16),

                    // Promotional Title Input
                    TextFormField(
                      controller: _titleController,
                      decoration: const InputDecoration(
                        labelText: 'Promotional Message',
                        hintText: 'e.g., Today\'s Special: 20% off Hot Mocha!',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter a promotional message';
                        }
                        return null;
                      },
                    ),
                  ],
                ],
              ),
            ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        if (!_isLoading && _dishes.isNotEmpty)
          ElevatedButton(
            onPressed: _isSaving ? null : _saveSpecial,
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.primary,
              foregroundColor: Colors.white,
            ),
            child: _isSaving
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                  )
                : const Text('Save Banner'),
          ),
      ],
    );
  }
}
