# Phase 2 Agile Implementation Roadmap

**Role:** Senior Business Analyst  
**Project:** DigitalMenu  
**Version:** 2.0  
**Date:** 2026-06-15  

---

## Executive Summary

To support the successful release of **DigitalMenu Phase 2**, this document outlines the business and technical roadmap. The goal is to evolve the application from a read-only menu showcase into an end-to-end digital ordering, kitchen fulfillment, and customer engagement platform. 

Every sprint is designed to deliver a **Minimum Viable Feature (MVF)** that is independently buildable, deployable, and testable. The sequence prioritizes low-complexity features first to establish stable data models, followed by high-value transactional features. Existing Phase 1 functions (such as admin login, dish addition, validation, and categories loading) remain backward compatible throughout this cycle.

---

## Enhancement Analysis

The five Phase 2 enhancements are analyzed below, evaluating business value, engineering complexity, and risks:

| Enhancement | Description | Priority | Complexity | Risk | Dependencies |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **Dish Availability Toggle** | Enable staff to toggle dishes "Out of Stock" instantly, disabling them from ordering. | High | Low | Low | Existing `dishes` collection in Firestore. |
| **Table-Number Ordering** | Customers add items to a cart associated with a table number. Cart persists on page reload. | Critical | Medium | Medium | Availability toggle status. Browser LocalStorage API. |
| **Kitchen Display Panel** | Real-time chronological dashboard for kitchen staff to receive and advance order statuses. | Critical | High | Medium | Table-Number ordering system (requires order documents). |
| **Customer Ratings** | 1-5 star ratings system per dish, updating average ratings atomically via transactions. | Medium | Medium | High | Cart/Order confirmation (rating session lock). |
| **Daily Specials Banner** | Promotional banner highlighting a dish that automatically expires at midnight. | Medium | Medium | Low | Dish Catalog model. Timestamp calculations. |

---

## Sprint Roadmap

---

### Sprint 1: Stock Control & Catalog Foundations
* **Sprint Goal:** Provide menu managers with immediate stock control and update customer layouts to prevent placing orders for unavailable items.
* **Features Included:** Dish Availability Toggle (Out of Stock).
* **Business Justification:** Prevents customer disappointment and operational refunds due to ordering unavailable items. It serves as the baseline for introducing new data models.
* **Technical Dependencies:** Existing Firestore `dishes` collection schema.
* **Risks:** 
  * Network delay during toggle updates. (Mitigated by using BLoC stream listeners for real-time optimistic updates).
* **Complexity:** 2 Story Points (Low)
* **Acceptance Criteria:**
  * GIVEN an admin is logged in, WHEN they toggle the availability switch on a dish card, THEN the `isAvailable` boolean changes in Firestore.
  * GIVEN a customer is browsing the menu, WHEN a dish is toggled off by admin, THEN the customer-facing card instantly dims and displays an "Out of Stock" badge.
  * GIVEN an unavailable dish, WHEN rendering the UI, THEN the "Add to Cart" button is disabled/hidden.
* **Testing Scope:**
  * Unit tests in `AdminDishCubit` checking toggle execution.
  * Widget tests in `DishCard` verifying dimmed layouts when `isAvailable == false`.
* **Definition of Done:**
  * Code passes static analysis (`flutter analyze`).
  * Unit tests are written and achieve 100% green status.
  * Firestore database fields are successfully seeded with default availability flags.

---

### Sprint 2: Table-Number & Shopping Cart Flow
* **Sprint Goal:** Enable dining-in customers to select a table number, build a shopping cart, and submit digital order requests.
* **Features Included:** Table-Number Ordering Flow.
* **Business Justification:** Speeds up order placement times, reduces server staff bottlenecks, and ensures all orders are linked to active dine-in tables.
* **Technical Dependencies:** Sprint 1 stock control (disables addition of out-of-stock items to cart).
* **Risks:**
  * Loss of cart contents during accidental page refreshes. (Mitigated by persisting JSON payloads to `localStorage` inside `CartCubit` state modifications).
* **Complexity:** 5 Story Points (Medium)
* **Acceptance Criteria:**
  * GIVEN a URL parameter `?table=X`, WHEN the customer accesses the menu, THEN the table selection is pre-loaded as table `X`.
  * GIVEN a customer is on the menu page, WHEN they add items, THEN a sticky cart bar appears showing the item count and sum.
  * GIVEN checkout is selected, WHEN no table number is set, THEN the app halts checkout and presents an error banner.
  * GIVEN a checkout submit, WHEN the payload is valid, THEN the order document is logged into Firestore collection `/orders` with status `"pending"`.
* **Testing Scope:**
  * Unit tests for `CartCubit` (add, remove, clear, and table parameter parsing logic).
  * Session recovery mock tests confirming persistence over simulated refreshes.
* **Definition of Done:**
  * Cart state machine is fully decoupled from menu rendering.
  * Checkout fails gracefully under poor network conditions without crashing the client.
  * Storage cleanup executes automatically post-checkout.

---

### Sprint 3: Kitchen Display Panel
* **Sprint Goal:** Create a real-time chronological dashboard for kitchen staff to process incoming orders and update statuses.
* **Features Included:** Kitchen Display – Incoming Orders Panel.
* **Business Justification:** Eliminates paper ticketing, provides the kitchen with real-time order streams, and improves service time tracking.
* **Technical Dependencies:** Sprint 2 (requires active order writes to Firestore).
* **Risks:**
  * Order congestion or delays under high-volume spikes. (Mitigated by streaming only active orders: `pending`, `preparing`, and `ready` states).
* **Complexity:** 8 Story Points (High)
* **Acceptance Criteria:**
  * GIVEN a customer places a valid order, WHEN the kitchen display is loaded, THEN the order appears instantly at the top of the queue.
  * GIVEN an active order, WHEN the kitchen staff selects "Preparing" or "Ready", THEN the Firestore state changes atomically and reflects instantly on the UI.
  * GIVEN orders on the screen, WHEN in tablet/desktop viewports, THEN cards wrap responsively and order details (quantities, time elapsed) remain readable.
* **Testing Scope:**
  * Real-time stream mock tests in `KitchenCubit`.
  * Widget integration tests simulating order fulfillment steps.
* **Definition of Done:**
  * Route `/admin/kitchen` is successfully protected under GoRouter's Auth Guard redirect.
  * All order cards include a running UI duration counter.
  * Layout renders responsively with no text clipping on standard tablet devices.

---

### Sprint 4: Customer Ratings & Specials
* **Sprint Goal:** Introduce the daily specials expiring banner and the dish rating feedback transaction logic.
* **Features Included:** Daily Specials Banner & Customer Ratings.
* **Business Justification:** Banners drive order volumes for high-margin specials, while ratings provide critical feedback to owners on menu items.
* **Technical Dependencies:** Sprint 1 database updates.
* **Risks:**
  * Concurrency issues when calculating average scores. (Mitigated by updating rating totals and sums via atomic Firestore Transactions).
  * Double voting. (Mitigated by locking the rated dish list in browser local storage).
* **Complexity:** 8 Story Points (High)
* **Acceptance Criteria:**
  * GIVEN a promotional item created by admin, WHEN the customer launches the menu, THEN the top banner highlights the daily special.
  * GIVEN a special is set to expire, WHEN the client clock passes midnight, THEN the special banner is removed instantly.
  * GIVEN a customer submits a score between 1–5, WHEN transaction executes, THEN average scores and review counts update immediately on the dish card.
  * GIVEN a rated dish, WHEN the customer tries to rate it again, THEN submission is blocked.
* **Testing Scope:**
  * Arithmetic validation tests for average scores.
  * Time-warp mock tests confirming specials expiration.
* **Definition of Done:**
  * Ratings transaction functions atomically and handles connection dropouts.
  * Star rating touch targets are optimized for mobile screens (at least 48x48 pixels).
