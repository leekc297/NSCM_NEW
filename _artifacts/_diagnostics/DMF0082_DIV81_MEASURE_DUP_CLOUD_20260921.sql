-- ============================================================================
-- DMF0082 / Division 81 — "정적 컬럼이 같은데 메저가 복수 행으로 나온다" 원인 진단
--   대상 : ⭐ 클라우드 (QA / DEV) — 사내에서는 재현되지 않았다(§0 기준선 참조)
--   성격 : READ-ONLY. 아무것도 바꾸지 않는다.
--   작성 : 2026-09-21 / 전 블록 사내(ZIOUI1)에서 실행 검증 후 배포
--
-- 증상(사용자 보고) : 81 DIVISION 에서 MKT_FCST · RTF · SCM_FCST · FCST_GAP 등
--                     여러 메저가 같은 키(정적 컬럼 동일)에 대해 2행으로 표시됨.
--                     40 DIVISION 은 과거 동일 증상을 해소한 이력이 있음.
--
-- ⚠️⚠️ 실행 전 필독
--   1) `&&P_USER` 에는 **증상을 본 그 사용자 본인의 ID** 를 넣는다.
--      ⛔ 타인 ID 로 GET 을 호출하면 그 사람의 titleset(SCM_MST_TITLESET_USER)이
--         **자동 생성**되어 원장이 오염된다 (DMF0044 2026-08-11 실사고).
--   2) [B] 블록은 **SP 호출과 같은 세션**에서 실행해야 한다.
--      GTT 가 ON COMMIT PRESERVE ROWS 라 COMMIT 은 무방하나 **접속을 끊으면 안 된다**.
--      DBeaver 사용 시 "Auto-commit" 여부와 무관하게 **같은 커넥션**에서 순서대로 실행.
--   3) 조회조건은 화면에서 증상을 본 그 조건과 같게 맞춘다(§1 변수).
-- ============================================================================

-- ─────────────────────────────────────────────────────────────────────────────
-- §1. 변수 — 화면에서 증상을 본 조건 그대로 채울 것
-- ─────────────────────────────────────────────────────────────────────────────
DEFINE P_DIV   = '81'            -- 81 / 81_HD / 81_HG / 81_HM / 81_ST / 81_UC
DEFINE P_FROM  = '20260901'      -- 화면 조회기간 FROM (YYYYMMDD)
DEFINE P_TO    = '20270228'      -- 화면 조회기간 TO   (YYYYMMDD)
DEFINE P_VER   = 'Current'       -- 화면 Version (기본 'Current')
DEFINE P_QTY   = 'Y'             -- 화면 수량유무 체크박스
DEFINE P_USER  = 'CHANGE_ME'     -- ⭐ 증상을 본 사용자 본인 ID

SET LINESIZE 300
SET PAGESIZE 200
SET SERVEROUTPUT ON
SET SQLBLANKLINES ON
SET DEFINE ON

PROMPT
PROMPT ############################################################
PROMPT #  §0. 사내(ZIOUI1) 기준선 — 2026-09-21 실측. 클라우드와 대조할 값
PROMPT ############################################################
PROMPT   [A1] SHEET_MEASURE   DMF0082 = 26행 / COLUMN_NAME 중복 0
PROMPT   [A2] TITLESET 'M'    SHEET_NAME 변형 1종('FcstNPrice') / (USER,MEASURE) 중복 0
PROMPT   [A3] SHEET_NAME 변형 BTN_MPG 에 'FcstNPrice' + 'fcstNPrice' 2종 공존(사내 동일)
PROMPT   [B1] TEMP_SELECT_MEASURE 중복 0행
PROMPT   [B2] RESULT_MEASURE 다대일 = RTF_SYS_RP <- (MKT_FCST, RTF_SYS_RP, SCM_FCST) 3종
PROMPT          ※ 이것은 AS-IS 설계다(실적측정 매핑). 그 자체는 결함이 아니다.
PROMPT   [B3] MF_SP 중복 = KRW/USD/LOC 각 351그룹(최대 2행)만.
PROMPT          ⭐ MKT_FCST / RTF_SYS_RP / SCM_FCST / FCST_GAP 은 사내 중복 **0**
PROMPT          ⇒ 클라우드에서 이 4종에 중복이 잡히면 그것이 이번 증상의 원인 지점이다.
PROMPT   [B5] 최종 결과 (정적키15+MEASURE) 중복 0
PROMPT

PROMPT
PROMPT ############################################################
PROMPT #  [A] 메타 축 — SP 호출 없이 바로 판정 가능
PROMPT ############################################################
PROMPT ============================================================
PROMPT [A1] SCM_MST_SHEET_MEASURE — 같은 measure 가 2행 등록됐는가
PROMPT      EXPECT : 0행. 1행이라도 나오면 **메타 중복이 원인**(측정 목록 자체가 2벌)
PROMPT ============================================================
SELECT SHEET_NAME, COLUMN_NAME, COUNT(*) AS CNT
     , LISTAGG(NVL(DIVISION_ID,'(NULL)'), ' | ') WITHIN GROUP (ORDER BY DIVISION_ID) AS DIVISIONS
  FROM SCM_MST_SHEET_MEASURE
 WHERE PROGRAM_ID = 'DMF0082'
 GROUP BY SHEET_NAME, COLUMN_NAME
HAVING COUNT(*) > 1
 ORDER BY 3 DESC;

PROMPT ============================================================
PROMPT [A1-b] 81 에 노출되는 measure 목록 (화면 행 후보)
PROMPT        사내 = SCM_FCST/FCST_GAP/MKT_FCST_PP/MKT_FCST/RTF_SYS_RP/BALANCE/KRW/USD/LOC
PROMPT               + MKT_FCST_RP_CAR/RTF_SCP/RTF_SYS_RP_CAR/RTF_SYS_RP_CELL/IN_TRANSIT
PROMPT               + CUST_FCST/AS_In_Req/AS_In_Plan/AS_Inv/MKT_FCST_RP_CELL  (VALID_YN='Y')
PROMPT ============================================================
SELECT COLUMN_NAME, COLUMN_LABEL_NAME, SORT_ORDER_NO, DEFAULT_FLAG, VALID_YN, DIVISION_ID
  FROM SCM_MST_SHEET_MEASURE
 WHERE PROGRAM_ID = 'DMF0082' AND SHEET_NAME = 'FcstNPrice'
   AND INSTR(',' || DIVISION_ID || ',', ',&&P_DIV,') > 0
 ORDER BY TO_NUMBER(SORT_ORDER_NO);

PROMPT ============================================================
PROMPT [A2] ⭐ TITLESET 개인화 — SHEET_NAME 변형 공존 / 같은 measure 2행
PROMPT      (DMF0044 2026-08-11 실사고 계보 : 변형 2종 공존 x GTT 적재부 SHEET_NAME 미필터
PROMPT       -> 메저가 정확히 2배. 사내 DMF0082 는 변형 1종이라 해당 없음)
PROMPT      EXPECT : A2-1 은 변형 1종만, A2-2 는 0행
PROMPT ============================================================
SELECT SHEET_NAME, USER_INQUIRY_COLUMN_TYPE_CODE AS TP
     , COUNT(*) AS ROWS_CNT, COUNT(DISTINCT USER_ID) AS USERS
  FROM SCM_MST_TITLESET_USER
 WHERE PROGRAM_ID = 'DMF0082'
 GROUP BY SHEET_NAME, USER_INQUIRY_COLUMN_TYPE_CODE
 ORDER BY 2, 1;

SELECT USER_ID, COLUMN_NAME, COUNT(*) AS CNT
     , LISTAGG(SHEET_NAME || '/' || SORT_ORDER_NO, ' , ') WITHIN GROUP (ORDER BY SHEET_NAME) AS DETAIL
  FROM SCM_MST_TITLESET_USER
 WHERE PROGRAM_ID = 'DMF0082' AND USER_INQUIRY_COLUMN_TYPE_CODE = 'M'
 GROUP BY USER_ID, COLUMN_NAME
HAVING COUNT(*) > 1
 ORDER BY 3 DESC;

PROMPT ============================================================
PROMPT [A2-c] 이 사용자(&&P_USER)의 measure 개인화 — 화면에 뜨는 행 목록
PROMPT ============================================================
SELECT SHEET_NAME, COLUMN_NAME, SORT_ORDER_NO, SUB_TOTAL_FLAG, DATA_SORT_METHOD_CODE
  FROM SCM_MST_TITLESET_USER
 WHERE PROGRAM_ID = 'DMF0082' AND USER_INQUIRY_COLUMN_TYPE_CODE = 'M'
   AND USER_ID = '&&P_USER'
 ORDER BY SHEET_NAME, TO_NUMBER(SORT_ORDER_NO);

PROMPT ============================================================
PROMPT [A3] SHEET_NAME 대소문자 변형 공존 점검 (배선 축)
PROMPT      사내에도 'FcstNPrice' / 'fcstNPrice' 2종이 있다 — 그 자체로는 증상이 아니나
PROMPT      titleset/GTT 적재가 이 변형을 섞으면 2배가 된다. A2 와 함께 판정.
PROMPT ============================================================
SELECT 'BTN_MPG' AS SRC, SHT_NM AS SHEET_NAME, COUNT(*) AS CNT
  FROM SCM_ADM_MNU_BTN_MPG_M WHERE MNU_ID = 'DMF0082' GROUP BY SHT_NM
UNION ALL
SELECT 'SHEET_COLUMNS', SHEET_NAME, COUNT(*) FROM SCM_MST_SHEET_COLUMNS
 WHERE PROGRAM_ID = 'DMF0082' GROUP BY SHEET_NAME
UNION ALL
SELECT 'SHEET_MEASURE', SHEET_NAME, COUNT(*) FROM SCM_MST_SHEET_MEASURE
 WHERE PROGRAM_ID = 'DMF0082' GROUP BY SHEET_NAME
UNION ALL
SELECT 'TITLESET_USER', SHEET_NAME, COUNT(*) FROM SCM_MST_TITLESET_USER
 WHERE PROGRAM_ID = 'DMF0082' GROUP BY SHEET_NAME
 ORDER BY 1, 2;

PROMPT
PROMPT ############################################################
PROMPT #  [B] 런타임 축 — SP 호출 후 **같은 세션**에서 GTT 직접 조회
PROMPT #      (GTT = SYS$SESSION PRESERVE ROWS. 접속 끊지 말 것)
PROMPT ############################################################
VAR rc1 REFCURSOR
VAR rc2 REFCURSOR
VAR rc3 REFCURSOR
VAR rc4 REFCURSOR
VAR rc5 REFCURSOR
VAR rcr REFCURSOR

PROMPT >>> 메인 조회 SP 호출 (화면 Search 와 동일 파라미터)
PROMPT     ⚠ 멀티선택 조건은 빈 문자열 '' 이 "전체" 다. 'ALL' 을 넣으면 LIKE '%ALL%' 로 전멸한다.
EXEC PKG_DMF0082.P_DMF0082_GET_MAIN_DATA('&&P_DIV','','','','&&P_FROM','&&P_TO','','','&&P_VER','&&P_QTY','&&P_USER','','','','','', :rc1, :rc2, :rc3, :rc4, :rc5, :rcr);

PROMPT ============================================================
PROMPT [B0] 결과 커서 / 스테이징 행수
PROMPT ============================================================
PRINT rcr
SELECT 'GT_DMF0082_MF_SP'               AS GTT, COUNT(*) AS ROWS_CNT FROM GT_DMF0082_MF_SP
UNION ALL SELECT 'GT_DMF0082_TEMP_FCST_N_PRICE',      COUNT(*) FROM GT_DMF0082_TEMP_FCST_N_PRICE
UNION ALL SELECT 'GT_DMF0082_TEMP_SELECT_MEASURE',    COUNT(*) FROM GT_DMF0082_TEMP_SELECT_MEASURE
UNION ALL SELECT 'GT_DMF0082_SELECT_MEASURE',         COUNT(*) FROM GT_DMF0082_SELECT_MEASURE;

PROMPT ============================================================
PROMPT [B1] ⭐⭐ 측정 선택 원장 중복 — "메저가 2배" 의 1순위 원인
PROMPT      EXPECT : 0행.  1행이라도 나오면 **여기가 범인**이다.
PROMPT      (이 GTT 는 최종 쿼리와 MEASURE 로 조인하므로, 중복 1건 = 그 메저 전 행 2배)
PROMPT ============================================================
SELECT MEASURE, COUNT(*) AS CNT
     , LISTAGG(RESULT_MEASURE || '/' || MEASURE_GROUP || '/' || SORT_ORDER_NO, ' , ')
         WITHIN GROUP (ORDER BY SORT_ORDER_NO) AS DETAIL
  FROM GT_DMF0082_TEMP_SELECT_MEASURE
 GROUP BY MEASURE HAVING COUNT(*) > 1
 ORDER BY 2 DESC;

PROMPT ============================================================
PROMPT [B1-b] 측정 선택 원장 전체 (사내 = 사용자 개인화 건수만큼)
PROMPT ============================================================
SELECT MEASURE, RESULT_MEASURE, MEASURE_GROUP, SORT_ORDER_NO, USER_ID
  FROM GT_DMF0082_TEMP_SELECT_MEASURE ORDER BY SORT_ORDER_NO, MEASURE;

PROMPT ============================================================
PROMPT [B2] RESULT_MEASURE 다대일 매핑 (참고 — AS-IS 설계, 결함 아님)
PROMPT      사내 = RTF_SYS_RP <- MKT_FCST, RTF_SYS_RP, SCM_FCST
PROMPT      ※ 실적 블록이 A.MEASURE = B.RESULT_MEASURE 로 조인해 표시측정 3종으로 펼친다.
PROMPT         이 3종의 실적 구간 값이 같아 보이는 것은 정상이다.
PROMPT ============================================================
SELECT RESULT_MEASURE, COUNT(*) AS DISPLAY_CNT
     , LISTAGG(MEASURE, ', ') WITHIN GROUP (ORDER BY MEASURE) AS DISPLAY_MEASURES
  FROM GT_DMF0082_TEMP_SELECT_MEASURE
 GROUP BY RESULT_MEASURE HAVING COUNT(*) > 1
 ORDER BY 2 DESC;

PROMPT ============================================================
PROMPT [B3] ⭐⭐ 스테이징 중복 — (업무키 + MEASURE + BUCKET_KEY) 가 2행 이상
PROMPT      사내 기준선 : KRW / USD / LOC 만 (가격계 = AS-IS 동일 동작)
PROMPT      ⭐ 여기에 MKT_FCST / RTF_SYS_RP / SCM_FCST / FCST_GAP 이 나오면 **그것이 이번 결함**
PROMPT ============================================================
SELECT MEASURE, COUNT(*) AS DUP_GROUPS, SUM(N) AS DUP_ROWS, MAX(N) AS MAX_ROWS_PER_KEY
  FROM (
        SELECT MEASURE, DIVISION_ID, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, INCOTERMS
             , FCST_TYPE, DOM_EXP, CURRENCY, PROJECT_CODE, PLANT_SITE_ID, BUCKET_KEY
             , COUNT(*) AS N
          FROM GT_DMF0082_MF_SP
         GROUP BY MEASURE, DIVISION_ID, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, INCOTERMS
                , FCST_TYPE, DOM_EXP, CURRENCY, PROJECT_CODE, PLANT_SITE_ID, BUCKET_KEY
        HAVING COUNT(*) > 1)
 GROUP BY MEASURE ORDER BY 2 DESC;

PROMPT ============================================================
PROMPT [B4] B3 에서 잡힌 중복 그룹이 **어느 컬럼 때문에** 갈렸는가
PROMPT      distinct > 1 인 컬럼이 곧 "행을 쪼개는 축" 이다.
PROMPT      (사내는 QTY/NICK_NAME/CREATE_DATE 등 = 가격계 다중 원천의 정상 분리)
PROMPT ============================================================
SELECT COUNT(DISTINCT QTY)            AS D_QTY
     , COUNT(DISTINCT BUCKET_TYPE)    AS D_BUCKET_TYPE
     , COUNT(DISTINCT MEASURE_GROUP)  AS D_MEASURE_GROUP
     , COUNT(DISTINCT SORT_KEY)       AS D_SORT_KEY
     , COUNT(DISTINCT SORT_ORDER_NO)  AS D_SORT_ORDER_NO
     , COUNT(DISTINCT VERSION_NO)     AS D_VERSION_NO
     , COUNT(DISTINCT CUTOFF_YYYYMMDD) AS D_CUTOFF
     , COUNT(DISTINCT AS_FROM_SITE)   AS D_AS_FROM_SITE
     , COUNT(DISTINCT CELL_PROD_SITE_ID) AS D_CELL_PROD_SITE
     , COUNT(DISTINCT AS_YN)          AS D_AS_YN
     , COUNT(DISTINCT NEW_FLAG)       AS D_NEW_FLAG
     , COUNT(DISTINCT EDIT_FLAG)      AS D_EDIT_FLAG
     , COUNT(DISTINCT GROUP_ID)       AS D_GROUP_ID
     , COUNT(DISTINCT NICK_NAME)      AS D_NICK_NAME
     , COUNT(DISTINCT ITEM_NAME)      AS D_ITEM_NAME
     , COUNT(DISTINCT CREATE_DATE)    AS D_CREATE_DATE
     , COUNT(DISTINCT YYYYMM)         AS D_YYYYMM
     , COUNT(DISTINCT YYYYMMWW)       AS D_YYYYMMWW
  FROM GT_DMF0082_MF_SP
 WHERE (MEASURE, DIVISION_ID, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, INCOTERMS
       ,FCST_TYPE, DOM_EXP, CURRENCY, PROJECT_CODE, PLANT_SITE_ID, BUCKET_KEY) IN (
        SELECT MEASURE, DIVISION_ID, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, INCOTERMS
             , FCST_TYPE, DOM_EXP, CURRENCY, PROJECT_CODE, PLANT_SITE_ID, BUCKET_KEY
          FROM GT_DMF0082_MF_SP
         GROUP BY MEASURE, DIVISION_ID, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, INCOTERMS
                , FCST_TYPE, DOM_EXP, CURRENCY, PROJECT_CODE, PLANT_SITE_ID, BUCKET_KEY
        HAVING COUNT(*) > 1);

PROMPT ============================================================
PROMPT [B4-b] 실제 중복 2행 샘플 — 눈으로 무엇이 다른지 확인
PROMPT        MKT_FCST / RTF_SYS_RP / SCM_FCST / FCST_GAP 로 한정해 뽑는다.
PROMPT        0행이면 그 4종은 스테이징 중복이 아니다(= 화면 쪽/다른 원인).
PROMPT ============================================================
SELECT *
  FROM (
    SELECT MEASURE, ITEM_ID, SCM_SITE_ID, PROJECT_CODE, PLANT_SITE_ID, BUCKET_KEY, BUCKET_TYPE
         , QTY, MEASURE_GROUP, SORT_KEY, SORT_ORDER_NO, VERSION_NO, CUTOFF_YYYYMMDD
         , AS_FROM_SITE, CELL_PROD_SITE_ID, AS_YN, NEW_FLAG, EDIT_FLAG, GROUP_ID
         , NICK_NAME, CREATE_DATE, YYYYMM, YYYYMMWW
         , COUNT(*) OVER (PARTITION BY MEASURE, DIVISION_ID, END_CUSTOMER, SCM_SITE_ID, ITEM_ID
                                     , INCOTERMS, FCST_TYPE, DOM_EXP, CURRENCY, PROJECT_CODE
                                     , PLANT_SITE_ID, BUCKET_KEY) AS DUP_N
      FROM GT_DMF0082_MF_SP
     WHERE MEASURE IN ('MKT_FCST','RTF_SYS_RP','SCM_FCST','FCST_GAP','MKT_FCST_PP','RTF_SCP'))
 WHERE DUP_N > 1
 ORDER BY MEASURE, ITEM_ID, SCM_SITE_ID, BUCKET_KEY
 FETCH FIRST 40 ROWS ONLY;

PROMPT ============================================================
PROMPT [B5] 최종 표시 grain 중복 — 정적 컬럼(표시축) + MEASURE 가 2행인가
PROMPT      EXPECT : 0행 (사내 실측 0)
PROMPT      1행 이상이면 **화면에서 보이는 그대로의 중복**이다 -> B4 결과와 함께 보고할 것
PROMPT ============================================================
SELECT MEASURE, DIVISION_ID, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, NICK_NAME
     , INCOTERMS, FCST_TYPE, DOM_EXP, CURRENCY, PROJECT_CODE, PLANT_SITE_ID
     , COUNT(DISTINCT BUCKET_TYPE) AS D_BUCKET_TYPE
     , COUNT(DISTINCT AS_FROM_SITE) AS D_AS_FROM
     , COUNT(DISTINCT CELL_PROD_SITE_ID) AS D_CELL_PROD
     , COUNT(DISTINCT VERSION_NO) AS D_VER
     , COUNT(DISTINCT SORT_KEY) AS D_SORT_KEY
     , COUNT(*) AS N
  FROM GT_DMF0082_MF_SP
 GROUP BY MEASURE, DIVISION_ID, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, NICK_NAME
        , INCOTERMS, FCST_TYPE, DOM_EXP, CURRENCY, PROJECT_CODE, PLANT_SITE_ID
HAVING COUNT(DISTINCT BUCKET_KEY) < COUNT(*)      -- 같은 버킷이 2번 이상 = 진짜 중복
 ORDER BY 18 DESC
 FETCH FIRST 30 ROWS ONLY;

PROMPT
PROMPT ############################################################
PROMPT #  §2. 판정 가이드 — 어느 블록이 걸렸느냐로 원인이 갈린다
PROMPT ############################################################
PROMPT   [A1] 0행 아님  -> SHEET_MEASURE 메타 중복. 해당 행 정리(VALID_YN='N' 또는 DELETE).
PROMPT   [A2-2] 0행 아님 -> titleset 개인화 중복. DMF0044 계보 —
PROMPT                     GTT 적재부 SHEET_NAME 필터 누락 + 변형 공존을 함께 의심.
PROMPT   [B1] 0행 아님  -> 측정 선택 GTT 중복. **메저 N배의 직접 원인**.
PROMPT                     적재 SQL 의 SHEET_NAME / USER_ID 필터와 DISTINCT 여부를 본다.
PROMPT   [B3] 에 MKT_FCST/RTF_SYS_RP/SCM_FCST/FCST_GAP 등장
PROMPT                  -> 스테이징 fan-out. [B4] 의 distinct>1 컬럼이 원인 축이다.
PROMPT                     그 컬럼이 화면 비표시 컬럼이면 "정적 컬럼은 같은데 2행" 증상과 일치.
PROMPT   [B3] 이 KRW/USD/LOC 뿐이고 [B1]/[A] 도 깨끗 -> 사내와 동일 상태.
PROMPT                     그때는 DB 가 아니라 **클라우드 FE/PKG 세대 차이**를 의심하고
PROMPT                     클라우드 PKG_DMF0082 LAST_DDL_TIME 과 사내(2026-09-21)를 대조할 것.
PROMPT
PROMPT   ⭐ 결과 전체를 그대로 회신해 주시면 원인 지목과 보완안을 만들겠습니다.
PROMPT

-- 참고: 클라우드 PKG 세대 대조 (사내 = 2026-09-21 적용본)
SELECT OBJECT_NAME, OBJECT_TYPE, STATUS, TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') AS LAST_DDL
  FROM USER_OBJECTS WHERE OBJECT_NAME = 'PKG_DMF0082' ORDER BY OBJECT_TYPE;
