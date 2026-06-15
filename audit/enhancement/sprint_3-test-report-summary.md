# Sprint 3: Kitchen Display Panel Test Report

## Validation Functions Table

| KPI Number | KPI | Validation Method | Expected Output | Actual Output | Status | Notes |
| ---------- | --- | ----------------- | --------------- | ------------- | ------ | ----- |
| **KPI-08** | Kitchen panel displays all newly submitted orders | Place an order from the customer view and watch `/admin/kitchen` panel. | The newly submitted order appears instantly under the "Pending" column or tab. | Placed orders appear instantly in real-time under the "Pending" section. | **PASS** | Live sync validated successfully. |
| **KPI-09** | Live updates without manual page refresh | Submit an order while the `/admin/kitchen` page is open. | The screen updates instantly to show the new card without a manual page refresh. | Firestore snapshot streams trigger BLoC state updates; cards insert dynamically. | **PASS** | Streams orders reactively. |
| **KPI-10** | Card displays order ID, table number, items, quantity, and timestamp | Inspect the contents of a rendered order card on the dashboard. | Card shows table number, short ID, list of items with quantities, timestamp, and elapsed running timer. | Card renders all requested information fields including the live running elapsed counter. | **PASS** | Rendered in coffee-brown Material 3 theme. |
| **KPI-11** | Sorted chronologically (newest first) | Place multiple orders in sequence and verify order list. | Newest orders are placed at the top of the queue/columns. | Orders are retrieved with `.orderBy('createdAt', descending: true)` and display newest first. | **PASS** | Tested via order sequence verification. |
| **KPI-12** | Kitchen staff can mark order as "Preparing" | Click the "Start Preparing" action button on a pending card. | Status changes to `preparing` in Firestore and the card transitions to the "Preparing" column. | Order updates atomically in Firestore; UI shifts the card to the "Preparing" column instantly. | **PASS** | Status changes are confirmed in database. |
| **KPI-13** | Kitchen staff can mark order as "Ready" | Click the "Mark Ready" action button on a preparing card. | Status updates to `ready` in Firestore and card transitions to the "Ready" column. | Order is updated in DB; UI moves the card to the "Ready" column instantly. | **PASS** | Status updates successfully. |
| **KPI-14** | Completed orders visually differentiated | Click "Complete Order" on a ready order card. | Status updates to `completed` in DB; card becomes semi-transparent (opacity: 0.75) and hides action buttons. | Card dims to 75% opacity, card background lightens, and action buttons are removed from UI. | **PASS** | Successfully archives and differentiates completed cards. |
| **KPI-15** | Kitchen panel remains functional after browser refresh | Set order status, reload Chrome tab on `/admin/kitchen`. | Active orders are reloaded with accurate states and streams resume. | The panel reloads successfully, starting a fresh subscription and restoring order cards. | **PASS** | Backed by persistent Firestore data. |
| **KPI-42** | Kitchen display renders correctly on tablet screens | Emulate iPad tablet width (e.g. 820px or 1024px) in Chrome viewport. | Dashboard renders columns (Pending, Preparing, Ready) side by side with no layout/text clipping. | Columns display in a scrollable horizontal row; details remain readable and non-clipped. | **PASS** | Handled by a responsive `LayoutBuilder` row layout. |
| **KPI-50** | All enhancement-related tests pass successfully | Run the command `flutter test` in workspace root. | All unit tests pass, producing 100% green output. | Test runner reports `All tests passed!` (22/22 tests passing). | **PASS** | Executed automated suite locally. |

---

## Test Cases Report

### 1. Kitchen State & Order Streams
| Test ID | Feature | Scenario | Expected Outcome | Status |
| :--- | :--- | :--- | :--- | :--- |
| **TC-001** | Stream Loading | Initialize KitchenCubit and receive orders | Cubit subscribes to stream, updates `orders` list, and sets `isLoading` to false. | **PASS** |
| **TC-002** | Stream Failure | Network failure during order stream load | Cubit catches error, updates `isLoading` to false, and emits descriptive error message. | **PASS** |
| **TC-003** | Status Advancement | Transition status: `pending` ➔ `preparing` | Action button clicks trigger `UpdateOrderStatusUseCase` to change status to `preparing`. | **PASS** |
| **TC-004** | Status Advancement | Transition status: `preparing` ➔ `ready` | Action button clicks trigger `UpdateOrderStatusUseCase` to change status to `ready`. | **PASS** |
| **TC-005** | Status Advancement | Transition status: `ready` ➔ `completed` | Action button clicks trigger `UpdateOrderStatusUseCase` to change status to `completed`. | **PASS** |
| **TC-006** | Error Catching | Failure updating order status | Usecase fails; cubit captures the error and alerts via a snackbar banner without crashing. | **PASS** |

### 2. UI Layouts & Responsiveness
| Test ID | Feature | Scenario | Expected Outcome | Status |
| :--- | :--- | :--- | :--- | :--- |
| **TC-007** | Tablet Layout | Load dashboard in tablet/desktop viewport | Renders as a Kanban board with 3 side-by-side columns: Pending, Preparing, and Ready. | **PASS** |
| **TC-008** | Mobile Layout | Load dashboard in mobile viewport | Renders as a TabBar containing 3 screens: Pending, Preparing, and Ready to fit small screens. | **PASS** |
| **TC-009** | Running Timer | Render active order card | Dynamic timer updates every second showing correct elapsed minutes/seconds (`mm:ss`) since creation. | **PASS** |
| **TC-010** | Auth Protection | Access `/admin/kitchen` while logged out | GoRouter redirects client back to `/admin/login`. | **PASS** |

---

## Defect Report

No defects were discovered during this test run. The implementation conforms to all specifications, code compilation is clean of warnings, and all automated unit tests are passing successfully.
