# CLAUDE.md — AI 바이브코딩 컨텍스트 (분기 라우터)

> ⭐ **이 문서를 작업 시작 시 반드시 첫 번째로 읽으세요.**
> NSCM 프로젝트에서 코드를 작성/수정할 때 따라야 할 핵심 룰입니다.
> 룰을 어기면 "한 사람이 개발한 것처럼"이 깨집니다.
>
> ⚠️ **최우선 룰** (2026-05-22 신규): [`hooks/anti-simplification.md`](hooks/anti-simplification.md) — 작업 단순화 절대 금지. 본 01_CLAUDE.md 의 모든 룰을 압도. 사용자가 "모두/전체/정밀/상세" 요청 시 다중 패턴 + Cross-check 의무. 위반 = 신뢰성 손상 → 도구 사용 중단.
>
> 📍 **분기 라우터 정책** (2026-06-01): 본 문서는 (a) 작업 트리거별 진입 룰을 자동 분기하고 (b) 모든 작업에 공통 적용되는 hard rule 만 정의합니다. 세부 룰 본문은 [`00_INDEX.md §B 트리거 매트릭스`](00_INDEX.md#§b-트리거-매트릭스-) 가 작업 키워드에 따라 자동 분기.

## 0. 작업 트리거 매트릭스 (먼저 lookup)

사용자 메시지의 작업 키워드 → 자동 진입 룰. 상세 매트릭스는 [`00_INDEX.md §B`](00_INDEX.md).

| 작업 트리거 | 진입 룰 | 보조 hook |
|---|---|---|
| 신규 화면 생성 | **25** → 17/05/08 | new-screen-pre-build, asis-coverage-check, popup-asis-analysis, runtime-error-prevention |
| As-Is 4축 매핑 | **24** → 20/09 | asis-coverage-check, popup-asis-analysis |
| Wijmo Grid / PIVOT | **12** → 27 | pivot-frozen-columns, runtime-error-prevention |
| FE Import / 모듈 | **23** → 26 | fe-import-check, module-duplication-check |
| DB 오류 / SP 진단 | **21** → 10/16/24 | db-error-asis-cross-check |
| Figma 연동 | **31** → 23 | figma-mapping-check |
| 메뉴 미표시 | **15** → 11/08 | menu-not-displayed-debug |
| POPUP 작업 | **25 §3.3.1** → 24 §3.5/14/23 | popup-asis-analysis |
| 화면 분석서 | **20** → 19/09 | screen-analysis-pre/post-build, pre-submit |
| 백업/원복 | **30** | (없음) |
| CSV/Docker | **29** | (없음) |
| 변환 SP 결함 | **21 §10** → 24 §6.5 | db-error-asis-cross-check |

> 감지 미스 시 fallback: 신규 화면(T1) + As-Is 매핑(T2) + DB 오류(T5) 보수적 union.

## 1. 프로젝트 정체성

- **이름**: NSCM (LG Energy Solution Next SCM)
- **AS-IS**: GSCM C#.NET WinForms (358 csproj, 4,162 cs, 2,771 SPs)
- **TO-BE**: React 19 + Spring Boot 3.5 + Oracle 19c
- **AS-IS → TO-BE 변환 도메인**: DM(Demand) / SCM(Master) / FP(Factory) / SCP(Supply) / SSP(Shipping) / Common(Admin)
- **위치**:
  - FE: `C:\Projects\NSCM\nscm-fe` (Turborepo monorepo)
  - BE: `C:\Projects\NSCM\nscm-be` (Gradle single project)

## 2. 작업 전 필수 확인 사항 (체크리스트)

```
[ ] 작업 대상이 FE인지 BE인지 명확한가?
[ ] FE라면 어느 Feature 패키지에 속하는가? (features/admin|demand|master|factory|supply|shipping)
[ ] BE라면 어느 패키지에 속하는가? (com.lgcns.nscm.{domain}.{feature})
[ ] 신규 화면이라면 MENU_ID가 정의되어 있는가? (DB SCM_ADM_MENU_M 테이블)
[ ] 기존 화면 패턴(예: features/admin/src/pages/user-management) 참조했는가?
[ ] DB Procedure는 PKG_{UI_ID}.P_* 형태로 패키지화되어 있는가?
[ ] ⭐ As-Is Validation(11_Validation) + Expression(12_Expression) 읽었는가?
      → Doc/_analysis/domain_{DM|Common|SCM}/screens/{화면ID}/validation.md
      → Doc/_analysis/domain_{DM|Common|SCM}/screens/{화면ID}/expressions.md
      → {27|28|29}_*_Screens/*_{화면ID}.xlsx 11/12 시트
```

⭐ **As-Is 동작 보존 의무**: 신규 화면 작성 시 위 두 산출물의 **모든 행**이 To-Be Wijmo FlexGrid/FlexSheet에 100% 반영되어야 한다. 카운트 누락 1건도 PR reject 사유. 상세: [`09_WIJMO_VALIDATION_EXPRESSION.md`](09_WIJMO_VALIDATION_EXPRESSION.md)

## 3. 작성 절대 금지 (Hard Rules)

### Frontend ❌

| 금지 | 사유 | 올바른 패턴 |
|---|---|---|
| `import { ... } from '../../../packages/shared'` | 상대경로 깊이 | `@shared/components` / `@foundation/utils` |
| Feature에서 다른 Feature import | 의존성 그래프 깨짐 | apps/web에서 조합 |
| Foundation → Shared 또는 Application 호출 | 역방향 의존 | 정방향만 |
| `fetch()` / `axios.get()` 직접 호출 | 인터셉터/세션/에러처리 누락 | `apiClient.get/post` 또는 `useTabProcQuery` |
| `useState`로 페이지 전역 상태 | 탭 격리 안 됨 | `createPersistedStoreWithTab` (Zustand) |
| `any` 타입 | 타입 안정성 깨짐 | 정확한 타입 선언 |
| `console.log` 운영 코드 잔존 | 로그 노이즈 | `@foundation/utils`의 logger 사용 또는 제거 |
| inline 스타일 `<div style={{...}}>` | 디자인 시스템 무시 | SCSS Modules `import styles from './Foo.module.scss'` |
| Wijmo Grid 외 다른 그리드 라이브러리 | 일관성 깨짐 | `@mescius/wijmo.grid` 전용 |

### Backend ❌

| 금지 | 사유 | 올바른 패턴 |
|---|---|---|
| 단일 클래스에 Controller+Service+SQL | SoC 위반 | Controller / Service(인터페이스) / ServiceImpl 분리 |
| `@RequestMapping`만 사용 | HTTP method 명시 안 됨 | `@GetMapping/@PostMapping` 명시 |
| Controller에서 SQL 직접 호출 | 레이어 위반 | Service를 통해서만 |
| Hardcoded SQL ID (`"admin.user.retrieveUser"`) | 변경 시 누락 위험 | `nameSpace + "retrieveUser"` |
| Direct `Map<String, Object>` 반환 | 타입 정보 손실 | DTO + Builder + `of()` 변환 |
| `@Autowired` 필드 주입 | 테스트 어려움 | `@RequiredArgsConstructor` + final 필드 |
| `System.out.println` | 로그 표준 무시 | `@Slf4j` + `log.info()` |
| Owner명 prefix (`SCM_MGR.TABLE`) in MyBatis | Synonym 무시 | Synonym 통해 호출 |
| `try-catch` 후 무시 (swallow) | 디버깅 불가 | `throws Exception` 또는 SystemException |
| `ResponseEntity.ok().body(dto)` 직접 | BaseResponse 무시 | `successResponseEntity(dto)` |

## 4. 신규 화면 추가 표준 절차 (9 step)

### Step 1: DB Procedure 생성 + 컴파일
`PKG_DMF0099.P_DMF0099_GET_MAIN_DATA(...)` 등 화면별 PKG/Procedure 작성.

### Step 2: ⭐ 7개 영역 메타 등록 — 자기완결형 인라인 DML (2026-05-19 변경)

> ❌ **금지**: `PKG_NSCM_SCREEN_REGISTRATION.P_REGISTER_SCREEN` 호출 — **2026-05-19 폐기됨** (스키마 불일치 + 4영역만 지원).
> ✅ **표준**: 자기완결형 인라인 DML 7-BLOCK 패턴 + 4-파일 SQL 세트 (`.sql` / `_DBeaver.sql` / `_DBeaver_Verify.sql` / `_DBeaver_Diagnose.sql`).

7개 메타 영역 (의존 선후 순):

```
BLOCK 1: SCM_ADM_MSG_M           (i18n × KO/EN/CN 3행)
BLOCK 2: SCM_ADM_MNU_M           (메뉴 마스터)
BLOCK 3: SCM_ADM_PROC_M          (SP IN/OUT 파라미터 ★ 누락 시 빈 결과)
BLOCK 4: SCM_ADM_API_M           (API 메타, API_MSG_ID NOT NULL)
BLOCK 5: SCM_ADM_MNU_BTN_MPG_M   (MNU × SHT × BTN → API_ID 라우팅)
BLOCK 6: SCM_MST_SHEET_COLUMNS   (Grid 컬럼 정의)
BLOCK 7: SCM_ADM_USER_GR_MNU_MPG_M + SCM_ADM_USER_GR_MNU_BTN_MPG_M (메뉴+버튼 권한 2 테이블)
```

→ 상세 패턴: [`Doc/_dev_rules/08_SCREEN_REGISTRATION.md`](08_SCREEN_REGISTRATION.md) §3 (Step 1~8) + §7.1 (DBeaver 4-파일 룰)

### Step 3: ⭐ FE procedures.d.ts 갱신

```bash
pnpm gen:procedures    # 자동 생성 (BE 메타 API → DB → procedures.d.ts)
```

또는 수동으로 `configs/types/procedures.d.ts`에 화면 entry 추가.

### Step 4: Backend — Controller / Service / ServiceImpl / dto/ / Mapper.xml

(대부분 동적 호출 아키텍처를 통해 GeneralController로 처리됨. 특수 비즈니스 로직 있을 때만 작성)
```
src/main/java/com/lgcns/nscm/demand/dmf0099/
├── Dmf0099Controller.java
├── Dmf0099Service.java          (interface)
├── Dmf0099ServiceImpl.java      (BaseService 상속)
└── dto/
    ├── Dmf0099Request.java
    └── Dmf0099Response.java

src/main/resources/sql/demand/Dmf0099.xml  (namespace: demand.dmf0099)
```

### Step 5: Frontend — features/{domain}/src/pages/{kebab-case}/
```
features/demand/src/pages/dmf0099-some-screen/
├── Dmf0099SomeScreen.tsx            (메인)
├── dmf0099-some-screen.constants.ts (MENU_ID/SHEETS/RESPONSE_SET)
├── useDmf0099SomeScreenStore.ts     (Zustand)
├── index.ts                          (export *)
└── components/
    ├── Dmf0099SomeScreenForm.tsx       (검색 영역)
    ├── Dmf0099SomeScreenForm.module.scss
    └── Dmf0099SomeScreenGrid.tsx       (Wijmo FlexGrid)
```

### Step 6: 라우팅 등록
`apps/web/src/pages/` 또는 메뉴 마스터에 화면 등록.

### Step 7: 다국어 (i18n) — `SCM_ADM_MESSAGE_M` INSERT
`public/locales/{en|ko}/...` 또는 DB에 메시지 코드 등록 (예: `MNU_DMF0099`).

### Step 8: 검증 룰 작성
React Hook Form rules → BE @Valid + DB CHECK 제약 3중 방어.

### ⭐ Step 8.5: As-Is Validation / Expression 적용 (필수)
1. `validation.md` 의 모든 행 → `useXxxValidation.ts` 에 반영 (사업부 분기 / 권한 분기 / MSG 매핑 / Grid 이벤트 등)
2. `expressions.md` 의 모든 행 → `useXxxExpression.ts` 또는 cellTemplate/aggregate/formula 에 반영
3. `__asis-mapping__.md` 매핑 매트릭스 작성 (As-Is 라인 ↔ To-Be 위치 1:1)
4. 카운트 일치 검증 (`Validation 건수 = 적용 건수`, `Expression 건수 = 적용 건수`)

→ **상세**: [`09_WIJMO_VALIDATION_EXPRESSION.md`](09_WIJMO_VALIDATION_EXPRESSION.md)

### Step 9: 테스트
- BE: JUnit 5 (`@SpringBootTest` 또는 `@MybatisTest`)
- FE: Vitest + React Testing Library

→ **상세 템플릿**: [`05_SCREEN_TEMPLATE.md`](05_SCREEN_TEMPLATE.md)
→ **4 Table 메타 등록**: [`08_SCREEN_REGISTRATION.md`](08_SCREEN_REGISTRATION.md)
→ **As-Is Validation/Expression 반영**: [`09_WIJMO_VALIDATION_EXPRESSION.md`](09_WIJMO_VALIDATION_EXPRESSION.md)

## 5. 명명 규약 (절대 어기지 말 것)

### Frontend

| 항목 | 규칙 | 예시 |
|---|---|---|
| 컴포넌트 파일 | PascalCase | `UserManagement.tsx`, `UserManagementForm.tsx` |
| 컴포넌트 폴더 | kebab-case | `user-management/`, `forecast-price/` |
| 훅/유틸/스토어 파일 | camelCase | `useUserManagementStore.ts`, `useDebounce.ts` |
| 타입 파일 | kebab-case | `user-management.types.ts` |
| 상수 파일 | kebab-case | `user-management.constants.ts`, `app-config.ts` |
| SCSS Module | `*.module.scss` | `UserManagementForm.module.scss` |
| MENU_ID 변수 | 대문자 + `as const` | `export const MENU_ID = 'SYS0002' as const;` |
| Zustand store | `use{PageName}Store` | `useUserManagementStore` |
| Workspace alias | `@foundation`, `@shared`, `@admin`, `@demand` | `import { ... } from '@shared/components'` |

### Backend

| 항목 | 규칙 | 예시 |
|---|---|---|
| 패키지 | `com.lgcns.nscm.{domain}.{feature}` | `com.lgcns.nscm.admin.user` |
| Controller | `{Feature}Controller` | `UserController`, `MenuController` |
| Service Interface | `{Feature}Service` | `UserService`, `MenuService` |
| ServiceImpl | `{Feature}ServiceImpl extends BaseService` | `UserServiceImpl` |
| DTO | `{Feature}{Action}Request/Response` 또는 `{Feature}Dto` | `LoginRequest`, `MenuDto` |
| MyBatis nameSpace | 패키지 점표기 | `nameSpace = "admin.user."` |
| Mapper XML | `src/main/resources/sql/{domain}/{Feature}.xml` | `sql/admin/User.xml` |
| DB SP 호출 | `PKG_{UI_ID}.P_*` | `PKG_DMF0021.P_DMF0021_GET_SALES_PLAN` |
| 클래스 헤더 주석 | 표준 Javadoc | `@Project @Package @FileName @author @date @description` |

## 6. 표준 코드 패턴 (Copy-Paste 가능 템플릿)

### FE — Page Component (PageName.tsx)

```tsx
import { type FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useRef } from 'react';

import type { HotkeyConfig, PageProps } from '@foundation/models';
import { MainTitle, SubTitle } from '@shared/components';
import { useProcMutation, useSaveWithValidation, useTabProcQuery } from '@shared/hooks';

import { Dmf0099SomeScreenForm } from './components/Dmf0099SomeScreenForm';
import { Dmf0099SomeScreenGrid } from './components/Dmf0099SomeScreenGrid';
import type { RESPONSE_SET } from './dmf0099-some-screen.constants';
import { MENU_ID, SHEETS } from './dmf0099-some-screen.constants';
import { useDmf0099SomeScreenStore } from './useDmf0099SomeScreenStore';

export const Dmf0099SomeScreen = ({ tabId, title }: PageProps<MENU_ID>) => {
  const gridRef =
    useRef<FlexGrid<ResponseData<MENU_ID, SHEETS.MAIN, RESPONSE_SET.MAIN>>>();
  const gridFilterRef = useRef<FlexGridFilter>();

  const filters = useDmf0099SomeScreenStore(state => state.filters);
  const setFilters = useDmf0099SomeScreenStore(state => state.setFilters);
  // ... 다른 store 셀렉터들 (개별 셀렉터 사용 — useStore() 통째로 X)

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

  const onSave = () => {
    const saveData = data?.o_rc?.filter?.(item => item.CRUD_TYPE) ?? [];
    saveWithValidation(saveData, staticColumn, mutate);
  };

  const hotkeyConfig: HotkeyConfig = { save: onSave, /* ... */ };

  return (
    <>
      <MainTitle title={title} menuId={MENU_ID} {...} />
      <Dmf0099SomeScreenForm />
      <SubTitle menuId={MENU_ID} grid={gridRef} {...} />
      <Dmf0099SomeScreenGrid gridRef={gridRef} gridFilterRef={gridFilterRef} data={data?.o_rc ?? []} />
    </>
  );
};
```

### FE — constants.ts

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

### FE — Store (useDmf0099Store.ts)

```ts
import { apiClient } from '@foundation/apis';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStoreWithTab } from '@shared/stores';

import { MENU_ID, SHEETS } from './dmf0099-some-screen.constants';

interface SearchParamProps { /* ... */ }
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

const initState: State = { /* ... */ } as const;

export const useDmf0099SomeScreenStore = createPersistedStoreWithTab<State & Action>(
  (set, get) => ({
    ...initState,
    reset: () => set(initState),
    setSearchParams: searchParams => set(state => {
      state.searchParams = { ...get().searchParams, ...searchParams };
    }),
    // ... 패턴 동일
  }),
  'dmf0099-some-screen'  // tab key
);
```

### BE — Controller

```java
package com.lgcns.nscm.demand.dmf0099;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import com.lgcns.nscm.admin.user.UserSession;
import com.lgcns.nscm.framework.annotation.LoginUser;
import com.lgcns.nscm.framework.base.BaseController;
import com.lgcns.nscm.framework.model.BaseResponse;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Tag(name = "DMF0099. 화면 설명")
@RestController
@RequiredArgsConstructor
public class Dmf0099Controller extends BaseController {

    private final Dmf0099Service dmf0099Service;

    @Operation(summary = "메인 데이터 조회", description = "조건에 맞는 메인 데이터를 조회합니다.")
    @PostMapping(value = "/demand/dmf0099/main", produces = "application/json; charset=UTF-8")
    public ResponseEntity<BaseResponse<List<Dmf0099Response>>> retrieveMain(
            @LoginUser UserSession userSession,
            @RequestBody @Valid Dmf0099Request dto) throws Exception {
        return successResponseEntity(
            dmf0099Service.retrieveMain(userSession.getUserId(), dto));
    }
}
```

### BE — Service Interface

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

### BE — ServiceImpl

```java
package com.lgcns.nscm.demand.dmf0099;

import static com.lgcns.nscm.framework.base.BaseConstants.DEFAULT_DATA_RESULT;

import java.util.*;
import org.springframework.stereotype.Service;

import com.lgcns.nscm.demand.dmf0099.dto.*;
import com.lgcns.nscm.framework.base.BaseService;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

/**
 * DMF0099 화면 Service Impl
 * @Project  : nscm
 * @Package  : com.lgcns.nscm.demand.dmf0099
 * @FileName : Dmf0099ServiceImpl.java
 * @author   : {이름}
 * @date     : 2026. 5. 13.
 * @description : DMF0099 비즈니스 로직 구현
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class Dmf0099ServiceImpl extends BaseService implements Dmf0099Service {

    private final String nameSpace = "demand.dmf0099.";

    @Override
    public List<Dmf0099Response> retrieveMain(String userId, Dmf0099Request dto) throws Exception {
        Map<String, Object> params = new HashMap<>();
        params.put("userId", userId);
        params.put("divisionId", dto.getDivisionId());
        // ... 모든 파라미터

        Map<String, Object> result = selectList(nameSpace + "retrieveMain", params);
        List<Map<String, Object>> data = (List<Map<String, Object>>) result.get(DEFAULT_DATA_RESULT);

        return Dmf0099Response.listOf(data);
    }
}
```

### BE — MyBatis XML

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE mapper PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN"  "../../mybatis/mybatis-3-mapper.dtd">
<mapper namespace="com.lgcns.nscm.demand.dmf0099">

    <resultMap id="dmf0099ResultMap" type="java.util.HashMap" />

    <select id="retrieveMain" statementType="CALLABLE">
        { CALL PKG_DMF0099.P_DMF0099_GET_MAIN_DATA(
            #{userId},
            #{divisionId},
            <!-- 모든 파라미터 -->
            #{DATARESULT, mode=OUT, jdbcType=CURSOR, javaType=java.sql.ResultSet, resultMap=dmf0099ResultMap}
        ) }
    </select>

    <select id="saveMain" statementType="CALLABLE">
        { CALL PKG_DMF0099.P_DMF0099_SAVE_MAIN_DATA(
            #{userId},
            #{rows, mode=IN, jdbcType=CLOB}
        ) }
    </select>

</mapper>
```

### BE — DTO

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
    private Long qty;

    public static Dmf0099Response of(Map<String, Object> data) {
        return Dmf0099Response.builder()
            .divisionId((String) data.get("DIVISION_ID"))
            .itemId((String) data.get("ITEM_ID"))
            .qty(((Number) data.get("QTY")).longValue())
            .build();
    }

    public static List<Dmf0099Response> listOf(List<Map<String, Object>> datas) {
        List<Dmf0099Response> result = new ArrayList<>();
        for (Map<String, Object> d : datas) result.add(of(d));
        return result;
    }
}
```

## 7. AI 작업 시 자기 점검 절차

코드를 작성하기 전에 다음 5가지를 자문하세요:

1. **이 화면(또는 SP)와 가장 유사한 기존 코드는 무엇인가?** (Read 도구로 확인)
2. **import 순서가 표준을 따르는가?** (FE: foundation → shared → 같은 feature, BE: java → javax → org → com)
3. **이 함수/메서드를 추가하면 기존 인터페이스/클래스의 책임 분리가 깨지지 않는가?**
4. **하드코딩된 문자열/숫자는 constants로 추출됐는가?**
5. **테스트 가능한 구조인가?** (의존성 주입, 순수 함수)

## 8. 빠른 참조: 자주 쓰는 도구

| 작업 | FE | BE |
|---|---|---|
| 로컬 개발 | `pnpm local` | `./gradlew bootRun` |
| 빌드 | `pnpm build` | `./gradlew build` |
| 린트 | `pnpm lint:fix` | `./gradlew spotlessApply` |
| 타입 체크 | `pnpm type-check` | (컴파일 시 자동) |
| 테스트 | `pnpm test` | `./gradlew test` |
| Pre-commit | husky `lint-staged` 자동 | git hook (Spotless) |

---

> 본 문서는 작업 시작 시 가장 먼저 읽어야 할 가이드입니다. 상세 룰은 02~07 문서를, 신규 화면은 05_SCREEN_TEMPLATE.md를 참조하세요.
