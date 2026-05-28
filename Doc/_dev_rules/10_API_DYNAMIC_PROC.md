# 10. 동적 SP 호출 아키텍처 (NSCM 핵심)

> NSCM 은 **메타데이터 기반 동적 SP 호출** 아키텍처입니다. 화면 코드는 "어떤 SP 를 호출하는지" 알지 않습니다.
> 메타 7개 영역 (SYS0001~SYS0008) 이 정확하면 단 1개의 BE 엔드포인트가 모든 화면 데이터 흐름을 처리합니다.
>
> ⭐ **선행 룰**: [`08_SCREEN_REGISTRATION.md`](08_SCREEN_REGISTRATION.md) §1 (호출 흐름 원형), [`04_BE_RULES.md`](04_BE_RULES.md), [`03_FE_RULES.md`](03_FE_RULES.md)
> ⭐ **연관**: [`12_GRID_COMMON.md`](12_GRID_COMMON.md) (Grid 컬럼 메타), [`14_ERROR_HANDLING.md`](14_ERROR_HANDLING.md) (에러 전파), [`21_TROUBLESHOOTING.md`](21_TROUBLESHOOTING.md) §1 (빈 결과 진단), §9.5 (ORA-01403 — sheet 매핑 누락)
> ⭐ **2026-05-28 추가**: [`27_WIJMO_PIVOT_AND_MODULE.md`](27_WIJMO_PIVOT_AND_MODULE.md) §D — 신규 sheet 등록 BE 5종 매핑 + 권한 + sheet name 대소문자 완전 일치 (FE enum vs BE `SHT_NM`)

---

## 1. 한 줄 요약

```
FE: useTabProcQuery({ menuId, sheetName, procedureAction, filters })
    ↓ POST /{mnuId}/{shtNm}/{mnuBtnCd}/call-proc
BE: GeneralController.callProc(...) → GeneralServiceImpl.execBtn(params)
    ↓ ① 메타 조회: SCM_ADM_MNU_BTN_MPG_M ⨝ SCM_ADM_API_M ⨝ SCM_ADM_PROC_M
    ↓ ② 동적 CALL 문 조립: makeProcedure(params, procInfo)
    ↓ ③ MyBatis: { CALL PKG_{MENU}.P_{MENU}_GET_*(...) }
DB: SP 실행 → SYS_REFCURSOR (o_rc1/o_rc2/...) + O_RESULT_CURSOR (상태)
    ↑
FE: data.o_rc1 → Wijmo Grid
    (컬럼 정의는 별도 GET /admin/menu/{MENU}/column → SCM_MST_SHEET_COLUMNS)
```

---

## 2. 메타 7개 영역의 역할

| # | 영역 | 테이블 | 역할 | 누락 시 |
|---|---|---|---|---|
| 1 | i18n | `SCM_ADM_MSG_M` | 메뉴/라벨/메시지 코드 (KO/EN/CN) | 화면명/필드명 미표시 |
| 2 | 메뉴 마스터 | `SCM_ADM_MNU_M` | 메뉴 트리 + URL slug | 메뉴 클릭 시 라우팅 실패 |
| 3 | **Procedure 메타** | `SCM_ADM_PROC_M` | SP IN/OUT 파라미터 명세 | **★ NULL 파라미터 호출 → 빈 결과 (DMF0007 사례)** |
| 4 | API 메타 | `SCM_ADM_API_M` | API_ID ↔ PKG.SP 매핑 | "API not found" |
| 5 | 라우팅 매핑 | `SCM_ADM_MNU_BTN_MPG_M` | (MNU, SHT, BTN) → API_ID | 버튼 클릭 시 호출 안 됨 |
| 6 | Grid 컬럼 | `SCM_MST_SHEET_COLUMNS` | SP OUT 컬럼 정의 (라벨/타입/너비) | Grid 빈 컬럼 |
| 7 | 권한 (메뉴+버튼) | `SCM_ADM_USER_GR_MNU_MPG_M` + `..._BTN_MPG_M` | 사용자 그룹 × 메뉴/버튼 접근 권한 | 'No Permission' 오류 |

> ⚠ 7개 영역이 단 1개라도 누락되면 화면이 동작하지 않거나 빈 데이터를 반환합니다. 신규 화면 추가 시 7-BLOCK DML 의무.

---

## 3. FE → BE → DB 흐름 (3 단계)

### 3.1 FE: `useTabProcQuery` / `useProcMutation`

```ts
// 조회 (Query)
const { data } = useTabProcQuery<MENU_ID>({
  menuId: MENU_ID,              // 'DMF0099' as const
  sheetName: SHEETS.MAIN,       // 'main'
  procedureAction: BUTTON_TYPE.SEARCH,   // 기본값 (생략 가능)
  tabId,
  filters,                      // ProcRequest<MENU_ID, SHEETS.MAIN>
  enabled: filters !== undefined,
});

// 저장 (Mutation)
const { mutate } = useProcMutation<MENU_ID>({
  menuId: MENU_ID,
  sheetName: SHEETS.MAIN,
  tabId,
});
```

> 구현: `nscm-fe/packages/shared/src/hooks/useCustomQueryClient.ts` (useTabProcQuery, useProcMutation)
> 직접 fetch / axios 호출 금지 — 메타 자동 적용 + 캐시 키 자동 생성 + 401/5xx 인터셉터 자동 적용 안 됨.

### 3.2 BE: `GeneralController.callProc`

```java
// nscm-be/src/main/java/com/lgcns/nscm/general/GeneralController.java
@SystemLog(LogType.BUTTON)
@AuthCheck(Type.ALL)
@PostMapping(value = "/{mnuId}/{shtNm}/{mnuBtnCd}/call-proc",
             produces = "application/json; charset=UTF-8")
public ResponseEntity callProc(
        @LoginUser UserSession userSession,
        @RequestBody(required = false) Map<String, Object> params,
        @PathVariable String mnuId,    // 'DMF0099'
        @PathVariable String shtNm,    // 'main'
        @PathVariable String mnuBtnCd  // 'SEARCH' / 'SAVE' / 'EXCEL' / ...
) throws Exception {
    if (NullUtils.isNone(params)) params = new HashMap<>();
    params.put("mnuId", mnuId);
    params.put("shtNm", shtNm);
    params.put("mnuBtnCd", mnuBtnCd);
    return successResponseEntity(generalService.execBtn(params));
}
```

### 3.3 BE: `GeneralServiceImpl.execBtn`

```java
// nscm-be/src/main/java/com/lgcns/nscm/general/GeneralServiceImpl.java
public Map<String, Object> execBtn(Map<String, Object> params) throws Exception {
    // ① 메타 조회: (mnuId, shtNm, mnuBtnCd) → API_URL (PKG.SP) + procInfo[]
    List<Map<String, Object>> procParam =
        (List<Map<String, Object>>) selectList("retrieveBtnInfoList", params).get("procInfo");

    // ② JVARCHAR (JSON 직렬화 IN 파라미터) 처리
    boolean isJvarchar = false;
    Set<String> jCols = new HashSet<>();
    for (Map<String, Object> p : procParam) {
        if (p.get("DATA_TP_CD").equals("JVARCHAR")) {
            isJvarchar = true;
            jCols.add((String) p.get("COL_NM"));
        }
    }
    if (isJvarchar) MapUtils.cvtJsonToJVarchar(params, jCols);

    // ③ 동적 CALL 조립 + 실행
    return selectList("callProc", makeProcedure(params, procParam));
}
```

### 3.4 DB: 메타 조회 SQL (`retrieveBtnInfoList`)

```sql
-- (mnuId, shtNm, mnuBtnCd) → API_URL + procInfo[]
SELECT T2.API_URL AS PROC_NM    -- 'PKG_DMF0099.P_DMF0099_GET_MAIN_DATA'
  FROM SCM_ADM_MNU_BTN_MPG_M T1
  JOIN SCM_ADM_API_M         T2 ON T1.API_ID = T2.API_ID
 WHERE T1.MNU_ID = #{mnuId}
   AND T1.SHT_NM = #{shtNm}
   AND T1.MNU_BTN_CD = #{mnuBtnCd};

-- 위 결과의 PROC_NM 으로 IN/OUT 컬럼 메타 조회
SELECT COL_NM, COL_TP_CD, DATA_TP_CD, SORT_ORD
  FROM SCM_ADM_PROC_M
 WHERE PROC_NM = #{procNm}
 ORDER BY SORT_ORD;
```

### 3.5 DB: 동적 CALL 문 (조립 후)

```sql
{ CALL PKG_DMF0099.P_DMF0099_GET_MAIN_DATA(
    #{divisionId, mode=IN,  jdbcType=VARCHAR},
    #{userId,     mode=IN,  jdbcType=VARCHAR},
    #{o_rc1,           mode=OUT, jdbcType=CURSOR, resultMap=data1},
    #{o_result_cursor, mode=OUT, jdbcType=CURSOR, resultMap=data2}
) }
```

> MyBatis 가 procInfo 의 SORT_ORD 순서로 `#{}` 자리표시자를 자동 생성. SP 시그니처 변경 시 SCM_ADM_PROC_M 만 갱신하면 BE 코드 수정 불필요.

---

## 4. SP 시그니처 표준

### 4.1 GET (조회) SP

```sql
PROCEDURE P_DMF0099_GET_MAIN_DATA (
    P_DIVISION_ID     IN  VARCHAR2,
    P_USER_ID         IN  VARCHAR2,
    P_MENU_ID         IN  VARCHAR2,
    -- ... 모든 IN 파라미터
    O_RC1             OUT SYS_REFCURSOR,   -- 메인 데이터 커서
    O_RESULT_CURSOR   OUT SYS_REFCURSOR    -- 상태/에러 코드
);
```

> 패턴: GET SP 는 항상 `O_RC1` (+ 필요 시 `O_RC2`, `O_RC3`) + `O_RESULT_CURSOR` 반환.

### 4.2 SAVE / DELETE SP

```sql
PROCEDURE P_DMF0099_SAVE_MAIN_DATA (
    P_DATA            IN  CLOB,            -- JSON 직렬화 데이터
    P_USER_ID         IN  VARCHAR2,
    O_RESULT_CURSOR   OUT SYS_REFCURSOR
);
```

> 패턴: SAVE/DELETE SP 는 `O_RESULT_CURSOR` 1 개만 반환. IN 은 `CLOB` (JSON) 또는 컬럼별 개별.

### 4.3 SCM_ADM_PROC_M `DATA_TP_CD` 값

| 값 | 의미 |
|---|---|
| `VARCHAR` | 일반 문자열 IN/OUT |
| `NUMBER` | 숫자 IN/OUT |
| `DATE` | 날짜 IN/OUT |
| `CLOB` | 대용량 문자열 (JSON 등) |
| `CURSOR` | SYS_REFCURSOR OUT (Grid 데이터) |
| `PROC_RESULT` | `O_RESULT_CURSOR` 전용 (상태 코드) |
| **`JVARCHAR`** | **JSON 문자열 IN — FE 에서 객체 직렬화 후 전송** |

### 4.4 SCM_ADM_PROC_M `COL_TP_CD` 값

`IN` / `OUT` — 단순. IN/OUT (양방향) 은 NSCM 에서 사용하지 않음.

---

## 5. FE 응답 처리 (RESPONSE_SET)

```ts
// constants.ts
export enum RESPONSE_SET {
  MAIN = 'o_rc',      // BE 가 lowercase 로 변환하여 응답
  SUB  = 'o_rc1',
}
```

```ts
// PageName.tsx
const { data } = useTabProcQuery<MENU_ID>({...});
const rows = data?.o_rc ?? [];   // 또는 data?.[RESPONSE_SET.MAIN]
```

> BE → FE 응답: SP 의 OUT CURSOR 컬럼명은 lowercase (`O_RC1` → `o_rc1`). 컬럼 데이터는 그대로 (`DIVISION_ID` → `DIVISION_ID`).

---

## 6. Grid 컬럼 정의 (별도 메타 호출)

`useTabProcQuery` 가 가져오는 것은 **데이터**, 컬럼 정의는 별도:

```ts
// useDmf0099Store.ts
const fetchStaticColumns = async () => {
  const res = await apiClient.get(`/admin/menu/${MENU_ID}/column`);
  // → SCM_MST_SHEET_COLUMNS 조회 결과
  set(state => { state.staticColumns = res.data.result; });
};
```

→ Grid 컬럼 활용 상세: [`12_GRID_COMMON.md`](12_GRID_COMMON.md)

---

## 7. 직접 SP 호출 vs 동적 호출 — 선택 기준

| 케이스 | 동적 호출 | 직접 호출 (Controller 작성) |
|---|---|---|
| 일반 화면 검색/저장 | ✅ | ❌ 불필요 |
| 단순 CRUD | ✅ | ❌ |
| 권한 분기만 있는 경우 | ✅ (`@AuthCheck`) | ❌ |
| **복잡한 트랜잭션** (여러 SP + 후처리) | ❌ | ✅ 작성 |
| **파일 업로드/다운로드** | ❌ | ✅ (`FileController`) |
| **외부 시스템 연동** (NERP/SAP) | ❌ | ✅ |
| **배치 트리거** | ❌ | ✅ |

> 권장: 90% 이상의 화면은 동적 호출로 충분. 직접 Controller 는 정말 필요할 때만.

---

## 8. 흔한 에러 케이스

### 8.1 빈 결과 반환 (DMF0007 사례, 2026-05-19)
**원인**: `SCM_ADM_PROC_M` 등록 누락 → procInfo 가 비어 → `makeProcedure` 가 IN 파라미터를 NULL 로 호출 → SP 가 빈 결과 반환.
**진단**:
```sql
SELECT COUNT(*) FROM SCM_ADM_PROC_M WHERE PROC_NM = 'PKG_DMF0099.P_DMF0099_GET_MAIN_DATA';
-- 0 이면 메타 미등록. 17_NEW_SCREEN_QUICKSTART Step 3 BLOCK 3 누락.
```

### 8.2 'API not found' / 호출 자체 안 됨
**원인**: `SCM_ADM_MNU_BTN_MPG_M` 또는 `SCM_ADM_API_M` 누락.
**진단**:
```sql
SELECT * FROM SCM_ADM_MNU_BTN_MPG_M WHERE MNU_ID='DMF0099' AND MNU_BTN_CD='SEARCH';
SELECT * FROM SCM_ADM_API_M WHERE API_ID = (위 결과의 API_ID);
```

### 8.3 'No Permission' / 403
**원인**: `SCM_ADM_USER_GR_MNU_MPG_M` 또는 `..._BTN_MPG_M` 누락 (권한 2 테이블 중 1개라도).
→ 메모리 `reference_scm_adm_user_gr_btn_mpg_m.md` 참조.

### 8.4 Grid 컬럼 빈 상태
**원인**: `SCM_MST_SHEET_COLUMNS` 누락 또는 `PROGRAM_ID` 오타.

### 8.5 ORA-22288: 잘못된 ARG 타입
**원인**: SP 시그니처 ↔ `SCM_ADM_PROC_M` 불일치 (DATA_TP_CD 또는 SORT_ORD).
**진단**:
```sql
SELECT POSITION, ARGUMENT_NAME, IN_OUT, DATA_TYPE
  FROM ALL_ARGUMENTS
 WHERE PACKAGE_NAME = 'PKG_DMF0099' AND OBJECT_NAME = 'P_DMF0099_GET_MAIN_DATA'
 ORDER BY POSITION;
-- 위 결과와 SCM_ADM_PROC_M 의 COL_NM/COL_TP_CD/DATA_TP_CD/SORT_ORD 비교
```

→ 상세 트러블슈팅: [`21_TROUBLESHOOTING.md`](21_TROUBLESHOOTING.md) §1, §2

---

## 9. 자기 점검 체크리스트

신규 화면 동작 검증 시:

```
[ ] BE 엔드포인트 (Swagger): POST /DMF0099/main/SEARCH/call-proc 가 노출됨
[ ] DB: 7-BLOCK 모두 INSERT 완료 (Verify SQL 결과 모두 CNT ≥ EXPECT_MIN)
[ ] FE: useTabProcQuery 만 사용 (apiClient.post / axios 직접 호출 X)
[ ] FE: procedures.d.ts 에 MENU_ID + ProcRequest/Response 타입 등재
[ ] SP: O_RC1 + O_RESULT_CURSOR 2 커서 반환 (GET 형)
[ ] SP: SCM_ADM_PROC_M 의 SORT_ORD == SP 파라미터 POSITION
[ ] 권한 2 테이블 (메뉴+버튼 권한) 모두 INSERT
[ ] mnuBtnCd (SEARCH/SAVE/EXCEL/DELETE/...) 별로 SCM_ADM_MNU_BTN_MPG_M 행 존재
```

---

## 10. 관련 문서

| 룰 | 주제 |
|---|---|
| [`08_SCREEN_REGISTRATION.md`](08_SCREEN_REGISTRATION.md) | 7-BLOCK 메타 등록 표준 절차 (Step 1~8) |
| [`12_GRID_COMMON.md`](12_GRID_COMMON.md) | Grid 컬럼 메타 → cellTemplate 매핑 |
| [`14_ERROR_HANDLING.md`](14_ERROR_HANDLING.md) | SP 에러 → BE Exception → FE 표시 |
| [`17_NEW_SCREEN_QUICKSTART.md`](17_NEW_SCREEN_QUICKSTART.md) | 5분 신규 화면 (메타 + FE + BE) |
| [`21_TROUBLESHOOTING.md`](21_TROUBLESHOOTING.md) | 빈 결과 / ORA-22288 / 권한 오류 진단 |
| [`hooks/post-write.md`](hooks/post-write.md) §5 | 7개 영역 검증 SQL |
