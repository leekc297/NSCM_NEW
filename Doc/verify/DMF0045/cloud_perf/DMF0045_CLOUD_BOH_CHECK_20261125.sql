/****************************************************************************************************/
/* DMF0045 2차 점검 쿼리 (클라우드 실행용) : W/H BOH 계산 82 사업부 부분                             */
/* 실행 : 스크립트 실행(F5). 조회 전용임. 결과 전체를 텍스트로 회신.                                  */
/*                                                                                                  */
/* 1차 회신 결과 (2026-11-25 13:47 클라우드 OCGSCMQ_P01)                                             */
/*  조회 1회 972.54초 중 W/H BOH 문장(클라우드 PACKAGE BODY 1261줄) 960.18초, 처리 행 0             */
/*  같은 문장 누적 38회 실행, 18,182초                                                              */
/*  실행계획 : SSP_DNM_ESS_PACKER_STOCK_V 를 2번 읽고, 두 번째 읽기가 바깥 행마다                   */
/*            재고 이력 SCM_STOCK_H 3일치를 CUTOFF_DATE 인덱스로 다시 읽음                           */
/*                                                                                                  */
/* 2차 확인 항목                                                                                     */
/*  1. 클라우드 PKG_DMF0045 원문 (사내본 2399줄, 클라우드 2436줄로 다름. 수정 기준본으로 씀)         */
/*  2. 재고 이력 SCM_STOCK_H 통계, 인덱스                                                           */
/*  3. 재고 뷰 1회 읽기 건수와 초                                                                   */
/*  4. 뷰 안 품목 기준 행 수 (실행계획 바깥 행)                                                     */
/*  5. 수정안 : 재고 뷰를 1번만 읽는 문장의 결과 행과 초                                            */
/****************************************************************************************************/

SET LINESIZE 300
SET PAGESIZE 50000
SET LONG 100000
SET TIMING ON
SET VERIFY OFF
SET FEEDBACK ON

/* 조회 시작일 = 화면 From 일자 (1차와 같은 값) */
DEFINE P_FROM = '20261123'
DEFINE P_DIV  = '82'
DEFINE P_BIZ  = 'P'

ALTER SESSION SET CURRENT_SCHEMA = SCM_MGR;

PROMPT ===== 1. 클라우드 PKG_DMF0045 PACKAGE BODY 원문 =====
SELECT S.LINE
     , RTRIM(S.TEXT, CHR(10)) AS TEXT
  FROM ALL_SOURCE S
 WHERE S.OWNER = 'SCM_MGR'
   AND S.NAME  = 'PKG_DMF0045'
   AND S.TYPE  = 'PACKAGE BODY'
 ORDER BY S.LINE;

PROMPT ===== 2-1. 재고 뷰가 읽는 테이블 (시노님 SCM_DNM_STOCK_SN 대상) =====
SELECT OWNER, SYNONYM_NAME, TABLE_OWNER, TABLE_NAME
  FROM ALL_SYNONYMS
 WHERE SYNONYM_NAME IN ('SCM_DNM_STOCK_SN', 'SCM_STOCK_H')
 ORDER BY OWNER, SYNONYM_NAME;

PROMPT ===== 2-2. SCM_STOCK_H 통계 =====
SELECT T.OWNER
     , T.TABLE_NAME
     , T.NUM_ROWS
     , T.BLOCKS
     , TO_CHAR(T.LAST_ANALYZED, 'YYYY-MM-DD HH24:MI') AS LAST_ANALYZED
     , T.STALE_STATS
  FROM ALL_TAB_STATISTICS T
 WHERE T.TABLE_NAME  = 'SCM_STOCK_H'
   AND T.OBJECT_TYPE = 'TABLE';

PROMPT ===== 2-3. SCM_STOCK_H CUTOFF_DATE 통계 최대값 (오늘보다 이전이면 최근 3일 건수를 1건으로 봄) =====
SELECT C.OWNER
     , C.COLUMN_NAME
     , C.NUM_DISTINCT
     , C.HISTOGRAM
     , TO_CHAR(TO_DATE(TO_CHAR(TO_NUMBER(SUBSTR(RAWTOHEX(C.HIGH_VALUE), 1, 2), 'XX') - 100, 'FM00')
                    || TO_CHAR(TO_NUMBER(SUBSTR(RAWTOHEX(C.HIGH_VALUE), 3, 2), 'XX') - 100, 'FM00')
                    || TO_CHAR(TO_NUMBER(SUBSTR(RAWTOHEX(C.HIGH_VALUE), 5, 2), 'XX'), 'FM00')
                    || TO_CHAR(TO_NUMBER(SUBSTR(RAWTOHEX(C.HIGH_VALUE), 7, 2), 'XX'), 'FM00'), 'YYYYMMDD'), 'YYYY-MM-DD') AS HIGH_DATE
     , TO_CHAR(C.LAST_ANALYZED, 'YYYY-MM-DD HH24:MI') AS LAST_ANALYZED
  FROM ALL_TAB_COL_STATISTICS C
 WHERE C.TABLE_NAME  = 'SCM_STOCK_H'
   AND C.COLUMN_NAME = 'CUTOFF_DATE';

PROMPT ===== 2-4. SCM_STOCK_H 인덱스 =====
SELECT C.INDEX_OWNER
     , C.INDEX_NAME
     , LISTAGG(C.COLUMN_NAME, ', ') WITHIN GROUP (ORDER BY C.COLUMN_POSITION) AS COLUMNS
  FROM ALL_IND_COLUMNS C
 WHERE C.TABLE_NAME = 'SCM_STOCK_H'
 GROUP BY C.INDEX_OWNER, C.INDEX_NAME
 ORDER BY C.INDEX_NAME;

PROMPT ===== 2-5. SCM_STOCK_H 최근 3일 실제 건수 (사업부 전체, 82 사업부) =====
SELECT COUNT(*)                                          AS CNT_ALL
     , COUNT(CASE WHEN H.DIVISION_ID = '&P_DIV' THEN 1 END) AS CNT_DIV
  FROM SCM_DNM_STOCK_SN H
 WHERE H.CUTOFF_DATE  > TRUNC(SYSDATE) - 3
   AND H.CUTOFF_DATE <= TRUNC(SYSDATE);

PROMPT ===== 3. 재고 뷰 1회 읽기 (조회 시작일 기준 3일) =====
SELECT V.SITE_ID
     , TO_CHAR(V.CUTOFF_DATE, 'YYYYMMDD') AS CUTOFF_DATE
     , COUNT(*)                           AS CNT
  FROM SSP_DNM_ESS_PACKER_STOCK_V V
 WHERE V.DIVISION_ID  = '&P_DIV'
   AND V.CUTOFF_DATE  > TO_DATE('&P_FROM', 'YYYYMMDD') - 3
   AND V.CUTOFF_DATE <= TO_DATE('&P_FROM', 'YYYYMMDD')
 GROUP BY V.SITE_ID, V.CUTOFF_DATE
 ORDER BY 1, 2;

PROMPT ===== 4. 뷰 안 품목 기준 행 수 (OSP 공장 품목) =====
SELECT COUNT(*) AS SITE_ITEM_CNT
  FROM SCM_MST_SITE_ITEM C
     , SCM_MST_SITE      D
 WHERE C.DIVISION_ID = D.DIVISION_ID
   AND C.SCM_SITE_ID = D.SCM_SITE_ID
   AND D.SITE_TYPE   = 'PLANT'
   AND D.OSP_YN      = 'Y'
   AND D.VALID_YN    = 'Y'
   AND D.DIVISION_ID = '&P_DIV';

PROMPT ===== 5. 수정안 : 재고 뷰 1번 읽기 (현재 문장 82 사업부 부분과 같은 결과를 내는 SELECT) =====
SELECT IA.DIVISION_ID
     , IA.ITEM_ID
     , IA.FROM_SITE
     , '&P_FROM'      AS YYYYMMDD
     , SUM(IA.QTY)    AS QTY
  FROM (SELECT A.DIVISION_ID
             , A.ITEM_ID
             , A.SCM_SITE_ID                                         AS FROM_SITE
             , A.SSP_QTY                                             AS QTY
          FROM (SELECT V.DIVISION_ID
                     , V.SITE_ID
                     , V.SCM_SITE_ID
                     , V.ITEM_ID
                     , V.SSP_QTY
                     , V.CUTOFF_DATE
                     , MAX(V.CUTOFF_DATE) OVER (PARTITION BY V.DIVISION_ID, V.SITE_ID) AS MAX_CUTOFF_DATE
                  FROM SSP_DNM_ESS_PACKER_STOCK_V V
                 WHERE V.DIVISION_ID  = '&P_DIV'
                   AND V.CUTOFF_DATE  > TO_DATE('&P_FROM', 'YYYYMMDD') - 3
                   AND V.CUTOFF_DATE <= TO_DATE('&P_FROM', 'YYYYMMDD')) A
             , SCM_MST_SITE       B
             , SCP_MST_FINAL_ITEM C
         WHERE A.CUTOFF_DATE      = A.MAX_CUTOFF_DATE
           AND A.DIVISION_ID      = B.DIVISION_ID
           AND A.SCM_SITE_ID      = B.SCM_SITE_ID
           AND B.SITE_TYPE        = 'PLANT'
           AND B.OPERATION_GROUP IN ('&P_BIZ', 'W')
           AND B.VALID_YN         = 'Y'
           AND A.DIVISION_ID      = C.DIVISION_ID
           AND A.ITEM_ID          = C.ITEM_ID
           AND C.OPERATION_GROUP IN ('&P_BIZ', 'W')) IA
 GROUP BY IA.DIVISION_ID
        , IA.ITEM_ID
        , IA.FROM_SITE
 ORDER BY 1, 2, 3;
