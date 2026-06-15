import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/di/di.dart';
import '../../../menu/domain/entities/order.dart';
import '../controllers/kitchen_cubit.dart';
import '../controllers/kitchen_state.dart';
import '../widgets/order_card.dart';

class KitchenPage extends StatelessWidget {
  const KitchenPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<KitchenCubit>(
      create: (context) => sl<KitchenCubit>()..init(),
      child: const KitchenPageView(),
    );
  }
}

class KitchenPageView extends StatelessWidget {
  const KitchenPageView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Kitchen Display Panel',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.go('/admin'),
          tooltip: 'Back to Admin',
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: Colors.grey[200],
            height: 1.0,
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFFF8F0),
              Color(0xFFFAF0E6),
            ],
          ),
        ),
        child: BlocConsumer<KitchenCubit, KitchenState>(
          listener: (context, state) {
            if (state.errorMessage != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage!),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            final pendingOrders = state.orders
                .where((o) => o.status.toLowerCase() == 'pending')
                .toList();
            final preparingOrders = state.orders
                .where((o) => o.status.toLowerCase() == 'preparing')
                .toList();
            final readyOrders = state.orders
                .where((o) => o.status.toLowerCase() == 'ready')
                .toList();
            final completedOrders = state.orders
                .where((o) => o.status.toLowerCase() == 'completed')
                .toList();

            return LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth > 800) {
                  // Tablet / Desktop Board Layout
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: _buildOrderColumn(
                            context,
                            'Pending',
                            pendingOrders,
                            Colors.orange[800]!,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildOrderColumn(
                            context,
                            'Preparing',
                            preparingOrders,
                            Colors.blue[800]!,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildOrderColumn(
                            context,
                            'Ready',
                            readyOrders,
                            Colors.green[800]!,
                            extraOrders: completedOrders,
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  // Mobile Tabbed Layout
                  return DefaultTabController(
                    length: 3,
                    child: Column(
                      children: [
                        TabBar(
                          labelColor: theme.colorScheme.primary,
                          unselectedLabelColor: Colors.grey[600],
                          indicatorColor: theme.colorScheme.primary,
                          tabs: [
                            Tab(text: 'Pending (${pendingOrders.length})'),
                            Tab(text: 'Preparing (${preparingOrders.length})'),
                            Tab(text: 'Ready (${readyOrders.length})'),
                          ],
                        ),
                        Expanded(
                          child: TabBarView(
                            children: [
                              _buildMobileList(context, pendingOrders),
                              _buildMobileList(context, preparingOrders),
                              _buildMobileList(context, readyOrders, extraOrders: completedOrders),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildOrderColumn(
    BuildContext context,
    String title,
    List<Order> orders,
    Color color, {
    List<Order>? extraOrders,
  }) {
    final theme = Theme.of(context);
    final allOrders = [...orders];
    if (extraOrders != null) {
      allOrders.addAll(extraOrders);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: color.withAlpha(20),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withAlpha(40)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '${orders.length}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Expanded(
          child: allOrders.isEmpty
              ? Center(
                  child: Text(
                    'No orders in this status.',
                    style: TextStyle(color: Colors.grey[500]),
                  ),
                )
              : ListView.separated(
                  itemCount: allOrders.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final order = allOrders[index];
                    return SizedBox(
                      height: 240, // Fixed height to prevent overflow in column
                      child: OrderCard(
                        order: order,
                        onUpdateStatus: (newStatus) {
                          context.read<KitchenCubit>().updateStatus(order.id, newStatus);
                        },
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildMobileList(
    BuildContext context,
    List<Order> orders, {
    List<Order>? extraOrders,
  }) {
    final allOrders = [...orders];
    if (extraOrders != null) {
      allOrders.addAll(extraOrders);
    }

    if (allOrders.isEmpty) {
      return const Center(
        child: Text('No orders in this status.'),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: allOrders.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final order = allOrders[index];
        return SizedBox(
          height: 240,
          child: OrderCard(
            order: order,
            onUpdateStatus: (newStatus) {
              context.read<KitchenCubit>().updateStatus(order.id, newStatus);
            },
          ),
        );
      },
    );
  }
}
