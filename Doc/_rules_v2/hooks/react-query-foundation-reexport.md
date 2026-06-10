# Hook — `@tanstack/react-query` 직접 import 금지

> 작성: 2026-06-10 (authority 의 AuthApproval/AuthRequest lint 사고 후)
> 상위 룰: `pre-write.md` / `post-write.md`
> 관련 hook: `relative-import-order.md`

---

## §0. 트리거

- 신규 FE 파일에 `useQueryClient`/`useQuery`/`useMutation`/`QueryClientProvider` 사용
- 기존 파일에 react-query 관련 import 추가/수정
- ESLint `no-restricted-imports` 오류 (`@tanstack/react-query` import is restricted`)

---

## §1. 안 됨 / 됨

| ❌ 안 됨 (lint error) | ✅ 됨 |
|---|---|
| `import { useQueryClient } from '@tanstack/react-query';` | `import { useQueryClient } from '@foundation/query-client';` |
| `import { useMutation, useQuery } from '@tanstack/react-query';` | `import { useMutation, useQuery } from '@foundation/query-client';` |
| `import { QueryClientProvider } from '@tanstack/react-query';` | `import { QueryClientProvider } from '@foundation/query-client';` |
| `import { PersistQueryClientProvider } from '@tanstack/react-query-persist-client';` | `import { PersistQueryClientProvider } from '@foundation/query-client';` |

## §2. Re-export 정의 위치

`packages/foundation/src/lib/query-client.ts`:
```typescript
export { PersistQueryClientProvider } from '@tanstack/react-query-persist-client';
export {
  type UseQueryOptions,
  QueryClientProvider,
  useQueryClient,
  useMutation,
  useQuery,
  useQueries,
  type UseQueryResult,
} from '@tanstack/react-query';
```

## §3. 왜 의무인가

1. **단일 source of truth** — react-query 버전 / config (queryClient instance) 가 `@foundation` 에 통일
2. **idb 기반 cache persistence** — `@foundation/query-client.ts` 가 sessionStorage + idb-keyval 설정 캡슐화
3. **세션 격리** — 동일 PC 의 다른 탭/window 가 cache 충돌 방지
4. **테스트 가능성** — provider mock 시 단일 진입점

## §4. 자기 점검 grep (PRE-WRITE / POST-WRITE)

```bash
# 신규 파일 작성 후 의무 grep — 0 매치 확인
grep -rn "from '@tanstack/react-query" {NEW_FILE_PATH}  # → 0 매치 의무
grep -rn "from \"@tanstack/react-query" {NEW_FILE_PATH}  # → 0 매치 의무

# 표준 사용 reference
grep -rn "from '@foundation/query-client'" packages/shared/src/hooks/ | head -5
```

## §5. import 그룹 위치 (relative-import-order.md 보강)

`@foundation/query-client` 는 `@foundation/*` 그룹에 위치:

```typescript
// 1) 외부 packages (alphabetical)
import { type FlexGrid } from '@mescius/wijmo.grid';
import { useEffect, useRef } from 'react';

// 2) @foundation/* (alphabetical)
import type { HotkeyConfig, PageProps } from '@foundation/models';
import { useQueryClient } from '@foundation/query-client';   // ← 여기

// 3) @shared/*
import { MainTitle, SubTitle } from '@shared/components';
import { useProcMutation, useTabProcQuery } from '@shared/hooks';

// 4) relative imports
import { MENU_ID, SHEETS } from './auth-approval.constants';
import type { ApprovalRow } from './auth-approval.types';
import { AuthApprovalForm } from './components/AuthApprovalForm';
```

## §6. 위반 시 lint 오류

```
error  '@tanstack/react-query' import is restricted from being used by a pattern.
       @foundation에서 re-export된 것을 쓰세요  no-restricted-imports
```

위반 = PR 머지 차단. PRE-WRITE 자기 점검 의무.
