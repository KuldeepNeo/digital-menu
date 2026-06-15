import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/di.dart';
import '../../../../shared/widgets/shimmer_loader.dart';
import '../bloc/menu_cubit.dart';
import '../bloc/menu_state.dart';
import '../bloc/cart_cubit.dart';
import '../bloc/cart_state.dart';
import '../widgets/dish_card.dart';
import '../widgets/cart_sheet.dart';

class MenuPage extends StatelessWidget {
  final String? tableNumber;

  const MenuPage({super.key, this.tableNumber});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<MenuCubit>(
          create: (context) => sl<MenuCubit>()..loadMenu(),
        ),
        BlocProvider<CartCubit>(
          create: (context) {
            final cubit = sl<CartCubit>()..loadCart();
            if (tableNumber != null) {
              cubit.setTableNumber(tableNumber);
            }
            return cubit;
          },
        ),
      ],
      child: const MenuPageContent(),
    );
  }
}

class MenuPageContent extends StatelessWidget {
  const MenuPageContent({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Our Café Menu',
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
        centerTitle: true,
      ),
      body: SafeArea(
        child: BlocBuilder<MenuCubit, MenuState>(
          builder: (context, state) {
            if (state.isLoadingCategories) {
              return const ShimmerLoader();
            }

            if (state.errorMessage != null && state.categories.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline_rounded, size: 48, color: Colors.red),
                      const SizedBox(height: 16),
                      Text(
                        'Failed to load menu: ${state.errorMessage}',
                        style: theme.textTheme.bodyLarge,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => context.read<MenuCubit>().loadMenu(),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              );
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Table Selector Bar
                BlocBuilder<CartCubit, CartState>(
                  builder: (context, cartState) {
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.secondary.withAlpha(15),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: cartState.tableNumber != null
                              ? theme.colorScheme.primary.withAlpha(51)
                              : Colors.red.withAlpha(51),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.table_bar_rounded,
                                color: cartState.tableNumber != null
                                    ? theme.colorScheme.primary
                                    : Colors.red[700],
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                cartState.tableNumber != null
                                    ? 'Dining at Table ${cartState.tableNumber}'
                                    : 'No Table Selected',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: cartState.tableNumber != null
                                      ? theme.colorScheme.onSurface
                                      : Colors.red[700],
                                ),
                              ),
                            ],
                          ),
                          TextButton(
                            onPressed: () {
                              showModalBottomSheet(
                                context: context,
                                builder: (sheetContext) => BlocProvider.value(
                                  value: context.read<CartCubit>(),
                                  child: const _TableSelectSheet(),
                                ),
                              );
                            },
                            child: Text(
                              cartState.tableNumber != null ? 'Change' : 'Select Table',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                // Horizontal category slider
                if (state.categories.isNotEmpty)
                  SizedBox(
                    height: 60,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      itemCount: state.categories.length,
                      itemBuilder: (context, index) {
                        final category = state.categories[index];
                        final isSelected = category.id == state.selectedCategoryId;
                        return Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: ChoiceChip(
                            label: Text(
                              category.name,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: isSelected
                                    ? Colors.white
                                    : theme.colorScheme.primary,
                              ),
                            ),
                            selected: isSelected,
                            selectedColor: theme.colorScheme.primary,
                            backgroundColor: theme.colorScheme.secondary.withAlpha(25),
                            checkmarkColor: Colors.white,
                            onSelected: (selected) {
                              if (selected) {
                                context.read<MenuCubit>().selectCategory(category.id);
                              }
                            },
                          ),
                        );
                      },
                    ),
                  ),
                // Dishes Grid/List section
                Expanded(
                  child: Builder(
                    builder: (context) {
                      if (state.isLoadingDishes) {
                        return const ShimmerLoader();
                      }

                      if (state.errorMessage != null) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Error loading dishes: ${state.errorMessage}',
                                style: theme.textTheme.bodyMedium,
                              ),
                              const SizedBox(height: 8),
                              ElevatedButton(
                                onPressed: () {
                                  if (state.selectedCategoryId != null) {
                                    context
                                        .read<MenuCubit>()
                                        .selectCategory(state.selectedCategoryId!);
                                  }
                                },
                                child: const Text('Retry'),
                              ),
                            ],
                          ),
                        );
                      }

                      if (state.dishes.isEmpty) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.no_meals_rounded,
                                  size: 48,
                                  color: Colors.grey[400],
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  'No items available in this category',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }

                      return GridView.builder(
                        padding: const EdgeInsets.all(16),
                        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 400,
                          childAspectRatio: 0.82,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                        itemCount: state.dishes.length,
                        itemBuilder: (context, index) {
                          final dish = state.dishes[index];
                          return DishCard(dish: dish);
                        },
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
      bottomNavigationBar: BlocBuilder<CartCubit, CartState>(
        builder: (context, state) {
          if (state.itemQuantities.isEmpty) {
            return const SizedBox.shrink();
          }

          final totalItems = state.itemQuantities.values.fold(0, (sum, q) => sum + q);
          final totalPrice = state.itemDetails.entries.fold(
            0.0,
            (sum, entry) => sum + (entry.value.price * (state.itemQuantities[entry.key] ?? 0)),
          );

          return Container(
            color: theme.colorScheme.surface,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: SafeArea(
              child: ElevatedButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (sheetContext) => BlocProvider.value(
                      value: context.read<CartCubit>(),
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.75,
                        child: const CartSheet(),
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 4,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.shopping_basket_rounded),
                        const SizedBox(width: 8),
                        Text(
                          '$totalItems ${totalItems == 1 ? 'item' : 'items'}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Text(
                      'View Cart • ₹${totalPrice.toStringAsFixed(0)}',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _TableSelectSheet extends StatelessWidget {
  const _TableSelectSheet();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Select Table Number',
            style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            alignment: WrapAlignment.center,
            children: List.generate(20, (index) {
              final table = '${index + 1}';
              return ChoiceChip(
                label: Text(table),
                selected: context.watch<CartCubit>().state.tableNumber == table,
                onSelected: (selected) {
                  if (selected) {
                    context.read<CartCubit>().setTableNumber(table);
                    Navigator.of(context).pop();
                  }
                },
              );
            }),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
