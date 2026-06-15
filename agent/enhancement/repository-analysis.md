# Repository Analysis & Architecture Assessment (Phase 2 Enhancements)

**Role:** Senior Architect  
**Project:** DigitalMenu  
**Version:** 2.0 (Planning & Analysis)  
**Date:** 2026-06-15  

---

## 1. Executive Summary

This document details the architectural assessment and repository analysis for the Phase 2 enhancements of the **DigitalMenu** project. The core objective is to transition from a static, read-only menu app into an interactive, real-time ordering platform. 

The primary architectural guidelines adhered to in this design are:
1. **Clean Architecture Adherence:** Strict separation between the Domain (Entities, Use Cases), Data (Models, Repositories, Data Sources), and Presentation (Widgets, Cubits) layers.
2. **Material 3 Aesthetics:** Seamlessly integrate new features into the existing warm **Coffee Brown** palette (`#FFF8F0` / `#FAF0E6` background, rich brown primary accents, and subtle micro-animations).
3. **No Code Duplication:** Re-use existing BLoC/Cubit infrastructure and model serialization techniques where possible, introducing modular sub-packages where needed.
4. **Stability and Performance:** Leverage Firestore's real-time stream capabilities to push state updates without polling, keeping Base64 image payload sizes minimal (< 600 KB per item).

---

## 2. Architecture & Design Alignment

The codebase's existing modularized structures for `menu` and `admin` features will be extended. Since Phase 2 introduces transactional logic (Orders, Cart, and Ratings), we will introduce a cohesive structure:
- **`features/menu` expansion:** Encompasses menu item attributes (out-of-stock, ratings), shopping cart caching, and order placement.
- **`features/admin` expansion:** Incorporates the kitchen dashboard stream and status modification widgets.

### Clean Architecture Components Map

```mermaid
graph TD
    subgraph Presentation Layer
        MP[MenuPage] --> MC[MenuCubit]
        MP --> CC[CartCubit]
        AD[AdminPage] --> AC[AdminDishCubit]
        KP[KitchenPage] --> KC[KitchenCubit]
    end

    subgraph Domain Layer (Business Logic)
        MC --> GC[GetCategoriesUseCase]
        MC --> GD[GetDishesByCategoryUseCase]
        CC --> SO[SubmitOrderUseCase]
        KC --> SA[StreamActiveOrdersUseCase]
        KC --> UO[UpdateOrderStatusUseCase]
    end

    subgraph Data Layer (Repositories & Sources)
        SO --> OR[OrderRepositoryImpl]
        SA --> OR
        UO --> OR
        OR --> ODS[OrderRemoteDataSourceImpl]
        ODS --> FS[(Firebase Firestore)]
    end
```

---

## 3. Detailed Feature Breakdown & Database Changes

### Feature A: Table-Number Ordering Flow (Add to Order)
* **Objective:** Customers dining in the restaurant associate their order with a table number. The cart state must remain persistent across browser refreshes and be validated before checkout.
* **Architecture Mapping:**
  * **Domain Layer:** 
    * Create `OrderItem` (Entity) containing: `dishId`, `name`, `price`, `quantity`.
    * Create `Order` (Entity) containing: `id`, `tableNumber`, `items` (List), `totalPrice`, `status`, `createdAt`.
    * Create `SubmitOrderUseCase` (executes repository write).
  * **Data Layer:**
    * Create `OrderItemModel` and `OrderModel` using Freezed/JSON serializers.
    * Implement `OrderRemoteDataSourceImpl` & `OrderRepositoryImpl` in `features/menu/data`.
  * **Presentation Layer:**
    * Create `CartCubit` & `CartState` to manage items, quantities, and table numbers.
    * Add custom UI overlays: A persistent **Floating Cart Bar** and a slide-up **Cart Details Sheet**.
* **Session Persistence Strategy:**
  * To satisfy the page refresh requirement without bringing in extra pub dependencies, the `CartCubit` will read/write the table number and JSON-serialized cart list to **`html.window.localStorage`** on state changes (wrapped in a conditional platform guard for web execution).
* **URL Routing Integration:**
  * Configure `GoRouter` in [router.dart](file:///Users/neo/Desktop/Vibe%20Coding%20Training/vibe_projects/digital-menu/digital_menu/lib/core/router/router.dart) to capture a table parameter (e.g., `/menu?table=5`). The `MenuPage` parses this parameter and auto-selects the table number in `CartCubit`.

---

### Feature B: Kitchen Display – Incoming Orders Panel
* **Objective:** Real-time chronological dashboard (newest first) for staff to track and advance order statuses (`pending` ➔ `preparing` ➔ `ready` ➔ `completed`).
* **Architecture Mapping:**
  * **Domain Layer:**
    * Create `StreamActiveOrdersUseCase` to subscribe to unfinished orders.
    * Create `UpdateOrderStatusUseCase` to advance order state.
  * **Data Layer:**
    * Expose real-time query stream `.snapshots()` on the `orders` collection.
  * **Presentation Layer:**
    * Create `KitchenCubit` & `KitchenState` that streams active orders.
    * Create `KitchenPage` (route `/admin/kitchen` protected by auth).
    * Create `OrderCard` (visualizes individual order list, timestamp, elapsed time, and state action buttons).
* **Responsive Visual Cues:**
  * Design a multi-column responsive grid (Desktop/Tablet) using a wrap/flexbox model.
  * Color-code states: **Coffee Cream** for `pending`, **Amber Brown** for `preparing`, and **Vibrant Ochre** for `ready`.

---

### Feature C: Daily Specials Banner (Auto-Expires at Midnight)
* **Objective:** Admin sets an item as a promotional special with banner text. The client-side menu queries and displays it dynamically, hiding it instantly at midnight without polling.
* **Database Schema:**
  * Introduce a new Firestore collection `specials` with a single document `daily`:
    ```json
    {
      "dishId": "String (linked dish Firestore doc ID)",
      "promoText": "String (promotional banner message)",
      "expiresAt": "Int (epoch timestamp in ms corresponding to 11:59:59 PM of the set day)"
    }
    ```
* **Architecture Mapping:**
  * **Domain Layer:** 
    * Create `DailySpecial` (Entity).
    * Create `GetActiveSpecialUseCase` and `SetDailySpecialUseCase`.
  * **Presentation Layer:**
    * Create `DailySpecialsBanner` (Widget).
    * Hook the stream listener into `MenuCubit` or a distinct `SpecialCubit`.
* **Automatic Expiration Logic:**
  * The stream queries the active special filtering by:
    `firestore.collection('specials').where('expiresAt', '>', DateTime.now().millisecondsSinceEpoch)`
  * When midnight passes, a client-side stream update is triggered implicitly (since the local time surpasses `expiresAt`), or on the next database check. The UI automatically collapses the banner when the stream returns empty.

---

### Feature D: Dish Availability Toggle (Out of Stock)
* **Objective:** Enable kitchen managers to instantly flag dishes as "out of stock". This visual indicator disables add-to-cart operations instantly on active customer sessions.
* **Database Schema:**
  * Update the `dishes` schema to contain a boolean field:
    * `isAvailable` (boolean, defaults to `true`).
* **Architecture Mapping:**
  * **Domain & Data Layers:**
    * Update [dish.dart](file:///Users/neo/Desktop/Vibe%20Coding%20Training/vibe_projects/digital-menu/digital_menu/lib/features/menu/domain/entities/dish.dart) and [dish_model.dart](file:///Users/neo/Desktop/Vibe%20Coding%20Training/vibe_projects/digital-menu/digital_menu/lib/features/menu/data/models/dish_model.dart) to parse `isAvailable`.
  * **Presentation Layer:**
    * **Customer Side:** Modify [dish_card.dart](file:///Users/neo/Desktop/Vibe%20Coding%20Training/vibe_projects/digital-menu/digital_menu/lib/features/menu/presentation/widgets/dish_card.dart). If `isAvailable` is `false`, overlay a translucent grey mask (opacity `0.6`), add an "Out of Stock" banner badge, and replace the Add button with a disabled indicator.
    * **Admin Side:** Modify [admin_dish_card.dart](file:///Users/neo/Desktop/Vibe%20Coding%20Training/vibe_projects/digital-menu/digital_menu/lib/features/admin/presentation/widgets/admin_dish_card.dart) to place a Switch/Toggle input. Toggling triggers `AdminDishCubit.updateDishAvailability()`.

---

### Feature E: Customer Ratings Per Dish (1–5 Stars)
* **Objective:** Interactive rating component allowing customers to submit a score once per session. Display average scores and count on dish cards.
* **Database Schema:**
  * To avoid loading all sub-documents to calculate the average on every menu fetch, we will store running aggregations directly in the `dishes` documents:
    * `ratingSum`: Double (defaults to `0.0`)
    * `totalRatings`: Int (defaults to `0`)
    * `averageRating`: Double (calculated client/server side, defaults to `0.0`)
  * Add a subcollection `/dishes/{dishId}/ratings/{ratingId}` containing: `{ rating: Int, sessionId: String, createdAt: Int }` for auditability and verification.
* **Architecture Mapping:**
  * **Domain Layer:** Create `SubmitRatingUseCase`.
  * **Data Layer:** Implement submission using a **Firestore Transaction** in `MenuRepositoryImpl` to guarantee thread-safe incrementation of rating sums and totals:
    ```dart
    // Read current dish -> calculate new average -> write back values atomically
    ```
  * **Presentation Layer:**
    * Create a custom `StarRatingBar` (Interactive stars 1-5).
    * Add duplicate rating check: Store rated dish IDs in local session storage and hide/disable rating interactions for those dishes once rating is logged.

---

## 4. Firestore Collections Schema Summary (Phase 2)

| Collection | Path / Document | New Fields | Type | Default Value | Role / Purpose |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **dishes** | `/dishes/{id}` | `isAvailable` | Boolean | `true` | Indicates if customers can order this dish |
| | | `ratingSum` | Double | `0.0` | Accumulated rating points |
| | | `totalRatings` | Integer | `0` | Count of total ratings submitted |
| | | `averageRating` | Double | `0.0` | Calculated mean score (`ratingSum / totalRatings`) |
| **orders** | `/orders/{id}` | `tableNumber` | String | - | Table where order was placed |
| | | `items` | Array (Map) | `[]` | List of items (name, price, quantity, dishId) |
| | | `totalPrice` | Double | `0.0` | Cumulative cost of items in order |
| | | `status` | String | `"pending"` | Order state: `pending`, `preparing`, `ready`, `completed` |
| | | `createdAt` | Integer | - | Milliseconds epoch timestamp |
| **specials** | `/specials/daily` | `dishId` | String | - | Reference to the current daily dish item |
| | | `promoText` | String | - | Marketing tagline for daily special |
| | | `expiresAt` | Integer | - | Expiration timestamp (midnight epoch) |

---

## 5. Architectural Execution Plan

The enhancements must be executed in a specific sequential order to ensure code compiler checks are met at each phase:

```
[1. Firestore Schemas & Indices]
               │
               ▼
[2. Data Layer Updates (Freezed Entities & Model Mapping)]
               │
               ▼
[3. Core Cubit Additions (CartCubit & Order logic)]
               │
               ▼
[4. Menu UI Integration (DishCard badge, star overlays)]
               │
               ▼
[5. Admin Panel Changes (Toggle availability, set special)]
               │
               ▼
[6. Kitchen Panel Implementation (Order stream & status actions)]
```

---

## 6. Verification and Testing Design

To verify the Phase 2 requirements (KPIs 46–50), the following test structure will be established:

### A. Unit Tests (Using `bloc_test` and `mocktail`)
1. **`CartCubit` Test Suite:**
   * Test initial state loading from LocalStorage.
   * Test adding/removing items and quantity constraints (e.g., minimum 1).
   * Test session state persistence on table-number change.
   * Test validation block (disallows checkout if table number is null).
2. **`AdminDishCubit` Availability Toggle Test:**
   * Verify updating a dish's `isAvailable` property successfully triggers repository calls and updates local bloc states.
3. **Rating Calculation Logic:**
   * Verify repository method calculations. If a dish has 2 ratings (4.0 and 5.0), adding a 3.0 rating updates the average to 4.0, sum to 12.0, and count to 3.

### B. Integration Tests (Using `flutter_test`)
* Implement an integration test running through a simulated workflow:
  1. Boot app, load `/menu` with parameter `?table=7`. Verify table 7 is locked in.
  2. Attempt to add an unavailable dish; assert addition is blocked.
  3. Add a valid dish to the cart.
  4. Submit order; mock network success and verify order document structure matches schema.
  5. Load `/admin/kitchen` layout, verify order from table 7 appears instantly at the top of the stream.
  6. Transition status to "Preparing" and then "Ready", verifying Firestore transactions trigger successfully.

### C. Manual Visual Checklists
* Perform responsive checks using Chrome Developer Tools viewport emulator (simulate iPad Pro for the Kitchen View, iPhone 14 for the Customer Menu Page).
* Verify rating star component touch targets conform to the minimum recommended Material Guidelines (48x48 pixels).
