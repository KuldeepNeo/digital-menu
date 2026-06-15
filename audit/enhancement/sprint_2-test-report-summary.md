# Sprint 2: Table-Number & Shopping Cart Flow Test Report

## Validation Functions Table

| KPI Number | KPI | Validation Method | Expected Output | Actual Output | Status | Notes |
| ---------- | --- | ----------------- | --------------- | ------------- | ------ | ----- |
| **KPI-01** | Select/enter table number before adding items | Select table number from header dropdown component on `/menu` page. | Selecting a table updates `CartCubit` state and enables order workflow. | Table dropdown renders successfully; selection updates `CartState.tableNumber` dynamically. | **PASS** | Selection component is styled in coffee-brown Material 3. |
| **KPI-02** | Table number remains attached to cart items | Inspect state object values during item additions in `CartCubit`. | Selected table number is preserved within `CartState` alongside items list. | `tableNumber` is retained correctly during all item addition and subtraction triggers. | **PASS** | Verified via BLoC state assertion. |
| **KPI-03** | Order submission includes table number | Trigger order checkout and verify output request payload. | Usecase parses table number and populates the field inside the submitted `Order` model. | Table number is written to the Firestore `orders` document at checkout. | **PASS** | Checked database model formatting. |
| **KPI-04** | Staff can view table number for orders | Verify `Order` domain entity model includes `tableNumber` attribute. | Entity includes `tableNumber` field, preparing it for the kitchen panel display. | The `Order` entity and model define `tableNumber` as a required parameter. | **PASS** | Decoupled domain mapping. |
| **KPI-05** | Validation prevents empty table checkout | Attempt order checkout with empty table number in `CartCubit`. | Submission is blocked; state emits error message "Please select a table number..." | Checkout is blocked; state transitions to include the correct error message. | **PASS** | Handled in validation checks inside `submitOrder()`. |
| **KPI-06** | Table number persists during browser refresh | Hard reload client browser after selecting table number and items. | Storage helper restores table number and cart items from local storage. | Selected table number and cart contents reload instantly post-refresh. | **PASS** | Implemented using `StorageHelper` wrapping web browser `localStorage`. |
| **KPI-07** | Multiple tables place independent orders | Simulate two separate browser sessions (incognito vs standard). | Table selections and cart contents are isolated to each browser client. | Isolated storage states ensure that Table A and Table B operate independent carts. | **PASS** | Standard browser local storage sandboxing prevents crossover. |
| **KPI-50** | All enhancement-related tests pass successfully | Run the command `flutter test` in workspace root. | All unit tests pass, producing 100% green output. | Test runner reports `All tests passed!` (17/17 tests passing). | **PASS** | Executed automated suite locally. |

---

## Test Cases Report

### 1. Cart Operations & Management
| Test ID | Feature | Scenario | Expected Outcome | Status |
| :--- | :--- | :--- | :--- | :--- |
| **TC-001** | Cart Addition | Add available dish to cart | Cart state updates item quantity to 1 and attaches correct dish metadata. | **PASS** |
| **TC-002** | Stock Validation | Add out-of-stock dish to cart | Addition is blocked; no state change occurs. | **PASS** |
| **TC-003** | Cart Decoupling | Remove/decrement dish in cart | Decrements dish quantity in state; removes dish completely when quantity drops to zero. | **PASS** |
| **TC-004** | Table Selection | Modify table number selection | Updates selected table number in `CartCubit` state. | **PASS** |
| **TC-005** | Cart Clearing | Trigger `clearCart()` operation | Cart contents and selected table number are reset to initial state and removed from local storage. | **PASS** |

### 2. Checkout & Persistence Workflows
| Test ID | Feature | Scenario | Expected Outcome | Status |
| :--- | :--- | :--- | :--- | :--- |
| **TC-006** | Checkout Validation | Submit order with no table selected | Checkout halts; state emits error: *"Please select a table number before checking out."* | **PASS** |
| **TC-007** | Checkout Validation | Submit order with empty cart | Checkout halts; state emits error: *"Your cart is empty."* | **PASS** |
| **TC-008** | Checkout Success | Submit valid cart with table selected | State transitions to submitting (`isSubmitting: true`), writes document to Firestore, resets cart, and emits success. | **PASS** |
| **TC-009** | Cart State Recovery | Reload browser environment | Platform helper loads saved JSON values, rebuilding cart state accurately. | **PASS** |

---

## Defect Report

No defects were discovered during this test run. The implementation conforms to all specifications, code compilation is warning-free, and all automated unit tests are passing successfully.
