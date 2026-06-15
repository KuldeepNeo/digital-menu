# DigitalMenu Application – Enhancement Features KPI Checklist

These are the **Key Performance Indicators (KPIs)** used to verify that the new enhancement features for the DigitalMenu application have been successfully implemented and are production-ready.

---

# Completion KPIs: DigitalMenu Enhancements

All KPIs are **binary (Pass/Fail)** and must pass before the enhancement sprint is considered complete.

---

## 🍽️ Table-Number Ordering Flow (Add to Order)

This feature enables customers dining in the restaurant to associate orders with a specific table number.

| #  | KPI                                                                             | Verification Method                                              |
| :- | :------------------------------------------------------------------------------ | :--------------------------------------------------------------- |
| 1  | Customer can select or enter a table number before adding items to cart         | Open menu; select table; value stored in session/cart.           |
| 2  | Table number remains attached to all cart items                                 | Add multiple dishes; verify table number persists.               |
| 3  | Order submission includes table number in payload                               | Inspect network request/database record.                         |
| 4  | Staff can view table number for every incoming order                            | Create order; verify table number visible in admin/kitchen view. |
| 5  | Validation prevents checkout without table number when dine-in mode is selected | Attempt checkout; validation message displayed.                  |
| 6  | Table number persists during page refresh within active session                 | Refresh browser; table number remains selected.                  |
| 7  | Multiple simultaneous tables can place independent orders                       | Test with different browsers/sessions; orders remain isolated.   |

---

## 🖥️ Kitchen Display – Incoming Orders Panel

This feature provides a live kitchen dashboard showing newly placed customer orders.

| #  | KPI                                                                        | Verification Method                                 |
| :- | :------------------------------------------------------------------------- | :-------------------------------------------------- |
| 8  | Kitchen panel displays all newly submitted orders                          | Place order; verify appearance in kitchen panel.    |
| 9  | Orders appear without manual page refresh                                  | Submit order; observe real-time update.             |
| 10 | Kitchen panel shows order ID, table number, items, quantity, and timestamp | Inspect order card details.                         |
| 11 | Orders are sorted chronologically (newest first)                           | Submit multiple orders; verify ordering.            |
| 12 | Kitchen staff can mark order as "Preparing"                                | Change status; UI updates correctly.                |
| 13 | Kitchen staff can mark order as "Ready"                                    | Update status; customer/admin view reflects change. |
| 14 | Completed orders are visually differentiated from pending orders           | Verify styling/status badges.                       |
| 15 | Kitchen panel remains functional after browser refresh                     | Refresh page; active orders reload correctly.       |

---

## 🎉 Daily Specials Banner (Auto-Expires at Midnight)

This feature highlights promotional dishes that automatically expire at the end of the day.

| #  | KPI                                                                    | Verification Method                                         |
| :- | :--------------------------------------------------------------------- | :---------------------------------------------------------- |
| 16 | Admin can create a daily special item/banner                           | Add special through admin panel.                            |
| 17 | Daily special is prominently displayed on customer menu page           | Open menu; banner visible.                                  |
| 18 | Banner displays promotional text and linked dish information           | Verify content shown correctly.                             |
| 19 | Only active specials are displayed                                     | Create active/inactive specials; verify filtering.          |
| 20 | Daily special automatically expires at midnight server time            | Simulate midnight or modify system time; banner disappears. |
| 21 | Expired specials are hidden from customers without manual intervention | Verify automatic removal.                                   |
| 22 | Admin can replace expired special with a new one                       | Create new special; verify display.                         |
| 23 | Banner layout remains responsive on mobile and desktop screens         | Test multiple screen sizes.                                 |

---

## 🚫 Dish Availability Toggle (Out of Stock)

This feature allows restaurant staff to instantly hide or disable unavailable dishes.

| #  | KPI                                                                      | Verification Method                                                   |
| :- | :----------------------------------------------------------------------- | :-------------------------------------------------------------------- |
| 24 | Admin can mark a dish as Out of Stock                                    | Toggle availability in admin panel.                                   |
| 25 | Out-of-stock status is saved in database                                 | Inspect database record.                                              |
| 26 | Customer menu visually indicates unavailable dishes                      | Open menu; unavailable badge visible.                                 |
| 27 | Customers cannot add out-of-stock dishes to cart                         | Attempt add-to-cart; action blocked.                                  |
| 28 | Availability changes update immediately on menu                          | Toggle stock state; verify customer view updates.                     |
| 29 | Admin can restore dish availability                                      | Enable stock again; dish becomes orderable.                           |
| 30 | Existing orders containing previously available dishes remain unaffected | Mark dish unavailable after order placement; order history preserved. |
| 31 | Availability state persists after application restart                    | Restart application; status retained.                                 |

---

## ⭐ Customer Ratings Per Dish (1–5 Stars)

This feature allows customers to rate menu items and helps restaurants identify popular dishes.

| #  | KPI                                                                                               | Verification Method                         |
| :- | :------------------------------------------------------------------------------------------------ | :------------------------------------------ |
| 32 | Customer can submit rating between 1 and 5 stars                                                  | Select rating; submit successfully.         |
| 33 | Rating validation prevents values below 1 or above 5                                              | Attempt invalid rating submission.          |
| 34 | Submitted rating is stored in database                                                            | Verify database entry.                      |
| 35 | Average rating is calculated correctly per dish                                                   | Submit multiple ratings; verify average.    |
| 36 | Average rating is displayed on dish cards/details page                                            | Open menu item; rating visible.             |
| 37 | Rating updates immediately after new submission                                                   | Submit rating; average refreshes.           |
| 38 | Total number of ratings is displayed alongside average score                                      | Verify count display.                       |
| 39 | Customer cannot submit duplicate ratings within the same session/order (if business rule enabled) | Attempt second rating; validation enforced. |
| 40 | Ratings remain visible after application restart                                                  | Restart application; ratings persist.       |

---

## 📱 Flutter Web UX & Responsiveness

| #  | KPI                                                      | Verification Method         |
| :- | :------------------------------------------------------- | :-------------------------- |
| 41 | Table ordering workflow functions on desktop browsers    | Test Chrome, Edge, Firefox. |
| 42 | Kitchen display renders correctly on tablet screens      | Verify responsive layout.   |
| 43 | Daily specials banner adapts to mobile viewports         | Test responsive design.     |
| 44 | Out-of-stock indicators remain readable on small screens | Verify mobile rendering.    |
| 45 | Star rating component is touch-friendly                  | Test on mobile browser.     |

---

## 🧪 Testing & Quality Assurance

| #  | KPI                                                                | Verification Method              |
| :- | :----------------------------------------------------------------- | :------------------------------- |
| 46 | Unit tests exist for table-number assignment logic                 | Execute test suite.              |
| 47 | Unit tests exist for dish availability toggle functionality        | Execute test suite.              |
| 48 | Unit tests exist for rating calculation logic                      | Execute test suite.              |
| 49 | Integration test covers full order flow from menu to kitchen panel | Run integration test.            |
| 50 | All enhancement-related tests pass successfully                    | Execute test command; all green. |

---

## 🚀 Enhancement Delivery Success Criteria

The enhancement implementation is considered complete only when:

* ✅ Table-number ordering is fully operational.
* ✅ Kitchen receives incoming orders in real time.
* ✅ Daily specials automatically expire at midnight.
* ✅ Out-of-stock dishes cannot be ordered.
* ✅ Customers can rate dishes using a 1–5 star system.
* ✅ All data persists correctly in the application's storage layer.
* ✅ All responsive and automated tests pass.
* ✅ No existing DigitalMenu functionality is broken by these enhancements.
