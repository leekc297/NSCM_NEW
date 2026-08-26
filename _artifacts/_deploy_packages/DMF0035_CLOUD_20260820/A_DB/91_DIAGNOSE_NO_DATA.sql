-- =====================================================================================================
-- 91_DIAGNOSE_NO_DATA.sql — DMF0035 "전 TYPE 조회 0행" 원인 적출 (클라우드 실행용 · **SELECT 전용**)
--   신고: 2026-08-20 클라우드에서 MKT FCST / SALES PLAN / BIZ PLAN **3 TYPE 모두** 데이터가 안 나옴.
--
--   ⭐ 판독 원리 — 3 TYPE 이 **동시에** 0행이면 원인은 타입별 로직이 아니라 **공통 축**이다.
--      D2/D3 이 SP 내부의 자동 시딩 경로를 그대로 재현하므로, 여기서 0 이 나오는 축이 곧 원인이다.
--
--   [SP 구조 근거 — PKG_DMF0035 BODY L309~331 LIVE]
--      ① 사용자별 measure 세트(SCM_MST_TITLESET_USER, USER_INQUIRY_COLUMN_TYPE_CODE='M')를 먼저 센다.
--      ② 0 건이면 `SCM_MST_SHEET_MEASURE` 에서 **SHEET_NAME='Mkt Fcst Waterfall' AND DEFAULT_FLAG='Y'
--         AND VALID_YN='Y'** 행으로 **자동 시딩**한다.
--      ③ 조회는 이 measure 세트를 조인해 나간다 ⇒ ②가 0행이면 세트가 비고 **전 TYPE 0행**이 된다.
--      ⚠ `SCM_MST_TITLESET_USER` 는 **이관 제외 축**(개인 설정)이라 클라우드에는 그 사용자 행이 없다.
--        정상 동작은 ②의 자동 시딩에 전적으로 의존한다 — 즉 SHEET_MEASURE 적재가 곧 생명선이다.
--
--   ⚠ sheet_name 3체계 (개명 금지 — PKG 변수 실측):
--        SHEET_COLUMNS/SHEET_MEASURE : 'Mkt Fcst Waterfall' / 'Sales Plan Waterfall' / 'Biz Plan Waterfall'
--        TITLESET_USER               : 'mktFcstWaterfall' / 'salesPlanWaterfall'
-- =====================================================================================================
SET LINESIZE 200
SET PAGESIZE 200

PROMPT ===== D0. 최근 DMF0035 호출 로그 (파라미터·소요·결과행수) =====
--  RESULT_COUNT 가 0 인지, EXCEPTION 이 있는지부터 본다. 예외가 있으면 아래 축보다 그것이 우선.
SELECT LOG_SEQ, SQL_ID, ELAPSED_MS, RESULT_COUNT,
       TO_CHAR(EXECUTE_TIME,'MM-DD HH24:MI') EXEC_T, CREATED_BY,
       DBMS_LOB.SUBSTR(EXCEPTION, 200, 1) ERR
  FROM SCM_MGR.SCM_COM_SQL_LOG
 WHERE EXECUTE_TIME > SYSDATE - 1
   AND (DBMS_LOB.INSTR(PARAMS, 'DMF0035') > 0 OR DBMS_LOB.INSTR(PARAMS, 'WATERFALL') > 0)
 ORDER BY EXECUTE_TIME DESC FETCH FIRST 10 ROWS ONLY;

PROMPT ===== D1. ⭐ SHEET_MEASURE — 자동 시딩 원천 (여기가 0 이면 그것이 원인) =====
--  기대: 3 시트 각각 DEFAULT_Y >= 1. 사내 실측 = Mkt 73행 / Sales 84행 / Biz 16행(전체 기준).
SELECT SHEET_NAME,
       COUNT(*)                                                    AS TOT,
       SUM(CASE WHEN VALID_YN = 'Y' THEN 1 ELSE 0 END)             AS VALID_Y,
       SUM(CASE WHEN VALID_YN = 'Y' AND DEFAULT_FLAG = 'Y' THEN 1 ELSE 0 END) AS DEFAULT_Y,
       CASE WHEN SUM(CASE WHEN VALID_YN='Y' AND DEFAULT_FLAG='Y' THEN 1 ELSE 0 END) = 0
            THEN '*** FAIL — 시딩 원천 0행 → 전 TYPE 0행 ***' ELSE 'OK' END AS VERDICT
  FROM SCM_MGR.SCM_MST_SHEET_MEASURE
 WHERE PROGRAM_ID IN ('DMF0035','DMF0022','DMF0051')
   AND SHEET_NAME IN ('Mkt Fcst Waterfall','Sales Plan Waterfall','Biz Plan Waterfall')
 GROUP BY SHEET_NAME ORDER BY SHEET_NAME;

PROMPT -- 사내(정본) 기준선 실측 2026-08-20 — 클라우드 값이 이와 다르면 22_SHEET_META_SYNC 축 문제
PROMPT --   Biz Plan Waterfall   : TOT 9  / VALID_Y 9  / DEFAULT_Y 9
PROMPT --   Mkt Fcst Waterfall   : TOT 49 / VALID_Y 23 / DEFAULT_Y 3
PROMPT --   Sales Plan Waterfall : TOT 31 / VALID_Y 27 / DEFAULT_Y 12

PROMPT ===== D1b. SHEET_MEASURE division 축 — 조회 division 이 토큰에 포함돼 있는가 =====
--  SP 는 measure 를 division 별로 거른다(BODY L404). 조회 division(예 '40')이 DIVISION_ID 콤마목록에
--  없으면 measure 가 0 이 되어 역시 전 TYPE 0행이 된다.
SELECT SHEET_NAME, DIVISION_ID, COUNT(*) CNT
  FROM SCM_MGR.SCM_MST_SHEET_MEASURE
 WHERE PROGRAM_ID IN ('DMF0035','DMF0022','DMF0051')
   AND SHEET_NAME IN ('Mkt Fcst Waterfall','Sales Plan Waterfall','Biz Plan Waterfall')
   AND VALID_YN = 'Y'
 GROUP BY SHEET_NAME, DIVISION_ID ORDER BY 1, 2;

PROMPT ===== D2. ⭐ TITLESET_USER — 시딩 결과 (조회 시도 후에도 0 이면 D1 이 원인) =====
--  이관 제외 축이므로 최초엔 0 이 정상. **조회를 1회 시도한 뒤에도 0** 이면 시딩이 실패한 것.
SELECT SHEET_NAME, USER_INQUIRY_COLUMN_TYPE_CODE AS TP, COUNT(*) CNT
  FROM SCM_MGR.SCM_MST_TITLESET_USER
 WHERE PROGRAM_ID IN ('DMF0035','DMF0022','DMF0051')
   AND USER_ID = USER   -- ⚠ 앱 로그인 계정으로 조회할 때는 USER 대신 해당 USER_ID 리터럴로 바꿀 것
 GROUP BY SHEET_NAME, USER_INQUIRY_COLUMN_TYPE_CODE ORDER BY 1,2;

PROMPT ===== D2b. TITLESET_USER — 전체 사용자 기준 (계정 무관하게 시딩이 되고는 있는가) =====
SELECT PROGRAM_ID, SHEET_NAME, COUNT(DISTINCT USER_ID) USERS, COUNT(*) ROWS_
  FROM SCM_MGR.SCM_MST_TITLESET_USER
 WHERE PROGRAM_ID IN ('DMF0035','DMF0022','DMF0051')
 GROUP BY PROGRAM_ID, SHEET_NAME ORDER BY 1,2;

PROMPT ===== D3. SHEET_COLUMNS — 컬럼 축 (0 이면 그리드 골격 자체가 안 나옴) =====
SELECT PROGRAM_ID, SHEET_NAME, COUNT(*) CNT,
       SUM(CASE WHEN VISIBLE_FLAG='Y' THEN 1 ELSE 0 END) VISIBLE_Y
  FROM SCM_MGR.SCM_MST_SHEET_COLUMNS
 WHERE SHEET_NAME IN ('Mkt Fcst Waterfall','Sales Plan Waterfall','Biz Plan Waterfall')
 GROUP BY PROGRAM_ID, SHEET_NAME ORDER BY 1,2;

PROMPT ===== D4. PROC_M — 24_PROC_M_SYNC 적용 확인 (미적용이면 PLS-00306) =====
SELECT PROC_NM, COUNT(*) PROC_M_CNT
  FROM SCM_MGR.SCM_ADM_PROC_M
 WHERE PROC_NM IN ('PKG_DMF0035.P_DMF0035_GET_MKT_FCST_WATERFALL',
                   'PKG_DMF0035.P_DMF0035_GET_SPREAD_TITLE',
                   'PKG_DMF0022.P_DMF0022_GET_DM_PLN_SALES_PLAN_WATERFALL',
                   'PKG_DMF0022.P_DMF0022_GET_SPREAD_TITLE',
                   'PKG_DMF0051.P_DMF0051_GET_DM_PLN_BIZ_PLAN_WATERFALL',
                   'PKG_DMF0051.P_DMF0051_GET_SPREAD_TITLE',
                   'PKG_SCM0002.P_SCM0002_GET_VERSIONBYWATERFALLPOPUP')
 GROUP BY PROC_NM ORDER BY 1;

PROMPT ===== D5. PKG 상태 — 4본 VALID 인가 =====
SELECT OBJECT_NAME, OBJECT_TYPE, STATUS, TO_CHAR(LAST_DDL_TIME,'MM-DD HH24:MI') LAST_DDL
  FROM ALL_OBJECTS
 WHERE OWNER = 'SCM_MGR'
   AND OBJECT_NAME IN ('PKG_DMF0035','PKG_DMF0022','PKG_DMF0051','PKG_SCM0002')
 ORDER BY OBJECT_NAME, OBJECT_TYPE;

PROMPT ===== D6. 원장 데이터 — 조회할 데이터가 애초에 있는가 (MKT 축) =====
--  ⚠ 여기가 0 이면 메타·SP 가 아니라 **데이터 자체가 없는 것**이다(QA DB 적재 여부 확인).
SELECT 'DM_PLN_MKT_FCST'   AS TB, COUNT(*) CNT FROM SCM_MGR.DM_PLN_MKT_FCST
UNION ALL SELECT 'DM_PLN_MKT_FCST_C',            COUNT(*) FROM SCM_MGR.DM_PLN_MKT_FCST_C
UNION ALL SELECT 'DM_PLN_CFM_MKT_DEMAND_PLAN',   COUNT(*) FROM SCM_MGR.DM_PLN_CFM_MKT_DEMAND_PLAN
UNION ALL SELECT 'DM_PLN_MKT_FCST_RESULT',       COUNT(*) FROM SCM_MGR.DM_PLN_MKT_FCST_RESULT;

PROMPT ===== D7. 콤보 — Bucket/QtyType 이 비면 조회조건을 못 고른다 =====
SELECT SQL_ID, USE_YN FROM SCM_MGR.SCM_ADM_CMBO_SQL_M
 WHERE SQL_ID IN ('QtyType','ReportBucketType','BucketType2','MyDivision') ORDER BY 1;

PROMPT ===== D8. GTT 실존 — 01_DDL_GTT 적용 확인 (미적용이면 ORA-00942) =====
SELECT COUNT(*) AS GT_DM35_CNT FROM ALL_TABLES
 WHERE OWNER='SCM_MGR' AND TABLE_NAME LIKE 'GT_DM35%' AND TEMPORARY='Y';

PROMPT ===== 판독 순서 =====
PROMPT   D0 에 EXCEPTION 이 있으면 → 그 오류가 원인 (아래 무시)
PROMPT   D1 DEFAULT_Y = 0        → 22_SHEET_META_SYNC 미적용/누락 = **가장 유력**. 적용 후 재조회
PROMPT   D1 OK 인데 D2 가 0      → 시딩은 되는데 조회 전이면 정상. 조회 1회 후 재확인
PROMPT   D4 가 0                 → 24_PROC_M_SYNC 미적용 (PLS-00306)
PROMPT   D5 INVALID              → PKG 재컴파일 필요
PROMPT   D6 이 0                 → 메타 문제 아님. 클라우드에 원장 데이터가 없음
PROMPT   D8 이 0                 → 01_DDL_GTT 미적용
