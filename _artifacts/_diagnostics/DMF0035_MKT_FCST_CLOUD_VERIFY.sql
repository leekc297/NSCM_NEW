--------------------------------------------------------------------------------
-- DMF0035 MKT FCST — 클라우드 조회건수 차이 진단 스크립트
--------------------------------------------------------------------------------
-- 신고 (2026-09-02): DIVISION 40 조회 시 AS-IS 765건 vs TO-BE 775건 = TO-BE 가 10건 많음
--                    메저 = MKT_FCST / SCM_FCST / CUST_FCST 3개
-- 계보 : REQ:CHAT-20260901-X12 (구 97건 차 775 vs 678) 의 후속 — 차이가 10건으로 좁혀진 상태
--
-- ⚠ 실행 규칙
--   1) 계정 = SCM_MGR
--   2) §4 이후는 GTT(SYS$SESSION) 를 읽으므로 **§4~§7 을 반드시 같은 세션에서 연속 실행**한다.
--      세션이 끊기면 GTT 내용이 사라져 전부 0건으로 보인다 (오진 주의).
--   3) SELECT 전용 + SP 조회 호출뿐 — 원장 변경 없음.
--   4) §1~§3 은 세션 무관(메타 조회)이라 언제든 단독 실행 가능.
--
-- 판정 흐름
--   §0 지문      : 클라우드 PKG 가 사내 정본과 같은 버전인가 (버전 드리프트 1순위 배제)
--   §1 메타      : 메저 마스터가 사내와 같은가 + X13(ROWNUM=1) 축
--   §2 titleset  : 사용자 저장 메저가 정말 3개인가 + 중복행 유무
--   §3 종속원천  : CUST_FCST 가 확장하는 종속메저의 원천 행
--   §4 SP 실행   : 단계별 GTT 건수로 어느 arm 에서 행이 생기/끊기는지
--   §5 SEL_MEASURE : 실제로 조회에 참여한 메저 전량 (기대 = 3 + 종속)
--   §6 메저별 건수 : ⭐ AS-IS 와 1:1 대조할 표 — 여기서 +10 이 어느 메저인지 드러난다
--   §7 그리드행수 : 최종 화면 행수 재구성
--------------------------------------------------------------------------------

SET LINESIZE 300
SET PAGESIZE 200
-- ⚠ SERVEROUTPUT 는 반드시 OFF. PKG_DMF0035 는 실행 중 동적 SQL 전문(V_COL_LIST/V_SQL_SELECT/
--   T_WF_DATA 쿼리 전체)을 DBMS_OUTPUT 으로 쏟아내며, ON 이면 그 덤프가 수만 자를 차지해
--   정작 판정에 쓸 §4~§7 결과가 화면·로그에서 잘려나간다 (2026-09-02 클라우드 1차 실행 실사고).
SET SERVEROUTPUT OFF
-- 컬럼 폭 정리 — 기본값이면 VARCHAR2(4000) 컬럼이 화면을 다 먹는다
COLUMN COLUMN_NAME    FORMAT A32
COLUMN MEASURE        FORMAT A32
COLUMN MEASURE_GROUP  FORMAT A16
COLUMN DIVISION_ID    FORMAT A42
COLUMN SHEET_NAME     FORMAT A22
COLUMN STAGE          FORMAT A26
COLUMN DB_NAME        FORMAT A16
COLUMN SERVER_HOST    FORMAT A20
COLUMN CONNECTED_AS   FORMAT A14
COLUMN OBJECT_NAME    FORMAT A18
COLUMN X13_EFFECT     FORMAT A30
COLUMN BRANCH         FORMAT A30
-- §4B 로그 컬럼 — FORMAT 을 안 주면 선언폭(LOG_MESSAGE 1000 / SQL_ERR_MSG 2000)대로 줄바꿈되어
--   로그 60행이 화면 수백 줄을 먹고 §5~§7 이 잘려나간다 (2026-09-02 클라우드 2차 실행 실사고).
COLUMN EVENT_TIME     FORMAT A20
COLUMN LOG_TYPE       FORMAT A8
COLUMN LOG_COUNT      FORMAT 9999999
COLUMN LOG_MESSAGE    FORMAT A42
COLUMN SQL_ERR_CODE   FORMAT A12
COLUMN SQL_ERR_MSG    FORMAT A60
COLUMN SRC_MEASURE      FORMAT A28
COLUMN DISPLAY_MEASURE  FORMAT A24
COLUMN ITEM             FORMAT A22

-- ▼▼ 신고와 동일한 조회조건으로 채울 것 ▼▼
DEFINE P_DIV      = '40'
DEFINE P_USER     = 'minyonglee1'
DEFINE P_VERSION  = 'CURRENT'
DEFINE P_FROM     = '20260901'
DEFINE P_TO       = '20261130'
DEFINE P_BUCKET   = 'WEEKLY'
-- ▲▲ 화면에서 실제로 조회한 값 그대로 (Version 은 화면 표기 그대로) ▲▲


PROMPT ================= §0 환경 지문 (버전 드리프트 배제) =================
-- 사내 정본 실측 2026-09-02: PKG_DMF0035 PACKAGE BODY = 4,234 라인
-- 라인 수가 다르면 그 시점에서 코드가 다르다 = 아래 진단보다 이관이 먼저다.
SELECT SYS_CONTEXT('USERENV','DB_NAME')     AS DB_NAME
     , SYS_CONTEXT('USERENV','SERVER_HOST') AS SERVER_HOST
     , USER                                 AS CONNECTED_AS
  FROM DUAL;

SELECT OBJECT_NAME, OBJECT_TYPE, STATUS, TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') AS LAST_DDL
  FROM ALL_OBJECTS
 WHERE OWNER = 'SCM_MGR' AND OBJECT_NAME = 'PKG_DMF0035'
 ORDER BY OBJECT_TYPE;

SELECT COUNT(*) AS PKG_BODY_LINES_EXPECT_4234
  FROM ALL_SOURCE
 WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0035' AND TYPE='PACKAGE BODY';


PROMPT ================= §1 메저 마스터 메타 (사내와 대조) =================
-- 사내 실측 2026-09-02: PROGRAM_ID='DMF0035' AND SHEET_NAME='Mkt Fcst Waterfall'
--   div 40 통과(자기 DIVISION_ID 에 40 포함) 행 수를 사내와 비교할 것.
SELECT COLUMN_NAME
     , DIVISION_ID
     , VALID_YN
     , DEFAULT_FLAG
     , SORT_ORDER_NO
     , CASE WHEN INSTR(','||DIVISION_ID||',', ',&P_DIV,') > 0 THEN 'Y' ELSE 'N' END AS OWN_DIV_MATCH
  FROM SCM_MGR.SCM_MST_SHEET_MEASURE
 WHERE PROGRAM_ID = 'DMF0035'
   AND SHEET_NAME = 'Mkt Fcst Waterfall'
 ORDER BY SORT_ORDER_NO, COLUMN_NAME;

-- ⭐ X13 축 (REQ:CHAT-20260901-X13) — SEL_MEASURE 의 division 필터는 메저별 DIVISION_ID 가 아니라
--    **ROWNUM=1 임의 1행**의 콤마목록을 전 메저에 CROSS JOIN 해서 판정한다(PKG_DMF0035 L406~411, L428).
--    즉 아래 1행의 목록에 조회 division 이 있으면 titleset 의 **모든** 메저가 통과하고, 없으면 전멸한다.
--    사내 실측 = 'AS_In_Plan' (40,82,81,81_UC,81_HM,81_ST,81_HD,81_HG) → 40·81 모두 통과(무증상).
--    클라우드에서 이 1행이 다르면 그 자체가 건수차 원인이 될 수 있다.
SELECT COLUMN_NAME, DIVISION_ID, VALID_YN, DEFAULT_FLAG
     , CASE WHEN INSTR(','||DIVISION_ID||',', ',&P_DIV,') > 0
            THEN 'PASS — titleset 전 메저 통과' ELSE 'BLOCK — 전 메저 소실' END AS X13_EFFECT
  FROM (SELECT COLUMN_NAME, DIVISION_ID, VALID_YN, DEFAULT_FLAG
          FROM SCM_MGR.SCM_MST_SHEET_MEASURE
         WHERE PROGRAM_ID = 'DMF0035' AND SHEET_NAME = 'Mkt Fcst Waterfall')
 WHERE ROWNUM = 1;


PROMPT ================= §2 사용자 개인화(titleset) =================
-- 기대 = MKT_FCST / SCM_FCST / CUST_FCST 3행. 이보다 많으면 그 초과분이 곧 초과 건수다.
SELECT SHEET_NAME, USER_INQUIRY_COLUMN_TYPE_CODE AS TYPE_CD, COLUMN_NAME, SORT_ORDER_NO
  FROM SCM_MGR.SCM_MST_TITLESET_USER
 WHERE PROGRAM_ID = 'DMF0035'
   AND USER_ID    = '&P_USER'
   AND USER_INQUIRY_COLUMN_TYPE_CODE = 'M'
 ORDER BY SHEET_NAME, SORT_ORDER_NO;

-- ⚠ SHEET_NAME 변형 2종(‘mktFcstWaterfall’ vs ‘Mkt Fcst Waterfall’)이 동시에 있으면
--   메저가 중복 적재되어 건수가 배수로 튄다. 기대 = 'mktFcstWaterfall' 한 종류만.
SELECT SHEET_NAME, COUNT(*) AS ROWS_, COUNT(DISTINCT COLUMN_NAME) AS DISTINCT_MEASURES
  FROM SCM_MGR.SCM_MST_TITLESET_USER
 WHERE PROGRAM_ID = 'DMF0035'
   AND USER_ID    = '&P_USER'
   AND USER_INQUIRY_COLUMN_TYPE_CODE = 'M'
 GROUP BY SHEET_NAME;


PROMPT ================= §3 CUST_FCST 종속메저 원천 =================
-- CUST_FCST 를 고르면 SP 가 아래 두 묶음을 **자동으로 덧붙인다**(사용자가 고른 적 없는 메저).
--   (A) PKG_DMF0035 L433~481 고정 8종
--   (B) PKG_DMF0035 L489~522 DM_MST_CUSTOMER_FCST 의 MEASURE 행
-- (B) 는 데이터 테이블이라 환경마다 다를 수 있다 → AS-IS/클라우드 차이의 유력 지점.
-- 사내 실측 2026-09-02: 'Customer FCST'(2,920행) / 'Cutomer FCST'(191행, 오타로 보이는 별도 값) 2종.
SELECT MEASURE_GROUP, MEASURE, VALID_YN, COUNT(*) AS SRC_ROWS
  FROM SCM_MGR.DM_MST_CUSTOMER_FCST
 WHERE MEASURE_GROUP = 'CUST_FCST'
   AND MEASURE IS NOT NULL
 GROUP BY MEASURE_GROUP, MEASURE, VALID_YN
 ORDER BY MEASURE;


PROMPT ================= §4 SP 실행 + 단계별 GTT 건수 =================
-- ⚠ 여기부터 §7 까지 같은 세션에서 연속 실행할 것 (GTT = SYS$SESSION).
-- 어느 단계에서 행이 생기고 끊기는지로 원인 arm 을 좁힌다.
DECLARE
  v_rc1 SYS_REFCURSOR; v_rc2 SYS_REFCURSOR; v_rc3 SYS_REFCURSOR; v_res SYS_REFCURSOR;
  v_cnt PLS_INTEGER := 0;
BEGIN
  -- ⭐⭐ 필터 파라미터의 "전체(무필터)" 센티널은 **NULL** 이다. `'ALL'` 이 아니다.
  --   근거: PKG_DMF0035 는 필터마다 `IF NVL(P_xxx,'@#@#@#') <> '@#@#@#' THEN DELETE ... WHERE NOT EXISTS(
  --         ... LIKE '%'||TOKEN||'%')` 구조다(예: P_ITEM_ID L2452~2472 = 로그마커 E52).
  --         'ALL' 을 주면 NULL 이 아니므로 분기가 켜지고, ITEM_ID 가 '%ALL%' 에 안 맞는 행을 **전부 삭제**한다.
  --   사내 실측 2026-09-02 (div40 / CURRENT / 20260901~20261130, 필터값만 교체):
  --         'ALL' → O_RC1 0   · RAW_DATA 0    (E52 가 3,141행 전량 삭제 — 로그마커로 확인)
  --         NULL  → O_RC1 515 · RAW_DATA 2081 (원장 X12 의 "사내 TO-BE 515" 와 일치)
  --   ⇒ 실제로 조회조건에 값을 넣은 항목만 채우고, 나머지는 NULL 로 둘 것.
  SCM_MGR.PKG_DMF0035.P_DMF0035_GET_MKT_FCST_WATERFALL(
      P_DIVISION_ID   => '&P_DIV'
    , P_DEPT_ID       => NULL     -- ▼ 화면에서 실제로 고른 값이 있으면 그것만 채운다. 없으면 NULL 유지.
    , P_END_CUSTOMER  => NULL
    , P_SCM_SITE_ID   => NULL
    , P_PROJECT_CODE  => NULL
    , P_ITEM_ID       => NULL
    , P_ITEM_TYPE     => NULL
    , P_FROM_YYYYMMDD => '&P_FROM'
    , P_TO_YYYYMMDD   => '&P_TO'
    , P_CREATED_BY    => '&P_USER'
    , P_PLANT_SITE_ID => NULL
    , P_BIZ_TYPE      => NULL
    , P_OWNER         => NULL
    , P_VERSION_NO    => '&P_VERSION'
    , P_BUCKET        => '&P_BUCKET'
    , P_USER_DEPT_ID  => NULL
    , P_GROUP_ID      => NULL
    , P_CELL_YN       => 'N'
    , P_SENDER_CODE   => NULL     -- ▲
    , P_USER_ID       => '&P_USER'
    , P_MENU_ID       => 'DMF0035'
    , O_RC1 => v_rc1, O_RC2 => v_rc2, O_RC3 => v_rc3, O_RESULT_CURSOR => v_res);
  CLOSE v_rc1; CLOSE v_rc2; CLOSE v_rc3; CLOSE v_res;
  DBMS_OUTPUT.PUT_LINE('SP 실행 완료 — 아래 단계별 건수 확인');
END;
/

-- 단계별 건수. 사내 실측(2026-09-02, div40 / CURRENT / 20260901~20261130 / 필터 NULL):
--   VERSION=0(정상 — CURRENT 는 L645 전용 분기라 이 GTT 를 안 쓴다) · SEL_MEASURE=14
--   · RAW_DATA=2081 · RAW_DATA_FINAL=2081 · O_RC1=515
-- ⚠ RAW_DATA 가 0 이면 메저 문제가 아니라 **필터 파라미터**를 먼저 의심할 것 (위 'ALL' vs NULL).
SELECT 'GT_DM35_VERSION'        AS STAGE, COUNT(*) AS CNT FROM SCM_MGR.GT_DM35_VERSION        UNION ALL
SELECT 'GT_DM35_SEL_MEASURE'         , COUNT(*) FROM SCM_MGR.GT_DM35_SEL_MEASURE              UNION ALL
SELECT 'GT_DM35_RAW_DATA'            , COUNT(*) FROM SCM_MGR.GT_DM35_RAW_DATA                 UNION ALL
SELECT 'GT_DM35_RAW_DATA_FINAL'      , COUNT(*) FROM SCM_MGR.GT_DM35_RAW_DATA_FINAL           UNION ALL
SELECT 'GT_DM35_CALENDAR'            , COUNT(*) FROM SCM_MGR.GT_DM35_CALENDAR                 UNION ALL
SELECT 'GT_DM35_SITE_ITEM'           , COUNT(*) FROM SCM_MGR.GT_DM35_SITE_ITEM                UNION ALL
SELECT 'GT_DM35_ITEM_SINGLE_V'       , COUNT(*) FROM SCM_MGR.GT_DM35_ITEM_SINGLE_V            UNION ALL
SELECT 'GT_DM35_TEMP_SCM_SITE'       , COUNT(*) FROM SCM_MGR.GT_DM35_TEMP_SCM_SITE;


PROMPT ================= §4B ⭐ SP 자체 단계로그 (조회조건 재현 없이 추적) =================
-- ⭐⭐ PKG_DMF0035 는 매 단계마다 SQL%ROWCOUNT 를 마커와 함께 SCM_SYS_LOG_BATCH 에 적재한다.
--   PR_SCM_SYS_LOG_BATCH 가 **pragma autonomous_transaction** 이라 커밋이 독립이고 세션과 무관하게 남는다.
--   ⇒ **화면(FE→BE)에서 실제로 돌린 조회의 단계별 건수도 여기서 그대로 읽을 수 있다.**
--     조회조건을 추측해 재현할 필요 없이, 사용자가 775건을 본 그 실행을 직접 추적하는 축이다.
--
-- 사용법: 화면에서 문제 조회를 한 번 수행한 직후, 아래를 실행해 가장 최근 실행 묶음을 본다.
-- 읽는 법 (사내 실측 마커 계보):
--   D5--GT_DM35_DM_PLN_MKT   : 원천에서 끌어온 행수
--   D61--GT_DM35_RAW_DATA    : RAW 적재 행수 (여기가 0 이면 원천/기간 문제)
--   E3A8--DELETE ...         : SITE_ITEM 에 없는 키 삭제
--   ⭐ E52--DELETE ...       : P_ITEM_ID 필터 삭제 — 'ALL' 을 넘기면 **여기서 전량 증발**한다
--   G2--GT_DM35_RAW_DATA COUNT : 최종 RAW 잔량 (0 이면 화면 0건)
SELECT TO_CHAR(EVENT_DATE,'YYYY-MM-DD HH24:MI:SS') AS EVENT_TIME
     , LOG_TYPE
     , LOG_COUNT
     , LOG_MESSAGE
  FROM (SELECT EVENT_DATE, LOG_TYPE, LOG_COUNT, LOG_MESSAGE
          FROM SCM_MGR.SCM_SYS_LOG_BATCH
         WHERE PROGRAM_NAME LIKE 'PKG_DMF0035%'
           AND LOG_TYPE = 'INFO'
           AND LOG_MESSAGE IN ('D5--GT_DM35_DM_PLN_MKT','D61--GT_DM35_RAW_DATA'
                              ,'E3A6--GT_DM35_SITE_ITEM','E3A7--DELETE GT_DM35_RAW_DATA'
                              ,'E3A8--DELETE GT_DM35_RAW_DATA','E5--'
                              ,'E51--DELETE GT_DM35_RAW_DATA','E52--DELETE GT_DM35_RAW_DATA'
                              ,'G1--DELETE GT_DM35_RAW_DATA','G2--GT_DM35_RAW_DATA COUNT','H--')
         ORDER BY EVENT_DATE DESC, ROWID DESC)
 WHERE ROWNUM <= 22          -- 최근 2회 실행분 (핵심 마커 11종 x 2)
 ORDER BY EVENT_TIME DESC, LOG_MESSAGE;

-- 오류가 있었으면 여기 잡힌다 (LOG_TYPE 이 INFO/START/END 가 아닌 행 = 실제 예외만)
SELECT TO_CHAR(EVENT_DATE,'YYYY-MM-DD HH24:MI:SS') AS EVENT_TIME
     , LOG_TYPE, LOG_MESSAGE, SQL_ERR_CODE, SQL_ERR_MSG
  FROM SCM_MGR.SCM_SYS_LOG_BATCH
 WHERE PROGRAM_NAME LIKE 'PKG_DMF0035%'
   AND LOG_TYPE NOT IN ('INFO','START','END')
   AND EVENT_DATE >= SYSDATE - 1
 ORDER BY EVENT_DATE DESC
 FETCH FIRST 10 ROWS ONLY;


PROMPT ================= §5 실제 조회에 참여한 메저 전량 =================
-- 기대 구성: 사용자 선택 3 (MKT_FCST/SCM_FCST/CUST_FCST)
--          + CUST_FCST 종속 8 (Immidiate/Planning_Forecast/Commercial_Agreement/Firm_Temp/
--                              Manumacturing_Material_Temp/Material_Temp/Backorder/CUST_FCST_EDI)
--          + DM_MST_CUSTOMER_FCST 종속 (§3 결과 수만큼)
--          + SYSTEM_ADD='Y' (환산 보조용 — 최종 결과에서는 L2834~2836 이 삭제하므로 화면 미표시)
-- ⇒ SYSTEM_ADD='N' 행 수가 곧 화면에 나올 수 있는 메저 수다. 사내 실측 = 14행(중 SYSTEM_ADD='Y' 1).
SELECT MEASURE_GROUP, MEASURE, SORT_ORDER_NO, SYSTEM_ADD
  FROM SCM_MGR.GT_DM35_SEL_MEASURE
 ORDER BY SYSTEM_ADD, SORT_ORDER_NO, MEASURE;

SELECT SYSTEM_ADD, COUNT(*) AS CNT FROM SCM_MGR.GT_DM35_SEL_MEASURE GROUP BY SYSTEM_ADD ORDER BY 1;


PROMPT ================= §6 ⭐ 메저별 건수 (AS-IS 와 1:1 대조) =================
-- ⭐ 이 표를 AS-IS 의 메저별 건수와 나란히 놓으면 +10 이 어느 메저에서 나오는지 즉시 드러난다.
--
-- ⚠ 화면 표기명 ≠ 원천 MEASURE 값. 최종 SELECT(V_SQL_SELECT)가 아래 치환을 건다:
--     'Customer FCST'      → LAST_UPDATED_BY LIKE '%robot%' ? 'Cust.FCST_RPA[P+P]' : 'Cust.FCST_EXCEL[P+P]'
--     'Customer FCST[Org.]'→ 동형 [Org.]
--   즉 원천 1개('Customer FCST')가 화면에서는 **RPA/EXCEL 2행으로 갈라진다**.
--   오타값 'Cutomer FCST' 는 치환 CASE 에 없어 그 문자열 그대로 화면에 뜬다.
--
-- ⛔ **기각된 가설 (2026-09-02)**: "오타 메저 'Cutomer FCST' 가 +10 의 원인" 은 **실측으로 반증**되었다.
--    사내·클라우드 양쪽 div40 실행에서 CUST_FCST 계열(CUST_FCST + 종속 11종)이 **전부 0행**이고
--    'Cutomer FCST' 기여분도 0 이다. 원인은 div40 의 원천(DM_PLN_CFM_MKT_DEMAND_PLAN)에
--    CUST_FCST/Customer FCST MEASURE 자체가 없기 때문(원천 실측: BALANCE/MKT_FCST/SCM_FCST/RTF*/
--    VMI*/MKT_AMT*/SalesAmt* 만 존재). ⇒ div40 건수차는 **MKT_FCST·SCM_FCST 두 메저 안에서** 찾아야 한다.
-- 아래는 원천값과 화면표기 둘 다 뽑는다 — AS-IS 대조는 DISPLAY_MEASURE 열로 할 것.
SELECT F.MEASURE_GROUP
     , F.MEASURE                                  AS SRC_MEASURE
     , CASE WHEN F.MEASURE = 'Customer FCST'
                 THEN CASE WHEN F.LAST_UPDATED_BY LIKE '%robot%'
                           THEN 'Cust.FCST_RPA[P+P]' ELSE 'Cust.FCST_EXCEL[P+P]' END
            WHEN F.MEASURE = 'Customer FCST[Org.]'
                 THEN CASE WHEN F.LAST_UPDATED_BY LIKE '%robot%'
                           THEN 'Cust.FCST_RPA[Org.]' ELSE 'Cust.FCST_EXCEL[Org.]' END
            ELSE F.MEASURE END                    AS DISPLAY_MEASURE
     , COUNT(*)                                   AS ROWS_ALL
     , COUNT(CASE WHEN F.QTY <> 0 THEN 1 END)     AS ROWS_QTY_NOT_ZERO
     , COUNT(DISTINCT F.VERSION_NO || '|' || F.PROJECT_CODE || '|' || F.SCM_SITE_ID || '|' ||
             F.PLANT_SITE_ID || '|' || F.ITEM_ID || '|' || F.INCOTERMS || '|' ||
             F.DOM_EXP || '|' || F.FCST_TYPE || '|' || F.CELL_PROD_SITE_ID) AS DISTINCT_KEYS
  FROM SCM_MGR.GT_DM35_RAW_DATA_FINAL F
 GROUP BY F.MEASURE_GROUP, F.MEASURE
        , CASE WHEN F.MEASURE = 'Customer FCST'
                    THEN CASE WHEN F.LAST_UPDATED_BY LIKE '%robot%'
                              THEN 'Cust.FCST_RPA[P+P]' ELSE 'Cust.FCST_EXCEL[P+P]' END
               WHEN F.MEASURE = 'Customer FCST[Org.]'
                    THEN CASE WHEN F.LAST_UPDATED_BY LIKE '%robot%'
                              THEN 'Cust.FCST_RPA[Org.]' ELSE 'Cust.FCST_EXCEL[Org.]' END
               ELSE F.MEASURE END
 ORDER BY F.MEASURE_GROUP, F.MEASURE;

-- ⭐ 오타 메저 'Cutomer FCST' 단독 확인 — 여기 건수가 잡히면 그만큼이 AS-IS 대비 초과 후보다.
SELECT 'Cutomer FCST 기여분' AS ITEM
     , COUNT(*)                                AS ROWS_ALL
     , COUNT(CASE WHEN QTY <> 0 THEN 1 END)    AS ROWS_QTY_NOT_ZERO
     , COUNT(DISTINCT VERSION_NO||'|'||PROJECT_CODE||'|'||SCM_SITE_ID||'|'||PLANT_SITE_ID||'|'||
             ITEM_ID||'|'||INCOTERMS||'|'||DOM_EXP||'|'||FCST_TYPE||'|'||CELL_PROD_SITE_ID) AS DISTINCT_KEYS
  FROM SCM_MGR.GT_DM35_RAW_DATA_FINAL
 WHERE MEASURE = 'Cutomer FCST';

-- 총계 (참고)
SELECT COUNT(*) AS RAW_FINAL_ROWS
     , COUNT(CASE WHEN QTY <> 0 THEN 1 END) AS RAW_FINAL_QTY_NOT_ZERO
  FROM SCM_MGR.GT_DM35_RAW_DATA_FINAL;


PROMPT ================= §7 최종 그리드 행수 재구성 =================
-- 화면 행수 = PIVOT 결과 행수 = (V_COL_LIST + EDIT_YN) 조합의 DISTINCT 수 (QTY<>0 인 행 기준).
-- V_COL_LIST 는 titleset 'C' 유무로 분기한다(PKG_DMF0035 L2924~2977).
--   'C' 0건  → SHEET_COLUMNS 의 DEFAULT_FLAG='Y' (+숨은컬럼) 기준
--   'C' 있음 → 사용자 저장 컬럼 기준
-- 아래는 어느 분기를 타는지와 실제 키 문자열을 그대로 보여준다.
SELECT COUNT(*) AS TITLESET_C_CNT
     , CASE WHEN COUNT(*) = 0 THEN 'DEFAULT 분기 (SHEET_COLUMNS)' ELSE 'USER 분기 (titleset C)' END AS BRANCH
  FROM SCM_MGR.SCM_MST_TITLESET_USER
 WHERE PROGRAM_ID='DMF0035' AND SHEET_NAME='mktFcstWaterfall'
   AND USER_ID='&P_USER' AND USER_INQUIRY_COLUMN_TYPE_CODE='C';

-- DEFAULT 분기일 때의 V_COL_LIST (L2933~2943 동일 산식)
SELECT RTRIM(LISTAGG(' '||COLUMN_NAME||',','') WITHIN GROUP (ORDER BY SORT_ORDER_NO), ',') AS V_COL_LIST_DEFAULT_BRANCH
  FROM (SELECT SORT_ORDER_NO, COLUMN_NAME
          FROM SCM_MGR.SCM_MST_SHEET_COLUMNS C
         WHERE C.PROGRAM_ID='DMF0035' AND C.SHEET_NAME='Mkt Fcst Waterfall'
           AND (C.DEFAULT_FLAG='Y'
             OR (C.VISIBLE_FLAG='N' AND RTRIM(C.DEFAULT_FLAG,' -') IS NULL AND C.VALID_YN='Y')));

-- 화면 행수 근사 (메저 포함 키 기준). AS-IS 765 / TO-BE 775 와 같은 자리수인지 확인용.
SELECT COUNT(*) AS GRID_ROWS_APPROX
  FROM (SELECT DISTINCT VERSION_NO, MEASURE_GROUP, MEASURE, PROJECT_CODE, SCM_SITE_ID,
                        PLANT_SITE_ID, ITEM_ID, INCOTERMS, DOM_EXP, FCST_TYPE, CELL_PROD_SITE_ID
          FROM SCM_MGR.GT_DM35_RAW_DATA_FINAL
         WHERE QTY <> 0);

PROMPT ================= 끝 =================
