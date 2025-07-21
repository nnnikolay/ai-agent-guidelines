# Frontend Development Guidelines for Feature-Based Architecture

## Purpose

These rules ensure maintainability, consistency, and developer velocity in feature-based frontend applications.

**MUST** rules are non-negotiable and must always be followed.
**SHOULD** rules are best practices that should be followed unless context suggests otherwise.

---

## 1 — Before Coding

- **BC-1 (MUST)** Understand the user problem before writing any code
- **BC-2 (SHOULD)** Identify which feature domain the work belongs to
- **BC-3 (SHOULD)** Consider if new shared components/utilities are needed or if existing ones can be reused
- **BC-4 (MUST)** Plan for error states, loading states, and edge cases upfront

---

## 2 — TypeScript & Type Safety

- **TS-1 (MUST)** Use strict TypeScript configuration
- **TS-2 (MUST)** Prefer `type` over `interface` unless interface merging is required
- **TS-3 (MUST)** Use branded types for domain-specific IDs and values
  ```ts
  type UserId = Brand<string, 'UserId'>
  type ProductId = Brand<string, 'ProductId'>
  ```
- **TS-4 (MUST)** Use `import type { ... }` for type-only imports
- **TS-5 (MUST)** Avoid `any` type - use `unknown` if type is truly unknown
- **TS-6 (SHOULD)** Use `const assertions` and `satisfies` for better type inference
- **TS-7 (MUST)** Type all API responses and external data interfaces

---

## 3 — Feature-Based Architecture

- **FA-1 (MUST)** Organize code by feature, not by file type
  ```
  src/
  ├── features/
  │   ├── auth/
  │   ├── dashboard/
  │   ├── user-profile/
  │   └── product-catalog/
  ├── shared/
  │   ├── components/
  │   ├── hooks/
  │   ├── utils/
  │   └── types/
  ```
- **FA-2 (MUST)** Keep feature-specific code within feature directories
- **FA-3 (MUST)** Place code in `shared/` only if used by 2+ features
- **FA-4 (SHOULD)** Each feature should have its own types, hooks, and components directories
- **FA-5 (MUST)** Features should not directly import from other features
- **FA-6 (SHOULD)** Use a feature's public API (index.ts) for cross-feature communication

---

## 4 — Component Design

- **CD-1 (MUST)** Keep components small and single-purpose
- **CD-2 (MUST)** Separate presentation components from business logic components
- **CD-3 (SHOULD)** Use composition over prop configuration
- **CD-4 (MUST)** Make components easily testable in isolation
- **CD-5 (SHOULD)** Extract custom hooks for reusable stateful logic
- **CD-6 (MUST)** Use meaningful prop names that reflect business domain
- **CD-7 (SHOULD)** Avoid prop drilling beyond 2-3 levels - use context or state management

---

## 5 — State Management

- **SM-1 (MUST)** Start with local component state, lift up only when needed
- **SM-2 (SHOULD)** Use reducers for complex state transitions within a feature
- **SM-3 (MUST)** Keep server state separate from client state
- **SM-4 (MUST)** Handle all async states: loading, success, error
- **SM-5 (SHOULD)** Use optimistic updates for better user experience where appropriate
- **SM-6 (MUST)** Make state updates immutable

---

## 6 — Data Fetching & APIs

- **API-1 (MUST)** Type all API request and response interfaces
- **API-2 (MUST)** Handle loading, error, and success states for all async operations
- **API-3 (MUST)** Implement proper error boundaries for component trees
- **API-4 (SHOULD)** Use proper HTTP status codes and handle them appropriately
- **API-5 (SHOULD)** Implement caching strategy appropriate for data freshness needs
- **API-6 (SHOULD)** Debounce user inputs that trigger API calls
- **API-7 (MUST)** Never expose sensitive API tokens or keys in frontend code

---

## 7 — Error Handling

- **EH-1 (MUST)** Use Error Boundaries to catch React component errors
- **EH-2 (MUST)** Handle async errors in useEffect properly
- **EH-3 (MUST)** Provide user-friendly error messages, not technical details
- **EH-4 (SHOULD)** Log errors with sufficient context for debugging
- **EH-5 (SHOULD)** Implement graceful degradation when non-critical features fail
- **EH-6 (MUST)** Never let unhandled promise rejections crash the app

---

## 8 — Testing

- **T-1 (MUST)** Test user behavior, not implementation details
- **T-2 (MUST)** Write integration tests for complete user flows within features
- **T-3 (SHOULD)** Unit test complex business logic and utility functions
- **T-4 (MUST)** Test error states and loading states
- **T-5 (MUST)** Mock external dependencies in tests
- **T-6 (SHOULD)** Use data-testid attributes for test targeting, not CSS classes
- **T-7 (MUST)** Ensure tests can run in isolation and are not order-dependent

---

## 9 — Performance

- **P-1 (SHOULD)** Use React.memo only when profiling shows it's beneficial
- **P-2 (SHOULD)** Apply useMemo and useCallback strategically, not everywhere
- **P-3 (MUST)** Implement lazy loading for routes and heavy components
- **P-4 (SHOULD)** Monitor and optimize bundle size regularly
- **P-5 (SHOULD)** Optimize images and assets for web delivery
- **P-6 (MUST)** Measure performance impact before implementing optimizations

---

## 10 — Code Quality

- **CQ-1 (MUST)** Use consistent naming conventions throughout the project
- **CQ-2 (MUST)** Keep functions pure and testable where possible
- **CQ-3 (SHOULD)** Prefer explicit code over clever code
- **CQ-4 (MUST)** Remove unused imports, variables, and code
- **CQ-5 (SHOULD)** Use meaningful variable and function names from business domain
- **CQ-6 (MUST)** Handle null/undefined values explicitly
- **CQ-7 (SHOULD)** Keep file lengths reasonable (under 300 lines typically)

---

## 11 — Accessibility

- **A11Y-1 (MUST)** Use semantic HTML elements appropriately
- **A11Y-2 (MUST)** Provide alt text for images and meaningful labels for form inputs
- **A11Y-3 (MUST)** Ensure keyboard navigation works for all interactive elements
- **A11Y-4 (MUST)** Maintain sufficient color contrast ratios
- **A11Y-5 (SHOULD)** Test with screen readers for critical user flows
- **A11Y-6 (MUST)** Use ARIA attributes correctly when semantic HTML isn't sufficient
