# Purpose
This document provides detailed explanations, examples, and rationale for each core rule. AI agents should reference specific sections when implementing features or when users need clarification.

## Table of Contents
1. [Architecture Rules (FA)](#architecture-rules)
2. [TypeScript Rules (TS)](#typescript-rules)
3. [Component Design (CD)](#component-design)
4. [State Management (SM)](#state-management)
5. [API & Data Fetching (API)](#api-data-fetching)
6. [Error Handling (EH)](#error-handling)
7. [Testing (T)](#testing)
8. [Performance (P)](#performance)
9. [Code Quality (CQ)](#code-quality)
10. [Accessibility (A11Y)](#accessibility)

---

## Architecture Rules

### FA-1: Feature-Based Organization
**Rule**: Organize code by feature, not by file type

**Why**: 
- Improves code discoverability
- Enables team ownership by feature
- Reduces merge conflicts
- Makes refactoring easier

**Example Structure**:
```
src/
├── features/
│   ├── user-profile/
│   │   ├── api/
│   │   │   ├── profile.api.ts
│   │   │   └── profile.types.ts
│   │   ├── components/
│   │   │   ├── ProfileCard.tsx
│   │   │   ├── ProfileForm.tsx
│   │   │   └── AvatarUpload.tsx
│   │   ├── hooks/
│   │   │   ├── useProfile.ts
│   │   │   └── useProfileUpdate.ts
│   │   ├── stores/
│   │   │   └── profile.store.ts
│   │   ├── utils/
│   │   │   └── validation.ts
│   │   └── index.ts  # Public API
│   └── dashboard/
├── shared/
│   ├── components/
│   │   ├── Button/
│   │   ├── Card/
│   │   └── Modal/
│   ├── hooks/
│   │   ├── useDebounce.ts
│   │   └── useLocalStorage.ts
│   └── utils/
│       └── formatters.ts
```

### FA-2: Shared Code Criteria
**Rule**: Place code in shared/ only if used by 2+ features

**Why**: Prevents premature abstraction and keeps features independent

**How to decide**:
1. Start in the feature that needs it
2. When another feature needs it, consider moving to shared
3. If only 2 features use it, consider if duplication is better

**Example**:
```typescript
// ❌ Bad: Moved to shared too early
// shared/components/UserAvatar.tsx

// ✅ Good: Keep in feature until needed elsewhere
// features/user-profile/components/Avatar.tsx

// When needed by features/comments/, then move to:
// shared/components/Avatar/
```

---

## TypeScript Rules

### TS-1: Strict Configuration
**Rule**: Use strict TypeScript configuration

**Required tsconfig.json settings**:
```json
{
  "compilerOptions": {
    "strict": true,
    "noImplicitAny": true,
    "strictNullChecks": true,
    "strictFunctionTypes": true,
    "strictBindCallApply": true,
    "strictPropertyInitialization": true,
    "noImplicitThis": true,
    "alwaysStrict": true,
    "noUnusedLocals": true,
    "noUnusedParameters": true,
    "noImplicitReturns": true,
    "noFallthroughCasesInSwitch": true
  }
}
```

### TS-2: Type vs Interface
**Rule**: Prefer 'type' over 'interface' unless interface merging is required

**Why**: Types are more flexible and consistent

**Examples**:
```typescript
// ✅ Good: Using type
type User = {
  id: string
  name: string
  email: string
}

type UserWithPosts = User & {
  posts: Post[]
}

// ❌ Avoid: Interface unless needed
interface IUser {
  id: string
  name: string
}

// ✅ Good: Interface when merging is needed
interface Window {
  myCustomGlobal: string
}
```

### TS-3: Branded Types
**Rule**: Use branded types for domain-specific values

**Implementation**:
```typescript
// Brand utility type
type Brand<T, TBrand> = T & { __brand: TBrand }

// Domain types
type UserId = Brand<string, 'UserId'>
type ProductId = Brand<string, 'ProductId'>
type Email = Brand<string, 'Email'>

// Usage
function getUser(id: UserId): User { /* ... */ }

// Type safety
const userId = 'user123' as UserId
const productId = 'prod456' as ProductId

getUser(userId) // ✅ OK
getUser(productId) // ❌ Type error
```

---

## Component Design

### CD-1: Single Purpose Components
**Rule**: Keep components small and single-purpose

**Why**: Easier to test, reuse, and understand

**Example**:
```typescript
// ❌ Bad: Multiple responsibilities
function UserProfile() {
  // Fetching data
  const [user, setUser] = useState()
  useEffect(() => { /* fetch */ }, [])
  
  // Form handling
  const [formData, setFormData] = useState()
  
  // Modal state
  const [showModal, setShowModal] = useState(false)
  
  // Everything mixed together
  return (
    <div>
      {/* Profile display */}
      {/* Edit form */}
      {/* Delete modal */}
    </div>
  )
}

// ✅ Good: Separated concerns
function UserProfile() {
  const { user, loading, error } = useUser()
  
  if (loading) return <ProfileSkeleton />
  if (error) return <ProfileError error={error} />
  
  return (
    <div>
      <ProfileDisplay user={user} />
      <ProfileActions userId={user.id} />
    </div>
  )
}

function ProfileDisplay({ user }: { user: User }) {
  return (/* Just display logic */)
}

function ProfileActions({ userId }: { userId: UserId }) {
  return (/* Just action buttons */)
}
```

### CD-2: Presentation vs Business Logic
**Rule**: Separate presentation components from business logic

**Pattern**:
```typescript
// Presentation Component (UI only)
interface ButtonProps {
  label: string
  onClick: () => void
  loading?: boolean
  variant?: 'primary' | 'secondary'
}

function Button({ label, onClick, loading, variant = 'primary' }: ButtonProps) {
  return (
    <button 
      className={`btn btn-${variant}`}
      onClick={onClick}
      disabled={loading}
    >
      {loading ? <Spinner /> : label}
    </button>
  )
}

// Business Logic Component (Container)
function SaveProfileButton() {
  const { saveProfile, saving } = useProfileActions()
  
  return (
    <Button
      label="Save Profile"
      onClick={saveProfile}
      loading={saving}
      variant="primary"
    />
  )
}
```

---

## State Management

### SM-1: Progressive State Lifting
**Rule**: Start with local component state, lift up only when needed

**Decision flow**:
```
1. Start with useState in component
2. If sibling needs it → lift to parent
3. If cousin needs it → consider context
4. If many components need it → global state
```

**Example progression**:
```typescript
// Step 1: Local state
function SearchBox() {
  const [query, setQuery] = useState('')
  return <input value={query} onChange={e => setQuery(e.target.value)} />
}

// Step 2: Lifted to parent (sibling needs it)
function SearchSection() {
  const [query, setQuery] = useState('')
  return (
    <>
      <SearchBox query={query} onQueryChange={setQuery} />
      <SearchResults query={query} />
    </>
  )
}

// Step 3: Context (multiple components need it)
const SearchContext = createContext<SearchContextType>(null)

function SearchProvider({ children }) {
  const [query, setQuery] = useState('')
  return (
    <SearchContext.Provider value={{ query, setQuery }}>
      {children}
    </SearchContext.Provider>
  )
}
```

### SM-2: Complex State Transitions
**Rule**: Use reducers for complex state transitions

**When to use reducer**:
- Multiple sub-values that change together
- Next state depends on previous state
- Complex update logic
- Need to track state history

**Example**:
```typescript
type FormState = {
  values: FormValues
  errors: FormErrors
  touched: Set<string>
  submitting: boolean
}

type FormAction =
  | { type: 'SET_FIELD'; field: string; value: any }
  | { type: 'SET_ERRORS'; errors: FormErrors }
  | { type: 'SUBMIT_START' }
  | { type: 'SUBMIT_SUCCESS' }
  | { type: 'SUBMIT_FAILURE'; error: Error }

function formReducer(state: FormState, action: FormAction): FormState {
  switch (action.type) {
    case 'SET_FIELD':
      return {
        ...state,
        values: { ...state.values, [action.field]: action.value },
        touched: new Set([...state.touched, action.field])
      }
    case 'SUBMIT_START':
      return { ...state, submitting: true, errors: {} }
    // ... other cases
  }
}
```

---

## API & Data Fetching

### API-1: Type All API Interfaces
**Rule**: Type all API request and response interfaces

**Example**:
```typescript
// API Types
type CreateUserRequest = {
  name: string
  email: Email
  role: UserRole
}

type CreateUserResponse = {
  user: User
  token: string
}

type ApiError = {
  code: string
  message: string
  details?: Record<string, string>
}

// API Client
class UserAPI {
  async createUser(data: CreateUserRequest): Promise<CreateUserResponse> {
    const response = await fetch('/api/users', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(data)
    })
    
    if (!response.ok) {
      const error: ApiError = await response.json()
      throw new ApiException(error)
    }
    
    return response.json()
  }
}
```

### API-2: Handle All Async States
**Rule**: Handle loading, error, and success states for all async operations

**Pattern**:
```typescript
function useUser(userId: UserId) {
  const [state, setState] = useState<{
    data: User | null
    loading: boolean
    error: Error | null
  }>({
    data: null,
    loading: true,
    error: null
  })

  useEffect(() => {
    let cancelled = false

    async function fetchUser() {
      try {
        setState(prev => ({ ...prev, loading: true, error: null }))
        const user = await userAPI.getUser(userId)
        
        if (!cancelled) {
          setState({ data: user, loading: false, error: null })
        }
      } catch (error) {
        if (!cancelled) {
          setState({ data: null, loading: false, error: error as Error })
        }
      }
    }

    fetchUser()
    return () => { cancelled = true }
  }, [userId])

  return state
}

// Usage
function UserProfile({ userId }: { userId: UserId }) {
  const { data: user, loading, error } = useUser(userId)

  if (loading) return <ProfileSkeleton />
  if (error) return <ErrorMessage error={error} />
  if (!user) return <NotFound />
  
  return <Profile user={user} />
}
```

---

## Error Handling

### EH-1: Error Boundaries
**Rule**: Use Error Boundaries to catch React component errors

**Implementation**:
```typescript
class ErrorBoundary extends Component<
  { children: ReactNode; fallback: ComponentType<{ error: Error }> },
  { hasError: boolean; error: Error | null }
> {
  state = { hasError: false, error: null }

  static getDerivedStateFromError(error: Error) {
    return { hasError: true, error }
  }

  componentDidCatch(error: Error, errorInfo: ErrorInfo) {
    console.error('Error caught by boundary:', error, errorInfo)
    // Send to error tracking service
    errorTracker.captureException(error, { extra: errorInfo })
  }

  render() {
    if (this.state.hasError && this.state.error) {
      const Fallback = this.props.fallback
      return <Fallback error={this.state.error} />
    }

    return this.props.children
  }
}

// Usage
function App() {
  return (
    <ErrorBoundary fallback={AppErrorFallback}>
      <Router>
        <Routes>
          {/* Your routes */}
        </Routes>
      </Router>
    </ErrorBoundary>
  )
}
```

### EH-2: useEffect Error Handling
**Rule**: Handle async errors in useEffect properly

**Pattern**:
```typescript
useEffect(() => {
  let mounted = true

  async function loadData() {
    try {
      const data = await fetchData()
      if (mounted) {
        setData(data)
      }
    } catch (error) {
      if (mounted) {
        setError(error as Error)
        // Don't just console.log - handle the error!
        showErrorNotification({
          message: 'Failed to load data',
          action: { label: 'Retry', onClick: loadData }
        })
      }
    }
  }

  loadData()
  
  return () => { mounted = false }
}, [deps])
```

---

## Testing

### T-1: Test Behavior, Not Implementation
**Rule**: Test user behavior, not implementation details

**Examples**:
```typescript
// ❌ Bad: Testing implementation
test('should call setUser with new data', () => {
  const setUser = jest.fn()
  const { getByRole } = render(<UserForm setUser={setUser} />)
  
  fireEvent.change(getByRole('textbox', { name: /name/i }), {
    target: { value: 'John' }
  })
  
  expect(setUser).toHaveBeenCalledWith({ name: 'John' })
})

// ✅ Good: Testing behavior
test('user can update their profile', async () => {
  const user = userEvent.setup()
  render(<UserProfile />)
  
  // User clicks edit
  await user.click(screen.getByRole('button', { name: /edit profile/i }))
  
  // User updates name
  const nameInput = screen.getByLabelText(/name/i)
  await user.clear(nameInput)
  await user.type(nameInput, 'John Doe')
  
  // User saves
  await user.click(screen.getByRole('button', { name: /save/i }))
  
  // Verify the result the user sees
  expect(await screen.findByText('Profile updated successfully')).toBeInTheDocument()
  expect(screen.getByText('John Doe')).toBeInTheDocument()
})
```

### T-2: Integration Tests for Features
**Rule**: Write integration tests for complete user flows

**Example**:
```typescript
describe('User Registration Flow', () => {
  test('new user can successfully register and access dashboard', async () => {
    const user = userEvent.setup()
    
    // Start at registration
    render(<App />, { route: '/register' })
    
    // Fill registration form
    await user.type(screen.getByLabelText(/email/i), 'user@example.com')
    await user.type(screen.getByLabelText(/password/i), 'SecurePass123!')
    await user.type(screen.getByLabelText(/confirm password/i), 'SecurePass123!')
    
    // Submit form
    await user.click(screen.getByRole('button', { name: /create account/i }))
    
    // Verify redirect to dashboard
    await waitFor(() => {
      expect(window.location.pathname).toBe('/dashboard')
    })
    
    // Verify user sees welcome message
    expect(await screen.findByText(/welcome, user@example\.com/i)).toBeInTheDocument()
    
    // Verify user data is loaded
    expect(await screen.findByText(/your projects/i)).toBeInTheDocument()
  })
})
```

---

## Performance

### P-1: Strategic React.memo
**Rule**: Use React.memo only when profiling shows it's beneficial

**When to use**:
1. Component renders frequently with same props
2. Component has expensive render logic
3. Parent re-renders often but child's props rarely change

**Example**:
```typescript
// ❌ Bad: Memo everything
const Button = memo(({ label, onClick }) => (
  <button onClick={onClick}>{label}</button>
))

// ✅ Good: Memo when beneficial
const ExpensiveChart = memo(({ data, options }) => {
  // Complex calculations
  const processedData = useMemo(() => 
    processChartData(data, options), [data, options]
  )
  
  return <ChartLibrary data={processedData} />
}, (prevProps, nextProps) => {
  // Custom comparison if needed
  return (
    prevProps.data.id === nextProps.data.id &&
    prevProps.options.theme === nextProps.options.theme
  )
})
```

### P-2: Strategic Memoization
**Rule**: Apply useMemo and useCallback strategically

**Guidelines**:
```typescript
// ❌ Bad: Over-memoization
function Component() {
  const value = useMemo(() => 1 + 1, []) // Unnecessary
  const handler = useCallback(() => console.log('click'), []) // Probably unnecessary
}

// ✅ Good: Strategic memoization
function DataGrid({ rows, columns }) {
  // Expensive computation
  const sortedData = useMemo(() => 
    sortDataByColumns(rows, columns), 
    [rows, columns]
  )
  
  // Callback passed to many children
  const handleCellEdit = useCallback((rowId: string, field: string, value: any) => {
    updateRow(rowId, { [field]: value })
  }, [updateRow])
  
  return (
    <Grid 
      data={sortedData} 
      onCellEdit={handleCellEdit}
    />
  )
}
```

---

## Code Quality

### CQ-1: Naming Conventions
**Rule**: Use consistent naming conventions

**Standards**:
```typescript
// Files
UserProfile.tsx          // React components (PascalCase)
useUserData.ts          // Hooks (camelCase with 'use' prefix)
userProfile.utils.ts    // Utilities (camelCase)
UserProfile.test.tsx    // Tests (match source file)
user.types.ts           // Type definitions (contextual)

// Variables
const MAX_RETRY_COUNT = 3        // Constants (UPPER_SNAKE_CASE)
const userId: UserId             // Variables (camelCase)
const isLoading: boolean         // Booleans (is/has/should prefix)

// Functions
function calculateTotalPrice() {} // Actions (verb)
function getUserById() {}         // Getters (get prefix)
function isValidEmail() {}        // Predicates (is/has prefix)

// Types/Interfaces
type User = {}                   // Types (PascalCase)
type UserMap = Map<UserId, User> // Descriptive type names

// React Components
function UserProfile() {}        // Components (PascalCase)
function useUserData() {}        // Hooks (camelCase with 'use')
```

### CQ-2: Pure Functions
**Rule**: Keep functions pure and testable where possible

**Example**:
```typescript
// ❌ Impure function
let userCount = 0
function createUser(name: string) {
  userCount++ // Side effect
  const timestamp = Date.now() // Non-deterministic
  return {
    id: `user_${userCount}`,
    name,
    createdAt: timestamp
  }
}

// ✅ Pure function
function createUser(
  name: string, 
  idGenerator: () => string,
  timestamp: number
): User {
  return {
    id: idGenerator(),
    name,
    createdAt: timestamp
  }
}

// Usage
const user = createUser(
  'John',
  () => generateUserId(),
  Date.now()
)
```

---

## Accessibility

### A11Y-1: Semantic HTML
**Rule**: Use semantic HTML elements appropriately

**Examples**:
```typescript
// ❌ Bad: Divs for everything
<div onClick={handleClick}>Click me</div>
<div className="header">
  <div className="nav">...</div>
</div>

// ✅ Good: Semantic elements
<button onClick={handleClick}>Click me</button>
<header>
  <nav aria-label="Main navigation">
    <ul>
      <li><a href="/home">Home</a></li>
      <li><a href="/about">About</a></li>
    </ul>
  </nav>
</header>

// Form example
<form onSubmit={handleSubmit}>
  <fieldset>
    <legend>Personal Information</legend>
    
    <label htmlFor="name">
      Name <span aria-label="required">*</span>
    </label>
    <input 
      id="name" 
      type="text" 
      required 
      aria-describedby="name-error"
    />
    <span id="name-error" role="alert" aria-live="polite">
      {errors.name}
    </span>
  </fieldset>
</form>
```

### A11Y-2: Interactive Elements
**Rule**: Ensure keyboard navigation and screen reader support

**Implementation**:
```typescript
function AccessibleModal({ isOpen, onClose, title, children }) {
  const closeButtonRef = useRef<HTMLButtonElement>(null)
  
  // Trap focus within modal
  useEffect(() => {
    if (isOpen) {
      closeButtonRef.current?.focus()
    }
  }, [isOpen])
  
  if (!isOpen) return null
  
  return (
    <div
      role="dialog"
      aria-modal="true"
      aria-labelledby="modal-title"
      onKeyDown={(e) => {
        if (e.key === 'Escape') onClose()
      }}
    >
      <div className="modal-backdrop" onClick={onClose} />
      <div className="modal-content">
        <h2 id="modal-title">{title}</h2>
        <button
          ref={closeButtonRef}
          onClick={onClose}
          aria-label="Close dialog"
          className="close-button"
        >
          ×
        </button>
        {children}
      </div>
    </div>
  )
}
```
