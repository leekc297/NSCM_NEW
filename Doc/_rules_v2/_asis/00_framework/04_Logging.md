# AS-IS Framework — Logging / Audit 정밀 분석

> **source 분포**: BaseForm.cs (SCM_SYS_LOG_BATCH / SetSaveLog / SaveMenuConnect) + DataService.cs (FP_Log / FP_Log2 / LogDataSet / FP_TableLog).
>
> **이 문서**는 cross-reference 통합. 원본 정밀 분석은 `01_BaseForm.md` §9 + `02_DataService.md` §1.3 참조.

---

## §0 메타

| 항목 | 값 |
|---|---|
| Source | BaseForm.cs §9 + DataService.cs §1.3 |
| 진행도 | **100%** (BaseForm + DataService 에서 모두 추출) |
| AS-IS 로그 종류 | 4 종 (SCM_SYS_LOG_BATCH / SetSaveLog / FP_Log2 / SaveMenuConnect) |

---

## §1 AS-IS 로그 4 종 분류

| # | 메서드 | 위치 | 호출 빈도 | 로그 대상 SP / API | 격차 |
|---:|---|---|---|---|---|
| 1 | **SCM_SYS_LOG_BATCH** | BaseForm.cs:6112 | 화면 저장 종료 시 (도메인 화면 안 호출) | `SCP.PR_SCM_SYS_LOG_BATCH` | OK (TO-BE @SystemLog 매핑) |
| 2 | **SetSaveLog(logType)** | BaseForm.cs:5963 | (private — Find/Save 종료) | `MenuContainer.UP_FX_SaveMenuExecutionLog` | **격차** (TO-BE 미구현 — G3 흡수) |
| 3 | **FP_Log2(logtype, params)** | DataService.cs:829 | 화면 성능 추적 ("SpeedUp") | `Utility/note2` | **격차** (G3 신규 구현) |
| 4 | **SaveMenuConnect (메뉴 open/close 로그)** | BaseForm.cs:1010 | FormClosed event | `Authentication.SaveMenuConnect` (`CnntCode=0104001/0104002`) | **격차** (G3 흡수) |

또한 보조:
| # | 메서드 | 위치 | 용도 |
|---:|---|---|---|
| 5 | `FP_Log(logtype, params)` | DataService.cs:806 | 일반 로그 (`Utility/note`) — note2 의 구버전 |
| 6 | `LogDataSet(dt, fileName)` | DataService.cs:2808 | 디버그 — DataSet JSON 파일 + FP_Log |
| 7 | `FP_TableLog(dt/ds)` | DataService.cs:2820/2840 | 디버그 — DataTable 전체 로그 |

---

## §2 §1.1 — SCM_SYS_LOG_BATCH 정밀 (BaseForm:6112)

```csharp
protected void SCM_SYS_LOG_BATCH(
    String p_program_name,   // 프로그램명 / FormName
    String p_log_type,       // "PARAM" / "SQL" / "ERROR" / "ONE"
    int p_log_count,         // 처리 건수
    String p_log_message,    // 메시지
    String p_description)    // 상세설명
{
    using (var client = new FoxDataClient("GSCM", "GSCM.BizService.WSL/FoxDataService.svc")) {
        var request = new FoxDataRequest("SCP.PR_SCM_SYS_LOG_BATCH");
        request.Parameters["p_program_name"] = p_program_name;
        request.Parameters["p_log_type"]     = p_log_type;
        request.Parameters["p_log_count"]    = p_log_count;
        request.Parameters["p_log_message"]  = p_log_message;
        request.Parameters["p_description"]  = p_description;
        request.Parameters["p_event_date"]   = DateTime.Now;
        client.ExecuteDataSet(request);
    }
}
```

### §2.1 LOG_TYPE 4 종

| LOG_TYPE | 의미 | 호출 예 |
|---|---|---|
| `PARAM` | 파라미터 로그 (입력 검증) | `SCM_SYS_LOG_BATCH(form, "PARAM", paramCount, json, "input")` |
| `SQL` | SQL 실행 로그 (쿼리 + 결과) | 쿼리 4000 자 초과 시 자동 분할 |
| `ERROR` | 오류 로그 | exception 발생 시 |
| `ONE` | 통합 로그 (한 번에 종합) | save 종료 시 권장 |

### §2.2 DB 컬럼 (`SCM_SYS_LOG` 테이블, AS-IS)

| 컬럼 | 의미 |
|---|---|
| PROG_ID | 프로그램 / 화면 ID |
| QUERY_ID | SQL ID (SQL 로그 시) |
| JOB_TYPE | LOG_TYPE (PARAM/SQL/ERROR/ONE) |
| INSERT_ID | User ID |
| IP_ADDRESS | IP 자동 |
| SESSION_ID | 세션 자동 |
| COMMAND_TIMEOUT | timeout 값 |
| QUERY_SEQ | 순차 (SQL 4000 분할 시) |
| LOG_MESSAGE | 메시지 |
| DESCRIPTION | 상세 |
| EVENT_DATE | 시각 |

### §2.3 TO-BE 매핑

| AS-IS | TO-BE |
|---|---|
| `SCM_SYS_LOG_BATCH("ONE", count, msg, desc)` | `@SystemLog(logType=ONE)` annotation + AOP 자동 |
| `LOG_TYPE = SQL` (쿼리 자동) | MyBatis intercepter 자동 |
| `LOG_TYPE = ERROR` (예외 자동) | `@ExceptionLog` + GlobalExceptionHandler |
| `LOG_TYPE = PARAM` (입력 검증) | `@RequestLog` (선택) |
| IP/Session 자동 기록 | Spring Security `HttpServletRequest` |

TO-BE 의 `SCM_SYS_LOG` 테이블은 AS-IS 와 동일 컬럼 구조 유지 가능. `@SystemLog` 이미 구현 — 추가 작업 없음.

---

## §3 §1.2 — SetSaveLog (BaseForm:5963)

```csharp
private void SetSaveLog(string logType) {
    string p_menu_id = this.ViewModel.MenuId;
    string p_log_cnt = _UISearchCnt.Replace("Total : ", "").Replace(",", "");
    string p_db_time = _SearchSpanTime;
    string p_ui_time = _UIEndSpanTime;
    string p_user_id = UserInfoContext.Current["USER_ID"];
    
    FoxDataRequest("MenuContainer.UP_FX_SaveMenuExecutionLog")
        with { menu_id, log_type (FIND/SAVE), log_cnt, db_time, ui_time, user_id };
}
```

**logType 분류** (struct `logType` line 689):
- `FIND` — 조회 종료 시
- `SAVE` — 저장 종료 시

**호출 시점**: BaseForm 의 OnClickFindButton / OnClickSaveButton 의 finally 또는 종료 직후.

### §3.1 TO-BE 매핑

| AS-IS | TO-BE | 격차 |
|---|---|---|
| `UP_FX_SaveMenuExecutionLog(menu, type, cnt, dbTime, uiTime, user)` | 화면 실행 로그 + 성능 추적 (DB/UI 시간) | **G3 흡수**: `@PerfLog` annotation 안에 자동 기록 |

→ G3 (PerfLog) 신규 구현에 통합. 별도 endpoint 불필요.

---

## §4 §1.3 — FP_Log2 (DataService:829) — 성능 추적

```csharp
public static DataSet FP_Log2(string logtype, params object[] list)
{
    FilterDataSet note = new FilterDataSet();
    string note_text = "";
    for (int i = 0; i < list.Length; i++)
        note_text += (list[i]?.ToString() ?? "") + "\r\n";
    
    note["LOGTYPE"] = logtype;
    note["NOTE"]    = note_text;
    note["USER_ID"] = UserInfoContext.Current?.UserId;
    return FP_ExecuteQuery("Utility", "note2", note.Dictionary);
}
```

### §4.1 SpeedUp 패턴 (도메인 화면 사용)

```csharp
// DMF0004 / DMF0008 / DMF0020 의 cboDivision_SelectedIndexChanged 안
DataService.FP_Log2("SpeedUp", "DMF0004", "division_id_changed", "start");
// ... heavy work (5+ DataService.GetDMInnerTable 호출) ...
DataService.FP_Log2("SpeedUp", "DMF0004", "division_id_changed", "end");
```

→ start/end 매칭으로 duration 계산. 1 round-trip 이지만 호출 2회.

### §4.2 격차 G3 신규 구현 (이미 결정됨)

`_mapping/asis_to_tobe.md` §4 참조. 핵심:
- DB: `SCM_SYS_PERF_LOG` (TRACE_ID PK + USER_ID + MENU_ID + ACTION + PHASE + EVENT_AT + DURATION_MS)
- BE: `@PerfLog(menuId, action)` AOP 자동 또는 Logger MDC
- FE (선택): `usePerfTrace.measure(action, async () => { ... })`

→ **SetSaveLog (§3) + FP_Log2 (§4) 둘 다 G3 안에 통합 구현**.

---

## §5 §1.4 — SaveMenuConnect (메뉴 open/close 로그)

```csharp
// BaseForm.ChildForm_FormClosed (line 1008-1018)
using (var client = new FoxBizClient("GSCM", "GSCM.BizService.WSL/FoxBizService.svc")) {
    var request = new FoxBizRequest("Authentication", "SaveMenuConnect");
    request.Parameters["MenuID"]   = sMenuID;
    request.Parameters["CnntCode"] = "0104002";  // Close (0104001 = Open)
    request.Parameters["UserID"]   = UserInfoContext.Current.UserId;
    client.Execute(request);
}
```

### §5.1 CnntCode 코드

| CnntCode | 의미 |
|---|---|
| `0104001` | Menu Open (화면 진입) |
| `0104002` | Menu Close (화면 종료) |

### §5.2 호출 시점

- Open: BaseForm OnShown (직접 호출 안 보임 — 추정으로 FoxForm 기반 base 또는 외부에서 호출)
- Close: BaseForm ChildForm_FormClosed (명시)

### §5.3 TO-BE 매핑

→ G3 (PerfLog) 안에 `action='menu_open'` / `action='menu_close'` 로 통합. 별도 테이블 불필요.

---

## §6 통합 TO-BE 구현 (G3 확장)

> 5 격차 결정에서 G3 (PerfLog) 신규 구현은 §3 (SetSaveLog) + §4 (FP_Log2 SpeedUp) + §5 (SaveMenuConnect) 3 메커니즘 통합.

### §6.1 DB 확장 (SCM_SYS_PERF_LOG 또는 SCM_SYS_LOG 확장)

기존 `SCM_SYS_LOG` 활용 추천 (이미 `@SystemLog` 매핑됨). 추가 컬럼:

| 신규 컬럼 | 의미 |
|---|---|
| `ACTION` VARCHAR2(50) | 'menu_open' / 'menu_close' / 'find' / 'save' / 'division_change' 등 |
| `PHASE` VARCHAR2(20) | 'start' / 'end' / 'one' (즉시 종료) |
| `DURATION_MS` NUMBER | end 시점에 계산 |
| `TRACE_ID` VARCHAR2(50) | start ↔ end 매칭 ULID |

또는 분리 테이블 `SCM_SYS_PERF_LOG` 신규 — DBA 결정.

### §6.2 BE — 3 메커니즘 통합

```java
// (a) 메뉴 open/close
@Component
public class MenuConnectInterceptor implements HandlerInterceptor {
    @Override
    public void afterCompletion(...) {
        if (request.getRequestURI().startsWith("/api/menu/enter")) {
            perfLogService.log(userId, menuId, "menu_open", "one");
        }
        // close 는 FE 가 명시 호출
    }
}

// (b) 화면 실행 시간 (Find / Save)
@PerfLog(menuId = "DMF0004", action = "find")
public List<...> retrieveMain(...) { ... }

// (c) 화면 안 부분 동작 (FP_Log2 SpeedUp 동등)
// FE 가 usePerfTrace.measure 호출 → BE POST /api/system/perf-log
```

### §6.3 FE — `usePerfTrace` (이미 §4 명세)

`@shared/hooks/usePerfTrace.ts` 의 `measure(action, fn)` API + 자동 menu_open/close (화면 lifecycle hook).

```typescript
// 화면 entry
useEffect(() => {
  perfTrace.log({ action: 'menu_open', phase: 'one' });
  return () => perfTrace.log({ action: 'menu_close', phase: 'one' });
}, []);

// Division 변경 시 (AS-IS FP_Log2 SpeedUp 등가)
const handleDivisionChange = (divisionId: string) => 
  perfTrace.measure('division_change', async () => { await bigFilter.refetch(...); });
```

---

## §7 룰셋 v2 반영

- `_tobe/16_logging.md` (Phase 4 신규)
  - §1 `@SystemLog` 자동 (AS-IS SCM_SYS_LOG_BATCH 동등)
  - §2 `@PerfLog` 자동 + `usePerfTrace.measure` (G3 신규)
  - §3 메뉴 open/close 자동 (interceptor)
  - §4 로그 컬럼 표 (PROG_ID / USER_ID / IP / ACTION / PHASE / DURATION_MS)
  - §5 위반 grep: `console.log` / `System.out.println` 0 건 의무 (기존 룰 유지)

---

## §8 진행 / 추가 분석

- ✅ BaseForm + DataService 의 모든 로깅 API 통합
- ✅ AS-IS 4 종 분류 → G3 신규 구현 1 종으로 통합 결정
- ⏳ Pending: AS-IS `SCM_SYS_LOG` 테이블 DDL 정밀 분석 (다음 세션 — DB 정밀 분석 phase)
- ⏳ Pending: AS-IS `UP_FX_SaveMenuExecutionLog` SP body 추출 (AS-IS DB 직접 cross-check)
