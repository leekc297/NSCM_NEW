# DMF0082 Excel Upload — AS-IS MSSQL SP 3종 → Oracle 19c 변환 REPORT

- **작업일**: 2026-07-12
- **범위**: 파일 산출물만 작성 (⚠️ **DB 미적용** — CREATE/ALTER/INSERT/UPDATE/DELETE/COMMIT 실행 0건, SELECT 실측만 수행)
- **원본**: AS-IS MSSQL dev (`asis.py proc dbo.<SP>`) / TO-BE 실측: SCM_MGR (SELECT only)
- **파이프라인**: `02_SP_CONVERSION_PIPELINE.md` Stage 0(원본 확보) + Stage 1(변환 + 부록 C 1-pass) 까지 수행.
  Stage 2(컴파일)~6(사내 적용)은 DB 적용 금지 지시로 **미수행** — 적용 시 `compile_check` + `silent_fail_audit.sql` + smoke 필수.

## 산출물 인벤토리

| 파일 | 내용 | 라인수 |
|---|---|---:|
| `asis_DMF0082_EXCEL_UPLOAD.sql` | AS-IS 원문 | 1,140 |
| `asis_DMF0082_GET_EXCEL_UPLOAD_DATA.sql` | AS-IS 원문 | 596 |
| `asis_DMF0082_GET_MAIN_DATA_CURRENT.sql` | AS-IS 원문 | 2,125 |
| `00_gtt_ddl.sql` | 신규 GTT 5종 (GET_EXCEL_UPLOAD_DATA 전용) + 인덱스/통계/GRANT/SYNONYM | 210 |
| `01_DMF0082_GET_MAIN_DATA_CURRENT.sql` | Oracle CREATE OR REPLACE | 1,854 |
| `02_DMF0082_GET_EXCEL_UPLOAD_DATA.sql` | Oracle CREATE OR REPLACE | 724 |
| `03_DMF0082_EXCEL_UPLOAD.sql` | Oracle CREATE OR REPLACE | 932 |
| `04_proc_m_api_btn_wiring.sql` | PROC_M/API_M/BTN_MPG/USER_GR 멱등 MERGE | 218 |

## GTT 전략 (실측 기반)

- **`GT_DMF0082_*` 25종 + `GTT_*` 98종 인벤토리 실측** (`ALL_TABLES`/`ALL_TAB_COLUMNS`).
- **01 (GET_MAIN_DATA_CURRENT)**: 기존 **`GTT_*` family 13종 전량 재사용** — AS-IS CURRENT 의 #temp 13종과 컬럼 1:1 일치 확인
  (`GTT_TEMPSITEITEM(ALL)` 38컬럼 = AS-IS CREATE TABLE 정확 일치, `GTT_MF_SP` 58컬럼, `GTT_TEMPFCSTNPRICE` 49컬럼,
  `GTT_TEMP_INTO_GROUP_MEASURE` 7컬럼, `GTT_TEMP_ADMIN_GROUP_MEASURE`(MEASURE,EDIT_FLAG) 등). **신규 DDL 불필요.**
  ※ `GT_DMF0082_*` family 는 구(버전형) `DMF0082_GET_MAIN_DATA` 변환용으로 CURRENT 변형과 컬럼 불일치 → 미사용.
- **02 (GET_EXCEL_UPLOAD_DATA)**: `%FCST_PRICE%` GTT 미존재 → `00_gtt_ddl.sql` 에 **신규 5종**
  (`GT_DMF0082_FCST_PRICE_EXCEL/_UNPIVOT/_BUCKET/_WEEKLY/_DAILY`, ON COMMIT PRESERVE ROWS + 세션통계 + 인덱스).
- **03 (EXCEL_UPLOAD)**: 활성 코드에 #temp 없음(주석 블록에만 존재) → GTT 불필요.
- GTT 초기화는 전량 **`DELETE FROM`** (C-2 TRUNCATE 금지 / C-5 INSERT 전 DELETE).

## 파라미터 시그니처 (변환본 = PROC_M positional 1:1)

### 1) `DMF0082_GET_MAIN_DATA_CURRENT` (AS-IS 12 IN → + 6 OUT)

| # | 파라미터 | 방향/타입 | PROC_M COL_NM |
|--:|---|---|---|
| 1 | p_division_id | IN VARCHAR2 | divisionId |
| 2 | p_team_id | IN VARCHAR2 | team |
| 3 | p_customer | IN VARCHAR2 | endCustomer |
| 4 | p_biz_type | IN VARCHAR2 | bizType |
| 5 | p_from_yyyymmdd | IN VARCHAR2 | startDate |
| 6 | p_to_yyyymmdd | IN VARCHAR2 | endDate |
| 7 | p_scm_site_id | IN VARCHAR2 | salesSite |
| 8 | p_item_id | IN VARCHAR2 | itemId |
| 9 | p_version_type | IN VARCHAR2 | version |
| 10 | p_qty_yn | IN VARCHAR2 | qtyYn |
| 11 | p_created_by | IN VARCHAR2 | **sesUserId** (BE 자동주입 — PKG_DMF0082 준거) |
| 12 | p_user_group | IN VARCHAR2 | userGroup |
| 13~17 | O_RC1~O_RC5 | OUT SYS_REFCURSOR | o_rc1~o_rc5 (CURSOR) |
| 18 | O_RESULT_CURSOR | OUT SYS_REFCURSOR | o_result_cursor (PROC_RESULT) |

결과셋 5개 = AS-IS 의 5개 SELECT 와 1:1 (① 동적 PIVOT 메인 ② M+3 월 TOP1 ③ 현재/전주 주차 ④ MEASURE/EDIT_FLAG ⑤ 캘린더 분배 정보).

### 2) `DMF0082_GET_EXCEL_UPLOAD_DATA` (AS-IS 1 IN, 결과셋 2)

| # | 파라미터 | 방향/타입 | PROC_M COL_NM |
|--:|---|---|---|
| 1 | p_created_by | IN VARCHAR2 | createdBy (DMF0014/0074 upload 표준) |
| 2 | O_RC1 (RECORD 형식 일자별 수량) | OUT SYS_REFCURSOR | o_rc1 (CURSOR) |
| 3 | O_RC2 (PIVOT 형식 — 동적 D컬럼) | OUT SYS_REFCURSOR | o_rc2 (CURSOR) |
| 4 | O_RESULT_CURSOR | OUT SYS_REFCURSOR | o_result_cursor (PROC_RESULT) |

### 3) `DMF0082_EXCEL_UPLOAD` (AS-IS @p_mode INT, @p_created_by)

| # | 파라미터 | 방향/타입 | PROC_M COL_NM |
|--:|---|---|---|
| 1 | p_mode | IN **NUMBER** (2-Step: 0=검증분류, >0=저장 게이트) | mode (NUMBER) |
| 2 | p_created_by | IN VARCHAR2 | createdBy |
| 3 | O_RESULT_CURSOR (SUCCESS/ERROR 건수) | OUT SYS_REFCURSOR | o_result_cursor (PROC_RESULT) |

## 함정 처리 체크리스트 (부록 C 11종 — 변환 중 1-pass 적용)

| # | 함정 | 01 CURRENT | 02 GET_UPLOAD_DATA | 03 EXCEL_UPLOAD |
|---|---|---|---|---|
| C-1 | SUBSTR(s,0,n) | ✅ OWNER 첫 토큰 `SUBSTRING(F.OWNER,0,…)` → `SUBSTR(s,1,INSTR-1)` 보정 | ✅ 해당 없음 (grep 0) | ✅ 해당 없음 (grep 0) |
| C-2 | GTT TRUNCATE 금지 | ✅ DELETE FROM 13건 | ✅ DELETE FROM 5건 | ✅ GTT 없음 |
| C-3 | LISTAGG OVERFLOW | ✅ OWNER LISTAGG — user명 결합, 4000 초과 비현실(OWNER 1000B). 미적용 사유 명시 | 해당 없음 | 해당 없음 |
| C-4 | JSON_OBJECT RETURNING CLOB | ✅ 미사용 (V_PROC_INPUT VARCHAR2) | ✅ 동일 | ✅ 동일 |
| C-5 | GTT INSERT 전 DELETE | ✅ SP 시작부 일괄 DELETE | ✅ 동일 | 해당 없음 |
| C-6 | OUT cursor OPEN 보장 | ✅ 6 cursor 전 분기 OPEN (빈리스트 가드 포함) | ✅ 3 cursor (가드 포함) | ✅ 1 cursor |
| C-7 | ''=NULL | ✅ IS NULL/IS NOT NULL 치환 + `DEFAULT_FLAG=''`→IS NULL(실측 NULL 11건) + ''표시값→NULL | ✅ UNPIVOT INCLUDE NULLS + NVL(QTY,'0') / ''AS LAST_DAY_YN→NULL | ✅ 필수값/중복(NVL '-')/빈 요일·시간 판정 |
| C-8 | CMBO @var quote | 해당 없음 | 해당 없음 | 해당 없음 |
| C-9 | ^-delim token | 해당 없음 (콤마 split 만) | 해당 없음 | ✅ 첫 토큰 INSTR/SUBSTR |
| C-10 | @@FETCH_STATUS 무한루프 | ✅ C_BUCKET/C_TITLE → FETCH 직후 `EXIT WHEN %NOTFOUND` | ✅ C_PIVOT 동일 | ✅ 커서 없음 |
| C-11 | 세션 NLS 의존 | ✅ TO_DATE/TO_CHAR 전건 명시 마스크 + `'DY','NLS_DATE_LANGUAGE=ENGLISH'` | ✅ 전건 명시 마스크 (LAST_DAY/DD 포함) | ✅ 전건 명시 마스크 |

추가 룰 적용: TOP n→FETCH FIRST / NOLOCK·bracket·dbo. 제거 / IIF→CASE / `+`→`||` / STUFF FOR XML→LISTAGG /
STRING_SPLIT→REGEXP_SUBSTR CONNECT BY(빈 입력 = NVL(REGEXP_COUNT,0)+1 로 1행 보존) / ISNUMERIC→VALIDATE_CONVERSION /
UPDATE JOIN→MERGE(GROUP BY+MAX, ORA-30926 방지) 또는 상관 Scalar Subquery+EXISTS(룰 #30, 다중매치는 MAX 결정적 채택) /
OUTER APPLY TOP(1)→LEFT JOIN LATERAL+FETCH FIRST / `WHILE LEN>0 PRINT 4000자` 디버그 루프→DBMS_LOB.SUBSTR 루프 1:1 유지.

## grep 게이트 결과 (2026-07-12 실행)

| 게이트 | 01 | 02 | 03 | 판정 |
|---|---|---|---|---|
| FETCH 수 = NOTFOUND 처리 수 (코드) | 2 = 2 | 1 = 1 | 0 = 0 | **PASS** |
| TRUNCATE 잔존 (코드) | 0 | 0 | 0 | **PASS** (주석 내 언급만) |
| ISNULL/GETDATE/DATEADD/CHARINDEX/IIF/STRING_SPLIT/NOLOCK/EOMONTH/DATEPART/SP_EXECUTESQL/@@/STUFF/FOR XML/TOP n/CONVERT 잔존 (코드) | 0 | 0 | 0 | **PASS** (히트 전건 AS-IS 원문 보존 주석) |
| NLS 무마스크: 단일인자 TO_DATE / 무마스크 TO_CHAR(date) | 0 | 0 | 0 | **PASS** |
| SUBSTR(x, 0, …) | 0 | 0 | 0 | **PASS** |

## 원문 대비 라인수

| SP | AS-IS | Oracle 변환본 | 비고 |
|---|---:|---:|---|
| DMF0082_GET_MAIN_DATA_CURRENT | 2,125 | 1,854 | AS-IS 內 주석처리된 구식 ORI/A/B 빌드 블록(287~407행)은 원문 자체가 dead — 대체 주석으로 축약 |
| DMF0082_GET_EXCEL_UPLOAD_DATA | 596 | 724 | GTT 컬럼 명시 리스트 + 표준 커서/핸들러 추가로 증가 |
| DMF0082_EXCEL_UPLOAD | 1,140 | 932 | AS-IS 889~1120행 주석 테스트 블록(비실행) 미이관 — `asis_*.sql` 에 원문 보존, 실 로직은 02 에 정식 구현 |

## 의도적 결정 사항 (silent 변경 아님 — 전건 파일 헤더에도 명시)

1. **표준 커서 확장**: AS-IS 는 O_RESULT_CURSOR 없음 → 3 SP 모두 표준 `O_RESULT_CURSOR('0'/RESULT_MSG/EVENT)` 추가
   (기존 Oracle `DMF0082_SAVE_MAIN_DATA`/`DMF0082_GET_MAIN_DATA` 표준·sp-dual-cursor-pattern 준수).
2. **03 중복 체크의 Currency 정규화**: MSSQL `ISNULL(ATTRIBUTE9,'')` ↔ 외부 `= ATTRIBUTE9` 비교를 Oracle 에서 `NVL(…,'-')` 양쪽 정렬 —
   MSSQL 의 ''(빈문자열) 행 매칭 동작 보존 목적 (Oracle 은 '' = NULL 이라 strict 비교 시 해당 행 누락).
3. **03 UPDATE JOIN → Scalar Subquery `MAX()`**: 코드 매핑 다중행 시 MSSQL 은 임의 1행 채택(비결정) → ORA-01427 방지 겸 `MAX()` 결정적 채택.
4. **01 CURRENCY 일괄 UPDATE → MERGE + GROUP BY/MAX**: 동일 9-키 복수 통화 시 MSSQL 임의채택 → ORA-30926 방지 위해 MAX 결정화.
5. **01 동적 SQL W/M SUM 분기 GROUP BY 에 `F.MEASURE` 명시 추가**: SELECT 의 `CASE WHEN F.MEASURE IN …` 참조 —
   MEASURE 가 사용자 컬럼(V_COLUMN)에 포함되면 중복 group-by(무해), 미포함이면 AS-IS 도 MSSQL 에서 오류였던 케이스의 방어.
6. **01 `[@v_PV_COL_LIST]` 치환 원문 버그 교정**: MSSQL 은 두 리스트가 동일 문자열이라 무해했으나 Oracle 은 PIVOT IN 형식과 SELECT 형식이 다름 → 각각 올바르게 치환.
7. **02 UNPIVOT INCLUDE NULLS**: MSSQL 은 ''(빈 셀) 행 유지+0 처리, Oracle 은 ''=NULL 로 UNPIVOT 탈락 → INCLUDE NULLS + `NVL(QTY,'0')` 동등화.
8. **03 @@ROWCOUNT quirk 미재현**: MSSQL 은 `SET` 문이 @@ROWCOUNT 를 리셋해 로그 description 이 실제 건수가 아니었음 → UPDATE 직후 `SQL%ROWCOUNT` 즉시 캡처(원 의도 보존).
9. **AS-IS 하드코딩 보존**: `DIVISION_ID='40'` 리터럴(01 TempSiteItemAll WHERE·LOOKA / 02 DAILY BC 서브쿼리), 숫자검증 M4~M12 한정(M13~M16 미검증) 등 원문 그대로 (임의 수정/확장 금지).
10. **01 SCM_MST_SITE.DEPT_ID → F.DEPT_ID**: 사내 SCM_MST_SITE.DEPT_ID 컬럼 삭제(Case 39) — 기존 변환본(DMF0082_GET_MAIN_DATA)과 동일 처리, K 조인은 SELECT 미참조라 결과 영향 0.
11. **04 배선 설계**: DMF0014/0074 2-Step 표준(UPLOAD/UPLOAD_SAVE=PROC, mode NUMBER) + UPLOAD_DATA/SEARCH_CURRENT 추가.
    업로드 3버튼 = ADMIN·DM ADMIN (Viewer 제외), SEARCH_CURRENT = 기존 SEARCH 와 동일 3그룹. API_MSG_ID='-' (기존 DMF0082 행 스타일).
    ※ FE 배선명(UPLOAD_DATA/SEARCH_CURRENT)은 화면 구현 시 hotkeyConfig 와 대사 필요.

## 적용 시 절차 (본 작업 범위 외 — 참고)

1. `00_gtt_ddl.sql` (GTT 5종 — SCM_MGR)
2. `01` → `02` → `03` (CREATE OR REPLACE, CRLF 제거 후 apply.sh)
3. GRANT EXECUTE + SYNONYM (SCMD_APP — -9994 90% 원인): 3 SP 각각
   `GRANT EXECUTE ON SCM_MGR.<SP> TO SCMD_APP;` + `CREATE OR REPLACE SYNONYM SCMD_APP.<SP> FOR SCM_MGR.<SP>;`
4. `04_proc_m_api_btn_wiring.sql`
5. Stage 2~4: compile_check(VALID 3/3) → silent_fail_audit 0건 → smoke call (mode=0 검증 → GET_UPLOAD_DATA → SAVE_MAIN_DATA 체인) → PROC_M↔ALL_ARGUMENTS diff 0건 (04 말미 검증 SQL 동봉)
