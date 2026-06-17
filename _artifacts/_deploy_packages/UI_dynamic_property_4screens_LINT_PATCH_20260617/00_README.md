# UI 동적 속성관리 4 화면 — LINT + VISIBLE SYNC PATCH (2026-06-17, **v4 갱신 — BE 룰 보강**)

## 패치 목적

베이스 패키지 `UI_dynamic_property_4screens_20260616` 적용 후 **사내 로컬 lint 결과 (24 errors + 4 화면 warnings)** 보완.

> ⚠ 사용자 명시 (2026-06-17): "pnpm lint 는 로컬에서 실행 금지, 클라우드에서만 실행". 본 패치는 사용자가 사내 로컬 lint 결과를 AI 에게 전달 → AI 가 정적 추론으로 fix → 변경 파일 취합. **클라우드 lint 재검증 의무**.

## v2 변경 (2026-06-17 갱신)

| 시점 | 결과 |
|---|---|
| v1 14 파일 적용 후 클라우드 lint | **24 errors → 1 error**, 46 warnings → 35 warnings |
| 잔존 1 error | `sales-future-price/SalesFuturePrice.tsx:3:21` `'useMemo' is defined but never used` |
| v2 추가 1 파일 | `SalesFuturePrice.tsx` — 사내 file 이 이미 useMemo 제거 상태였음 (사내↔클라우드 sync 차이). 본 파일 덮어쓰면 1 error 해소 → **0 errors 예상** |

→ v2 총 **15 파일 (4 화면 14 + 1 보조)**.

## v3 변경 (2026-06-17 갱신) — admin 컬럼 속성 전체 동기화

> ⭐ **사용자 보고 (2026-06-17)**: "DMF0043 / DMF0043_01 두 화면에서 UI Category Setup 의 column visible='N' 변경해도 grid 에 계속 나옴" + "visible 뿐 아니라 cell object 등 전체 속성 동기화 필요"

### 4 화면 동기화 상태 진단 (BE/FE cross-check)

| 화면 | grid 구현 | BE → staticColumns | FE → grid 반영 | 결과 |
|---|---|---|---|---|
| DMF0008 ErpEdiMaster | `DataGrid` wrapper (4 grid: Summary/Repair/SalesSite/Sspm) | BE `MenuServiceImpl L72-77` 가 VISIBLE_FLAG='N' row 미리 제거 | wrapper L98-111 `mapRawColumnsToWijmoColumns(staticColumns.filter(c=>c.display))` 표준 매핑 | ✅ 정상 동작 |
| DMF0072 NnMasterMapping | wijmo 직접 (NnMasterMapping.tsx) | 동일 | `mergedColumns = staticColumns.map(...)` 으로 시작 + `visibleColumns.filter(c=>c.visible!==false)` | ✅ 정상 동작 |
| **DMF0043** ContributeMain | wijmo 직접 (ContributeMainGrid.tsx) | 동일 | ❌ **버그**: `BASE_COLUMNS.map + if (!sc) return {...c, visible: true}` 패턴 → BE 가 제거한 컬럼이 fallback 으로 항상 표시 | v3 fix |
| **DMF0043_01** ContributeView | wijmo 직접 (ContributeViewGrid.tsx) | 동일 | ❌ **버그**: `base.map + if (!sc) return c` 동일 패턴 | v3 fix |

### v3 fix 상세

**Root cause**: BE 가 visible='N' row 를 미리 filter (`MenuServiceImpl L73-77` + `GridColumn L72`). staticColumns 에 있는 row 만 = admin 허용. `if (!sc)` 분기를 fallback 으로 처리하면 admin 제거 결정 무력화.

**v3 fix 패턴** (ContributeMainGrid + ContributeViewGrid 공통):
1. `staticColumns` 가 있을 때 (length>0) — BE 가 모든 visible='N' row 미리 제거된 결과로 간주
2. `BASE_COLUMNS.filter(c => staticColumns.some(s => s.colNm === c.binding))` — admin 에 등록 + visible='Y' 만 통과
3. admin 메타로 **전체 column 속성 override** (사용자 v3 요구):
   - `colLblNm` → `header`
   - `colWth` → `width`
   - `horzAlgnCd` ('L'/'R'/'C') → `align`
   - `scale` → `format='nN'`
   - `inputTpCd` ('S'=static) → `isReadOnly`
   - `cellCtrlObjTpCd` → cell control type (BASE 컬럼 추후 콤보/팝업 확장용 metadata)
   - `cellCboDataTp` → combo SQL ID metadata
   - `attribute1` → modal key metadata
   - `lClsLblNm` → ContributeViewGrid 의 다단 헤더 `large`
4. `staticColumns` 가 빈 배열 (BE 미동작 / 메타 미등록) → BASE_COLUMNS fallback (안전망)
5. ContributeViewGrid 는 `columnMetas` 자체가 admin 메타 override 단일 source (formatItem 안 columnMetaRef lookup 도 자동 동기화)

→ v3 총 **15 파일** (v2 와 동일 파일 개수, ContributeMainGrid + ContributeViewGrid 만 재변경).

## v4 변경 (2026-06-17 갱신) — BE isDivisionAllowed 빈 칸 룰 보강 ⭐ 진짜 root cause

> ⭐ **사용자 명시 (2026-06-17)**: "DMF0043 의 팀 컬럼 visible='N' 처리했는데 계속 보임" + "Attribute1 이 빈칸/NULL 이면 Division 상관없이 전체 사용 가능 으로 적용 요청"

### v3 도 동작 안 한 진짜 root cause

v3 fix 적용해도 사용자가 DMF0043 의 "팀" 컬럼 visible='N' 설정 후 계속 표시 → 더 깊은 진단:

**BE `MenuServiceImpl.isDivisionAllowed` (L92-98)**:
```java
private boolean isDivisionAllowed(String attribute1, String divisionId) {
    if (attribute1 == null || attribute1.isEmpty()) return false;   // ← 2026-06-16 룰
    if (divisionId == null || divisionId.isEmpty()) return false;
    return Arrays.stream(attribute1.split(",")).map(String::trim).anyMatch(d -> d.equals(divisionId));
}
```

이전 룰 (2026-06-16): "ATTRIBUTE1 빈 칸 = 화면 비노출"

→ DMF0043 BASE 6 컬럼 (DEPARTMENT_NAME / DEPT_NAME / END_CUST_REPORT / SOLDTO_CUST_REPORT / PRODUCT_GROUP / DM_BIZ_TYPE) 은 division 무관 공용 컬럼 → ATTRIBUTE1 빈 칸 운영 → BE 가 6 컬럼 모두 제거 → staticColumns 빈 배열 → FE 의 BASE_COLUMNS fallback 분기 (v3 의 `staticColumns.length === 0`) 활성화 → admin visible='N' 변경 영원히 무효화

### v4 fix — BE 룰 변경 (사용자 명시)

```java
private boolean isDivisionAllowed(String attribute1, String divisionId) {
    if (attribute1 == null || attribute1.isEmpty()) return true;    // ⭐ 빈 칸/NULL = 전체 허용
    if (divisionId == null || divisionId.isEmpty()) return false;
    return Arrays.stream(attribute1.split(",")).map(String::trim).anyMatch(d -> d.equals(divisionId));
}
```

| 시나리오 | 이전 (v3) | v4 |
|---|---|---|
| ATTRIBUTE1='40,82,81' + divisionId='81' | true | true |
| ATTRIBUTE1='40,82,81' + divisionId='83' | false | false |
| ATTRIBUTE1='' (빈 칸) + divisionId='40' | ❌ false → row 제거 | ✅ true → row 통과 |
| ATTRIBUTE1=NULL + divisionId=any | ❌ false → row 제거 | ✅ true → row 통과 |

→ DMF0043 의 ATTRIBUTE1 빈 BASE 6 컬럼이 staticColumns 에 정상 포함 → FE v3 fix 가 의도대로 동작 → admin visible='N' 즉시 반영 ✅

⚠ measure 의 `isDivisionAllowed` 도 동일 헬퍼 사용 — measure 도 동일 룰 적용 (PIVOT 화면의 measure 도 빈 ATTRIBUTE1 = 전체 허용).

### v4 추가 파일 (1)

| 파일 | 경로 |
|---|---|
| `MenuServiceImpl.java` ⭐v4 BE | `02_BE/admin/menu/MenuServiceImpl.java` |

→ v4 총 **16 파일** (FE 15 + BE 1).

### v4 적용 (BE 재기동 의무)

```
nscm-be/src/main/java/com/lgcns/nscm/admin/menu/MenuServiceImpl.java   ← 02_BE/admin/menu/MenuServiceImpl.java
```

BE `bootRun` 재기동 필요. 사용자 메모리 `feedback_be_restart_login.md` — 재기동 직후 새 창 재로그인 의무.

## 변경 파일 (15)

| # | 파일 | 변경 유형 |
|---:|---|---|
| 1 | `contribute-main/ContributeMain.tsx` | 미사용 `useProcMutation`+`saveMain` 제거 / `void refetch?.()` x2 / `handleDelete` selected 타입 명시 |
| 2 ⭐v3 | `contribute-main/components/ContributeMainGrid.tsx` | wijmo import 순서 (`@mescius/wijmo` → `.grid` → `.react.grid`) + type/value 통합 / **v3: admin 메타 전체 동기화 (BASE_COLUMNS.filter(staticColumns.has) + align/format/isReadOnly + MergedBaseColumn 보존)** |
| 3 | `contribute-main/components/ContributeRatePopup.tsx` | array index key → composite key `${divisionId}-${yyyymm}-${osCorpCd}-${contributionType}` |
| 4 | `contribute-main/components/SearchBar.tsx` | scss import 가 store import 보다 먼저 |
| 5 | `contribute-main/components/VersionPopup.tsx` | wijmo import 순서 + `as VersionRow[] \| undefined` → `as VersionRow[]` (unnecessary union 제거) + unused `eslint-disable-next-line react-hooks/exhaustive-deps` 제거 |
| 6 | `contribute-view/ContributeView.tsx` | parent (`../../components`) import 가 sibling (`./components/...`) 보다 먼저 + 그룹 간 empty line |
| 7 ⭐v3 | `contribute-view/components/ContributeViewGrid.tsx` | wijmo import 순서 + type/value 통합 / **v3: admin 메타 전체 동기화 (columnMetas 통합 + baseColumnAttrs map + align/format 매핑)** |
| 8 | `contribute-view/components/modals/ColumnTitleSetModal.tsx` | `@mescius/wijmo.grid` type import 가 `@mescius/wijmo.react.grid` 보다 먼저 |
| 9 | `contribute-view/components/modals/ContributeVersionModal.tsx` | 동일 (wijmo type before react) |
| 10 | `erp-edi-master/ErpEdiMaster.tsx` | no-multiple-empty-lines (L192~193 빈 줄 1개로) + `void refetchSummary?.()` / `void refetchRepair?.()` |
| 11 | `erp-edi-master/erp-edi-master.utils.ts` | `@mescius/wijmo` import 가 `@mescius/wijmo.grid` 보다 먼저 |
| 12 | `erp-edi-master/useErpEdiMasterStore.ts` | L201 `paramCtn as SearchCondition[typeof curr.paramNm]` cast 제거 (unnecessary) |
| 13 | `nn-master-mapping/NnMasterMapping.tsx` | wijmo import 순서 (`@mescius/wijmo` → `.grid` → `.grid.filter` → `.react.grid`) + `spRows` cast `as NnRow[]` 제거 (unnecessary) + `void refetch?.()` x2 |
| 14 | `nn-master-mapping/components/NnMasterMappingForm.tsx` | import group 내 empty line 제거 + scss 가 store 보다 먼저 + `arr = rows ?? []` cast `as LookupRow[]` 제거 |
| 15 ⭐v2 | `sales-future-price/SalesFuturePrice.tsx` | L3 `import { useEffect, useRef, useState } from 'react';` (useMemo 제거 — 사내 file 이 이미 fix 상태였으나 클라우드 미동기화) |

## 폴더 구조

```
UI_dynamic_property_4screens_LINT_PATCH_20260617/
├─ 00_README.md  (이 파일)
└─ 01_FE/
   ├─ contribute-main/
   │  ├─ ContributeMain.tsx
   │  └─ components/
   │     ├─ ContributeMainGrid.tsx
   │     ├─ ContributeRatePopup.tsx
   │     ├─ SearchBar.tsx
   │     └─ VersionPopup.tsx
   ├─ contribute-view/
   │  ├─ ContributeView.tsx
   │  └─ components/
   │     ├─ ContributeViewGrid.tsx
   │     └─ modals/
   │        ├─ ColumnTitleSetModal.tsx
   │        └─ ContributeVersionModal.tsx
   ├─ erp-edi-master/
   │  ├─ ErpEdiMaster.tsx
   │  ├─ erp-edi-master.utils.ts
   │  └─ useErpEdiMasterStore.ts
   ├─ nn-master-mapping/
   │  ├─ NnMasterMapping.tsx
   │  └─ components/
   │     └─ NnMasterMappingForm.tsx
   └─ sales-future-price/                                                 ⭐ v2 추가
      └─ SalesFuturePrice.tsx
```

## 적용 순서

> **사전 조건**: 베이스 패키지 `UI_dynamic_property_4screens_20260616` 이미 적용 완료. 이 패치는 그 위에 14 파일만 덮어쓰기.

### Step 1: 14 파일 덮어쓰기

```
nscm-fe/features/master/src/pages/
   ├─ contribute-main/ContributeMain.tsx                                ← 01_FE/contribute-main/ContributeMain.tsx
   ├─ contribute-main/components/ContributeMainGrid.tsx                 ← 동일 경로
   ├─ contribute-main/components/ContributeRatePopup.tsx                ← 동일 경로
   ├─ contribute-main/components/SearchBar.tsx                          ← 동일 경로
   ├─ contribute-main/components/VersionPopup.tsx                       ← 동일 경로
   ├─ contribute-view/ContributeView.tsx                                ← 동일 경로
   ├─ contribute-view/components/ContributeViewGrid.tsx                 ← 동일 경로
   ├─ contribute-view/components/modals/ColumnTitleSetModal.tsx         ← 동일 경로
   ├─ contribute-view/components/modals/ContributeVersionModal.tsx      ← 동일 경로
   ├─ erp-edi-master/ErpEdiMaster.tsx                                   ← 동일 경로
   ├─ erp-edi-master/erp-edi-master.utils.ts                            ← 동일 경로
   ├─ erp-edi-master/useErpEdiMasterStore.ts                            ← 동일 경로
   ├─ nn-master-mapping/NnMasterMapping.tsx                             ← 동일 경로
   ├─ nn-master-mapping/components/NnMasterMappingForm.tsx              ← 동일 경로
   └─ sales-future-price/SalesFuturePrice.tsx                           ← 동일 경로 (⭐ v2)
```

### Step 2: 클라우드 lint 재실행 (의무)

```
cd nscm-fe/features/master
pnpm lint
```

기대값:
- v1 적용 후 클라우드 lint 검증 결과 (실측): **24 errors → 1 error**, 46 warnings → 35 warnings.
- v2 (SalesFuturePrice.tsx 추가) 적용 후: **1 error → 0 errors** 예상. warnings 35건 유지.
- v3 (ContributeMainGrid + ContributeViewGrid 재변경) 적용 후: lint 영향 없음 (0 errors 유지), admin SYS0004 UI Category Setup 의 column 속성 변경이 **즉시 grid 반영** 됨.

### v3 검증 (브라우저)

| 시나리오 | 기대 결과 |
|---|---|
| DMF0043 grid 의 BASE 컬럼 1개 admin 에서 `VISIBLE_FLAG='N'` 저장 후 화면 재진입 | 해당 컬럼 사라짐 |
| DMF0043_01 grid 의 BASE 컬럼 `COLUMN_WIDTH=200` 변경 → 화면 재진입 | 200px 적용 |
| DMF0043_01 의 BASE 컬럼 `HORIZONTAL_ALIGN_CODE='R'` 변경 | 우측 정렬 |
| DMF0043_01 의 dynamic 컬럼 (지역×Commission/Markup) `DATA_SCALE_NUMBER=2` 변경 | 소수 2자리 표시 |
| DMF0043 의 BASE 컬럼 `COLUMN_LABEL_NAME='판매부서'` 변경 | header 라벨 변경 |

⚠ **사전 조건**: `SCM_MST_SHEET_COLUMNS` 에 DMF0043 main + DMF0043_01 main BASE 컬럼이 등록되어 있어야 함 (베이스 패키지 `03_META/00_Verify_SHEET_COLUMNS.sql` 의 카운트 검증). 미등록 시 FE 가 `staticColumns` 빈 배열 → BASE_COLUMNS fallback (admin 변경 무효화).

## 보류 warnings (별도 결정 필요)

### 4 화면 한정 잔존 warnings (클라우드 lint 실측)

| 패턴 | 위치 | 보류 사유 |
|---|---|---|
| `react-hooks/exhaustive-deps` | `ContributeMain.tsx` L232, `SearchBar.tsx` L57, `ContributeView.tsx` L89, `ContributeViewForm.tsx` L55 | deps 추가 시 무한 loop 위험. AS-IS Form_Load 의 "최초 1회" 자동 조회 의도 — `eslint-disable-next-line` 또는 의도적 deps 결정 필요 |
| `import/no-relative-parent-imports` | `SearchBar.tsx` L6, `ErpEdiMasterUpdateHistoryBar.tsx` L1, `NnMasterMappingForm.tsx` L8 | 부모 폴더 `*.module.scss` 참조. 컴포넌트 동일 폴더로 scss 이동 또는 디자인 토큰 외부화 필요 (구조적 결정) |

### 4 화면 외 (본 패치 범위 밖, 별도 PR 권장)

| 위치 | 패턴 | 건수 |
|---|---|---|
| `components/{customerModal,itemByDivisionModal,ownerByDivisionModal,ownerModal,projectByDivisionModal,projectModal,regionModal,storageLocationModal,teamModal}/` | exhaustive-deps / no-empty-function | 10+ |
| `pages/customer-forecast-master/` | exhaustive-deps + floating-promises | 3 |
| `pages/customer-model-mapping/` | exhaustive-deps | 1 |
| `pages/sales-future-price/` (SalesFuturePrice.tsx 외) | floating-promises + non-null-assertion + exhaustive-deps + parent-imports | 12+ |
| `pages/sales-site/`, `pages/sales-site-project-model/` | exhaustive-deps | 2 |

## 의존성 (변경 없음)

- BE / SP / API_M / PROC_M / MNU_M / SHEET_COLUMNS / USER_GR_MNU_BTN / CMBO_SQL_M — 무변경
- 베이스 패키지 (`UI_dynamic_property_4screens_20260616`) 의 i18n PATCH / SHEET_COLUMNS 검증 SQL — 그대로 유효

## 롤백

각 파일을 베이스 패키지 (`UI_dynamic_property_4screens_20260616/01_FE/{화면}/`) 의 동일 경로 파일로 복원. 14 파일 단위. DB 변경 없음.

## 룰셋 cross-ref

- 변경 패턴 출처: ESLint `import/order` + `@typescript-eslint/no-unnecessary-type-assertion` + `@typescript-eslint/no-floating-promises` + `react-hooks/exhaustive-deps` + `react/no-array-index-key` + `unused-imports/no-unused-imports` + `no-multiple-empty-lines`
- 관련 룰: `Doc/_dev_rules/02_DEVELOPMENT_RULES.md` (import/no-relative-parent / wijmo import 순서 표준) — **갱신 후보** (4 wijmo 패키지 import 순서 명시)
- 관련 메모리: `feedback_pnpm_install_avoidance.md` (2026-06-17 갱신 — lint 클라우드 전용)

## 작성

- 일자: 2026-06-17
- 베이스: `UI_dynamic_property_4screens_20260616`
- 다음 단계: 클라우드 lint 재검증 → 추가 errors/warnings 있으면 동일 PATCH 폴더에 v2 작성 (또는 별도 PATCH)
