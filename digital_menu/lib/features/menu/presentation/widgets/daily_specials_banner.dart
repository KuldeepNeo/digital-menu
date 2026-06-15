import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/dish.dart';
import '../../domain/entities/special.dart';
import '../bloc/cart_cubit.dart';

class DailySpecialsBanner extends StatelessWidget {
  final Special special;
  final Dish dish;

  const DailySpecialsBanner({
    super.key,
    required this.special,
    required this.dish,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primary.withAlpha(204), // 0.8 opacity
            theme.colorScheme.primary,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withAlpha(51),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 600;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                // Icon / Badge
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(51),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.star_rounded,
                    color: Colors.amber,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),

                // Title & Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        special.title,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Promo Item: ${dish.name} • ₹${dish.price.toStringAsFixed(0)}',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.white.withAlpha(204),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),

                // Linked dish photo and quick add button
                if (dish.isAvailable)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Dish image preview
                      if (!isMobile)
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.white.withAlpha(102), width: 1),
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: dish.photoUrl.startsWith('data:image')
                              ? Image.memory(
                                  base64Decode(dish.photoUrl.split(',').last),
                                  fit: BoxFit.cover,
                                )
                              : CachedNetworkImage(
                                  imageUrl: dish.photoUrl,
                                  fit: BoxFit.cover,
                                ),
                        ),
                      const SizedBox(width: 12),
                      ElevatedButton(
                        onPressed: () {
                          context.read<CartCubit>().addDish(dish);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Added ${dish.name} to cart!'),
                              duration: const Duration(seconds: 1),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: theme.colorScheme.primary,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        ),
                        child: const Text('Add to Cart', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
