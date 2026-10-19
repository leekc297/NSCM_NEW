-- ============================================================================
-- DMF0082 / Division 81 — 2차 진단 + 1차 실행 부작용 정리
--   대상 : 클라우드 (QA / DEV)
--   작성 : 2026-09-21
--
--   1차(DMF0082_DIV81_MEASURE_DUP_CLOUD_20260921.sql) 결과 요약
--     · DB 중복 축은 전부 0행 (B1/B3/B4-b/B5)  -> DB 레벨 중복은 확인되지 않음
--     · 단 P_USER='CHANGE_ME' 로 실행되어 **증상 재현이 안 된 상태**
--     · 부작용 : CHANGE_ME titleset 23행 자동 생성 (TITLESET_USER 528 -> 551)
--     · 부수 적발 : DM_MST_CUSTOMER_FCST 에 measure 아닌 값('Customer FCST','ea') 등재
-- ============================================================================

SET LINESIZE 300
SET PAGESIZE 200
SET SQLBLANKLINES ON
SET DEFINE ON

DEFINE P_DIV  = '81'
DEFINE P_FROM = '20260901'
DEFINE P_TO   = '20270228'
DEFINE P_VER  = 'Current'
DEFINE P_QTY  = 'Y'
DEFINE P_USER = 'CHANGE_ME_TO_REAL_ID'   -- ⭐⭐ 증상을 본 **실제 사용자 ID**. 이번엔 반드시.


PROMPT ============================================================
PROMPT #0. 1차 실행 부작용 정리 — CHANGE_ME titleset 삭제
PROMPT    먼저 SELECT 로 대상을 확인하고, 맞으면 DELETE 를 실행한다.
PROMPT    (1차 실행 시 GET 이 없는 사용자에게 기본셋을 자동 시드했다)
PROMPT ============================================================
SELECT USER_ID, USER_INQUIRY_COLUMN_TYPE_CODE AS TP, COUNT(*) AS ROWS_CNT
     , MIN(TO_CHAR(CREATION_DATE,'YYYY-MM-DD HH24:MI:SS')) AS FIRST_CREATED
  FROM SCM_MST_TITLESET_USER
 WHERE PROGRAM_ID = 'DMF0082' AND USER_ID = 'CHANGE_ME'
 GROUP BY USER_ID, USER_INQUIRY_COLUMN_TYPE_CODE;

-- 위 결과가 CHANGE_ME 23행(C 16 + M 7)이면 아래 주석을 풀어 실행:
-- DELETE FROM SCM_MST_TITLESET_USER WHERE PROGRAM_ID = 'DMF0082' AND USER_ID = 'CHANGE_ME';
-- COMMIT;


PROMPT ============================================================
PROMPT #1. ⭐ DM_MST_CUSTOMER_FCST 오염 점검 (1차에서 적발)
PROMPT    PKG 2단 블록이 이 테이블의 MEASURE 를 그대로 측정행으로 승격시킨다.
PROMPT    measure 코드가 아닌 값(라벨/단위/공백/한글)이 있으면 화면에 유령 행이 생긴다.
PROMPT    1차 실측 : 'Customer FCST'(라벨) , 'ea'(단위) 가 둘 다 SORT 47.1 로 겹침
PROMPT ============================================================
SELECT C.MEASURE
     , COUNT(*) AS ROWS_CNT
     , CASE WHEN EXISTS (SELECT 1 FROM SCM_MST_SHEET_MEASURE M
                          WHERE M.PROGRAM_ID = 'DMF0082' AND M.COLUMN_NAME = C.MEASURE)
            THEN 'SHEET_MEASURE 등재'
            ELSE '*** 미등재(유령 후보) ***' END AS REGISTERED
     , CASE WHEN REGEXP_LIKE(C.MEASURE, '[[:space:]]') THEN '공백포함 ' END ||
       CASE WHEN LENGTH(C.MEASURE) <= 3               THEN '너무짧음 ' END ||
       CASE WHEN REGEXP_LIKE(C.MEASURE, '[가-힣]')     THEN '한글포함 ' END AS SMELL
  FROM DM_MST_CUSTOMER_FCST C
 WHERE C.MEASURE_GROUP = 'CUST_FCST'
   AND NVL(C.MEASURE,'-') <> '-'
   AND C.VALID_YN = 'Y'
 GROUP BY C.MEASURE
 ORDER BY 3, 1;

PROMPT ============================================================
PROMPT #1-b. 위 오염 measure 가 실제 원장 데이터를 갖고 있는가
PROMPT      (0건이면 화면에 빈 행만 늘리는 유령 measure — 제거 1순위)
PROMPT ============================================================
SELECT C.MEASURE, C.DIVISION_ID, COUNT(*) AS LEDGER_ROWS
  FROM DM_MST_CUSTOMER_FCST C
 WHERE C.MEASURE_GROUP = 'CUST_FCST' AND C.VALID_YN = 'Y'
   AND NVL(C.MEASURE,'-') <> '-'
 GROUP BY C.MEASURE, C.DIVISION_ID
 ORDER BY 1, 2;


PROMPT ============================================================
PROMPT #2. ⭐⭐ 실제 사용자로 재현 — 이 사용자가 화면에서 보는 measure 행
PROMPT    이번엔 반드시 P_USER 를 실제 ID 로 바꾼 뒤 실행할 것.
PROMPT ============================================================
SELECT SHEET_NAME, COLUMN_NAME, SORT_ORDER_NO
  FROM SCM_MST_TITLESET_USER
 WHERE PROGRAM_ID = 'DMF0082' AND USER_INQUIRY_COLUMN_TYPE_CODE = 'M'
   AND USER_ID = '&&P_USER'
 ORDER BY TO_NUMBER(SORT_ORDER_NO);

VAR rc1 REFCURSOR
VAR rc2 REFCURSOR
VAR rc3 REFCURSOR
VAR rc4 REFCURSOR
VAR rc5 REFCURSOR
VAR rcr REFCURSOR

EXEC PKG_DMF0082.P_DMF0082_GET_MAIN_DATA('&&P_DIV','','','','&&P_FROM','&&P_TO','','','&&P_VER','&&P_QTY','&&P_USER','','','','','', :rc1, :rc2, :rc3, :rc4, :rc5, :rcr);

PROMPT ============================================================
PROMPT #2-a. 측정 선택 원장 — USER_ID 별 / 중복 여부
PROMPT      DM_ADMIN 행은 **설계상 정상**(계산용 강제포함, 최종 삭제 대상).
PROMPT      같은 MEASURE 가 2행이면 그게 화면 복수행의 직접 원인.
PROMPT ============================================================
SELECT MEASURE, RESULT_MEASURE, MEASURE_GROUP, SORT_ORDER_NO, USER_ID
     , COUNT(*) OVER (PARTITION BY MEASURE)        AS SAME_MEASURE_ROWS
     , COUNT(*) OVER (PARTITION BY SORT_ORDER_NO)  AS SAME_SORT_ROWS
  FROM GT_DMF0082_TEMP_SELECT_MEASURE
 ORDER BY SORT_ORDER_NO, MEASURE;

PROMPT ============================================================
PROMPT #2-b. ⭐ 정렬키 충돌 — 같은 SORT_ORDER_NO 를 2개 이상 measure 가 쓰는가
PROMPT      EXPECT : 0행. 나오면 그 자리에 여러 행이 겹쳐 "복수행" 으로 보인다.
PROMPT      1차 실측(CHANGE_ME) : 47.1 에 'Customer FCST' + 'ea' 2건
PROMPT ============================================================
SELECT SORT_ORDER_NO, COUNT(*) AS CNT
     , LISTAGG(MEASURE || '(' || USER_ID || ')', ' | ') WITHIN GROUP (ORDER BY MEASURE) AS MEASURES
  FROM GT_DMF0082_TEMP_SELECT_MEASURE
 GROUP BY SORT_ORDER_NO
HAVING COUNT(*) > 1
 ORDER BY 1;

PROMPT ============================================================
PROMPT #2-c. 최종 결과 커서 기준 — 화면 1행 = 여기 1행
PROMPT      "정적 컬럼 동일 + 같은 MEASURE" 가 2행이면 그게 화면 복수행이다.
PROMPT      EXPECT : 0행
PROMPT ============================================================
SELECT MEASURE, DIVISION_ID, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, NICK_NAME
     , INCOTERMS, FCST_TYPE, DOM_EXP, CURRENCY, VERSION_NO, PROJECT_CODE
     , PLANT_SITE_ID, AS_FROM_SITE, CELL_PROD_SITE_ID
     , COUNT(*) AS N
  FROM GT_DMF0082_MF_SP
 GROUP BY MEASURE, DIVISION_ID, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, NICK_NAME
        , INCOTERMS, FCST_TYPE, DOM_EXP, CURRENCY, VERSION_NO, PROJECT_CODE
        , PLANT_SITE_ID, AS_FROM_SITE, CELL_PROD_SITE_ID
HAVING COUNT(DISTINCT BUCKET_KEY) < COUNT(*)
 ORDER BY 16 DESC
 FETCH FIRST 30 ROWS ONLY;

PROMPT ============================================================
PROMPT #2-d. 화면 표시 measure 목록 (라벨) — 캡처와 1:1 대조용
PROMPT      캡처에 보이는 순서/라벨과 같은지 눈으로 확인한다.
PROMPT      ※ MKT FCST[R+P](MKT_FCST) 와 MKT FCST[P+P](MKT_FCST_PP) 는 **서로 다른 measure** 다.
PROMPT         RTF[R+P](RTF_SYS_RP) 와 RTF[P+P](RTF_SCP) 도 마찬가지.
PROMPT         이 둘이 나란히 보이는 것은 정상이며 "중복"이 아니다.
PROMPT ============================================================
SELECT T.SORT_ORDER_NO, T.MEASURE, NVL(M.COLUMN_LABEL_NAME, '(라벨 미등록)') AS LABEL
     , T.USER_ID
     , CASE WHEN M.COLUMN_NAME IS NULL THEN '*** SHEET_MEASURE 미등재 ***' END AS NOTE
  FROM GT_DMF0082_TEMP_SELECT_MEASURE T
  LEFT JOIN SCM_MST_SHEET_MEASURE M
    ON  M.PROGRAM_ID  = 'DMF0082'
    AND M.SHEET_NAME  = 'FcstNPrice'
    AND M.COLUMN_NAME = T.MEASURE
 ORDER BY T.SORT_ORDER_NO, T.MEASURE;

PROMPT ============================================================
PROMPT #2-e. 그 사용자 기준 실제 데이터 행 — measure 별 행수
PROMPT      화면 캡처의 키 하나를 골라 WHERE 에 넣으면 그 키의 행 구성이 그대로 보인다.
PROMPT ============================================================
SELECT MEASURE, COUNT(*) AS ROWS_CNT, COUNT(DISTINCT BUCKET_KEY) AS BUCKETS
     , COUNT(DISTINCT ITEM_ID || '|' || SCM_SITE_ID || '|' || PROJECT_CODE) AS KEYS
  FROM GT_DMF0082_MF_SP
 GROUP BY MEASURE ORDER BY 2 DESC;

PROMPT
PROMPT ============================================================
PROMPT §판정
PROMPT   #2-a 에 같은 MEASURE 2행  -> 측정선택 중복 = 직접 원인
PROMPT   #2-b 에 행이 있음         -> 정렬키 충돌 = 같은 자리에 겹쳐 보임
PROMPT   #2-c 에 행이 있음         -> 스테이징 fan-out = 진짜 데이터 중복
PROMPT   #1 에 미등재 measure      -> DM_MST_CUSTOMER_FCST 오염 = 유령 행
PROMPT   전부 0행이면             -> DB 아님. 화면 캡처의 해당 키/메저를 지정해 주시면
PROMPT                              그 키 한 건만 끝까지 추적하겠습니다.
PROMPT ============================================================
