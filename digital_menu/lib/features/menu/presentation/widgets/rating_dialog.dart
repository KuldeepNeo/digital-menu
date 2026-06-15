import 'dart:convert';
import 'package:flutter/material.dart';
import '../../../../core/utils/storage_helper.dart';
import '../../domain/entities/dish.dart';

class RatingDialog extends StatefulWidget {
  final Dish dish;
  final Function(int rating) onSubmit;

  const RatingDialog({
    super.key,
    required this.dish,
    required this.onSubmit,
  });

  @override
  State<RatingDialog> createState() => _RatingDialogState();
}

class _RatingDialogState extends State<RatingDialog> {
  int _selectedRating = 5;

  static const String _ratedDishesKey = 'rated_dishes';

  bool _hasAlreadyRated() {
    try {
      final stored = StorageHelper.load(_ratedDishesKey);
      if (stored != null && stored.isNotEmpty) {
        final List<dynamic> decoded = jsonDecode(stored);
        return decoded.contains(widget.dish.id);
      }
    } catch (_) {}
    return false;
  }

  void _markAsRated() {
    try {
      final stored = StorageHelper.load(_ratedDishesKey);
      List<String> ratedList = [];
      if (stored != null && stored.isNotEmpty) {
        final List<dynamic> decoded = jsonDecode(stored);
        ratedList = decoded.map((e) => e.toString()).toList();
      }
      if (!ratedList.contains(widget.dish.id)) {
        ratedList.add(widget.dish.id);
        StorageHelper.save(_ratedDishesKey, jsonEncode(ratedList));
      }
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final alreadyRated = _hasAlreadyRated();

    return AlertDialog(
      title: Text(
        alreadyRated ? 'Already Rated' : 'Rate "${widget.dish.name}"',
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      content: alreadyRated
          ? const Text('You have already submitted a rating for this item.')
          : Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('How would you rate this dish?'),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) {
                    final starRating = index + 1;
                    final isFilled = starRating <= _selectedRating;
                    return InkWell(
                      onTap: () {
                        setState(() {
                          _selectedRating = starRating;
                        });
                      },
                      borderRadius: BorderRadius.circular(24),
                      child: Container(
                        width: 48,
                        height: 48,
                        alignment: Alignment.center,
                        child: Icon(
                          isFilled ? Icons.star_rounded : Icons.star_outline_rounded,
                          color: Colors.amber[700],
                          size: 36,
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        if (!alreadyRated)
          ElevatedButton(
            onPressed: () {
              widget.onSubmit(_selectedRating);
              _markAsRated();
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.primary,
              foregroundColor: Colors.white,
            ),
            child: const Text('Submit'),
          ),
      ],
    );
  }
}
