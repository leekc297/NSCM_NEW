# 27. Wijmo 모듈 중복 / Grid 머지 조건 / PivotGrid 패턴 / Sheet 등록 5종

> ⭐ **DMF0007 PSI Tab 추가 작업 (2026-05-28) 에서 도출된 4가지 인사이트 통합**
> - (A) `node_modules/node_modules/` 잔존으로 인한 Wijmo MergeManager `null` 강제
> - (B) Wijmo FlexGrid column header **세로 머지 발동 조건** (TWO_DEPTH + group.header == leaf.header)
> - (C) Wijmo PivotGrid 사용 시 React 패턴 (useMemo + 1회 fields 설정 가드)
> - (D) 신규 sheet 등록 시 BE 5종 매핑 + sheet name 대소문자 정확 일치

작성: 2026-05-28
관련 hooks: `hooks/module-duplication-check.md`
관련 룰: `08_SCREEN_REGISTRATION.md`, `09_WIJMO_VALIDATION_EXPRESSION.md`, `10_API_DYNAMIC_PROC.md`, `12_GRID_COMMON.md`, `21_TROUBLESHOOTING.md`

---

## §A. Module Duplication — `node_modules/node_modules/` 잔존

### 증상

- Wijmo grid 의 `allowMerging = AllowMerging.ColumnHeaders` 가 설정되어 있고, `DataGrid.tsx:130-131` 에서 `grid.mergeManager = new CustomMergeManager(grid)` 가 정상 실행됨에도 불구하고:
- 브라우저 런타임에서 `grid.mergeManager` 가 **`null`** (undefined 아님)
- 결과: 컬럼 헤더 세로 머지가 작동하지 않음
- `handleInitialized` 의 다른 설정 (allowDragging, allowSorting 등) 은 정상 적용됨

### 근본 원인

```
nscm-fe/
├── node_modules/                          ← 정상 (최신 pnpm install)
│   ├── .pnpm/@mescius+wijmo.grid@X.Y.Z/
│   ├── @mescius/wijmo.grid
│   └── node_modules/                      ← 잔존 (이전 설치)
│       ├── .pnpm/@mescius+wijmo.grid@X.Y.Z/
│       └── @mescius/wijmo.grid
```

- 두 `.pnpm` 저장소가 **동일 버전을 각각 독립 복사본** 으로 보유
- `CustomMergeManager extends MergeManager` 의 `MergeManager` 와 FlexGrid 내부 `setter` 가 `instanceof MergeManager` 검사 시 사용하는 `MergeManager` 가 **서로 다른 클래스 인스턴스**
- Wijmo 의 `mergeManager` setter 는 invalid 객체를 받으면 silently `null` 로 저장 (검증: plain duck-typed object 주입 시 동일하게 null 저장됨)
- Vite 의 `apps/web/node_modules/.vite/deps/` prebundle 캐시가 stale 한 inner 모듈을 참조 가능

### 검출 방법 (DevTools 콘솔)

```js
const grid = wijmo.Control.getControl(document.querySelector('.wj-flexgrid'));
console.table({
  allowDragging: grid.allowDragging,           // 0 (None) = handleInitialized 실행됨
  mergeManager_is_null: grid.mergeManager === null,  // true = instanceof 실패
});
```

`allowDragging = 0` 이면서 `mergeManager === null` 인 경우 → **module duplication 확정**.

### 진단 명령

```bash
ls C:/Projects/NSCM/nscm-fe/node_modules/node_modules 2>/dev/null && echo "DUPLICATE EXISTS"
ls C:/Projects/NSCM/nscm-fe/node_modules/node_modules/.pnpm/@mescius+wijmo.grid* 2>/dev/null
```

### 보완 절차

```bash
# 1) Vite 서버 중지 (TaskStop 또는 OS 레벨 kill)
#    netstat -ano | grep :3000 → PID → Stop-Process

# 2) 잔존 디렉토리 + Vite deps 캐시 삭제
rm -rf nscm-fe/node_modules/node_modules
rm -rf nscm-fe/apps/web/node_modules/.vite

# 3) Vite 재기동 (메모리 룰: pnpm dev 금지, vite 직접 실행)
cd nscm-fe/apps/web && ./node_modules/.bin/vite
```

### 발생 회피

- pnpm 재설치 후 항상 `node_modules/node_modules/` 잔존 여부 확인
- `pre-write.md` hook 에서 `wijmo.grid` 또는 `wijmo.olap` import 변경 시 module duplication check 자동 수행 (`hooks/module-duplication-check.md`)

---

## §B. Wijmo FlexGrid Column Header 세로 머지 조건

### 발동 조건 (전부 만족해야 함)

1. `<DataGrid allowMerging={AllowMerging.ColumnHeaders}>` (기본값)
2. `grid.mergeManager` 가 `CustomMergeManager` 인스턴스 (§A 참조)
3. `columnGroups` 에 **2개 이상 header row** 가 존재해야 함 (TWO_DEPTH 이상)
4. 머지 대상 컬럼의 **group header == leaf header** (텍스트 완전 일치)

### `getColumnDepth` 로직 (`columnMapping.ts:116-135`)

| 입력 메타 | depth | 설명 |
|---|---|---|
| 모든 컬럼이 `sClsLblNm` 빈값 AND `lClsLblNm` 빈값 | `ONE_DEPTH` | flat leaf — 머지 안 됨 |
| 1개 이상 `sClsLblNm` 있고 `lClsLblNm` 빈값 (또는 sCls = lCls) | `TWO_DEPTH` | 2단 group |
| 1개 이상 `lClsLblNm` 있음 | `THREE_DEPTH` | 3단 group |

### TWO_DEPTH 매핑 (머지 발동 패턴)

```js
// columnMapping.ts:183-209
group.header = sClsLblNm (없으면 colLblNm)
leaf.header  = colLblNm

// 머지 발동: group.header === leaf.header
// 예: sCls='Paln Week', colLbl='Paln Week' → 두 header row 가 같은 텍스트 → CustomMergeManager 머지
```

### 시드 데이터 표준 — `SCM_MST_SHEET_COLUMNS`

> ⭐ **신규 sheet 시드 시 다음 규칙 의무**:

| 컬럼 패턴 | 규칙 |
|---|---|
| 단순 컬럼 (그룹핑 없음) | `SMALL_CLASS_LABEL_NAME = COLUMN_LABEL_NAME` (완전 동일) |
| 의도된 grouping (예: Measure 그룹 아래 Group + Name) | `SMALL_CLASS_LABEL_NAME = 'Measure'` 동일 그룹명, `COLUMN_LABEL_NAME` 만 다름 |
| 필수 표시 (`*` 등) | **별표는 SMALL_CLASS_LABEL_NAME 에 단독 붙이지 말 것** — `COLUMN_LABEL_NAME` 에도 같이 붙이거나 둘 다 빼고 다른 메커니즘 사용 |

### 자주 보는 위반 사례

```sql
-- ❌ 위반: sCls 에만 * 가 있어서 머지 안 됨
COLUMN_LABEL_NAME = 'Div'
SMALL_CLASS_LABEL_NAME = 'Div*'

-- ✅ 정정: 두 값 통일
COLUMN_LABEL_NAME = 'Div'
SMALL_CLASS_LABEL_NAME = 'Div'

-- ✅ 의도된 grouping (정상)
COLUMN_LABEL_NAME = 'Group'
SMALL_CLASS_LABEL_NAME = 'Measure'   -- 다른 컬럼 'Name' 도 sCls='Measure'

COLUMN_LABEL_NAME = 'Name'
SMALL_CLASS_LABEL_NAME = 'Measure'
```

### 시드 정정 UPDATE 패턴

```sql
-- 의도된 grouping (MEASURE_GROUP/MEASURE) 외 모든 행 통일
UPDATE SCM_MGR.SCM_MST_SHEET_COLUMNS
   SET SMALL_CLASS_LABEL_NAME = COLUMN_LABEL_NAME
 WHERE PROGRAM_ID = '<MNU_ID>'
   AND SHEET_NAME = '<sheetName>'
   AND COLUMN_NAME NOT IN ('MEASURE_GROUP', 'MEASURE')  -- 의도된 grouping 제외
   AND (SMALL_CLASS_LABEL_NAME IS NULL OR SMALL_CLASS_LABEL_NAME <> COLUMN_LABEL_NAME);
```

---

## §C. Wijmo PivotGrid 사용 패턴 (React Wrapper)

### 패키지

- `@mescius/wijmo.olap` (코어)
- `@mescius/wijmo.react.olap` (React wrapper)
- 이미 설치되어 있음 — `pnpm install` 불요. Vite 가 자동으로 prebundle.

### 안티 패턴 (column 미표시 원인)

```tsx
// ❌ 잘못된 패턴 — data 변경 시마다 fields reset 됨
<PivotGrid
  itemsSource={data}
  initialized={(grid) => {
    grid.engine.fields.clear();
    grid.engine.rowFields.push(...);   // useEffect 마다 reset 되어 안 보임
  }}
/>
```

### 권장 패턴

```tsx
import { PivotEngine } from '@mescius/wijmo.olap';
import { PivotGrid } from '@mescius/wijmo.react.olap';
import { useEffect, useMemo } from 'react';

export const SomePivotGrid = ({ data }) => {
  // 1) PivotEngine 인스턴스 1회 생성 (컴포넌트 라이프타임 유지)
  const engine = useMemo(() => {
    const e = new PivotEngine();
    e.autoGenerateFields = true;
    return e;
  }, []);

  // 2) data 변경 시 itemsSource 만 갱신, fields 는 1회만 (guard 조건)
  useEffect(() => {
    engine.beginUpdate();
    engine.itemsSource = data;
    if (engine.rowFields.length === 0 && engine.fields.length > 0) {
      engine.rowFields.push('DIVISION_ID', 'CUSTOMER_CODE', ...);
      engine.columnFields.push('SUMMARY_BUCKET_VALUE');
      engine.valueFields.push('SUMMARY_BUCKET_YN');
    }
    engine.endUpdate();
  }, [data, engine]);

  // 3) PivotGrid 에 engine 인스턴스 직접 전달
  return <PivotGrid itemsSource={engine} ... />;
};
```

### BE 데이터 형식

PivotGrid 는 **long-format raw rows** 가 필요 — PIVOT 안 된 상태.

```sql
-- ✅ PivotGrid 용 SP 출력
SELECT PLAN_WEEK, DIVISION_ID, CUSTOMER_CODE, SCM_SITE_ID,
       MEASURE_GROUP, MEASURE,
       SUMMARY_BUCKET_VALUE,   -- columnFields 의 source
       SUMMARY_BUCKET_YN,      -- valueFields 의 source
       ...
  FROM DM_MST_CUSTOMER_FCST
 WHERE ...
```

**기존 FlexGrid (with dynamic D_YYYYMMDD columns)** 와 차이:
- FlexGrid: BE 가 `MAX(CASE WHEN ... THEN ... END) AS D_YYYYMMDD` 동적 PIVOT 후 wide row 반환
- PivotGrid: BE 는 long-format raw 만 반환, **클라이언트(Wijmo)** 가 PIVOT 수행

---

## §D. 신규 Sheet 등록 시 BE 5종 매핑 + 권한 (필수)

### 등록 누락 증상

- FE 가 `POST /<MNU_ID>/<sheetName>/SEARCH/call-proc` 호출
- BE 로그: `ORA-01403: no data found` at `PKG_NSCM_UI_COMM.PR_GET_PROC_INFO_LIST`
- → `SCM_ADM_MNU_BTN_MPG_M` 매핑 누락

### 5종 매핑 체크리스트

| # | 테이블 | 등록 내용 | 누락 시 |
|---:|---|---|---|
| 1 | `SCM_MST_SHEET_COLUMNS` | 시트의 컬럼 메타 (PROGRAM_ID, SHEET_NAME, COLUMN_NAME, COLUMN_LABEL_NAME, SMALL_CLASS_LABEL_NAME 등) | FE 가 빈 그리드 표시 |
| 2 | `SCM_ADM_API_M` | API_ID → API_URL (PROC_NM) | MNU_BTN_MPG 등록 불가 |
| 3 | `SCM_ADM_PROC_M` | PROC_NM 의 모든 IN/OUT 파라미터 메타 | BE 가 SP 호출 시 파라미터 매핑 실패 |
| 4 | `SCM_ADM_MNU_BTN_MPG_M` | (MNU_ID, SHT_NM, MNU_BTN_CD) → API_ID | **ORA-01403** |
| 5 | `SCM_ADM_USER_GR_MNU_BTN_MPG_M` | (USER_GR_ID, MNU_ID, SHT_NM, MNU_BTN_CD) 권한 | "No Permission" 오류 |

### Sheet name 대소문자 일관성 (필수)

> ⚠️ FE 의 `SHEETS` enum 값과 BE 의 `SHT_NM` 컬럼 값은 **대소문자까지 완전 일치** 해야 함.
> 한 글자 차이로도 BTN_MPG 조회 실패 → ORA-01403.

**과거 사고**: DMF0007 의 권한 테이블에 `customerPsi` (소문자 i) 로 등록되어 있었으나 FE 는 `customerPSI` (대문자 SI) 로 호출 → 권한 매칭 안됨.

**검증 SQL**:
```sql
SELECT DISTINCT SHT_NM FROM SCM_MGR.SCM_ADM_MNU_BTN_MPG_M WHERE MNU_ID='<MNU_ID>'
UNION
SELECT DISTINCT SHT_NM FROM SCM_MGR.SCM_ADM_USER_GR_MNU_BTN_MPG_M WHERE MNU_ID='<MNU_ID>';
-- 한 행만 나와야 함 (FE 의 sheet name 과 정확 동일)
```

### Stand-alone SP vs PKG SP

- **PKG 내 PROCEDURE**: `API_URL = 'PKG_DMF0007.P_DMF0007_GET_CUST_FCST_DATA'`
- **Stand-alone PROCEDURE**: `API_URL = 'P_DMF0007_GET_CUST_PSI_PIVOT_DATA'` (PKG prefix 없음)

`PR_GET_PROC_INFO_LIST` 는 어떤 형식이든 동작. 큰 PKG body 를 통째로 재컴파일 위험 회피용으로 stand-alone SP 도 자주 사용.

### `_artifacts` 시드 SQL 4종 의무 (메모리 룰 보강)

```
_artifacts/<task>-seed.sql              ← 메인 (SQL*Plus PROMPT 포함)
_artifacts/<task>-seed_DBeaver.sql      ← DBeaver 호환 (SET/PROMPT 제거)
_artifacts/<task>-seed_Verify.sql       ← 단일 UNION ALL SELECT
_artifacts/<task>-seed_Diagnose.sql     ← 진단 SELECT 다수
```

검증:
- `_DBeaver.sql` 에 SQL*Plus 명령 잔존 0건: `grep -nE "^SET|^PROMPT|^DEFINE|^&\w|^/$"`
- `_Verify.sql` 단일 문 (UNION ALL): 세미콜론 1개
- ⚠️ `SQL%ROWCOUNT` 는 PL/SQL 외부에서 사용 불가 (ORA-00911) — 메인 SQL 의 `SELECT TO_CHAR(SQL%ROWCOUNT) FROM DUAL` 패턴 금지

---

## §E. 변경 이력

- 2026-05-28 작성 (DMF0007 PSI Tab + PivotGrid 추가 작업 반영)
