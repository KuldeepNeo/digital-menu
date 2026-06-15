# Technical Design Document (Phase 2)

**Role:** Senior Architect  
**Project:** DigitalMenu  
**Version:** 2.0  
**Date:** 2026-06-15  

---

## 1. Enhancement Overview

This technical design details the implementation plan to extend **DigitalMenu** from a read-only menu display to an interactive customer ordering and admin kitchen fulfillment platform. The five key features in this enhancement scope are:
1. **Table-Number Ordering Flow:** Allows customers to specify their table number (input manually or parsed from a `/menu?table=X` query parameter), add items to a shopping cart, cache state locally across refreshes, validate table allocation, and submit order payloads.
2. **Kitchen Display incoming Orders Panel:** Provides a real-time chronological dashboard for kitchen staff to receive, track, and update order statuses from `pending` to `preparing`, `ready`, and `completed`.
3. **Daily Specials Banner:** Displays a promotional dish banner at the top of the menu that automatically expires and disappears at midnight server/client time.
4. **Dish Availability Toggle:** Gives managers the ability to toggle stock status. Out-of-stock items are automatically dimmed and disabled from customer ordering in real time.
5. **Customer Ratings Per Dish:** Features an interactive 1–5 star rating mechanism, calculating running averages and rating counts in a thread-safe Firestore Transaction.

---

## 2. Existing Architecture Analysis

The Phase 1 architecture relies on Clean Architecture split into modular feature directories (`features/menu` and `features/admin`).
* **Domain Layer:** Contains pure Dart entities and use cases with no external package imports.
* **Data Layer:** Maps Firestore documents to Dart models utilizing `freezed` and `json_serializable` packages, implementing repository interfaces.
* **Presentation Layer:** Uses the `Cubit` pattern to emit states to M3 widgets. Dependency Injection is managed via `GetIt` in [di.dart](file:///Users/neo/Desktop/Vibe%20Coding%20Training/vibe_projects/digital-menu/digital_menu/lib/core/di/di.dart).

### Reuse Strategy:
* **Real-time streams:** Extend the reactive collection snapshots paradigm already established in [menu_remote_datasource.dart](file:///Users/neo/Desktop/Vibe%20Coding%20Training/vibe_projects/digital-menu/digital_menu/lib/features/menu/data/datasources/menu_remote_datasource.dart) to stream orders from a new `orders` collection and specials from a `specials` collection.
* **Service Registry:** Register all new Cubits, Use Cases, and Repositories as lazy singletons/factories in [di.dart](file:///Users/neo/Desktop/Vibe%20Coding%20Training/vibe_projects/digital-menu/digital_menu/lib/core/di/di.dart).
* **Network Responses:** Wrap all new repository outputs in the pre-existing `CloudResult<T>` pattern.

---

## 3. Proposed Design

### A. Database (Firestore) Schema changes

#### 1. Modification to `dishes` collection documents:
```json
{
  "isAvailable": "boolean (default: true)",
  "ratingSum": "double (default: 0.0)",
  "totalRatings": "int (default: 0)",
  "averageRating": "double (default: 0.0)"
}
```

#### 2. Addition of `orders` collection schema:
```json
{
  "id": "String (auto-generated document ID)",
  "tableNumber": "String (validated table identifier)",
  "items": [
    {
      "dishId": "String",
      "name": "String",
      "price": "double",
      "quantity": "int"
    }
  ],
  "totalPrice": "double (aggregate of price * quantity)",
  "status": "String (pending | preparing | ready | completed)",
  "createdAt": "int (milliseconds since epoch timestamp)"
}
```

#### 3. Addition of `specials` collection schema:
A single document `daily` located at `/specials/daily`:
```json
{
  "dishId": "String (linked dish ID)",
  "promoText": "String (promotional caption)",
  "expiresAt": "int (midnight epoch milliseconds)"
}
```

#### 4. Addition of Ratings subcollection:
Subcollection path: `/dishes/{dishId}/ratings/{ratingId}`:
```json
{
  "rating": "int (1-5)",
  "sessionId": "String (anonymous session token)",
  "createdAt": "int (milliseconds since epoch)"
}
```

---

### B. API & Repository Methods Signatures

#### 1. Order Repository Updates:
```dart
abstract class OrderRepository {
  Future<CloudResult<void>> submitOrder(Order order);
  Stream<List<Order>> streamActiveOrders();
  Future<CloudResult<void>> updateOrderStatus(String orderId, String status);
}
```

#### 2. Menu Repository Updates (Ratings & Specials):
```dart
abstract class MenuRepository {
  // Existing methods...
  Future<CloudResult<void>> submitDishRating(String dishId, int rating, String sessionId);
  Stream<DailySpecial?> streamDailySpecial();
  Future<CloudResult<void>> setDailySpecial(String dishId, String promoText, int expiresAt);
}
```

---

### C. UI/UX & Layout Changes

* **Customer Menu Header (`menu_page.dart`):**
  * Integrate a **Table Selection Bar** at the top of the categories slider. Clicking opens a simple sheet to enter or select a table number.
  * Extract table numbers from query parameters when routing: `/#/menu?table=4`.
* **Dish Card Overlay (`dish_card.dart`):**
  * **Out-of-Stock Overlay:** If `isAvailable == false`, apply opacity mask (`0.6`) with a diagonally aligned **"OUT OF STOCK"** badge. Disable interaction.
  * **Ratings Display:** Below the dish name, render average rating stars (`★ 4.5 (12)`). Clicking the rating area opens the **Rating Dialog**.
  * **Add to Cart Interaction:** Bottom-right corner gains an "Add" button which expands into a responsive `[-] 1 [+]` quantity editor when selected.
* **Floating Cart Bar & Cart Sheet:**
  * Add a sticky bottom banner indicating `X items | Total: ₹Y`. Tapping opens a slide-up panel containing: item lines, quantities adjusters, table selector, and a prominent checkout button.
* **Daily Specials Banner:**
  * Display a sliding banner at the very top of `MenuPage` featuring the promo text, linked dish picture, and an anchor button to scroll directly to the category containing the promoted dish.
* **Kitchen Panel Dashboard (`kitchen_page.dart`):**
  * Provide a grid of **Order Cards**. Each card displays the table number, elapsed timer (time since creation), item list, and context buttons: `Mark Preparing` (if status is pending) and `Mark Ready` (if status is preparing).

---

## 4. Files to Modify

The following existing files will be modified to support Phase 2:

1. **[constants.dart](file:///Users/neo/Desktop/Vibe%20Coding%20Training/vibe_projects/digital-menu/digital_menu/lib/core/constants/constants.dart):** Define Firestore collection names `orders` and `specials`.
2. **[di.dart](file:///Users/neo/Desktop/Vibe%20Coding%20Training/vibe_projects/digital-menu/digital_menu/lib/core/di/di.dart):** Register new use cases, repositories, and BLoC cubits.
3. **[router.dart](file:///Users/neo/Desktop/Vibe%20Coding%20Training/vibe_projects/digital-menu/digital_menu/lib/core/router/router.dart):** Define the `/admin/kitchen` route and ensure it is covered under the GoRouter Auth Guard redirect. Support table parameters in the `/menu` route.
4. **[dish.dart](file:///Users/neo/Desktop/Vibe%20Coding%20Training/vibe_projects/digital-menu/digital_menu/lib/features/menu/domain/entities/dish.dart):** Update entity to hold `isAvailable`, `ratingSum`, `totalRatings`, and `averageRating`.
5. **[dish_model.dart](file:///Users/neo/Desktop/Vibe%20Coding%20Training/vibe_projects/digital-menu/digital_menu/lib/features/menu/data/models/dish_model.dart):** Update model definitions to map the new parameters, setting safe defaults (`isAvailable = true`, `averageRating = 0.0`).
6. **[menu_repository_impl.dart](file:///Users/neo/Desktop/Vibe%20Coding%20Training/vibe_projects/digital-menu/digital_menu/lib/features/menu/data/repositories/menu_repository_impl.dart):** Add rating submissions (with transaction logic) and specials management.
7. **[menu_remote_datasource.dart](file:///Users/neo/Desktop/Vibe%20Coding%20Training/vibe_projects/digital-menu/digital_menu/lib/features/menu/data/datasources/menu_remote_datasource.dart):** Provide data handlers for ratings, stock toggles, and daily special snapshots.
8. **[dish_card.dart](file:///Users/neo/Desktop/Vibe%20Coding%20Training/vibe_projects/digital-menu/digital_menu/lib/features/menu/presentation/widgets/dish_card.dart):** Add cart buttons, out-of-stock styles, and rating displays.
9. **[menu_page.dart](file:///Users/neo/Desktop/Vibe%20Coding%20Training/vibe_projects/digital-menu/digital_menu/lib/features/menu/presentation/pages/menu_page.dart):** Add the daily specials banner, table selections UI, and cart sheets.
10. **[admin_dish_card.dart](file:///Users/neo/Desktop/Vibe%20Coding%20Training/vibe_projects/digital-menu/digital_menu/lib/features/admin/presentation/widgets/admin_dish_card.dart):** Add a Switch component linking to stock status updates.
11. **[admin_page.dart](file:///Users/neo/Desktop/Vibe%20Coding%20Training/vibe_projects/digital-menu/digital_menu/lib/features/admin/presentation/pages/admin_page.dart):** Add actions to configure daily specials and navigations to the Kitchen Display.

---

## 5. New Files Required

Create the following files under the respective layers:

### A. Domain Layer
* **`lib/features/menu/domain/entities/order.dart` & `order_item.dart`:** Defines ordering entity records.
* **`lib/features/menu/domain/repositories/order_repository.dart`:** Interface for order submissions.
* **`lib/features/menu/domain/entities/daily_special.dart`:** Defines the special banner entity.
* **Use Cases:**
  * `lib/features/menu/domain/usecases/submit_order_usecase.dart`
  * `lib/features/menu/domain/usecases/submit_dish_rating_usecase.dart`
  * `lib/features/menu/domain/usecases/get_active_special_usecase.dart`
  * `lib/features/admin/domain/usecases/stream_active_orders_usecase.dart`
  * `lib/features/admin/domain/usecases/update_order_status_usecase.dart`
  * `lib/features/admin/domain/usecases/set_daily_special_usecase.dart`

### B. Data Layer
* **`lib/features/menu/data/models/order_model.dart` & `order_item_model.dart`:** Freezed models.
* **`lib/features/menu/data/models/daily_special_model.dart`:** Freezed special models.
* **`lib/features/menu/data/datasources/order_remote_datasource.dart`:** Reads/writes order streams.
* **`lib/features/menu/data/repositories/order_repository_impl.dart`:** Concrete order data operations.

### C. Presentation Layer
* **`lib/features/menu/presentation/bloc/cart_cubit.dart` & `cart_state.dart`:** State managers for the client cart.
* **`lib/features/admin/presentation/controllers/kitchen_cubit.dart` & `kitchen_state.dart`:** Streams active orders.
* **Widgets & Pages:**
  * `lib/features/menu/presentation/widgets/cart_sheet.dart`: Shopping cart UI drawer.
  * `lib/features/menu/presentation/widgets/rating_dialog.dart`: Star ratings submission sheet.
  * `lib/features/menu/presentation/widgets/daily_specials_banner.dart`: Promotional banner.
  * `lib/features/admin/presentation/pages/kitchen_page.dart`: Kitchen display screen.
  * `lib/features/admin/presentation/widgets/order_card.dart`: Individual order panels.
  * `lib/features/admin/presentation/widgets/set_special_dialog.dart`: Daily specials setup panel.

---

## 6. Dependencies

To adhere to the project boundaries, **no additional external pub packages are added**. We utilize the current stable library integrations:
* **GoRouter 14.x:** Handles routing parameters natively.
* **HTML Platform Bindings (`dart:html` / `universal_html`):** Used to perform local storage persistence on web.
* **Flutter Material 3 icons and widgets:** Handles rating stars rendering, sheets, and switches natively.

---

## 7. Validation Strategy

* **Form and Field Valuations:**
  * Prevent rating submissions outside of $[1, 5]$.
  * Prevent checkout order submissions if `tableNumber` is empty. Emits a localized snackbar error message.
  * Prevent adding out-of-stock items via disabled states at the card boundary.
* **Unit Testing Coverage:**
  * **`CartCubit` test suite:** Assert adding items correctly persists state into local storage. Validate that empty table checkout triggers an error state.
  * **Ratings Transaction logic:** Assert that submitting a rating executes the arithmetic average algorithm correctly.
* **Integration Testing Coverage:**
  * Mock a complete end-to-end user stream: Load menu with table parameter ➔ verify layout ➔ place order ➔ verify order collection triggers stream updates on kitchen panel page ➔ update order status ➔ confirm database state transition.

---

## 8. Implementation Sequence

We execute the implementation strictly according to this chronological sequence to guarantee compile-time stability:

1. **Step 1: DB Schemes & Models updates**
   * Edit `dish.dart` and `dish_model.dart`. Create `order.dart`, `order_item.dart`, `daily_special.dart` and their respective models.
   * Run build generation: `dart run build_runner build --delete-conflicting-outputs`.
2. **Step 2: Setup Remote Data Sources & Repositories**
   * Implement `OrderRemoteDataSourceImpl` and `OrderRepositoryImpl`.
   * Add transactions logic in `MenuRepositoryImpl` for ratings and specials management.
   * Update DI references in `di.dart`.
3. **Step 3: Cart Logic & Menu UI Changes**
   * Create `CartCubit` handling local storage operations.
   * Modify `dish_card.dart` to support out-of-stock displays, cart buttons, and stars ratings.
   * Modify `menu_page.dart` to present floating cart bars, sheets, and table selections.
4. **Step 4: Kitchen Dashboard & Order Flow**
   * Implement `KitchenCubit` and use cases.
   * Build `KitchenPage` and `OrderCard`. 
   * Wire route details in `router.dart` and update `admin_page.dart` navigation headers.
5. **Step 5: Ratings Dialog & Daily Specials**
   * Build `RatingDialog` and integration buttons.
   * Create `SetSpecialDialog` on `admin_page.dart`.
   * Build `DailySpecialsBanner` on `menu_page.dart`.
6. **Step 6: Execute Quality Tests**
   * Build test suites matching KPIs 46–50 and verify everything runs correctly.
