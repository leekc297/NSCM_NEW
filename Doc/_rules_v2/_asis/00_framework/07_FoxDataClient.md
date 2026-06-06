# AS-IS Framework — FoxDataClient / FoxBizClient (TheOne lib) 정밀 분석

> **source**:
> - `Windows.Forms/Service/PseudoFoxClient.cs` (592 lines) — wrapper / extension
> - `TheOne.ServiceModel.Data.FoxDataClient` (external lib, source 없음)
> - `TheOne.ServiceModel.Biz.FoxBizClient` (external lib, source 없음)
>
> **중요성**: BaseForm + DataService 의 모든 SP 호출이 결국 FoxDataClient/FoxBizClient (WCF SOAP) 로 라우팅. TO-BE 는 REST (Spring Boot Controller + axios) 로 전환.

---

## §0 메타

| 항목 | 값 |
|---|---|
| Source | PseudoFoxClient.cs (wrapper) + TheOne lib (external) |
| Lines | 592 (wrapper) + ? (external) |
| 추상 모델 | WCF SOAP RPC (.svc endpoint) |
| 진행도 | wrapper 핵심 method 추출 100% / external lib skeleton (source 없음) |

---

## §1 클래스 계층

```
[TheOne ServiceModel layer (외부 lib)]
  TheOne.ServiceModel.Data.FoxDataClient (IFoxDataClient)
    ├─ Execute(FoxDataRequest) → FoxDataResponse
    ├─ ExecuteDataSet(FoxDataRequest) → FoxDataResponse  (DataSet 포함)
    ├─ ExecuteNonQuery(FoxDataRequest) → FoxDataResponse
    ├─ ExecuteMultiple(FoxDataRequestCollection) → FoxDataResponseCollection
    └─ ExecuteParallel(IList<FoxDataRequest>) → IList<FoxDataResponse>
  
  TheOne.ServiceModel.Biz.FoxBizClient (IFoxBizClient)
    └─ Execute(FoxBizRequest) → FoxBizResponse

[NSCM wrapper layer]
  GSCM.Windows.Forms.Service.PseudoFoxClient (Wrapper)
    ├─ Execute (TheOne 호출 + "PseudoDataClient" biz request 추가)
    ├─ ExecuteDataSet (queryId 기반)
    ├─ ExecuteDataSet (request 기반)
    └─ SaveDataTable
  
  FoxDataClientExtensionTmp (static extension)
    └─ ExecuteDataSet(this FoxDataClient, FoxDataRequest pseudo_request)
       → 내부적으로 새 TheOne.FoxDataRequest 생성 후 호출
```

---

## §2 호출 패턴 (도메인 화면 → BaseForm/DataService → FoxClient → WCF endpoint)

### §2.1 동기 호출 (FoxBizClient)

```csharp
// DataService.CommonExecuteQuery2 안의 패턴
using (var client = new FoxBizClient("GSCM", "GSCM.BizService.WSL/FoxBizService.svc")) {
    var request = new FoxBizRequest("AppService", "GeneralExecuteQuery");
    request.Parameters["pagePath"]  = "DM\\Common\\BigFilter";
    request.Parameters["batchId"]   = "list_line_dm";
    request.Parameters["dictParam"] = paramTable;
    request.Parameters["TimeOut"]   = 15 * 60;
    request.Parameters["user_id"]   = AESEncrypt(userId);
    request.Parameters["ipaddress"] = clientIp;
    
    var response = client.Execute(request);
    DataSet result = (DataSet)response.Result;
}
```

### §2.2 비동기 호출 (FoxDataClient + async)

```csharp
// 도메인 화면 (DMF0005 / DMF0020) SaveButton 안
using (var client = new FoxDataClient("GSCM", "GSCM.DM.Master.WSL/FoxDataService.svc")) {
    var request = new FoxDataRequest("DM.DMF0005_SAVE_PRODUCT_MODEL");
    request.Parameters["p_division_id"] = divId;
    request.Parameters["p_data"] = saveDt;
    
    // async/await 패턴
    var response = await client.ExecuteDataSetAsync(request);
    DataSet result = response.DataSet;
}
```

### §2.3 endpoint 분류

| endpoint URL | 사용처 |
|---|---|
| `GSCM.BizService.WSL/FoxBizService.svc` | Common / Authentication / FP_Log (모든 도메인 공통) |
| `GSCM.BizService.WSL/FoxDataService.svc` | SCP / SCM_SYS_LOG_BATCH / SetSaveLog |
| `GSCM.DM.Master.WSL/FoxDataService.svc` | DM 도메인 (DMF0004~0099) |
| `GSCM.SCM.Master.WSL/FoxDataService.svc` | SCM 도메인 (lookup + 마스터) |
| `GSCM.FP.{Module}.WSL/FoxDataService.svc` | FP 도메인 |
| `GSCM.SCP.{Module}.WSL/FoxDataService.svc` | SCP 도메인 |
| `GSCM.SSP.Plan.WSL/FoxDataService.svc` | SSP 도메인 |

### §2.4 BizRequest action 분류

| action 이름 | 의미 |
|---|---|
| `GeneralExecuteQuery` | 일반 SQL 실행 (`pagePath` + `batchId` 로 SQL 찾기) |
| `GeneralRunProcedure` | Stored Procedure 호출 |
| `PseudoDataClient` | Pseudo batch (wrapper 가 사용) |
| `GeneralExecuteNonQuery` | INSERT / UPDATE / DELETE |
| `Authentication.GetSecurityACL` | 권한 ACL 조회 |
| `Authentication.SaveSearchCondition` | 검색조건 저장 (BaseForm F6) |
| `Authentication.ResetSearchCondition` | 검색조건 초기화 (BaseForm F10) |
| `Authentication.SaveMenuConnect` | 메뉴 open/close 로그 |
| `MenuContainer.UP_FX_GetSearchCondition` | 검색조건 복원 (BaseForm OnShown) |
| `MenuContainer.UP_FX_SaveMenuExecutionLog` | 화면 실행 로그 (SetSaveLog) |

---

## §3 PseudoFoxClient (Wrapper) 정밀

### §3.1 public method 5 종

| 라인 | 시그니처 | 책임 |
|---:|---|---|
| 44 | `FoxDataClient(addressName, serviceUri, bindingMapName=null)` | 생성자 — TheOne client 인스턴스 wrapping |
| 61 | `FoxDataResponse Execute(FoxDataRequest request, TimeOut=15*60)` | 일반 호출 (PseudoDataClient action) |
| 113 | `FoxDataResponse ExecuteDataSet(queryId, parameters=null, TimeOut)` | queryId 기반 단순 호출 |
| 235 | `FoxDataResponse ExecuteDataSet(FoxDataRequest request)` | request 기반 (overload) |
| 323 | `FoxDataResponse SaveDataTable(FoxDataRequest request)` | DataTable 저장 (INSERT/UPDATE/DELETE) |
| 53 | `void Dispose()` | IDisposable |

### §3.2 내부 호출 패턴

```csharp
public FoxDataResponse Execute(FoxDataRequest pseudo_request, int TimeOut = 15*60) {
    // 1. 새 TheOne BizRequest 생성 (action="PseudoDataClient")
    using (var client = new FoxBizClient("GSCM", biz_client)) {
        FoxBizRequest bizReq = new FoxBizRequest(biz_request, "PseudoDataClient");
        // 2. pseudo_request 의 parameters 를 bizReq 로 복사
        bizReq.Parameters["...".Add(pseudo_request.Parameters)
        // 3. TheOne FoxBizClient 호출
        var response = client.Execute(bizReq);
        // 4. response → FoxDataResponse 변환
        return ...;
    }
}
```

### §3.3 FoxDataClientExtensionTmp

```csharp
public static class FoxDataClientExtensionTmp {
    public static FoxDataResponse ExecuteDataSet(
        this TheOne.ServiceModel.Data.FoxDataClient classinstance, 
        FoxDataRequest pseudo_request) 
    {
        TheOne.ServiceModel.Data.FoxDataRequest request = new(
            // pseudo_request 의 인자를 TheOne request 로 변환
        );
        return classinstance.ExecuteDataSet(request);
    }
}
```

→ TheOne FoxDataClient 의 ExecuteDataSet 을 NSCM 의 `FoxDataRequest` 형식으로 호출 가능하게 하는 extension.

---

## §4 TO-BE 매핑 (WCF SOAP → REST)

### §4.1 추상 매핑

| AS-IS (WCF) | TO-BE (REST) |
|---|---|
| `FoxBizClient("GSCM", "X.svc")` | `apiClient` (axios instance, baseURL=BE) |
| `FoxBizRequest("Action", "Method")` | HTTP path: `POST /api/{module}/{action}` |
| `request.Parameters["X"] = Y` | RequestBody JSON: `{ X: Y }` |
| `response = client.Execute(request)` | `await apiClient.post(path, body)` |
| `response.Result` (DataSet) | response JSON `{ o_rc1: [...], o_rc2: [...] }` |
| `client.ExecuteDataSetAsync` | `await apiClient.post` (자동 async) |
| `client.ExecuteNonQuery` | `await apiClient.put/delete` |
| `client.ExecuteMultiple` | `Promise.all([apiClient.post, ...])` |
| `client.ExecuteParallel` | 동일 `Promise.all` |
| WCF `serviceUri` (`.svc` endpoint) | Spring Boot `@RestController` 의 `@RequestMapping` |
| `ipaddress`, `user_id` 자동 주입 | Spring `HttpServletRequest` + `@LoginUser` |
| AES 암호화 USER_ID | JWT session (BE 자동 인증) |
| WCF Fault → `FaultException` | HTTP error code + RFC 7807 (`@ExceptionHandler` + `setAlert`) |
| WCF `TimeOut=15*60` (15 분) | axios timeout (env `.env.local` `VITE_API_TIMEOUT=600000` = 10 분) |
| Connection pool (WCF Binding) | HikariCP (Spring Boot config-local.yml `maxPoolSize=30`) |

### §4.2 endpoint 매핑

| AS-IS endpoint + action | TO-BE endpoint |
|---|---|
| `GSCM.BizService.WSL/FoxBizService.svc` + `GeneralExecuteQuery` | `POST /api/proc/{menuId}/{sheetName}/{tabId}` (useTabProcQuery) |
| 동일 + `GeneralRunProcedure` | `POST /api/mutation/{menuId}/{sheetName}/{tabId}` (useProcMutation) |
| 동일 + `Authentication.GetSecurityACL` | `GET /api/menu/{menuId}/permission` (이미 구현) |
| 동일 + `Authentication.SaveSearchCondition` | `POST /api/system/search-condition/{menuId}` (G1 신규) |
| 동일 + `Authentication.ResetSearchCondition` | `DELETE /api/system/search-condition/{menuId}` (G1 신규) |
| 동일 + `Authentication.SaveMenuConnect` | (G3 PerfLog 안에 통합) |
| 동일 + `MenuContainer.UP_FX_GetSearchCondition` | `GET /api/system/search-condition/{menuId}` (G1 신규) |
| 동일 + `MenuContainer.UP_FX_SaveMenuExecutionLog` | (G3 PerfLog 안에 통합) |
| `GSCM.SCM.Master.WSL/FoxDataService.svc` + `SCM.SCM_SYS_GET_SPREAD_TITLE` | `GET /api/master/sheet/title/{menuId}` (ColumnSettingModal) |

### §4.3 FoxDataResponse 구조 → TO-BE JSON 구조

```
AS-IS FoxDataResponse {
    Result: DataSet { Tables[0..N] }
    Success: bool
    Message: string
}
↓
TO-BE Response {
    code: '0',
    message: 'success',
    result: {
        o_rc1: [...],  // Table 0
        o_rc2: [...],  // Table 1
        o_message: '',
    }
}
```

→ FE 의 `useTabProcQuery` 가 `result` 만 자동 unwrap.

### §4.4 비동기 처리

```csharp
// AS-IS
using (var client = new FoxDataClient(...)) {
    var request = new FoxDataRequest("SP.NAME");
    request.Parameters["X"] = Y;
    var response = await client.ExecuteDataSetAsync(request);  // async
    return response.DataSet;
}

// TO-BE
const { mutate } = useProcMutation<MENU_ID, SHEETS.X>({ menuId, sheetName, tabId });
mutate(params, { onSuccess: (data) => { ... } });
```

→ TO-BE 는 react-query 의 `useMutation` 이 자동 async + cache invalidation.

---

## §5 격차 / 보존 사항

### §5.1 OK (자연스러운 매핑)

- WCF SOAP → REST (모든 호출 자동 변환)
- TimeOut → axios timeout
- Connection pool → HikariCP
- async → await + react-query

### §5.2 격차 (위 G1~G5 안에 통합)

- 검색조건 저장/복원 (Auth.Save/Reset/GetSearchCondition) → **G1 신규 구현**
- 메뉴 open/close 로그 (Auth.SaveMenuConnect) → **G3 신규 구현 (PerfLog 통합)**
- 화면 실행 로그 (UP_FX_SaveMenuExecutionLog) → **G3 신규 구현 (PerfLog 통합)**

### §5.3 보존 (TO-BE 가 더 합리적)

- 권한 ACL (Authentication.GetSecurityACL) → 메뉴/버튼 권한 2 테이블 (이미 구현)
- USER_ID AES 암호화 → JWT (이미 구현)
- WCF Fault → HTTP error code + RFC 7807 (이미 구현)

---

## §6 룰셋 v2 반영

- `_tobe/03_main_component.md` §1 `useTabProcQuery` / `useProcMutation` 표준
- `_tobe/11_be_controller_service.md` §1 RestController + `@LoginUser` 자동
- `_tobe/14_error_handling.md` §1 axios error → setAlert + RFC 7807 매핑 (Phase 4)

---

## §7 진행 / 추가 분석

- ✅ PseudoFoxClient (wrapper) 5 method 인벤토리
- ✅ WCF endpoint + action 매핑 표 (10+ action)
- ✅ TO-BE REST 매핑 (1:1 자동 변환)
- ⏳ Pending: TheOne lib 의 FoxDataRequest / FoxDataResponse 구조 (source 없음 — TO-BE 이관 시 의미 추정)
- ⏳ Pending: FoxAsyncProxy (BaseForm.SetSaveLog 에서 사용) 패턴
- ⏳ Pending: 도메인 화면의 async/await 사용 패턴 정밀 (DMF0005/0020 의 SaveData_DataService 비동기 호출)

---

## §8 Phase 1 종합 정리

> Framework 정밀 분석 7 파일 모두 완료.

| # | 파일 | lines | 진행도 | 격차 발견 |
|---|---|---:|---|---|
| 01 | `BaseForm.md` | 6,329 | 핵심 100% | G1 (검색조건), G3 부분 |
| 02 | `DataService.md` | 5,261 | 핵심 100% | G2 (BigFilter), G3 부분, G4 (Batch), G5 (File) |
| 03 | `MessageHelper.md` | 405 | 100% | G6 (YesNoCancel) |
| 04 | `Logging.md` | (cross-ref) | 100% | G3 통합 |
| 05 | `Auth_FormAuth.md` | (cross-ref + UserInfoContext 201 + GAppSettings 100) | 100% | G7 (impersonation, 격차 유지), 보안 의무 (AES/DB 비번) |
| 06 | `UsrControls.md` | 36 컨트롤 (UsrCombo 583 + UsrCheckedList 1367 + UsrCheckBox 343 + UsrConditionPanel 45) | 핵심 4 100% / 32 인벤토리 | G8 (multi-col), G9 (DateRangePicker), G10 (MonthPicker) |
| 07 | `FoxDataClient.md` | PseudoFoxClient 592 + TheOne (external) | wrapper 100% / external skeleton | (없음 - REST 매핑 자연스러움) |

### Phase 1 격차 총 10건

| # | 격차 | 결정 | 우선순위 |
|---|---|---|---|
| G1 | 검색조건 저장/복원 | ✅ 신규 구현 | High |
| G2 | BigFilter 캐싱 | ✅ 신규 구현 | High |
| G3 | PerfLog (성능 + 메뉴 open/close + 화면 실행) | ✅ 신규 구현 | Medium |
| G4 | Batch 처리 | ✅ 신규 구현 | Medium |
| G5 | File transfer | ✅ 신규 구현 | Low |
| G6 | YesNoCancel confirm 3옵션 | ⏳ 사용자 결정 (auto default: 신규 구현 권장) | Low |
| G7 | Impersonation (admin 대리 작업) | (a) 격차 유지 (auto default) | (없음) |
| G8 | UsrColumnCombo (multi-column dropdown) | (a) 격차 유지 (auto default) | (없음) |
| G9 | DateRangePicker | ⏳ 사용자 결정 (auto default: 신규 구현 권장) | Low |
| G10 | MonthPicker | ⏳ 사용자 결정 (사용 빈도 확인) | Low |

### 보안 의무 (TO-BE 이관 시)

- AS-IS `GAppSettings.AESKey` / `AESVector` (hardcoded) — 절대 이관 금지
- AS-IS `GAppSettings.saveSCPPath_dev` / `_prd` (DB 계정 hardcoded) — 절대 이관 금지
- TO-BE: Jasypt + Vault / 환경변수 / `.gitignore` 강화 (룰 28)
