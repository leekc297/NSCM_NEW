# Hook — FE Import 경로 자기 점검

> ⚠ **신규 FE 파일 작성 직전·직후 의무 hook**
> Vite "Failed to fetch dynamically imported module" 오류의 90% 는 import 경로 불일치.
> 본 hook 은 작성 직전 (pre-write) + 작성 직후 (post-write) 양방향으로 적용.

작성: 2026-05-22 (DMF0020 6종 import 오류 사고 후)
관련 룰: `Doc/_dev_rules/23_FE_IMPORT_INVENTORY.md`
상위 룰: `Doc/_dev_rules/hooks/anti-simplification.md`

---

## §0. 적용 시점

| 시점 | 행위 |
|---|---|
| **PRE-WRITE** (파일 작성 직전) | 의도한 import 모두를 §1~§4 체크리스트로 사전 검증 |
| **POST-WRITE** (파일 작성 직후) | 작성된 모든 import 줄을 §5 자동 검증 명령으로 확인 |
| **PRE-SUBMIT** (PR 직전) | §6 빌드 검증 (lint + type-check + dev 서버 페이지 오픈 확인) |

---

## §1. PRE-WRITE 체크리스트 (모두 ✓ 필수)

### 1.1 컴포넌트 import 경로 확인

신규 화면에서 자주 쓰는 컴포넌트의 **정확한 출처**:

```
✓ DataGrid              → @shared/components       (★ FlexGrid 직접 사용 X)
✓ MainTitle, SubTitle   → @shared/components
✓ SearchArea            → @shared/components
✓ CustomDropdown        → @shared/components
✓ CustomDialog          → @shared/components       (★ Dialog 아님!)
✓ TabWrapper, TabItem   → @shared/components
✓ MessageModal          → @shared/components

✓ Button                → @shared/lges             (★ @shared/components 아님)
✓ InputField            → @shared/lges             (★ @shared/components 아님)
✓ FormItem, Label       → @shared/lges
✓ Checkbox              → @shared/lges             (★ CheckboxField 아님)
✓ DatePickerCalendar    → @shared/lges             (★ DateRangePicker/MonthPicker 아님 — prop 으로 모드 전환)
✓ DropdownField, Switch, Tooltip, TextField, Divider → @shared/lges

✓ Grid, Stack, Typography → @shared/mui
✓ FunctionSearchIcon 등  → @shared/lges-icons
✓ clsx                   → @shared/clsx
```

### 1.2 Hook import 경로 확인

```
✓ useTabProcQuery       → @shared/hooks            (★ @foundation/query-client 아님)
✓ useProcMutation       → @shared/hooks
✓ useTabComboQuery(s)   → @shared/hooks
✓ useTabLookupQuery(s)  → @shared/hooks
✓ useTabCombosMulti     → @shared/hooks            (G2 multi-combo 1 round-trip)
✓ useTabBtnPermissions  → @shared/hooks            (⭐ 2026-06-15 신규 — Menu Button 권한 동적 fetch)
✓ useSaveWithValidation → @shared/hooks
✓ useSearchConditionPersistence → @shared/hooks
✓ useClearAppData       → @shared/hooks
✓ useBatchMutation      → @shared/hooks
✓ useConfirmYesNoCancel → @shared/hooks
✓ useFileTransfer       → @shared/hooks
✓ usePerfTrace          → @shared/hooks

✓ useTranslation        → 글로벌 auto-import (import 불필요)
                          또는 import { useTranslation } from '@foundation/i18n'
✓ t (직접)               → @foundation/i18n
```

⚠ **신규 hook 작성 검토 시** (2026-06-15 사고 후 보강) — master hook 의 명칭만 보고 "미구현" 추측 → 가설 import → vite 폭발 family 차단:
- **PRE-WRITE 의무**: `nscm-fe/packages/shared/src/hooks/index.ts` 직접 read 로 정확 export 확인
- **BE endpoint 인벤토리**: 동적 fetch 패턴 작성 시 BE Controller 의 `@(Get|Post|...)Mapping` grep 의무
- 메모리 `feedback_be_endpoint_inventory_before_hook.md` 참조 — NSCM `/admin/menu/{mnuId}/*` endpoint 패밀리 표

### 1.3 Store import 경로 확인

```
✓ useAuthStore, useUIStore, useSessionStore → @shared/stores
✓ useMessageStore, useDataGridStore         → @shared/stores
✓ useMotherStore                            → @shared/stores
✓ createPersistedStoreWithTab               → @shared/stores  (신규 화면 store 작성용)
```

### 1.4 Foundation import 경로 확인

```
✓ CRUD_TYPE, ROUTE_PATHS, BUTTON_TYPE, HTTP_STATUS, CELL_*_TYPE → @foundation/constants
✓ HotkeyConfig, PageProps, ApiResponse, RawFlexGridColumnConfig, ... → @foundation/models
✓ GridAction, GridUtils, EditTracker, DynamicColumnManager, CustomMergeManager → @foundation/utils
✓ apiClient, mockApiClient → @foundation/apis
✓ dayjs, lodash, isoWeek → @foundation/<name>  (default export)
```

### 1.5 ❌ 금지 import 패턴

```
❌ import { Dialog } from '@shared/components'          → CustomDialog 사용
❌ import { Button } from '@shared/components'          → @shared/lges 에서
❌ import { InputField } from '@shared/components'      → @shared/lges 에서
❌ import { DateRangePicker } from '@shared/components' → DatePickerCalendar 사용
❌ import { MonthPicker } from '@shared/components'     → DatePickerCalendar 사용
❌ import { CheckboxField } from '@shared/lges'         → Checkbox 사용
❌ import { useTabProcQuery } from '@foundation/query-client' → @shared/hooks
❌ import {...} from '@shared'                          → 루트 alias 금지
❌ import {...} from '@foundation'                      → 루트 alias 금지
❌ import {...} from '../../../packages/...'            → 상대 경로 금지
❌ import { FlexGrid } from '@mescius/wijmo.react.all'  → 컴포넌트 직접 사용 금지 (DataGrid wrapper 사용)
```

### 1.6 procedures.d.ts 등록 확인

```
✓ 신규 MENU_ID 가 configs/types/procedures.d.ts 에 등록됨? 
  → 미등록이면 ResponseData<MENU_ID, SHEETS.X> 타입 에러
  → 해결: 등록 또는 임시로 Record<string, unknown> 사용
```

---

## §2. PRE-WRITE 추가 확인 — 새 컴포넌트가 필요한 경우

작성하려는 import 가 §1 목록에 없으면 **반드시** 다음 단계를 거침:

```
[Step A] grep 으로 실제 존재 확인:
   Grep "^export.*\b<COMPONENT>\b" packages/shared/src/

[Step B] 미존재 → 가장 가까운 기존 컴포넌트로 대체:
   - Date range 입력      → DatePickerCalendar (range mode)
   - Month picker         → DatePickerCalendar (month mode)
   - Dialog/Modal         → CustomDialog 또는 MessageModal
   - Boolean toggle       → Checkbox 또는 Switch
   - Dropdown             → CustomDropdown 또는 DropdownField

[Step C] 정말 없다면 사용자에게 보고:
   "이 컴포넌트는 디자인 시스템에 없습니다. 다음 옵션 중 선택해주세요:
    - 기존 X 컴포넌트로 대체
    - 신규 atom 컴포넌트 작성 (별도 PR)
    - 외부 라이브러리 추가"
```

---

## §3. PRE-WRITE — 기존 표준 화면 참조

신규 화면 작성 전 **반드시** 다음 화면 중 하나의 import 패턴을 그대로 복사하여 시작:

| 화면 종류 | 표준 참조 |
|---|---|
| 단일 그리드 + 검색 | `features/master/src/pages/customer-forecast-master/` |
| 다중 그리드 + 탭 | `features/master/src/pages/erp-edi-master/` |
| 동적 컬럼 (Spread) | `features/demand/src/pages/forecast-price/` |
| Lookup 화면 | `features/admin/src/pages/lookup/` |
| Report (Read-only) | `features/report/src/pages/sales-plan-waterfall/` |
| Master CRUD | `features/admin/src/pages/user-management/` |

---

## §4. POST-WRITE 자동 검증 명령

파일 작성 직후 다음 명령을 실행. 1건이라도 실패 → 작성 중단 → 수정:

```bash
# 4.1 dev 서버 떠 있는 상태에서 type-check 만 빠르게
cd C:/Projects/NSCM/nscm-fe
pnpm type-check 2>&1 | head -50
# → 작성한 화면 관련 에러 0건 확인

# 4.2 신규 화면 폴더만 lint
pnpm eslint features/<domain>/src/pages/<screen>/ --color
# → error 0건 확인

# 4.3 import 패턴 자체 점검 (정규식)
# 금지 패턴 매칭이 있는지 확인 — 0 건이어야 함
grep -nE "from '@shared/components'.*\b(Dialog|Button|InputField|DateRangePicker|MonthPicker)\b" \
  features/<domain>/src/pages/<screen>/ -r

grep -nE "from '@shared/lges'.*\bCheckboxField\b" \
  features/<domain>/src/pages/<screen>/ -r

grep -nE "from '@foundation/query-client'.*\b(useTabProcQuery|useProcMutation)\b" \
  features/<domain>/src/pages/<screen>/ -r

grep -nE "from '\.\./\.\./\.\." features/<domain>/src/pages/<screen>/ -r
```

**자동 검증 PowerShell 1줄 (Windows)**:
```powershell
$scr = "C:\Projects\NSCM\nscm-fe\features\<domain>\src\pages\<screen>"
$bad = Select-String -Path "$scr\*","$scr\**\*" -Pattern "from '@shared/components'.*\b(Dialog|Button|InputField|DateRangePicker|MonthPicker)\b","from '@shared/lges'.*\bCheckboxField\b","from '@foundation/query-client'.*\b(useTabProcQuery|useProcMutation)\b","from '\.\./\.\./\.\." -ErrorAction SilentlyContinue
if ($bad) { Write-Host "❌ 금지 import 패턴 검출"; $bad } else { Write-Host "✅ import 패턴 OK" }
```

---

## §5. POST-WRITE — 실제 빌드 검증 (mandatory)

```bash
# 5.1 dev 서버 기동 (이미 떠 있으면 SKIP)
cd C:/Projects/NSCM/nscm-fe
pnpm dev   # 별도 터미널

# 5.2 브라우저에서 신규 화면 직접 오픈
#   → http://localhost:3000/<domain>/<sub>/<slug>
#   → Console 에 에러 0건 확인
#   → Network 탭에 500 응답 0건 확인

# 5.3 빌드 (운영용)
pnpm gen:procedures   # procedures.d.ts 자동 갱신
pnpm lint:fix
pnpm type-check
pnpm build
```

**한 번이라도 실패 → 작성 중단 → 사용자 보고**. "타입 에러 무시" 같은 단순화 금지 (Anti-Simplification 룰).

---

## §6. 사고 발생 시 디버깅 절차

Vite "Failed to fetch dynamically imported module: .../index.ts" 오류 시:

```
[Step 1] 브라우저 Network 탭 확인
   → 500 응답의 정확한 .tsx 파일 경로 (보통 자식 모듈)

[Step 2] 해당 파일의 import 목록을 §1.5 금지 패턴과 대조
   grep -nE "from '@shared/(components|lges)'" <파일>

[Step 3] 각 import 가 실제 export 되는지 grep
   Grep "^export.*\b<NAME>\b" packages/shared/src/

[Step 4] 모두 fix 후 dev 서버 reload
   → Vite HMR 자동 재컴파일

[Step 5] 여전히 실패 → dev 서버 콘솔 (터미널) 로그 확인
   → ECMAScript 파싱 에러, 순환 import 등 다른 원인 가능
```

---

## §7. 다른 룰과의 관계

| 룰 | 관계 |
|---|---|
| `anti-simplification.md` | 본 hook 의 상위 룰. import 추측 금지 = 단순화 금지 |
| `23_FE_IMPORT_INVENTORY.md` | 본 hook 의 데이터 소스 (모든 alias/export 정확 매핑) |
| `03_FE_RULES.md` §명명 규약 | 본 hook 과 상호보완 |
| `17_NEW_SCREEN_QUICKSTART.md` | 신규 화면 절차서 — 본 hook 을 §3 에 인용 |
| `08_SCREEN_REGISTRATION.md` | DB 메타 등록 — 본 hook 과 별도 |

---

## §8. 변경 이력

- 2026-05-22: 신규 작성 (DMF0020 사고 후).
  - 6종 import 오류 (Dialog/Button/InputField/DateRangePicker/MonthPicker/CheckboxField) 의 실제 발생 사례 반영.
  - PRE-WRITE / POST-WRITE 양방향 hook 적용.
  - `23_FE_IMPORT_INVENTORY.md` 와 짝.
