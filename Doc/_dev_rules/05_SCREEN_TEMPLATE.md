# 05. 신규 화면 추가 표준 템플릿 (FE + BE + DB 한 세트)

> 신규 화면 1개 추가 = FE 8+개 파일 + BE 4+개 파일 + DB Procedure 등록 + **7개 영역 메타 등록 (자기완결형 인라인 DML)** + **As-Is Validation/Expression 100% 반영**
> 본 문서는 Copy-Paste 가능한 완전한 코드 템플릿을 제공합니다.
>
> ⭐ **메타 등록 절차 (4-파일 SQL 세트)**: [`08_SCREEN_REGISTRATION.md`](08_SCREEN_REGISTRATION.md)
> ⭐ **As-Is Validation/Expression 반영**: [`09_WIJMO_VALIDATION_EXPRESSION.md`](09_WIJMO_VALIDATION_EXPRESSION.md)
> 코드 작성 전후로 반드시 7개 영역 메타 등록 + As-Is 매핑을 함께 진행해야 합니다.

## 0.0 ⭐ As-Is 산출물 사전 확인 (코드 작성 전 필수)

As-Is GSCM 화면을 To-Be 로 옮기는 경우 **반드시 먼저 읽고 카운트 기록**:

```
[ ] Doc/_analysis/domain_{DM|Common|SCM}/screens/{화면ID}/validation.md   → Validation 총 ___ 건
[ ] Doc/_analysis/domain_{DM|Common|SCM}/screens/{화면ID}/expressions.md  → Expression 총 ___ 건
[ ] {27|28|29}_*_Screens/*_{화면ID}.xlsx 11_Validation + 12_Expression 시트
```

→ 두 카운트는 To-Be 코드에서 **그대로 일치**해야 한다 (누락 0건). `__asis-mapping__.md` 매트릭스에 1:1 매핑 기록.

## 예제 화면

- **MENU_ID**: `DMF0099`
- **화면명**: Sales Monitor (예시)
- **도메인**: demand
- **kebab-case 폴더명**: `dmf0099-sales-monitor`
- **PascalCase 컴포넌트명**: `Dmf0099SalesMonitor`
- **BE 패키지**: `com.lgcns.nscm.demand.dmf0099`
- **As-Is 카운트** (예시): Validation 141건 / Expression 120건

## 0. 사전 준비

### 0.1 MENU_ID 등록 (DB)

```sql
INSERT INTO SCM_ADM_MENU_M (MNU_ID, UPPR_MNU_ID, MNU_URL, MNU_MSG_ID, MNU_DESC, SORT_ORD, USE_YN, CRT_USR_ID, CRT_DT)
VALUES ('DMF0099', 'DMF', '/demand/dmf0099-sales-monitor', 'MNU_DMF0099', 'Sales Monitor', 99, 'Y', 'admin', SYSDATE);
```

### 0.2 PKG 생성 (DB)

```sql
CREATE OR REPLACE PACKAGE SCM_MGR.PKG_DMF0099 AS
    PROCEDURE P_DMF0099_GET_MAIN_DATA (
        p_user_id      IN  VARCHAR2,
        p_division_id  IN  VARCHAR2,
        p_yyyymm       IN  VARCHAR2,
        o_rc1          OUT SYS_REFCURSOR
    );
    PROCEDURE P_DMF0099_SAVE_MAIN_DATA (
        p_user_id      IN VARCHAR2,
        p_data_json    IN CLOB
    );
END PKG_DMF0099;
/
```

## 1. Backend 파일 세트

### 1.1 `Dmf0099Controller.java`

```java
package com.lgcns.nscm.demand.dmf0099;

import java.util.List;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

import com.lgcns.nscm.admin.user.UserSession;
import com.lgcns.nscm.demand.dmf0099.dto.Dmf0099Request;
import com.lgcns.nscm.demand.dmf0099.dto.Dmf0099Response;
import com.lgcns.nscm.framework.annotation.LoginUser;
import com.lgcns.nscm.framework.base.BaseController;
import com.lgcns.nscm.framework.model.BaseResponse;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

/**
 * DMF0099 Sales Monitor Controller
 *
 * @Project  : nscm
 * @Package  : com.lgcns.nscm.demand.dmf0099
 * @FileName : Dmf0099Controller.java
 * @author   : {nickname}
 * @date     : 2026. 5. 13.
 * @description : DMF0099 화면의 API endpoint 제공
 */
@Slf4j
@Tag(name = "DMF0099. Sales Monitor")
@RestController
@RequiredArgsConstructor
public class Dmf0099Controller extends BaseController {

    private final Dmf0099Service dmf0099Service;

    @Operation(summary = "메인 데이터 조회", description = "조건에 맞는 Sales Monitor 데이터를 조회합니다.")
    @PostMapping(value = "/demand/dmf0099/main", produces = "application/json; charset=UTF-8")
    public ResponseEntity<BaseResponse<List<Dmf0099Response>>> retrieveMain(
            @LoginUser UserSession userSession,
            @RequestBody @Valid Dmf0099Request dto) throws Exception {
        return successResponseEntity(dmf0099Service.retrieveMain(userSession.getUserId(), dto));
    }

    @Operation(summary = "메인 데이터 저장", description = "변경된 행을 저장합니다.")
    @PostMapping(value = "/demand/dmf0099/main/save", produces = "application/json; charset=UTF-8")
    public ResponseEntity<BaseResponse<Void>> saveMain(
            @LoginUser UserSession userSession,
            @RequestBody List<Dmf0099Request> rows) throws Exception {
        dmf0099Service.saveMain(userSession.getUserId(), rows);
        return successResponseEntity();
    }
}
```

### 1.2 `Dmf0099Service.java` (Interface)

```java
package com.lgcns.nscm.demand.dmf0099;

import java.util.List;

import com.lgcns.nscm.demand.dmf0099.dto.Dmf0099Request;
import com.lgcns.nscm.demand.dmf0099.dto.Dmf0099Response;

public interface Dmf0099Service {
    List<Dmf0099Response> retrieveMain(String userId, Dmf0099Request dto) throws Exception;
    void saveMain(String userId, List<Dmf0099Request> rows) throws Exception;
}
```

### 1.3 `Dmf0099ServiceImpl.java`

```java
package com.lgcns.nscm.demand.dmf0099;

import static com.lgcns.nscm.framework.base.BaseConstants.DEFAULT_DATA_RESULT;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.lgcns.nscm.demand.dmf0099.dto.Dmf0099Request;
import com.lgcns.nscm.demand.dmf0099.dto.Dmf0099Response;
import com.lgcns.nscm.framework.base.BaseService;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

/**
 * DMF0099 Sales Monitor Service Impl
 *
 * @Project  : nscm
 * @Package  : com.lgcns.nscm.demand.dmf0099
 * @FileName : Dmf0099ServiceImpl.java
 * @author   : {nickname}
 * @date     : 2026. 5. 13.
 * @description : DMF0099 비즈니스 로직 — PKG_DMF0099 호출
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class Dmf0099ServiceImpl extends BaseService implements Dmf0099Service {

    private final String nameSpace = "demand.dmf0099.";
    private final ObjectMapper objectMapper;

    @Override
    public List<Dmf0099Response> retrieveMain(String userId, Dmf0099Request dto) throws Exception {

        Map<String, Object> params = new HashMap<>();
        params.put("userId", userId);
        params.put("divisionId", dto.getDivisionId());
        params.put("yyyymm", dto.getYyyymm());

        Map<String, Object> result = selectList(nameSpace + "retrieveMain", params);
        List<Map<String, Object>> data = (List<Map<String, Object>>) result.get(DEFAULT_DATA_RESULT);

        return Dmf0099Response.listOf(data);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void saveMain(String userId, List<Dmf0099Request> rows) throws Exception {

        String json = objectMapper.writeValueAsString(rows);

        Map<String, Object> params = new HashMap<>();
        params.put("userId", userId);
        params.put("dataJson", json);

        selectList(nameSpace + "saveMain", params);
    }
}
```

### 1.4 `dto/Dmf0099Request.java`

```java
package com.lgcns.nscm.demand.dmf0099.dto;

import jakarta.validation.constraints.NotBlank;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
public class Dmf0099Request {
    @NotBlank(message = "Division 은 필수입니다.")
    private String divisionId;

    @NotBlank(message = "YYYYMM 은 필수입니다.")
    private String yyyymm;

    // 저장 시 사용
    private String itemId;
    private Long qty;
    private String crudType;  // I, U, D
}
```

### 1.5 `dto/Dmf0099Response.java`

```java
package com.lgcns.nscm.demand.dmf0099.dto;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;

@Getter
@Builder
@AllArgsConstructor
public class Dmf0099Response {
    private String divisionId;
    private String itemId;
    private String yyyymm;
    private Long qty;

    public static Dmf0099Response of(Map<String, Object> data) {
        return Dmf0099Response.builder()
            .divisionId((String) data.get("DIVISION_ID"))
            .itemId((String) data.get("ITEM_ID"))
            .yyyymm((String) data.get("YYYYMM"))
            .qty(data.get("QTY") == null ? null : ((Number) data.get("QTY")).longValue())
            .build();
    }

    public static List<Dmf0099Response> listOf(List<Map<String, Object>> datas) {
        List<Dmf0099Response> result = new ArrayList<>();
        for (Map<String, Object> d : datas) result.add(of(d));
        return result;
    }
}
```

### 1.6 `src/main/resources/sql/demand/Dmf0099.xml`

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE mapper PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN"  "../../mybatis/mybatis-3-mapper.dtd">
<mapper namespace="com.lgcns.nscm.demand.dmf0099">

    <resultMap id="dmf0099ResultMap" type="java.util.HashMap" />

    <select id="retrieveMain" statementType="CALLABLE">
        { CALL SCM_MGR.PKG_DMF0099.P_DMF0099_GET_MAIN_DATA(
            #{userId},
            #{divisionId},
            #{yyyymm},
            #{DATARESULT, mode=OUT, jdbcType=CURSOR, javaType=java.sql.ResultSet, resultMap=dmf0099ResultMap}
        ) }
    </select>

    <select id="saveMain" statementType="CALLABLE">
        { CALL SCM_MGR.PKG_DMF0099.P_DMF0099_SAVE_MAIN_DATA(
            #{userId},
            #{dataJson, mode=IN, jdbcType=CLOB}
        ) }
    </select>

</mapper>
```

## 2. Frontend 파일 세트

위치: `features/{domain}/src/pages/{kebab-page}/`

### ⭐ 2.0 표준 폴더 구조 (2026-05-22 갱신 — DMF0020 작업 반영)

화면 규모에 따라 **두 가지 패턴** 으로 분기:

#### 2.0.1 기본 패턴 (Validation/Expression < 20건, POPUP 0개)

```
{kebab-page}/
├── {PageName}.tsx                              ← 메인 페이지
├── {page-name}.constants.ts                    ← MENU_ID/SHEETS/RESPONSE_SET
├── use{PageName}Store.ts                       ← Zustand store
├── index.ts                                    ← export *
└── components/
    ├── {PageName}Form.tsx                      ← 검색 영역
    ├── {PageName}Form.module.scss
    └── {PageName}Grid.tsx                      ← Wijmo DataGrid 래퍼
```

#### 2.0.2 ⭐ 확장 패턴 (Validation/Expression ≥ 20건 또는 POPUP ≥ 1개) — DMF0020 사례

```
{kebab-page}/
├── {PageName}.tsx
├── {page-name}.constants.ts                    ← + DIVISION_CODE, GROUP_KEY_COLUMNS 등 도메인 상수
├── use{PageName}Store.ts                       ← + dynamicColumns, modalState 등
├── __asis-mapping__.md                         ← ⭐ As-Is ↔ To-Be 매트릭스 (필수)
├── index.ts
├── hooks/                                      ← ⭐ 신규 (대규모 Validation/Expression 분리)
│   ├── use{PageName}Validation.ts              ← Validation N건 + 사업부 분기
│   └── use{PageName}Expression.ts              ← Expression N건 + 계산식
└── components/
    ├── {PageName}Form.tsx
    ├── {PageName}Form.module.scss
    ├── {PageName}Grid.tsx
    └── modals/                                 ← ⭐ 신규 (As-Is POPUP → Modal 통합)
        ├── {ModalName1}Modal.tsx               ← 전용 POPUP 1
        ├── {ModalName1}Modal.module.scss
        ├── {ModalName2}Modal.tsx
        ├── {ModalName2}Modal.module.scss
        └── ...
```

**분기 기준**:

| 항목 | 기본 | 확장 |
|---|:-:|:-:|
| Validation 건수 | < 20 | ≥ 20 (분기 보존 시 `hooks/Validation` 분리 의무) |
| Expression 건수 | < 5 | ≥ 5 (`hooks/Expression` 분리 의무) |
| 사업부 분기 (40/81/82) | 0~5 | ≥ 6 (분기 명시적 메서드로 분리) |
| As-Is POPUP | 0 | ≥ 1 (`components/modals/` 의무) |
| `__asis-mapping__.md` | 권장 | **필수** |

> **상세 룰**:
> - `hooks/` 분리 룰 → `09_WIJMO_VALIDATION_EXPRESSION.md` §3
> - `components/modals/` 룰 → `12_GRID_COMMON.md` §11 (Modal 통합 패턴)
> - 매트릭스 양식 → `09_WIJMO_VALIDATION_EXPRESSION.md` §6

> **참조 표준 화면**:
> - 기본 패턴: `features/admin/src/pages/user-management/` (Validation 4건, POPUP 0)
> - 확장 패턴: `features/master/src/pages/sales-future-price/` (Validation 71건, POPUP 4 modal — DMF0020)

### 2.1 `dmf0099-sales-monitor.constants.ts`

```ts
export const MENU_ID = 'DMF0099' as const;
export type MENU_ID = typeof MENU_ID;

export enum SHEETS {
  MAIN = 'main',
}

export enum RESPONSE_SET {
  MAIN = 'o_rc',
}
```

### 2.2 `useDmf0099SalesMonitorStore.ts`

```ts
import { apiClient } from '@foundation/apis';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStoreWithTab } from '@shared/stores';

import { MENU_ID, SHEETS } from './dmf0099-sales-monitor.constants';

interface SearchParamProps {
  divisionId: string;
  yyyymm: string;
}

interface State {
  initialized: boolean;
  filters?: ProcRequest<MENU_ID, SHEETS.MAIN>;
  searchParams: SearchParamProps;
  staticColumns: RawFlexGridColumnConfig[];
  isOpenSearchArea: boolean;
}

interface Action {
  reset: () => void;
  setSearchParams: (p: Partial<SearchParamProps>) => void;
  setFilters: () => void;
  fetchStaticColumns: () => Promise<void>;
  setOpenSearchArea: (open?: boolean) => void;
}

const initParams: SearchParamProps = {
  divisionId: 'ALL',
  yyyymm: '',
};

const initState: State = {
  initialized: false,
  filters: undefined,
  searchParams: initParams,
  staticColumns: [],
  isOpenSearchArea: true,
} as const;

export const useDmf0099SalesMonitorStore = createPersistedStoreWithTab<State & Action>(
  (set, get) => ({
    ...initState,
    reset: () => set(initState),
    setSearchParams: searchParams => {
      set(state => {
        state.searchParams = { ...get().searchParams, ...searchParams };
      });
    },
    setFilters: () => {
      set(state => {
        state.filters = { ...state.searchParams };
      });
    },
    fetchStaticColumns: async () => {
      const result = await apiClient.post<RawFlexGridColumnConfig[]>(
        `/admin/menu/${MENU_ID}/column`,
        { sheetNm: SHEETS.MAIN }
      );
      set(state => {
        state.staticColumns = result.data.result;
      });
      if (get().initialized) return;
      set(state => {
        state.initialized = true;
      });
    },
    setOpenSearchArea: open => {
      set(state => {
        state.isOpenSearchArea = open ?? !state.isOpenSearchArea;
      });
    },
  }),
  'dmf0099-sales-monitor'
);
```

### 2.3 `Dmf0099SalesMonitor.tsx`

```tsx
import { type FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useRef } from 'react';

import type { HotkeyConfig, PageProps } from '@foundation/models';
import { GridAction } from '@foundation/utils';
import { MainTitle, SubTitle } from '@shared/components';
import { useProcMutation, useSaveWithValidation, useTabProcQuery } from '@shared/hooks';

import { Dmf0099SalesMonitorForm } from './components/Dmf0099SalesMonitorForm';
import { Dmf0099SalesMonitorGrid } from './components/Dmf0099SalesMonitorGrid';
import type { RESPONSE_SET } from './dmf0099-sales-monitor.constants';
import { MENU_ID, SHEETS } from './dmf0099-sales-monitor.constants';
import { useDmf0099SalesMonitorStore } from './useDmf0099SalesMonitorStore';

export const Dmf0099SalesMonitor = ({ tabId, title }: PageProps<MENU_ID>) => {
  const gridRef =
    useRef<FlexGrid<ResponseData<MENU_ID, SHEETS.MAIN, RESPONSE_SET.MAIN>>>();
  const gridFilterRef = useRef<FlexGridFilter>();

  const filters = useDmf0099SalesMonitorStore(s => s.filters);
  const setFilters = useDmf0099SalesMonitorStore(s => s.setFilters);
  const staticColumns = useDmf0099SalesMonitorStore(s => s.staticColumns);
  const fetchStaticColumns = useDmf0099SalesMonitorStore(s => s.fetchStaticColumns);
  const isOpenSearchArea = useDmf0099SalesMonitorStore(s => s.isOpenSearchArea);
  const setOpenSearchArea = useDmf0099SalesMonitorStore(s => s.setOpenSearchArea);
  const searchParams = useDmf0099SalesMonitorStore(s => s.searchParams);

  const { saveWithValidation } = useSaveWithValidation();

  const { data } = useTabProcQuery<MENU_ID>({
    menuId: MENU_ID,
    sheetName: SHEETS.MAIN,
    tabId,
    filters,
    enabled: filters !== undefined,
  });

  const { mutate } = useProcMutation<MENU_ID>({
    menuId: MENU_ID,
    sheetName: SHEETS.MAIN,
    tabId,
  });

  useEffect(() => {
    void fetchStaticColumns();
  }, [tabId, fetchStaticColumns]);

  const onSave = () => {
    const saveData = data?.o_rc?.filter?.(item => item.CRUD_TYPE) ?? [];
    saveWithValidation(saveData, staticColumns, mutate);
  };

  const onInsert = () => {
    if (!gridRef.current) return;
    GridAction.addRow(gridRef.current, {
      // 기본값 설정
    });
  };

  const hotkeyConfig: HotkeyConfig = {
    save: onSave,
    insert: onInsert,
    search: setFilters,
    manual: false,
    upload: false,
  };

  return (
    <>
      <MainTitle
        title={title}
        menuId={MENU_ID}
        openSearchArea={isOpenSearchArea}
        toggleOpenSearchArea={setOpenSearchArea}
      />
      <Dmf0099SalesMonitorForm />
      <SubTitle
        menuId={MENU_ID}
        grid={gridRef}
        gridFilter={gridFilterRef}
        dataCount={data?.o_rc.length ?? 0}
        excelFileName='SalesMonitor'
        hotkeyConfig={hotkeyConfig}
        searchParam={searchParams}
      />
      <Dmf0099SalesMonitorGrid
        gridRef={gridRef}
        gridFilterRef={gridFilterRef}
        data={data?.o_rc ?? []}
      />
    </>
  );
};
```

### 2.4 `components/Dmf0099SalesMonitorForm.tsx`

```tsx
import { useTranslation } from 'react-i18next';

import { CustomDropdown, SearchArea } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';
import { FormItem, InputField } from '@shared/lges';
import { Grid } from '@shared/mui';

import { useDmf0099SalesMonitorStore } from '../useDmf0099SalesMonitorStore';
import styles from './Dmf0099SalesMonitorForm.module.scss';

export const Dmf0099SalesMonitorForm = () => {
  const { t } = useTranslation();

  const searchParams = useDmf0099SalesMonitorStore(s => s.searchParams);
  const setSearchParams = useDmf0099SalesMonitorStore(s => s.setSearchParams);
  const setFilters = useDmf0099SalesMonitorStore(s => s.setFilters);
  const isOpenSearchArea = useDmf0099SalesMonitorStore(s => s.isOpenSearchArea);

  const [division] = useTabComboQueries({ filters: ['Division'] });

  return (
    <SearchArea
      searchButtonLabel={t('LBL00112', '_Search')}
      onSearch={setFilters}
      isHidden={!isOpenSearchArea}
      conditions={
        <>
          <Grid size={3}>
            <FormItem
              label={t('LBL00100', '_Division')}
              labelAlign='right'
              labelSize='long'
              render={() => (
                <CustomDropdown
                  fullWidth
                  options={division.data ?? []}
                  value={searchParams.divisionId}
                  onChange={value => setSearchParams({ divisionId: value })}
                />
              )}
            />
          </Grid>
          <Grid size={3}>
            <FormItem
              label={t('LBL00200', '_YYYYMM')}
              labelAlign='right'
              labelSize='long'
              render={() => (
                <InputField
                  fullWidth
                  value={searchParams.yyyymm}
                  onChange={e => setSearchParams({ yyyymm: e.target.value })}
                />
              )}
            />
          </Grid>
        </>
      }
    />
  );
};
```

### 2.5 `components/Dmf0099SalesMonitorForm.module.scss`

```scss
.formContainer {
  display: flex;
  gap: 16px;
  padding: 8px;
}
```

### 2.6 `components/Dmf0099SalesMonitorGrid.tsx`

```tsx
import { type FlexGrid } from '@mescius/wijmo.grid';
import { type FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useRef, type MutableRefObject } from 'react';

import type { EditTracker } from '@foundation/utils';
import { DataGrid } from '@shared/components';

import type { MENU_ID, RESPONSE_SET, SHEETS } from '../dmf0099-sales-monitor.constants';
import { useDmf0099SalesMonitorStore } from '../useDmf0099SalesMonitorStore';

interface Props {
  gridRef: MutableRefObject<FlexGrid<ResponseData<MENU_ID, SHEETS.MAIN>> | undefined>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  data: ResponseData<MENU_ID, SHEETS.MAIN>[];
}

export const Dmf0099SalesMonitorGrid = ({ gridRef, gridFilterRef, data }: Props) => {
  const editTrackerRef =
    useRef<EditTracker<ResponseData<MENU_ID, SHEETS.MAIN, RESPONSE_SET.MAIN>>>();
  const staticColumns = useDmf0099SalesMonitorStore(s => s.staticColumns);

  return (
    <DataGrid
      gridRef={gridRef}
      gridFilterRef={gridFilterRef}
      editTrackerRef={editTrackerRef}
      data={data}
      columns={staticColumns}
    />
  );
};
```

### 2.7 `index.ts`

```ts
export { Dmf0099SalesMonitor } from './Dmf0099SalesMonitor';
```

### 2.8 ⭐ `hooks/useDmf0099SalesMonitorValidation.ts` (As-Is Validation 반영 — 필수)

```ts
/**
 * DMF0099 Validation Hook
 *
 * @asis Doc/_analysis/domain_DM/screens/DMF0099_SalesMonitor/validation.md
 * @count As-Is 141건 → To-Be 141건 (100%)
 */
import { z } from 'zod';
import { useUserStore } from '@shared/stores';
import type { Dmf0099Row } from '../types/dmf0099.types';

// AS-IS: DMF0099_SalesMonitor.cs:1234 — MessageHelper.GMessageBox("MSG0001")
const baseSchema = z.object({
  DIVISION_ID: z.string().min(1, 'msg.MSG0001'),
  YYYYMM: z.string().regex(/^\d{6}$/, 'msg.MSG0023'),
  // ... validation.md 행마다 1:1 매핑
});

export function useDmf0099SalesMonitorValidation(division: string) {
  const isJvPlanner = useUserStore((s) => s.isJvPlanner);

  return (row: Dmf0099Row): string[] => {
    const errors: string[] = [];

    const parsed = baseSchema.safeParse(row);
    if (!parsed.success) errors.push(...parsed.error.errors.map((e) => e.message));

    // AS-IS: cs:440 — 사업부 분기 (보존 필수)
    switch (division) {
      case '40': /* AS-IS: cs:441-460 */ break;
      case '81': /* AS-IS: cs:461-475 */ break;
      case '82': /* AS-IS: cs:476-490 */ break;
    }

    // AS-IS: cs:512 — 권한 분기
    if (isJvPlanner && !row.JV_PLAN_REASON) errors.push('msg.MSG0456');

    return errors;
  };
}
```

### 2.9 ⭐ `hooks/useDmf0099SalesMonitorExpression.ts` (As-Is Expression 반영 — 필수)

```ts
/**
 * DMF0099 Expression Hook
 *
 * @asis Doc/_analysis/domain_DM/screens/DMF0099_SalesMonitor/expressions.md
 * @count As-Is 120건 → To-Be 120건 (100%)
 */
import { useCallback } from 'react';
import type * as wjGrid from '@mescius/wijmo.grid';
import type { Dmf0099Row } from '../types/dmf0099.types';

export function useDmf0099SalesMonitorExpression(division: string) {
  // AS-IS: cs:994 — siMain.LockRange(...) — 조건부잠금
  const onCellEditEnding = useCallback(
    (s: wjGrid.FlexGrid, e: wjGrid.CellEditEndingEventArgs) => {
      const row = s.rows[e.row].dataItem as Dmf0099Row;
      const col = s.columns[e.col].binding!;
      // AS-IS: cs:994 — INSERT 행만 편집 가능
      if (row.CRUD_TYPE !== 'I' && col === 'DIVISION_ID') {
        e.cancel = true;
      }
      // AS-IS: cs:1001 — Week 컬럼만 편집 가능 (BucketType==Week)
      // ...
    },
    [division],
  );

  // AS-IS: cs:1234 — _CellChange — SetValue(r, c, qty * price)
  const onCellEditEnded = useCallback(
    (s: wjGrid.FlexGrid, e: wjGrid.CellEditEndedEventArgs) => {
      const row = s.rows[e.row].dataItem as Dmf0099Row;
      const col = s.columns[e.col].binding;
      if (col === 'QTY' || col === 'PRICE') {
        row.AMOUNT = (row.QTY ?? 0) * (row.PRICE ?? 0);
        s.invalidate();
      }
    },
    [],
  );

  return { onCellEditEnding, onCellEditEnded };
}
```

### 2.10 ⭐ `__asis-mapping__.md` (매핑 매트릭스 — 필수)

```markdown
# DMF0099 As-Is → To-Be 매핑

**As-Is Source**: `06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0099_SalesMonitor/DMF0099_SalesMonitor.cs`
**Validation 카운트**: As-Is 141 ↔ To-Be 141 ✅
**Expression 카운트**: As-Is 120 ↔ To-Be 120 ✅

## Validation 매핑 (141건)

| # | As-Is Line | As-Is Code | To-Be 위치 | 상태 |
|---:|---:|---|---|---|
| 1 | 335 | `if (sDivision != null...)` | hooks/useDmf0099Validation.ts:32 | ✅ |
| 2 | 337 | `if (sDivision == "82")` | hooks/useDmf0099Validation.ts:35 case '82' | ✅ |
| ... | ... | ... | ... | ... |

## Expression 매핑 (120건)

| # | As-Is Line | As-Is Pattern | To-Be 위치 | 상태 |
|---:|---:|---|---|---|
| 1 | 994 | LockRange | hooks/useDmf0099Expression.ts:onCellEditEnding | ✅ |
| 2 | 1001 | LockRange Week | hooks/useDmf0099Expression.ts:onCellEditEnding | ✅ |
| ... | ... | ... | ... | ... |
```

## 3. 라우팅 등록

`apps/web/src/pages/` 또는 메뉴 마스터에서 `/demand/dmf0099-sales-monitor` 경로를 `Dmf0099SalesMonitor` 컴포넌트와 연결.

`apps/web/src/core/routes.tsx` 또는 동등 파일:

```tsx
import { Dmf0099SalesMonitor } from '@demand/dmf0099-sales-monitor';

// 라우터에 등록
{
  path: '/demand/dmf0099-sales-monitor',
  element: <Dmf0099SalesMonitor />,
}
```

## 4. i18n 메시지 코드

`public/locales/{en|ko}/`:

```json
{
  "LBL00200": "YYYYMM",
  "MSG_DMF0099_SAVED": "Sales Monitor 데이터가 저장되었습니다."
}
```

## 5. 테스트

### 5.1 BE

`src/test/java/com/lgcns/nscm/demand/dmf0099/Dmf0099ServiceImplTest.java`

```java
@SpringBootTest
@ActiveProfiles("local")
class Dmf0099ServiceImplTest {
    @Autowired private Dmf0099Service service;

    @Test
    void retrieveMain_returnsList() throws Exception {
        Dmf0099Request req = new Dmf0099Request();
        req.setDivisionId("81");
        req.setYyyymm("202605");
        List<Dmf0099Response> result = service.retrieveMain("testUser", req);
        assertThat(result).isNotNull();
    }
}
```

### 5.2 FE

`features/demand/src/pages/dmf0099-sales-monitor/__tests__/Dmf0099SalesMonitor.test.tsx`

```tsx
import { render, screen } from '@testing-library/react';
import { describe, it, expect } from 'vitest';
import { Dmf0099SalesMonitor } from '../Dmf0099SalesMonitor';

describe('Dmf0099SalesMonitor', () => {
  it('renders title', () => {
    render(<Dmf0099SalesMonitor tabId='tab1' title='Sales Monitor' />);
    expect(screen.getByText('Sales Monitor')).toBeInTheDocument();
  });
});
```

## 6. 체크리스트 (PR 전)

```
[ ] DB Procedure(PKG_DMF0099) 생성 및 컴파일 검증
[ ] ⭐ 7개 영역 메타 등록 — 자기완결형 인라인 DML 4-파일 세트 (2026-05-19, PKG 폐기)
    → 08_SCREEN_REGISTRATION.md §3 (Step 1~8) + §7.1 (DBeaver 4-파일 룰) 참조
    - BLOCK 1: SCM_ADM_MSG_M (i18n × 3 lang)
    - BLOCK 2: SCM_ADM_MNU_M (메뉴 마스터)
    - BLOCK 3: SCM_ADM_PROC_M (SP IN/OUT ★ 누락 시 빈 결과)
    - BLOCK 4: SCM_ADM_API_M (API 메타)
    - BLOCK 5: SCM_ADM_MNU_BTN_MPG_M (라우팅)
    - BLOCK 6: SCM_MST_SHEET_COLUMNS (Grid 컬럼)
    - BLOCK 7: SCM_ADM_USER_GR_MNU_MPG_M + ..._BTN_MPG_M (메뉴+버튼 권한 2 테이블)
[ ] ⭐ FE procedures.d.ts 갱신 (pnpm gen:procedures 또는 수동 추가)
[ ] BE 5개 파일 생성 (Controller / Service / ServiceImpl / 2 DTO)
    ※ 동적 호출 아키텍처를 사용하면 BE Controller는 GeneralController로 처리되어 생략 가능
[ ] BE MyBatis XML 생성 (sql/demand/Dmf0099.xml) — 비표준 SP 호출 시
[ ] FE 7개 파일 생성 (Page / constants / Store / index + 3 components)
[ ] 라우팅 등록 (apps/web)
[ ] i18n 메시지 코드 등록 (SCM_ADM_MESSAGE_M INSERT)
[ ] 단위 테스트 작성 (BE + FE)
[ ] pnpm lint:fix / ./gradlew spotlessApply 통과
[ ] pnpm type-check / ./gradlew build 통과
[ ] 권한 검증 (메뉴 권한 + Procedure 권한 SCMD_APP에 GRANT EXECUTE)
[ ] 기존 화면(예: user-management)과 코드 스타일 일관성 확인
```

## 7. 동작 흐름 (메타데이터 기반 동적 호출)

NSCM은 **메타 Table을 통한 동적 SP 호출** 아키텍처입니다. 화면 코드는 어떤 SP를 호출하는지 알 필요가 없습니다.

```
FE: useTabProcQuery({menuId, sheetName})
    ↓ POST /{menuId}/{sheetName}/{action}/call-proc
BE: GeneralController → PR_GET_PROC_INFO_LIST(mnuId, shtNm, btnCd)
    ↓ (SCM_ADM_API_M에서 PKG_NM, PROC_NM 조회)
BE: 동적 CALL PKG_DMF0099.P_DMF0099_GET_MAIN_DATA(...)
    ↓ SYS_REFCURSOR 반환
FE: data.o_rc → Wijmo Grid (컬럼 정의는 별도 호출 /admin/menu/{id}/column)
```

→ 따라서 신규 화면 추가 시:
1. **PKG/SP 작성** (Oracle 컴파일 OK)
2. **7개 영역 메타 등록** (자기완결형 인라인 DML, 4-파일 SQL 세트)
3. **FE 화면 파일** 작성
4. **라우팅 등록**
5. 끝.

별도 BE Controller/Service/MyBatis XML은 **표준 동적 호출 외 특수 로직이 필요한 경우에만** 작성합니다.

---

> 본 템플릿은 신규 화면 1개를 추가하는 데 필요한 최소 파일 세트입니다. 실제로는 추가 시트, 팝업, Excel 업로드 등 화면별 특화 기능이 들어갑니다.
