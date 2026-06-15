# Sprint 4 Implementation Plan: Customer Ratings & Specials

Implement the Daily Specials expiring top promotional banner and the dish rating feedback transaction logic.

## User Review Required

> [!IMPORTANT]
> * **Firestore Transaction for Ratings**: Ratings are saved using a Firestore Transaction on the specific dish document to ensure average score and total reviews are calculated atomically and concurrency-safe.
> * **Local Storage Session Lock**: To prevent duplicate rating submissions, once a customer rates a dish, the dish ID is stored in browser `localStorage` under `rated_dishes`, disabling further ratings for that item.
> * **Specials Auto-Expiration**: Specials are queried with a condition `expiresAt > currentTimestamp`. In addition, a client-side timer checks and hides the specials banner immediately when the clock passes midnight.

## Proposed Changes

### Core / Domain Layer

#### [MODIFY] [dish.dart](file:///Users/neo/Desktop/Vibe%20Coding%20Training/vibe_projects/digital-menu/digital_menu/lib/features/menu/domain/entities/dish.dart)
* Add `averageRating` (double, defaults to 0.0) and `numRatings` (int, defaults to 0) fields.

#### [NEW] [special.dart](file:///Users/neo/Desktop/Vibe%20Coding%20Training/vibe_projects/digital-menu/digital_menu/lib/features/menu/domain/entities/special.dart)
* Define `Special` entity containing: `id`, `dishId`, `title`, `expiresAt`.

#### [MODIFY] [menu_repository.dart](file:///Users/neo/Desktop/Vibe%20Coding%20Training/vibe_projects/digital-menu/digital_menu/lib/features/menu/domain/repositories/menu_repository.dart)
* Declare:
  * `Future<CloudResult<void>> submitRating(String dishId, int rating);`
  * `Stream<CloudResult<Special?>> streamDailySpecial();`
  * `Future<CloudResult<void>> setDailySpecial(String dishId, String title, int expiresAt);`
  * `Future<CloudResult<Dish>> getDishById(String dishId);`

#### [NEW] [submit_rating_usecase.dart](file:///Users/neo/Desktop/Vibe%20Coding%20Training/vibe_projects/digital-menu/digital_menu/lib/features/menu/domain/usecases/submit_rating_usecase.dart)
* Usecase calling `MenuRepository.submitRating(dishId, rating)`.

#### [NEW] [stream_special_usecase.dart](file:///Users/neo/Desktop/Vibe%20Coding%20Training/vibe_projects/digital-menu/digital_menu/lib/features/menu/domain/usecases/stream_special_usecase.dart)
* Usecase calling `MenuRepository.streamDailySpecial()`.

#### [NEW] [set_special_usecase.dart](file:///Users/neo/Desktop/Vibe%20Coding%20Training/vibe_projects/digital-menu/digital_menu/lib/features/menu/domain/usecases/set_special_usecase.dart)
* Usecase calling `MenuRepository.setDailySpecial()`.

### Data Layer

#### [MODIFY] [dish_model.dart](file:///Users/neo/Desktop/Vibe%20Coding%20Training/vibe_projects/digital-menu/digital_menu/lib/features/menu/data/models/dish_model.dart)
* Add `averageRating` and `numRatings` mapping with defaults.

#### [NEW] [special_model.dart](file:///Users/neo/Desktop/Vibe%20Coding%20Training/vibe_projects/digital-menu/digital_menu/lib/features/menu/data/models/special_model.dart)
* Define Freezed model for `Special`.

#### [MODIFY] [menu_remote_datasource.dart](file:///Users/neo/Desktop/Vibe%20Coding%20Training/vibe_projects/digital-menu/digital_menu/lib/features/menu/data/datasources/menu_remote_datasource.dart)
* Implement:
  * `Future<void> submitRating(String dishId, int rating);` (using `runTransaction`)
  * `Stream<SpecialModel?> streamDailySpecial();` (reading `/specials/daily`)
  * `Future<void> setDailySpecial(String dishId, String title, int expiresAt);` (writing to `/specials/daily`)
  * `Future<DishModel> getDishById(String dishId);` (reading `dishes` collection)

#### [MODIFY] [menu_repository_impl.dart](file:///Users/neo/Desktop/Vibe%20Coding%20Training/vibe_projects/digital-menu/digital_menu/lib/features/menu/data/repositories/menu_repository_impl.dart)
* Implement the new repository methods.

#### [MODIFY] [constants.dart](file:///Users/neo/Desktop/Vibe%20Coding%20Training/vibe_projects/digital-menu/digital_menu/lib/core/constants/constants.dart)
* Register `specials` collection name constant.

#### [MODIFY] [di.dart](file:///Users/neo/Desktop/Vibe%20Coding%20Training/vibe_projects/digital-menu/digital_menu/lib/core/di/di.dart)
* Register the new UseCases and `SpecialCubit`.

### Presentation Layer

#### [MODIFY] [menu_state.dart](file:///Users/neo/Desktop/Vibe%20Coding%20Training/vibe_projects/digital-menu/digital_menu/lib/features/menu/presentation/bloc/menu_state.dart)
* Add `dailySpecial` (Special?) and `dailySpecialDish` (Dish?) attributes.

#### [MODIFY] [menu_cubit.dart](file:///Users/neo/Desktop/Vibe%20Coding%20Training/vibe_projects/digital-menu/digital_menu/lib/features/menu/presentation/bloc/menu_cubit.dart)
* Subscribe to `streamDailySpecial()`. Fetch the corresponding dish via repository when a valid special is streamed, and update the state.

#### [NEW] [rating_dialog.dart](file:///Users/neo/Desktop/Vibe%20Coding%20Training/vibe_projects/digital-menu/digital_menu/lib/features/menu/presentation/widgets/rating_dialog.dart)
* Star rating entry dialog (optimizing touch targets to at least 48x48 pixels).

#### [NEW] [daily_specials_banner.dart](file:///Users/neo/Desktop/Vibe%20Coding%20Training/vibe_projects/digital-menu/digital_menu/lib/features/menu/presentation/widgets/daily_specials_banner.dart)
* Expiring promo banner placed at the top of `MenuPage`. Runs a periodic timer to enforce immediate midnight client-side expiration.

#### [MODIFY] [dish_card.dart](file:///Users/neo/Desktop/Vibe%20Coding%20Training/vibe_projects/digital-menu/digital_menu/lib/features/menu/presentation/widgets/dish_card.dart)
* Display average stars and ratings count. Provide entry touch targets to submit a review (checking localStorage first to see if duplicate rating should be blocked).

#### [MODIFY] [admin_page.dart](file:///Users/neo/Desktop/Vibe%20Coding%20Training/vibe_projects/digital-menu/digital_menu/lib/features/admin/presentation/pages/admin_page.dart)
* Add a button/action "Configure Daily Special" opening `SetSpecialDialog`.

#### [NEW] [set_special_dialog.dart](file:///Users/neo/Desktop/Vibe%20Coding%20Training/vibe_projects/digital-menu/digital_menu/lib/features/admin/presentation/widgets/set_special_dialog.dart)
* Admin dialog to select a dish from catalog, write promotional titles, calculate current day's midnight, and save to `/specials/daily`.

### Testing Updates

#### [NEW] [ratings_specials_test.dart](file:///Users/neo/Desktop/Vibe%20Coding%20Training/vibe_projects/digital-menu/digital_menu/test/features/menu/presentation/bloc/ratings_specials_test.dart)
* Test suite verifying transaction calculations, specials stream mapping, local storage locking, and mid-night expiration timers.

---

## Verification Plan

### Automated Tests
* Run `flutter test test/features/menu/presentation/bloc/ratings_specials_test.dart` to verify ratings/specials logic.
* Run `flutter analyze` to ensure code is clean of static warnings.

### Manual Verification
* Run local Chrome browser: `flutter run -d chrome`.
* Go to Admin Dashboard, click "Configure Daily Special". Select a dish, save it.
* Open customer menu `/menu`, verify Specials banner displays title and linked dish details.
* Warp time / simulate midnight clock check, verify banner disappears.
* Click on ratings stars on a customer `DishCard`, submit a rating of 4. Verify stars update.
* Click again, verify submission is blocked and indicates "Already Rated".
