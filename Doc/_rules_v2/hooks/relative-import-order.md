# Hook — Relative imports 알파벳/계층 순서 정렬

> 작성: 2026-06-10 (AuthApproval.tsx import/order lint 사고 후)
> 상위 룰: `pre-write.md` / `post-write.md`
> 관련 hook: `react-query-foundation-reexport.md`

---

## §0. 트리거

- 신규 FE 파일 import 영역 작성
- 기존 파일 import 줄 추가/이동
- ESLint `import/order` 오류 (relative import 순서 위반)

---

## §1. relative imports 정렬 룰

### 1.1 기본 원칙
- **현 폴더 (./auth-approval.constants) → 하위 폴더 (./components/Xxx) 순서**
- 같은 계층 안에서는 알파벳 순

### 1.2 4-그룹 import 표준 (전체)

```typescript
// 1) 외부 packages (alphabetical, '@'-prefixed first/last 는 eslint config 따름)
import { type FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useRef } from 'react';

// 2) @foundation/* (alphabetical)
import type { HotkeyConfig, PageProps } from '@foundation/models';
import { useQueryClient } from '@foundation/query-client';
import { GridUtils } from '@foundation/utils';

// 3) @shared/* (alphabetical)
import { MainTitle, SubTitle } from '@shared/components';
import { useProcMutation, useTabProcQuery } from '@shared/hooks';
import { Button, TitleArea } from '@shared/lges';
import { useMessageStore } from '@shared/stores';

// 4) relative imports — 현 폴더 → 하위 폴더 (alphabetical)
import { MENU_ID, SHEETS } from './auth-approval.constants';
import type { ApprovalRow } from './auth-approval.types';
import { AuthApprovalForm } from './components/AuthApprovalForm';
import { AuthApprovalGrid } from './components/AuthApprovalGrid';
import { useAuthApprovalStore } from './useAuthApprovalStore';
```

## §2. 위반 사례 (실제 발생)

### 2.1 사고 — AuthApproval.tsx (2026-06-10)
```typescript
// ❌ 잘못된 순서 (lint error)
import { AuthApprovalForm } from './components/AuthApprovalForm';   // 하위 폴더 먼저
import { AuthApprovalGrid } from './components/AuthApprovalGrid';
import { MENU_ID, SHEETS } from './auth-approval.constants';        // 현 폴더 나중 ❌
import type { ApprovalRow } from './auth-approval.types';
import { useAuthApprovalStore } from './useAuthApprovalStore';
```

ESLint 오류:
```
error  `./auth-approval.constants` import should occur before import of `./components/AuthApprovalForm`   import/order
error  `./auth-approval.types` type import should occur before import of `./components/AuthApprovalForm`  import/order
```

### 2.2 fix
```typescript
// ✅ 정확한 순서
import { MENU_ID, SHEETS } from './auth-approval.constants';     // 현 폴더 먼저
import type { ApprovalRow } from './auth-approval.types';
import { AuthApprovalForm } from './components/AuthApprovalForm'; // 하위 폴더 나중
import { AuthApprovalGrid } from './components/AuthApprovalGrid';
import { useAuthApprovalStore } from './useAuthApprovalStore';
```

## §3. 자기 점검 (PRE-WRITE / POST-WRITE)

### 3.1 작성 직후 grep
```bash
# relative import 영역만 추출하여 시각 검토
grep -nE "^import.*from '\./|^import.*from '\.\.\/" {FILE} | head -20

# 하위 폴더 (./components/, ./hooks/, ./modals/) 가 현 폴더 파일 (.constants, .types, .utils) 뒤에 오는지 확인
```

### 3.2 사용자 lint 자동 fix
```bash
# 권장 — ESLint 자동 정렬
pnpm run lint:fix   # 또는 eslint --fix {FILE}
```

## §4. 자주 발생하는 패턴

| 파일 유형 | 의무 import 순서 |
|---|---|
| 메인 컴포넌트 (`{ScreenName}.tsx`) | 1) 외부 → 2) @foundation → 3) @shared → 4) `./{name}.constants` → `./{name}.types` → `./components/*` → `./hooks/*` → `./use{Name}Store` |
| Sub-grid 컴포넌트 (`components/XxxGrid.tsx`) | 1) 외부 → 2) @foundation → 3) @shared → 4) `../{name}.constants` → `../{name}.types` → `../use{Name}Store` |
| Modal 컴포넌트 (`components/modals/XxxModal.tsx`) | 1) 외부 → 2) @foundation → 3) @shared → 4) `../../{name}.constants` → `../../{name}.types` → `../../use{Name}Store` |

## §5. eslint config 위치

`packages/foundation/.eslintrc.cjs` 또는 root `.eslintrc.cjs` 의 `import/order` rule. 변경 시 모든 화면에 영향 — 신중 검토.
