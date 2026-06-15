# Sprint 3 Implementation Plan: Kitchen Display Panel

Create a real-time, responsive chronological dashboard for kitchen staff to receive, track, and advance order statuses from `pending` ➔ `preparing` ➔ `ready` ➔ `completed`.

## User Review Required

> [!IMPORTANT]
> * The `/admin/kitchen` route will be registered in `GoRouter` under the same authentication guards protecting `/admin`.
> * The panel will stream active orders from the `/orders` Firestore collection in real-time.
> * A running duration timer will render dynamically on each order card to show elapsed minutes/seconds since the order was placed.

## Proposed Changes

### Core / Domain Layer

#### [MODIFY] [order_repository.dart](file:///Users/neo/Desktop/Vibe%20Coding%20Training/vibe_projects/digital-menu/digital_menu/lib/features/menu/domain/repositories/order_repository.dart)
* Add `Stream<List<Order>> streamActiveOrders();`
* Add `Future<CloudResult<void>> updateOrderStatus(String orderId, String status);`

#### [NEW] [stream_orders_usecase.dart](file:///Users/neo/Desktop/Vibe%20Coding%20Training/vibe_projects/digital-menu/digital_menu/lib/features/menu/domain/usecases/stream_orders_usecase.dart)
* Call `OrderRepository.streamActiveOrders()`.

#### [NEW] [update_order_status_usecase.dart](file:///Users/neo/Desktop/Vibe%20Coding%20Training/vibe_projects/digital-menu/digital_menu/lib/features/menu/domain/usecases/update_order_status_usecase.dart)
* Call `OrderRepository.updateOrderStatus(orderId, status)`.

### Data Layer

#### [MODIFY] [order_remote_datasource.dart](file:///Users/neo/Desktop/Vibe%20Coding%20Training/vibe_projects/digital-menu/digital_menu/lib/features/menu/data/datasources/order_remote_datasource.dart)
* Implement `Stream<List<OrderModel>> streamActiveOrders();` reading from Firestore and ordered by `createdAt` descending.
* Implement `Future<void> updateOrderStatus(String orderId, String status);` updating the `status` field.

#### [MODIFY] [order_repository_impl.dart](file:///Users/neo/Desktop/Vibe%20Coding%20Training/vibe_projects/digital-menu/digital_menu/lib/features/menu/data/repositories/order_repository_impl.dart)
* Implement the new repository methods mapped from remote datasource.

#### [MODIFY] [di.dart](file:///Users/neo/Desktop/Vibe%20Coding%20Training/vibe_projects/digital-menu/digital_menu/lib/core/di/di.dart)
* Register `StreamOrdersUseCase`, `UpdateOrderStatusUseCase`, and `KitchenCubit`.

### Presentation Layer

#### [NEW] [kitchen_state.dart](file:///Users/neo/Desktop/Vibe%20Coding%20Training/vibe_projects/digital-menu/digital_menu/lib/features/admin/presentation/controllers/kitchen_state.dart)
* Freezed state model for the kitchen display including: `isLoading`, `orders` (List of Order), and `errorMessage`.

#### [NEW] [kitchen_cubit.dart](file:///Users/neo/Desktop/Vibe%20Coding%20Training/vibe_projects/digital-menu/digital_menu/lib/features/admin/presentation/controllers/kitchen_cubit.dart)
* BLoC controller streaming active orders, handling status transitions, and handling search or status filters if needed.

#### [NEW] [kitchen_page.dart](file:///Users/neo/Desktop/Vibe%20Coding%20Training/vibe_projects/digital-menu/digital_menu/lib/features/admin/presentation/pages/kitchen_page.dart)
* Responsive dashboard displaying columns or categorized grids of orders by status (`pending`, `preparing`, `ready`). Includes responsive grids for tablet/desktop viewports.

#### [NEW] [order_card.dart](file:///Users/neo/Desktop/Vibe%20Coding%20Training/vibe_projects/digital-menu/digital_menu/lib/features/admin/presentation/widgets/order_card.dart)
* Card layout displaying order details: table number, items with quantities, timestamp, running duration counter, and state-advancement buttons.

#### [MODIFY] [router.dart](file:///Users/neo/Desktop/Vibe%20Coding%20Training/vibe_projects/digital-menu/digital_menu/lib/core/router/router.dart)
* Add `/admin/kitchen` route mapped to `KitchenPage`.

#### [MODIFY] [admin_page.dart](file:///Users/neo/Desktop/Vibe%20Coding%20Training/vibe_projects/digital-menu/digital_menu/lib/features/admin/presentation/pages/admin_page.dart)
* Add a navigation button in the Admin Dashboard AppBar or header to open the Kitchen Display Panel.

### Testing Updates

#### [NEW] [kitchen_cubit_test.dart](file:///Users/neo/Desktop/Vibe%20Coding%20Training/vibe_projects/digital-menu/digital_menu/test/features/admin/presentation/controllers/kitchen_cubit_test.dart)
* Unit tests verifying that `KitchenCubit` listens to orders, filters correctly, handles updates, and transitions state cleanly.

---

## Verification Plan

### Automated Tests
* Run `flutter test test/features/admin/presentation/controllers/kitchen_cubit_test.dart` to verify logic.
* Run `flutter analyze` to ensure code is clean of static warnings.

### Manual Verification
* Run local Chrome browser: `flutter run -d chrome`.
* Log in as admin, verify a link/button to the Kitchen Display Panel is visible.
* Open two windows: one with the customer menu, one with `/admin/kitchen`.
* Place an order from the menu page. Verify that it instantly displays on the kitchen page without page refresh.
* Interact with status advancement buttons ("Start Preparing", "Ready", etc.) and confirm real-time updates and database storage sync.
