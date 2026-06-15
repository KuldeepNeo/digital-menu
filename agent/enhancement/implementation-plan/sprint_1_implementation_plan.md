# Sprint 1 Implementation Plan: Stock Control & Catalog Foundations

Implement stock status control to allow café staff to toggle dish availability (in-stock vs. out-of-stock), dynamically updating customer views in real time.

## User Review Required

> [!IMPORTANT]
> The database schema changes are backward-compatible. If a dish does not have the `isAvailable` field in Firestore, it will default to `true` (available) client-side.
> No new packages are added.

## Proposed Changes

### Core / Catalog Updates

#### [MODIFY] [dish.dart](file:///Users/neo/Desktop/Vibe%20Coding%20Training/vibe_projects/digital-menu/digital_menu/lib/features/menu/domain/entities/dish.dart)
* Add `isAvailable` field (boolean, default: `true`).

#### [MODIFY] [dish_model.dart](file:///Users/neo/Desktop/Vibe%20Coding%20Training/vibe_projects/digital-menu/digital_menu/lib/features/menu/data/models/dish_model.dart)
* Add `@Default(true) bool isAvailable` to Freezed factory constructor.
* Map `isAvailable` between entity and model.

#### [MODIFY] [admin_dish_cubit.dart](file:///Users/neo/Desktop/Vibe%20Coding%20Training/vibe_projects/digital-menu/digital_menu/lib/features/admin/presentation/controllers/admin_dish_cubit.dart)
* Pass `isAvailable` when creating/editing a dish.
* Implement a new function `toggleAvailability(Dish dish)` to update Firestore without editing other properties.

### Presentation Updates

#### [MODIFY] [admin_dish_card.dart](file:///Users/neo/Desktop/Vibe%20Coding%20Training/vibe_projects/digital-menu/digital_menu/lib/features/admin/presentation/widgets/admin_dish_card.dart)
* Add a Switch/Toggle at the card footer to enable/disable availability.
* Connect switch toggles directly to `AdminDishCubit.toggleAvailability()`.

#### [MODIFY] [dish_card.dart](file:///Users/neo/Desktop/Vibe%20Coding%20Training/vibe_projects/digital-menu/digital_menu/lib/features/menu/presentation/widgets/dish_card.dart)
* Check `dish.isAvailable`.
* If unavailable, apply `Opacity` widget (opacity `0.6`), render an "OUT OF STOCK" banner text overlay, and disable cart actions (which will be added in Sprint 2).

### Testing Updates

#### [MODIFY] [admin_dish_cubit_test.dart](file:///Users/neo/Desktop/Vibe%20Coding%20Training/vibe_projects/digital-menu/digital_menu/test/features/admin/presentation/controllers/admin_dish_cubit_test.dart)
* Add unit tests verifying `toggleAvailability` successfully updates Firestore and emits `[loading, success]`.

---

## Verification Plan

### Automated Tests
* Run `flutter test test/features/admin/presentation/controllers/admin_dish_cubit_test.dart` to verify cubit states.
* Run code generation: `dart run build_runner build --delete-conflicting-outputs`.

### Manual Verification
* Run local Chrome browser: `flutter run -d chrome`.
* Log in as admin, check that toggling availability instantly updates the database.
* Keep customer menu open in another window, confirm it updates in real time.
