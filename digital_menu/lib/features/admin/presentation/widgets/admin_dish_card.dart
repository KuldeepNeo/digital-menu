import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../menu/domain/entities/dish.dart';
import '../controllers/admin_dish_cubit.dart';

class AdminDishCard extends StatelessWidget {
  final Dish dish;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const AdminDishCard({
    super.key,
    required this.dish,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 2,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              children: [
                Positioned.fill(
                  child: dish.photoUrl.startsWith('data:image')
                      ? Image.memory(
                          base64Decode(dish.photoUrl.split(',').last),
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            color: Colors.grey[200],
                            child: const Center(
                              child: Icon(Icons.broken_image_outlined, color: Colors.grey),
                            ),
                          ),
                        )
                      : CachedNetworkImage(
                          imageUrl: dish.photoUrl,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            color: Colors.grey[200],
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          ),
                          errorWidget: (context, url, error) => Container(
                            color: Colors.grey[200],
                            child: const Center(
                              child: Icon(
                                Icons.broken_image_outlined,
                                color: Colors.grey,
                                size: 32,
                              ),
                            ),
                          ),
                        ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withAlpha(230),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.edit_rounded, size: 18, color: Colors.blue),
                          onPressed: onEdit,
                          constraints: const BoxConstraints(),
                          padding: const EdgeInsets.all(8),
                          tooltip: 'Edit Dish',
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withAlpha(230),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.delete_rounded, size: 18, color: Colors.red),
                          onPressed: onDelete,
                          constraints: const BoxConstraints(),
                          padding: const EdgeInsets.all(8),
                          tooltip: 'Delete Dish',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  dish.name,
                  style: theme.textTheme.titleMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '₹${dish.price.toStringAsFixed(0)}',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          dish.isAvailable ? 'In Stock' : 'Out of Stock',
                          style: TextStyle(
                            fontSize: 12,
                            color: dish.isAvailable ? Colors.green : Colors.red,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 4),
                        SizedBox(
                          height: 24,
                          width: 40,
                          child: Transform.scale(
                            scale: 0.75,
                            child: Switch(
                              value: dish.isAvailable,
                              onChanged: (value) {
                                context.read<AdminDishCubit>().toggleAvailability(dish);
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
