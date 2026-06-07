# TO-BE 룰 12 — 메타 SQL (BLOCK 1~7 + Lookup combo + AS-IS → Oracle 변환)

> **추출 reference**: `_artifacts/{N}_DMF{XXXX}_*.sql` 의 BLOCK 1~7 표준 + 메모리 `feedback_sql_idempotent_insert_all.md` / `feedback_sql_dual_output.md` / `feedback_dbeaver_sql_mandatory_grep.md` / `feedback_oracle_cmbo_quote_pitfall.md`

## §0 메타

| 항목 | 값 |
|---|---|
| 룰 # | 12 |
| 토픽 | 메타 SQL BLOCK 1~7 + Lookup combo SQL + MSSQL → Oracle 변환 + 멱등 INSERT |
| 적용 trigger | 신규 화면 메타 등록 / SP body 작성 |
| 관련 hook | `asis-coverage-check.md`, `deploy-package-completeness.md` |

---

## §1 7-BLOCK 메타 SQL 표준 (의무)

> 신규 화면 등록 시 메타 SQL 7-BLOCK 모두 INSERT. 누락 시 메뉴 미표시 / 권한 없음 / 컬럼 미표시 등 사고.

### §1.1 BLOCK 인벤토리

| BLOCK | 테이블 | 내용 | 실행 순서 |
|---|---|---|---|
| BLOCK 1 | i18n / Message | LBL00xxx + MSG00xxx 다국어 (KO/EN/CN) | 1 |
| BLOCK 2 | `SCM_ADM_MNU_M` | 메뉴 등록 (MNU_ID + MNU_NM + MNU_URL + UPPR_MNU_ID + MNU_TP_CD) | 2 |
| BLOCK 3 | `SCM_ADM_MNU_M_SHEET` | 화면별 sheet 메타 (SHT_NM = 'main' 또는 의미명) | 3 |
| BLOCK 4 | `SCM_ADM_PROC_M` | SP 파라미터 명세 (PROC_NM + COL_NM + DATA_TYPE + COL_TP_CD) | 4 |
| BLOCK 5 | `SCM_ADM_API_M` | endpoint URL + sheet → SP 매핑 (API_TP_CD NOT NULL!) | 5 |
| BLOCK 6 | `SCM_ADM_MNU_M_SHEET_COLUMNS` | grid column 메타 (룰 08) | 6 |
| BLOCK 7 | 권한 2 테이블 | `USER_GR_MNU_MPG_M` + `USER_GR_MNU_BTN_MPG_M` | 7 |

### §1.2 4-파일 SQL 세트 표준

> 메모리 `feedback_sql_dual_output.md`: 메타 SQL 등록 시 항상 4 파일 세트 생성.

```
_artifacts/{NN}_{MENU_ID}_{purpose}_{date}.sql            ⭐ 메인 (SQL*Plus 호환)
_artifacts/{NN}_{MENU_ID}_{purpose}_{date}_DBeaver.sql    ⭐ DBeaver 호환 (DEFINE / `/` 제거)
_artifacts/{NN}_{MENU_ID}_{purpose}_{date}_Verify.sql     ⭐ 등록 검증 (COUNT(*))
_artifacts/{NN}_{MENU_ID}_{purpose}_{date}_Diagnose.sql   ⭐ 진단 (실패 시)
```

### §1.3 DBeaver 호환 의무 grep (메모리 룰)

> 메모리 `feedback_dbeaver_sql_mandatory_grep.md`: `_DBeaver*.sql` 작성 / 수정 직후 의무 검증.

```bash
# DBeaver 호환 검증 (ORA-00922 회피)
grep -nE "^SET|^PROMPT|^DEFINE|^&\w|^/$" _DBeaver.sql | wc -l   # = 0
```

→ 0건 확인 누락 시 `ORA-00922` 반복 (사용자 심각 지적 사고).

---

## §2 BLOCK 별 표준 SQL (NOT EXISTS 멱등 패턴)

> 메모리 `feedback_sql_idempotent_insert_all.md`: `INSERT ALL ... VALUES` 는 재실행 시 첫 unique 위반에서 전체 ROLLBACK. **항상 `INSERT SELECT FROM (...) NEW WHERE NOT EXISTS (...)`** 패턴 사용.

### §2.1 BLOCK 1 — i18n (LBL + MSG)

```sql
INSERT INTO SCM_ADM_I18N_M (CTGY_CD, MSG_CD, LANG_CD, MSG_CTN, UPD_ID, UPD_DT)
SELECT 'LBL', 'LBL00501', 'KO', 'Division', 'admin', SYSDATE FROM DUAL
WHERE NOT EXISTS (
    SELECT 1 FROM SCM_ADM_I18N_M WHERE CTGY_CD='LBL' AND MSG_CD='LBL00501' AND LANG_CD='KO'
);
-- (LBL00501 + EN, CN, LBL00502 + KO/EN/CN, ... 반복)

-- MSG 동일
INSERT INTO SCM_ADM_I18N_M (CTGY_CD, MSG_CD, LANG_CD, MSG_CTN, ...)
SELECT 'MSG', 'MSG00501', 'KO', '저장되었습니다', ... FROM DUAL
WHERE NOT EXISTS (...);
```

### §2.2 BLOCK 2 — 메뉴 등록 (`SCM_ADM_MNU_M`)

```sql
INSERT INTO SCM_ADM_MNU_M (MNU_ID, MNU_NM, MNU_URL, UPPR_MNU_ID, MNU_TP_CD, ORDR_NO, USE_YN, ...)
SELECT 'DMF0099', 'New Screen', 'new-screen', 'Demand_Master', 'SCREEN', 999, 'Y', ... FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM SCM_ADM_MNU_M WHERE MNU_ID = 'DMF0099');
```

**⚠️ 의무 (메모리 `feedback_mnu_uppr_case_standard.md`)**:
- `UPPR_MNU_ID` 대소문자 표준 인벤토리:
  - Lv1: `Master`, `Demand`, `Report`, `Admin`, `Authority`, `Popup`, `OPT`
  - Lv2: `Demand_Master`, `Demand_Plan`, `Demand_Report`, `Demand_Shipment`, `SCM_Master`, ...
- `DEMAND_MASTER` (대문자) 등록 시 메뉴 미표시 사고 (DMF0020).
- `MNU_TP_CD = 'SCREEN'` (대문자) 표준. `'FN'` 금지.
- `MNU_URL` = slug only (예: `'sales-future-price'`, `/` 없음). FE 라우터가 부모 트리 walk-up.

### §2.3 BLOCK 3 — Sheet 등록 (`SCM_ADM_MNU_M_SHEET`)

```sql
INSERT INTO SCM_ADM_MNU_M_SHEET (MNU_ID, SHT_NM, SHT_DSP_NM, ORDR_NO, USE_YN, ...)
SELECT 'DMF0099', 'main', 'Main', 1, 'Y', ... FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM SCM_ADM_MNU_M_SHEET WHERE MNU_ID='DMF0099' AND SHT_NM='main');
```

**⚠️ 의무 (메모리 `feedback_sheet_name_main_standard.md`)**:
- `SHT_NM = 'main'` 표준 (DMF0020 / 자매 화면). 화면 의미 이름 (예: `'futurePrice'`) 단독 금지.
- 다중 sheet 화면은 각 sheet 별 의미 이름 (DMF0008 의 `summary` / `repair` / `sspm`).
- FE `SHEETS.MAIN = 'main'` 과 일치 의무 — 불일치 시 `ORA-01403` at `PKG_NSCM_UI_COMM:17`.

### §2.4 BLOCK 4 — SP 파라미터 (`SCM_ADM_PROC_M`)

```sql
INSERT INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, COL_TP_CD, COL_ORDR, DATA_TYPE, DATA_LENGTH, ...)
SELECT 'P_DMF0099_GET_MAIN', 'sesUserId', 'IN', 1, 'VARCHAR2', 20, ... FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM SCM_ADM_PROC_M WHERE PROC_NM='P_DMF0099_GET_MAIN' AND COL_NM='sesUserId' AND COL_TP_CD='IN');
-- ... (모든 IN/OUT 파라미터 반복)
```

**⚠️ 의무 (메모리 `feedback_proc_meta_mandatory.md` + `feedback_proc_meta_col_nm_be_auto_keys.md`)**:
- AS-IS SP IN `P_USER_ID` → COL_NM `sesUserId` (camelCase, BE 자동 채움)
- `P_MENU_ID` → `mnuId` (FE request body 자동)
- `P_LANG_CD` → `sesLangCd`
- `P_CREATED_BY` → `createdBy` (BE 자동 채움 = sesUserId 값 — 2026-06-06 추가, NDaoInterface.java:434-438)
- `P_LAST_UPDATED_BY` → `lastUpdatedBy` (BE 자동 채움 = sesUserId 값 — 2026-06-06 추가)
- 그 외 IN → camelCase (예: `P_DIVISION_ID` → `divisionId`)
- `O_RCn` → 소문자 `o_rc1` / `o_rc2` (n 개의 데이터 cursor)
- `O_RESULT_CURSOR` → **반드시 대문자** (FE 가 `data.O_RESULT_CURSOR` 로 읽음, 표준)
- COL_TP_CD: `'IN'` / `'OUT'` / `'IN/OUT'`
- DATA_TYPE: `VARCHAR2` / `NUMBER` / `DATE` / `CLOB` / `SYS_REFCURSOR` (cursor)
- DATA_TP_CD: `'CURSOR'` (메인 데이터) / `'PROC_RESULT'` (결과 상태)

**PK = (PROC_NM, COL_NM, COL_TP_CD)** — UPDATE 시 충돌 → DELETE + INSERT.

### §2.4.1 ⭐ Dual OUT Cursor 표준 (GET SP 의무, 2026-06-06 강화)

> 단일 OUT cursor 사용 시 BE 응답 JSON 의 cursor key 가 `O_RESULT_CURSOR` 뿐이라 FE `data?.o_rc` 가 undefined → grid 빈 표시 (SCM0009 사고).

**GET SP 의 PROC_M 등록 의무 (마지막 2 행)**:

| COL_NM | DATA_TP_CD | 비고 |
|---|---|---|
| `o_rc` (소문자) | `CURSOR` | **메인 데이터 cursor — FE 가 `data.o_rc` 로 읽음 (RESPONSE_SET.OUTPUT)** |
| `O_RESULT_CURSOR` (대문자) | `PROC_RESULT` | 결과 상태 cursor (CODE/MSG) |

```sql
-- 의무 패턴 (예: P_SYS0012_GET_APPROVAL_LIST)
INSERT INTO SCM_ADM_PROC_M VALUES ('P_SYS0012_GET_APPROVAL_LIST', 'sesUserId',      'IN',  'VARCHAR',     1, ...);
INSERT INTO SCM_ADM_PROC_M VALUES ('P_SYS0012_GET_APPROVAL_LIST', '{filter}',       'IN',  'VARCHAR',     2, ...);
-- ...
INSERT INTO SCM_ADM_PROC_M VALUES ('P_SYS0012_GET_APPROVAL_LIST', 'o_rc',           'OUT', 'CURSOR',      N,   ...);  -- ⭐ 소문자
INSERT INTO SCM_ADM_PROC_M VALUES ('P_SYS0012_GET_APPROVAL_LIST', 'O_RESULT_CURSOR','OUT', 'PROC_RESULT', N+1, ...);  -- ⭐ 대문자
```

**SAVE/MUTATION SP**: 데이터 반환 없으므로 `O_RESULT_CURSOR` 단일 cursor 허용 (CRUD response 만 필요).

**Cross-ref**: hook `sp-dual-cursor-pattern.md`, 메모리 `feedback_sp_dual_out_cursor_pattern`.

### §2.4.2 ⭐ Audit 검사 표준 (2026-06-06 추가)

> AXIS 3-B audit 의 검사 기준은 **DATA_TP_CD 기반** (COL_NM 기반 X).

| 검사 항목 | 정확 패턴 |
|---|---|
| Data cursor 존재 | `COL_TP_CD='OUT' AND DATA_TP_CD='CURSOR'` ≥ 1 |
| Result cursor 존재 | `COL_TP_CD='OUT' AND DATA_TP_CD='PROC_RESULT' AND UPPER(COL_NM)='O_RESULT_CURSOR'` ≥ 1 |

**COL_NM 기반 검사 금지 이유 (false positive 사례)**:
- COL_NM 이 custom 이름 (`fcstNPrice` / `drop1~4` / `column` / `measure` / `purchase` 등) 일 때 `IN ('o_rc','o_rc1','o_rc2')` 매칭 X → 잘못 위반 분류
- COL_NM `o_result_cursor` 소문자 등록 시 case-sensitive 매칭 X → 잘못 위반 분류

**참조**: `_artifacts/80_screen_4axis_audit.sql` BLOCK 3 / AXIS 3-B (DATA_TP_CD 기준).

**자동 변환 SQL 템플릿** (AS-IS SP body 에서 IN/OUT 추출):

```sql
-- 1. AS-IS .pkg / .sql 파일 의 PROCEDURE / IN 인자 추출
-- 2. P_X_Y → xY (camelCase) 변환
-- 3. INSERT SELECT FROM (...) NEW WHERE NOT EXISTS 패턴으로 BLOCK 4 작성
-- 4. 카운트 검증 (총 IN/OUT 카운트 = SCM_ADM_PROC_M 안 카운트)
```

### §2.5 BLOCK 5 — API endpoint (`SCM_ADM_API_M`)

```sql
INSERT INTO SCM_ADM_API_M (MNU_ID, SHT_NM, ACTION_TP, API_URL, API_TP_CD, API_MSG_ID, ...)
SELECT 'DMF0099', 'main', 'RETRIEVE', 'PKG_DMF0099.P_GET_MAIN', 'PKG_PROC', 'MSG_API_DMF0099_MAIN_RETRIEVE', ... FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM SCM_ADM_API_M WHERE MNU_ID='DMF0099' AND SHT_NM='main' AND ACTION_TP='RETRIEVE');
```

**⚠️ 의무 (메모리 `reference_scm_adm_api_m_ddl.md`)**:
- `API_TP_CD` **NOT NULL** (PKG_PROC / STANDALONE / WRAPPER)
- `API_MSG_ID` **NOT NULL** (FK 없음). 표준 형식: `MSG_API_{MENU}_{SHEET_UPPER}_{ACTION}` (예: `MSG_API_DMF0099_MAIN_RETRIEVE`)
- BLOCK 1 에 i18n 동반 INSERT 의무
- API_URL: 
  - standalone SP: `P_DMF0099_GET_MAIN`
  - PKG 안: `PKG_DMF0099.P_GET_MAIN`
  - 혼동 시 `PLS-00302 구성요소 정의되어야 합니다` 사고 (메모리 `feedback_standalone_vs_pkg_proc_api_url`)

### §2.6 BLOCK 6 — Sheet columns (`SCM_ADM_MNU_M_SHEET_COLUMNS`)

```sql
INSERT INTO SCM_ADM_MNU_M_SHEET_COLUMNS (MNU_ID, SHT_NM, COL_NM, COL_HEAD, COL_WIDTH, COL_ALIGN, 
    INPUT_TP_CD, CTRL_TP_CD, MODAL_KEY, IS_REQUIRED, IS_DISPLAY, ORDR_NO, USE_YN, ...) 
SELECT 'DMF0099', 'main', 'PROJECT_CODE', 'Project Code', 100, 'center', 
    'IO', 'FPModal', 'PROJECT', 'Y', 'N', 5, 'Y', ... FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM SCM_ADM_MNU_M_SHEET_COLUMNS WHERE MNU_ID='DMF0099' AND SHT_NM='main' AND COL_NM='PROJECT_CODE');
```

→ 룰 08 column meta 상세 참조.

### §2.7 BLOCK 7 — 권한 2 테이블

```sql
-- 메뉴 권한 (USER_GR_MNU_MPG_M)
INSERT INTO SCM_ADM_USER_GR_MNU_MPG_M (USER_ID, GR_ID, MNU_ID, FIND_AUTH_YN, INSERT_AUTH_YN, EDIT_AUTH_YN, SAVE_AUTH_YN, DELETE_AUTH_YN, ...)
SELECT 'minyonglee1', 'ADMIN', 'DMF0099', 'Y', 'Y', 'Y', 'Y', 'Y', ... FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM SCM_ADM_USER_GR_MNU_MPG_M WHERE USER_ID='minyonglee1' AND GR_ID='ADMIN' AND MNU_ID='DMF0099');

-- 버튼 권한 (USER_GR_MNU_BTN_MPG_M) — 5 버튼 모두
INSERT INTO SCM_ADM_USER_GR_MNU_BTN_MPG_M (USER_ID, GR_ID, MNU_ID, BTN_ID, AUTH_YN, ...)
SELECT 'minyonglee1', 'ADMIN', 'DMF0099', 'FIND', 'Y', ... FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM SCM_ADM_USER_GR_MNU_BTN_MPG_M WHERE USER_ID='minyonglee1' AND GR_ID='ADMIN' AND MNU_ID='DMF0099' AND BTN_ID='FIND');
-- (INSERT/EDIT/SAVE/DELETE 동일 반복)
```

**의무**:
- 형제 메뉴에서 동적 복제 (hardcoding 그룹 금지 — UPPR_MNU_ID 형제 메뉴의 권한 복사)
- 누락 시 'No Permission' 오류

---

## §3 Lookup combo SQL (`SCM_ADM_CMBO_SQL_M`)

### §3.1 등록 인벤토리

> 메모리 `reference_combo_sql_id_inventory.md`: 52 등록 키. 신규 화면이 사용하는 lookup SQL_ID 는 등록 필수.

| AS-IS lookup | TO-BE SQL_ID | 비고 |
|---|---|---|
| MyDivision | `MyDivision` | 권한 있는 division |
| UserTeamByDivision | `TeambyDivision` | naming 변경 |
| EndCustomerByDivision | `EndCustomerByDivisionDept` | dept 추가 |
| UserSiteByEndCustomer | `SiteByEndCustomer` | |
| CURRENCY_LIST | `CurrencyList` | |
| INCOTERMS | `Incoterms` | |
| ... (총 52) | ... | |

→ FE useTabComboQueries filter 키 = TO-BE SQL_ID.

### §3.2 신규 lookup 추가 (AS-IS Combo → TO-BE 마이그레이션, 5 단계)

> 메모리 `feedback_combo_migration_asis_to_tobe.md`:

1. **인벤토리 매칭 grep** — 메모리 인벤토리 52 SQL_ID 안에서 검색
2. **AS-IS .cs SetChangeControl + DataService.cs case 분기** + `SCM_ADM_LOOKUP_MASTER_DETAIL` 빠른 경로 확인
3. **Oracle 19c 호환 SQL 변환** (`UF_FX_STRING_SPLIT` 등)
4. **NOT EXISTS INSERT** (멱등)
5. **검증 + 인벤토리 / 카탈로그 갱신**

```sql
INSERT INTO SCM_ADM_CMBO_SQL_M (SQL_ID, SQL_CTN, USE_YN, ...)
SELECT 'NewLookupId', 
    'SELECT CODE, NAME FROM SCM_MST_X WHERE DIVISION_ID = TO_CHAR(@divisionId) AND USE_YN = ''Y'' ORDER BY CODE', 
    'Y', ... FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM SCM_ADM_CMBO_SQL_M WHERE SQL_ID = 'NewLookupId');
```

### §3.3 @varName quote 의무 (메모리 사고)

> 메모리 `feedback_oracle_cmbo_quote_pitfall.md`:

**금지** (사고 패턴):
```sql
SQL_CTN: 'SELECT ... WHERE SEGMENT1 = @divisionId AND USE_YN = @useYn'
-- BE 가 quote 없이 raw 치환: WHERE SEGMENT1 = 81 → 다른 row SEGMENT1='81_UC' 와 비교 시 ORA-01722 (NUMBER conversion)
```

**의무**:
```sql
SQL_CTN: 'SELECT ... WHERE SEGMENT1 = TO_CHAR(@divisionId) AND USE_YN = TO_CHAR(@useYn)'
-- 또는 NVL 처리
SQL_CTN: 'SELECT ... WHERE NVL(SEGMENT1, '''') = TO_CHAR(@divisionId)'
```

→ MSSQL `<> ''` → Oracle `IS NOT NULL` 변환 (Oracle 의 `''` = NULL 룰).

---

## §4 MSSQL → Oracle 변환 표준

### §4.1 키워드 변환 표 (룰 21 §변환)

| MSSQL | Oracle | 메모 |
|---|---|---|
| `DATEADD(day, 1, GETDATE())` | `SYSDATE + 1` 또는 `ADD_MONTHS(SYSDATE, n)` | 일 단위 = `+1`, 월 = ADD_MONTHS |
| `GETDATE()` | `SYSDATE` | |
| `ISNULL(X, Y)` | `NVL(X, Y)` 또는 `COALESCE(X, Y)` | |
| `IIF(cond, a, b)` | `CASE WHEN cond THEN a ELSE b END` | |
| `CHARINDEX(s, str)` | `INSTR(str, s)` | 인자 순서 반대 |
| `STRING_SPLIT(s, ',')` | `UF_FX_STRING_SPLIT(s, ',')` (커스텀 함수 — 룰 29 §splitfunction) |
| `N'문자열'` (NVARCHAR) | `'문자열'` | Oracle 는 N prefix 불필요 |
| `WITH (NOLOCK)` | (제거) | Oracle 는 MVCC, NOLOCK 불필요 |
| `TOP N` | `WHERE ROWNUM <= N` 또는 `FETCH FIRST N ROWS ONLY` | |
| `[표명].[컬럼]` | `"표명"."컬럼"` | 대문자 quote |
| `+` (문자열 concat) | `\|\|` (Oracle concat) | |
| `LEN(str)` | `LENGTH(str)` | |
| `CONVERT(VARCHAR, X)` | `TO_CHAR(X)` | |
| `CAST(X AS DATETIME)` | `TO_DATE(X, 'YYYYMMDD')` | format 명시 |
| `''` (빈 string) | (NULL 동등) | `IS NOT NULL` 사용 |

### §4.2 PL/SQL 표준 패턴

```sql
CREATE OR REPLACE PROCEDURE P_DMF0099_GET_MAIN (
    P_USER_ID    IN VARCHAR2,
    P_DIVISION   IN VARCHAR2,
    O_RC1        OUT SYS_REFCURSOR,
    O_MSG        OUT VARCHAR2,
    O_CD         OUT VARCHAR2
) AS
BEGIN
    OPEN O_RC1 FOR
        SELECT ... 
        FROM SCM_MST_X
        WHERE DIVISION_ID = NVL(P_DIVISION, DIVISION_ID);
    
    O_MSG := 'success';
    O_CD := '0';
EXCEPTION
    WHEN OTHERS THEN
        O_MSG := SQLERRM;
        O_CD := '1';
END;
/
```

### §4.3 RETURNING CLOB 사고 (룰 21 §12 / Phase 1 Stage 3b)

**⚠️ 주의 (Oracle 23ai)**:
```sql
JSON_OBJECT(... RETURNING CLOB)   -- ⚠️ PL/SQL 안에서 PLS-00684 거부
```

→ PL/SQL 안에서는 `JSON_OBJECT` 의 `RETURNING CLOB` 절 사용 시 PLS-00684. SQL context 에서만 사용 가능. PL/SQL 안에서는 VARCHAR2(4000) 또는 DBMS_LOB 으로 처리.

### §4.4 LISTAGG 의 ON OVERFLOW

```sql
LISTAGG(col, ',') WITHIN GROUP (ORDER BY col)
    ON OVERFLOW TRUNCATE WITH COUNT   -- 4000 byte 초과 시 자동 truncate
```

→ ON OVERFLOW 는 LISTAGG 인자 안 위치 (WITHIN GROUP 뒤가 아님).

### §4.5 GTT (Global Temporary Table) 패턴

```sql
-- GTT 정의 (DDL — 1 번만)
CREATE GLOBAL TEMPORARY TABLE GT_DMF0099_MAIN (
    ...
) ON COMMIT PRESERVE ROWS;

-- SP 안 사용
DELETE FROM GT_DMF0099_MAIN;   -- ⚠️ 의무 (메모리 — DELETE 누락 시 잔존 row 사고)
INSERT INTO GT_DMF0099_MAIN SELECT ...;
SELECT ... FROM GT_DMF0099_MAIN;
```

→ Phase 1 Stage 3d/3e audit 결과: GTT DELETE 누락 38 proc / 203 GT_* INSERT.

---

## §5 신규 SP 작성 표준 + 메타 등록 cross-check

### §5.1 SP body 표준

```sql
CREATE OR REPLACE PROCEDURE P_DMF0099_GET_MAIN (
    P_USER_ID    IN  VARCHAR2,
    P_LANG_CD    IN  VARCHAR2,
    P_MENU_ID    IN  VARCHAR2,
    P_DIVISION   IN  VARCHAR2,
    P_DEPT_ID    IN  VARCHAR2,
    O_RC1        OUT SYS_REFCURSOR,
    O_MSG        OUT VARCHAR2,
    O_CD         OUT VARCHAR2
) AS
BEGIN
    OPEN O_RC1 FOR
        SELECT a.PROJECT_CODE, a.PROJECT_NAME, ...
        FROM SCM_MST_PROJECT a
        WHERE a.DIVISION_ID = NVL(P_DIVISION, a.DIVISION_ID)
          AND a.DEPT_ID     = NVL(P_DEPT_ID, a.DEPT_ID)
          AND a.USE_YN      = 'Y';
    
    O_MSG := 'success';
    O_CD := '0';
EXCEPTION WHEN OTHERS THEN
    O_MSG := SQLERRM; O_CD := '1';
END;
/
```

### §5.2 메타 등록 동반 의무

```sql
-- BLOCK 4: SCM_ADM_PROC_M 5 IN + 3 OUT = 8 row
INSERT INTO SCM_ADM_PROC_M ... ('P_DMF0099_GET_MAIN', 'sesUserId', 'IN', 1, 'VARCHAR2', 20, ...);
INSERT INTO SCM_ADM_PROC_M ... ('P_DMF0099_GET_MAIN', 'sesLangCd', 'IN', 2, 'VARCHAR2', 5, ...);
INSERT INTO SCM_ADM_PROC_M ... ('P_DMF0099_GET_MAIN', 'mnuId', 'IN', 3, 'VARCHAR2', 20, ...);
INSERT INTO SCM_ADM_PROC_M ... ('P_DMF0099_GET_MAIN', 'divisionId', 'IN', 4, 'VARCHAR2', 20, ...);
INSERT INTO SCM_ADM_PROC_M ... ('P_DMF0099_GET_MAIN', 'deptId', 'IN', 5, 'VARCHAR2', 20, ...);
INSERT INTO SCM_ADM_PROC_M ... ('P_DMF0099_GET_MAIN', 'o_rc1', 'OUT', 1, 'SYS_REFCURSOR', 0, ...);
INSERT INTO SCM_ADM_PROC_M ... ('P_DMF0099_GET_MAIN', 'o_msg', 'OUT', 2, 'VARCHAR2', 4000, ...);
INSERT INTO SCM_ADM_PROC_M ... ('P_DMF0099_GET_MAIN', 'o_cd', 'OUT', 3, 'VARCHAR2', 10, ...);

-- BLOCK 5: SCM_ADM_API_M
INSERT INTO SCM_ADM_API_M ... ('DMF0099', 'main', 'RETRIEVE', 'PKG_DMF0099.P_GET_MAIN', 'PKG_PROC', 'MSG_API_DMF0099_MAIN_RETRIEVE', ...);
```

---

## §6 PR 직전 검증 명령

```bash
SQL_DIR="_artifacts"
DEPLOY_SQL="$SQL_DIR/{N}_{MENU_ID}_metadata.sql"

# 1. DBeaver 호환 검증 (메모리 룰)
grep -nE "^SET|^PROMPT|^DEFINE|^&\w|^/$" "${DEPLOY_SQL%.sql}_DBeaver.sql" | wc -l   # = 0

# 2. NOT EXISTS 멱등 패턴 사용 (재실행 가능)
grep -c "WHERE NOT EXISTS" "$DEPLOY_SQL"   # ≥ 7 (BLOCK 1~7 모두)
grep -c "INSERT ALL" "$DEPLOY_SQL"   # = 0 (사용 금지)

# 3. UPPR_MNU_ID 대소문자 검증
grep -E "UPPR_MNU_ID\s*=\s*'(DEMAND_MASTER|MASTER|DEMAND|REPORT)'" "$DEPLOY_SQL"   # 대문자 = 0
# 의무: 'Demand_Master' / 'Master' / 'Demand' / 'Report' (PascalCase)

# 4. SHT_NM 표준 검증
grep -E "SHT_NM\s*=\s*'(futurePrice|salesSite|customerFcst)'" "$DEPLOY_SQL"   # 자유명 = 0
# 의무: 'main' 또는 자매 화면 표준

# 5. SCM_ADM_PROC_M 의 표준 COL_NM
grep -cE "'sesUserId'|'sesLangCd'|'mnuId'" "$DEPLOY_SQL"   # ≥ 3 (모든 SP 가 3 표준 IN)
grep -cE "'createdBy'|'lastUpdatedBy'" "$DEPLOY_SQL"       # As-Is 변환 SP (P_CREATED_BY/P_LAST_UPDATED_BY) 매핑용

# 6. SCM_ADM_API_M 의 API_TP_CD + API_MSG_ID NOT NULL
awk '/INSERT INTO SCM_ADM_API_M/,/WHERE NOT EXISTS/' "$DEPLOY_SQL" | grep -c "API_TP_CD"   # ≥ 1 per row
awk '/INSERT INTO SCM_ADM_API_M/,/WHERE NOT EXISTS/' "$DEPLOY_SQL" | grep -c "API_MSG_ID"   # ≥ 1 per row

# 7. MSSQL 키워드 잔존
grep -nE "DATEADD\(|CHARINDEX\(|GETDATE\(\)|ISNULL\(|IIF\(|WITH \(NOLOCK\)" "$DEPLOY_SQL" | wc -l   # = 0

# 8. CMBO_SQL_M 의 @varName quote 의무 (메모리 사고)
grep -nE "@\w+\s*[)=]" "$DEPLOY_SQL" | grep -v "TO_CHAR(@\|NVL(@\|@varname.*'" | wc -l   # = 0 (raw @var 없음)
```

---

## §7 AS-IS → TO-BE SP 변환 표준 (메모리 룰)

### §7.1 변환 의무 (메모리 `feedback_asis_to_tobe_sp_no_omission.md`)

> "AS-IS PKG body 의 모든 JOIN/필터/case/PIVOT/권한 logic 을 1:1 의미 보존. 단순화/임시 stub/생략 절대 금지."

**의무**:
- AS-IS .pkg body 처음 ~ 끝 모두 read
- 모든 JOIN / WHERE / CASE / PIVOT / EXISTS / NOT IN 1:1 보존
- 변환 불가 항목 (Oracle 23ai 미지원) 시 사용자 명시 보고 후 결정

**금지**:
- "wrapper 가 ALL → '' 변환" 패턴 (메모리 `feedback_wrapper_sp_no_all_transform.md` 사고)
- 임시 stub (`-- TODO: implement`)
- 부분 구현 (필터 일부 누락)

### §7.2 PIVOT 동적 컬럼 SP (DMF0007 / DMF0020 패턴)

```sql
CREATE OR REPLACE PROCEDURE P_DMF0099_GET_PIVOT (
    P_USER_ID    IN VARCHAR2,
    P_DIVISION   IN VARCHAR2,
    P_START_DT   IN VARCHAR2,
    P_END_DT     IN VARCHAR2,
    O_RC1        OUT SYS_REFCURSOR,
    O_RC_DATES   OUT SYS_REFCURSOR,   -- ⭐ 동적 컬럼 정보 (헤더)
    O_MSG        OUT VARCHAR2,
    O_CD         OUT VARCHAR2
) AS
    V_SQL CLOB;
BEGIN
    -- O_RC_DATES: 동적 컬럼 명세
    OPEN O_RC_DATES FOR
        SELECT TO_CHAR(d, 'YYYYMMDD') AS DT_CD, TO_CHAR(d, 'MM/DD') AS DT_NM
        FROM (SELECT TO_DATE(P_START_DT, 'YYYYMMDD') + LEVEL - 1 AS d
              FROM DUAL CONNECT BY LEVEL <= (TO_DATE(P_END_DT, 'YYYYMMDD') - TO_DATE(P_START_DT, 'YYYYMMDD') + 1));
    
    -- O_RC1: 동적 PIVOT
    V_SQL := 'SELECT *
              FROM (SELECT DIVISION, ITEM_ID, TO_CHAR(EVENT_DT, ''YYYYMMDD'') AS DT, QTY FROM SCM_X)
              PIVOT (SUM(QTY) FOR DT IN (';
    -- DT 별 컬럼 생성 (반복)
    -- ... 생략 ...
    V_SQL := V_SQL || '))';
    
    OPEN O_RC1 FOR V_SQL;
    O_MSG := 'success'; O_CD := '0';
END;
/
```

→ AS-IS dynamic column 화면 = TO-BE 동적 PIVOT SP. O_RC_DATES + O_RC1 분리.

---

## §8 도구 (`_artifacts/_bulk_fix_v2_converted/` 와 `_diagnostics/`)

> Phase 1 Stage 4 (`_artifacts/_diagnostics/`):

| 도구 | 용도 |
|---|---|
| `sp_body_diff.sh` | AS-IS vs TO-BE SP body 비교 |
| `row_count_diff.sh` | 데이터 row count 비교 (AS-IS DB vs TO-BE DB) |
| `column_inventory.sh` | 컬럼 인벤토리 cross-check |

→ DMF0043 row_count_diff 결과 As-Is 1.5M / To-Be 27K (98% 누락) — Phase 5 검증 시 활용.

---

## §9 자동 검증 (PR 머지 게이트)

```bash
# §6 의 검증 명령 8 종 모두 통과 = PASS

# 추가: 신규 화면 메타 SQL 4 파일 세트 존재 검증
test -f "$SQL_DIR/{N}_{MENU_ID}_metadata.sql"
test -f "$SQL_DIR/{N}_{MENU_ID}_metadata_DBeaver.sql"
test -f "$SQL_DIR/{N}_{MENU_ID}_metadata_Verify.sql"
test -f "$SQL_DIR/{N}_{MENU_ID}_metadata_Diagnose.sql"

# Verify 실행 (BLOCK 1~7 모두 row > 0 확인)
sqlplus -L "$DB_CONN" @"$SQL_DIR/{N}_{MENU_ID}_metadata_Verify.sql"
```

---

## §10 AS-IS 매핑

| AS-IS | TO-BE |
|---|---|
| `SCM.SCM_SYS_GET_SPREAD_TITLE` SP | `DMF0002_GET_TITLESET_POPUP` (ColumnSettingModal — 룰 10 §1) |
| MSSQL DB schema (LGCE_SCMDEV / LGCE_SCMPROD) | Oracle 19c (TO-BE) — 룰 29 CSV 적재 표준 |
| `SCM.SCM0002_GET_PROJECT_BY_DIVISION_POPUPEX` | `P_SCM0002_GET_PROJECT_BY_DIVISION_POPUPEX` (1:1 변환) |
| `DataService.GetDMInnerTable("MyDivision")` | `useTabComboQueries({ filters: ['MyDivision'] })` + lookup SQL 등록 |
| `FoxDataClient → AppService.GeneralExecuteQuery` | `POST /api/proc/{menuId}/{sheetName}/{tabId}` + 메타 4 테이블 분기 |

---

## §11 reference 위치

| 위치 | 용도 |
|---|---|
| `_artifacts/` | 신규 화면 메타 SQL 4 파일 세트 |
| `_artifacts/_diagnostics/` | AS-IS vs TO-BE 비교 도구 |
| `_artifacts/_bulk_fix_v2_converted/` | Phase 1 Stage 3 SP body fix (SUBSTR / CLOB / LISTAGG) |
| `To-be_v2_converted/` | DB 변환 산출물 (Phase 0 변환) |
| `Doc/_analysis/db_migration/01_MSSQL_to_Oracle_Conversion_Rules.md` | MSSQL → Oracle 변환 룰 |

---

## §13 MNU_BTN_CD 표준 (2026-06-09 강화)

### §13.1 표준 button code 인벤토리

| MNU_BTN_CD | 용도 | FE 호출 |
|---|---|---|
| `SEARCH` | 조회 (메인) | `useTabProcQuery` default |
| `SAVE` | 저장 | `useProcMutation` default |
| `EXCELDOWN` | Excel 다운로드 | SubTitle 자동 |
| `EXCELUPLOAD` | Excel 업로드 | upload action |
| (화면 특화) APPROVE / REJECT / EXECUTE / REQUEST 등 | 특화 액션 | `useProcMutation` + `procedureAction='APPROVE' as never` |

### §13.2 anti-pattern: `RETRIEVE` 사용 금지

```sql
-- ❌ AS-IS 변환 잔재 — SCM0009 / SCM0005 동일 사고
INSERT INTO USER_GR_MNU_BTN_MPG_M VALUES (..., 'RETRIEVE', ...);
```

→ FE 의 `useTabProcQuery` default action 은 `'SEARCH'`. 권한 체크 시 SEARCH 권한 없음 → **"권한없음"** 응답.

```sql
-- ✅ 의무 — SEARCH 사용
INSERT INTO USER_GR_MNU_BTN_MPG_M VALUES (..., 'SEARCH', ...);
```

### §13.3 MNU_BTN_MPG_M ↔ USER_GR_MNU_BTN_MPG_M 일관성 의무

| 테이블 | MNU_BTN_CD |
|---|---|
| `MNU_BTN_MPG_M` (메뉴-API 매핑) | SEARCH / SAVE / EXECUTE / ... |
| `USER_GR_MNU_BTN_MPG_M` (그룹 권한) | **동일 값 의무** |

→ 양쪽 다른 값 (예: MNU_BTN_MPG_M 은 SEARCH, USER_GR... 은 RETRIEVE) 시 "권한없음" 발생.

### §13.4 자동 검증 SQL

```sql
SELECT M.MNU_ID, M.SHT_NM, M.MNU_BTN_CD AS MAPPED, U.MNU_BTN_CD AS GRANTED
  FROM SCM_ADM_MNU_BTN_MPG_M M
  LEFT JOIN SCM_ADM_USER_GR_MNU_BTN_MPG_M U
    ON U.MNU_ID = M.MNU_ID AND U.SHT_NM = M.SHT_NM
   AND U.MNU_BTN_CD = M.MNU_BTN_CD
 WHERE U.MNU_BTN_CD IS NULL;
-- 결과 = 0 의무 (모든 MNU_BTN_MPG_M 에 대응 USER_GR_MNU_BTN_MPG_M 권한 존재)
```

### §13.5 cross-ref

- 메모리 `feedback_button_code_consistency_search_vs_retrieve`
- 사고: SCM0009 (2026-06-06), SCM0005 (2026-06-09)

---

## §14 SHEET_COLUMNS 일괄 dedupe 표준 (2026-06-09 신규)

### §14.1 사고

SCM_MST_SHEET_COLUMNS 의 (PROGRAM_ID, SHEET_NAME, COLUMN_NAME) 별 2회 INSERT 누적 → 모든 row 가 정확히 2배. 2026-06-09 전역 점검 시 357 program / 755 sheet / 15,167 dup row 검출.

### §14.2 전역 dedupe SQL

```sql
DELETE FROM SCM_MGR.SCM_MST_SHEET_COLUMNS X
 WHERE X.ROWID NOT IN (
   SELECT MIN(Y.ROWID)
     FROM SCM_MGR.SCM_MST_SHEET_COLUMNS Y
    GROUP BY Y.PROGRAM_ID, Y.SHEET_NAME, Y.COLUMN_NAME
 );
COMMIT;
```

→ `(PROGRAM_ID, SHEET_NAME, COLUMN_NAME)` PK 별 `MIN(ROWID)` 유지.

### §14.3 재발 방지 — 메타 INSERT 멱등 의무

```sql
-- ✅ NOT EXISTS pattern (표준 의무)
INSERT INTO SCM_MGR.SCM_MST_SHEET_COLUMNS (...)
SELECT ... FROM (SELECT ... FROM DUAL UNION ALL ...) NEW
WHERE NOT EXISTS (
  SELECT 1 FROM SCM_MGR.SCM_MST_SHEET_COLUMNS X
   WHERE X.PROGRAM_ID = NEW.PROGRAM_ID
     AND X.SHEET_NAME = NEW.SHEET_NAME
     AND X.COLUMN_NAME = NEW.COLUMN_NAME
);
```

```sql
-- ❌ 금지 — INSERT ALL 또는 단순 INSERT (재실행 시 dup 누적)
INSERT INTO SHEET_COLUMNS (...) VALUES (...);
```

### §14.4 cross-ref

- `_artifacts/65_GLOBAL_SHEET_COLUMNS_dedupe_all.sql` (전역 dedupe 적용 기록)
- 메모리 `feedback_sql_idempotent_insert_all` (기존)

---

## §15 CMBO_SQL_M `@varName` BE 자동 채움 표 (2026-06-07 신규, DMF0003)

> DMF0003 (MKT FCST) Insert dropdown 사고 — `BizType` SQL 의 `@divisionId` 가 0 row 반환.
> 원인: BE 가 자동 채움하는 `@varName` 은 **시스템 키만**. 그 외 변수는 FE 측에서 객체 filter 명시 전달 필수.

### §15.1 자동 채움 시스템 키 (이것만 string filter 가능)

| `@varName` | BE 자동 채움 | 채움 소스 |
|---|---|---|
| `@sesUserId` | ✅ | session 의 USER_ID |
| `@sesLangCd` | ✅ | session 의 LANG_CD |
| `@langCd` | ✅ | session 의 LANG_CD (alias) |
| `@mnuId` | ✅ | 호출 화면 MENU_ID |

### §15.2 명시 전달 필수 변수 (객체 filter 의무)

| `@varName` | 채움 방식 | 위반 시 |
|---|---|---|
| `@divisionId` | ❌ 자동 X — `{ comboId, divisionId: '...' }` | 0 row 반환 → dropdown 빈 |
| `@endCustomer` | ❌ 자동 X — `{ comboId, endCustomer: '...' }` | 동일 |
| `@projectCode` | ❌ 자동 X | 동일 |
| 그 외 사용자 정의 | ❌ 자동 X | 동일 |

### §15.3 SQL 작성 권장

```sql
-- ✅ 변수 없는 SQL (자동 채움 X 변수 회피) — FE string filter 가능
-- BizType (전 div distinct + DIVISION_ID 결과 컬럼 + FE filter)
SELECT DISTINCT DIVISION_ID, BIZ_TYPE_NAME AS CODE, BIZ_TYPE_NAME AS NAME
  FROM SCM_MST_PROJECT
 WHERE BIZ_TYPE_NAME IS NOT NULL
 ORDER BY DIVISION_ID, BIZ_TYPE_NAME

-- ✅ @sesUserId 자동 채움 활용 — FE string filter 가능
SELECT DISTINCT A.DIVISION_ID, ...
  FROM SCM_MST_SITE A
 WHERE A.DIVISION_ID IN (
   SELECT UNIT_ID FROM SCM_ADM_USER_GR_UNIT_AUTH_MPG_M
    WHERE USER_ID = @sesUserId AND UNIT_TP_CD = 'D'
 )

-- ⚠️ @divisionId 사용 SQL — FE 객체 filter 의무
SELECT SEGMENT2 AS CODE, SEGMENT2 AS NAME
  FROM SCM_ADM_LOOKUP_MASTER_DETAIL
 WHERE LOOKUP_TYPE = 'BP_CUSTOMS_HANDBOOK' AND VALID_YN = 'Y'
   AND SEGMENT1 = TO_CHAR(@divisionId)
```

### §15.4 FE 호출 패턴

```tsx
// ✅ 변수 없거나 @sesUserId 만 — string filter
filters: ['EndCustomer', 'BizType', 'Incoterms', 'PlantSite', 'Measure']

// ✅ @divisionId 사용 SQL — 객체 filter
filters: [
  { comboId: 'FcstType', divisionId: sc.divisionId },
  { comboId: 'CustomsHandbook', divisionId: sc.divisionId },
  { comboId: 'SiteByEndCustomer', divisionId: sc.divisionId, endCustomer: 'ALL' },
]
```

### §15.5 자매 검증 SQL_ID 인벤토리

| SQL_ID | 변수 | 결과 컬럼 | string OK? |
|---|---|---|---|
| `MyDivision` | `@sesUserId` | CODE/NAME | ✅ |
| `TeambyDivision` | `@sesUserId`, `@langCd` | DIVISION_ID/CODE/NAME | ✅ |
| `EndCustomer` | `@sesUserId` | DIVISION_ID/DEPT_ID/CODE/NAME | ✅ |
| `EndCustomerByDivisionDept` | (없음) | DIVISION_ID/CODE/NAME | ✅ |
| `SalesSite` | `@sesUserId` | DIVISION_ID/.../CODE/NAME | ✅ |
| `SiteByEndCustomer` | `@divisionId`, `@endCustomer` | DIVISION_ID/EC/CODE/NAME | ❌ 객체 |
| `BizType` | (2026-06-07 fix: 없음) | DIVISION_ID/CODE/NAME | ✅ |
| `Incoterms` | (없음) | CODE/NAME | ✅ |
| `FcstType` | `@divisionId` | CODE/NAME | ❌ 객체 |
| `CustomsHandbook` | `@divisionId` | CODE/NAME | ❌ 객체 |
| `PlantSite` | `@sesUserId` | DIVISION_ID/CODE/NAME | ✅ |
| `Measure` | (없음) | CODE/NAME | ✅ |
| `CurrencyList` | (없음) | CODE/NAME | ✅ |

### §15.6 cross-ref

- hook `wijmo-insert-cell-dropdown.md §2` (CMBO 의무 + filter 패턴)
- 룰 `_tobe/06_search_area.md` (searchFields 카탈로그 SQL_ID 호출)
- 룰 `_tobe/07_datagrid.md §12` (Insert cell ComboBox)
- 메모리: `feedback_cmbo_sql_at_division_param`

---

## §12 변경 이력

| 일자 | 변경 | 이유 |
|---|---|---|
| 2026-06-03 | 초안 (Phase 3 추출) | 메타 SQL 7-BLOCK + MSSQL→Oracle + 멱등 INSERT + Lookup combo + 사고 메모리 통합 |
| 2026-06-09 | §13 MNU_BTN_CD 표준 (RETRIEVE 금지, SEARCH 의무) + §14 전역 SHEET_COLUMNS dedupe 표준 신설 | SCM0005/SCM0009 권한 사고 + 전역 dedupe 15,167 row |
| 2026-06-07 | §15 CMBO_SQL_M `@varName` BE 자동 채움 표 + 자매 검증 SQL_ID 인벤토리 신설 | DMF0003 BizType + EndCustomer dropdown 사고 (BE 자동 채움 추측 위반) |
