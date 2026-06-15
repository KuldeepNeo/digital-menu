# Enhancement Impact Analysis (Phase 2)

**Role:** Senior Architect  
**Project:** DigitalMenu  
**Version:** 2.0  
**Date:** 2026-06-15  

---

## 1. Introduction & Context

This document provides a detailed impact analysis of the Phase 2 enhancements on the existing **DigitalMenu** codebase. It maps every key requirement and KPI to files, identifies reusable assets, analyzes dependencies, estimates implementation complexity, and dictates the implementation roadmap.

The goal is to maintain the project boundaries defined in [project_boundary.md](file:///Users/neo/Desktop/Vibe%20Coding%20Training/vibe_projects/digital-menu/agent/project_boundary.md) and ensure that no existing features from Phase 1 (as described in [prd_digital_menu.md](file:///Users/neo/Desktop/Vibe%20Coding%20Training/vibe_projects/digital-menu/agent/prd_digital_menu.md) and [kpi_digital_menu.md](file:///Users/neo/Desktop/Vibe%20Coding%20Training/vibe_projects/digital-menu/agent/kpi_digital_menu.md)) are broken.

---

## 2. Reusable Components & Classes

Before introducing new code, we identify the following existing components that can be reused to maintain consistency and accelerate development:

| Component / Class | File / Path | Reuse Strategy |
| :--- | :--- | :--- |
| `CloudResult<T>` | [cloud_result.dart](file:///Users/neo/Desktop/Vibe%20Coding%20Training/vibe_projects/digital-menu/digital_menu/lib/core/network/cloud_result.dart) | Standard wrapper for all new repository operations (ordering, ratings, and specials management). |
| `ShimmerLoader` | [shimmer_loader.dart](file:///Users/neo/Desktop/Vibe%20Coding%20Training/vibe_projects/digital-menu/digital_menu/lib/shared/widgets/shimmer_loader.dart) | Display skeleton loading for the kitchen dashboard page and ratings streams. |
| `AddDishDialog` style | [add_dish_dialog.dart](file:///Users/neo/Desktop/Vibe%20Coding%20Training/vibe_projects/digital-menu/digital_menu/lib/features/admin/presentation/widgets/add_dish_dialog.dart) | Serve as a baseline style template for the new rating submission dialog and special configuration overlay. |
| `MenuCubit` real-time streams | [menu_cubit.dart](file:///Users/neo/Desktop/Vibe%20Coding%20Training/vibe_projects/digital-menu/digital_menu/lib/features/menu/presentation/bloc/menu_cubit.dart) | Leverage Firestore real-time subscriptions pattern to listen to category and dish edits instantly. |
| Dependency Injection (DI) | [di.dart](file:///Users/neo/Desktop/Vibe%20Coding%20Training/vibe_projects/digital-menu/digital_menu/lib/core/di/di.dart) | Wire all new Use Cases, Repositories, and Cubits in the central locator. |

---

## 3. KPI-to-Codebase Mapping & File Impact

Here is the exact mapping of all 50 Phase 2 KPIs to the codebase:

### 🍽️ Module A: Table-Number Ordering Flow (KPIs 1–7)

| KPI | Description | Affected Files (M = Modify, N = New) | Reusable Code & Dependencies | Complexity |
| :--- | :--- | :--- | :--- | :--- |
| **KPI-01** | Select/enter table number before adding items | (M) `menu_page.dart`<br>(N) `cart_cubit.dart` | Material dropdown/chip components | Medium |
| **KPI-02** | Table number remains attached to cart items | (N) `cart_cubit.dart`<br>(N) `order.dart` (Entity) | `OrderItem` structures | Low |
| **KPI-03** | Order submission includes table number | (N) `submit_order_usecase.dart`<br>(M) `menu_remote_datasource.dart` | `CloudResult`, `FirebaseFirestore` | Medium |
| **KPI-04** | Staff can view table number for orders | (N) `kitchen_page.dart`<br>(N) `order_card.dart` | Material Text themes | Low |
| **KPI-05** | Validation prevents empty table checkout | (N) `cart_cubit.dart`<br>(N) `cart_sheet.dart` | Custom state validators | Low |
| **KPI-06** | Table number persists during browser refresh | (N) `cart_cubit.dart` | `html.window.localStorage` (Web target) | Medium |
| **KPI-07** | Multiple tables place independent orders | (N) `cart_cubit.dart` | Handled via sandbox local session storage | Low |

---

### 🖥️ Module B: Kitchen Display – Incoming Orders Panel (KPIs 8–15)

| KPI | Description | Affected Files (M = Modify, N = New) | Reusable Code & Dependencies | Complexity |
| :--- | :--- | :--- | :--- | :--- |
| **KPI-08** | Kitchen displays all submitted orders | (N) `kitchen_page.dart`<br>(N) `kitchen_cubit.dart` | `ShimmerLoader` | High |
| **KPI-09** | Live updates without manual page refresh | (N) `kitchen_cubit.dart` | Firestore snapshots subscription | Medium |
| **KPI-10** | Card displays order ID, table, items, status, time | (N) `order_card.dart` | M3 Card layouts, DateFormat helper | Low |
| **KPI-11** | Sorted chronologically (newest first) | (N) `kitchen_cubit.dart` | `.orderBy('createdAt', descending: true)` | Low |
| **KPI-12** | Mark order status as "Preparing" | (N) `update_order_status_usecase.dart` | `orders` update Firestore payload | Low |
| **KPI-13** | Mark order status as "Ready" | (N) `update_order_status_usecase.dart` | Same as above | Low |
| **KPI-14** | Completed orders visually differentiated | (N) `order_card.dart` | Color schemes, status tags | Low |
| **KPI-15** | Panel remains functional after refresh | (N) `kitchen_page.dart`<br>(M) `router.dart` | GoRouter persistence and guards | Medium |

---

### 🎉 Module C: Daily Specials Banner (KPIs 16–23)

| KPI | Description | Affected Files (M = Modify, N = New) | Reusable Code & Dependencies | Complexity |
| :--- | :--- | :--- | :--- | :--- |
| **KPI-16** | Admin can set a daily special banner | (M) `admin_page.dart`<br>(N) `set_special_dialog.dart` | Dropdowns, M3 Forms | Medium |
| **KPI-17** | Special displayed on customer menu page | (M) `menu_page.dart`<br>(N) `daily_specials_banner.dart` | Animation controllers, text styles | Medium |
| **KPI-18** | Banner shows text and linked dish info | (N) `daily_specials_banner.dart` | `CachedNetworkImage` | Low |
| **KPI-19** | Only active specials are queried | (M) `menu_cubit.dart` | Firestore where query filter | Low |
| **KPI-20** | Special expires at midnight server time | (N) `set_special_dialog.dart` | Calculations for midnight timestamp | Medium |
| **KPI-21** | Expired specials automatically hidden | (M) `menu_cubit.dart` | Timestamp comparator stream filter | Low |
| **KPI-22** | Admin can replace expired specials | (M) `admin_page.dart` | Overwrite Firestore single document | Low |
| **KPI-23** | Responsive banner layout | (N) `daily_specials_banner.dart` | LayoutBuilder/MediaQuery check | Low |

---

### 🚫 Module D: Dish Availability Toggle (KPIs 24–31)

| KPI | Description | Affected Files (M = Modify, N = New) | Reusable Code & Dependencies | Complexity |
| :--- | :--- | :--- | :--- | :--- |
| **KPI-24** | Admin can toggle Out of Stock | (M) `admin_dish_card.dart` | Material Switch | Low |
| **KPI-25** | Toggle state saved in database | (M) `dish_model.dart`<br>(M) `dish.dart` | Freezed defaults | Low |
| **KPI-26** | Customer menu indicates unavailable items | (M) `dish_card.dart` | Custom badges, opacity filters | Low |
| **KPI-27** | Disables adding unavailable items to cart | (M) `dish_card.dart` | Conditional click hooks | Low |
| **KPI-28** | Updates propagate immediately | (M) `menu_cubit.dart` | Firestore snaps listener | Low |
| **KPI-29** | Admin can restore dish availability | (M) `admin_dish_card.dart` | Re-enable toggle Switch | Low |
| **KPI-30** | Existing orders remain unaffected | (N) `order_model.dart` | Immutable maps (does not join dynamically) | Low |
| **KPI-31** | Status persists after restarts | (M) `dish_model.dart` | Firestore persistent fields | Low |

---

### ⭐ Module E: Customer Ratings Per Dish (KPIs 32–40)

| KPI | Description | Affected Files (M = Modify, N = New) | Reusable Code & Dependencies | Complexity |
| :--- | :--- | :--- | :--- | :--- |
| **KPI-32** | Customers submit ratings (1-5 stars) | (N) `rating_dialog.dart`<br>(N) `submit_dish_rating_usecase.dart` | Touch handlers | Medium |
| **KPI-33** | Validation restricts range to 1–5 | (N) `submit_dish_rating_usecase.dart` | Range check validation assertion | Low |
| **KPI-34** | Rating saved in Firestore | (M) `menu_repository_impl.dart` | Firestore transactions | Medium |
| **KPI-35** | Average rating calculated correctly | (M) `menu_repository_impl.dart` | Transaction mathematics | Medium |
| **KPI-36** | Average rating shown on dish cards | (M) `dish_card.dart` | Stars and average tags | Low |
| **KPI-37** | Updates propagate immediately | (M) `menu_cubit.dart` | Stream updates | Low |
| **KPI-38** | Total number of ratings displayed | (M) `dish_card.dart` | Card details alignment | Low |
| **KPI-39** | Duplicate ratings prevented per session | (N) `rating_dialog.dart` | `html.window.localStorage` checklist | Medium |
| **KPI-40** | Ratings persist across sessions | (M) `dish_model.dart` | Firestore documents fields | Low |

---

### 🧪 UX, Responsiveness, & QA Modules (KPIs 41–50)

* **UX/Responsiveness (KPI-41 to KPI-45):** 
  * Handled inside the respective new layout widgets (`kitchen_page.dart`, `daily_specials_banner.dart`, `rating_dialog.dart`) using responsive widgets (`LayoutBuilder`, `MediaQuery`).
* **QA & Automated Testing (KPI-46 to KPI-50):**
  * Handled inside the testing suite (`test/features/menu` and `test/features/admin`). Unit tests will check the business logic of `CartCubit` and `AdminDishCubit`, and integration tests will walk through the order pipeline.

---

## 4. Dependencies & Architectural Impact

### Internal Dependencies Graph

```
[UI Views: MenuPage, AdminPage, KitchenPage]
                  │
                  ▼
[Controllers: MenuCubit, AdminDishCubit, CartCubit, KitchenCubit]
                  │
                  ▼
[Domain Use Cases: SubmitOrder, StreamOrders, SetSpecial, ToggleStock, SubmitRating]
                  │
                  ▼
[Data Layer: Repositories & Serialized Freezed Models]
                  │
                  ▼
[Infrastructure: Firebase Auth, Cloud Firestore, LocalStorage]
```

### Architectural Impact Summary:
1. **Model Expansion:** Upgrading [dish.dart](file:///Users/neo/Desktop/Vibe%20Coding%20Training/vibe_projects/digital-menu/digital_menu/lib/features/menu/domain/entities/dish.dart) and [dish_model.dart](file:///Users/neo/Desktop/Vibe%20Coding%20Training/vibe_projects/digital-menu/digital_menu/lib/features/menu/data/models/dish_model.dart) is necessary first to support ratings and availability properties. Models require regenerating via `build_runner`.
2. **Local Session Caching:** Rather than adding external packages (like `shared_preferences`), standard Web platform features (`html.window.localStorage`) will be leveraged inside `CartCubit` to track cart contents and table selections across page refreshes.
3. **Firestore Transact Operations:** To ensure total and average rating calculations are mathematically sound and atomic, rating submissions must run within a Firestore Transaction inside `MenuRepositoryImpl` instead of simple set operations.

---

## 5. Estimated Complexity Analysis

* **High Complexity Modules:**
  * **Kitchen display panel & real-time order state management:** Requires handling state synchronization, streams, chronological sorting, and UI layout adaptations.
* **Medium Complexity Modules:**
  * **Table-Number Cart System:** Involves synchronizing memory cache to local storage, routing URLs, and handling validation.
  * **Daily Specials Banner:** Involves timestamp calculations for automatic midnight expiration.
  * **Star Rating Dialog:** Involves custom star inputs, transactions, and session validation.
* **Low Complexity Modules:**
  * **Availability Toggle:** Leverages existing update mechanisms; only requires UI badges and boolean flags.

---

## 6. Recommended Implementation Order

To minimize dependency conflicts and simplify debugging, implement the features in the following order:

1. **Step 1: Data Model Expansion & Build Generation**
   * Modify `dish.dart` and `dish_model.dart`.
   * Run code generation: `dart run build_runner build --delete-conflicting-outputs`.
2. **Step 2: Table-Number & Cart State (`CartCubit`)**
   * Write `OrderItem` and `Order` entities/models.
   * Write `CartCubit` handling item additions, removals, table parsing, validation, and browser persistence.
   * Update `MenuPage` and `DishCard` to display the cart drawer and allow items to be added.
3. **Step 3: Dish Availability Toggle**
   * Modify `admin_dish_card.dart` to insert the stock toggle.
   * Modify `dish_card.dart` to dim out-of-stock items and disable actions.
4. **Step 4: Kitchen Dashboard & Order Placing**
   * Create `OrderRepository`, `OrderRemoteDataSource`, and write order placement use cases.
   * Develop `KitchenCubit` and `KitchenPage`. Set up GoRouter configuration for `/admin/kitchen`.
5. **Step 5: Customer Ratings**
   * Implement ratings transaction in `MenuRepositoryImpl`.
   * Create rating submission dialog and display average stars on `DishCard`.
6. **Step 6: Daily Specials Banner**
   * Implement specials document schema, admin specials config form, and the expiring top banner.
7. **Step 7: Unit & Integration Testing**
   * Write tests corresponding to KPIs 46–50.
