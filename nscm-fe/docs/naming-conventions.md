# Naming Conventions

## File Names

| Type               | Format     | Example                            |
| ------------------ | ---------- | ---------------------------------- |
| Components         | PascalCase | Button.tsx, ForecastPrice.tsx      |
| Utils/Hooks/Stores | camelCase  | useDebounce.ts, useSessionStore.ts |
| Folders            | kebab-case | forecast-price/, form-field/       |
| Types              | kebab-case | forecast-price.types.ts            |
| Constants          | kebab-case | app-config.ts                      |

## Import Paths

```typescript
// ✅ Correct
import { Button } from '@shared/components';
import { formatDate } from '@foundation/utils';

// ❌ Avoid
import { Button } from '../../../packages/shared/src/components/atoms/Button';
```

---

See README.md for more details.
