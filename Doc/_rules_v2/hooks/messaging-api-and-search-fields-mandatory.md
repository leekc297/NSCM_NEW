# Hook — Messaging / apiClient / searchFields 카탈로그 / CustomDialog 표준

> **Trigger**: T01 (신규 화면) + T05 (Form / SearchArea) + T07 (Button / 데이터 fetch / SAVE)
> **PR 차단 강도**: ⭐⭐⭐ (anti-simplification 동등)
> **신설일**: 2026-06-18 (자가 진화 #30, 사용자 명시 — "누락 없을 때까지" cross-check 4 회차)
> **세트 hook**: #60~#68 + **#69 (본 hook)**

## 0. 원칙 — 4 영역

1. **`useMessageStore`** 표준 (`@shared/stores`) — `setAlert` / `setToast` / `setConfirmYesNoCancel` 만 사용. `window.alert` / `window.confirm` 직접 사용 절대 금지
2. **`apiClient` 10 메서드 인벤토리** (`@foundation/apis`) — HTTP 4 + SP 호출 2 + Combo legacy 2 + G2 BigFilter 2. `fetch` / `axios` 직접 사용 금지
3. **`searchFields` 카탈로그 14 컴포넌트** (`@master/components` 또는 `../../../components`) — Form 작성 시 카탈로그 우선 사용
4. **`CustomDialog` 표준 size 7** (400/600/800/1000/1200/1400/1600) — 자체 modal / MUI Dialog 직접 사용 금지

---

## 1. `useMessageStore` 표준 5 패턴 (`@shared/stores`)

### 1.1 import + 사용
```tsx
import { useMessageStore } from '@shared/stores';
import type { YesNoCancelResult } from '@shared/stores';

const setAlert = useMessageStore(state => state.setAlert);
const setToast = useMessageStore(state => state.setToast);
const setConfirmYesNoCancel = useMessageStore(state => state.setConfirmYesNoCancel);

// 또는 component 외부 (handler 등) — getState()
const setAlert = useMessageStore.getState().setAlert;
```

### 1.2 5 패턴 표

| 패턴 | 시그니처 | 사용처 |
|---|---|---|
| **A. 단순 알림** | `await setAlert({ type: 'alert', content: t('MSG00010', '_저장됨') })` → `Promise<true>` | 결과 통지 (저장 완료 / 검색 결과 / 에러 메시지) |
| **B. Confirm** | `const ok = await setAlert({ type: 'confirm', content: t('MSG00009', '_초기화?') })` → `Promise<boolean>` | 사용자 확인 (삭제 / 초기화 / 저장 직전) |
| **C. YesNoCancel (G6)** | `const result = await setConfirmYesNoCancel({ content: ... })` → `Promise<'yes' \| 'no' \| 'cancel'>` | AS-IS MessageHelper Button '0202004' 매핑 — 3 옵션 분기 |
| **D. Toast** | `setToast({ message: t('MSG00020', '_성공'), type: 'success', duration: 4000 })` | 자동 사라지는 알림 (저장 성공 / 임시 상태) |
| **E. Header 포함** | `setAlert({ type: 'alert', header: t('TITLE001', '_경고'), content: ... })` | 강조 알림 |

### 1.3 의무 사항
- `setAlert` 는 **`Promise<boolean>`** 반환 — `await` 의무 (특히 confirm)
- 메시지 = `t('MSG00xxx', '_fallback')` i18n 키 의무 (#63 §9)
- `window.alert(...)` / `window.confirm(...)` / `alert(...)` 직접 사용 **PR 차단**
- `console.error('실패')` 사용자 알림 용도 금지 — `setAlert({ type: 'alert', ... })` 의무

### 1.4 표준 MSG ID 인벤토리 (KO.json)

| MSG ID | 한국어 | 사용처 |
|---|---|---|
| MSG00009 | 저장된 검색조건을 초기화 하겠습니까? | F10 Reset Condition |
| MSG00010 | 조회 조건이 저장되었습니다 | F6 Condition 저장 |
| MSG00011 | 검색조건이 초기화 되었습니다 | F10 Reset 완료 |
| MSG00013 | 필수값을 입력하세요 | useSaveWithValidation 실패 |
| MSG00014 | No selection | F9 Delete 선택 0건 |
| ... | (확장 시 KO.json 등록 — #68 §3) | |

---

## 2. `apiClient` 10 메서드 인벤토리 (`@foundation/apis`)

### 2.1 import
```ts
import { apiClient, mockApiClient } from '@foundation/apis';
```

### 2.2 10 메서드 표

| # | 메서드 | 시그니처 | 용도 |
|---:|---|---|---|
| **HTTP 4** | | | |
| 1 | `get<T, P>` | `(url, params?, opts?) => AxiosPromise<ApiResponse<T>>` | 단순 GET (예: `/admin/menu/${menuId}/search-conditions`) |
| 2 | `post<T, P>` | `(url, data?, opts?) => AxiosPromise<ApiResponse<T>>` | 단순 POST (예: `/admin/menu/${menuId}/column`) |
| 3 | `patch<T, P>` | `(url, data?, opts?) => AxiosPromise<ApiResponse<T>>` | PATCH (드물게) |
| 4 | `delete<T, P>` | `(url, params?, opts?) => AxiosPromise<ApiResponse<T>>` | DELETE (드물게) |
| **SP 호출 2** | | | |
| 5 | `callProc<M, S>` | `(menuId, sheetName, action, params?) => Promise<ApiResponse<ProcResponse<M, S>>>` | SP 조회. URL 패턴: `${menuId}/${sheetName}/${procedureAction}/call-proc`. **`useTabProcQuery` 내부 자동 호출 — 직접 호출 회피** |
| 6 | `callMutationProc<M, S, RS>` | `(menuId, sheetName, action, data[]) => Promise<ApiResponse<MutateResponse>>` | SP SAVE. `useProcMutation` 내부 자동 — 직접 호출 회피 |
| **Combo legacy 2** | | | |
| 7 | `getCombo(params)` | `(ComboParam) => Promise<ComboResponse[]>` | 단일 combo (legacy — `useTabComboQueries` 권장) |
| 8 | `getLookup(params)` | `(LookupParam) => Promise<LookupResponse[]>` | 단일 lookup (legacy) |
| **G2 BigFilter 2** ⭐ | | | |
| 9 | `getCombosMulti(comboList[])` | `(ComboParam[]) => Promise<Record<string, ComboResponse[]>>` | **1 round-trip 다중 combo** — DM 도메인 BigFilter (AS-IS BaseForm DataService.GetDMInnerTable 동등). URL `admin/combo-muti`. body `{ comboList: [{comboId: 'MyDivision'}, ...] }`. 응답 `{ MyDivision: [...], TeambyDivision: [...] }` |
| 10 | `getLookupsMulti(lookupTypes[])` | `(string[]) => Promise<Record<string, LookupResponse[]>>` | **1 round-trip 다중 lookup** — URL `admin/lookup-muti`. body `{ lookupType: 'INPUT_TP_CD,MNU_TP_CD' }` (csv) |

### 2.3 표준 사용 우선순위 (의무)

```
화면 데이터 fetch (SP 조회) → useTabProcQuery (#61 §3.3) [callProc 직접 X]
화면 SAVE (SP mutate)        → useProcMutation (#61 §3.3)  [callMutationProc 직접 X]
다중 combo                    → useTabComboQueries (#61 §3.3) [getCombosMulti 자동 내부]
단일 admin GET                → apiClient.get
단일 admin POST               → apiClient.post
직접 fetch / axios            → 절대 금지
```

### 2.4 의무 사항
- `fetch(...)` / `axios.get(...)` / `axios.post(...)` 직접 사용 **PR 차단** (인증 / progress / alert interceptor 무력화)
- `callProc` / `callMutationProc` 직접 호출은 hook 내부에서만 (`useTabProcQuery` / `useProcMutation` 가 사용)
- 화면에서 직접 호출 시 `tabId` 캐시 / invalidate / 에러 알림 모두 누락
- ApiResponse 형식: `{ code: '0', message: 'success', result: T }` — `result` 만 추출

---

## 3. `searchFields` 카탈로그 14 컴포넌트 (`features/master/src/components/searchFields/`)

### 3.1 컴포넌트 인벤토리

| # | 컴포넌트 | Props 타입 | 용도 |
|---:|---|---|---|
| 1 | `DivisionField` | `SingleFieldProps` (value, onChange) | Division dropdown |
| 2 | `TeamField` | `MultiFieldProps` (value, onChange, division) | Team multi dropdown — division cascade |
| 3 | `EndCustomerField` | `MultiFieldProps` | End Customer multi — division cascade |
| 4 | `SalesSiteField` | `MultiFieldProps` | Sales Site multi |
| 5 | `PlantSiteField` | `MultiFieldProps` | Plant Site multi |
| 6 | `BizTypeField` | `Omit<MultiFieldProps, 'division'>` | Biz Type (no cascade) |
| 7 | `ProjectField` | `PopupFieldProps` (value, onValueChange, onOpenPopup) | Project — InputField + popup trigger |
| 8 | `ItemField` | `ItemFieldProps extends PopupFieldProps` | Model/Item — popup |
| 9 | `OwnerField` | `OwnerFieldProps extends PopupFieldProps` | Owner — popup |
| 10 | `PeriodField` | `PeriodFieldProps` (start, end, onChange) | 날짜 범위 |
| 11 | `BucketField` | `BucketFieldProps` (value, onChange) | Bucket type (M/W/D) |
| 12 | `VersionField` | `VersionFieldProps` (value, onOpenPopup) | Version popup |
| 13 | `SearchOverRangeField` | `CheckFieldProps` (value, onChange) | 범위 초과 검색 checkbox |
| 14 | (확장) `PopupSearchInput` | internal | InputField + Search Button helper |

### 3.2 Helper 함수
```ts
const orAll = (arr?: string[]) => (arr && arr.length > 0 ? arr.join(',') : 'ALL');
// CSV 변환 + 'ALL' fallback (cascade combo filter #59 표준)

const toOptions = (rows: ...) => ({ label, value })[]
// combo 응답 → CustomDropdown options 변환
```

### 3.3 사용 표준 (Form 작성 시)
```tsx
import {
  DivisionField, TeamField, EndCustomerField, SalesSiteField,
  ProjectField, ItemField, OwnerField, BucketField, PeriodField,
} from '../../../components';   // 또는 @master/components

<DivisionField
  value={searchParams.divisionId}
  onChange={(v) => setSearchParams({
    divisionId: v,
    deptId: 'ALL', endCustomer: 'ALL', salesSite: 'ALL'   // cascade reset #59 §1
  })}
/>

<TeamField
  value={searchParams.deptId}
  onChange={(v) => setSearchParams({ deptId: v })}
  division={searchParams.divisionId}
/>
```

### 3.4 의무 사항
- 신규 화면 Form 작성 시 **카탈로그 우선 사용** — 메모리 `feedback_search_fields_catalog.md` cross-ref
- 화면별 자체 `<CustomDropdown>` + `<FormItem>` 자체 작성 = 카탈로그 미등재 항목에 한정 (확장 시 카탈로그 등록 우선)
- 카탈로그 컴포넌트는 자동: `i18n LBL` + `FormItem labelAlign/required/size` + `CustomDropdown multiple/allOption/useClearIcon/limitTags` + `Map dedup` + `cascade filter` + `useTabComboQueries 1 RT` 모두 표준 처리
- 신규 항목 카탈로그 등록 시: `features/master/src/components/searchFields/SearchFields.tsx` + barrel export 추가

---

## 4. `CustomDialog` 표준 (`@shared/components`)

### 4.1 시그니처
```tsx
import { CustomDialog } from '@shared/components';

<CustomDialog
  type='modal'                          // 'modal' | 'modaless'
  position='basic'                      // 'basic' | 'overflow'
  size={1000}                           // ⭐ 표준 7 size: 400 / 600 / 800 / 1000 / 1200 / 1400 / 1600
  title={t('LBL00xxx', '_Title')}
  subTitle={t('LBL00xxx', '_Sub')}
  handleSubmit={handleConfirm}
  handleClose={modalClose}
  isOutBound={false}
  disableButtonCancel={false}
>
  {/* content */}
</CustomDialog>
```

### 4.2 표준 size 7 (디자인 시스템)
| size | 용도 |
|:-:|---|
| **400** | 단순 confirm / 작은 input |
| **600** | 단일 form / 권한 안내 |
| **800** | 표준 popup (Owner / Team) |
| **1000** | DataGrid 포함 popup (Region / Customer) |
| **1200** | 다중 grid popup |
| **1400** | 대형 마스터 popup |
| **1600** | 분석/리포트 popup |

### 4.3 의무 사항
- `<dialog>` HTML / MUI `<Dialog>` 직접 사용 **PR 차단**
- 표준 size 7 중 선택 (`number` literal 자체 금지)
- `draggable` 자동 지원 (`react-draggable` 내부)
- title / subTitle = i18n 키 의무
- handleSubmit / handleClose 둘 다 정의

---

## 5. PRE-WRITE 체크리스트 (4 영역 — 14 항목)

```
[Messaging]
[ ] 1.  window.alert / window.confirm / alert(...) 직접 사용 0?
[ ] 2.  setAlert({ type: 'alert' / 'confirm' / 'yesNoCancel' }) 의무?
[ ] 3.  setAlert 호출 시 `await` (confirm 결과 사용 시)?
[ ] 4.  message content = t('MSG00xxx', ...) i18n 키?

[apiClient]
[ ] 5.  fetch / axios 직접 호출 0?
[ ] 6.  화면 데이터 fetch = useTabProcQuery (callProc 직접 0)?
[ ] 7.  화면 SAVE = useProcMutation + useSaveWithValidation (callMutationProc 직접 0)?
[ ] 8.  단일 admin GET/POST 만 apiClient.get/.post 직접 (그 외 hook 경유)?
[ ] 9.  G2 BigFilter 필요 시 getCombosMulti / getLookupsMulti 1 RT (개별 callProc 0)?

[searchFields]
[ ] 10. Form 필드 = searchFields 카탈로그 14종 우선 사용?
[ ] 11. 카탈로그 미등재 시 신규 등록 후 사용 (직접 작성 후 카탈로그 미등록 0)?

[CustomDialog]
[ ] 12. <dialog> / <MUIDialog> 직접 사용 0 — CustomDialog 만?
[ ] 13. size = 7 표준 (400/600/800/1000/1200/1400/1600) 중 선택?
[ ] 14. title + handleSubmit + handleClose 의무 정의 + i18n 키?
```

---

## 6. POST-WRITE grep (작성 직후 의무)

```bash
SCREEN="nscm-fe/features/{domain}/src/pages/{my-screen}"

# 1. window.alert / window.confirm / 직접 alert
grep -nE "window\\.alert|window\\.confirm|^\\s*alert\\(|^\\s*confirm\\(" "$SCREEN"
# 결과 = 0 — useMessageStore 만

# 2. fetch / axios 직접
grep -nE "fetch\\(|axios\\." "$SCREEN"
# 결과 = 0 — apiClient 만

# 3. callProc / callMutationProc 직접 호출 (hook 외부)
grep -nE "apiClient\\.callProc\\(|apiClient\\.callMutationProc\\(" "$SCREEN"
# 결과 = 0 — useTabProcQuery / useProcMutation 만

# 4. <dialog> / <MuiDialog> 직접
grep -nE "<dialog|<MuiDialog|<MUIDialog|@mui/material.*Dialog" "$SCREEN"
# 결과 = 0 — CustomDialog 만

# 5. searchFields 카탈로그 미사용 검출 (Form 안 <CustomDropdown> 직접 + 표준 필드 작성)
grep -nE "<CustomDropdown[^>]*['\"]MyDivision['\"]" "$SCREEN/components/*Form.tsx"
# 결과 = 0 — DivisionField 사용 의무

# 6. setAlert 누락 (await 없이 호출)
grep -nE "setAlert\\(\\{" "$SCREEN" | grep -v "await\\|void"
# 결과 — await 권장
```

---

## 7. 안티 패턴 (PR 차단)

| # | 안티 패턴 | 사고 / 대체 |
|---:|---|---|
| 1 | `window.alert('저장 실패')` 직접 | 디자인 시스템 무력화 / i18n 미적용. `setAlert({ type: 'alert', content: t('MSG00xxx', '_저장 실패') })` |
| 2 | `window.confirm('삭제하시겠습니까?')` 직접 | 동기 blocking + 디자인 깨짐. `await setAlert({ type: 'confirm', ... })` 비동기 |
| 3 | `alert(...)` 글로벌 직접 호출 | 동일 |
| 4 | `console.error` 사용자 알림 용도 | 사용자 미인지. `setAlert` 의무 |
| 5 | `fetch(...)` 직접 호출 | apiClient interceptor (auth / progress / alert) 무력화. `apiClient.post` |
| 6 | `axios.get / post` 직접 import | 동일. `apiClient` 만 |
| 7 | 화면 안 `apiClient.callProc(...)` 직접 호출 | tabId 캐시 / invalidate / 에러 alert 누락. `useTabProcQuery` 의무 |
| 8 | 화면 안 `apiClient.callMutationProc(...)` 직접 호출 | useSaveWithValidation 필수값 검증 누락. `useProcMutation` + `useSaveWithValidation` |
| 9 | 다중 combo 마다 `useTabProcQuery(BUTTON_TYPE.COMBO)` 개별 호출 | N round-trip. `useTabComboQueries({ filters: [...] })` 1 RT 또는 `getCombosMulti` G2 |
| 10 | Form 안 `<CustomDropdown options={divisions.map(...)} onChange={...}>` Division 직접 작성 | searchFields 카탈로그 미사용. `<DivisionField value onChange>` 의무 |
| 11 | 카탈로그 미등재 필드 만들고 카탈로그 등록 누락 | 다른 화면 재사용 불가. 등록 후 사용 |
| 12 | `<dialog>` HTML 직접 / MUI `<Dialog>` 직접 | 디자인 시스템 무력화. `<CustomDialog>` 의무 |
| 13 | `<CustomDialog size={1100}>` 비표준 size | 디자인 토큰 깨짐. 7 size 중 선택 |
| 14 | i18n 키 없이 `setAlert({ content: '저장됨' })` 하드코딩 | 다국어 미적용. `t('MSG00xxx', '_fallback')` 의무 |

---

## 8. 관련 hook / 메모리 cross-ref

| 항목 | 참조 |
|---|---|
| Page Shell + Form + Hook + Store | hook `screen-shell-composition-mandatory.md` (#61) |
| useSaveWithValidation 필수값 검증 | hook #61 §3.3 |
| useTabProcQuery / useProcMutation / useTabComboQueries 표준 | hook #61 §3.3 |
| Form 표준 (SearchArea + FormItem + CustomDropdown) | hook #61 §3.2 |
| Cascade Combo Filter 5 단계 (cascade reset + Map dedup) | hook `cascade-combo-filter.md` (#59) |
| searchFields 카탈로그 (DivisionField/TeamField/...) | 메모리 `feedback_search_fields_catalog.md` |
| i18n LBL / MSG 키 표준 | 메모리 `feedback_i18n_lbl_code_pattern.md` + #68 §3 |
| Popup Modal (CustomDialog wrap) | hook `popup-modal-and-routing-mandatory.md` (#67) |
| ⭐ G2 BigFilter (`getCombosMulti`) | AS-IS BaseForm DataService.GetDMInnerTable 격차 / Phase 5 신규 |
| YesNoCancel G6 (`setConfirmYesNoCancel`) | AS-IS MessageHelper Button '0202004' / Phase 5 신규 |
| Implementation 위치 | `nscm-fe/packages/shared/src/stores/useMessageStore.ts` + `packages/foundation/src/apis/axios.ts` + `features/master/src/components/searchFields/SearchFields.tsx` + `packages/shared/src/components/molecules/dialog/CustomDialog.tsx` |

---

## 9. 검증 — PR 차단 강도

§5 PRE-WRITE 14 + §6 POST-WRITE grep 6 + §7 안티패턴 14 모두 PR 차단.
사용자 cross-check 4 회차 (2026-06-18 "누락 없을 때까지").
