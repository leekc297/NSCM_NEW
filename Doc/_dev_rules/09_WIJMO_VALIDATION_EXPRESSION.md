# 09. As-Is Spread/Grid → To-Be Wijmo 마이그레이션 룰

> ⚠️ **최우선 룰**: [`hooks/anti-simplification.md`](hooks/anti-simplification.md) (2026-05-22 신규) — Validation/Expression 추출 작업은 절대 단순화 금지. 다중 패턴(MessageHelper.GMessageBox + MessageBox.Show + GetColumnIndex == -1 + Division 분기 + 권한 분기) 동시 적용 + 화면별 .cs 처음~끝 Read 의무.
>
> **목적**: As-Is GSCM FarPoint Spread/DevExpress Grid에 적용된 **모든 Validation(2,683건)과 Expression(1,766건)** 을 To-Be Wijmo FlexGrid/FlexSheet에 100% 보존.
> **근거 산출물** (신뢰 우선순위 — §1 원칙 4 참조):
>   - **1차** `Doc/_analysis/domain_{DM|Common|SCM|FP|SCP|SSP}/screens/{id}/validation.md`
>   - **1차** `Doc/_analysis/domain_{DM|Common|SCM|FP|SCP|SSP}/screens/{id}/expressions.md`
>   - **2차** `{27|28|29}_*_Screens/{27|28|29}_*_{id}.xlsx` — `11_Validation` + `12_Expression` 시트만 (1~10 시트는 ⚠ 화면 ID 불일치 가능)
> **대상**: 인간 개발자 + AI(Claude).
> **위반 시**: 화면 동작 불일치 (실데이터 정합성 불량) → PR reject.

## 1. 핵심 원칙

### 원칙 1 — As-Is 누락 0건
신규 화면 1개를 생성할 때 다음 두 산출물의 **모든 행**이 To-Be 코드에 대응되어야 한다.

```
Validation 건수(11_Validation) = To-Be에 적용된 validator 건수
Expression 건수(12_Expression) = To-Be에 적용된 cellTemplate/aggregate/formula 건수
```

### 원칙 2 — 매핑 추적 가능
각 적용 코드 옆에 As-Is 원소스 라인 주석 필수.

```ts
// AS-IS: DMF0021_SalesPlan.cs:994 — siMain.LockRange(i, j, ..., false)
g.cellEditEnding.addHandler((s, e) => { ... });
```

### 원칙 3 — 사업부 분기 절대 보존
DM/SCM 화면의 `사업부(Division 40/81/82) 분기`는 To-Be에서도 동일하게 분기 처리. 통합/단순화 금지.

### ⭐ 원칙 4 — 원본 신뢰성 가드 (2026-05-18 추가)

화면별 분석 산출물은 두 종류가 있고, **신뢰 우선순위가 다르다**:

| 우선순위 | 자료 | 신뢰도 | 비고 |
|---|---|---|---|
| **1차 (Source of Truth)** | `Doc/_analysis/domain_{DM\|Common\|SCM\|FP\|SCP\|SSP}/screens/{id}/*.md` (8개 MD) | ✅ 신뢰 | 전 도메인 1차 참조 |
| **2차 (보조)** | `{27\|28\|29}_*_Screens/{27\|28\|29}_*_{id}.xlsx`의 **`11_Validation` + `12_Expression`** 시트 | ✅ 신뢰 | .cs 원소스 직접 파싱 |
| **3차 (참고용)** | 위 xlsx의 **`1_화면개요` ~ `10_ToBe권장`** 10개 시트 | ⚠ **불일치 가능** | 1단계 추출기 캐시 재사용 버그로 다른 화면 데이터가 들어 있을 수 있음 |

**검증 룰**:
1. xlsx 파일 사용 전 `1_화면개요` 시트의 "화면 ID" 행이 **파일명의 화면 ID와 일치하는지** 확인할 것.
2. 불일치 또는 `00_정정안내_READ_ME` 시트가 있으면 → **1~10 시트 무시, MD 폴더 1차 참조**.
3. 카운트 일치 의무는 **MD의 `validation.md`/`expressions.md` 행 수 = 11/12 시트 행 수 = To-Be 코드 적용 건수** 로 평가한다.
4. 손상된 xlsx (`__corrupted__/` 격리됨)는 MD 폴더만으로 진행한다.

**최초 발견 사고**: `27_DM_Screens/` 14개 파일에서 1~10 시트가 다른 화면(주로 `DMF0003_MktFcst` 또는 직전 화면) 내용으로 채워짐. 2026-05-18 Cowork로 안내 시트 추가 보완 완료. 백업: `27_DM_Screens/__bak_20260518/`.

## 2. Validation 7 패턴 → Wijmo 매핑

| # | As-Is 패턴 | As-Is 예시 | To-Be Wijmo 매핑 |
|---|---|---|---|
| 1 | `MessageHelper.GMessageBox("MSG####")` | MSG0001 ~ MSG9999 | `import { showAlert } from '@shared/ui'; showAlert(t('msg.MSG0001'))` |
| 2 | `MessageBox.Show(...)` 직접 호출 | `MessageBox.Show("저장하시겠습니까?")` | `await confirm({ title, message })` (Promise 기반) |
| 3 | `GetColumnIndex(...) == -1` 필수 컬럼 체크 | `if (siMain.GetColumnIndex(DefColumns.QTY) == -1) return;` | TS: `if (!grid.columns.getColumn('QTY')) return;` |
| 4 | 사전 검증 `if (조건) { return/break; }` | NULL/빈값/날짜 | Zod schema + form validator (Frontend) + DB SP validation (Backend) |
| 5 | Grid 이벤트 (`CellChange/KeyDown/Validating`) | `_CellChange += handler` | `grid.cellEditEnding.addHandler` / `grid.cellEditEnded` |
| 6 | 권한 분기 (`UserInfo/Role/JV_Planner`) | `if (UserInfo.IsJVPlanner)` | `const { isJvPlanner } = useUserStore(s => ({ ... }))` + 조건부 렌더 |
| 7 | 사업부 분기 (Division 40/81/82) | `if (sDivision == "40")` | `switch (division) { case '40': ... }` — 분기 그대로 유지 |

### Validation 적용 표준 템플릿

```tsx
// features/demand/src/pages/dmf0021-sales-plan/hooks/useDmf0021Validation.ts

import { z } from 'zod';
import { useUserStore } from '@shared/stores';
import type { Dmf0021Row } from '../types';

const baseSchema = z.object({
  // 4. 사전 검증 — 필수값
  // AS-IS: DMF0021_SalesPlan.cs:1234 — if (string.IsNullOrEmpty(...)) MessageHelper.GMessageBox("MSG0001");
  DIVISION_ID: z.string().min(1, 'msg.MSG0001'),
  // ...
});

export function useDmf0021Validation(division: string) {
  const isJvPlanner = useUserStore((s) => s.isJvPlanner);

  return (row: Dmf0021Row): string[] => {
    const errors: string[] = [];

    // 1. MSG validation
    const parsed = baseSchema.safeParse(row);
    if (!parsed.success) errors.push(...parsed.error.errors.map((e) => e.message));

    // 7. 사업부 분기 — AS-IS: cs:440
    switch (division) {
      case '40':
        // AS-IS: cs:441-460 — Division 40 전용 체크
        if (!row.PROJECT_CODE) errors.push('msg.MSG0123');
        break;
      case '81':
        // AS-IS: cs:461-475
        break;
      case '82':
        break;
    }

    // 6. 권한 분기 — AS-IS: cs:512 — if (UserInfo.IsJVPlanner)
    if (isJvPlanner && !row.JV_PLAN_REASON) errors.push('msg.MSG0456');

    return errors;
  };
}
```

```tsx
// Grid 이벤트 연결 (5. Grid 이벤트)
// AS-IS: DMF0021_SalesPlan.cs:2882 — siMain_CellChange handler
useEffect(() => {
  const grid = gridRef.current?.control;
  if (!grid) return;

  const handler = (s: wjGrid.FlexGrid, e: wjGrid.CellEditEndingEventArgs) => {
    const row = s.rows[e.row].dataItem as Dmf0021Row;
    const errors = validate(row);
    if (errors.length) {
      e.cancel = true;
      showAlert(errors.map((k) => t(k)).join('\n'));
    }
  };
  grid.cellEditEnding.addHandler(handler);
  return () => grid.cellEditEnding.removeHandler(handler);
}, [validate]);
```

## 3. Expression 6 패턴 → Wijmo 매핑

| # | As-Is 패턴 | As-Is 예시 | To-Be Wijmo 매핑 |
|---|---|---|---|
| 1 | `Cells[r,c].Formula = "=SUM(...)"` | FarPoint Cell.Formula | **FlexSheet**: `sheet.setCellData(r, c, '=SUM(A1:A10)', false, true)` |
| 2 | 합계변수 `iSum`/`dblTotal` (누적) | `iSum += int.Parse(value)` | **FlexGrid**: `<GroupAggregate property='QTY' aggregate='Sum' />` |
| 3 | `LockRange(...)` / `.Locked = true/false` | 행/셀 조건부 잠금 | `grid.cellEditEnding` + `e.cancel = true` 또는 `cellTemplate` 의 `readOnly` |
| 4 | `SetValue(r, c, expr)` 산술 | `setValue(r, c, qty * price)` | `cellEditEnded` 핸들러 내 계산 후 `setCellData` |
| 5 | `ColumnHeaderSpan(..., "SUM", ...)` | 헤더에 SUM 표시 | FlexGrid `groupHeaderFormat` + `getMergedRange` 또는 footer row |
| 6 | `_CellChange/_TextChanged/_EditModeOff` 이벤트 계산 | 변경 시 자동 합계 갱신 | `grid.cellEditEnded.addHandler` 내 산술 + `dataMap` 재계산 |

### Expression 적용 표준 템플릿

#### 3.1. Cell.Formula (FlexSheet 사용)

```tsx
// AS-IS: DMF0009_BizPlanPrice_Input.cs:455 — siMain.Cells[r,c].Formula = "=A1+B1"
import * as wjSheet from '@grapecity/wijmo.grid.sheet';

const sheet = sheetRef.current?.control;
sheet?.setCellData(r, c, '=SUM(D2:D10)', false, true);  // (row, col, value, isFormula, refresh)
```

#### 3.2. 합계변수 / SUM헤더 — FlexGrid GroupAggregate

```tsx
// AS-IS: DMF0021_SalesPlan.cs — iSum += int.Parse(siMain.GetText(i, col))
import { CollectionView } from '@mescius/wijmo';
import { FlexGrid, FlexGridColumn, FlexGridColumnGroup } from '@mescius/wijmo.react.grid';

const cv = useMemo(() => {
  const view = new CollectionView(data);
  view.groupDescriptions.push(new PropertyGroupDescription('DIVISION_ID'));
  return view;
}, [data]);

return (
  <FlexGrid itemsSource={cv} showGroups>
    <FlexGridColumn binding="QTY" header="수량" aggregate="Sum" />
  </FlexGrid>
);
```

#### 3.3. 조건부잠금 (LockRange) — 가장 빈번한 패턴 (DM 1,454건)

```tsx
// AS-IS: DMF0021_SalesPlan.cs:994 — siMain.LockRange(i, j, i, max, false);
// 조건: 행이 신규 입력일 때만 편집 가능

const isEditable = (row: Dmf0021Row, col: string) => {
  // AS-IS 라인 주석
  // cs:994 — INSERT 행은 편집 가능
  if (row.STATUS === 'INSERT') return true;
  // cs:1001 — Week 컬럼만 편집 가능 (BucketType==Week)
  if (bucketType === 'W' && weekEditCols.includes(col)) return true;
  return false;
};

const onCellEditEnding = (s: wjGrid.FlexGrid, e: wjGrid.CellEditEndingEventArgs) => {
  const row = s.rows[e.row].dataItem as Dmf0021Row;
  const col = s.columns[e.col].binding!;
  if (!isEditable(row, col)) e.cancel = true;
};
```

또는 컬럼 단위 readOnly:
```tsx
<FlexGridColumn binding="DIVISION_ID" isReadOnly={(item) => item.STATUS !== 'INSERT'} />
```

#### 3.4. SetValue 산술 / 이벤트 계산

```tsx
// AS-IS: DMF0021_SalesPlan.cs — siMain_CellChange += siMain.SetValue(r, c, qty * price);
const onCellEditEnded = (s: wjGrid.FlexGrid, e: wjGrid.CellEditEndedEventArgs) => {
  const row = s.rows[e.row].dataItem as Dmf0021Row;
  const col = s.columns[e.col].binding;
  if (col === 'QTY' || col === 'PRICE') {
    // cs:1234 — AMOUNT = QTY * PRICE
    row.AMOUNT = (row.QTY ?? 0) * (row.PRICE ?? 0);
    s.invalidate();
  }
};
```

## 4. 신규 화면 작성 절차 (필수)

### Step 1 — As-Is 산출물 읽기

```
1. Doc/_analysis/domain_{XXX}/screens/{화면ID}/validation.md
2. Doc/_analysis/domain_{XXX}/screens/{화면ID}/expressions.md
3. {27|28|29}_*_{화면ID}.xlsx → 11_Validation + 12_Expression 시트
```

### Step 2 — 카운트 기록

```typescript
// 화면 최상위 파일에 주석
/**
 * DMF0021 — Sales Plan (To-Be)
 *
 * AS-IS 매핑 카운트:
 *   Validation: 141건 (cs:DMF0021_SalesPlan.cs)
 *   Expression: 120건 (cs:DMF0021_SalesPlan.cs)
 *
 * @as-is-source 06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0021_SalesPlan/DMF0021_SalesPlan.cs
 * @validation-md Doc/_analysis/domain_DM/screens/DMF0021_SalesPlan/validation.md
 * @expression-md Doc/_analysis/domain_DM/screens/DMF0021_SalesPlan/expressions.md
 */
```

### Step 3 — 적용 후 매핑 매트릭스 작성

`features/{domain}/src/pages/{kebab-id}/__asis-mapping__.md` 파일 생성. **2026-05-22 갱신** — DMF0020 (Validation 71 + POPUP 12 = 83건) 작업을 통해 표준 양식 확정.

#### 3.1 표준 헤더 (필수)

```markdown
# DMF{####} ({ScreenName}) As-Is → To-Be 매핑 매트릭스

**As-Is 소스**: `Doc/_legacy_source/06_UIL/.../{ScreenName}.cs` (N줄)
**To-Be 위치**: `nscm-fe/features/{domain}/src/pages/{kebab-page}/`
**작성일**: YYYY-MM-DD
**총 매핑 건수**: **N건** (Validation X + Expression Y + POPUP Z)

> **룰**: 1) 모든 As-Is 행은 To-Be 코드 위치에 1:1 매핑. 2) 각 To-Be 코드에 `// AS-IS: {파일명}.cs:LLLL` 주석. 3) ❌ 행이 1건도 남으면 PR Reject. 4) 사업부 분기 (40/81/82) 통합 금지.
```

#### 3.2 카테고리별 §섹션 분리 (필수 — Validation 10건 이상 시)

핸들러/메서드 단위로 §1.1 ~ §1.N 섹션 분리. 각 섹션 헤더에 핸들러명 + As-Is 라인 범위 + 건수 명시.

```markdown
## 1. Validation 매핑 (N 행)

> 카운트: `validation.md` 의 §전체 Validation 목록 N건 == 본 매트릭스 1~N 행.

### 1.1 Form_Load / InitControls / KeyDown (6건, line 203~482)

| # | Handler | As-Is Line | As-Is 조건 | To-Be 위치 | 상태 |
|---:|---|---:|---|---|:---:|
| 1 | Form_Load | 203 | `if (clbDivisions...Substring(0,2) == "81")` 사업부 81 분기 | `hooks/useXxxValidation.ts:applyDivision81PlantSiteFilter()` | ✅ |
| 2 | InitControls | 320 | ... | ... | ✅ |

### 1.2 EditButton (11건, line 876~1149)
| # | Handler | As-Is Line | As-Is 조건 | To-Be 위치 | 상태 |
|---:|---|---:|---|---|:---:|
| 7 | EditButton | 876 | `MSG00448` 편집 모드 가드 | `hooks/useXxxValidation.ts:guardEnterEditMode()` | ✅ |
| ... |

### 1.3 FindData / SaveData / InsertRow / ... 동일 형식
```

#### 3.3 Expression 매핑 (별도 § 분리)

```markdown
## 2. Expression 매핑 (N 행)

> `expressions.md` 의 N건 (SUM 헤더 / Cell.Formula / LockRange 등) 매핑.

| # | Handler | As-Is Line | As-Is Expression | To-Be 위치 | 상태 |
|---:|---|---:|---|---|:---:|
| N+1 | SetSpreadHeaderSpan | 645 | `siMain.ColumnHeaderSpan(...)` | `hooks/useXxxExpression.ts:buildLargeSumHeader` | ✅ |
```

#### 3.4 ⭐ POPUP 매핑 룰 (2026-05-22 추가 — DMF0020 작업 반영)

As-Is POPUP `.cs` 가 별도 Validation 을 가지면 매트릭스에 §3 으로 추가. **분류 2종**:

**(A) 전용 POPUP** — 본 화면 전용. `components/modals/{ModalName}Modal.tsx` 에 매핑.
**(B) 공통 POPUP** — 다른 화면도 호출. `⚠` 표시 + To-Be 위치는 "공통 컴포넌트" 또는 "별도 화면 ID".

```markdown
## 3. POPUP N종 추가 Validation (메인 외 X 행)

### 3.1 {ModalName} Modal — 전용 POPUP (As-Is `{ModalName}Popup.cs`)
| # | Handler | Msg ID | 조건 | To-Be 위치 | 상태 |
|---:|---|---|---|---|:---:|
| P1 | EditButton | MSG00142 | `!IsLock(SheetName)` | `components/modals/{ModalName}Modal.tsx:guardLock` | ✅ |
| P2 | FindData | MSG00108 | Period 역전 | `components/modals/{ModalName}Modal.tsx:validatePeriodOrder` | ✅ |

### 3.2 {OtherPopup} — 공통 POPUP (As-Is `{Common}Popup.cs`)
| # | Handler | Msg ID | 조건 | To-Be 위치 | 상태 |
|---:|---|---|---|---|:---:|
| P3 | FindData | MSG00097 | Division 미선택 | (공통 컴포넌트 `@shared/components/{CommonPicker}`, 호출만) | ⚠ |
| P4 | Apply | (silent) | 선택 0건 | (공통 컴포넌트, 호출만) | ⚠ |
```

> **⚠ 표시 룰**: 공통 POPUP 은 본 화면 작업 범위 외. `⚠` 표시 + To-Be 위치를 "(공통 컴포넌트, 호출만)" 으로 표기. PR Reject 대상 **아님**. follow-up 으로 별도 PR 처리.

#### 3.5 카운트 검증 표 (필수 — 매트릭스 마지막)

```markdown
## 카운트 검증

| 구분 | As-Is 카운트 | To-Be ✅ | 일치 |
|---|---:|---:|:---:|
| Validation (메인) | 71 | 71 | ✅ |
| Expression (메인) | 2 | 2 | ✅ |
| Popup Validation (전용 N popup) | 6 | 6 | ✅ |
| Popup Validation (공통 M popup) | 6 | 6 (⚠) | ✅ (follow-up) |
| **합계** | **85** | **85** | ✅ |

> 메인 + 전용 POPUP = PR Reject 기준. 공통 POPUP (⚠) 은 별도 follow-up.
```

#### 3.6 변경 이력 (필수)

```markdown
## 변경 이력
- YYYY-MM-DD: 초기 작성 (모든 행 ✅, ⚠ N행)
- YYYY-MM-DD: ... 갱신
```

#### 3.7 As-Is 라인 주석 의무

To-Be 코드에 매핑 행마다 `// AS-IS: {파일명}.cs:LLLL` 주석. 매트릭스의 `As-Is Line` 컬럼과 코드 주석이 1:1 일치.

```ts
// AS-IS: DMF0020_SalesFuturePrice.cs:1279
const validateFindWorkInProgress = useCallback((): boolean => { ... }, []);
```

### Step 4 — Hook 검증

`pre-submit` Hook이 두 카운트 일치 여부를 자동 검증.

## 5. Wijmo 컴포넌트 선택 가이드

| 케이스 | 컴포넌트 |
|---|---|
| 일반 데이터 그리드 (편집 + 조회) | `@mescius/wijmo.react.grid` `FlexGrid` |
| Excel-like Cell.Formula 사용 | `@mescius/wijmo.react.grid.sheet` `FlexSheet` |
| 피벗 / 다축 집계 | `@mescius/wijmo.react.olap` `PivotGrid` |
| 트리 구조 | `FlexGrid` + `treeIndent` 설정 |
| 가상화 (대량 행) | `FlexGrid` 기본 내장 (별도 설정 불요) |

### Cell.Formula가 사용된 화면 (FlexSheet 필요)

DM 49 화면 중 Cell.Formula 사용 화면: DMF0009_BizPlanPrice_Input(5건) 등 5건. 이 화면은 **반드시 FlexSheet 사용**.

## 6. MSG ID → i18n 매핑

As-Is `MSG####` 문자열은 GSCM `SCM_ADM_MSG_M` 마스터에 정의되어 있다. To-Be에서는 i18n 키로 변환:

```
MSG0001 → t('msg.MSG0001')  ("필수 항목입니다.")
MSG0123 → t('msg.MSG0123')  ("프로젝트 코드는 필수입니다.")
...
```

i18n 파일 위치: `apps/web/src/locales/ko/msg.json` (자동 생성 스크립트는 후속 작업).

## 7. 권장 코드 스플릿 구조

> **2026-05-22 갱신** — DMF0020 (확장 패턴) 기반으로 정형화. `05_SCREEN_TEMPLATE.md` §2.0.2 의 표준 폴더 구조 그대로.

### 7.1 확장 패턴 (Validation ≥ 20건 또는 POPUP ≥ 1개)

```
features/{domain}/src/pages/{kebab-page}/
├── {PageName}.tsx                          # 메인 페이지 (검색/저장 핸들러)
├── {page-name}.constants.ts                # MENU_ID/SHEETS + DIVISION_CODE/GROUP_KEY_COLUMNS 등
├── use{PageName}Store.ts                   # Zustand (filters + dynamicColumns + modalState)
├── __asis-mapping__.md                     # ⭐ As-Is → To-Be 매트릭스 (필수)
├── index.ts                                # export { PageName }
├── hooks/                                  # ⭐ 분리 의무 (≥20건)
│   ├── use{PageName}Validation.ts          # Validation 적용 (사업부 분기 그대로)
│   └── use{PageName}Expression.ts          # Expression 적용 (수식/Footer Aggregate)
└── components/
    ├── {PageName}Form.tsx                  # 검색 영역 (Zod schema)
    ├── {PageName}Form.module.scss
    ├── {PageName}Grid.tsx                  # DataGrid 래퍼
    └── modals/                             # ⭐ As-Is POPUP → Modal 통합
        ├── {Modal1}Modal.tsx
        ├── {Modal1}Modal.module.scss
        └── ...
```

### 7.2 hooks/ 분리 룰 (필수 조건)

다음 조건 중 **1개 이상** 충족 시 `hooks/useXxxValidation.ts` + `hooks/useXxxExpression.ts` 로 분리 **의무**:

```
[ ] Validation 건수 ≥ 20
[ ] Expression 건수 ≥ 5
[ ] 사업부 분기 (40/81/82) ≥ 6 건
[ ] 핸들러 종류 (FindData / SaveData / EditButton / InsertRow / fnValidation 등) ≥ 5
```

분리하지 않고 `{PageName}.tsx` 안에 인라인 작성 시 → PR Reject (가독성/테스트성/일관성 침해).

### 7.3 hooks 내부 명명 규약

```ts
// hooks/useXxxValidation.ts

/** #N  AS-IS: {파일명}.cs:LLLL  {조건 또는 MSG ID 설명} */
const {camelCaseFunctionName} = useCallback((...args): boolean => {
  // ...
  return ok;
}, [deps]);
```

- 각 메서드의 JSDoc 첫 줄은 `#N  AS-IS: ...` 형식 (매트릭스의 # 와 라인 번호 1:1)
- 사업부 분기는 `editButtonForDivision40()`, `editButtonForDivision81()` 처럼 분기명을 메서드명에 명시 (통합 금지)
- 반환 타입은 `boolean` 또는 `{ ok: boolean; field?: string }` (page 측에서 if-not-return)

### 7.4 기본 패턴 (소규모 화면)

`05_SCREEN_TEMPLATE.md` §2.0.1 참조 — `hooks/` / `modals/` 없이 7 파일만.

## 8. 자기 점검 체크리스트 (코드 작성 직후)

```
[ ] validation.md 모든 행이 useXxxValidation.ts에 반영되었나? (카운트 일치)
[ ] expressions.md 모든 행이 useXxxExpression.ts 또는 cellTemplate에 반영되었나?
[ ] 각 적용 코드에 AS-IS 원소스 라인 주석이 있는가?
[ ] __asis-mapping__.md 매트릭스 작성 완료?
[ ] 사업부 분기(40/81/82) 통합/단순화 없이 그대로 보존?
[ ] Cell.Formula 사용 화면은 FlexSheet 적용?
[ ] MSG#### → t('msg.MSG####') 변환?
[ ] LockRange 조건이 isReadOnly 또는 cellEditEnding에 그대로 매핑?
[ ] 권한 분기(UserInfo/Role)가 useUserStore 셀렉터로 변환?
```

## 9. 절대 금지

1. ❌ As-Is Validation/Expression 누락 (1건이라도)
2. ❌ AS-IS 원소스 라인 주석 생략
3. ❌ `__asis-mapping__.md` 미작성
4. ❌ Cell.Formula 화면에 FlexGrid 사용 (FlexSheet 필요)
5. ❌ MSG#### 하드코딩 (i18n 키 미사용)
6. ❌ 사업부 분기 통합 ("간소화" 목적)
7. ❌ `e.cancel = true` 없이 LockRange 무시
8. ❌ `console.log`로 validation 에러 표시 (`showAlert`/`toast` 사용)

## 10. 위반 적발 예시

### Bad ❌

```tsx
const onCellEdit = (e) => {
  if (!data.QTY) {
    console.log('수량 필수');  // ❌ console + 메시지 하드코딩
    return;
  }
  // ❌ 사업부 분기 없음
};
```

### Good ✅

```tsx
// AS-IS: DMF0021_SalesPlan.cs:1234, 1262, 1290
const onCellEdit = (s, e) => {
  const row = s.rows[e.row].dataItem as Dmf0021Row;
  const errors = validate(row);  // useDmf0021Validation 사용
  if (errors.length) {
    e.cancel = true;
    showAlert(errors.map(t).join('\n'));
  }
};
```

## 11. 관련 문서

| 경로 | 내용 |
|---|---|
| `03_FE_RULES.md` §Wijmo 섹션 | FE 코드 일반 규약 |
| `05_SCREEN_TEMPLATE.md` | 신규 화면 코드 템플릿 |
| `08_SCREEN_REGISTRATION.md` | 메타 Table 4종 일괄 등록 |
| `hooks/pre-write.md` | 작성 전 validation/expressions.md 강제 읽기 |
| `hooks/post-write.md` | 작성 후 카운트 검증 |
| `hooks/pre-submit.md` | PR 제출 전 `__asis-mapping__.md` 검증 |
| `Doc/_analysis/INDEX.md` | 도메인 분석 자료 진입점 |

## 12. ⭐ 자동화 스크립트 (2026-05-13 추가)

| 스크립트 | 위치 | 용도 |
|---|---|---|
| `gen_asis_mapping.py` | `Doc/_analysis/scripts/` | `__asis-mapping__.md` 빈 매트릭스 자동 생성 |
| `gen_i18n_msg_json.py` | `Doc/_analysis/scripts/` | MSG #### → i18n JSON 자동 생성 |
| `gen-procedures.ts` | `To-be_v2_converted/08_Screen_Registration/04_*` (To-Be FE 적용) | procedures.d.ts 자동 생성 |
| `PR_GET_PROCEDURES_METADATA` | `To-be_v2_converted/08_Screen_Registration/03_*` (DB) | FE gen-procedures 백엔드 |

상세 사용법: [`Doc/_analysis/scripts/README.md`](../../_analysis/scripts/README.md)

### 표준 작업 흐름 (신규 화면 마이그레이션 1개)

```bash
# 1. 빈 매트릭스 생성
python3 Doc/_analysis/scripts/gen_asis_mapping.py \
    --out C:/Projects/NSCM/nscm-fe/features/demand/src/pages/dmf0021-sales-plan/__asis-mapping__.md \
    DMF0021_SalesPlan

# 2. 화면 코드 작성 (Validation/Expression Hook 작성, 매트릭스 ✅ 마킹)

# 3. i18n JSON 갱신 (전체 화면 공용 — 화면 작업 후 1회)
python3 Doc/_analysis/scripts/gen_i18n_msg_json.py \
    --out C:/Projects/NSCM/nscm-fe/apps/web/src/locales/

# 4. procedures.d.ts 갱신 (BE 메타 → FE 타입)
cd C:/Projects/NSCM/nscm-fe && pnpm gen:procedures
```

---

> 본 문서는 **As-Is 동작 보존**의 최후 방어선입니다. 한 줄도 누락 없이 적용하세요.
> 변경 시 `01_CLAUDE.md`, `03_FE_RULES.md`, `05_SCREEN_TEMPLATE.md`, `CLAUDE.md` (워크스페이스 루트) 동기화 필수.
