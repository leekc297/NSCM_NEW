# Hook — Type-Check 오류 17 패턴 정밀 가이드

> ⚠ **신규 FE 파일 작성 시 의무 hook (cloud type-check 8 회 push 차단 사고 후, 2026-06-09)**
> `pnpm type-check` 호출 없이 작성 직전 / 직후 self-check 로 17 패턴 사전 차단.

작성: 2026-06-09 (cloud `fix/lint-cleanup-20260608` branch 8 회 push 차단 사고 후)
상위 룰: [`anti-simplification.md`](./anti-simplification.md) / [`pre-write.md`](./pre-write.md) / [`post-write.md`](./post-write.md)
관련 룰: [`fe-import-check.md`](../../_dev_rules/hooks/fe-import-check.md) / [`runtime-error-prevention.md`](./runtime-error-prevention.md) / [`_tobe/02_imports.md`](../_tobe/02_imports.md)

---

## §0. 적용 시점 + 메타룰

| 시점 | 행위 |
|---|---|
| **PRE-WRITE** (파일 작성 직전) | §1~§5 17 패턴 self-check |
| **POST-WRITE** (파일 작성 직후) | §6 자동 검증 grep 8 종 실행 |
| **PRE-SUBMIT** (PR 직전) | §7 검증 (cloud type-check 결과 share 후 patch 적용) |

### ⛔ 절대 금지 (메모리 정책 재확인)

- 이 PC 에서 `pnpm type-check` / `pnpm install` / `pnpm dev` / `pnpm build` 절대 호출 금지 (메모리: `feedback_pnpm_install_avoidance`)
- `pnpm exec tsc --noEmit` 도 install 트리거 가능 → 금지
- type-check 검증은 cloud PC 의 결과 또는 본 룰의 self-check 만 사용

---

## §1. 패턴 1~5 — Hook / Modal Required Prop

### 패턴 1: `useTabProcQuery` / `useProcMutation` `tabId` 필수 (TS2345)

```typescript
// ❌ 거부 — TS2345: Property 'tabId' is missing
useTabProcQuery({ menuId: MENU_ID, sheetName: SHEETS.MAIN, filters, enabled: true });

// ✓ 정확
useTabProcQuery({ menuId: MENU_ID, sheetName: SHEETS.MAIN, tabId: MENU_ID, filters, enabled: true });

useProcMutation({ menuId: MENU_ID, sheetName: SHEETS.MAIN, tabId: MENU_ID });
```

**근거**: `@shared/hooks/useCustomQueryClient.ts:30` — `tabId: string;` required.

**자동 검증 grep (PRE-COMMIT)**:
```bash
# tabId 누락 검출 — useTabProcQuery / useProcMutation 안에 tabId 없는 호출
grep -rPzn 'use(Tab)?Proc(Query|Mutation)\(\{[^}]*?\}' features/ packages/ --include='*.tsx' --include='*.ts' \
  | grep -v 'tabId:' | head -10
```

### 패턴 2: Modal `callFromCell` required (TS2741)

```typescript
// ❌ 거부 — TS2741: Property 'callFromCell' is missing
<ProjectByDivisionModal open={...} modalClose={...} setSelectedValue={...} preSearchParams={...} />

// ✓ 정확
<ProjectByDivisionModal open={...} modalClose={...} setSelectedValue={...} preSearchParams={...} callFromCell={false} />
```

**근거**: `@master/components/projectByDivisionModal/ProjectByDivisionModal.tsx:30` — `callFromCell: boolean;` required.

**자동 검증 grep**:
```bash
# Modal 호출 시 callFromCell 누락 검출
grep -rPzn '<(Project|Item|Owner|Customer)ByDivisionModal[^/]*?/>' features/ \
  --include='*.tsx' | grep -v 'callFromCell' | head -10
```

### 패턴 3: Modal `headerTitle` optional (TS2322)

```typescript
// ⚠ headerTitle 은 optional — modal 의 default i18n 사용 시 생략 가능
// 사용자 명시 라벨 시 명시:
<ItemByDivisionModal ... headerTitle='Model / Nickname' callFromCell={false} />
```

### 패턴 4: ProjectByDivisionModal `setSelectedValue` 4 인자 시그니처 (TS2322)

```typescript
// ⚠ DMF0020 (2026-06-03) 이후 optional 3 추가 인자 — Project popup 의 PROJECT_STATUS/BIZ_TYPE_NAME 자동 채움
setSelectedValue: (projects: string, projectsNames?: string, projectStatus?: string, bizTypeName?: string) => void;

// 호출처 callback 도 4 인자 형태 권장 (optional 일부만 사용 가능)
setSelectedValue={(projectCode, projectName, projectStatus, bizTypeName) => { ... }}
```

### 패턴 5: 그 외 required prop 명시 패턴

```bash
# PRE-WRITE 자기 점검: 사용하려는 모든 컴포넌트의 interface 확인 의무
grep -A 30 "interface.*ModalProps\|interface.*GridProps" \
  $(grep -l "<XxxComponent" 작성중인-파일.tsx) | head -40
```

---

## §2. 패턴 6~10 — Type Cast / Generic Constraint

### 패턴 6: `as XxxType[]` direct cast (TS2352)

```typescript
// ❌ 거부 — TS2352: Conversion of type '(WijmoRowItem & ...)[]' to type 'ApprovalRow[]' may be a mistake
const rows = (data?.o_rc1 ?? []) as ApprovalRow[];

// ✓ 정확 — `as unknown as` 우회
const rows = (data?.o_rc1 ?? []) as unknown as ApprovalRow[];
```

**근거**: ProcResponse 의 `o_rc1` / `O_RESULT_CURSOR` 가 `WijmoRowItem` (= `Record<string, WijmoPrimitive>`) 으로 추론됨. 화면 specific type 으로 direct cast 시 union 불일치 → `as unknown as` 우회 의무.

### 패턴 7: `as Record<string, unknown>` direct cast (TS2352)

```typescript
// ❌ 거부 — `XxxRow` 가 index signature 없을 때
(ra as Record<string, unknown>)[key];

// ✓ 정확
(ra as unknown as Record<string, unknown>)[key];
```

### 패턴 8: `<DataGrid<XxxType>>` generic constraint (TS2344)

```typescript
// ❌ 거부 — DataGrid<T extends WijmoRowItem> 인데 ResponseData<...> 가 union 에 undefined 포함
<DataGrid<ResponseData<MENU_ID, SHEETS.SALES_SITE>>

// ✓ 정확 1 — WijmoRowItem 직접
<DataGrid<WijmoRowItem>
  itemsSource={data as unknown as WijmoRowItem[]}
  ...

// ✓ 정확 2 — Row interface 가 [key: string]: WijmoPrimitive 가지면
<DataGrid<MyRowItem>  // MyRowItem extends WijmoRowItem 또는 직접 index sig
```

### 패턴 9: `[key: string]: WijmoPrimitive` index sig 누락 (TS2344)

```typescript
// ❌ 거부 — DataGrid<MyRow> 에서 MyRow 가 WijmoRowItem constraint 만족 못함
interface MyRow {
  COL_A: string;
  COL_B: string;
}

// ✓ 정확
interface MyRow {
  COL_A: string;
  COL_B: string;
  [key: string]: WijmoPrimitive;  // WijmoRowItem constraint 호환 의무
}
```

**`WijmoPrimitive` 정의** (`configs/types/global.d.ts:19`):
```typescript
type WijmoPrimitive = string | number | boolean | Date | null;
```

### 패턴 10: optional `?: string` 가 index sig 거부 (TS2411)

```typescript
// ❌ 거부 — TS2411: 'string | undefined' is not assignable to index type 'WijmoPrimitive' (undefined 미포함)
interface MyRow {
  APPROVED_BY?: string;
  [key: string]: WijmoPrimitive;
}

// ✓ 정확 — optional 제거 + default '' 채움 의무
interface MyRow {
  APPROVED_BY: string;  // optional 제거
  [key: string]: WijmoPrimitive;
}
```

---

## §3. 패턴 11~14 — Dialog / DatePicker / Constants

### 패턴 11: `DialogNavigationSize` literal type (TS2322)

```typescript
// ❌ 거부 — string literal 'large'/'medium' 등 비지원
<CustomDialog size='large'>
<CustomDialog size='medium'>
<CustomDialog size={1100}>  // 1100 도 union 에 없음

// ✓ 정확 — number literal union 만 (1600 | 1400 | 1200 | 1000 | 800 | 600 | 400)
<CustomDialog size={1200}>
<CustomDialog size={800}>
<CustomDialog size={600}>
```

**근거**: `packages/shared/src/components/molecules/dialog/CustomDialog.tsx:14` —
```typescript
export type DialogNavigationSize = 1600 | 1400 | 1200 | 1000 | 800 | 600 | 400;
```

### 패턴 12: `CustomDialog` deprecated prop (TS2322)

```typescript
// ❌ 거부 — 구버전 prop 들
<CustomDialog open={...} onClose={...} title='...' width={600} height={400}>
  <div>content</div>
</CustomDialog>

// ✓ 정확 — 신버전 prop 들
<CustomDialog
  open={...}
  handleClose={...}            // onClose → handleClose
  customHeaderTitle='...'      // title → customHeaderTitle (string 또는 ReactNode)
  size={600}                   // width/height → size (DialogNavigationSize)
  type='modal'
  position='basic'
  disableButtonCancel
  customContentArea={          // children → customContentArea
    <div>content</div>
  }
/>
```

### 패턴 13: `DatePickerCalendar.onChange` 시그니처 (TS2322)

```typescript
// ❌ 거부 — TS2322: '(date: [Dayjs, Dayjs]) => void' not assignable to '(date: DateRangePickerValueType) => void'
<DatePickerCalendar
  usecase='date-range-multi'
  value={period}
  onChange={(date: [Dayjs, Dayjs]) => setPeriod(date)}
/>

// ✓ 정확 — DateRangePickerValueType (가변 length 가드 의무)
<DatePickerCalendar
  usecase='date-range-multi'
  value={period}
  onChange={date => {
    if (Array.isArray(date) && date.length === 2) {
      setPeriod([date[0] as Dayjs, date[1] as Dayjs]);
    }
  }}
/>
```

### 패턴 14: `RESPONSE_SET.CUD` namespace 처럼 사용 (TS2702)

```typescript
// constants.ts 에서:
export const RESPONSE_SET = { MAIN: 'o_rc1', ... } as const;
export type RESPONSE_SET = (typeof RESPONSE_SET)[keyof typeof RESPONSE_SET];

// ❌ 거부 — TS2702: 'RESPONSE_SET' only refers to a type, but is being used as a namespace here
} satisfies ResponseData<MENU_ID, SHEETS.SALES_SITE, RESPONSE_SET.CUD>;

// ✓ 정확 1 — string literal 직접
} satisfies ResponseData<MENU_ID, SHEETS.SALES_SITE, 'o_rc1'>;

// ✓ 정확 2 — enum 으로 변경
export enum RESPONSE_SET { MAIN = 'o_rc1', CUD = 'o_rc1', ... }
```

---

## §4. 패턴 15~17 — eslint Errors (lint-staged 차단)

### 패턴 15: `@typescript-eslint/no-base-to-string`

```typescript
// ❌ 거부 — r.COLUMN_NAME 의 type 이 unknown 일 때 stringify 시 '[object Object]' 위험
const rows = (data?.o_rc1 ?? []) as Record<string, unknown>[];
rows.map(r => ({ name: String(r.COLUMN_NAME ?? '') }));
//                      ^ no-base-to-string

// ✓ 정확 — type 강제 (Record<string, string>)
const rows = (data?.o_rc1 ?? []) as unknown as Record<string, string>[];
rows.map(r => ({ name: String(r.COLUMN_NAME ?? '') }));
```

### 패턴 16: `@typescript-eslint/restrict-template-expressions`

```typescript
// ❌ 거부 — template literal 안에 unknown
const key = `${r.DIVISION_ID ?? ''}|${r.CODE ?? ''}`;  // r 이 unknown 일 때

// ✓ 정확 — Record<string, string> 강제 후 사용
const arr = rows as unknown as Array<Record<string, string>>;
const key = `${arr[0].DIVISION_ID ?? ''}|${arr[0].CODE ?? ''}`;
```

### 패턴 17: `@typescript-eslint/no-use-before-define`

```typescript
// ❌ 거부 — JSX 안에서 사용한 popupBtnStyle 가 file 하단에 정의
export const MyField = () => (
  <button style={popupBtnStyle}>...</button>  // line 100
);
const popupBtnStyle = { ... };  // line 200

// ✓ 정확 — 사용 전 정의 (file 상단 helper 영역)
const popupBtnStyle = { ... };  // file 상단 helper 영역
export const MyField = () => (
  <button style={popupBtnStyle}>...</button>
);
```

---

## §5. 패턴 — procedures.d.ts Schema 정합

### 패턴 12-bis: ProcedureMap[M] schema 정합 의무

```typescript
// procedures.d.ts 의 schema 확인 의무 (auto-gen, 수정은 cloud sync 후)
DMF0008: {
  summary: {
    request: { divisionId: string; sesUserId?: string; menuId?: string; };
    response: { o_rc1: {...} };
  };
  ...
}

// ❌ 거부 — TS2345: Property 'fromYyyymmdd' does not exist on schema
useTabProcQuery({
  menuId: 'DMF0008', sheetName: 'summary', tabId: 'DMF0008',
  filters: { divisionId, fromYyyymmdd, toYyyymmdd },  // schema 에 없음
  enabled: true,
});

// ✓ 정확 — schema 에 추가 (procedures.d.ts) 또는 store 에서 schema 와 일치하게 filter 작성
filters: { divisionId },  // schema 와 일치만
```

**procedures.d.ts 수정 의무**:
- BE PROC_M 의 IN 파라미터와 일치
- `sesUserId` / `menuId` 는 BE 자동 채움이므로 **optional 권장**
- sheet key 누락 시 enum 사용처 모두 거부 (TS2344) → entry 추가 의무

### 패턴 13-bis: SHEETS enum 의 ProcedureMap key 정합

```typescript
// ❌ 거부 — SHEETS.MAIN ('main') 이 ProcedureMap[DMF0008] union ('summary'|'repair'|...) 에 없음
useTabProcQuery<MENU_ID, SHEETS.MAIN>({ ... });

// ✓ 정확 — ProcedureMap[M] 의 sheet key 와 SHEETS enum value 일치 의무
// 두 방향:
//  (1) SHEETS.MAIN = 'summary' 로 변경 (또는 SUMMARY = 'summary' enum 추가)
//  (2) procedures.d.ts 의 DMF0008 entry 에 'main' 추가
```

---

## §6. POST-WRITE 자동 검증 grep (작성 직후 실행)

```bash
# 작성 직후 작성한 file 에 대해 8 종 grep 의무 (pnpm type-check 회피)

FILE="$1"  # 작성한 파일

# §1.1 tabId 누락
grep -nP 'use(Tab)?Proc(Query|Mutation)\(\{[^}]*\}\)' "$FILE" | grep -v 'tabId:' && echo "⚠ tabId 누락"

# §1.2 Modal callFromCell 누락
grep -nP '<(Project|Item|Owner|Customer)ByDivisionModal' "$FILE" | grep -v 'callFromCell' && echo "⚠ Modal callFromCell 누락"

# §2.1 as XxxRow[] direct cast
grep -nP 'as [A-Z]\w*Row\[\]' "$FILE" | grep -v 'as unknown as' && echo "⚠ direct cast (use as unknown as)"

# §2.2 as Record<string, unknown> direct cast
grep -nP 'as Record<string, unknown>' "$FILE" | grep -v 'as unknown as' && echo "⚠ Record direct cast (use as unknown as)"

# §3.1 DialogNavigationSize literal 거부
grep -nP "size='(large|medium|small)'" "$FILE" && echo "⚠ Dialog size 는 number literal 만 (1200/800 등)"

# §3.2 CustomDialog deprecated prop
grep -nP '<CustomDialog[^/]*?(width=|height=|title=|onClose=)' "$FILE" && echo "⚠ CustomDialog deprecated prop (customHeaderTitle/handleClose/size 사용)"

# §4.1 popupBtnStyle JSX 사용 전 정의
LINE_USE=$(grep -n "style={popupBtnStyle}" "$FILE" | head -1 | cut -d: -f1)
LINE_DEF=$(grep -n "const popupBtnStyle\s*=" "$FILE" | head -1 | cut -d: -f1)
[ -n "$LINE_USE" ] && [ -n "$LINE_DEF" ] && [ "$LINE_USE" -lt "$LINE_DEF" ] && echo "⚠ popupBtnStyle JSX 사용 전 정의 (use-before-define)"

# §5.1 [key: string]: WijmoPrimitive 누락 — DataGrid<XxxRow> 사용 시 XxxRow interface 확인
grep -nP '<DataGrid<' "$FILE" && echo "ℹ DataGrid<T> 사용 — T extends WijmoRowItem 또는 [key:string]: WijmoPrimitive 확인 의무"
```

---

## §7. PRE-SUBMIT 검증 — cloud type-check 결과 share + patch 적용

cloud type-check 가 push 차단 시 (사용자 정책 = 이 PC type-check 금지):

1. cloud 에서 정확한 오류 메시지 dump:
   ```powershell
   cd C:\Projects\NSCM\nscm-fe\features\<패키지>
   pnpm type-check 2>&1 | tee typecheck_err.log
   ```
2. log 를 사용자가 이 PC 에 share
3. 이 PC 에서 17 패턴 매칭하여 fix → patch 또는 file 직접 작성
4. cloud 에 복사 → 재검증

---

## §8. 사고 사례 — Cloud `fix/lint-cleanup-20260608` 8 회 Push 차단 (2026-06-09)

| 회차 | 패키지 | 오류 수 | 사고 패턴 |
|---:|---|---:|---|
| 1 | `@master` | 60+ | 패턴 1, 2, 4, 6, 8, 11, 14 |
| 2 | `@master` | 13 | 패턴 1, 2, 4, 11, 12 |
| 3 | `@master` | 17 (eslint) | 패턴 15, 16, 17 |
| 4 | `@authority` | 2 | 패턴 6, 9 |
| 5 | `@authority` | 1 | 패턴 10 (optional → required) |
| 6 | `@master` | 20 | 패턴 1, 4, 7, 8, 11, 14 |
| 7 | `@master` | 13 → 8 | 패턴 1, 2, 4 (잔여) + 패턴 7, 14 (cloud 전용 file) |
| 8 | `@master` | 8 → 5 | 패턴 7 (RawFlexGridColumnConfig 정합) |

**근본 원인**:
- 이 PC 의 `pnpm type-check` 금지 정책 → cloud 결과만으로 iterative fix → 16 시간 누적
- 17 패턴 룰 미존재 → 같은 사고 반복

**룰 적용 후 기대 효과**:
- §6 POST-WRITE grep 으로 작성 직후 8 종 자동 검출 → cloud type-check 회피
- 17 패턴 의 1차 self-check 로 cloud push 차단 사고 80%+ 사전 차단

---

## §9. 자가 진화

본 룰의 1 회차 cover 17 패턴. 새 사고 발생 시:
1. 패턴 번호 추가 + TS 코드 + before/after 코드 + 자동 검증 grep
2. §6 grep 명령 보강
3. §8 사고 사례 표 추가

cross-ref 갱신 의무:
- `Doc/_rules_v2/hooks/pre-write.md` §1 type-check-error-patterns hook 호출 추가
- `Doc/_rules_v2/hooks/post-write.md` §3 자동 검증 grep 8 종 추가
- `Doc/_rules_v2/00_INDEX.md` hook 카탈로그 등록
- `MEMORY.md` 인덱스 추가
