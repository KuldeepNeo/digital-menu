# Sprint 1: Stock Control & Catalog Foundations Test Report

## Validation Functions Table

| KPI Number | KPI | Validation Method | Expected Output | Actual Output | Status | Notes |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| **KPI-24** | Admin can mark a dish as Out of Stock | Toggle the availability switch on an `AdminDishCard` in the Admin Dashboard. | The local bloc state updates to loading and then success; Switch toggles to false. | The switch toggles to false, cubit emits `[loading, success]` states, and UI shows a success toast. | **PASS** | Checked via `AdminDishCard` Switch interaction. |
| **KPI-25** | Out-of-stock status is saved in database | Inspect the updated Firestore dish document field `isAvailable`. | Field `isAvailable` is set to `false` in the target Firestore document. | Document field in database is updated to `isAvailable: false`. | **PASS** | Verified document snapshot values in Firestore. |
| **KPI-26** | Customer menu visually indicates unavailable dishes | Load `/menu` page in customer view after marking a dish out of stock. | Target dish card is dimmed (opacity 0.6) and displays an "OUT OF STOCK" banner overlay. | Card has 60% opacity applied and shows the red "OUT OF STOCK" overlay on the image. | **PASS** | Visual check on `DishCard`. |
| **KPI-27** | Customers cannot add out-of-stock dishes to cart | Verify click/touch interactions on an out-of-stock `DishCard`. | Add button/cart action is hidden, disabled, or non-responsive on out-of-stock cards. | No cart interaction buttons are rendered on the card, preventing any action. | **PASS** | Enforced at the card component boundary. |
| **KPI-28** | Availability changes update immediately on menu | Toggle a dish's stock state in admin window and watch customer menu window. | Customer menu page updates instantly in real time via snapshot streams without page refresh. | Dish card dimming and out-of-stock overlay apply immediately when toggled in admin. | **PASS** | Verified via multi-window real-time synchronization. |
| **KPI-29** | Admin can restore dish availability | Toggle the availability switch on a disabled `AdminDishCard` back to active. | Firestore field `isAvailable` updates to `true`, and card dims are removed from customer menu. | Switch toggles to active, DB writes `isAvailable: true`, and card dims disappear instantly. | **PASS** | Re-enabled state is fully functional. |
| **KPI-30** | Existing orders containing previously available dishes remain unaffected | Inspect order models and confirm separation of order state from active dish catalog. | Data models store copies of name, price, and details, ensuring catalog toggle has zero impact. | Models are structurally decoupled; order schemas log static details at checkout. | **PASS** | Validated via entity and data model structural analysis. |
| **KPI-31** | Availability state persists after application restart | Restart the application/refresh browser after setting stock status. | Stock states reload exactly as configured from Firestore. | Out-of-stock statuses persist and display identically post-restart. | **PASS** | Verified after hard reloading Chrome. |
| **KPI-47** | Unit tests exist for dish availability toggle functionality | Run the unit test suite targeting `AdminDishCubit` and toggling stock. | Tests check `toggleAvailability` success and failure cases under BLoC state transitions. | Dedicated tests are registered in `admin_dish_cubit_test.dart` under group `toggleAvailability`. | **PASS** | Verified via test suite run. |
| **KPI-50** | All enhancement-related tests pass successfully | Run the command `flutter test`. | All unit and widget tests pass, producing 100% green output. | Test runner reports `All tests passed!`. | **PASS** | Executed test suite locally. |

---

## Test Cases Report

### 1. Dish Availability Toggle (Admin Feature)
| Test ID | Feature | Scenario | Expected Outcome | Status |
| :--- | :--- | :--- | :--- | :--- |
| **TC-001** | Stock Toggle | Mark dish as out-of-stock (isAvailable: false) | Cubit updates state to loading, updates Firestore document to `isAvailable: false`, and alerts with a success toast. | **PASS** |
| **TC-002** | Stock Toggle | Mark dish as in-stock (isAvailable: true) | Firestore document `isAvailable` updates to `true`. Dimming overlay on client menu disappears. | **PASS** |
| **TC-003** | Error Handling | Network fails during stock toggle write | Cubit emits `[loading, error]` and presents a red error snackbar in the admin view. | **PASS** |

### 2. Catalog Display (Customer Feature)
| Test ID | Feature | Scenario | Expected Outcome | Status |
| :--- | :--- | :--- | :--- | :--- |
| **TC-004** | Out-of-Stock UI | Render out-of-stock dish on menu | Card is dimmed (60% opacity) and showcases the red "OUT OF STOCK" banner overlay. | **PASS** |
| **TC-005** | Real-time Update | Toggle availability in admin panel | Customer page applies/removes out-of-stock overlay instantly without manual page reload. | **PASS** |

---

## Defect Report

No defects were discovered during this test run. The implementation perfectly conforms to the requirements, code compilation is clean, and 100% of the unit test cases pass.
