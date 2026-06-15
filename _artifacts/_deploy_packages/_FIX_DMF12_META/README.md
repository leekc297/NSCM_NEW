# DMF12 신규 화면 메타 일괄 재작성 fix (2026-06-08)

## 목적

DMF12 신규 화면 (DMF0014/0021/0042/0044/0048/0049/0074/0081/0082) 의 **9 PKG / 52 SP / 484 args** 메타 일괄 등록.

기존 9 메타 SQL 파일 (`010_DMF{ID}_meta.sql`) 모두 잘못된 컬럼명 (`MNU_NM/MNU_LVL/SHT_NM/HDR_NM` 등) 사용 → ORA-00904 실패. 자매 표준 (DMF0072) 패턴으로 재작성 + 자동 변환 SQL 으로 일괄 처리.

## 적용 결과 (Verify PASS)

| BLOCK | 테이블 | 신규 row | 결과 |
|---|---|---:|---|
| 1 | MSG_M (API msg, KO) | 52 | PASS |
| 2 | API_M (PKG_DMFxxxx.P_DMFxxxx_xxx URL) | 52 | PASS |
| 3 | MNU_BTN_MPG_M (sheet='main') | 52 (+ 기존 2 = 54) | PASS |
| 4 | PROC_M (자동 변환 P_USER_ID→sesUserId 등) | 484 | PASS |
| 5 | USER_GR_MNU_BTN_MPG_M (ADMIN/DM ADMIN/DM Viewer/GUEST × 52) | 208 (+ 기존 8 = 216) | PASS |

화면별 cross-check:

| 화면 | API | PROC | BTN | GR_BTN |
|---|---:|---:|---:|---:|
| DMF0014 | 5 | 50 | 5 | 20 |
| DMF0021 | 3 | 25 | 3 | 12 |
| DMF0042 | 10 | 93 | 10 | 40 |
| DMF0044 | 17 | 167 | 17 | 68 |
| DMF0048 | 1 | 23 | 1 | 4 |
| DMF0049 | 2 | 13 | 2 | 8 |
| DMF0074 | 3 | 24 | 3 | 12 |
| DMF0081 | 6 | 54 | 6 | 24 |
| DMF0082 | 5 | 35 | 7 | 28 |

## 파일 세트

| 파일 | 용도 |
|---|---|
| `002_DMF12_meta_full.sql` | 메인 sqlplus (PROMPT 포함) — 1차 시도 (BLOCK 5 PROC_M 484 PASS, BLOCK 2/3/4 ORA-12899 FAIL) |
| `003_DMF12_meta_msg_api_btn_fix.sql` | 1차 fix — SUBSTR(50) 적용 BLOCK 2/3/4/6 (적용 PASS) |
| `002_DMF12_meta_full_DBeaver.sql` | DBeaver 호환 통합 (DML 만, SET/PROMPT 0건, 멱등 재실행 안전) |
| `002_DMF12_meta_full_Verify.sql` | 5 BLOCK PASS/FAIL + 화면별 카운트 |
| `002_DMF12_meta_full_Diagnose.sql` | 사고 재발 진단 5 항목 + SP 별 ARG mismatch |
| `README.md` | 본 파일 |

## 사고 진단 + fix

### 사고 — ORA-12899 (SP 이름 50자 초과)
- `P_DMF0081_GET_DDL_DM_YEARLY_MKT_DMD_ANALYSIS_EXCEL_UPLOAD` = 57자 (MSG_ID/API_ID/API_MSG_ID 컬럼 max 50)
- **fix**: `SUBSTR(SP_NAME, 1, 50)` 적용 — 가장 긴 2 SP 의 첫 50자 unique 검증 후 안전.

## 자동 변환 핵심 (PL/SQL CASE — BLOCK 5 PROC_M)

```sql
CASE UPPER(A.ARGUMENT_NAME)
  WHEN 'P_USER_ID'        THEN 'sesUserId'
  WHEN 'P_MENU_ID'        THEN 'mnuId'
  WHEN 'P_LANG_CD'        THEN 'sesLangCd'
  WHEN 'P_CREATED_BY'     THEN 'createdBy'
  WHEN 'P_USERINFO'       THEN 'userInfo'
  WHEN 'O_RESULT_CURSOR'  THEN 'O_RESULT_CURSOR'
  WHEN 'O_ERROR_CURSOR'   THEN 'O_ERROR_CURSOR'
  ELSE
    CASE
      WHEN UPPER(A.ARGUMENT_NAME) LIKE 'O_%' THEN LOWER(A.ARGUMENT_NAME)  -- O_RC1 → o_rc1
      WHEN UPPER(A.ARGUMENT_NAME) LIKE 'P_%' THEN
        LOWER(SUBSTR(REPLACE(INITCAP(LOWER(REPLACE(SUBSTR(ARGUMENT_NAME,3),'_',' '))),' ',''),1,1)) ||
        SUBSTR(REPLACE(INITCAP(LOWER(REPLACE(SUBSTR(ARGUMENT_NAME,3),'_',' '))),' ',''),2)
        -- P_DIVISION_ID → 'DIVISION_ID' → 'division id' → 'Division Id' → 'DivisionId' → 'divisionId'
      ELSE LOWER(A.ARGUMENT_NAME)
    END
END
```

## 누락 사고 (별도 처리 필요)

### 1. SHEET_COLUMNS (Grid column 정의)
- 기존 9 메타 SQL 의 SHEET_COLUMNS INSERT 도 잘못된 컬럼명 (`SHT_NM/HDR_NM` 등) 사용 — 적용 안 됨
- 정확 컬럼: `SHEET_NAME`/`COLUMN_LABEL_NAME`/`SORT_ORDER_NO`/`HORIZONTAL_ALIGN_CODE`/`CELL_CONTROL_OBJECT_TYPE_CODE` 등 36개
- 화면별 grid column 의미 분석 필요 (대량) — 자동 일괄 어려움. 화면별 정밀 처리.
- 일부 화면 (DMF0021/42/44/48/49/74/81/82) 에 잔존 row 있으나 컬럼명 부분 일치 (수동 정정 또는 신규 INSERT)

### 2. PKG body INVALID (7건)
- `PKG_DMF0014/0021/0042/0044/0049/0074/0081` body INVALID
- 메타 등록되어 있어도 SP 호출 자체 실패 (PLS-00306 또는 ORA-04063)
- 진단: AS-IS .cs cross-check + PKG body 재컴파일 + SP body 1:1 변환 검증
- 사고 #3 별도 처리

### 3. PKG body 없음 (2건)
- `PKG_DMF0048/0082` — PACKAGE 정의만 있고 body 없음
- AS-IS 1:1 변환 필요
- 사고 #3 별도 처리

### 4. PKG 자체 없음 (3건)
- `DMF0042_1/0042_2/0042_3` — 신규 SP body 작성 필요
- AS-IS DMF0042 variant 분석 + 신규 작성
- 사고 #3 별도 처리

## 다음 단계 (사용자 결정)

본 메타 fix 후 화면 진입 시 — **메타 측면 정상 (API_M/PROC_M/BTN_MPG 모두 OK)** 이지만 PKG body 사고로 SP 호출 자체 실패 가능. 화면 진입 후 console error 발생 시:

- ORA-04063 / PLS-00306 → 사고 #3 진행 (PKG body 진단/fix)
- "Query is not exist" → 메타 누락 (재발 시 Diagnose 실행)
- SHEET_COLUMNS 빈 grid → 사고 SHEET_COLUMNS 별도 정밀 처리

## cross-ref

- 메모리 `feedback_proc_meta_mandatory.md` (PROC_M 자동 변환 표)
- 메모리 `feedback_sql_idempotent_insert_all.md` (NOT EXISTS 멱등)
- 메모리 `feedback_dbeaver_sql_mandatory_grep.md` (DBeaver SET/PROMPT 0건)
- 자매 reference: `_artifacts/_deploy_packages/DMF0072/03_META/010_DMF0072_meta_full.sql`
- 룰 08 §4.4 (PROC_M ARGUMENT_NAME → COL_NM 자동 변환)
- 룰 12 §2.4.1 (PROC_M dual cursor 표준)
