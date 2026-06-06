# TO-BE 룰 11 — BE 동적 SP 호출 아키텍처 (NSCM 표준)

> ⚠️ **전면 재작성 (2026-06-04)**: Phase 6 PoC 에서 사용자 지적으로 룰 11 의 Spring Boot 표준 패턴 (BodController 등 화면별 Controller) 이 NSCM 실제 아키텍처와 **불일치** 발견. 동적 SP 호출 아키텍처 + 메타 SQL 중심으로 전면 재작성.
>
> **NSCM BE 아키텍처 핵심**: 단일 `GeneralController` 의 `/{mnuId}/{shtNm}/{mnuBtnCd}/call-proc` endpoint 가 `SCM_ADM_API_M` 메타 lookup 기반으로 모든 화면의 SP 호출을 라우팅. **화면별 BE 패키지 작성 불필요**.

## §0 메타

| 항목 | 값 |
|---|---|
| 룰 # | 11 |
| 토픽 | NSCM 동적 SP 호출 아키텍처 + 메타 SQL 등록 + GeneralController 활용 |
| 적용 trigger | 신규 화면의 BE 측면 작업 |
| 관련 hook | `asis-coverage-check.md`, `popup-asis-analysis.md` |
| Phase 6 PoC 정정 | 2026-06-04 — Spring Boot 표준 패턴 → NSCM 동적 라우팅 |

---

## §1 NSCM BE 아키텍처 핵심

### §1.1 단일 동적 라우터 — `GeneralController`

```java
// nscm-be/src/main/java/com/lgcns/nscm/general/GeneralController.java
@RestController
@RequiredArgsConstructor
public class GeneralController extends BaseController {
    
    private final GeneralService generalService;
    
    @SystemLog(LogType.BUTTON)
    @AuthCheck(Type.ALL)
    @PostMapping("/{mnuId}/{shtNm}/{mnuBtnCd}/call-proc")
    public ResponseEntity callProc(
        @LoginUser UserSession userSession,
        @RequestBody Map<String, Object> params,
        @PathVariable String mnuId,
        @PathVariable String shtNm,
        @PathVariable String mnuBtnCd
    ) {
        params.put("mnuId", mnuId);
        params.put("shtNm", shtNm);
        params.put("mnuBtnCd", mnuBtnCd);
        return successResponseEntity(generalService.execBtn(params));
    }
}
```

**동작**:
1. FE 가 `apiClient.callProc<MENU_ID, SHEETS>(menuId, sheetName, action, params)` 호출
2. axios → `POST /{menuId}/{shtNm}/{mnuBtnCd}/call-proc`
3. GeneralController 가 `params + mnuId + shtNm + mnuBtnCd` 를 generalService 에 전달
4. generalService 가 `SCM_ADM_API_M` lookup → API_URL (예: `PKG_DMF0015.P_GET_BOD_M`)
5. `SCM_ADM_PROC_M` lookup → IN/OUT 파라미터 자동 매핑
6. 자동 인증 주입 (`sesUserId / sesLangCd / mnuId`)
7. MyBatis 가 SP 호출 → cursor 결과 반환
8. JSON wrap (`{ code: '0', message: 'success', result: { o_rc1: [...] } }`)

### §1.2 신규 화면 BE 작업 = **메타 SQL + SP body 만**

| 항목 | 필요 여부 | 위치 |
|---|---|---|
| Controller (Java) | ❌ 불필요 | (GeneralController 자동) |
| Service (Java) | ❌ 불필요 | (GeneralService 자동) |
| ServiceImpl (Java) | ❌ 불필요 | (자동) |
| DTO Request/Response (Java) | ❌ 불필요 | (Map<String, Object> 자동) |
| MyBatis XML | ❌ 불필요 | (메타 SQL 의 SCM_ADM_API_M 으로 SP 직접 호출) |
| **SCM_ADM_API_M 메타 등록** | ✅ 의무 | `_artifacts/{N}_DMF{XXX}_metadata.sql` BLOCK 5 |
| **SCM_ADM_PROC_M 메타 등록** | ✅ 의무 | 동일 BLOCK 4 |
| **SCM_ADM_MNU_M_SHEET_COLUMNS** | ✅ 의무 | 동일 BLOCK 6 (룰 08) |
| **SP body (Oracle PL/SQL)** | ✅ 의무 | `_artifacts/{N}_DMF{XXX}_PKG_*.sql` (룰 12) |
| **권한 메타** (`USER_GR_MNU_MPG_M`/`BTN_MPG_M`) | ✅ 의무 | BLOCK 7 |

→ **Java 코드 0 줄** + 메타 SQL + SP body 로 BE 측면 100% 완료.

---

## §2 메타 SQL 등록 표준

> 상세는 `_tobe/12_metadata_sql.md` 참조. 본 룰에서는 BE 작업 관점에서 핵심만:

### §2.1 SCM_ADM_API_M (endpoint → SP 매핑)

```sql
INSERT INTO SCM_ADM_API_M (MNU_ID, SHT_NM, ACTION_TP, API_URL, API_TP_CD, API_MSG_ID, USE_YN)
SELECT 'DMF0015', 'main', 'RETRIEVE', 'PKG_DMF0015.P_GET_BOD_M', 'PKG_PROC', 'MSG_API_DMF0015_MAIN_RETRIEVE', 'Y' FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM SCM_ADM_API_M WHERE MNU_ID='DMF0015' AND SHT_NM='main' AND ACTION_TP='RETRIEVE');
```

| 컬럼 | 의미 | 예 |
|---|---|---|
| `MNU_ID` | 메뉴 ID | `'DMF0015'` |
| `SHT_NM` | sheet 이름 (FE SHEETS 의 value) | `'main'` |
| `ACTION_TP` | 액션 (RETRIEVE / SAVE / INSERT / DELETE / 등) | `'RETRIEVE'` |
| `API_URL` | SP 호출 명 | `'PKG_DMF0015.P_GET_BOD_M'` |
| `API_TP_CD` | SP 종류 (PKG_PROC / STANDALONE / WRAPPER) **NOT NULL** | `'PKG_PROC'` |
| `API_MSG_ID` | 실패 시 i18n key **NOT NULL** | `'MSG_API_DMF0015_MAIN_RETRIEVE'` |

### §2.2 SCM_ADM_PROC_M (SP 파라미터 명세)

```sql
INSERT INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, COL_TP_CD, COL_ORDR, DATA_TYPE, DATA_LENGTH, USE_YN)
SELECT 'P_DMF0015_GET_BOD_M', 'sesUserId', 'IN', 1, 'VARCHAR2', 20, 'Y' FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM SCM_ADM_PROC_M WHERE PROC_NM='P_DMF0015_GET_BOD_M' AND COL_NM='sesUserId' AND COL_TP_CD='IN');
```

> **COL_NM = BE 자동 채움 키 (camelCase)** — 메모리 `feedback_proc_meta_col_nm_be_auto_keys.md`:
> - `sesUserId` / `sesLangCd` / `sesGrId` / `mnuId` — BE 가 session 에서 자동 주입
> - 그 외 IN 은 FE 가 `apiClient.callProc(params)` 의 params 로 전달

### §2.3 카운트 검증 (PR 머지 게이트)

```bash
# 자동 검증: 신규 SP 작성 시 SCM_ADM_PROC_M 메타 카운트 = SP IN/OUT 카운트
AS_IS_PARAM_COUNT=$(grep -c "request.Parameters\[" GSCM/06.UIL/.../DM0015_BOD.cs)
TO_BE_META_COUNT=$(grep -c "INSERT INTO SCM_ADM_PROC_M.*'P_DMF0015" _artifacts/G15_DMF0015_BOD_metadata.sql)
# AS_IS_PARAM 와 TO_BE_META 가 일치해야 함 (PLS-00306 사고 회피)
```

---

## §3 SP body 작성 (Oracle PL/SQL)

> 상세는 `_tobe/12_metadata_sql.md` §4 (MSSQL → Oracle 변환) + §7 (AS-IS SP 1:1 변환 의무) 참조.

### §3.1 표준 시그니처 — Dual OUT Cursor (2026-06-06 강화)

```sql
CREATE OR REPLACE PROCEDURE P_DMF{XXX}_GET_{SHEET}_M (
    P_SES_USER_ID  IN VARCHAR2,
    P_SES_LANG_CD  IN VARCHAR2,
    P_MNU_ID       IN VARCHAR2,
    -- (도메인 IN 파라미터: P_DIVISION_ID, P_BOD_ID 등 camelCase IN)
    O_RC            OUT SYS_REFCURSOR,    -- ⭐ 데이터 cursor (PROC_M COL_NM='o_rc' 소문자 매핑)
    O_RESULT_CURSOR OUT SYS_REFCURSOR     -- ⭐ 결과 상태 cursor (PROC_M COL_NM='O_RESULT_CURSOR')
) AS
BEGIN
    OPEN O_RC FOR
        SELECT ... FROM SCM_MST_{TABLE}
        WHERE ...;

    OPEN O_RESULT_CURSOR FOR
        SELECT '0' AS CODE, 'SUCCESS' AS MSG FROM DUAL;
EXCEPTION
    WHEN OTHERS THEN
        DECLARE V_ERR VARCHAR2(4000) := SUBSTR(SQLERRM, 1, 4000);
        BEGIN
            OPEN O_RC FOR SELECT NULL AS DUMMY FROM DUAL WHERE 1=0;
            OPEN O_RESULT_CURSOR FOR
                SELECT '-1' AS CODE, V_ERR AS MSG FROM DUAL;
        END;
END;
/
```

⚠️ **Dual cursor 의무**: 단일 OUT cursor 사용 시 BE 응답 JSON 의 cursor key 가 `O_RESULT_CURSOR` 뿐이라 FE 의 `data?.o_rc` 가 undefined → grid 빈 표시 (SCM0009 사고 2026-06-06). 상세는 hook `sp-dual-cursor-pattern.md`.

### §3.2 저장 SP (CLOB JSON 패턴)

AS-IS 의 `^ csv` 다중 행 전달 → TO-BE 는 CLOB JSON + `JSON_TABLE`:

```sql
CREATE OR REPLACE PROCEDURE P_DMF{XXX}_SAVE_{SHEET}_M (
    P_SES_USER_ID IN VARCHAR2,
    P_MNU_ID      IN VARCHAR2,
    P_IN_DATA     IN CLOB,    -- JSON array
    O_MSG         OUT VARCHAR2,
    O_CD          OUT VARCHAR2
) AS
BEGIN
    FOR r IN (
        SELECT *
        FROM JSON_TABLE(P_IN_DATA, '$[*]' COLUMNS (
            CRUD_TYPE     VARCHAR2(1)  PATH '$.CRUD_TYPE',
            DIVISION_ID   VARCHAR2(20) PATH '$.DIVISION_ID',
            -- ... 모든 column
        ))
    ) LOOP
        IF r.CRUD_TYPE = 'I' THEN INSERT ...
        ELSIF r.CRUD_TYPE = 'M' THEN UPDATE ...
        ELSIF r.CRUD_TYPE = 'D' THEN DELETE ...
        END IF;
    END LOOP;
    
    O_MSG := 'MSG00004'; O_CD := '0';
EXCEPTION WHEN OTHERS THEN
    O_MSG := SQLERRM; O_CD := '1'; ROLLBACK;
END;
/
```

---

## §4 권한 처리 (메타 기반)

### §4.1 `@AuthCheck` annotation (GeneralController 자동)

`GeneralController` 의 `@AuthCheck(Type.ALL)` annotation 이 모든 호출에 권한 cross-check:
- `SCM_ADM_USER_GR_MNU_MPG_M` 메뉴 권한 lookup
- `SCM_ADM_USER_GR_MNU_BTN_MPG_M` 버튼 권한 lookup
- 권한 없음 → 401 / 403 자동 반환

→ **신규 화면별 권한 처리 코드 0 줄**. 메타 등록만으로 완료.

### §4.2 Division 권한 (`SCM_ADM_USER_GR_UNIT_AUTH_MPG_M`)

SP body 안에서 cross-check:
```sql
AND EXISTS (
    SELECT 1 FROM SCM_ADM_USER_GR_UNIT_AUTH_MPG_M a
    WHERE a.USER_ID = P_SES_USER_ID
      AND a.GR_ID = P_SES_GR_ID
      AND a.UNIT_VAL = b.DIVISION_ID
)
```

---

## §5 신규 Controller 작성이 필요한 예외 케이스

> **드뭄** — 다음 경우에만 별도 Controller 작성 (다른 모든 화면은 GeneralController 사용):

| 케이스 | 위치 |
|---|---|
| 인증 / 메뉴 트리 / 권한 | `admin/auth`, `admin/menu`, `admin/user` |
| Lookup / Combo (lookup-muti / combo-muti) | `admin/lookup` |
| 시스템 (로그, 메시지) | `admin/log`, `admin/message` |
| 파일 (G5 Phase 5+) | `general/file` |
| **도메인 master 화면 (DMF0004~7 / DMF0015 / DMF0020 등)** | ❌ **별도 Controller 미작성** (GeneralController 사용) |

### §5.1 별도 Controller 가 필요한 신호

다음 모두 충족 시에만:
- (a) SP 호출 외의 비즈니스 로직이 BE 에서 필요 (Java 로직)
- (b) 표준 `{menuId}/{shtNm}/{btnCd}/call-proc` 라우팅으로 처리 불가능
- (c) 파일 / 외부 시스템 연동 / 멀티 트랜잭션 등 GeneralService 외 처리 필요

→ **(a)+(b)+(c) 모두 true 인 경우만**. 일반 master 화면은 미해당.

---

## §6 자동 검증 (PR 머지 게이트)

```bash
# 1. 신규 화면별 BE Controller 작성 여부 — 일반적으로 0
ls nscm-be/src/main/java/com/lgcns/nscm/master/{kebab-feature}/  2>/dev/null
# 결과: 폴더 미존재 = 정상 (GeneralController 사용)

# 2. 메타 SQL 4 파일 세트 존재
test -f _artifacts/{N}_DMF{XXX}_metadata.sql
test -f _artifacts/{N}_DMF{XXX}_metadata_DBeaver.sql
test -f _artifacts/{N}_DMF{XXX}_metadata_Verify.sql

# 3. SCM_ADM_API_M / PROC_M 등록 카운트
sqlplus -s ... "SELECT COUNT(*) FROM SCM_ADM_API_M WHERE MNU_ID='DMF0015'"
# 결과 ≥ 1 per (sheet × action)

sqlplus -s ... "SELECT COUNT(*) FROM SCM_ADM_PROC_M WHERE PROC_NM LIKE 'P_DMF0015_%'"
# 결과 ≥ 1 per SP × (IN + OUT param)

# 4. SP 존재 (Oracle compiled VALID)
sqlplus -s ... "SELECT OBJECT_NAME, STATUS FROM USER_OBJECTS WHERE OBJECT_TYPE = 'PACKAGE' AND OBJECT_NAME = 'PKG_DMF0015'"
# 결과: STATUS = VALID

# 5. AS-IS SP 의 모든 JOIN/WHERE 1:1 보존 (anti-simplification — 메모리 룰)
diff -u (AS-IS PKG body) (TO-BE PKG body)
# 결과: 모든 SELECT / JOIN / WHERE 1:1 매핑
```

---

## §7 AS-IS → TO-BE BE 매핑 표

| AS-IS GSCM (.NET WCF) | TO-BE NSCM (Spring Boot REST) |
|---|---|
| `FoxBizClient("GSCM", "X.WSL/FoxBizService.svc")` | `GeneralController` 의 `/call-proc` endpoint |
| `FoxBizRequest("AppService", "GeneralExecuteQuery")` | `POST /{menuId}/{shtNm}/{btnCd}/call-proc` |
| `request.Parameters["X"] = Y` | `RequestBody { X: Y }` JSON |
| `response.Result` (DataSet) | `successResponseEntity(data)` → `{ code, message, result }` |
| `UserInfoContext.Current.UserId` (FE) | `@LoginUser UserSession` (BE 자동) |
| `EncryptUserID(dictParam)` AES | JWT session (자동 추출) |
| `filter["_SAVE_AUTH"] = "Y"` (SP 플래그) | `@AuthCheck` annotation 자동 |
| `SecurityContext.CanSelect` (4 권한) | `SCM_ADM_USER_GR_MNU_MPG_M` (5 권한 컬럼) |
| `SCM_SYS_LOG_BATCH` | `@SystemLog` annotation 자동 |
| 4 시스템 endpoint (FP/Common/SCM/QA) | 단일 endpoint + 메타 SQL 분기 |
| **DMF0004 / DMF0005 / DMF0006 / DMF0007 / DMF0020** 모두 별도 Controller | **모두 GeneralController 사용 — 화면별 Controller 0** |

---

## §8 보안 의무 (TO-BE 이관 시 절대 금지)

> Phase 1 § 5 (Auth_FormAuth) 발견 — `_asis/00_framework/05_Auth_FormAuth.md` §3.2

⛔ **AS-IS `GSCM/01.Framework/GSCM.App.Core/GAppSettings.cs` 의 hardcoded 값 절대 이관 금지**:
- AES 키 (`AESKey` / `AESVector`)
- DB connection string (`saveSCPPath_dev` / `_prd` — uid + pwd 포함)

**TO-BE 의무**:
- Jasypt + Vault / AWS Secrets Manager / 환경변수
- `config-local.yml` (gitignore) + Spring profile
- `.gitignore` 강화 (`*.key` / `*.pem` / `_artifacts/grant_*.sql` / `.figma_token`)

---

## §9 격차 (Phase 5 신규 endpoint — 별도 Controller 작성 케이스)

> 격차 8 종 (G1~G6 + G9 + G10) 중 BE 작업 필요한 것:

| 격차 | BE 작업 | 위치 |
|---|---|---|
| G1 (검색조건 저장/복원) | **이미 구현** (`MenuController.retrieveSearchConditions/saveSearchConditions/resetSearchConditions`) | `admin/menu/` |
| G2 (BigFilter combo-muti) | **이미 구현** (`LookupController.retrieveComboMuti`) | `admin/lookup/` |
| G3 (PerfLog) | 신규 — `SCM_SYS_PERF_LOG` 테이블 + `@PerfLog` AOP 또는 PerfLogController | `framework/aspect` 또는 신규 |
| G4 (Batch) | 신규 — `POST /api/batch/{menuId}/{sheetName}` (또는 callProc 반복) | (단순 callProc 반복 권장 — 별도 Controller 불필요) |
| G5 (File transfer) | 기존 `general/file/FileController` 활용 또는 확장 | `general/file/` |
| G6 (YesNoCancel) | FE only — BE 작업 없음 | - |
| G9 (DateRangePicker) | FE only | - |
| G10 (MonthPicker) | FE only | - |

→ **거의 모든 격차 BE 이미 구현** 또는 FE only. 신규 Controller 작성 거의 없음.

---

## §10 변경 이력

| 일자 | 변경 |
|---|---|
| 2026-06-03 | 초안 (Phase 3 추출) — Spring Boot 표준 패턴 (BodController + Service + ...) |
| **2026-06-04** | **전면 재작성 (Phase 6 PoC 정정)** — NSCM 동적 SP 호출 아키텍처 + 메타 SQL 중심 + Java 코드 0 줄 표준 |
