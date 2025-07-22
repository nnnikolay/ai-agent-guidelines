## Frontend Feature-Based Architecture Core Rules

ARCHITECTURE:
- FA: Organize by feature (/features/[name]/), not file type
- FA: Shared code only if used by 2+ features (/shared/)
- FA: No direct imports between features

TYPESCRIPT:
- TS: Strict mode, prefer 'type' over 'interface'
- TS: Brand domain IDs: type UserId = Brand<string, 'UserId'>
- TS: No 'any', use 'unknown' for truly unknown types

COMPONENTS:
- CD: Single purpose, <300 lines, composition over props
- CD: Separate presentation from business logic
- CD: Extract hooks for reusable stateful logic

STATE & API:
- SM: Start local, lift only when needed
- API: Type all requests/responses, handle loading/error/success
- API: Never expose keys/tokens in frontend

QUALITY:
- EH: User-friendly errors, use Error Boundaries
- T: Test behavior not implementation
- A11Y: Semantic HTML, keyboard nav, proper contrast

VERIFY: After implementation, check applied rules with /check-rules
