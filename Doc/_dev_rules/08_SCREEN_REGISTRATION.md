# 08. 신규 화면 메타 등록 RULE — 7개 영역 통합 가이드

> NSCM 은 **메타데이터 기반 동적 SP 호출 아키텍처**입니다.
> 신규 화면 1개를 동작시키려면 7개 메타 테이블에 데이터가 등록되어야 합니다.
> 본 문서는 SYS0001/SYS0003/SYS0004/SYS0005/SYS0006/SYS0008 의 7개 영역에 대해
> 등록 절차·SQL 패턴·자동화 갭·검증 방법을 정의합니다.

**작성 이력**
- 2026-05-19: 전면 개정 — 4개 테이블 기준 → 7개 영역 기준으로 확장
  - 누락 자동화 영역(i18n / Procedure 메타 / Group Menu / MNU_BTN_MPG 매핑) 명문화
  - 자동 등록 PKG 의 스키마 모순(`SCM_ADM_MENU_M` vs `SCM_ADM_MNU_M`, `SCM_ADM_API_M` 컬럼 불일치) 식별
- 2026-05-28: **`SCM_MST_SHEET_COLUMNS` 시드 표준 추가** ([`27_WIJMO_PIVOT_AND_MODULE.md §B`](27_WIJMO_PIVOT_AND_MODULE.md) 와 자매)
  - `SMALL_CLASS_LABEL_NAME = COLUMN_LABEL_NAME` 통일 의무 (의도된 grouping 제외) — Wijmo column header 세로 머지 발동 조건
  - 별표(`*`) 등 추가 문자 단독 부여 금지 (sCls != colLbl → 머지 깨짐)
  - 신규 sheet 등록 5종 테이블 + 권한 체크리스트 → [`27_WIJMO_PIVOT_AND_MODULE.md §D`](27_WIJMO_PIVOT_AND_MODULE.md)
  - Sheet name **대소문자 완전 일치** (FE enum vs BE `SHT_NM`) — 한 글자 차이도 ORA-01403

---

## §1. 동적 호출 아키텍처 (Why 7 areas?)

### 1.1 호출 흐름

```
[FE]  useTabProcQuery({ menuId='DMF0099', sheetName='main', filters })
   ↓  POST /DMF0099/main/SEARCH/call-proc
   ↓
[BE]  GeneralController → GeneralServiceImpl.execBtn(params)
   ↓
   ① PR_GET_PROC_INFO_LIST(mnuId, shtNm, mnuBtnCd)
      ├─ SELECT API_URL FROM SCM_ADM_MNU_BTN_MPG_M T1
      │  JOIN SCM_ADM_API_M T2 ON T1.API_ID = T2.API_ID
      │  WHERE T1.MNU_ID = :mnuId AND T1.SHT_NM = :shtNm AND T1.MNU_BTN_CD = :mnuBtnCd
      │  →  V_PROC_NM (예: 'PKG_DMF0099.P_DMF0099_GET_MAIN_DATA')
      └─ SELECT COL_NM, COL_TP_CD, DATA_TP_CD, SORT_ORD
         FROM SCM_ADM_PROC_M WHERE PROC_NM = V_PROC_NM
         →  ★ IN 파라미터 + OUT 커서 명세
   ↓
   ② makeProcedure(params, procInfo) 가 동적 CALL 문 조립
      {call PKG_DMF0099.P_DMF0099_GET_MAIN_DATA(
          #{divisionId, mode=IN, ...},
          #{@o_rc1, mode=OUT, jdbcType=CURSOR, resultMap=data1}, ...)}
   ↓
   ③ MyBatis 실행 → 결과 Map { o_rc1: [...rows] }
   ↓
[FE]  data.o_rc1 → Wijmo Grid
       (컬럼 정의는 별도로 GET /admin/menu/DMF0099/column 로 SCM_MST_SHEET_COLUMNS 조회)
```

> 근거 코드: `To-be_v2_converted/06_Packages/04_Package_PKG_NSCM_UI_COMM.sql:88-128` (`PR_GET_PROC_INFO_LIST`)

### 1.2 메타데이터의 역할

화면은 "어떤 SP 를 호출하는지" 알 필요가 없습니다. 메타 7개가 정확하면 동적 호출이 동작합니다.

→ **신규 화면 등록 = 7개 메타 영역 일괄 등록**

> ⚠ **2026-05-19 DMF0007 사례**: `SCM_ADM_PROC_M` 등록 누락 시 SP 가 호출되지 않거나 NULL 파라미터로 호출되어 빈 결과 반환. 7개 영역 중 1개라도 빠지면 화면이 동작하지 않거나 빈 데이터를 반환합니다.

---

## §2. 7개 영역 × 메타 테이블 매트릭스

| # | 영역 | 관리 화면 (SYS) | 실제 테이블 | PKG 자동화 | 단위 |
|---|---|---|---|---|---|
| 1 | **i18n (LBL/MSG/MNU)** | **SYS0001** | `SCM_ADM_MSG_M` | ❌ 누락 (DELETE만) | MSG_ID × LANG_CD(KO/EN/CN) |
| 2 | **MENU 마스터** | **SYS0003** | `SCM_ADM_MNU_M` ⚠ | ⚠ 오타 (PKG에서 `SCM_ADM_MENU_M` 사용) | MNU_ID 당 1행 |
| 3 | **UI Category (Sheet Columns)** | **SYS0004** | `SCM_MST_SHEET_COLUMNS` | ✅ | (PROGRAM_ID, SHEET_NAME, COL) 당 1행 |
| 4 | **Procedure 메타 (SP IN/OUT)** | **SYS0005** | `SCM_ADM_PROC_M` | ❌ 누락 (★ 가장 중요) | (PROC_NM, COL_NM) 당 1행 |
| 5 | **API 메타 (PKG.SP URL)** | **SYS0006** | `SCM_ADM_API_M` ⚠ | ⚠ 컬럼 불일치 | API_ID 당 1행 |
| 5-a | **API 라우팅 매핑** | (SYS0003 보조) | `SCM_ADM_MNU_BTN_MPG_M` | ❌ 누락 | (MNU_ID, SHT_NM, BTN_CD) 당 1행 |
| 6 | **Group MENU 권한** | **SYS0008** | `SCM_ADM_USER_GR_MNU_MPG_M` (+ `..._BTN_MPG_M`) | ⚠ 다른 테이블에 INSERT | (GR_ID, MNU_ID) 당 1행 |

> ⚠ 표시 = 현재 `PKG_NSCM_SCREEN_REGISTRATION.P_REGISTER_SCREEN` 의 동작이 실제 스키마와 불일치하는 영역. §8 로드맵 참조.

### 2.1 의존 선후

```
1. i18n         (LBL/MSG/MNU 코드는 다른 메타가 참조하므로 먼저 등록)
   ↓
2. MENU         (MNU_MSG_ID 가 1번을 참조)
   ↓
3. Procedure    (API URL 이 SP 이름을 가리키므로 PROC 메타가 먼저 등록되어 있어야 호출 가능)
   ↓
4. API + MNU_BTN_MPG  (MENU + PROC 둘 다 참조)
   ↓
5. Sheet Columns (PROGRAM_ID 가 MENU 참조)
   ↓
6. Group Menu   (MENU + USER_GROUP 참조)
```

---

## §3. 신규 화면 등록 표준 절차 (8 Step)

### ⭐ §3.0 모든 INSERT 의 절대 룰 (2026-05-22 신설 — DMF0020 ORA-01400 사고 반영)

NSCM 의 7-BLOCK 등록 SQL 작성 시 **모든 INSERT 문** 에 다음 룰을 적용:

#### 룰 1 — 표준 4 컬럼 항상 명시
모든 마스터 테이블의 4개 표준 컬럼은 **테이블 무관 INSERT 시 4개 모두 명시**:
- `CREATED_BY`
- `CREATION_DATE`
- `LAST_UPDATED_BY`   ⚠ **누락 빈번**
- `LAST_UPDATE_DATE`  ⚠ **누락 빈번**

DEFAULT 정책이 테이블마다 다르므로 (`DEFAULT 'SYSTEM'` / `DEFAULT SYSDATE` / **DEFAULT 없음**) 추측 일반화 금지. 8개 테이블 중 6개가 **DEFAULT 없는 NOT NULL** → INSERT 누락 시 ORA-01400.

| 테이블 | 4 컬럼 DEFAULT 정책 | 위험도 |
|---|---|:-:|
| `SCM_ADM_MSG_M` | DEFAULT 없음 | 🔴 |
| `SCM_ADM_MNU_M` | DEFAULT 없음 | 🔴 |
| `SCM_ADM_MNU_BTN_MPG_M` | DEFAULT 없음 | 🔴 |
| `SCM_MST_SHEET_COLUMNS` | DEFAULT 없음 | 🔴 |
| `SCM_ADM_USER_GR_MNU_MPG_M` | DEFAULT 없음 | 🔴 |
| `SCM_ADM_USER_GR_MNU_BTN_MPG_M` | DEFAULT 없음 | 🔴 |
| `SCM_ADM_PROC_M` | DEFAULT 'SYSTEM' / SYSDATE | 🟢 |
| `SCM_ADM_API_M` | DEFAULT 'SYSTEM' / SYSDATE | 🟢 |

→ **안전 룰**: 8개 테이블 모두 4컬럼 명시.

#### 룰 2 — INSERT 작성 직후 자기 검증

다중 INSERT 작성 후 다음 SQL 로 누락 검증 (개발 시):

```sql
-- 누락된 NOT NULL + DEFAULT 없는 컬럼 발견
SELECT TABLE_NAME, COLUMN_NAME
  FROM USER_TAB_COLS
 WHERE TABLE_NAME IN (
       'SCM_ADM_MSG_M', 'SCM_ADM_MNU_M', 'SCM_ADM_MNU_BTN_MPG_M',
       'SCM_MST_SHEET_COLUMNS', 'SCM_ADM_USER_GR_MNU_MPG_M',
       'SCM_ADM_USER_GR_MNU_BTN_MPG_M', 'SCM_ADM_PROC_M', 'SCM_ADM_API_M')
   AND NULLABLE = 'N'
   AND DATA_DEFAULT IS NULL
 ORDER BY TABLE_NAME, COLUMN_ID;
-- 결과 컬럼들을 모두 INSERT 문에 포함해야 함
```

#### 룰 3 — DDL 1차 소스 위치 주석

각 BLOCK 안의 INSERT 위에 DDL 위치를 주석으로 명시:

```sql
-- DDL: 02_GTT_OTHER_part4.sql:3292 (SCM_ADM_MSG_M)
-- NOT NULL + DEFAULT 없음: CREATED_BY / CREATION_DATE / LAST_UPDATED_BY / LAST_UPDATE_DATE
INSERT INTO SCM_ADM_MSG_M (...) VALUES (...);
```

→ 다른 작업자/AI 가 검증 시 동일 DDL 위치 재확인 가능.

#### 룰 4 — 첫 INSERT 검증 후 복사

다중 INSERT 작성 시:
1. 첫 INSERT 1줄을 완성
2. DDL 5층 cross-check (컬럼명/타입/NOT NULL/DEFAULT/CHECK)
3. 위 룰 2 의 자기 검증 SQL 실행 → 0행
4. **그 후에** 나머지 N-1줄을 동일 패턴으로 복사

→ 첫 줄 검증 없이 N줄 일괄 작성 금지 (오류 N 배 증폭).

→ 본 4 룰 자세히: [`hooks/anti-simplification.md`](hooks/anti-simplification.md) §1.4

---

### Step 1: PKG/SP 작성·컴파일

```sql
CREATE OR REPLACE PACKAGE SCM_MGR.PKG_DMF0099 AS
  PROCEDURE P_DMF0099_GET_MAIN_DATA (
    P_DIVISION_ID     IN  VARCHAR2,
    P_USER_ID         IN  VARCHAR2,
    P_MENU_ID         IN  VARCHAR2,
    O_RC1             OUT SYS_REFCURSOR,
    O_RESULT_CURSOR   OUT SYS_REFCURSOR
  );
  PROCEDURE P_DMF0099_SAVE_MAIN_DATA (
    P_DATA            IN  CLOB,
    P_USER_ID         IN  VARCHAR2,
    O_RESULT_CURSOR   OUT SYS_REFCURSOR
  );
END PKG_DMF0099;
/
```

> 패턴: 모든 GET SP 는 `O_RC1` (데이터 커서) + `O_RESULT_CURSOR` (상태 코드) 2개 반환. SAVE SP 는 `O_RESULT_CURSOR` 1개.

### Step 2: ★ i18n 등록 (`SCM_ADM_MSG_M`) — SYS0001 영역

화면이 사용하는 모든 다국어 코드를 KO/EN/CN 3개 언어로 등록.

> ⚠ **2026-05-22 룰 강화 (DMF0020 ORA-01400 사고 반영)**:
> `SCM_ADM_MSG_M` 의 `CREATED_BY` / `CREATION_DATE` / `LAST_UPDATED_BY` / `LAST_UPDATE_DATE` 4개 컬럼은
> **NOT NULL + DEFAULT 없음** (DDL: `02_GTT_OTHER_part4.sql:3299-3302`).
> → INSERT 시 **4개 모두 명시 의무**. 1개라도 누락 시 ORA-01400. `anti-simplification.md` §1.4 위반.

```sql
INSERT ALL
  -- 메뉴명 (4개 표준 컬럼 모두 명시 — NSCM 의무)
  INTO SCM_ADM_MSG_M (MSG_ID, LANG_CD, MSG_NM, MSG_TP_CD, USE_YN,
                      CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
    VALUES ('MNU_DMF0099', 'KO', '판매 모니터링', 'MNU', 'Y',
            'admin', SYSDATE, 'admin', SYSDATE)
  INTO SCM_ADM_MSG_M (MSG_ID, LANG_CD, MSG_NM, MSG_TP_CD, USE_YN,
                      CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
    VALUES ('MNU_DMF0099', 'EN', 'Sales Monitor', 'MNU', 'Y',
            'admin', SYSDATE, 'admin', SYSDATE)
  INTO SCM_ADM_MSG_M (MSG_ID, LANG_CD, MSG_NM, MSG_TP_CD, USE_YN,
                      CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
    VALUES ('MNU_DMF0099', 'CN', '销售监控', 'MNU', 'Y',
            'admin', SYSDATE, 'admin', SYSDATE)
SELECT * FROM DUAL;
COMMIT;
```

> 컬럼 근거: `nscm-be/src/main/resources/sql/admin/Message.xml`, `PKG_SYS0001.SYS0001_GET_MAIN_DATA`

### Step 3: ★ Procedure 메타 등록 (`SCM_ADM_PROC_M`) — SYS0005 영역

SP 시그니처의 IN/OUT 파라미터를 1행씩 등록. **이 단계 누락 시 DMF0007 사례처럼 빈 결과 반환**.

```sql
-- SP IN/OUT 자동 추출 (보조)
SELECT  NVL2(PACKAGE_NAME, PACKAGE_NAME||'.'||OBJECT_NAME, OBJECT_NAME) AS PROC_NM,
        ARGUMENT_NAME AS DB_COL_NM, POSITION, IN_OUT, DATA_TYPE
  FROM  ALL_ARGUMENTS
 WHERE  PACKAGE_NAME = 'PKG_DMF0099' AND OBJECT_NAME = 'P_DMF0099_GET_MAIN_DATA'
 ORDER BY POSITION;

-- 위 결과를 변환해서 INSERT (COL_NM 명명 규약은 §6 참조)
INSERT INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, COL_TP_CD, DATA_TP_CD, SORT_ORD,
                            CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
VALUES ('PKG_DMF0099.P_DMF0099_GET_MAIN_DATA', 'divisionId', 'IN', 'VARCHAR', 1, 'admin', SYSDATE, 'admin', SYSDATE);
-- ... userId, menuId, o_rc1, o_result_cursor 까지 모든 파라미터 반복
```

`COL_TP_CD`: `IN` / `OUT` | `DATA_TP_CD`: `VARCHAR` / `NUMBER` / `DATE` / `CLOB` / `CURSOR` / `PROC_RESULT` (O_RESULT_CURSOR 전용)

### Step 4: ★ Sheet Columns 등록 (`SCM_MST_SHEET_COLUMNS`) — 자기완결형 인라인 INSERT

JSON_TABLE 기반 인라인 INSERT (외부 PKG 의존성 없음, idempotent).

```sql
DECLARE
    v_col_json CLOB := '[
        {"sht_nm":"main","col_nm":"DIVISION_ID","col_lbl":"LBL00001","cell_tp":"FPText","col_wth":120,"sort_ord":1,"input_tp":"MANDATORY"},
        {"sht_nm":"main","col_nm":"YYYYMM",     "col_lbl":"LBL00100","cell_tp":"FPText","col_wth": 80,"sort_ord":2},
        {"sht_nm":"main","col_nm":"QTY",        "col_lbl":"LBL00200","cell_tp":"FPNumber","col_wth":100,"sort_ord":3,"scale":4,"align":"R"}
    ]';
    v_cnt NUMBER;
BEGIN
    DELETE FROM SCM_MST_SHEET_COLUMNS WHERE PROGRAM_ID = 'DMF0099';

    INSERT INTO SCM_MST_SHEET_COLUMNS (
        PROGRAM_ID, SHEET_NAME, COLUMN_NAME, COLUMN_LABEL_NAME, SORT_ORDER_NO,
        FIXED_FLAG, COLUMN_WIDTH, CELL_CONTROL_OBJECT_TYPE_CODE, CELL_COMBO_DATA_TYPE,
        DATA_SCALE_NUMBER, DATA_MAX_LENGTH, HORIZONTAL_ALIGN_CODE,
        UPPERCASE_APPLY_FLAG, VISIBLE_FLAG, DEFAULT_FLAG,
        USER_SELECTABLE_FLAG, VALID_YN, DIVISION_ID, INPUT_TP_CD,
        CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
    SELECT 'DMF0099', jt.SHT_NM, jt.COL_NM, jt.COL_LBL, jt.SORT_ORD,
           NVL(jt.FIXED, 'N'), NVL(jt.COL_WTH, 100), NVL(jt.CELL_TP, 'FPText'), jt.CELL_CBO,
           NVL(jt.SCALE, 0), NVL(jt.MAX_LEN, 200), NVL(jt.ALIGN, 'L'),
           NVL(jt.UPPER, 'N'), NVL(jt.VISIBLE, 'Y'), NVL(jt.DEFAULT_F, 'Y'),
           NVL(jt.USR_SEL, 'Y'), 'Y', NVL(jt.DIV_ID, 'ALL'), NVL(jt.INPUT_TP, 'OPTIONAL'),
           'admin', SYSDATE, 'admin', SYSDATE
      FROM JSON_TABLE(v_col_json, '$[*]' COLUMNS (
            SHT_NM VARCHAR2(50) PATH '$.sht_nm', COL_NM VARCHAR2(100) PATH '$.col_nm',
            COL_LBL VARCHAR2(200) PATH '$.col_lbl', SORT_ORD NUMBER PATH '$.sort_ord',
            FIXED VARCHAR2(1) PATH '$.fixed', COL_WTH NUMBER PATH '$.col_wth',
            CELL_TP VARCHAR2(50) PATH '$.cell_tp', CELL_CBO VARCHAR2(100) PATH '$.cell_cbo',
            SCALE NUMBER PATH '$.scale', MAX_LEN NUMBER PATH '$.max_len',
            ALIGN VARCHAR2(1) PATH '$.align', UPPER VARCHAR2(1) PATH '$.upper',
            VISIBLE VARCHAR2(1) PATH '$.visible', DEFAULT_F VARCHAR2(1) PATH '$.default_f',
            USR_SEL VARCHAR2(1) PATH '$.usr_sel', DIV_ID VARCHAR2(100) PATH '$.div_id',
            INPUT_TP VARCHAR2(50) PATH '$.input_tp')) jt;
    v_cnt := SQL%ROWCOUNT;
    DBMS_OUTPUT.PUT_LINE('Sheet Columns: '||v_cnt);
END;

COMMIT;
```

### Step 5: ★ API_ID ↔ `SCM_ADM_MNU_BTN_MPG_M` 매핑

실제 라우팅 SQL (`PR_GET_PROC_INFO_LIST`) 은 `SCM_ADM_MNU_BTN_MPG_M ⋈ SCM_ADM_API_M` 조인을 사용. 두 테이블 모두 INSERT.

```sql
-- 1) SCM_ADM_API_M (API_ID + API_URL)
INSERT ALL
  INTO SCM_ADM_API_M (API_ID, API_TP_CD, API_MSG_ID, API_MSG_DESC, API_URL, USE_YN,
                      CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
    VALUES ('DMF0099_main_SEARCH', 'PROC', NULL, 'DMF0099 Search',
            'PKG_DMF0099.P_DMF0099_GET_MAIN_DATA', 'Y',
            'admin', SYSDATE, 'admin', SYSDATE)
  INTO SCM_ADM_API_M (...) VALUES ('DMF0099_main_SAVE', 'PROC', NULL, ...)
SELECT 1 FROM DUAL;

-- 2) SCM_ADM_MNU_BTN_MPG_M (MENU × SHEET × BTN → API_ID)
INSERT ALL
  INTO SCM_ADM_MNU_BTN_MPG_M (MNU_ID, SHT_NM, MNU_BTN_CD, API_ID, USE_YN,
                              CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
    VALUES ('DMF0099', 'main', 'SEARCH', 'DMF0099_main_SEARCH', 'Y',
            'admin', SYSDATE, 'admin', SYSDATE)
  INTO SCM_ADM_MNU_BTN_MPG_M (...) VALUES ('DMF0099', 'main', 'SAVE', 'DMF0099_main_SAVE', 'Y', ...)
SELECT 1 FROM DUAL;
COMMIT;
```

> `API_ID` 명명 규약: `{MNU_ID}_{SHT_NM}_{BTN_CD}`

### Step 6: ★ Group Menu 권한 등록 (`SCM_ADM_USER_GR_MNU_MPG_M`) — SYS0008 영역

```sql
INSERT INTO SCM_ADM_USER_GR_MNU_MPG_M (USER_GR_ID, MNU_ID, USE_YN,
                                        CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT 'ADMIN',       'DMF0099', 'Y', 'admin', SYSDATE, 'admin', SYSDATE FROM DUAL UNION ALL
SELECT 'DEMAND_USER', 'DMF0099', 'Y', 'admin', SYSDATE, 'admin', SYSDATE FROM DUAL;

-- 버튼별 권한 분리가 필요한 경우 (선택)
INSERT INTO SCM_ADM_USER_GR_MNU_BTN_MPG_M (USER_GR_ID, MNU_ID, MNU_BTN_CD, USE_YN, ...) VALUES (...);
COMMIT;
```

### Step 7: FE 코드 작성

`Doc/_dev_rules/05_SCREEN_TEMPLATE.md` 의 표준 패턴 참조. 핵심 파일:
- `features/{domain}/src/pages/{kebab-name}/{Pascal}.tsx`
- `features/{domain}/src/pages/{kebab-name}/{kebab}.constants.ts` — `MENU_ID = 'DMF0099'`, `SHEET_NAME = 'main'`
- `features/{domain}/src/pages/{kebab-name}/use{Pascal}Store.ts`
- `apps/web/src/core/Router.tsx` — 라우트 1행 추가
- `configs/types/procedures.d.ts` — `DMF0099` 타입 정의 추가

### Step 8: 검증

```bash
# 1) FE 타입 자동 생성 (BE PR_GET_PROCEDURES_METADATA 호출)
pnpm gen:procedures

# 2) FE 로컬 실행
pnpm dev

# 3) 메뉴 클릭 → 화면 로드 → 검색 → Grid 표시 확인

# 4) DB 검증 SQL (§9 체크리스트 참조)
```

---

## §4. 영역별 SQL INSERT 표준 패턴 (요약)

> 실행 가능한 전체 템플릿: `To-be_v2_converted/08_Screen_Registration/02_NEW_SCREEN_FULL_REGISTRATION_TEMPLATE.sql`

### 4.1 i18n (`SCM_ADM_MSG_M`)

| 컬럼 | 값 |
|---|---|
| `MSG_ID` | `MNU_DMF0099` (메뉴) / `LBL00001` (라벨) / `MSG00001` (시스템 메시지) |
| `LANG_CD` | `'KO'` / `'EN'` / `'CN'` (3행 1세트) |
| `MSG_NM` | 번역문 |
| `MSG_TP_CD` | `'MNU'` / `'LBL'` / `'MSG'` |
| `USE_YN` | `'Y'` |

### 4.2 MENU (`SCM_ADM_MNU_M`)

| 컬럼 | 값 |
|---|---|
| `MNU_ID` (PK) | `'DMF0099'` |
| `UPPR_MNU_ID` | `'DMF'` |
| `MNU_LV_NO` | `3` (1=대분류, 2=중분류, 3=화면) |
| `MNU_MSG_ID` | `'MNU_DMF0099'` (i18n 참조) |
| `MNU_URL` | `'dmf0099-sales-monitor'` ★ **slug only — 디렉토리 prefix 금지**. 부모 메뉴 경로는 FE 라우터가 SCM_ADM_MNU_M 트리를 walk-up 해 자동 조립. 형제 메뉴들 (DMF0004~0008 등) 모두 leaf segment 만 저장됨. **⚠ FE `nscm-fe/packages/foundation/src/constants/route-paths.ts` 의 동일 MNU_ID slug 와 정확히 일치 의무** — 불일치 시 메뉴 클릭해도 화면 안 뜸 (2026-05-29 DMF0043/0043_01/0072 사고). 작성 직후 cross-check: `grep -nE "^\s*{MNU_ID}:" nscm-fe/packages/foundation/src/constants/route-paths.ts` |
| `SORT_ORD` | `99` |
| `USE_YN` | `'Y'` |

### 4.3 UI Category — Sheet Columns (`SCM_MST_SHEET_COLUMNS`)

화면 그리드의 모든 컬럼 1개당 1행. 자세한 컬럼은 `PKG_SYS0004` 참조.

| 컬럼 | 값 (예) |
|---|---|
| `PROGRAM_ID` (PK1) | `'DMF0099'` |
| `SHEET_NAME` (PK2) | `'main'` |
| `COLUMN_NAME` (PK3) | `'DIVISION_ID'` (SP OUT cursor 컬럼명, UPPER_SNAKE) |
| `COLUMN_LABEL_NAME` | `'LBL00001'` (i18n 코드) |
| `SORT_ORDER_NO` | `1` |
| `CELL_CONTROL_OBJECT_TYPE_CODE` | `'FPText'` / `'FPNumber'` / `'FPCombo'` / `'FPDate'` |
| `CELL_COMBO_DATA_TYPE` | 콤보 ID (`'MyDivision'` 등) |
| `DATA_SCALE_NUMBER` | 소수점 자릿수 |
| `DATA_MAX_LENGTH` | 최대 길이 |
| `HORIZONTAL_ALIGN_CODE` | `'L'` / `'C'` / `'R'` |
| `VISIBLE_FLAG` / `DEFAULT_FLAG` / `USER_SELECTABLE_FLAG` | `'Y'` |
| `INPUT_TP_CD` | `'MANDATORY'` / `'OPTIONAL'` / `'READONLY'` (실제 DDL 컬럼명, 길이 100 CHAR, DEFAULT 'S') |
| `DIVISION_ID` | `'ALL'` 또는 `'40,81'` |
| `VALID_YN` | `'Y'` |

### 4.4 Procedure 메타 (`SCM_ADM_PROC_M`)

⛔ **절대 누락 금지** — BE 의 동적 SP 호출은 본 메타에서 IN/OUT 파라미터를 조회해 바인딩한다. 누락 시 BE 가 파라미터 0개로 SP 호출 → `ORA-06550 PLS-00306: 인수의 갯수나 유형이 잘못되었습니다` (2026-05-29 DMF0043 사고).

SP IN/OUT 파라미터 1개당 1행. `ALL_ARGUMENTS` 시스템 뷰로 자동 추출 가능.

| 컬럼 | 값 (예) |
|---|---|
| `PROC_NM` (PK1) | `'PKG_DMF0099.P_DMF0099_GET_MAIN_DATA'` |
| `COL_NM` (PK2) | `'divisionId'` (변환 룰 ↓ 참조) |
| `COL_TP_CD` | `'IN'` / `'OUT'` |
| `DATA_TP_CD` | `'VARCHAR'` / `'NUMBER'` / `'DATE'` / `'CLOB'` / `'CURSOR'` / `'PROC_RESULT'` |
| `SORT_ORD` | `1, 2, 3, ...` (SP 파라미터 순서, `ALL_ARGUMENTS.POSITION` 그대로) |

**ARGUMENT_NAME → COL_NM 변환 룰** (BE 자동 주입 키와 정확히 일치 의무):

| ALL_ARGUMENTS.ARGUMENT_NAME | IN_OUT | COL_NM | 비고 |
|---|---|---|---|
| `P_USER_ID` | IN | `sesUserId` | BE 세션 자동 주입 |
| `P_MENU_ID` | IN | `menuId` | BE 세션 자동 주입 |
| `P_LANG_CD` | IN | `sesLangCd` | BE 세션 자동 주입 |
| `P_XXX_YYY` (그 외) | IN | `xxxYyy` | `P_` 제거 + camelCase |
| `O_RC1`, `O_RC2`, ... | OUT | `o_rc1`, `o_rc2`, ... | 소문자 |
| `O_RESULT_CURSOR` | OUT | `O_RESULT_CURSOR` | 대문자 그대로 + `DATA_TP_CD='PROC_RESULT'` |

**DATA_TYPE → DATA_TP_CD 변환**:

| ALL_ARGUMENTS.DATA_TYPE | DATA_TP_CD |
|---|---|
| `VARCHAR2` | `VARCHAR` |
| `REF CURSOR` (O_RC*) | `CURSOR` |
| `REF CURSOR` (O_RESULT_CURSOR) | `PROC_RESULT` |
| `NUMBER` / `DATE` / `CLOB` | 그대로 |

**자동 변환 SQL 템플릿** (모든 신규 화면 등록 시 BLOCK 4 로 적용 의무 — `_artifacts/34_DMF0043_DMF0072_PROC_Meta_Insert_DBeaver.sql` 참조):

```sql
INSERT INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, COL_TP_CD, DATA_TP_CD, SORT_ORD,
                            CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT
  PACKAGE_NAME || '.' || OBJECT_NAME AS PROC_NM,
  CASE
    WHEN IN_OUT = 'IN' AND ARGUMENT_NAME = 'P_USER_ID' THEN 'sesUserId'
    WHEN IN_OUT = 'IN' AND ARGUMENT_NAME = 'P_MENU_ID' THEN 'menuId'
    WHEN IN_OUT = 'IN' AND ARGUMENT_NAME = 'P_LANG_CD' THEN 'sesLangCd'
    WHEN IN_OUT = 'IN' THEN
      LOWER(SUBSTR(REPLACE(INITCAP(REPLACE(SUBSTR(ARGUMENT_NAME, 3), '_', ' ')), ' ', ''), 1, 1))
      || SUBSTR(REPLACE(INITCAP(REPLACE(SUBSTR(ARGUMENT_NAME, 3), '_', ' ')), ' ', ''), 2)
    WHEN IN_OUT = 'OUT' AND ARGUMENT_NAME = 'O_RESULT_CURSOR' THEN 'O_RESULT_CURSOR'
    WHEN IN_OUT = 'OUT' THEN LOWER(ARGUMENT_NAME)
  END,
  IN_OUT,
  CASE
    WHEN ARGUMENT_NAME = 'O_RESULT_CURSOR' THEN 'PROC_RESULT'
    WHEN DATA_TYPE = 'REF CURSOR' THEN 'CURSOR'
    WHEN DATA_TYPE = 'VARCHAR2' THEN 'VARCHAR'
    ELSE DATA_TYPE
  END,
  POSITION, 'admin', SYSDATE, 'admin', SYSDATE
FROM ALL_ARGUMENTS S
WHERE PACKAGE_NAME = 'PKG_{SCREEN_ID}'
  AND POSITION > 0
  AND NOT EXISTS (
    SELECT 1 FROM SCM_ADM_PROC_M T
     WHERE T.PROC_NM = S.PACKAGE_NAME || '.' || S.OBJECT_NAME AND T.SORT_ORD = S.POSITION
  );
```

**PR 직전 검증 (필수)**:

```sql
-- ALL_ARGUMENTS 와 SCM_ADM_PROC_M 카운트 일치 확인
SELECT 'EXPECT' AS K, COUNT(*) FROM ALL_ARGUMENTS WHERE PACKAGE_NAME = 'PKG_{SCREEN_ID}' AND POSITION > 0
UNION ALL
SELECT 'ACTUAL', COUNT(*) FROM SCM_ADM_PROC_M WHERE PROC_NM LIKE 'PKG_{SCREEN_ID}.%';
-- 두 행의 COUNT 가 정확히 일치해야 함
```

### 4.5 API (`SCM_ADM_API_M`)

실제 스키마: `(API_ID, API_TP_CD, API_MSG_ID, API_MSG_DESC, API_URL, USE_YN)`

| 컬럼 | 값 (예) |
|---|---|
| `API_ID` (PK) | `'DMF0099_main_SEARCH'` |
| `API_TP_CD` | `'PROC'` |
| `API_MSG_ID` | `'MSG_API_DMF0099_MAIN_SEARCH'` (i18n) |
| `API_URL` | `'PKG_DMF0099.P_DMF0099_GET_MAIN_DATA'` |
| `USE_YN` | `'Y'` |

### 4.6 MNU_BTN_MPG (`SCM_ADM_MNU_BTN_MPG_M`)

| 컬럼 | 값 (예) |
|---|---|
| `MNU_ID` (PK1) | `'DMF0099'` |
| `SHT_NM` (PK2) | `'main'` |
| `MNU_BTN_CD` (PK3) | `'SEARCH'` / `'SAVE'` / `'DELETE'` / `'EXCEL'` / 커스텀 (§4.6.1 참조) |
| `API_ID` | `'DMF0099_main_SEARCH'` (4.5 참조) |

### 4.6.1 MNU_BTN_CD 명명 규약 ⭐ (2026-05-22 추가 — DMF0020 작업 반영)

#### 표준 BTN_CD (모든 화면 공통, GridAction 의 F-키 매핑)

| BTN_CD | 용도 | F-키 / 트리거 | API_ID 예 |
|---|---|---|---|
| `SEARCH` | 메인 조회 | F7 / 검색 버튼 | `DMF0099_main_SEARCH` |
| `SAVE` | 메인 저장 (CRUD 통합) | F10 / 저장 버튼 | `DMF0099_main_SAVE` |
| `DELETE` | 명시적 삭제 | F9 (SAVE 통합 시 생략 가능) | `DMF0099_main_DELETE` |
| `EXCEL` | Excel 다운로드 | F11 / Excel 버튼 (보통 클라이언트 처리) | (생략 가능) |
| `INSERT` | 명시적 행 추가 (서버측 default 채움 시) | F8 (보통 클라이언트 처리) | `DMF0099_main_INSERT` |

#### 커스텀 BTN_CD (비즈니스 SP 호출)

화면 고유의 SP 호출 (예: 동적 컬럼 메타, 환율 갱신, 배치 트리거 등) 은 커스텀 BTN_CD 정의.

**명명 규약**: `대문자_UPPER_SNAKE_CASE` (As-Is SP 명 또는 동작을 영어 대문자로)

| 커스텀 BTN_CD 예 | 용도 | API_ID 예 |
|---|---|---|
| `SPREAD_TITLE_DATE` | 시간축 동적 컬럼 메타 조회 (DMF0020) | `DMF0020_main_SPREAD_TITLE_DATE` |
| `EXCHANGE_RATE_APPLY` | 환율 일괄 적용 | `DMF0020_main_EXCHANGE_RATE_APPLY` |
| `BATCH_TRIGGER` | 배치 실행 트리거 | `DMF0099_main_BATCH_TRIGGER` |
| `IMPORT_TEMPLATE` | 템플릿 적용 | `DMF0020_main_IMPORT_TEMPLATE` |

#### 규칙

```
[ ] 표준 BTN_CD (SEARCH/SAVE/DELETE/EXCEL/INSERT) 외에는 커스텀 명명 사용
[ ] 커스텀 BTN_CD 는 UPPER_SNAKE_CASE (소문자/하이픈/공백 금지)
[ ] As-Is SP 의 비즈니스 의미와 일치하도록 명명 (`SPREAD_TITLE_DATE` 는 As-Is `GET_SPREAD_TITLE_DATE` 와 매칭)
[ ] API_ID 는 `{MNU_ID}_{SHT_NM}_{BTN_CD}` 형식 엄수
[ ] BLOCK 4 의 `SCM_ADM_API_M` 행과 BLOCK 5 의 `SCM_ADM_MNU_BTN_MPG_M` 행 1:1 매칭
[ ] BTN_CD 가 다른 sheet 에 같이 쓰이면 (예: `SEARCH` 가 main / exchangeRate / popup 모두) 각 sheet 별 별도 API_ID
```

#### 권한 분리 (BLOCK 7)

커스텀 BTN_CD 도 권한 2 테이블에 INSERT 필요 (`SCM_ADM_USER_GR_MNU_BTN_MPG_M`). 형제 메뉴에서 동적 복제 시 자동 포함.

```sql
-- SCM_ADM_USER_GR_MNU_BTN_MPG_M 동적 복제 (DMF0007 → DMF0020)
INSERT INTO SCM_ADM_USER_GR_MNU_BTN_MPG_M (USER_GR_ID, MNU_ID, MNU_BTN_CD, USE_YN, ...)
SELECT USER_GR_ID, 'DMF0020', MNU_BTN_CD, 'Y', ...
  FROM SCM_ADM_USER_GR_MNU_BTN_MPG_M
 WHERE MNU_ID = 'DMF0007' AND USE_YN = 'Y'
   AND NOT EXISTS (...);  -- idempotent
-- ★ 위 SELECT 는 DMF0007 의 BTN_CD 모두 복제. 커스텀 BTN_CD 가 DMF0020 만 있고 DMF0007 에 없으면 별도 INSERT 필요.
```

> ⚠ **주의**: 형제 메뉴 (DMF0007) 에 없는 커스텀 BTN_CD (예: DMF0020 의 `SPREAD_TITLE_DATE`) 는 동적 복제로 자동 포함되지 않음. 별도 INSERT 또는 'ADMIN' 그룹만 수동 부여.

### 4.7 Group MENU (`SCM_ADM_USER_GR_MNU_MPG_M`)

| 컬럼 | 값 (예) |
|---|---|
| `USER_GR_ID` (PK1) | `'ADMIN'` / `'DEMAND_USER'` / `'PLANNER'` |
| `MNU_ID` (PK2) | `'DMF0099'` |
| `USE_YN` | `'Y'` |

---

## §5. i18n 코드 명명 규약

### 5.1 메시지 타입(`MSG_TP_CD`) 3종

| 타입 | 용도 | MSG_ID 예시 |
|---|---|---|
| `MNU` | 메뉴명 / 화면 제목 | `MNU_DMF0099` (= `MNU_{MENU_ID}`) |
| `LBL` | 라벨 / 컬럼 헤더 / 버튼 텍스트 | `LBL00001` (5자리 일련번호) |
| `MSG` | 시스템 메시지 (Alert/Toast/Confirm) | `MSG00001` (5자리 일련번호) |

### 5.2 언어 코드(`LANG_CD`) 3종

- `KO` — 한국어 (기본)
- `EN` — English
- `CN` — 中文

> 3개 언어 1세트 일괄 INSERT 필수. 누락 시 해당 언어 사용자에게 i18n 키가 그대로 노출됨.

### 5.3 일련번호 채번 (FN_GET_MSG_SEQ)

`PKG_NSCM_UI_COMM.FN_GET_MSG_SEQ(P_PREFIX)` 으로 다음 LBL/MSG 번호를 받아 사용.

```sql
SELECT PKG_NSCM_UI_COMM.FN_GET_MSG_SEQ('LBL') FROM DUAL;  -- → 'LBL00321' 등
```

### 5.4 FE 동기화

`nscm-fe` 의 `sync-i18n.mjs` 가 BE `/admin/message` 를 호출해 `public/locales/{KO,EN,CN}.json` 을 생성. 등록 후 `pnpm sync:i18n` 실행해야 FE 에 반영됨.

> 컬럼 근거: `nscm-be/src/main/resources/sql/admin/Message.xml`, `PKG_SYS0001.SYS0001_GET_MAIN_DATA`

---

## §6. COL_NM 명명 규약 (Procedure 메타)

`SCM_ADM_PROC_M.COL_NM` 은 FE/BE 의 파라미터 키와 정확히 일치해야 합니다.

### 6.1 IN 파라미터 (Oracle → camelCase)

| Oracle SP 파라미터 | `SCM_ADM_PROC_M.COL_NM` | FE `procedures.d.ts` request 키 |
|---|---|---|
| `P_DIVISION_ID` | `divisionId` | `divisionId` |
| `P_USER_ID` | `userId` | `userId` |
| `P_MENU_ID` | `menuId` | `menuId` |
| `P_CUSTOMER_PROJECT_CODE` | `customerProjectCode` (또는 `customerPJT` 같은 약어도 화면별로 등록) | 동일 |

**규칙**: `P_` 접두사 제거 → camelCase 변환

### 6.2 OUT 커서 (Oracle → snake)

| Oracle SP 커서 | `SCM_ADM_PROC_M.COL_NM` | FE 응답 키 |
|---|---|---|
| `O_RC1` | `o_rc1` | `o_rc1` |
| `O_CURSOR` | `o_rc1` (관례) 또는 `o_cursor` | 등록값 그대로 |
| `O_RESULT_CURSOR` | `o_result_cursor` | (FE 미사용 — 상태 코드) |

**중요**: BE 의 `BaseService.selectList()` 는 응답 Map 키에서 `@` 접두사를 제거하므로 `COL_NM` 그대로가 응답 키가 됩니다. FE 의 `data?.o_rc1` 으로 접근할 때 이 키가 정확히 일치해야 합니다.

### 6.3 DATA_TP_CD 매핑

| Oracle 타입 | `DATA_TP_CD` |
|---|---|
| `VARCHAR2` / `CHAR` | `VARCHAR` |
| `NUMBER` (정수) | `NUMBER` |
| `NUMBER` (소수) | `NUMERIC` |
| `DATE` / `TIMESTAMP` | `DATE` |
| `CLOB` / `BLOB` | `CLOB` |
| `SYS_REFCURSOR` (O_RC1 등) | `CURSOR` |
| `SYS_REFCURSOR` (O_RESULT_CURSOR 전용) | `PROC_RESULT` |

> JSON 배열을 IN 으로 받는 경우(SAVE SP) 는 `JVARCHAR` 사용. BE 의 `MapUtils.cvtJsonToJVarchar` 가 변환 처리.

---

## §7. 통합 등록 템플릿 사용법

실행 가능한 통합 SQL: `To-be_v2_converted/08_Screen_Registration/02_NEW_SCREEN_FULL_REGISTRATION_TEMPLATE.sql`

### 7.1 사용 절차

1. 템플릿을 SQL\*Plus / SQL Developer 에서 새 탭으로 복사
2. 상단 `DEFINE` 블록의 변수 치환 (MENU_ID, SHEET_NAME, PKG_NM 등)
3. BLOCK 1 (i18n) 의 번역문 채우기
4. BLOCK 2 (Procedure) 의 IN/OUT 파라미터 목록 채우기 (또는 `ALL_ARGUMENTS` 조회 결과 활용)
5. BLOCK 3 (MENU/API/Columns/권한) 의 JSON 채우기
6. BLOCK 6 (검증) 실행 → 7개 영역 모두 row 수가 기대치 이상이면 성공
7. `pnpm gen:procedures` 로 FE 타입 갱신, `pnpm sync:i18n` 로 i18n 동기화

### 7.2 변수 치환표

| 변수 | 예시값 | 비고 |
|---|---|---|
| `&V_MENU_ID` | `DMF0099` | 화면 ID |
| `&V_UPPR_MENU` | `DMF` | 상위 메뉴 |
| `&V_MENU_URL` | `/demand/dmf0099-sales-monitor` | FE 라우팅 |
| `&V_SHEET_NM` | `main` | 시트명 (보통 `main`) |
| `&V_PKG_NM` | `PKG_DMF0099` | Oracle 패키지명 |
| `&V_USER_ID` | `admin` | 등록자 |
| `&V_AUTH_GROUPS` | `ADMIN,DEMAND_USER` | 콤마 구분 |

---

## §7.1 ★ SQL 파일 듀얼 출력 룰 (SQL\*Plus + DBeaver) — 필수

> **추가일**: 2026-05-19
> **계기**: SQL\*Plus 전용 명령(`SET DEFINE`, `DEFINE`, `&변수`, `PROMPT`, `UNDEFINE`)을 포함한 등록 스크립트가 DBeaver/JDBC 환경에서 `ORA-00922 부적합한 옵션` 으로 실패하는 사례 발생. 현장 운영팀은 DBeaver 를 주로 사용하므로 SQL\*Plus 버전만 제공하면 즉시 활용 불가.

### 7.1.1 룰

**메타 등록·운영용 SQL 스크립트는 반드시 다음 파일 세트를 함께 생성해야 한다.**

| # | 파일명 패턴 | 대상 실행 환경 | 내용 |
|---|---|---|---|
| 1 | `{name}.sql` | SQL\*Plus / SQLcl | 통합 1개 파일 (`SET DEFINE`, `DEFINE V_X=...`, `&V_X`, `PROMPT`, `UNDEFINE`, `/`) |
| 2 | `{name}_DBeaver.sql` | DBeaver / 일반 JDBC | **등록 PL/SQL 블록** 1개 (PART 1) — `/` 없음, `CONSTANT` 변수 |
| 3 | `{name}_DBeaver_Verify.sql` | DBeaver | **검증 SELECT** 1개 (PART 2) |
| 4 | `{name}_DBeaver_Diagnose.sql` | DBeaver | **라우팅 진단 PL/SQL 블록** 1개 (PART 3) — 선택 |

> 예시: `03_DMF0020_Registration.sql` ↔ `03_DMF0020_Registration_DBeaver.sql` + `_Verify.sql` + `_Diagnose.sql`

### 7.1.1-b ★ `_DBeaver.sql` 의 BLOCK 3 는 자기완결형(Self-Contained) 인라인 INSERT 사용

**규칙**: `_DBeaver.sql` 의 BLOCK 3 (Sheet Columns 등록) 은 `PKG_NSCM_SCREEN_REGISTRATION.P_REGISTER_SCREEN` 호출이 아닌 **JSON_TABLE 기반 인라인 INSERT** 로 작성한다.

**왜:**
- `PKG_NSCM_SCREEN_REGISTRATION` 미배포 시 `ORA-06550 PLS-00201` (식별자 미정의) 발생
- 배포되어도 BODY 컴파일 실패 시 `ORA-06508` (프로그램 단위 미발견) 발생
- 본 PKG 는 §8.1 의 결함 6개를 가지고 있어 어차피 BLOCK 4~7 로 보완 필요 → 호출 자체가 부가가치 없음
- 인라인 INSERT 는 의존성 0, idempotent, 가독성 높음

**구조**:
```sql
v_col_json := '[ {"sht_nm":"...", "col_nm":"...", ...}, ... ]';

DELETE FROM SCM_MST_SHEET_COLUMNS WHERE PROGRAM_ID = V_MENU_ID;

INSERT INTO SCM_MST_SHEET_COLUMNS (PROGRAM_ID, SHEET_NAME, COLUMN_NAME, ...)
SELECT V_MENU_ID, jt.SHT_NM, jt.COL_NM, ...
  FROM JSON_TABLE(v_col_json, '$[*]' COLUMNS (
       SHT_NM VARCHAR2(50) PATH '$.sht_nm',
       COL_NM VARCHAR2(100) PATH '$.col_nm',
       ...
  )) jt;
```

**참고 모델**: `PKG_NSCM_SCREEN_REGISTRATION.P_REGISTER_SCREEN` BODY 의 STEP 3 (SCM_MST_SHEET_COLUMNS INSERT) 을 그대로 복사하여 인라인화.

### 7.1.1-a DBeaver 파일을 PART 단위로 분리하는 이유

단일 파일에 **PL/SQL 블록 + SELECT 혼재** 시:
- DBeaver 의 SQL 파서가 `END;` 이후의 `SELECT` 를 블록 일부로 잘못 해석
- 결과: `PLS-00103: 심볼 "SELECT"를 만났습니다` (ORA-06550)
- `/` 종결자를 추가하면 이번엔 `/` 자체가 별도 SQL 로 전송되어 ORA-00911 발생
- **유일한 해결**: PART 단위로 파일 분리 → 각 파일에 1개 statement (블록 또는 SELECT) 만 포함

→ 단순히 "여러 statement 를 한 파일에 두지 않는다" 가 본질.

### 7.1.2 두 형식의 변환 매트릭스

| SQL\*Plus (`.sql`) | DBeaver (`_DBeaver.sql`) |
|---|---|
| `SET DEFINE ON` | (제거) |
| `SET SERVEROUTPUT ON SIZE UNLIMITED` | (제거 — DBeaver 측 "Enable DBMS_OUTPUT" 설정) |
| `DEFINE V_MENU_ID = 'DMF0020'` | `V_MENU_ID CONSTANT VARCHAR2(20) := 'DMF0020';` |
| `'&V_MENU_ID'` 치환 | `V_MENU_ID` 직접 참조 (또는 `||` 연결) |
| `&V_NUM` (숫자) | `V_NUM` (NUMBER 상수) |
| `PROMPT === 메시지 ===` | `DBMS_OUTPUT.PUT_LINE('=== 메시지 ===');` |
| `UNDEFINE V_X V_Y` | (제거 — PL/SQL 블록 종료 시 자동 소멸) |
| `END;` 다음 줄의 `/` (블록 종결자) | **(완전 제거)** — DBeaver/JDBC 는 `/` 단독을 별도 SQL 문으로 보내 ORA-00911 발생 |
| 여러 개의 독립 DML | **단일 익명 PL/SQL 블록** 으로 통합 (변수 재사용 + 트랜잭션 단일화) |
| 예외 처리 분산 | **`EXCEPTION WHEN OTHERS THEN ROLLBACK; RAISE;`** 1개로 통합 |

### 7.1.3 DBeaver 파일 표준 구조 (PART 단위 분리)

**파일 1 — `{name}_DBeaver.sql` (등록):**

```sql
/* 헤더: 다른 2 파일 참조 명시 */
DECLARE
    V_MENU_ID  CONSTANT VARCHAR2(20)  := 'DMF0099';
    V_USER_ID  CONSTANT VARCHAR2(50)  := 'admin';
    /* ...추가 상수... */
    v_code     NUMBER;
    v_msg      VARCHAR2(4000);
BEGIN
    /* BLOCK 1~7 DML 통합 */
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('완료');
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('SQLCODE:'||SQLCODE||' / '||SQLERRM);
        RAISE;
END;
-- ⚠ 파일 끝에 `/` 절대 추가 금지 (DBeaver 가 별도 SQL 로 전송 → ORA-00911)
-- ⚠ 본 파일에는 SELECT 등 다른 statement 추가 금지 (PLS-00103 발생)
```

**파일 2 — `{name}_DBeaver_Verify.sql` (검증 SELECT만):**

```sql
/* 헤더: 본 파일은 SELECT 1개. 등록 후 Ctrl+Enter */
SELECT '1.MENU' AS K, COUNT(*) AS CNT, 1 AS EXPECT_MIN, '...' AS TBL FROM ...
UNION ALL SELECT '2....' , ...
ORDER BY 1
-- ⚠ 끝에 세미콜론 없어도 됨. 다른 statement 추가 금지.
```

**파일 3 — `{name}_DBeaver_Diagnose.sql` (진단 PL/SQL만):**

```sql
/* 헤더: 라우팅 진단용. DBMS Output 확인 */
DECLARE
    v_cur SYS_REFCURSOR;
    /* ... */
BEGIN
    /* PR_GET_PROC_INFO_LIST 호출 + 결과 fetch + DBMS_OUTPUT */
END;
-- ⚠ `/` 없음, 다른 statement 추가 금지
```

### 7.1.3-a 실행 안내 (각 DBeaver 파일 헤더 의무 문구)

각 `_DBeaver*.sql` 파일 헤더에 다음 실행 안내를 반드시 포함:

```
실행 방법:
  1. 본 파일 열기 → 전체 선택 (Ctrl+A) → Ctrl+Enter
  2. DBMS_OUTPUT 결과: Window → "DBMS Output" 뷰 활성화

⚠ 본 파일은 1개의 SQL/PL/SQL statement 만 포함하므로 전체 선택 실행이 안전합니다.
⚠ DBeaver 사전 설정: Window → Preferences → Database → Editors → Oracle → ✅ Enable DBMS_OUTPUT
```

### 7.1.4 SQL 헤더에 명시할 의무 사항

`_DBeaver.sql` 파일 상단 헤더에 다음 5개 항목을 반드시 포함:

1. **원본 파일과의 대응 관계** — "원본 `{name}.sql` 의 SQL\*Plus 명령을 PL/SQL CONSTANT 로 재작성"
2. **두 가지 실행 방법** — DBeaver (Alt+X), SQLcl/SQL\*Plus (`@파일경로`)
3. **DBeaver 사전 설정** — `Window → Preferences → Database → Editors → Oracle → ✅ Enable DBMS_OUTPUT`
4. **사전 조건** — 호출하는 PKG/Function 의 VALID 상태
5. **실행 계정** — `SCM_MGR` 등

### 7.1.5 AI 작업 시 적용

본 룰은 다음 모든 경우에 적용 — AI 가 SQL 파일을 신규 생성하거나 SQL\*Plus 구문이 포함된 기존 파일을 사용자에게 제공할 때:

- 신규 화면 메타 등록 SQL (`/registrations/*.sql`)
- 자동화 PKG 배포 SQL
- 데이터 적재 / 마이그레이션 SQL
- 운영 패치 SQL (Hot-fix DML)

→ 단순 SELECT 쿼리·DDL 1개·테스트 단편 등 SQL\*Plus 명령이 포함되지 않은 파일은 듀얼 출력 불요.

### 7.1.6 ZIP/PR 산출물 동봉 의무

신규 화면 또는 메타 변경 작업의 산출물 ZIP·PR 첨부 시:

- ✅ `{name}.sql` (SQL\*Plus) + `{name}_DBeaver.sql` + `{name}_DBeaver_Verify.sql` + `{name}_DBeaver_Diagnose.sql` **4개 모두** 포함
- ✅ 모든 파일이 동일 디렉터리(`registrations/`)에 위치
- ✅ 각 `_DBeaver*.sql` 파일은 statement 1개만 포함 (PL/SQL 블록 1개 또는 SELECT 1개)
- ❌ 일부만 포함된 산출물은 머지 게이트에서 반려
- ❌ 단일 `_DBeaver.sql` 에 PL/SQL + SELECT 혼재 시 머지 게이트 반려 (PLS-00103 위험)

---

## §8. 등록 패턴 이력 및 향후 자동화

### 8.1 채택 패턴 — 자기완결형 (Self-Contained) 인라인 DML

본 룰은 **모든 7개 영역을 인라인 DML 로 직접 등록** 하는 자기완결형 패턴을 표준으로 채택. 외부 PKG 의존성 없음.

**이유 (이력)**:

2026-05-13 ~ 2026-05-19 기간 동안 `PKG_NSCM_SCREEN_REGISTRATION.P_REGISTER_SCREEN` 자동화 PKG 접근법을 시도했으나, 다음 6가지 결함이 발견되어 폐기:

| # | 발견 결함 | 증상 |
|---|---|---|
| 1 | `SCM_ADM_MENU_M` (오타) 에 INSERT — 실제 테이블은 `SCM_ADM_MNU_M` | MENU 미등록 |
| 2 | `SCM_ADM_API_M` 컬럼 매핑 오류 | API 메타 미등록 |
| 3 | `SCM_ADM_MNU_BTN_MPG_M` INSERT 누락 | 동적 라우팅 미동작 |
| 4 | `SCM_ADM_PROC_M` INSERT 누락 | SP 파라미터 NULL 호출 → 빈 결과 (DMF0007 사례) |
| 5 | `SCM_ADM_MSG_M` INSERT 누락 (DELETE만 지원) | 다국어 미표시 |
| 6 | `SCM_ADM_USER_GR_MNU_MPG_M` 대신 `SCM_ADM_USER_MNU_AUTH` 에 INSERT | 그룹 권한 조회 불일치 |

PKG 결함을 보완하기 위해 추가 BLOCK 4~7 을 호출 측에서 작성해야 했고, 결국 PKG 자체가 부가가치 없음 + 배포 시 `ORA-06508` (BODY 컴파일 실패) 등 추가 장애 발생. → 2026-05-19 사용자 결정으로 PKG 전면 폐기, 자기완결형 인라인 DML 로 통합.

### 8.2 자기완결형의 장점

- **의존성 0**: 외부 PKG 배포 불필요. 화면 SP (`PKG_DMF{NNNN}`) 만 컴파일되어 있으면 OK
- **결함 0**: 각 BLOCK 이 실제 운영 테이블·컬럼을 직접 사용 (오타·매핑 오류 원천 차단)
- **Idempotent**: 모든 BLOCK 이 `DELETE` 후 `INSERT` 패턴 → 재실행 안전
- **트랜잭션 단일화**: 1개 PL/SQL 블록 내 7개 영역 → 일부 실패 시 전체 ROLLBACK + RAISE
- **가독성**: 어떤 테이블에 어떤 값이 들어가는지 파일에서 직접 확인 가능

### 8.3 향후 자동화 후보 (선택)

자기완결형 패턴을 유지하면서 보조 자동화 도구로 활용 가능:

1. `P_EXTRACT_SP_PARAMS` — `ALL_ARGUMENTS` 뷰 기반 SP 시그니처 추출 (`SCM_ADM_PROC_M` 등록 보조)
2. `pnpm gen:procedures` — `SCM_ADM_PROC_M` 기반 `procedures.d.ts` 자동 생성 (이미 존재)
3. `pnpm sync:i18n` — `SCM_ADM_MSG_M` 기반 locale JSON 생성 (이미 존재)

→ DB 메타가 정확히 등록되어야 FE 자동화 도구 출력도 정확함.

---

## §9. PR 머지 게이트 — 체크리스트

신규 화면 PR 머지 전 다음 검증 쿼리 7개를 모두 실행하고 결과를 PR 본문에 첨부:

```sql
-- &V_MENU_ID 를 본인 화면 ID 로 치환
SELECT '1.MENU'        AS K, COUNT(*) AS CNT, 1 AS EXPECT_MIN FROM SCM_ADM_MNU_M             WHERE MNU_ID = '&V_MENU_ID'
UNION ALL
SELECT '2.MENU_AUTH',    COUNT(*), 1 FROM SCM_ADM_USER_GR_MNU_MPG_M WHERE MNU_ID = '&V_MENU_ID'
UNION ALL
SELECT '3.UI_COLS',      COUNT(*), 1 FROM SCM_MST_SHEET_COLUMNS     WHERE PROGRAM_ID = '&V_MENU_ID'
UNION ALL
SELECT '4.PROC',         COUNT(*), 3 FROM SCM_ADM_PROC_M            WHERE PROC_NM LIKE 'PKG_'||'&V_MENU_ID'||'%'
UNION ALL
SELECT '5.API',          COUNT(*), 1 FROM SCM_ADM_API_M             WHERE API_ID LIKE '&V_MENU_ID'||'%'
UNION ALL
SELECT '6.MNU_BTN_MPG',  COUNT(*), 1 FROM SCM_ADM_MNU_BTN_MPG_M     WHERE MNU_ID = '&V_MENU_ID'
UNION ALL
SELECT '7.I18N_MNU',     COUNT(*), 3 FROM SCM_ADM_MSG_M             WHERE MSG_ID = 'MNU_'||'&V_MENU_ID';
```

**전부 `CNT >= EXPECT_MIN` 이어야 머지 가능.** 1개라도 0 이면 화면 미동작 가능성.

추가 확인:
- [ ] `pnpm gen:procedures` 실행 후 `configs/types/procedures.d.ts` 에 신규 화면 타입 자동 추가됨
- [ ] `pnpm sync:i18n` 실행 후 KO/EN/CN locale 에 신규 키 모두 존재
- [ ] 브라우저에서 실제 메뉴 클릭 → 화면 로드 → 데이터 검색 → Grid 표시 확인
- [ ] **★ 등록 SQL 이 4개 파일 세트로 제공됨**: `{name}.sql` + `{name}_DBeaver.sql` + `{name}_DBeaver_Verify.sql` + `{name}_DBeaver_Diagnose.sql` (§7.1)
- [ ] **★ 각 `_DBeaver*.sql` 은 statement 1개만 포함** (PL/SQL 블록 1개 또는 SELECT 1개)
- [ ] **★ `_DBeaver*.sql` 어디에도 `/` 종결자 없음** (DBeaver ORA-00911 방지)

---

## §10. 롤백 절차

### 10.1 7개 영역 일괄 삭제 (자기완결형)

자기완결형 패턴은 외부 PKG 없이 직접 DELETE. 단일 PL/SQL 블록에 7개 영역 통합 가능.

```sql
DECLARE
    V_MENU_ID  CONSTANT VARCHAR2(20) := 'DMF0099';
BEGIN
    DELETE FROM SCM_ADM_MSG_M              WHERE MSG_ID = 'MNU_'||V_MENU_ID;
    DELETE FROM SCM_ADM_PROC_M             WHERE PROC_NM LIKE 'PKG_'||V_MENU_ID||'%';
    DELETE FROM SCM_MST_SHEET_COLUMNS      WHERE PROGRAM_ID = V_MENU_ID;
    DELETE FROM SCM_ADM_MNU_BTN_MPG_M      WHERE MNU_ID = V_MENU_ID;
    DELETE FROM SCM_ADM_USER_GR_MNU_BTN_MPG_M WHERE MNU_ID = V_MENU_ID;
    DELETE FROM SCM_ADM_USER_GR_MNU_MPG_M  WHERE MNU_ID = V_MENU_ID;
    DELETE FROM SCM_ADM_API_M              WHERE API_ID LIKE V_MENU_ID||'\_%' ESCAPE '\';
    DELETE FROM SCM_ADM_MNU_M              WHERE MNU_ID = V_MENU_ID;
    -- LBL/MSG 는 공유 자산이므로 화면 전용으로 채번한 코드만 선별 삭제 필요
    COMMIT;
END;
```

---

## §11. 관련 문서 / 자산

| 항목 | 경로 |
|---|---|
| FE/BE 화면 코드 템플릿 | `Doc/_dev_rules/05_SCREEN_TEMPLATE.md` |
| As-Is Validation / Expression → Wijmo 매핑 | `Doc/_dev_rules/09_WIJMO_VALIDATION_EXPRESSION.md` |
| 통합 SQL 등록 템플릿 (자기완결형) | `To-be_v2_converted/08_Screen_Registration/02_NEW_SCREEN_FULL_REGISTRATION_TEMPLATE.sql` |
| FE 타입 자동 생성 스크립트 | `To-be_v2_converted/08_Screen_Registration/04_gen-procedures.ts` |
| 동적 호출 SP | `To-be_v2_converted/06_Packages/04_Package_PKG_NSCM_UI_COMM.sql` (`PR_GET_PROC_INFO_LIST`) |
| 메타데이터 추출 SP | `To-be_v2_converted/08_Screen_Registration/03_PR_Get_Procedures_Metadata.sql` |
| SYS0001 (i18n) PKG | `To-be_v2_converted/06_Packages/04_Package_PKG_SYS0001.sql` |
| SYS0003 (MENU) PKG | `To-be_v2_converted/06_Packages/04_Package_PKG_SYS0003.sql` |
| SYS0004 (Sheet Cols) PKG | `To-be_v2_converted/06_Packages/04_Package_PKG_SYS0004.sql` |
| SYS0005 (Procedure) PKG | `To-be_v2_converted/06_Packages/04_Package_PKG_SYS0005.sql` |
| SYS0006 (API) PKG | `To-be_v2_converted/06_Packages/04_Package_PKG_SYS0006.sql` |
| SYS0008 (Group Menu) PKG | `To-be_v2_converted/06_Packages/04_Package_PKG_SYS0008.sql` |
| i18n MyBatis 쿼리 | `nscm-be/src/main/resources/sql/admin/Message.xml` |
| FE i18n 동기화 | `nscm-fe/scripts/sync-i18n.mjs` |

---

> **본 룰 적용 시 화면 1개 등록 = 7개 영역 × INSERT + FE 7개 파일 + 타입 정의 1개 + 라우트 1행** 으로 표준화됩니다.
> 7개 영역 중 1개라도 누락되면 화면이 동작하지 않거나 빈 데이터를 반환할 수 있으니 §9 체크리스트를 반드시 통과시키세요.
