# Sprint 2 Implementation Plan: Table-Number & Shopping Cart Flow

Enable customers dining at the café to specify their table number, build a shopping cart, and submit orders directly to Firestore.

## User Review Required

> [!IMPORTANT]
> * Custom LocalStorage platform code is implemented in `CartCubit` via conditional platform guards (only running on Web) to ensure compatibility with `shared_preferences`-free requirements.
> * A new Firestore collection named `orders` is introduced.

## Proposed Changes

### Core / Domain Layer

#### [NEW] [order.dart](file:///Users/neo/Desktop/Vibe%20Coding%20Training/vibe_projects/digital-menu/digital_menu/lib/features/menu/domain/entities/order.dart)
* Define `Order` entity containing: `id`, `tableNumber`, `items` (List), `totalPrice`, `status`, `createdAt`.

#### [NEW] [order_item.dart](file:///Users/neo/Desktop/Vibe%20Coding%20Training/vibe_projects/digital-menu/digital_menu/lib/features/menu/domain/entities/order_item.dart)
* Define `OrderItem` entity containing: `dishId`, `name`, `price`, `quantity`.

#### [NEW] [order_repository.dart](file:///Users/neo/Desktop/Vibe%20Coding%20Training/vibe_projects/digital-menu/digital_menu/lib/features/menu/domain/repositories/order_repository.dart)
* Define `OrderRepository` interface containing `submitOrder`.

#### [NEW] [submit_order_usecase.dart](file:///Users/neo/Desktop/Vibe%20Coding%20Training/vibe_projects/digital-menu/digital_menu/lib/features/menu/domain/usecases/submit_order_usecase.dart)
* Define `SubmitOrderUseCase` to execute repository calls.

### Data Layer

#### [NEW] [order_model.dart](file:///Users/neo/Desktop/Vibe%20Coding%20Training/vibe_projects/digital-menu/digital_menu/lib/features/menu/data/models/order_model.dart)
* Freezed model mapping `Order` to Firestore database fields.

#### [NEW] [order_item_model.dart](file:///Users/neo/Desktop/Vibe%20Coding%20Training/vibe_projects/digital-menu/digital_menu/lib/features/menu/data/models/order_item_model.dart)
* Freezed model mapping `OrderItem`.

#### [NEW] [order_remote_datasource.dart](file:///Users/neo/Desktop/Vibe%20Coding%20Training/vibe_projects/digital-menu/digital_menu/lib/features/menu/data/datasources/order_remote_datasource.dart)
* Concrete Firestore queries to write documents to `/orders`.

#### [NEW] [order_repository_impl.dart](file:///Users/neo/Desktop/Vibe%20Coding%20Training/vibe_projects/digital-menu/digital_menu/lib/features/menu/data/repositories/order_repository_impl.dart)
* Implementation of `OrderRepository`.

#### [MODIFY] [constants.dart](file:///Users/neo/Desktop/Vibe%20Coding%20Training/vibe_projects/digital-menu/digital_menu/lib/core/constants/constants.dart)
* Register `orders` collection name constant.

#### [MODIFY] [di.dart](file:///Users/neo/Desktop/Vibe%20Coding%20Training/vibe_projects/digital-menu/digital_menu/lib/core/di/di.dart)
* Register new Order dependencies and `CartCubit`.

### Presentation Layer

#### [NEW] [cart_cubit.dart](file:///Users/neo/Desktop/Vibe%20Coding%20Training/vibe_projects/digital-menu/digital_menu/lib/features/menu/presentation/bloc/cart_cubit.dart) & `cart_state.dart`
* Cubit controller for tracking cart items and table selections, persisting contents to browser storage.

#### [NEW] [cart_sheet.dart](file:///Users/neo/Desktop/Vibe%20Coding%20Training/vibe_projects/digital-menu/digital_menu/lib/features/menu/presentation/widgets/cart_sheet.dart)
* Slide-up sheet showing cart items, quantity selectors, table inputs, and the "Checkout" submission button.

#### [MODIFY] [router.dart](file:///Users/neo/Desktop/Vibe%20Coding%20Training/vibe_projects/digital-menu/digital_menu/lib/core/router/router.dart)
* Add support for checking query parameters (`?table=X`) to lock table numbers in the cart.

#### [MODIFY] [dish_card.dart](file:///Users/neo/Desktop/Vibe%20Coding%20Training/vibe_projects/digital-menu/digital_menu/lib/features/menu/presentation/widgets/dish_card.dart)
* Embed a quantity selector widget (`[-] Qty [+]`) replacing the simple display card.

#### [MODIFY] [menu_page.dart](file:///Users/neo/Desktop/Vibe%20Coding%20Training/vibe_projects/digital-menu/digital_menu/lib/features/menu/presentation/pages/menu_page.dart)
* Inject `CartCubit`, include a persistent **Table Selector Bar** and the bottom **Floating Cart Bar**.

### Testing Updates

#### [NEW] [cart_cubit_test.dart](file:///Users/neo/Desktop/Vibe%20Coding%20Training/vibe_projects/digital-menu/digital_menu/test/features/menu/presentation/bloc/cart_cubit_test.dart)
* Unit tests verifying cart operations, validations, and storage operations.

---

## Verification Plan

### Automated Tests
* Run `flutter test test/features/menu/presentation/bloc/cart_cubit_test.dart` to verify logic.
* Run code generation: `dart run build_runner build --delete-conflicting-outputs`.

### Manual Verification
* Run local Chrome browser: `flutter run -d chrome`.
* Navigate to `/#/menu?table=4`. Confirm table 4 is locked.
* Add items, verify bottom bar count and total price matches catalog.
* Force browser refresh, assert cart and table selection persist.
* Click checkout, confirm order appears correctly in Firestore.
