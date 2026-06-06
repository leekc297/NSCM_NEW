# AS-IS ↔ TO-BE 매핑 + 격차 신규 구현 사양

> **목적**: AS-IS GSCM 의 모든 메커니즘이 TO-BE NSCM 에서 어떻게 표현되는지 1:1 매핑. **격차** = AS-IS 에 있으나 TO-BE 미구현 항목.
>
> **사용자 결정**:
> - 2026-06-03 (1차): 5 격차 (G1~G5) 모두 신규 구현
> - 2026-06-03 (2차): 추가 3 격차 (G6/G9/G10) 모두 신규 구현
> - 격차 유지: G7 (impersonation) + G8 (multi-column dropdown)
>
> **Phase 7 후속 (2026-06-04)**: 4 reference 화면 (DMF0004~7) + DMF0008 cascade cross-check 완료.
> - 룰 07 §2.10 7 sub-pattern 모두 reference 보강 (DMF0004 modal callback 신규 / DMF0005 다중 row propagate 신규)
> - 격차 cascade 18 건 발견 (DMF0004: 6 / DMF0005: 4 / DMF0006: 1 / DMF0007: 7) — 향후 보강 후보

---

## §1 격차 10건 요약

| # | 격차 | AS-IS 위치 | 결정 | 우선순위 | 신규 구현 phase |
|---:|---|---|---|---|---|
| G1 | 사용자별 검색조건 저장/복원 (F6/F10) | `BaseForm.OnClickConditionButton / OnClickResetConditionButton` (5237/5245) | ✅ 신규 구현 | ⭐ High | Phase 4-5 |
| G2 | BigFilter 캐싱 (1 round-trip DM lookup) | `DataService.GetDMInnerTable` (3682) + `InitBigFilterDM` (3630) | ✅ 신규 구현 | ⭐ High | Phase 4-5 |
| G3 | FP_Log2 "SpeedUp" 성능 추적 + 메뉴 open/close + 화면 실행 통합 | `DataService.FP_Log2` (829) + `BaseForm.SetSaveLog` (5963) + `Authentication.SaveMenuConnect` | ✅ 신규 구현 | Medium | Phase 5 |
| G4 | CommonPseudoBatch2 배치 처리 | `DataService.CommonPseudoBatch2` (1193) | ✅ 신규 구현 | Medium | Phase 5 |
| G5 | File transfer (FP_DataPull / FP_DataPush) | `DataService.FP_DataPull/Push/FileDataClient` (147~159) | ✅ 신규 구현 | Low | Phase 5+ |
| G6 | YesNoCancel confirm 3옵션 | `MessageHelper.GMessageBox` Button 코드 `0202004` | ✅ 신규 구현 | Low | Phase 4 |
| G7 | Impersonation (admin 대리 작업) | `UserInfoContext.NewUserID/NewDeptID/...` 7 properties | ❌ 격차 유지 | (없음) | (사용 빈도 0) |
| G8 | UsrColumnCombo (multi-column dropdown) | `Controls/UsrColumnCombo.cs` | ❌ 격차 유지 | (없음) | (사용 빈도 낮음) |
| G9 | DateRangePicker (date range picker) | `Controls/UsrDateRangePicker.cs` / `UsrDateRangePicker3.cs` | ✅ 신규 구현 | Medium | Phase 5 |
| G10 | MonthPicker / MonthRangePicker | `Controls/UsrMonthPicker.cs` / `UsrMonthRangePicker.cs` | ✅ 신규 구현 | Medium | Phase 5 |

> **High 우선순위 (G1+G2)** = DMF0004~7 + 모든 master 화면이 즉시 사용. PoC (Phase 6, DMF0015) 에서 검증 필수.
>
> **Medium 우선순위 (G3+G4+G9+G10)** = 모든 화면이 사용하나 성능/대량/일자 처리 시에만 critical.
>
> **Low 우선순위 (G5+G6)** = 일부 화면에서 사용. Phase 5 후반.
>
> **격차 유지 (G7+G8)** = 사용 빈도 거의 0 / 0 — 필요 발생 시 추후 신규 구현 결정 가능.

---

## §2 격차 1: 사용자별 검색조건 저장/복원 (G1)

### §2.1 AS-IS 메커니즘 요약

```
[F6 OnClickConditionButton]
  → CheckCondition(ctl) → SavePanelCondition(ctl)
  → 모든 UsrXxx 컨트롤의 ControlValues / SelectedItem 추출 → lstSearchConditon 에 add
  → foreach → FoxBizClient "Authentication.SaveSearchCondition" 호출 (controlName, controlValue 1건씩)
  → 성공 시 MSG00155 "조회 조건이 저장되었습니다"

[F10 OnClickResetConditionButton]
  → MSG00397 (확인) → ResetPanelCondition
  → FoxBizClient "Authentication.ResetSearchCondition" 호출 (groupID, userID, menuID)
  → 성공 시 MSG00398 "검색조건이 초기화 되었습니다"

[화면 진입 시 OnShown]
  → FoxBizClient "MenuContainer.UP_FX_GetSearchCondition" → dsSearchCondition 로딩
  → foreach Control → InitPanel 에서 type 별 restore (UsrCheckBox.Checked / UsrCombo.SelectedItem / UsrCheckedList.ControlValues / UsrTextBox.Text / UsrDatePicker.Value / etc)
```

### §2.1.1 ⚠️ Phase 3 사양 정정 (GET 부분 이미 구현)

> Phase 3 (DMF0004~7 정밀 분석, 2026-06-03) 에서 발견:
> - **GET (자동 restore) = 이미 구현됨** — 모든 4 reference 화면의 `store.fetchStaticColumns` 안에 `apiClient.get('/admin/menu/{menuId}/search-conditions')` 존재 + `searchParams` 자동 restore (`useStore`).
> - **POST (저장 — F6) + DELETE (초기화 — F10) 만 신규 구현 필요** + FE `SubTitle.DefaultButtonActions` 의 condition / resetCondition action 활성.
> - 결과: G1 신규 구현 범위 축소 (3 endpoint → **2 endpoint** + FE hook 활성).

### §2.2 신규 구현 사양 (TO-BE)

#### G1.1 DB

**신규 테이블**: `SCM_SYS_USR_SEARCH_COND_M`

| 컬럼 | 타입 | 제약 | 설명 |
|---|---|---|---|
| USER_ID | VARCHAR2(20) | PK1, NOT NULL | 사용자 ID |
| GR_ID | VARCHAR2(20) | PK2, NOT NULL | 권한 그룹 ID (AS-IS NowGroupID) |
| MNU_ID | VARCHAR2(20) | PK3, NOT NULL | 메뉴 ID (예: DMF0007) |
| CTRL_NM | VARCHAR2(50) | PK4, NOT NULL | FE field name (예: `divisionId`, `endCustomerIds`) |
| CTRL_VAL | VARCHAR2(2000) | NULL OK | 저장된 값 (multi-value 는 "," join) |
| INS_USR | VARCHAR2(20) | NOT NULL | 등록자 |
| INS_DT | DATE | NOT NULL DEFAULT SYSDATE | 등록일 |
| UPD_USR | VARCHAR2(20) | NULL OK | 수정자 |
| UPD_DT | DATE | NULL OK | 수정일 |

**신규 SP** (GET 은 이미 구현 — 추가 X):
- ~~`P_SCM_SYS_USR_SEARCH_COND_GET`~~ (이미 구현 — `apiClient.get('/admin/menu/{menuId}/search-conditions')` 호출)
- ✅ `P_SCM_SYS_USR_SEARCH_COND_SAVE_ALL` (P_USER_ID, P_GR_ID, P_MNU_ID, P_DATA_CLOB) → CLOB JSON 으로 일괄 저장 (DELETE + INSERT)
- ✅ `P_SCM_SYS_USR_SEARCH_COND_RESET` (P_USER_ID, P_GR_ID, P_MNU_ID) → 해당 메뉴의 모든 row DELETE

**메타 등록** (BLOCK 1~7 표준):
- BLOCK 1 — i18n (MSG ID 신규: `MSG00155` 동등 / `MSG00397` 동등 / `MSG00398` 동등 / `MSG00399` 동등)
- BLOCK 4 — SCM_ADM_PROC_M (**2 SP** × camelCase 파라미터 매핑 — `sesUserId / sesGrId / mnuId / dataClob`) — Phase 3 정정
- BLOCK 5 — SCM_ADM_API_M (**2 endpoint 신규**: `POST /admin/menu/{menuId}/search-conditions` / `DELETE /admin/menu/{menuId}/search-conditions`) — Phase 3 정정 (GET 은 이미 구현됨)

#### G1.2 BE (Spring Boot)

**위치**: `nscm-be/src/main/java/com/lgcns/nscm/system/searchcondition/`

```
SearchConditionController.java
  GET    /api/system/search-condition/{menuId}    → Map<String,Object> getList
  POST   /api/system/search-condition/{menuId}    → success (saveAll, RequestBody = Map<String, Object>)
  DELETE /api/system/search-condition/{menuId}    → success (reset)
SearchConditionService.java (interface)
SearchConditionServiceImpl.java extends BaseService
sql/system/SearchCondition.xml (MyBatis)
  namespace=com.lgcns.nscm.system.searchcondition
  retrieveCondition / saveCondition / resetCondition (3 SP call)
```

**자동 인증**: `@LoginUser UserInfo` annotation 으로 USER_ID 자동 주입. GR_ID 는 session 에서 `currentGrId` 사용.

#### G1.3 FE (React 19)

**위치**: `nscm-fe/shared/hooks/` + `nscm-fe/shared/components/SubTitle/`

```
@shared/hooks/useSearchConditionPersistence.ts
  export const useSearchConditionPersistence = (menuId: string) => {
    const queryClient = useQueryClient();
    const { data: savedConditions } = useQuery({
      queryKey: ['search-condition', menuId],
      queryFn: () => apiClient.get(`/api/system/search-condition/${menuId}`),
    });
    const saveCondition = useMutation({
      mutationFn: (params) => apiClient.post(`/api/system/search-condition/${menuId}`, params),
      onSuccess: () => toast.success(t('MSG00155')),
    });
    const resetCondition = useMutation({
      mutationFn: () => apiClient.delete(`/api/system/search-condition/${menuId}`),
      onSuccess: () => {
        queryClient.invalidateQueries(['search-condition', menuId]);
        toast.success(t('MSG00398'));
      },
    });
    return { savedConditions, saveCondition, resetCondition };
  };

@shared/components/SubTitle/SubTitle.tsx
  // condition / resetCondition action 의 default 구현:
  // - condition: useSearchConditionPersistence(menuId).saveCondition(searchParams)
  // - resetCondition: setConfirm(t('MSG00397')) → resetCondition()
```

**자동 restore**: 메인 페이지 컴포넌트의 useEffect 에 `if (savedConditions && !initialized) setSearchParams(savedConditions)`.

**Store 통합**:
```
usePageStore.searchParams 와 동기화. 사용자가 F6 누르면 → 현재 searchParams 저장.
화면 진입 시 → searchParams 가 saved 값으로 초기화 (없으면 기본값).
```

#### G1.4 룰셋 v2 반영 위치
- `_tobe/06_search_area.md` §G1 검색조건 저장/복원 표준 (의무: useSearchConditionPersistence 사용)
- `_tobe/09_subtitle_hotkey.md` §SubTitle.DefaultButtonActions §condition/resetCondition default 의미 변경 (`false` → 자동 저장/초기화)
- `_tobe/11_be_controller_service.md` §G1 SearchCondition controller 패턴
- `_tobe/12_metadata_sql.md` §SCM_SYS_USR_SEARCH_COND_M 테이블 DDL
- 메모리 `feedback_search_aux_default_activation.md` 갱신 (조건/초기화 = 자동 활성, false 강제 X)

---

## §3 격차 2: BigFilter 캐싱 (G2)

### §3.1 AS-IS 메커니즘 요약

```
DM 화면 진입 시:
  → DataService.GetDMInnerTable("MyDivision", BigFilter)
  → 첫 호출 시 CommonExecuteQuery2(@"DM\Common\BigFilter", "list_line_dm", BigFilter.Dictionary)
  → SP 가 단일 호출로 모든 DM lookup (Tables[0]=MyDivision, Tables[1]=Team, Tables[2]=EndCustomer, Tables[3]=Site, ...) 반환
  → dsAllDM static 변수에 캐시
  → 이후 GetDMInnerTable("UserTeamByDivision") 등 호출 시 dsAllDM.Tables[i] 에서 in-memory filter
  
  결과: cboDivision 변경 시 5+ lookup 갱신 = 1 round-trip
```

### §3.2 신규 구현 사양

#### G2.1 DB

**기존 SP 활용**: AS-IS 의 `BigFilter:list_line_dm` SP 를 Oracle 19c 로 변환
- `P_DM_BIG_FILTER_GET` — IN: P_USER_ID / P_DIVISION_ID / P_DEPT_ID / P_END_CUSTOMER / ... — OUT: O_RC_MY_DIVISION / O_RC_TEAM / O_RC_END_CUSTOMER / O_RC_SALES_SITE / O_RC_BIZ_TYPE / O_RC_PLANT_SITE / O_RC_BUCKET / O_RC_CURRENCY (8+ cursor)

**메타 등록**:
- BLOCK 4 — SCM_ADM_PROC_M: 8+ cursor result 의 COL_NM = `o_rcMyDivision / o_rcTeam / o_rcEndCustomer / ...` (camelCase)
- BLOCK 5 — SCM_ADM_API_M: `POST /api/lookup/dm/big-filter`

#### G2.2 BE

**위치**: `nscm-be/src/main/java/com/lgcns/nscm/common/lookup/`

```
BigFilterDmController.java
  POST /api/lookup/dm/big-filter
  RequestBody = { divisionIds: string, deptIds: string, endCustomerIds: string, ... }
  Response = {
    o_rcMyDivision: [{CODE, NAME}],
    o_rcTeam:       [{CODE, NAME, DIVISION_ID}],
    o_rcEndCustomer:[{CODE, NAME, DIVISION_ID}],
    o_rcSalesSite:  [{CODE, NAME, DIVISION_ID, END_CUSTOMER}],
    o_rcBizType:    [{CODE, NAME, DIVISION_ID}],
    ...
  }
BigFilterDmService.java + impl
sql/common/BigFilterDm.xml
  namespace=com.lgcns.nscm.common.lookup
  retrieveBigFilter (단일 SP, 8+ cursor 반환)
```

#### G2.3 FE

**신규 hook**: `@shared/hooks/useBigFilterDM.ts`

```typescript
import { useQuery } from '@tanstack/react-query';
import { useMemo } from 'react';

export interface BigFilterDmParams {
  divisionIds?: string;
  deptIds?: string;
  endCustomerIds?: string;
}

export interface BigFilterDmResult {
  myDivision:   { CODE: string; NAME: string }[];
  team:         { CODE: string; NAME: string; DIVISION_ID: string }[];
  endCustomer:  { CODE: string; NAME: string; DIVISION_ID: string }[];
  salesSite:    { CODE: string; NAME: string; DIVISION_ID: string; END_CUSTOMER: string }[];
  bizType:      { CODE: string; NAME: string; DIVISION_ID: string }[];
  plantSite:    { CODE: string; NAME: string; DIVISION_ID: string }[];
  bucket:       { CODE: string; NAME: string }[];
  currency:     { CODE: string; NAME: string }[];
}

export const useBigFilterDM = (params: BigFilterDmParams) => {
  const { data, ...rest } = useQuery({
    queryKey: ['big-filter-dm', params.divisionIds],
    queryFn: () => apiClient.post<BigFilterDmResult>('/api/lookup/dm/big-filter', params),
    staleTime: 5 * 60 * 1000, // 5 분 캐시
  });

  // in-memory filter (AS-IS GetDMInnerTable 의 case 별 분기 동등)
  const filterByDivision = useMemo(() => (divisionId: string) => ({
    team:        data?.team.filter(t => t.DIVISION_ID === divisionId) ?? [],
    endCustomer: data?.endCustomer.filter(e => e.DIVISION_ID === divisionId) ?? [],
    salesSite:   data?.salesSite.filter(s => s.DIVISION_ID === divisionId) ?? [],
    bizType:     data?.bizType.filter(b => b.DIVISION_ID === divisionId) ?? [],
    plantSite:   data?.plantSite.filter(p => p.DIVISION_ID === divisionId) ?? [],
  }), [data]);

  return { data, filterByDivision, ...rest };
};
```

**`useTabComboQueries` 통합**: 기존 `useTabComboQueries({ filters: ['MyDivision', 'TeambyDivision', ...] })` 와 병행 사용 가능. DM 도메인 화면은 **`useBigFilterDM` 우선 사용**, 다른 lookup 만 `useTabComboQueries` 로.

#### G2.4 룰셋 v2 반영 위치
- `_tobe/06_search_area.md` §G2 BigFilter 패턴 (DM 도메인 화면 의무: useBigFilterDM 우선)
- `_tobe/11_be_controller_service.md` §G2 BigFilter controller
- `_tobe/12_metadata_sql.md` §P_DM_BIG_FILTER_GET SP 사양
- 메모리 `reference_combo_sql_id_inventory.md` 갱신 (BigFilter 사용 시 개별 SQL_ID 불필요)

---

## §4 격차 3: FP_Log2 "SpeedUp" 성능 추적 (G3)

### §4.1 AS-IS 메커니즘

```csharp
DataService.FP_Log2("SpeedUp", "DMF0004", "division_id_changed", "start");
// ... heavy work (DB query / grid refresh) ...
DataService.FP_Log2("SpeedUp", "DMF0004", "division_id_changed", "end");

// → FP_ExecuteQuery("Utility", "note2", {LOGTYPE: "SpeedUp", NOTE: "DMF0004\r\ndivision_id_changed\r\nstart\r\n", USER_ID: ...})
// → SCM_SYS_LOG 테이블에 trace 기록
```

### §4.2 신규 구현 사양

#### G3.1 DB

**기존 활용**: `SCM_SYS_LOG` 테이블 (이미 존재). 추가 컬럼 검토:
- `PERF_TRACE_ID` (VARCHAR2(50)) — start/end 매칭용 (ULID)
- `PERF_DURATION_MS` (NUMBER) — start ↔ end 사이 ms

또는 신규 분리 테이블 `SCM_SYS_PERF_LOG`:

| 컬럼 | 타입 | 설명 |
|---|---|---|
| TRACE_ID | VARCHAR2(50) PK | ULID |
| USER_ID | VARCHAR2(20) NOT NULL | |
| MENU_ID | VARCHAR2(20) NOT NULL | |
| ACTION | VARCHAR2(50) NOT NULL | 예: 'division_change' / 'find' / 'save' |
| PHASE | VARCHAR2(20) | 'start' / 'end' |
| EVENT_AT | TIMESTAMP NOT NULL | |
| DURATION_MS | NUMBER | (end 시점에 계산) |
| EXTRA_JSON | CLOB | (선택, 추가 컨텍스트) |

**SP**: `P_SCM_SYS_PERF_LOG` (insert) + `P_SCM_SYS_PERF_LOG_END` (update with duration)

#### G3.2 BE (Spring Boot)

**Annotation 기반** (권장):

```java
@PerfLog(menuId = "DMF0004", action = "find")
public List<...> retrieveMain(...) { ... }
```

AOP 로 자동 start/end + duration 계산 + `SCM_SYS_PERF_LOG` INSERT.

**또는 Logger MDC 기반**:
```java
MDC.put("traceId", ULID.randomUlid());
MDC.put("menuId", menuId);
MDC.put("action", "find");
logger.info("PERF start");
// ... work ...
logger.info("PERF end duration={}ms", elapsed);
```

Logback config 에서 PERF logger 만 별도 appender 로 SCM_SYS_PERF_LOG 에 기록.

#### G3.3 FE (옵션)

**자동 추적 hook**: `@shared/hooks/usePerfTrace.ts`

```typescript
export const usePerfTrace = (menuId: string) => {
  const trace = useMutation({
    mutationFn: ({action, phase, duration}: {action: string; phase: 'start'|'end'; duration?: number}) =>
      apiClient.post('/api/system/perf-log', { menuId, action, phase, duration }),
  });
  
  const measure = async <T>(action: string, fn: () => Promise<T>): Promise<T> => {
    const start = performance.now();
    trace.mutate({ action, phase: 'start' });
    try {
      const result = await fn();
      const duration = performance.now() - start;
      trace.mutate({ action, phase: 'end', duration });
      return result;
    } catch (e) {
      trace.mutate({ action, phase: 'end', duration: -1 });
      throw e;
    }
  };
  
  return { measure };
};
```

**사용 예**:
```typescript
const { measure } = usePerfTrace(MENU_ID);
const handleDivisionChange = async (divisionId: string) => {
  await measure('division_change', async () => {
    await refetchCombos({ divisionIds: divisionId });
  });
};
```

#### G3.4 룰셋 v2 반영 위치
- `_tobe/11_be_controller_service.md` §G3 @PerfLog annotation / Logger MDC 표준
- `_tobe/03_main_component.md` §G3 usePerfTrace 사용 패턴 (선택)
- 메모리 `reference_scm_sys_perf_log.md` 신규 (테이블 DDL 참조)

---

## §5 격차 4: CommonPseudoBatch2 배치 처리 (G4)

### §5.1 AS-IS 메커니즘

```csharp
// 대량 데이터 (1000+ rows) 저장 시
DataService.CommonPseudoBatch2(
    "DM\\Master\\DMF0008",     // sql_define_page
    "save_main_data",           // batch_id
    dsSrc,                      // DataSet (전체)
    100,                        // batch_count (한 번에 100 row 씩 분할)
    ...
);
// → BE 가 dsSrc 를 100 row chunk 로 분할 후 SP 호출 × N 회
```

### §5.2 신규 구현 사양

#### G4.1 BE

**신규 endpoint**: `/api/batch/{menuId}/{sheetName}`

```java
@PostMapping("/api/batch/{menuId}/{sheetName}")
public Response<BatchResult> batchSave(
    @PathVariable String menuId,
    @PathVariable String sheetName,
    @RequestBody BatchRequest request  // { chunkSize: 100, data: [...] }
) {
    // 1. data 를 chunkSize 단위로 분할
    // 2. 각 chunk 를 SP 에 전달 (트랜잭션 분리 옵션)
    // 3. 진행률 응답 (SSE 또는 polling)
}

public class BatchResult {
    int totalCount;
    int successCount;
    int failCount;
    List<BatchError> errors;
}
```

**SP 측**: 기존 `P_DMF000N_SAVE_*` SP 를 chunk 단위로 호출 (CLOB 안에 chunk data).

#### G4.2 FE

**신규 hook**: `@shared/hooks/useBatchMutation.ts`

```typescript
export const useBatchMutation = <T>(menuId: string, sheetName: string) => {
  return useMutation({
    mutationFn: async ({ data, chunkSize = 100, onProgress }: {
      data: T[]; chunkSize?: number; onProgress?: (p: number) => void;
    }) => {
      const chunks = chunkArray(data, chunkSize);
      const results = [];
      for (let i = 0; i < chunks.length; i++) {
        const r = await apiClient.post(`/api/batch/${menuId}/${sheetName}`, {
          data: chunks[i],
        });
        results.push(r);
        onProgress?.((i + 1) / chunks.length);
      }
      return mergeResults(results);
    },
  });
};
```

#### G4.3 룰셋 v2 반영
- `_tobe/03_main_component.md` §G4 대량 저장 시 useBatchMutation 사용 (1000+ rows)
- `_tobe/11_be_controller_service.md` §G4 batch controller 패턴

---

## §6 격차 5: File Transfer (G5)

### §6.1 AS-IS 메커니즘

```csharp
// 파일 업로드
DataService.FP_DataPush("/server/path/", "domain", "file.xlsx", true, dictParam, ...);

// 파일 다운로드
DataService.FP_DataPull("/local/path/", "/server/path/", "file.xlsx", dictParam, ...);

// 파일 + 데이터 (FoxDataClient 안에 binary 첨부)
DataService.FP_FileDataClient("/path/", "options", dictParam, "/WSL.svc", 60000);
```

### §6.2 신규 구현 사양

#### G5.1 DB

**신규 테이블**: `SCM_SYS_FILE_M`

| 컬럼 | 타입 | 설명 |
|---|---|---|
| FILE_ID | VARCHAR2(50) PK | ULID |
| MENU_ID | VARCHAR2(20) NOT NULL | 업로드 화면 |
| ORIG_FILE_NM | VARCHAR2(255) NOT NULL | 원본 파일명 |
| STORED_PATH | VARCHAR2(500) NOT NULL | 저장 경로 (S3 key 또는 로컬) |
| FILE_SIZE | NUMBER NOT NULL | bytes |
| CONTENT_TYPE | VARCHAR2(100) | MIME type |
| UPLOAD_USR | VARCHAR2(20) NOT NULL | |
| UPLOAD_DT | TIMESTAMP NOT NULL | |
| EXPIRY_DT | TIMESTAMP | 만료일 (선택) |

#### G5.2 BE

**위치**: `nscm-be/src/main/java/com/lgcns/nscm/system/file/`

```
FileController.java
  POST /api/file/upload                   → multipart, return FileMeta
  GET  /api/file/download/{fileId}        → binary stream
  GET  /api/file/meta/{fileId}            → FileMeta
  DELETE /api/file/{fileId}               → success
FileService.java + impl
  S3 또는 local storage 추상화 (Strategy pattern)
  config-local.yml: storage.type=local / storage.localPath=/data/uploads
```

#### G5.3 FE

**신규 컴포넌트**:
```
@shared/components/FileUploader/FileUploader.tsx
  Props: { menuId, onUpload: (file: FileMeta) => void, accept?: string, maxSize?: number }
  - drag-drop + click upload
  - progress bar
  - error handling (size / type)

@shared/components/FileDownloader/FileDownloader.tsx  
  Props: { fileId: string; fileName: string; }
  - download button
  - 자동 토큰 인증
```

#### G5.4 룰셋 v2 반영
- `_tobe/11_be_controller_service.md` §G5 File controller
- `_tobe/12_metadata_sql.md` §SCM_SYS_FILE_M DDL
- `_tobe/03_main_component.md` §G5 FileUploader / FileDownloader 사용 표준

---

## §6A 격차 6: YesNoCancel confirm 3옵션 (G6)

### §6A.1 AS-IS 메커니즘

```csharp
// MessageHelper.GMessageBox(MSG_ID) — Button 코드 "0202004" = YesNoCancel
// 예: MSG00100 "저장하지 않고 바로 열겠습니까?" → Yes/No/Cancel
DialogResult result = MessageHelper.GMessageBox("MSG00100");
if (result == DialogResult.Yes)      ExportExcel3(true);    // 저장 + 열기
else if (result == DialogResult.No)  ExportExcel3(false);   // 저장만
else                                 return;                 // Cancel
```

### §6A.2 신규 구현 사양

#### G6.1 FE (BE 없음 — 순수 UI)

**신규 hook**: `@shared/hooks/useConfirmYesNoCancel.ts`

```typescript
import { useCallback } from 'react';

export type YesNoCancelResult = 'yes' | 'no' | 'cancel';

export interface ConfirmYesNoCancelOptions {
  title?: string;
  message: string;
  yesLabel?: string;   // default: t('LBL_YES')
  noLabel?: string;    // default: t('LBL_NO')
  cancelLabel?: string; // default: t('LBL_CANCEL')
}

export const useConfirmYesNoCancel = () => {
  // Promise-based API (await 가능)
  const confirm = useCallback((opts: ConfirmYesNoCancelOptions): Promise<YesNoCancelResult> => {
    return new Promise((resolve) => {
      // CustomDialog 3-button variant 렌더
      // Yes/No/Cancel 클릭 시 resolve('yes'|'no'|'cancel')
    });
  }, []);
  
  return confirm;
};
```

**컴포넌트 확장**: `@shared/components/CustomDialog/CustomDialog.tsx` 에 `buttons: 'yesNoCancel'` variant 추가.

```typescript
// 사용 예
const confirmYNC = useConfirmYesNoCancel();
const handleExcel = async () => {
  const r = await confirmYNC({ message: t('MSG00100') });
  if (r === 'yes')      exportExcel(true);
  else if (r === 'no')  exportExcel(false);
  // r === 'cancel' → 아무 것도 안 함
};
```

#### G6.2 룰셋 v2 반영
- `_tobe/14_error_handling.md` §G6 — setAlert / setConfirm 외에 confirmYesNoCancel 표준
- `_tobe/__TEMPLATE__.md` 의 §1 표준 패턴에 추가
- 메모리 `feedback_confirm_yes_no_cancel.md` 신규 — AS-IS Button 코드 `0202004` 매핑 시 의무

---

## §6B 격차 9: DateRangePicker (G9)

### §6B.1 AS-IS 메커니즘

```csharp
// UsrDateRangePicker — date range 입력
// ControlValues 형식: "yyyyMMdd-yyyyMMdd" 또는 단일 "yyyyMMdd"
public class UsrDateRangePicker : Control, IRangeSettable {
    public Tuple<DateTime, DateTime> Values { get; set; }  // (start, end)
    public DateTime Value1 { get; set; }
    public DateTime Value2 { get; set; }
    
    // BaseForm.InitPanel 에서 자동 restore:
    // value.Split('-') → s_date / e_date 분해 → usrCtl.Values = (s, e)
}
```

**사용 화면 예**: 분석/리포트 화면에서 일자 범위 조회.

### §6B.2 신규 구현 사양

#### G9.1 FE (BE 없음 — 순수 UI)

**신규 컴포넌트**: `@shared/components/DateRangePicker/DateRangePicker.tsx`

```typescript
import dayjs, { Dayjs } from 'dayjs';

export interface DateRangePickerProps {
  startDate?: Dayjs | string | null;
  endDate?: Dayjs | string | null;
  onChange: (range: { startDate: Dayjs; endDate: Dayjs }) => void;
  minDate?: Dayjs;
  maxDate?: Dayjs;
  format?: string;  // default 'YYYY-MM-DD'
  separator?: string;  // default ' ~ '
  disabled?: boolean;
  required?: boolean;
}

export const DateRangePicker = ({ startDate, endDate, onChange, ... }: DateRangePickerProps) => {
  // 2 개 DatePickerCalendar 조합 (start + end) + 범위 보장 (end >= start)
  // 또는 단일 RangePicker (lges DateRangePicker 가 있으면 그것 사용)
};
```

**SearchParam 매핑**:
```typescript
// store
interface SearchParams {
  periodStartDate?: string;  // 'YYYYMMDD' format (AS-IS 동등)
  periodEndDate?: string;
}

// 사용
<DateRangePicker
  startDate={searchParams.periodStartDate ? dayjs(searchParams.periodStartDate, 'YYYYMMDD') : null}
  endDate={searchParams.periodEndDate ? dayjs(searchParams.periodEndDate, 'YYYYMMDD') : null}
  onChange={({ startDate, endDate }) => setSearchParams({
    periodStartDate: startDate.format('YYYYMMDD'),
    periodEndDate:   endDate.format('YYYYMMDD'),
  })}
/>
```

**SearchFields 카탈로그 통합**: `@master/components/searchFields/PeriodRangeField.tsx` 추가 (Period 카탈로그 확장).

#### G9.2 룰셋 v2 반영
- `_tobe/06_search_area.md` §G9 — DateRangePicker 표준 (ControlValues = "YYYYMMDD-YYYYMMDD" 매핑)
- `_master/searchFields/` 카탈로그에 PeriodRangeField 추가

---

## §6C 격차 10: MonthPicker / MonthRangePicker (G10)

### §6C.1 AS-IS 메커니즘

```csharp
// UsrMonthPicker — month 단일 선택 (yyyyMM)
// UsrMonthRangePicker — month 범위 (yyyyMM-yyyyMM)
public class UsrMonthPicker : Control {
    public DateTime Value { get; set; }  // 일자 부분 무시, 월만 사용
    // ControlValues 형식: "yyyyMM"
}

public class UsrMonthRangePicker : Control {
    public Tuple<DateTime, DateTime> Values { get; set; }
    // ControlValues 형식: "yyyyMM-yyyyMM"
}
```

**사용 화면 예**: 월 단위 계획/분석 화면 (FP 도메인 다수, DM 일부).

### §6C.2 신규 구현 사양

#### G10.1 FE (BE 없음 — 순수 UI)

**신규 컴포넌트 2 종**:

`@shared/components/MonthPicker/MonthPicker.tsx`:
```typescript
export interface MonthPickerProps {
  value?: Dayjs | string | null;  // 'YYYYMM' format
  onChange: (month: Dayjs) => void;  // dayjs (.format('YYYYMM') 사용)
  minMonth?: Dayjs;
  maxMonth?: Dayjs;
  disabled?: boolean;
  required?: boolean;
}

export const MonthPicker = (props: MonthPickerProps) => {
  // dayjs based month picker (DatePicker view='month' 또는 별도 UI)
  // value 가 string 인 경우 dayjs(value, 'YYYYMM') 변환
};
```

`@shared/components/MonthRangePicker/MonthRangePicker.tsx`:
```typescript
export interface MonthRangePickerProps {
  startMonth?: Dayjs | string | null;
  endMonth?: Dayjs | string | null;
  onChange: (range: { startMonth: Dayjs; endMonth: Dayjs }) => void;
  minMonth?: Dayjs;
  maxMonth?: Dayjs;
  separator?: string;
}

// 2 개 MonthPicker 조합 + 범위 보장
```

**SearchFields 카탈로그**:
- `@master/components/searchFields/MonthField.tsx`
- `@master/components/searchFields/MonthRangeField.tsx`

#### G10.2 룰셋 v2 반영
- `_tobe/06_search_area.md` §G10 — MonthPicker / MonthRangePicker 표준
- `_master/searchFields/` 카탈로그에 MonthField / MonthRangeField 추가

---

## §7 격차 구현 phase 계획

| Phase | 산출 | 시점 | 검증 |
|---|---|---|---|
| Phase 4 | 룰셋 v2 의 `_tobe/*.md` 에 8 격차 신규 구현 사양 반영 (G1~G6 + G9 + G10) | Phase 3 종료 직후 | 룰셋 자체 검증 |
| Phase 5 (G1+G2) | G1 (SearchCondition) + G2 (BigFilter) 의 DB + BE + FE 구현 | Phase 4 직후 | DMF0004 또는 DMF0007 retrofit |
| Phase 5 (G6) | G6 (YesNoCancel) 의 useConfirmYesNoCancel hook + CustomDialog 확장 | Phase 4 (간단) | MSG00100 ExcelButtonWithoutCopy 동작 |
| Phase 5 (G9+G10) | G9 (DateRangePicker) + G10 (MonthPicker / MonthRangePicker) 의 컴포넌트 + searchFields 카탈로그 | Phase 4 직후 | SearchArea 통합 테스트 |
| Phase 5 (G3) | G3 (PerfLog) 의 BE annotation + FE hook 구현 | G1/G2 후 | 모든 master 화면 자동 적용 |
| Phase 5 (G4) | G4 (Batch) 의 endpoint + hook | DMF0008 / DMF0020 대량 데이터 화면 retrofit 시 | 1000+ rows 대량 저장 테스트 |
| Phase 5 (G5) | G5 (File transfer) 의 endpoint + 컴포넌트 | LCB / 첨부파일 화면 필요 시 | 별도 PoC |
| Phase 6 | PoC (DMF0015 BOD) 에서 G1+G2+G6+G9+G10 검증 | Phase 5 G1/G2/G6/G9/G10 직후 | 보완사항 ≤ 10 |

**중요 결정**:
- **G1 + G2 + G6 + G9 + G10 이 Phase 6 PoC 의 success criterion 핵심**. PoC 화면이 자동 검색조건 restore + BigFilter 1 round-trip + YesNoCancel + DateRange + Month picker 모두 동작해야 함.
- G3 / G4 / G5 는 PoC 이후 추가 retrofit.

---

## §8 AS-IS ↔ TO-BE 전체 매핑 표 (5 격차 포함 → 모두 신규 구현)

| AS-IS 메커니즘 | TO-BE 등가물 | 매핑 상태 | 룰 위치 |
|---|---|---|---|
| F1 Help (HelpButton virtual) | Help button (제거 또는 별도 가이드 URL) | OK | (없음) |
| F2 Edit (EditButton virtual + IsLock) | column meta `_inputEditType` 자동 (DataGrid wrapper) | OK | `_tobe/08_column_meta.md` |
| F3 Sort (OnClickSortButton) | DataGrid `allowSorting={true}` (자동) | OK | `_tobe/07_datagrid.md` |
| F4 Filter (OnClickFilterButton) | FlexGridFilter 자동 (DataGrid 내장) | OK | `_tobe/07_datagrid.md` |
| F5 Find (FindButton virtual) | handleSearch + useTabProcQuery refetch | OK | `_tobe/03_main_component.md` |
| **F6 Condition (Save search)** | **G1 useSearchConditionPersistence (신규)** | **G1 신규 구현** | `_tobe/06_search_area.md` §G1 |
| F7 Save (SaveButton virtual) | handleSave + useSaveWithValidation + useProcMutation | OK | `_tobe/03_main_component.md` |
| F8 Insert (InsertButton virtual) | handleInsert + GridAction.addRow | OK | `_tobe/03_main_component.md` |
| F9 Delete (DeleteButton virtual) | handleDelete + GridAction.removeRow(true) | OK | `_tobe/03_main_component.md` |
| **F10 ResetCondition** | **G1 useSearchConditionPersistence.reset (신규)** | **G1 신규 구현** | `_tobe/06_search_area.md` §G1 |
| F12 Excel (ExcelButton virtual) | SubTitle excelFileName (자동) | OK | `_tobe/09_subtitle_hotkey.md` |
| OnClickXxxButton 권한 가드 (CanSelect/...) | 메뉴/버튼 권한 2 테이블 (SCM_ADM_USER_GR_MNU_MPG_M + SCM_ADM_USER_GR_MNU_BTN_MPG_M) | OK | `_tobe/11_be_controller_service.md` |
| CheckValidation(ButtonType) IsLock | column meta 자동 처리 | OK | `_tobe/08_column_meta.md` |
| FormAuth enum (None/Disable/Inquiry/Update/All) | 폐기 (메뉴/버튼 권한 조합으로 대체) | OK (TO-BE 더 합리적) | (메모리에 deprecation 기록) |
| bEnable[] | hotkeyConfig.{xxx}: false (숨김) | OK | `_tobe/09_subtitle_hotkey.md` |
| SetDivisionAuthCheck | TO-BE BE Division dropdown filter (SCM_ADM_USER_GR_UNIT_AUTH_MPG_M) | OK | `_tobe/11_be_controller_service.md` |
| MessageHelper.GMessageBox(MSG_ID) | setAlert / setConfirm (`@shared/hooks`) + i18n | OK | `_tobe/14_error_handling.md` (Phase 4 신규) |
| MessageHelper.GetTerm(label) | t(labelId) (i18next) | OK | `_tobe/05_constants.md` |
| dsSearchCondition (사용자별 저장) — F6/F10 entry | **G1 useSearchConditionPersistence (신규)** | **G1 신규 구현** | (위 G1) |
| AddSheet(fps, name, table, row, col) | `<DataGrid sheetName={SHEETS.X} />` | OK | `_tobe/07_datagrid.md` |
| FpSpread_CellClick / KeyDown / SubEditorOpening | wijmo cellEditEnded / dblClick / click | OK | `_tobe/07_datagrid.md` |
| IsChange | useEffect ([data]) + EditTracker | OK | `_tobe/04_store.md` |
| LockColumn / LockRange | column meta `_inputEditType: 'O'/'M'` | OK | `_tobe/08_column_meta.md` |
| SetBGColor / SetBGColor2 | `.wj-cell-editable / .wj-cell-non-editable` CSS (자동) | OK | `_tobe/07_datagrid.md` |
| SetValue Auto-Sync | wijmo cellEditEnded handler + editTrackerRef.storeChange | OK | `_tobe/03_main_component.md` |
| SmartColMerge | HierarchicalMergeManager 또는 mergedRanges | OK | `_tobe/07_datagrid.md` §11.6 |
| BaseForm_AutoFilteredColumn dtFilterCol2/Val2 | (TO-BE FlexGridFilter 자동, 사용자 저장 미구현) | **격차 (G1 의 일부): 필터 상태 사용자별 저장도 G1 에 포함 검토** | `_tobe/06_search_area.md` §G1 |
| SCM_SYS_LOG_BATCH | @SystemLog annotation + Logback MDC | OK | `_tobe/16_logging.md` (Phase 4 신규) |
| SetSaveLog (UP_FX_SaveMenuExecutionLog) | (TO-BE 미구현 / access log filter 로 대체 가능) | **격차 (G3 의 일부): 화면 실행 로그도 G3 에 포함 검토** | (위 G3) |
| **FP_Log2 "SpeedUp"** | **G3 @PerfLog annotation + usePerfTrace (신규)** | **G3 신규 구현** | `_tobe/11_be_controller_service.md` §G3 |
| openSubMenu(prgId, msc) | MDI 탭 useNavigate + searchParams | OK | `_tobe/13_routing_menu.md` |
| ManualSearchCondition (다른 화면에서 전달) | useNavigate state 또는 searchParams (route) | OK | `_tobe/13_routing_menu.md` |
| FormClosing IsChange MSG00013 | useEffect ([data]) + window.beforeunload 또는 navigate confirm | OK | `_tobe/14_error_handling.md` |
| FormClosed SaveMenuConnect (메뉴 close 로그) | (TO-BE @SystemLog annotation 으로 통합 가능) | G3 의 일부로 흡수 | (위 G3) |
| CommonExecuteQuery2 (page, batchId, dict) | useTabProcQuery + 메타 (SCM_ADM_API_M + SCM_ADM_PROC_M) | OK | `_tobe/12_metadata_sql.md` |
| FP_ExecuteQuery2 wrapper | (TO-BE 는 FP 분리 없음) | OK | (없음) |
| FP_RunProcedure2 (async SP) | useProcMutation 또는 apiClient.post | OK | `_tobe/03_main_component.md` |
| **CommonPseudoBatch2 (배치)** | **G4 useBatchMutation + batch controller (신규)** | **G4 신규 구현** | `_tobe/03_main_component.md` §G4 |
| **GetDMInnerTable BigFilter 캐싱** | **G2 useBigFilterDM + BigFilterDm controller (신규)** | **G2 신규 구현** | `_tobe/06_search_area.md` §G2 |
| useTabComboQueries (lookup 마다 별도 호출) | (DM 도메인은 G2 우선, 다른 lookup 은 그대로) | OK | `_tobe/06_search_area.md` |
| GetSpdTitle (사용자별 컬럼 setting) | ColumnSettingModal (master/components) | OK | `_tobe/10_popup_modal.md` |
| LtTool IN clause split | string "," 그대로 + BE UF_FX_STRING_SPLIT | OK | `_tobe/03_main_component.md` |
| FilterDataSet["_SAVE_AUTH"] = "Y" | BE 가 메뉴/버튼 권한으로 자동 결정 | OK | `_tobe/11_be_controller_service.md` |
| EncryptUserID + USER_ID 자동 주입 | JWT session 에서 BE 가 자동 주입 | OK | `_tobe/11_be_controller_service.md` |
| **FP_DataPull / FP_DataPush / FP_FileDataClient** | **G5 FileController + FileUploader/FileDownloader (신규)** | **G5 신규 구현** | `_tobe/11_be_controller_service.md` §G5 |

---

## §10 Cascade DataModel.Changed 격차 — Phase 7 후속 (2026-06-04)

> 4 reference 화면 (DMF0004~7) + DMF0008 의 AS-IS cascade handler 정밀 추출 + TO-BE cellEditEnded / modal callback 매핑.
>
> 상세: `_asis/02_screens/{DMF0004~8}/cascade-mapping.md`

### §10.1 5 화면 종합 cascade handler

| 화면 | AS-IS handler 수 | AS-IS branch 수 | TO-BE 구현 위치 | 격차 |
|---|---:|---:|---|---:|
| DMF0004 SalesSite | 3 (Main + SubCustomer + SubBucket) | 9 | 4 grid + 3 modal callback (Region/Customer/Storage) — modal 패턴 표준 | 6 |
| DMF0005 SalesSiteProjectModel | 2 (Main + Sub) | 4 | Form + Grid + PurchaseGrid + 7 modal callback | 4 |
| DMF0006 CustomerModelMapping | 1 (Dsdm_Changed) | 1 | Grid + 2 modal callback (Project/Item) | 1 |
| DMF0007 CustomerFcstMaster | 3 (FCST + PSI + ComboSel) | 7 | 2 grid + handleActiveChange (VALID_YN cascade — §2.10.3 reference) | 7 |
| DMF0008 ErpEdiMaster | 3 (Summary + Sub + spdSub) | 7 | 4 grid 모두 read-only — cascade 0 구현 | 7 |
| **합계** | **12** | **28** | (다양) | **25** |

### §10.2 룰 07 §2.10 7 sub-pattern 의 reference

| sub-pattern | reference 1 (원천) | reference 2 (확장) | reference 3 (확장) |
|---|---|---|---|
| §2.10.1 auto-derive | DMF0008 SalesSite (a) | DMF0004 Main (a) — TO-BE 구현 ⭐ | DMF0005 Main (b) — 계산 변형 |
| §2.10.2 duplicate-check | DMF0008 SalesSite (b) | DMF0007 FCST/PSI (3 위치) | DMF0004 (5 위치) |
| §2.10.3 cascade-clear | DMF0008 SalesSite (c)(d) | DMF0007 FCST/PSI handleActiveChange — TO-BE 구현 ⭐ | DMF0004 setRegion (modal callback 변형) |
| §2.10.4 staging | DMF0008 SSPM dtSubBucket | DMF0004 SubBucket | (EditTracker 자동) |
| §2.10.5 combo cascade | DMF0008 SSPM | DMF0007 ComboSelChange (2-level) | — |
| §2.10.6 modal callback | DMF0004 setRegion/setCustomers/setSloc | DMF0005 7 modal callback | DMF0006 2 modal callback |
| §2.10.7 다중 row propagate | DMF0005 VMI_LT (Division 분기) | — | — |

→ 7 sub-pattern 모두 2+ reference 보유 (anti-simplification 의 다중 패턴 cross-check 충족).

### §10.3 격차 25 건 — 사용자 결정 후보

> 현재 모두 TO-BE 미구현 — 의도된 부분 구현 또는 향후 보강 후보.
> 사용자 작업물 우선 (메타-룰 #4) — 변경 X.

| 화면 | 격차 # | 우선순위 |
|---|---:|---|
| DMF0004 | 6 (Main SiteId 중복 / Attribute5+VMI_YN / SubCustomer RepYn single Y / SubCustomer SoldTo+ShipTo 중복 / SubBucket 2종) | 中 |
| DMF0005 | 4 (LIABILITY_PERIOD validation 2 + 계산 / VMI_LT propagate) | 中 |
| DMF0006 | 1 (CONVERT_QTY 음수 → 0) | 低 |
| DMF0007 | 7 (Measure CUST_FCST 차단 / 5-key 중복 ×2 / 8 필수 입력 / D_ Y 중복 / DeptId combo cascade / CustomerCode cascade) | 高 (FCST master 핵심) |
| DMF0008 | 7+ (cascade 전체) | 中 (read-only 화면 — 편집 가능 전환 시) |

---

## §9 변경 이력

- 2026-06-03 — 초안 작성 (Phase 1 BaseForm + DataService 분석 결과 반영)
- 2026-06-03 — 5 격차 (G1~G5) 모두 TO-BE 신규 구현 결정 (사용자) — 사양 명세화
- 2026-06-03 — Phase 1 완료. 추가 5 격차 (G6~G10) 발견. G6/G9/G10 신규 구현 결정, G7/G8 격차 유지 (사용자) — 사양 명세화. 총 격차 10건 / 신규 구현 8건.
- 2026-06-04 — Phase 7 후속. DMF0004~7 + DMF0008 cascade cross-check 완료. 룰 07 §2.10 7 sub-pattern 모두 2+ reference 확보. cascade 격차 25 건 추가 발견 (향후 보강 후보).

---

> **다음 단계**: A2 (G6 AlertModal UI) + A3 (G3 BE AOP) + A1 (G5 File transfer) + Phase 6 PoC PASS 후 룰셋 v2 → `_dev_rules/` rename.
