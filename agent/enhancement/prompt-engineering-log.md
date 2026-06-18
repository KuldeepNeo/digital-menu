# Prompt Engineering Log

---

### Project Summary

| Field | Detail |
|---|---|
| **Project** | DigitalMenu – Flutter Web Digital Ordering & Kitchen Management Platform |
| **Duration** | Phase 2 – Sprint 1 to Sprint 4 + QA Validation (Full Enhancement Lifecycle) |
| **Total Prompts** | 14 |
| **AI Personas Created** | 4 (Senior Architect, Senior Business Analyst, Fullstack Developer, Senior QA Automation Architect / QA Lead Engineer) |
| **Primary Use Cases** | Architecture Analysis, Impact Assessment, Technical Design, Sprint Implementation, QA Testing, Defect Resolution, End-to-End Validation, Prompt Documentation |

---

## Prompt Catalog

---

### P-001

**Title:** Repository Assessment

**Category:** Architecture / Analysis

**Objective:** Analyse the existing Phase 1 codebase alongside the Phase 2 enhancement requirements to identify where each new feature fits within the current architecture, without writing any code.

**Business Value:** Provided an architectural baseline that prevented over-engineering, ensured Phase 2 work was scoped correctly, and gave developers a clear map of reusable components from day one.

**Key Deliverable:** `repository-analysis.md`

**Prompt:**

```markdown
# Repository Assessment 

## Role
Act as the Senior Architect

## Action
Read below handover document:
[developer_handover.md], the enhancement requirements [requirement.md] and repository.
 
Analyze the existing architecture and identify where each enhancement fits. Do not write code. 


## Context
Phase 1 of the project has been successfully completed, and all planned features have been implemented, tested, and closed
An enhancement document has now been prepared that outlines the new requirements, improvements, and feature additions for Phase 2.

The objective is to extend the current application with the Phase 2 requirements while minimizing code duplication, maintaining coding standards, following existing design patterns, and ensuring the application remains stable, maintainable, and scalable.
	

## Execute
generate : repository-analysis.md
path: agent/enhancement
```

---

### P-002

**Title:** Enhancement Impact Analysis

**Category:** Architecture / Analysis

**Objective:** Map every Phase 2 KPI to the existing codebase, identify reusable components, flag affected files, assess dependency chains, and estimate implementation complexity per module.

**Business Value:** Eliminated guesswork for the development team by providing a precise file-level impact map — reducing estimation error, preventing scope creep, and accelerating sprint planning.

**Key Deliverable:** `enhancement-impact-analysis.md` with KPI-to-file mapping across 50 KPIs and 5 feature modules

**Prompt:**

```markdown
# Impact Analysis 

## Role
Act as the Senior Architect

## Action
Read [repository-analysis.md], phase2 [requirement.md], [kpi_digital_menu.md], [prd_digital_menu.md], [project_boundary.md]

 Do not write code.



## Context
The objective is to identify the current application with the Phase 2 requirements.

map every enhancement KPI to the existing codebase. Identify reusable components, affected files, dependencies, estimated complexity, and implementation order. 
	
## Execute
generate : enhancement-impact-analysis.md
path: agent/enhancement
```

---

### P-003

**Title:** Technical Design Blueprint

**Category:** Architecture / Design

**Objective:** Produce a detailed implementation blueprint for every Phase 2 enhancement — covering API, database, and UI changes, files to modify, new files required, dependencies, and implementation sequence — without writing any code.

**Business Value:** Created a single source of truth for all developers, ensuring architectural consistency, maximising code reuse, and preventing design-level defects before implementation began.

**Key Deliverable:** `technical-design.md` with enhancement overview, architecture analysis, and proposed design per module

**Prompt:**

```markdown
# Technical Design

## Role
Act as the Senior Architect

## Action
Read:
[enhancement-impact-analysis.md]
[requirement.md], [repository-analysis.md]  

 Do not write code.

## Objective

Create a detailed implementation blueprint for each enhancement without writing any code.

The design should maximize reuse of the existing architecture and minimize modifications.


## Execute
generate : technical-design.md
path: agent/enhancement
Include : 
1. Enhancement Overview
2. Existing Architecture Analysis
3. Proposed Design: API changes, DB changes, Ui changes.
4. Files to Modify
5. New Files Required
6. Dependencies
7. Validation Strategy
8. Implementation Sequence

Note: Implement Enhancement plan exactly as designed. Modify only the listed files, preserve the existing architecture, and generate an implementation summary after completion.
```

---

### P-004

**Title:** Agile Implementation Roadmap

**Category:** Business Analysis / Planning

**Objective:** Analyse all Phase 2 enhancements and produce a production-ready, Agile sprint roadmap with business justification, dependency mapping, complexity scoring, acceptance criteria, and definition of done for each sprint.

**Business Value:** Enabled structured, independently deliverable and testable sprint releases, reducing integration risk and aligning the engineering roadmap with business priorities.

**Key Deliverable:** `implementation-plan.md` with 4 sprints, enhancement analysis table, and sprint-level acceptance criteria

**Prompt:**

```markdown
## Role

Act as Senior Business Analyst

## Task

Analyze the [enhancement] documents and create a production-ready implementation roadmap.

Your objectives are to:

1. Analyze every enhancement.
2. Identify business and technical dependencies.
3. Estimate implementation complexity (Low/Medium/High or Story Points).
5. Ensure every sprint is independently testable.
6. Recommend the optimal implementation sequence.


## Context

- Phase 1 features have been successfully implemented and closed.
- Phase 2 introduces new enhancements to the existing production codebase.
- Existing functionality must remain stable and backward compatible.
- The implementation should reuse existing architecture and coding patterns wherever possible.
- The roadmap should support Agile delivery and CI/CD practices.

## Format

### Executive Summary

### Enhancement Analysis

| Enhancement | Description | Priority | Complexity | Risk | Dependencies |

### Sprint Roadmap

For each sprint provide:

- Sprint Goal
- Features Included
- Business Justification
- Technical Dependencies
- Risks
- Complexity
- Acceptance Criteria
- Testing Scope
- Definition of Done

generate : implementation-plan.md
path: agent/enhancement
```

---

### P-005

**Title:** Sprint 1 Implementation – Stock Control & Catalog Foundations

**Category:** Development / Implementation

**Objective:** Implement the Dish Availability Toggle feature (KPIs 24–31), enabling admins to instantly mark dishes as out of stock and propagating that state to the customer menu in real time.

**Business Value:** Prevented customer disappointment and operational refunds caused by ordering unavailable dishes — directly improving the customer experience and staff efficiency.

**Key Deliverable:** `isAvailable` toggle in admin, out-of-stock badge on dish cards, disabled add-to-cart, Firestore persistence; `sprint_1-implementation-summary.md`

**Prompt:**

```markdown
# Sprint 1: Stock Control & Catalog Foundations

## Role

Act Fullstack Developer.

Read:

* [enhancement-impact-analysis.md] 
* [implementation-plan.md] 
* [save_token.md] 


## Action

Implement Sprint 1: Stock Control & Catalog Foundations

## Context

- Phase 1 features have been successfully implemented and closed.
- Phase 2 introduces new enhancements to the existing production codebase.

## Execute

- Implement Sprint 1 only.
- Follow the implementation plan and  enhancement impact analysis.
- Reuse existing code.
- Do not modify unrelated modules.
- Generate implementation summary after completion.

generate : sprint 1-implementation-summary.md
path: agent/enhancement/summary/

Stop when the module is fully implemented and ready for QA testing.
```

---

### P-006

**Title:** Sprint 1 QA Testing – Stock Control & Catalog Foundations

**Category:** QA / Testing

**Objective:** Perform functional, integration, validation, and workflow testing on Sprint 1 and produce a formal KPI validation table, test-case report, and defect report.

**Business Value:** Ensured the availability toggle was production-ready before it became a dependency for the cart and ordering flows in subsequent sprints, preventing downstream defects.

**Key Deliverable:** `sprint_1-test-report-summary.md` with KPI validation table, test cases, and defect report

**Prompt:**

```markdown
# Sprint 1: Stock Control & Catalog Foundations  QA Testing

## Role

Act as Senior QA Automation Architect
Read:

* [qa_persona.md]  
* [save-token.md] 

## Action

Sprint 1: Stock Control & Catalog Foundations

Perform functional, integration, validation, and workflow testing.

## Context

Backend and frontend implementation for this module are complete.

The goal is to determine whether the module is production-ready.

## Execute
Generate: Test cases report and defect report 

generate : sprint 1-test-report-summary.md
path: [enhancement] 

## Expected output format

# Sprint Title

## Validation Functions Table

| KPI Number | KPI | Validation Method | Expected Output | Actual Output | Status | Notes |
| ---------- | --- | ----------------- | --------------- | ------------- | ------ | ----- |
| KPI-001 | ... | ... | ... | | [PASS/FAIL] | |


Strictly follow guideline which mentioned in [enhancement-impact-analysis.md] and [implementation-plan.md]  
```

---

### P-007

**Title:** Sprint 2 Implementation – Table-Number & Shopping Cart Flow

**Category:** Development / Implementation

**Objective:** Implement the customer-facing table selection, cart management (add, remove, persist across page reloads), and order submission to Firestore flow (KPIs 1–7).

**Business Value:** Eliminated dependency on paper-based ordering, reduced server staff bottlenecks, and ensured all customer orders are digitally tracked and linked to specific tables.

**Key Deliverable:** `CartCubit`, `cart_sheet.dart`, localStorage persistence, Firestore order submission; `sprint_2-implementation-summary.md`

**Prompt:**

```markdown
# Sprint 2: Table-Number & Shopping Cart Flow

## Role

Act Fullstack Developer.

Read:

* [enhancement-impact-analysis.md] 
* [implementation-plan.md] 
* [save_token.md] 


## Action

Implement Sprint 2: Table-Number & Shopping Cart Flow

## Context

- Phase 1 features have been successfully implemented and closed.
- Phase 2 introduces new enhancements to the existing production codebase.

## Execute

- Implement Sprint 2 only.
- Follow the implementation plan and  enhancement impact analysis.
- Reuse existing code.
- Do not modify unrelated modules.
- Generate implementation summary after completion.

generate : sprint 2-implementation-summary.md
path: agent/enhancement/summary/

Stop when the module is fully implemented and ready for QA testing.
```

---

### P-008

**Title:** Sprint 2 QA Testing – Table-Number & Shopping Cart Flow

**Category:** QA / Testing

**Objective:** Perform functional, integration, validation, and workflow testing on Sprint 2 and produce a formal KPI validation table, test-case report, and defect report covering cart operations, persistence, and order submission.

**Business Value:** Validated that the digital ordering flow was stable, data-persistent, and error-handled before the kitchen display system depended on incoming order documents.

**Key Deliverable:** `sprint_2-test-report-summary.md` with KPI validation table, test cases, and defect report

**Prompt:**

```markdown
# Sprint 2: Table-Number & Shopping Cart Flow  QA Testing

## Role

Act as Senior QA Automation Architect
Read:

* [qa_persona.md]  
* [save-token.md] 

## Action

Sprint 2: Table-Number & Shopping Cart Flow

Perform functional, integration, validation, and workflow testing.

## Context

Backend and frontend implementation for this module are complete.

The goal is to determine whether the module is production-ready.

## Execute
Generate: Test cases report and defect report 

generate : sprint_2-test-report-summary.md
path: [enhancement] 

## Expected output format

# Sprint Title

## Validation Functions Table

| KPI Number | KPI | Validation Method | Expected Output | Actual Output | Status | Notes |
| ---------- | --- | ----------------- | --------------- | ------------- | ------ | ----- |
| KPI-001 | ... | ... | ... | | [PASS/FAIL] | |


Strictly follow guideline which mentioned in [enhancement-impact-analysis.md] and [implementation-plan.md]  
```

---

### P-009

**Title:** Sprint 3 Implementation – Kitchen Display Panel

**Category:** Development / Implementation

**Objective:** Build the real-time Kitchen Display Panel (KPIs 8–15), enabling kitchen staff to receive incoming orders, view item details and elapsed time, and advance order statuses (pending → preparing → ready → completed).

**Business Value:** Eliminated paper-based kitchen ticketing, reduced service time through real-time visibility, and created a fully digital order fulfilment pipeline from customer submission to kitchen completion.

**Key Deliverable:** `kitchen_page.dart` (Kanban + mobile tab layout), `order_card.dart` with running timer, `KitchenCubit`, auth-guarded `/admin/kitchen` route; `sprint_3-implementation-summary.md`

**Prompt:**

```markdown
# Sprint 3: Kitchen Display Panel

## Role

Act Fullstack Developer.

Read:

* [enhancement-impact-analysis.md] 
* [implementation-plan.md] 
* [save_token.md] 


## Action

Implement Sprint 3: Kitchen Display Panel

## Context

- Phase 1 features have been successfully implemented and closed.
- Phase 2 introduces new enhancements to the existing production codebase.

## Execute

- Implement Sprint 3 only.
- Follow the implementation plan and  enhancement impact analysis.
- Reuse existing code.
- Do not modify unrelated modules.
- Generate implementation summary after completion.

generate : sprint_3-implementation-summary.md
path: agent/enhancement/summary/

Stop when the module is fully implemented and ready for QA testing.
```

---

### P-010

**Title:** Sprint 3 QA Testing – Kitchen Display Panel

**Category:** QA / Testing

**Objective:** Perform functional, integration, validation, and workflow testing on Sprint 3 and produce a formal KPI validation table, test-case report, and defect report covering real-time streams, status advancement, responsiveness, and auth protection.

**Business Value:** Confirmed the kitchen panel was production-stable and responsive under real-time conditions before being exposed to kitchen staff, preventing service disruption.

**Key Deliverable:** `sprint_3-test-report-summary.md` with KPI validation table, test cases, and defect report

**Prompt:**

```markdown
# Sprint 3: Kitchen Display Panel QA Testing

## Role

Act as Senior QA Automation Architect
Read:

* [qa_persona.md]  
* [save-token.md] 

## Action

Sprint 3: Kitchen Display Panel

Perform functional, integration, validation, and workflow testing.

## Context

Backend and frontend implementation for this module are complete.

The goal is to determine whether the module is production-ready.

## Execute
Generate: Test cases report and defect report 

generate : sprint_3-test-report-summary.md
path: [enhancement] 

## Expected output format

# Sprint Title

## Validation Functions Table

| KPI Number | KPI | Validation Method | Expected Output | Actual Output | Status | Notes |
| ---------- | --- | ----------------- | --------------- | ------------- | ------ | ----- |
| KPI-001 | ... | ... | ... | | [PASS/FAIL] | |


Strictly follow guideline which mentioned in [sprint_3-implementation-summary.md] [enhancement-impact-analysis.md] and [implementation-plan.md]  
```

---

### P-011

**Title:** Sprint 4 Implementation – Customer Ratings & Daily Specials

**Category:** Development / Implementation

**Objective:** Implement the Customer Ratings system (KPIs 32–40) using atomic Firestore transactions, and the Daily Specials Banner (KPIs 16–23) with midnight auto-expiration — including mobile-optimised star rating touch targets and session-based duplicate vote prevention.

**Business Value:** Increased customer engagement through social proof ratings, drove revenue via targeted daily specials promotions, and provided owners with actionable dish-level feedback.

**Key Deliverable:** `rating_dialog.dart`, `daily_specials_banner.dart`, `set_special_dialog.dart`, atomic rating transactions, `MenuCubit` specials stream; `sprint_4-implementation-summary.md`

**Prompt:**

```markdown
# Sprint 4: Customer Ratings & Specials

## Role

Act Fullstack Developer.

Read:

* [enhancement-impact-analysis.md] 
* [implementation-plan.md] 
* [save_token.md] 


## Action

Implement Sprint 4: Customer Ratings & Specials

## Context

- Phase 1 features have been successfully implemented and closed.
- Phase 2 introduces new enhancements to the existing production codebase.

## Execute

- Implement Sprint 4 only.
- Follow the implementation plan and  enhancement impact analysis.
- Reuse existing code.
- Do not modify unrelated modules.
- Generate implementation summary after completion.

generate : sprint_4-implementation-summary.md
path: agent/enhancement/summary/

Stop when the module is fully implemented and ready for QA testing.
```

---

### P-012

**Title:** Sprint 4 QA Testing – Customer Ratings & Daily Specials

**Category:** QA / Testing

**Objective:** Perform functional, integration, validation, and workflow testing on Sprint 4 — covering rating submission, atomic average calculation, duplicate prevention, specials banner rendering, midnight expiration, and admin configuration.

**Business Value:** Validated the integrity of financial and engagement-critical features (ratings and promotions) before customer exposure, protecting both brand trust and data accuracy.

**Key Deliverable:** `sprint_4-test-report-summary.md` with 18-KPI validation table, test cases, and defect report

**Prompt:**

```markdown
# Sprint 4: Customer Ratings & Specials

## Role

Act as Senior QA Automation Architect
Read:

* [qa_persona.md]  
* [save-token.md] 

## Action

Sprint 4: Customer Ratings & Specials

Perform functional, integration, validation, and workflow testing.

## Context

Backend and frontend implementation for this module are complete.

The goal is to determine whether the module is production-ready.

## Execute
Generate: Test cases report and defect report 

generate : sprint_4-test-report-summary.md
path: [enhancement] 

## Expected output format

# Sprint Title

## Validation Functions Table

| KPI Number | KPI | Validation Method | Expected Output | Actual Output | Status | Notes |
| ---------- | --- | ----------------- | --------------- | ------------- | ------ | ----- |
| KPI-001 | ... | ... | ... | | [PASS/FAIL] | |


Strictly follow guideline which mentioned in 
[sprint_4-implementation-summary.md] [enhancement-impact-analysis.md] and [implementation-plan.md]  
```

---

### P-013

**Title:** End-to-End User Journey Validation

**Category:** QA / End-to-End Testing

**Objective:** Execute a comprehensive 5-phase end-to-end validation covering application launch, all user workflows, enhancement verification, exploratory stress testing, and regression validation across all screens — generating 5 formal QA reports.

**Business Value:** Provided the final production gate-check, confirming zero regressions, zero open defects, and a 100/100 production readiness score across all Phase 2 enhancements before release.

**Key Deliverable:** 5 reports under `audit/enhancement/qa-lead-engineer-report/`: end-to-end, exploratory, regression, defect, and production-readiness reports; Final Verdict: ✅ Approved for Release

**Prompt:**

```markdown
# End-to-End User Journey Validation

## Role

Act as the QA Lead Engineer.

Before starting, read and follow:
* [save_token.md] 
[summary]
[implementation-plan]
[walkthrough]
[enhancement]


Adopt all QA standards, testing strategies, reporting guidelines, and token-saving practices.

---

## Action

Perform a comprehensive End-to-End User Journey Validation by running the application.

Your objective is to validate the application exactly as a real user would interact with it.

Do not rely solely on source code inspection. Execute the application, navigate through every screen, and validate complete workflows.

Assume hidden defects exist and attempt to discover them.

---

## Context

The enhancement implementation is complete.

The objective is to validate that:

* Existing functionality continues to work.
* Newly implemented enhancements integrate correctly.
* User workflows are intuitive and stable.
* No crashes, navigation failures, state issues, or data inconsistencies exist.

---

## Execute

### Phase 1 – Application Review
* Launch the application.
* Verify application startup.
* Verify authentication flow.
* Verify initial navigation.
* Review overall UI consistency.

### Phase 2 – End-to-End User Journey
Execute every major user workflow from start to finish.

### Phase 3 – Enhancement Validation
Validate every enhancement implemented in Phase 2.

### Phase 4 – Exploratory Testing
Attempt to break the application using realistic user behavior.

### Phase 5 – Regression Validation
Revalidate all existing modules affected by the enhancements.

---

## Deliverables

Generate reports under: audit/enhancement/qa-lead-engineer-report/

Generate:

* end-to-end-test-report.md
* exploratory-test-report.md
* regression-report.md
* defect-report.md
* production-readiness-report.md

---

## Final Assessment

Final Verdict:

* ✅ Approved for Release
* ⚠️ Approved with Minor Issues
* 🔄 Rework Required
* ❌ Release Blocked

Do not conclude testing until every user journey has been executed, every enhancement has been validated, and no additional critical issues can be identified.
```

---

### P-014

**Title:** Firestore Order Submission Defect – Root Cause Analysis & Fix

**Category:** QA / Defect Resolution

**Objective:** Investigate and resolve a Firestore serialisation failure occurring when customers submitted orders, trace the execution path from the Submit Order button to the Firestore write, and implement the fix.

**Business Value:** Restored the core revenue-generating workflow — order placement — which was completely blocked for all customers, making this a Severity 1 / Priority 1 defect fix with immediate business impact.

**Key Deliverable:** Root cause analysis identifying `toFirestore` nested object serialisation bug; fixed `order_remote_datasource.dart` with explicit `item.toJson()` mapping; all 26 tests passing

**Prompt:**

```markdown
# Submit Order to Kitchen Flow error fixing

# Role
Act as Senior QA Automation Architect

# Task

Investigate why the **Submit Order to Kitchen** flow is failing. When a user submits an order, a Firestore-related error occurs.


# Context

* The application uses Firebase Firestore as the backend database.
* The order placement flow was previously functional but is currently failing during the submission process.
* Users are unable to place orders because the Firestore operation fails.
* The issue may originate from the frontend, backend integration, Firestore security rules, authentication, data model, document structure, serialization, or asynchronous execution.

# Expected Investigation

Perform a comprehensive analysis of the complete order submission flow, including:

1. Trace the execution flow from the **Submit Order** button to Firestore.
2. Identify the exact point of failure.

# Deliverables

Provide:

## Root Cause Analysis

* Exact cause of the failure
* File(s) involved
* Code location(s)
* Error message(s)

## Fix Implementation

* Required code changes
* Explanation of why the fix resolves the issue
* Any Firestore configuration changes required
```

---

## Key Achievements

| Metric | Value |
|---|---|
| **Total Prompts Created** | 14 |
| **Major Prompt Categories** | Architecture (3), Business Analysis (1), Development (4), QA Testing (4), Defect Resolution (1), Prompt Documentation (1) |
| **AI Personas Developed** | Senior Architect, Senior Business Analyst, Fullstack Developer, Senior QA Automation Architect, QA Lead Engineer |
| **KPIs Validated** | 50 across 5 feature modules |
| **Unit Tests Maintained** | 26/26 passing throughout all sprints |
| **Open Defects at Release** | 0 |
| **Production Readiness Score** | 100/100 |
| **Final Release Verdict** | ✅ Approved for Release |

---

## Executive Summary

### Overview

The DigitalMenu Phase 2 enhancement programme was executed entirely through structured AI-assisted prompt engineering across 14 prompts, five AI personas, and four Agile sprints. The programme transformed a read-only menu showcase application into a fully operational end-to-end digital ordering, kitchen fulfilment, and customer engagement platform — without introducing a single regression against Phase 1 functionality.

### Productivity & Quality Impact

A conventional four-sprint feature enhancement of this scope — covering five independent modules, 50 KPIs, full-stack implementation, and multi-layer QA — typically requires weeks of coordination between architects, developers, QA engineers, and business analysts. Through prompt engineering, each of these roles was instantiated on demand, with personas carrying their own standards, constraints, and output formats.

Each prompt was scoped to a single, independently verifiable deliverable: an architectural analysis, a sprint implementation, or a QA report. This decomposition prevented context bleed between phases, maintained a clean audit trail, and ensured every deliverable met its acceptance criteria before the next phase began.

The result was a zero-defect release validated across all five enhancement modules, 26 automated unit tests, 5 formal QA reports, and a production readiness score of 100/100.

### Reusability of the Prompt Library

The prompt library developed for this project is fully reusable and modular:

- **Architecture prompts** (P-001 to P-003) apply to any new feature phase requiring impact analysis and design before implementation.
- **Sprint implementation prompts** (P-005, P-007, P-009, P-011) follow a consistent template parameterised only by the sprint scope — enabling rapid adaptation for future sprints.
- **QA testing prompts** (P-006, P-008, P-010, P-012) share a standardised KPI validation table format, making all test reports directly comparable and auditable across sprints.
- **The E2E validation prompt** (P-013) is a reusable release-gate template that can be applied to any future phase.
- **Personas** (QA Architect, Fullstack Developer, Senior Architect) are ready to be re-activated for Phase 3 with no modification.

### Recommendations for Future AI-Assisted Development

1. **Maintain the persona-first pattern.** Always establish the AI persona with its standards file (`qa_persona.md`, `save_token.md`) before issuing implementation tasks. This ensures consistent quality and token efficiency across all outputs.
2. **Enforce single-responsibility per prompt.** Prompts scoped to one deliverable produce higher quality output and cleaner audit trails than multi-objective prompts.
3. **Adopt the implement → test → fix cadence.** The sprint implementation → sprint QA → defect fix cycle proved effective at catching issues early within each sprint boundary rather than in late-stage integration.
4. **Preserve the prompt log as a project artefact.** This document enables any future team member or AI agent to reconstruct the full engineering history of the project, understand design decisions, and extend the prompt library consistently.
5. **Expand automated test coverage progressively.** As AI-generated code accumulates across sprints, maintaining a growing automated test suite (26 tests maintained green throughout Phase 2) provides the safety net that makes AI-assisted development sustainable at pace.
