# Sprint 2 Implementation Summary: Table-Number & Shopping Cart Flow

**Feature Group:** Table Identification & Cart Flow Management  
**Status:** Completed & Ready for QA Testing  
**Date:** 2026-06-15  

---

## 1. Overview of Changes

Sprint 2 implements the table-number identification and cart checkout flow, allowing café customers to specify their table number (manually or dynamically via query parameters), build a shopping cart, persist their selections across browser reloads via `localStorage`, and checkout/submit orders directly to Firestore.

### Domain Layer
* **[order_item.dart](file:///Users/neo/Desktop/Vibe%20Coding%20Training/vibe_projects/digital-menu/digital_menu/lib/features/menu/domain/entities/order_item.dart):** Introduced `OrderItem` entity to represent dishes selected in the cart.
* **[order.dart](file:///Users/neo/Desktop/Vibe%20Coding%20Training/vibe_projects/digital-menu/digital_menu/lib/features/menu/domain/entities/order.dart):** Introduced `Order` entity containing the items, table number, total price, status, and creation timestamp.
* **[order_repository.dart](file:///Users/neo/Desktop/Vibe%20Coding%20Training/vibe_projects/digital-menu/digital_menu/lib/features/menu/domain/repositories/order_repository.dart):** Defined the repository interface with the `submitOrder` method.
* **[submit_order_usecase.dart](file:///Users/neo/Desktop/Vibe%20Coding%20Training/vibe_projects/digital-menu/digital_menu/lib/features/menu/domain/usecases/submit_order_usecase.dart):** Created the usecase for submitting an order.

### Data Layer
* **[order_item_model.dart](file:///Users/neo/Desktop/Vibe%20Coding%20Training/vibe_projects/digital-menu/digital_menu/lib/features/menu/data/models/order_item_model.dart) & [order_model.dart](file:///Users/neo/Desktop/Vibe%20Coding%20Training/vibe_projects/digital-menu/digital_menu/lib/features/menu/data/models/order_model.dart):** Defined Freezed/JSON models to serialize and deserialize order data.
* **[order_remote_datasource.dart](file:///Users/neo/Desktop/Vibe%20Coding%20Training/vibe_projects/digital-menu/digital_menu/lib/features/menu/data/datasources/order_remote_datasource.dart):** Created Firebase remote datasource that pushes orders to `/orders` Firestore collection under the `pending` status.
* **[order_repository_impl.dart](file:///Users/neo/Desktop/Vibe%20Coding%20Training/vibe_projects/digital-menu/digital_menu/lib/features/menu/data/repositories/order_repository_impl.dart):** Concrete repository implementation.
* **Code Generation:** Re-ran `build_runner` to build code for new Freezed models (`order_model`, `order_item_model`, and `cart_state`).

### Presentation Layer & State Management
* **[cart_state.dart](file:///Users/neo/Desktop/Vibe%20Coding%20Training/vibe_projects/digital-menu/digital_menu/lib/features/menu/presentation/bloc/cart_state.dart):** Defined the immutable UI state using Freezed.
* **[cart_cubit.dart](file:///Users/neo/Desktop/Vibe%20Coding%20Training/vibe_projects/digital-menu/digital_menu/lib/features/menu/presentation/bloc/cart_cubit.dart):** Implemented the Cart BLoC controller, supporting operations like add, remove, change table, load, persist, and submit orders.
* **Conditional Web Storage Helper:**
  * **[storage_helper.dart](file:///Users/neo/Desktop/Vibe%20Coding%20Training/vibe_projects/digital-menu/digital_menu/lib/core/utils/storage_helper.dart):** Interface exporting conditional implementations.
  * **[storage_helper_stub.dart](file:///Users/neo/Desktop/Vibe%20Coding%20Training/vibe_projects/digital-menu/digital_menu/lib/core/utils/storage_helper_stub.dart):** Non-web VM fallback stub.
  * **[storage_helper_web.dart](file:///Users/neo/Desktop/Vibe%20Coding%20Training/vibe_projects/digital-menu/digital_menu/lib/core/utils/storage_helper_web.dart):** Browser local storage implementation with static-analyzer ignores to keep the code warning-free.
* **UI Updates:**
  * **[router.dart](file:///Users/neo/Desktop/Vibe%20Coding%20Training/vibe_projects/digital-menu/digital_menu/lib/core/router/router.dart):** Enhanced `GoRouter` route definition for the menu page to read the `?table=X` query parameter.
  * **[menu_page.dart](file:///Users/neo/Desktop/Vibe%20Coding%20Training/vibe_projects/digital-menu/digital_menu/lib/features/menu/presentation/pages/menu_page.dart):** Added the interactive header for table number input/selection, integrated `CartCubit`, and built a sticky bottom floating cart bar.
  * **[dish_card.dart](file:///Users/neo/Desktop/Vibe%20Coding%20Training/vibe_projects/digital-menu/digital_menu/lib/features/menu/presentation/widgets/dish_card.dart):** Updated to display quantity increment/decrement controls instead of a simple card when items are added to the cart.
  * **[cart_sheet.dart](file:///Users/neo/Desktop/Vibe%20Coding%20Training/vibe_projects/digital-menu/digital_menu/lib/features/menu/presentation/widgets/cart_sheet.dart):** Created the slide-up modal bottom sheet showing cart items, total price, table number validation, and Checkout triggers.

### Dependency Injection
* **[di.dart](file:///Users/neo/Desktop/Vibe%20Coding%20Training/vibe_projects/digital-menu/digital_menu/lib/core/di/di.dart):** Registered the new Remote DataSource, Repository, Usecase, and CartCubit with GetIt.

---

## 2. QA & Test Verification Results

### Automated Unit Testing
* **New Tests added in [cart_cubit_test.dart](file:///Users/neo/Desktop/Vibe%20Coding%20Training/vibe_projects/digital-menu/digital_menu/test/features/menu/presentation/bloc/cart_cubit_test.dart):**
  * Verified add/remove dish cart logic.
  * Verified table number setting logic.
  * Verified order submission validations (e.g., empty cart error, missing table number error).
  * Tested state emissions during successful checkout and failures.
* **Execution Status:** 
  * Run command: `flutter test`
  * Result: **All tests passed!**

### Static Code Analysis
* Run command: `flutter analyze`
* Result: **No issues found!**
