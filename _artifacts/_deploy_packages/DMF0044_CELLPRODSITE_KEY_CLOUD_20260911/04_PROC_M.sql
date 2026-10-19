-- =====================================================================================
-- DMF0044 Cutoff 저장 SP 파라미터 계약 갱신 (23 IN -> 25 IN)
--   마커: E20260911-CELLPRODKEY / 원장 REQ:CHAT-20260911-W66
--   ⚠ 03_PKG_DMF0044_BODY.sql 과 **반드시 함께** 적용 (단독 적용 금지)
--
-- SPEC 파라미터 순서 (위치 바인딩이므로 SORT_ORD 가 이 순서와 일치해야 함):
--   ... 21 P_FCST_TYPE, 22 P_INCOTERMS, 23 P_CELL_PROD_SITE, 24 P_PLANT_SITE_ID,
--       25 P_CREATED_BY(=sesUserId), 26 O_RESULT_CURSOR(=result)
--
-- DATA_TP_CD 는 **기존 행에서 복사**한다 — 환경별(VARCHAR/CLOB) 차이를 자동 흡수하기 위함.
--   (사내 실측은 VARCHAR, 클라우드는 E20260903-DMF0044CLOB 로 CLOB 일 수 있음)
-- =====================================================================================

-- ① 뒤쪽 2행을 먼저 밀어낸다 (sesUserId 23->25, result 24->26)
UPDATE SCM_MGR.SCM_ADM_PROC_M                                   /*[E20260911-CELLPRODKEY]*/
   SET SORT_ORD = 26, LAST_UPDATED_BY='admin', LAST_UPDATE_DATE=SYSDATE
 WHERE PROC_NM = 'PKG_DMF0044.P_DMF0044_SAVE_SALES_PLAN_REPORT_C_CF'
   AND COL_NM  = 'result' AND SORT_ORD = 24;

UPDATE SCM_MGR.SCM_ADM_PROC_M                                   /*[E20260911-CELLPRODKEY]*/
   SET SORT_ORD = 25, LAST_UPDATED_BY='admin', LAST_UPDATE_DATE=SYSDATE
 WHERE PROC_NM = 'PKG_DMF0044.P_DMF0044_SAVE_SALES_PLAN_REPORT_C_CF'
   AND COL_NM  = 'sesUserId' AND SORT_ORD = 23;

-- ② 신규 2행 — DATA_TP_CD/COL_TP_CD 는 incoterms 행에서 그대로 복사 (멱등)
INSERT INTO SCM_MGR.SCM_ADM_PROC_M                              /*[E20260911-CELLPRODKEY]*/
    ( PROC_NM, COL_NM, DATA_TP_CD, COL_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE )
SELECT S.PROC_NM, 'cellProdSite', S.DATA_TP_CD, S.COL_TP_CD, 23, 'admin', SYSDATE, 'admin', SYSDATE
  FROM SCM_MGR.SCM_ADM_PROC_M S
 WHERE S.PROC_NM = 'PKG_DMF0044.P_DMF0044_SAVE_SALES_PLAN_REPORT_C_CF'
   AND S.COL_NM  = 'incoterms'
   AND NOT EXISTS ( SELECT 1 FROM SCM_MGR.SCM_ADM_PROC_M T
                     WHERE T.PROC_NM = S.PROC_NM AND T.COL_NM = 'cellProdSite' );

INSERT INTO SCM_MGR.SCM_ADM_PROC_M                              /*[E20260911-CELLPRODKEY]*/
    ( PROC_NM, COL_NM, DATA_TP_CD, COL_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE )
SELECT S.PROC_NM, 'plantSiteId', S.DATA_TP_CD, S.COL_TP_CD, 24, 'admin', SYSDATE, 'admin', SYSDATE
  FROM SCM_MGR.SCM_ADM_PROC_M S
 WHERE S.PROC_NM = 'PKG_DMF0044.P_DMF0044_SAVE_SALES_PLAN_REPORT_C_CF'
   AND S.COL_NM  = 'incoterms'
   AND NOT EXISTS ( SELECT 1 FROM SCM_MGR.SCM_ADM_PROC_M T
                     WHERE T.PROC_NM = S.PROC_NM AND T.COL_NM = 'plantSiteId' );

COMMIT;

-- ③ 검증 — 기대: 26행, SORT_ORD 1..26 연속, 23=cellProdSite / 24=plantSiteId / 25=sesUserId / 26=result
SELECT SORT_ORD, COL_NM, COL_TP_CD, DATA_TP_CD
  FROM SCM_MGR.SCM_ADM_PROC_M
 WHERE PROC_NM = 'PKG_DMF0044.P_DMF0044_SAVE_SALES_PLAN_REPORT_C_CF'
 ORDER BY SORT_ORD;
