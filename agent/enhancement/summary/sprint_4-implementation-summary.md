# Sprint 4 Implementation Summary: Customer Ratings & Specials

**Feature Group:** Customer Ratings & Specials  
**Status:** Completed & Ready for QA Testing  
**Date:** 2026-06-15  

---

## 1. Overview of Changes

Sprint 4 implements the **Daily Specials Banner** and the **Customer Ratings** systems, promoting high-margin items and gathering customer feedback via an atomic rating transaction flow.

### Domain Layer
* **[dish.dart](file:///Users/neo/Desktop/Vibe%20Coding%20Training/vibe_projects/digital-menu/digital_menu/lib/features/menu/domain/entities/dish.dart):** Extended the `Dish` entity to include `averageRating` (double) and `numRatings` (int).
* **[special.dart](file:///Users/neo/Desktop/Vibe%20Coding%20Training/vibe_projects/digital-menu/digital_menu/lib/features/menu/domain/entities/special.dart):** Added the new `Special` entity containing `id`, `dishId`, `promoMessage`, and `expiresAt`.
* **[menu_repository.dart](file:///Users/neo/Desktop/Vibe%20Coding%20Training/vibe_projects/digital-menu/digital_menu/lib/features/menu/domain/repositories/menu_repository.dart):** Updated repository contract with signatures for streaming daily specials, setting daily specials, submitting ratings, fetching dishes by ID, and retrieving all dishes.
* **Use Cases:**
  * **[stream_special_usecase.dart](file:///Users/neo/Desktop/Vibe%20Coding%20Training/vibe_projects/digital-menu/digital_menu/lib/features/menu/domain/usecases/stream_special_usecase.dart):** Streams the active daily special document.
  * **[set_special_usecase.dart](file:///Users/neo/Desktop/Vibe%20Coding%20Training/vibe_projects/digital-menu/digital_menu/lib/features/menu/domain/usecases/set_special_usecase.dart):** Sets or updates the daily special in Firestore.
  * **[submit_rating_usecase.dart](file:///Users/neo/Desktop/Vibe%20Coding%20Training/vibe_projects/digital-menu/digital_menu/lib/features/menu/domain/usecases/submit_rating_usecase.dart):** Atomically submits a 1–5 star rating for a dish.
  * **[get_dish_by_id_usecase.dart](file:///Users/neo/Desktop/Vibe%20Coding%20Training/vibe_projects/digital-menu/digital_menu/lib/features/menu/domain/usecases/get_dish_by_id_usecase.dart):** Fetches a dish by its Firestore document ID.
  * **[get_all_dishes_usecase.dart](file:///Users/neo/Desktop/Vibe%20Coding%20Training/vibe_projects/digital-menu/digital_menu/lib/features/menu/domain/usecases/get_all_dishes_usecase.dart):** Fetches all dishes (used by admin selectors).

### Data Layer
* **[dish_model.dart](file:///Users/neo/Desktop/Vibe%20Coding%20Training/vibe_projects/digital-menu/digital_menu/lib/features/menu/data/models/dish_model.dart):** Updated serialization/deserialization schemas to support `averageRating` and `numRatings` (including Freezed generated files).
* **[special_model.dart](file:///Users/neo/Desktop/Vibe%20Coding%20Training/vibe_projects/digital-menu/digital_menu/lib/features/menu/data/models/special_model.dart):** Added database deserializer mapping for the `specials` collection.
* **[menu_remote_datasource.dart](file:///Users/neo/Desktop/Vibe%20Coding%20Training/vibe_projects/digital-menu/digital_menu/lib/features/menu/data/datasources/menu_remote_datasource.dart) & [menu_remote_datasource_impl.dart](file:///Users/neo/Desktop/Vibe%20Coding%20Training/vibe_projects/digital-menu/digital_menu/lib/features/menu/data/datasources/menu_remote_datasource_impl.dart):**
  * Added real-time listener streams targeting the active daily special document.
  * Designed an atomic Firestore transaction inside `submitRating` to safely recalculate and update `averageRating` and `numRatings` preventing dirty writes and concurrency anomalies.
* **[menu_repository_impl.dart](file:///Users/neo/Desktop/Vibe%20Coding%20Training/vibe_projects/digital-menu/digital_menu/lib/features/menu/data/repositories/menu_repository_impl.dart):** Propagates use case data and implements mapping logic from model to entity format.

### Presentation Layer
* **[menu_state.dart](file:///Users/neo/Desktop/Vibe%20Coding%20Training/vibe_projects/digital-menu/digital_menu/lib/features/menu/presentation/bloc/menu_state.dart):** Extended menu BLoC state with `dailySpecial` (entity) and `dailySpecialDish` (linked dish entity).
* **[menu_cubit.dart](file:///Users/neo/Desktop/Vibe%20Coding%20Training/vibe_projects/digital-menu/digital_menu/lib/features/menu/presentation/bloc/menu_cubit.dart):**
  * Initiated real-time subscription for the active daily special, matching it to the corresponding catalog dish dynamically.
  * Configured client-side timer checks to immediately remove/expire the daily special banner when passing midnight.
  * Exposed sub-handlers for submit rating transactions.
* **[daily_specials_banner.dart](file:///Users/neo/Desktop/Vibe%20Coding%20Training/vibe_projects/digital-menu/digital_menu/lib/features/menu/presentation/widgets/daily_specials_banner.dart):** Visual banner highlighted at the top of the customer menu page. Features custom promotional message, dish photo, price, and a direct "Add to Cart" button.
* **[rating_dialog.dart](file:///Users/neo/Desktop/Vibe%20Coding%20Training/vibe_projects/digital-menu/digital_menu/lib/features/menu/presentation/widgets/rating_dialog.dart):** Overlay modal containing 1–5 star selector buttons. Includes a session lock checking browser `localStorage` to prevent duplicate reviews. Touch targets are set to 48x48 pixels for optimum mobile viewport compatibility.
* **[dish_card.dart](file:///Users/neo/Desktop/Vibe%20Coding%20Training/vibe_projects/digital-menu/digital_menu/lib/features/menu/presentation/widgets/dish_card.dart):** Enhanced to display average star ratings (using decorative mini stars) and rating counts, and links directly to the `RatingDialog`.
* **[set_special_dialog.dart](file:///Users/neo/Desktop/Vibe%20Coding%20Training/vibe_projects/digital-menu/digital_menu/lib/features/admin/presentation/widgets/set_special_dialog.dart):** Admin dialog allowing menu managers to select an active dish, write a promo message, and set it as the daily special with midnight auto-expiration.
* **[admin_page.dart](file:///Users/neo/Desktop/Vibe%20Coding%20Training/vibe_projects/digital-menu/digital_menu/lib/features/admin/presentation/pages/admin_page.dart):** Inserted a "Set Special" action button in the responsive page header.
* **[AdminDishCubit](file:///Users/neo/Desktop/Vibe%20Coding%20Training/vibe_projects/digital-menu/digital_menu/lib/features/admin/presentation/controllers/admin_dish_cubit.dart) & [AddDishDialog](file:///Users/neo/Desktop/Vibe%20Coding%20Training/vibe_projects/digital-menu/digital_menu/lib/features/admin/presentation/widgets/add_dish_dialog.dart):** Modified edit, creation, and availability toggle flows to forward existing `averageRating` and `numRatings` attributes, preventing data deletion.

### Dependency Injection
* **[di.dart](file:///Users/neo/Desktop/Vibe%20Coding%20Training/vibe_projects/digital-menu/digital_menu/lib/core/di/di.dart):** Wired all five new use cases into the locator registry.

---

## 2. QA & Test Verification Results

### Automated Unit Testing
* **Tests added in [ratings_specials_test.dart](file:///Users/neo/Desktop/Vibe%20Coding%20Training/vibe_projects/digital-menu/digital_menu/test/features/menu/presentation/bloc/ratings_specials_test.dart):**
  * Verified initial state has empty dailySpecial and dailySpecialDish.
  * Verified submitting ratings calls the corresponding `SubmitRatingUseCase`.
  * Verified streaming specials maps the active special and fetches the correct dish.
  * Verified time-based expiration logic blocks emitting expired daily specials.
* **Execution Status:** 
  * Run command: `flutter test`
  * Result: **All tests passed!** (26/26 tests passing)

### Static Code Analysis
* Run command: `flutter analyze`
* Result: **No issues found!**
