# GAP 421 — DMF0074 Metal Link Price · Excel Form 빈 양식(데이터 0행) 보완 가이드

- 일자: 2026-10-15 / 대상: `nscm-fe` 1파일 (DB 변경 없음)
- 상시 지시(보완 = DB 우선, FE 는 가이드만)에 따라 FE 는 **직접 수정하지 않고** 아래 가이드만 제공한다.

## 1. 원인 (확인 결과)

| 축 | 상태 | 근거 |
|---|---|---|
| FE Excel Form 버튼 | ❌ **결함** | `MetalLinkPrice.tsx` `handleExcelFormDownload` 가 양식 조회 SP 를 호출하지 않고, 메인 그리드 `itemsSource = []` 로 **비운 채** export → 머리글만 있는 빈 파일 |
| 메타 `SCM_ADM_API_M` | ✅ | `DMF0074_template_SEARCH` → `PKG_DMF0074.P_DMF0074_GET_METAL_LINK_TEMPLATE` (USE_YN=Y) |
| 메타 `SCM_ADM_PROC_M` | ✅ | divisionId / sesUserId / mnuId IN + o_rc1 / o_result_cursor OUT (5행, SP 시그니처와 일치) |
| SP `P_DMF0074_GET_METAL_LINK_TEMPLATE` | ✅ | 사내오라클(ZIOUI1, SERVER_HOST=localhost) 최신 원문에서 직접 실행, user=minyonglee1 / mnu=DMF0074 |

SP 직접 실행 결과 (2026-10-15):

| Division | 행수 | 결과 커서 | GAP 기재값 |
|---|---:|---|---:|
| 81 | **203** | `0 / SUCCESS` | 203 ✅ |
| 82 | 128 | `0 / SUCCESS` | 127 (원장 변동 범위) |
| 40 | 0 | `0 / SUCCESS` | 414 ⚠ |

⚠ 40 이 0행인 이유는 **사내 데이터** 때문이다(SP 결함 아님). 40 의 MRF='Y'(`ATTRIBUTE7='Y'`) 최신 SP_W 버전은 `SP_W_20260921_V001` 인데,
사내 `DM_PLN_SALES_PLAN_C` 에는 이 버전 행이 0건이다(사내 최신 적재 = `SP_W_20260825_V002`). 버전 조건은 AS-IS 운영 원문
(`ISNULL(ATTRIBUTE7,'N')='Y'`)·업로드 검증과 같으므로 바꾸지 않는다. 414행은 클라우드에서 측정한 값으로 보인다.

## 2. FE 수정 가이드 (1파일)

파일: `nscm-fe/features/demand/src/pages/metal-link-price/MetalLinkPrice.tsx`

### 2-1. import 추가 (L1~L19 import 블록)

```ts
import { BUTTON_TYPE } from '@foundation/constants';
```

`apiClient` 는 L6 에 이미 import 돼 있다. `useSessionStore` 도 L18 에 있다.

### 2-2. `handleExcelFormDownload` 교체 (L205~L240)

변경 전 (요지): 그리드를 `[]` 로 비운 뒤 `GridAction.excelDownload` → 머리글만 저장됨.

변경 후:

```ts
  const handleExcelFormDownload = async () => {
    if (!searchParams.divisionId) {
      void setAlert({
        type: 'alert',
        content: t(MSG.REQUIRE_DIVISION, '_Please select Division.'),
      });
      return;
    }
    const grid = gridRef.current;
    if (!grid) return;

    // GAP 421 — 양식 데이터 = PKG_DMF0074.P_DMF0074_GET_METAL_LINK_TEMPLATE (API_M DMF0074_template_SEARCH).
    //   AS-IS DMF0074_MetalLinkPricePopup FindData → ExportFpSpread 1:1 — 조회한 업로드 대상 행을 채워서 내려받는다.
    //   sesUserId/mnuId = division-gate 키 (BE 세션 자동 + 보강 전송, 템플릿 모달과 동일 계약).
    let templateRows: MetalLinkPriceRow[] = [];
    try {
      const res = await apiClient.callProc(MENU_ID, SHEETS.TEMPLATE, BUTTON_TYPE.SEARCH, {
        divisionId: searchParams.divisionId,
        sesUserId: useSessionStore.getState().session.userId ?? '',
        mnuId: MENU_ID,
      });
      if (res.code !== '0') {
        void setAlert({ type: 'alert', content: res.message ?? 'Excel Form search failed.' });
        return;
      }
      templateRows = ((res.result as { o_rc1?: MetalLinkPriceRow[] })?.o_rc1 ?? []).map(row =>
        // SP 는 빈 값을 '' 로 내린다(E20260825-DASHRM). 과거 '-' placeholder 가 남아 있으면 빈칸으로 바꾼다.
        Object.fromEntries(
          Object.entries(row).map(([k, v]) => [k, v === TEMPLATE_BLANK_PLACEHOLDER ? '' : v])
        ) as MetalLinkPriceRow
      );
    } catch (error: unknown) {
      void setAlert({
        type: 'alert',
        content: error instanceof Error ? error.message : 'Excel Form search failed.',
      });
      return;
    }
    // AS-IS 팝업 0건 안내 (L229 계보) — MSG01015
    if (templateRows.length === 0) {
      void setAlert({
        type: 'alert',
        content: t(MSG.TEMPLATE_EMPTY, '_No template data to download.'),
      });
      return;
    }

    // 머리글(2단 병합)은 메인 그리드 그대로 쓰고, 그 순간만 데이터를 양식 행으로 바꿨다가 되돌린다.
    const originalItemsSource = grid.itemsSource;
    const sortSnapshot = captureGridSort(grid);
    const filterDefinition = captureGridFilter(gridFilterRef.current);
    grid.itemsSource = templateRows;
    void GridAction.excelDownload(
      grid,
      TEMPLATE_EXCEL_PREFIX,
      useUIStore.getState().setProgress,
      { border: true, fillColor: '#E7E6E6', bold: false }
    )
      .catch((error: unknown) => {
        void setAlert({
          type: 'alert',
          content: error instanceof Error ? error.message : 'Excel download failed.',
        });
      })
      .finally(() => {
        grid.itemsSource = originalItemsSource;
        restoreGridSort(grid, sortSnapshot);
        restoreGridFilter(grid, gridFilterRef.current, filterDefinition);
      });
  };
```

### 2-3. constants import 에 `TEMPLATE_BLANK_PLACEHOLDER` 추가 (L27~L36)

```ts
import {
  MAIN_EXCEL_PREFIX,
  MENU_ID,
  MSG,
  SHEETS,
  TEMPLATE_BLANK_PLACEHOLDER,
  TEMPLATE_EXCEL_PREFIX,
  ...
} from './metal-link-price.constants';
```

### 2-4. customButtons 액션 (L254)

`action: handleExcelFormDownload` → `action: () => void handleExcelFormDownload()` (async 반환 Promise 를 버튼 핸들러에서 무시 — no-misused-promises 회피).

### 2-5. 유지되는 것

- 머리글: 현재 2단 머리글 + 테두리/배경(#E7E6E6) 그대로 (GAP 조치 ② "머리글은 현재 2단 머리글 유지").
- 메인 화면 조회 결과·정렬·필터: export 후 원복 (기존 idiom 동일).
- 버튼 노출 권한 `hasButton('SEARCH')` 그대로.

## 3. 검증 방법

1. Division=81 선택 → Excel Form 클릭 → 파일 데이터 행 수 = **203** (아래 SQL 결과 행수와 일치).
2. Division=82 → 128 행 / Division=40 → 사내 데이터 기준 MSG01015 안내(0행).
3. 내려받은 파일의 Div/Team/End Customer/Project/Model/Sales Site/Currency/FCST Type 이 채워지고, 메탈 42열은 빈칸인지 확인.
4. 다운로드 후 메인 그리드 조회 결과·정렬·필터가 그대로인지 확인.

확인 SQL (사내오라클, SQL*Plus/SQLcl):

```sql
VAR rc1 REFCURSOR
VAR rc2 REFCURSOR
EXEC SCM_MGR.PKG_DMF0074.P_DMF0074_GET_METAL_LINK_TEMPLATE('81', 'minyonglee1', 'DMF0074', :rc1, :rc2);
PRINT rc2
PRINT rc1
```

## 4. 남은 확인 (참고)

- 이 파일을 그대로 재업로드할 때의 머리글 매핑(2단 헤더 ↔ `SCM_ADM_EXCEL_COLUMNS.HEADER_CONTENT`)은 기존 주석(L202~L204)대로 별도 검증 대상이다. 본 GAP 범위(양식에 데이터 행 채움)와는 별개.
- 클라우드 반영 시 FE 1파일만 이관. DB(API_M·PROC_M·PKG) 변경 없음 → 클라우드 SQL 패키지 불필요. 단 클라우드에 `DMF0074_template_SEARCH` API_M 행이 있는지는 클라우드에서 1회 확인할 것:
  `SELECT API_ID, API_URL, USE_YN FROM SCM_MGR.SCM_ADM_API_M WHERE API_ID = 'DMF0074_template_SEARCH';`
