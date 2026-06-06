# AS-IS Framework — `DataService` 정밀 분석

> **source**: `C:\Projects\NSCM\GSCM\01.Framework\GSCM.Windows.Forms\Service\DataService.cs` (5,261 lines)
>
> **클래스**: `public static class DataService` (모든 메서드 static)
>
> **중요성**: 모든 도메인 화면이 SP 호출 시 사용하는 단일 entry. `FP_ExecuteQuery2` / `CommonExecuteQuery2` / `GetDMInnerTable` 3 종이 DMF0004~7 의 모든 데이터 흐름의 시작점.

---

## §0 메타

| 항목 | 값 |
|---|---|
| Source | `Windows.Forms/Service/DataService.cs` |
| Lines | 5,261 |
| 클래스 | `public static class DataService` |
| Phase | Phase 1 |
| 진행도 | 핵심 7 method (FP_ExecuteQuery2 / CommonExecuteQuery2 / GetDMInnerTable / FP_Log2 / GetSpdTitle / FP_RunProcedure2 / CommonPseudoBatch2) deep-dive 완료 |
| Pending | QA* / SCM_* 전체 + Big Filter 의 모든 case (3000+ lines) |

---

## §1 메서드 분류 (87 public method)

### §1.1 SP 호출 4 시스템 × 3 변형 매트릭스

> 모든 SP 호출은 `(sql_define_page, batch_id, dictParam, ...)` 표준 시그니처. `*Pseudo*` = 배치, `*Execute*` = 단발, `*RunProcedure*` = stored proc.

| 시스템 | Pseudo Batch | Execute Query | Run Procedure | Update Batch | Execute NonQuery |
|---|---|---|---|---|---|
| **FP** (ForeignPlan) | `FP_PseudoBatch` (1744) / `FP_PseudoBatch2` (1700) | `FP_ExecuteQuery` (1772) / **`FP_ExecuteQuery2` (1779) ⭐** | `FP_RunProcedure` (1797) / `FP_RunProcedure2` (1803) / `FP_RunProcedure3` (1918) | `FP_UpdateBatch` (1679) / `FP_UpdateBatch2` (1634) | `FP_ExecuteNonQuery` (1765) |
| **Common** | `CommonPseudoBatch` (1186) / **`CommonPseudoBatch2` (1193) ⭐** / `CommonPseudoBatch3` (1269) | `CommonExecuteQuery` (1441) / **`CommonExecuteQuery2` (1448) ⭐** / `CommonExecuteQuery3` (1486) | `CommonRunProcedure` (1499) / `CommonRunProcedure2` (1505) / `CommonRunProcedure3` (1620) | `CommonUpdaetBatch` (1293) / `CommonUpdaetBatch2` (1300) / `CommonUpdaetBatch3` (1376) | `CommonExecuteNonQuery` (1389) / `CommonExecuteNonQuery4` (1408) |
| **SCM** | `SCM_PseudoBatch` (1986) / `SCM_PseudoBatch2` (1942) | `SCM_ExecuteQuery` (2016) / `SCM_ExecuteQuery2` (2023) | `SCM_RunProcedure` (2033) / `SCM_RunProcedureCustomTable` (2040) / `SCM_RunProcedure2` (2049) | (없음) | `SCM_ExecuteNonQuery` (2007) |
| **QA** | `QAPseudoBatch` (2327) / `QAPseudoBatch2` (2334) / `QAPseudoBatch3` (2409) | `QAExecuteQuery` (2581) / `QAExecuteQuery2` (2588) / `QAExecuteQuery3` (2621) | `QARunProcedure` (2634) / `QARunProcedure2` (2640) / `QARunProcedure3` (2755) | `QAUpdateBatch` (2433) / `QAUpdaetBatch2` (2440) / `QAUpdaetBatch3` (2516) | `QAExecuteNonQuery` (2529) / `QAExecuteNonQuery4` (2548) |

> **⭐ = 가장 자주 호출되는 패턴 (DMF0004~7 + 대부분 도메인 화면)**.
>
> 시스템 차이는 SP 가 어느 WSL endpoint 에 등록되었는가:
> - FP_* → `FP/{part_service}/{sql_define_page}` 경로
> - Common* → `GSCM.BizService.WSL/FoxBizService.svc` (default)
> - SCM_* → `GSCM.SCM.Master.WSL/FoxDataService.svc`
> - QA* → QA 환경 별도 endpoint

### §1.2 Big Filter / Lookup (10)

| 라인 | 메서드 | 책임 |
|---:|---|---|
| 2884 | `InitBigFilterAll()` | 모든 BigFilter 캐시 초기화 |
| 2897 | `SetBigFilterClean()` | clean flag set |
| 2902 | `InitBigFilter()` (private) | 일반 BigFilter init |
| 2921 | `GetInnerTable(result_columname, BigFilter)` | 일반 도메인 lookup |
| 3423 | `GetTopItemId(BigFilter)` | top-level Item lookup |
| 3485/3492 | `GetNicknameId(BigFilter, Refresh)` | Nickname master lookup |
| 3568 | `GetProdType(BigFilter)` | Product Type lookup |
| 3630 | `InitBigFilterDM()` | DM 도메인 BigFilter init |
| 3644 | `GetMyDivision(BigFilter)` | Division 권한 list |
| 3682 | **`GetDMInnerTable(result_columname, BigFilter)` ⭐⭐** | **DM 도메인 lookup super function** (switch by result_columname) |
| 4144 | `InitBigFilterSSP()` | SSP 도메인 BigFilter init |
| 4176 | `GetSSPInnerTable(result_columname, BigFilter)` | SSP 도메인 lookup |

### §1.3 Log / Audit (4)

| 라인 | 메서드 | 책임 |
|---:|---|---|
| 806 | `FP_Log(logtype, params...)` | `FP_ExecuteQuery("Utility", "note", ...)` — 일반 로그 |
| 829 | **`FP_Log2(logtype, params...)` ⭐** | `FP_ExecuteQuery("Utility", "note2", ...)` — 성능 추적 로그 (사용 빈도 높음) |
| 2808 | `LogDataSet(dt, fileName)` | DataSet JSON 변환 후 FP_Log + 파일 저장 |
| 2820/2840 | `FP_TableLog(dt/ds, User, UI)` | 디버그용 |

### §1.4 Filter / Parameter helper (10+)

| 라인 | 메서드 | 책임 |
|---:|---|---|
| 851 | `NullTool(filter, ctrl_header, table_part, variable, and=true)` | Null 처리 (JS 의 `AND COL = @VAL` 패턴 — VAL=null 시 TRUE) |
| 876 | `LkTool(filter, ctrl_header, variable, lt_head, equal_head)` | Lookup tool |
| 913 | **`LtTool(filter, ctrl_header, variable, lt_head, equal_head)` ⭐** | List tool (IN clause split) |
| 602 | `ParamDictionaryToTable(dictParam, AttachPrefix)` | Dict → DataTable 변환 |
| 619 | `EncryptUserID(dictParam)` | USER_ID AES 암호화 |
| 738/762/789 | `FillUserID / UnFillUserID` | DataTable 의 USER_ID 자동 채움 |
| 640 | `ReadResult(oResult)` | SP 응답 파싱 |
| 715/724 | `CreateCodeTable / CreateCodeDataSet` | CODE/NAME 컬럼 빈 테이블 |
| 950/992 | `CopyData(src, dt)` | DataTable 복사 (2 overloads) |
| 1029 | `applyEntity(source)` | HTML entity 변환 |
| 1040/1094/1122 | `ToLoopParam(param_type, pack, delim, sub, kv)` | MeasurePack/DataTable/DataSet → "!,#,:" 구분 string (loop param) |
| 1131/1143 | `CreateResultDataSet / CreateResultDataTable(Success, Count, Msg)` | 표준 응답 객체 |

### §1.5 File transfer (4)

| 라인 | 메서드 | 책임 |
|---:|---|---|
| 141 | `FP_FileDataClient(base_path, option, dict, ws_path, TimeOut)` | 파일 데이터 클라이언트 |
| 147 | `FP_DataPull(local_base, server_base, file_path, dict, ...)` | 서버 → 로컬 파일 |
| 153 | `FP_DataPush(base, domain, file, overwrite, dict, ...)` | 로컬 → 서버 파일 |
| 159 | `FP_DataPushFile(local, server_short, server_domain, server_path, overwrite, dict, ...)` | 단일 파일 push |
| 206 | `StripPath(full, pre_base, last)` | 경로 파싱 helper |

### §1.6 Dynamic Column / Spread Title

| 라인 | 메서드 | 책임 |
|---:|---|---|
| 2776 | **`GetSpdTitle(programID, userID, sheetName)` ⭐** | `SCM.SCM_SYS_GET_SPREAD_TITLE` SP 호출 — **사용자별 column setting (column 순서/visible/width)** |

> ⚠️ **중요**: 모든 화면이 InitSpread 직후 `GetSpdTitle` 호출 후 결과를 `CreateSheetHeaderColumn` 에 전달. **TO-BE 의 `ColumnSettingModal` 과 동등 메커니즘**.

---

## §2 핵심 method body 정밀 분석

### §2.1 `CommonExecuteQuery2` (1448-1484) ⭐ — Common 표준 SP 호출

```csharp
public static DataSet CommonExecuteQuery2(
    string _sql_define_page,      // 예: "DM\Common\BigFilter"
    string sql_item_id,           // 예: "list_line_dm"
    Dictionary<string, object> _dictParam,
    string service_path = "",     // 미사용
    int TimeOut = 15 * 60)        // 15분
{
    // 1. USER_ID 자동 주입
    if (_dictParam.Count == 0) {
        _dictParam.Add("USER_ID", UserInfoContext.Current?.UserId ?? "");
    }
    
    // 2. USER_ID AES 암호화
    Dictionary<string, object> dictParam = EncryptUserID(_dictParam);
    DataTable paramTable = ParamDictionaryToTable(dictParam);

    // 3. FoxBizClient 로 호출
    using (var client = new FoxBizClient("GSCM", "GSCM.BizService.WSL/FoxBizService.svc")) {
        var request = new FoxBizRequest("AppService", "GeneralExecuteQuery");
        request.Parameters["pagePath"] = _sql_define_page;
        request.Parameters["batchId"]  = sql_item_id;
        request.Parameters["dictParam"] = paramTable;
        request.Parameters["TimeOut"]  = TimeOut;
        request.Parameters["user_id"]  = AESEncrypt128ForDB(UserService.GetUserID());
        request.Parameters["ipaddress"] = UserService.GetIP();
        
        var response = client.Execute(request);
        return (DataSet)response.Result;
    }
}
```

**TO-BE 매핑**:
- `pagePath` (sql_define_page) + `batchId` (sql_item_id) → TO-BE 는 별도 등록 없이 직접 SP 명만 사용
- USER_ID AES 암호화 → TO-BE 는 session JWT 가 BE 에서 user_id 자동 주입
- `ipaddress` → TO-BE 는 `X-Forwarded-For` header
- `TimeOut = 15 분` → TO-BE 는 BE config (`config-local.yml maxPoolSize=30` 등)

### §2.2 `FP_ExecuteQuery2` (1779-1787) — FP wrapper

```csharp
public static DataTable FP_ExecuteQuery2(
    string sql_define_page, string batch_id, Dictionary<string, object> dictParam,
    string part_service = "Common", int TimeOut = 15*60)
{
    DataSet set = FP_ExecuteQuery(sql_define_page, batch_id, dictParam, part_service, TimeOut);
    return set?.Tables?[0];  // Tables[0] 만 반환 (DataTable)
}
```

→ **단순 wrapper**: DataSet 의 첫 테이블만 반환. SP 가 단일 result set 일 때 사용.

### §2.3 `FP_Log2` (829-850) — 성능 추적 로그

```csharp
public static DataSet FP_Log2(string logtype, params object[] list)
{
    FilterDataSet note = new FilterDataSet();
    string note_text = "";
    for (int i = 0; i < list.Length; i++)
        note_text += (list[i]?.ToString() ?? "") + "\r\n";
    
    note["LOGTYPE"] = logtype;
    note["NOTE"]    = note_text;
    note["USER_ID"] = UserInfoContext.Current?.UserId ?? "Invalid User";
    
    return FP_ExecuteQuery("Utility", "note2", note.Dictionary);
}
```

**사용 패턴** (DMF0004 / DMF0008 / DMF0020 에서):
```csharp
DataService.FP_Log2("SpeedUp", "DMF0004", "division_id_changed", "start");
// ... heavy work ...
DataService.FP_Log2("SpeedUp", "DMF0004", "division_id_changed", "end");
```
→ `LOGTYPE="SpeedUp"`, `NOTE="DMF0004\r\ndivision_id_changed\r\nstart\r\n"` 로 SP "Utility/note2" 호출.

**TO-BE 매핑**: 현재 TO-BE 미구현 (성능 추적 격차). 필요 시 OpenTelemetry 또는 별도 trace SP.

### §2.4 `GetDMInnerTable` (3682-4143) ⭐⭐ — DM 도메인 lookup super function

> **3682-4143 = 약 460 lines, ~30+ case branch**.

```csharp
public static DataTable GetDMInnerTable(string result_columname, FilterDataSet BigFilter)
{
    // 1. BigFilter 캐시 dirty 체크
    if (bBigFilterClean) InitBigFilterAll();

    // 2. 첫 호출 시 모든 DM lookup 을 1번에 가져오기 (캐시)
    if (!dtMyDivision.Good()) {
        dsAllDM = GService.CommonExecuteQuery2(@"DM\Common\BigFilter", "list_line_dm", BigFilter.Dictionary);
        // dsAllDM.Tables[0~N] = MyDivision, Team, EndCustomer, SalesSite, ... 다수
    }

    // 3. "ALL" 처리
    if (BigFilter["DIVISION_ID"] == "ALL") BigFilter["DIVISION_ID"] = "";
    if (BigFilter["DEPT_ID"] == "ALL")     BigFilter["DEPT_ID"]     = "";
    if (BigFilter["END_CUSTOMER"] == "ALL") BigFilter["END_CUSTOMER"] = "";

    // 4. result_columname 기반 in-memory filter
    switch (result_columname) {
        case "MyDivision":
            // dsAllDM.Tables[0] 에서 CODE/NAME 추출, groupBy CODE, OrderBy CODE
            return ...;
        case "UserTeamByDivision":
            // dsAllDM.Tables[1] 에서 BigFilter["DIVISION_ID"] 로 filter
            return ...;
        // case "EndCustomerByDivision":
        // case "UserSiteByEndCustomer":
        // case "ScmSitebyEndCustomer40":
        // case "BizType":
        // case "UserPlantSiteByDivision":
        // ... 30+ case
    }
}
```

**중요 특성**:
1. **단일 SP 호출 → in-memory filter**: 한 번에 모든 DM lookup 을 캐시한 후 BigFilter 의 조건으로 client 측 필터링
2. 결과 컬럼은 항상 `CODE / NAME` 표준화
3. `"ALL"` 은 `""` (빈 string) 로 변환
4. `CommaToList(BigFilter["DIVISION_ID"])` 패턴으로 multi-value 분기

**TO-BE 매핑 (격차)**:
- TO-BE 는 `SCM_ADM_CMBO_SQL_M` 의 SQL_ID 마다 별도 SP 호출 (`UserTeamByDivision`, `EndCustomerByDivisionDept`, ...)
- 각 호출이 별도 round-trip → DM lookup 5 개 = 5 round-trip
- AS-IS 의 BigFilter 패턴은 1 round-trip
- **격차 해소 옵션**:
  - (a) TO-BE 도 `BigFilterCacheService` 같은 client 측 캐시 도입 (`@shared/hooks/useBigFilterDM`)
  - (b) BE 가 single endpoint 로 multi-lookup 제공 (예: `/api/lookup/dm/batch?keys=...`)
- 현재 TO-BE 는 (a)/(b) 모두 미구현 → **성능 격차**

### §2.5 `GetSpdTitle` (2776-2805) ⭐ — 사용자별 컬럼 설정

```csharp
public static DataTable GetSpdTitle(string programID, string userID, string sheetName)
{
    using (var client = new FoxDataClient("GSCM", "GSCM.SCM.Master.WSL/FoxDataService.svc")) {
        var request = new FoxDataRequest("SCM.SCM_SYS_GET_SPREAD_TITLE");
        request.Parameters["p_program_id"] = programID;
        request.Parameters["p_user_id"]    = userID;
        request.Parameters["p_sheet_name"] = sheetName;
        var response = client.ExecuteDataSet(request);
        return response.DataSet.Tables[0];
    }
}
```

**호출 위치 (도메인 화면)**:
```csharp
// 모든 화면의 InitSpread 직후
DataTable dtTitle = DataService.GetSpdTitle(this.Name, UserInfoContext.Current.UserId, "Main");
CreateSheetHeaderColumn(siMain, 1, dtTitle);  // dtTitle 에 column 순서/visible/width 적용
```

**SP `SCM.SCM_SYS_GET_SPREAD_TITLE` 의 결과 컬럼**:
- COLUMN_NAME / COLUMN_LABEL (헤더 텍스트)
- COLUMN_WIDTH / VISIBLE / SORT_ORDER (column 위치/크기)
- (사용자별 저장: `SCM.DM0002_TitleSetForm_Popup` 으로 편집)

**TO-BE 매핑**: 이 SP 가 TO-BE 의 `ColumnSettingModal` (master/components) 의 BE 의 결과. 
- AS-IS `SCM.SCM_SYS_GET_SPREAD_TITLE` ↔ TO-BE `DMF0002_GET_TITLESET_POPUP`
- 컬럼 설정 저장/복원 = TO-BE 의 `ColumnSettingModal` 사용 (룰 23 §12.A)

### §2.6 `LtTool` (913) — List tool (IN clause split)

```csharp
public static void LtTool(FilterDataSet filter, string ctrl_header, string variable, string lt_head, string equal_head)
{
    // 예: clbDivision.ControlValues = "40,81"
    // → filter[variable] = "40,81" 일 때, SQL 에서 다음 패턴으로 사용:
    //   [{lt_head} SA.DIVISION_ID IN (UF_FX_STRING_SPLIT(@DIVISION_ID, ','))]
    //   [{equal_head} SA.DIVISION_ID = @DIVISION_ID]  (단일 값 시)
    //
    // 즉, `,` 가 포함되면 IN clause 활성, 아니면 = 활성
}
```

**중요 함의**: AS-IS multi-select dropdown (UsrCheckedList) 의 결과는 `","` 구분 string. SQL 에서 `UF_FX_STRING_SPLIT` 함수로 분해.

**TO-BE 매핑**: TO-BE 는 `string` join "," 으로 그대로 BE 에 전달. BE 는 `UF_FX_STRING_SPLIT` 또는 자체 split 사용.

---

## §3 SP 호출 표준 시그니처 (4 시스템 통합)

> 모든 SP 호출 메서드의 공통 시그니처 패턴.

```csharp
public static DataXxx XxxYyyZzz(
    string sql_define_page,    // 예: "DM\Master\DMF0004"
    string batch_id,           // 예: "select_main_data" 또는 SP 이름
    Dictionary<string, object> dictParam,  // 파라미터 dict
    string[] table_names = null,           // 결과 테이블 명 (선택, RunProcedure 만)
    string part_service = "Common",        // FP 변형: part_service
    int TimeOut = 15 * 60,                 // 15 분 default
    string AttachPrefix = "")              // dict key prefix
```

| 시스템 | sql_define_page 패턴 | endpoint |
|---|---|---|
| FP_* | `FP/{part_service}/{page}` | `GSCM.BizService.WSL/FoxBizService.svc` (FP 안 별도 routing) |
| Common* | `{page}` (자유) | `GSCM.BizService.WSL/FoxBizService.svc` |
| SCM_* | (절대 경로) | `GSCM.SCM.Master.WSL/FoxDataService.svc` |
| QA* | (QA 환경) | (QA endpoint) |

---

## §4 TO-BE 매핑 종합

| AS-IS 호출 | TO-BE 등가 | 격차 | 룰 위치 |
|---|---|---|---|
| `CommonExecuteQuery2(page, batchId, dict, t)` | `useTabProcQuery<MENU_ID>({menuId, sheetName, tabId, filters})` | SP 등록 메타 (SCM_ADM_API_M + SCM_ADM_PROC_M) | `_tobe/12_metadata_sql.md` |
| `FP_ExecuteQuery2(page, batchId, dict)` | (TO-BE 는 FP 분리 없음. Common 으로 통합) | - | 동일 |
| `FP_RunProcedure2(page, procName, dict, timeout)` | `useProcMutation` 또는 `apiClient.post(...)` | - | `_tobe/03_main_component.md` |
| `CommonPseudoBatch2(page, batchId, src, batchCount)` | (TO-BE 배치는 별도 endpoint — 현재 미사용) | **격차** | `_mapping/asis_to_tobe.md` |
| `GetDMInnerTable("MyDivision", filter)` | `useTabComboQueries({filters: ['MyDivision']})` | **격차**: TO-BE 는 lookup 마다 별도 round-trip | `_tobe/06_search_area.md` |
| `GetDMInnerTable("UserTeamByDivision", filter)` | `useTabComboQueries({filters: ['TeambyDivision']})` | naming 변경 / 별도 호출 | 동일 |
| `GetDMInnerTable("EndCustomerByDivision", filter)` | `useTabComboQueries({filters: ['EndCustomerByDivisionDept']})` | naming 변경 | 동일 |
| `GetSpdTitle(programID, userID, sheet)` | `ColumnSettingModal` (master/components) → BE `DMF0002_GET_TITLESET_POPUP` | OK (매핑 명확) | `_tobe/10_popup_modal.md` |
| `FP_Log2("SpeedUp", form, action, "start"/"end")` | (TO-BE 미구현) | **격차**: 성능 추적 | `_mapping/asis_to_tobe.md` |
| `LtTool(filter, ctrl, var, lt, equal)` IN clause split | TO-BE 는 string "," 그대로 전달 + BE `UF_FX_STRING_SPLIT` | OK | `_tobe/03_main_component.md` |
| `FilterDataSet["_SAVE_AUTH"] = "Y"` 권한 플래그 | TO-BE 는 BE 가 메뉴/버튼 권한으로 자동 결정 | OK (TO-BE 더 합리적) | `_tobe/11_be_controller_service.md` |
| `EncryptUserID` AES + USER_ID 자동 주입 | TO-BE 는 JWT session 에서 BE 가 자동 주입 | OK (TO-BE 더 합리적) | `_tobe/11_be_controller_service.md` |
| `ParamDictionaryToTable(dict, prefix)` Dict → DataTable | TO-BE 는 `Map<String,Object>` 그대로 JSON | OK | - |
| File transfer (`FP_DataPull / FP_DataPush`) | (TO-BE 별도 endpoint — 현재 미사용 / 격차) | **격차** | `_mapping/asis_to_tobe.md` |

---

## §5 격차 (TO-BE 미구현) 총괄

1. **사용자별 검색조건 저장/복원** (BaseForm §5 + 본 §4 의 F6/F10) — TO-BE 신규 구현 필요
2. **BigFilter 캐싱** (1 round-trip 으로 모든 DM lookup) — TO-BE 는 N 회 별도 호출 (성능 차이)
3. **`FP_Log2 "SpeedUp"` 성능 추적** — TO-BE 미구현 (OpenTelemetry 또는 별도 trace SP 신규)
4. **`CommonPseudoBatch2` 배치 처리** — TO-BE 는 단일 호출 위주 (대량 데이터 처리 시 격차)
5. **File transfer (`FP_DataPull / FP_DataPush`)** — TO-BE 는 별도 endpoint 신규 필요 (LCB 첨부파일 등)

격차 결정 의무: 사용자가 (a) 격차 유지 (b) 신규 구현 결정. Phase 4 룰셋 v2 작성 시 `_mapping/asis_to_tobe.md` 에 격차 표 추가.

---

## §6 도메인 화면 호출 패턴 (DMF0004 예)

> AS-IS DMF0004 의 데이터 흐름 — DataService 호출 인벤토리.

| 시점 | 호출 | 목적 |
|---|---|---|
| Form_Load | `GetDMInnerTable("MyDivision", filter)` | cboDivision 데이터 |
| cboDivision_SelChange | `GetDMInnerTable("UserTeamByDivision", filter)` | clbTeam refresh |
| cboDivision_SelChange | `GetDMInnerTable("EndCustomerByDivision", filter)` | clbEndCustomer refresh |
| cboDivision_SelChange | `GetDMInnerTable("UserSiteByEndCustomer", filter)` | clbSalesSite refresh |
| cboDivision_SelChange | `GetDMInnerTable("ScmSitebyEndCustomer40", filter)` | 별도 site lookup |
| cboDivision_SelChange | `FP_Log2("SpeedUp", "DMF0004", "division_id_changed", "start")` | 성능 trace |
| cboDivision_SelChange | `FP_Log2("SpeedUp", "DMF0004", "division_id_changed", "end")` | 성능 trace |
| InitSpread | `GetSpdTitle(this.Name, UserId, "Main")` | 동적 컬럼 헤더 |
| FindButton | `FoxDataClient.GetData2Async` → DM.DMF0004_GET_DATA | 메인 데이터 |
| SaveButton | `FoxDataClient.SaveData2Async` → DM.DMF0004_SAVE_DATA | 저장 |

→ **TO-BE 매핑** (sales-site/SalesSite.tsx):
| AS-IS | TO-BE |
|---|---|
| `GetDMInnerTable("MyDivision/...")` | `useTabComboQueries({filters: ['MyDivision','TeambyDivision','EndCustomer','SalesSite','YesOrNo']})` |
| `FP_Log2` performance | (없음) |
| `GetSpdTitle` | `staticColumns[RESPONSE_SET.SITE]` from `fetchStaticColumns` |
| `FoxDataClient.GetData2Async DM.DMF0004_GET_DATA` | `useTabProcQuery<MENU_ID, SHEETS.SITE>({menuId, sheetName: SHEETS.SITE, tabId, filters})` |
| `FoxDataClient.SaveData2Async DM.DMF0004_SAVE_DATA` | `useProcMutation<MENU_ID, SHEETS.SITE>({menuId, sheetName: SHEETS.SITE, tabId})` |

---

## §7 진행 / 보강 예정

- [ ] FP_PseudoBatch / CommonPseudoBatch 의 batch 처리 메커니즘 정밀 분석 (1186-1408)
- [ ] FP_RunProcedure2 의 `_innerFPRunProcedureCustomTable` (1811+) body — async 호출 패턴
- [ ] `GetDMInnerTable` 의 30+ case branch 전수 인벤토리 (3682-4143)
- [ ] `GetSSPInnerTable` 의 lookup 인벤토리 (4176-5261)
- [ ] `SCM_RunProcedureCustomTable` (2040) — DataTable parameter 패턴
- [ ] FileDataClient / DataPull / DataPush 의 동작 (141-200)

위 항목은 Phase 1 의 DataService 정밀 분석 v2 (다음 세션) 의 우선순위.
