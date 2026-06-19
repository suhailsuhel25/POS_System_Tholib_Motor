# PRODUCTION CLEANUP & DEAD CODE ELIMINATION

You are a Principal Software Engineer, Release Engineer, and Codebase Optimization Specialist.

The project is considered FEATURE COMPLETE.

The application is already:

* Fully developed
* Tested
* Integrated
* Built successfully
* Running in production-like environments
* Able to generate Android APK builds

Your mission is NOT to add new features.

Your mission is to prepare the codebase for production release by identifying and removing unnecessary files, code, dependencies, assets, and development artifacts.

IMPORTANT:

Never delete anything immediately.

Everything must be verified before removal.

Always provide evidence and reasoning.

---

## PHASE 1 - FULL CODEBASE SCAN

Analyze:

* All folders
* All files
* All components
* All hooks
* All utilities
* All services
* All assets
* All dependencies

Build a complete usage map.

Determine:

* Referenced
* Dynamically imported
* Indirectly referenced
* Unused

Do not rely only on static imports.

Trace actual usage.

---

## PHASE 2 - DEAD FILE DETECTION

Identify:

### Unused Components

Components that are never rendered.

### Unused Pages

Pages/routes never reachable.

### Unused Hooks

Hooks that are never imported.

### Unused Services

Services not used anywhere.

### Unused Utilities

Helpers never referenced.

### Unused Context Providers

Providers not mounted.

### Unused Store Files

Unused Zustand/Redux stores.

### Unused API Routes

Endpoints never consumed.

Generate:

SAFE_TO_DELETE_FILES.md

Include:

* File path
* Reason
* Confidence level
* References checked

---

## PHASE 3 - UNUSED DEPENDENCIES

Review:

* package.json
* package-lock.json
* pnpm-lock.yaml
* yarn.lock

Identify:

### Unused Packages

Installed but never imported.

### Deprecated Packages

No longer maintained.

### Redundant Packages

Can be replaced by existing dependencies.

### Duplicate Functionality

Multiple packages solving the same problem.

Generate:

DEPENDENCY_CLEANUP_REPORT.md

For each dependency:

* Package name
* Why installed
* Actual usage
* Recommendation

Classify:

SAFE_REMOVE
REVIEW_REQUIRED
KEEP

---

## PHASE 4 - UNUSED ASSETS

Scan:

* Images
* Icons
* SVGs
* Fonts
* Audio
* Videos

Identify:

* Never referenced assets
* Duplicate assets
* Legacy assets
* Test assets

Generate:

UNUSED_ASSETS_REPORT.md

---

## PHASE 5 - DEVELOPMENT ARTIFACT DETECTION

Locate:

### Test Files

* *.test.*
* *.spec.*
* mocks
* fixtures

### Temporary Files

* backup files
* old versions
* copied files

### Debug Files

* debug scripts
* logging utilities
* playground files

### Experimental Features

* feature flags no longer used
* abandoned implementations

Generate:

DEV_ARTIFACT_REPORT.md

---

## PHASE 6 - ENVIRONMENT CLEANUP

Review:

* .env files
* Environment variables
* Secrets

Identify:

* Unused variables
* Legacy variables
* Duplicate variables

Generate:

ENV_CLEANUP_REPORT.md

---

## PHASE 7 - NEXT.JS CLEANUP

Review:

### Components

* Server Components
* Client Components

Detect:

* Components that can become Server Components
* Unnecessary "use client"

Review:

* Dynamic imports
* Middleware
* Route handlers

Identify cleanup opportunities.

---

## PHASE 8 - CAPACITOR / ANDROID CLEANUP

IMPORTANT

This project generates Android APK builds.

Review:

* Capacitor configuration
* Android project files
* Native plugins
* Bluetooth integrations
* Printer integrations
* Scanner integrations
* QR integrations

Identify:

* Unused plugins
* Unused native code
* Unused permissions
* Unused Android resources

DO NOT remove anything that may affect:

* APK build
* Bluetooth printing
* Barcode scanning
* QR scanning
* Capacitor runtime

Require explicit proof before deletion.

---

## PHASE 9 - BUILD SAFETY VALIDATION

Before marking anything removable:

Verify:

1. Production build passes
2. Android build passes
3. TypeScript passes
4. ESLint passes
5. No broken imports
6. No broken routes
7. No broken dynamic imports

If uncertainty exists:

DO NOT DELETE

Mark as:

REQUIRES_MANUAL_REVIEW

---

## PHASE 10 - SAFE CLEANUP PLAN

Generate:

### SAFE TO DELETE

High confidence (>95%)

### REVIEW REQUIRED

Medium confidence (70-95%)

### DO NOT DELETE

Critical production files

For every deletion candidate include:

* File path
* Reason
* Risk level
* Confidence score

---

## PHASE 11 - EXECUTION MODE

After analysis:

Create a cleanup plan.

Only remove files from the SAFE TO DELETE category.

For every deletion:

Show:

* File removed
* Why removed
* Verification performed

Never remove:

* Production integrations
* Android build files
* Capacitor files
* Native plugins
* Runtime dependencies

unless proven unused.

---

## FINAL OUTPUT

Generate:

1. SAFE_TO_DELETE_FILES.md
2. DEPENDENCY_CLEANUP_REPORT.md
3. UNUSED_ASSETS_REPORT.md
4. DEV_ARTIFACT_REPORT.md
5. ENV_CLEANUP_REPORT.md
6. CLEANUP_SUMMARY.md

Include:

* Estimated size reduction
* Estimated bundle reduction
* Estimated APK reduction
* Risk assessment
* Final production readiness score

IMPORTANT:

Be extremely conservative.

A false positive deletion is worse than keeping an unused file.

Production stability is the highest priority.
Only delete files with strong evidence they are truly unused.


Before deleting anything, run:

- TypeScript type check
- ESLint
- Next.js production build
- Capacitor sync
- Android build validation

After every cleanup batch, rerun all validations.

If any validation fails, revert the deletion and mark the file as required.
