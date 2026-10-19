/* =====================================================================================================
 * DMF0082 저장 후 DM_PLN_MKT_FCST 에 QTY=0 행이 함께 생긴 사유 확인 (클라우드 실행용 · 조회 전용 · 변경 없음)
 * 대상: 40 / NT / Foxlink_CN_DGG / MCSS22531-B1 / E / MPS / DAP / SCM_FCST / PLANT '/'  (저장자 k0101, 2026-10-14)
 *
 * 확인하려는 가설 (사내 소스 기준):
 *  (1) 주 셀(W_)에 수량을 넣으면 화면이 그 주의 배분 요일(40 기본=월요일)에 전량을 넣고,
 *      같은 주의 다른 요일 중 "기존 값이 있던 날"을 0 으로 바꿔 함께 저장 전송한다.
 *      (빈칸→0 은 변경으로 안 잡으므로, 기존 값이 있던 날만 0 으로 넘어간다)
 *  (2) 저장 SP 는 확정 테이블 DM_PLN_CFM_MKT_DEMAND_PLAN 에서는 0 행을 삭제하지만,
 *      이어서 부르는 P_PR_DM_PLN_CFM_TO_MKT_FCST 는 넘겨받은 행을 0 여부와 관계없이
 *      DM_PLN_MKT_FCST 에 DELETE 후 INSERT 한다 → QTY=0 행이 남는다.
 *
 * 실행: 전체 F5 가능 (SELECT 만). 결과 해석은 각 블록 주석 참고.
 * ===================================================================================================== */

/* V1. 저장 결과 — 날짜별 요일 · 주 시작일 확인
 *  기대: 999999 = 월요일, 0 = 같은 주의 다른 요일(10/16 금 · 11/06 금 · 11/18 수) */
SELECT F.YYYYMMDD
     , TO_CHAR(TO_DATE(F.YYYYMMDD, 'YYYYMMDD'), 'DY', 'NLS_DATE_LANGUAGE=ENGLISH')      AS DOW
     , TO_CHAR(TRUNC(TO_DATE(F.YYYYMMDD, 'YYYYMMDD'), 'IW'), 'YYYYMMDD')                AS WEEK_MON
     , F.QTY, F.CREATED_BY, F.CREATION_DATE, F.LAST_UPDATED_BY, F.LAST_UPDATE_DATE
FROM SCM_MGR.DM_PLN_MKT_FCST F
WHERE F.DIVISION_ID   = '40'
  AND F.PROJECT_CODE  = 'NT'
  AND F.SCM_SITE_ID   = 'Foxlink_CN_DGG'
  AND F.ITEM_ID       = 'MCSS22531-B1'
  AND F.DOM_EXP       = 'E'
  AND F.FCST_TYPE     = 'MPS'
  AND F.INCOTERMS     = 'DAP'
  AND F.MEASURE       = 'SCM_FCST'
  AND F.PLANT_SITE_ID = '/'
  AND F.YYYYMMDD     >= '20261012'
ORDER BY F.YYYYMMDD;

/* V2. 화면이 실제로 보낸 값 — 저장 이력(_H)은 저장 SP 가 받은 행을 0 포함 그대로 남긴다
 *  기대: 오늘 k0101 저장 시각에 8행(999999 5행 + 0 3행) → 0 은 화면이 보낸 값임이 확정 */
SELECT H.CREATION_DATE AS SAVED_AT, H.YYYYMMDD
     , TO_CHAR(TO_DATE(H.YYYYMMDD, 'YYYYMMDD'), 'DY', 'NLS_DATE_LANGUAGE=ENGLISH') AS DOW
     , H.QTY, H.CREATED_BY, H.CELL_PROD_SITE_ID, H.END_CUSTOMER, H.HISTORY_SEQ
FROM SCM_MGR.DM_PLN_CFM_MKT_DEMAND_PLAN_H H
WHERE H.DIVISION_ID   = '40'
  AND H.PROJECT_CODE  = 'NT'
  AND H.SCM_SITE_ID   = 'Foxlink_CN_DGG'
  AND H.ITEM_ID       = 'MCSS22531-B1'
  AND H.DOM_EXP       = 'E'
  AND H.FCST_TYPE     = 'MPS'
  AND H.INCOTERMS     = 'DAP'
  AND H.MEASURE       = 'SCM_FCST'
  AND H.PLANT_SITE_ID = '/'
  AND H.CREATION_DATE >= TRUNC(SYSDATE)
ORDER BY H.CREATION_DATE, H.YYYYMMDD;

/* V3. 0 으로 바뀐 3일의 "저장 전" 값 — 직전 이력에 값이 있었는지
 *  기대: 10/16 · 11/06 · 11/18 에 오늘 이전 이력(0 이 아닌 값)이 존재 → 기존 값이 있던 날이라 0 으로 전송됨
 *  (이력이 없으면 아래 V4 의 MKT_FCST 쪽 이전 값 원천을 확인 — 배치/인터페이스 적재분일 수 있음) */
SELECT H.YYYYMMDD
     , TO_CHAR(TO_DATE(H.YYYYMMDD, 'YYYYMMDD'), 'DY', 'NLS_DATE_LANGUAGE=ENGLISH') AS DOW
     , H.QTY, H.CREATED_BY, H.CREATION_DATE, H.HISTORY_SEQ
FROM SCM_MGR.DM_PLN_CFM_MKT_DEMAND_PLAN_H H
WHERE H.DIVISION_ID   = '40'
  AND H.PROJECT_CODE  = 'NT'
  AND H.SCM_SITE_ID   = 'Foxlink_CN_DGG'
  AND H.ITEM_ID       = 'MCSS22531-B1'
  AND H.DOM_EXP       = 'E'
  AND H.FCST_TYPE     = 'MPS'
  AND H.INCOTERMS     = 'DAP'
  AND H.MEASURE       = 'SCM_FCST'
  AND H.PLANT_SITE_ID = '/'
  AND H.YYYYMMDD IN ('20261016', '20261106', '20261118')
  AND H.CREATION_DATE < TRUNC(SYSDATE)
ORDER BY H.YYYYMMDD, H.CREATION_DATE;

/* V4. 확정 테이블 현재 상태 — 0 행은 저장 SP 가 삭제하므로 없어야 정상
 *  기대: 월요일 5행(999999)만 있고, 10/16 · 11/06 · 11/18 행은 없음
 *  → DM_PLN_MKT_FCST(V1) 에만 0 이 있다 = P_PR_DM_PLN_CFM_TO_MKT_FCST 가 0 행을 그대로 INSERT 한 결과 */
SELECT C.YYYYMMDD
     , TO_CHAR(TO_DATE(C.YYYYMMDD, 'YYYYMMDD'), 'DY', 'NLS_DATE_LANGUAGE=ENGLISH') AS DOW
     , C.QTY, C.END_CUSTOMER, C.CELL_PROD_SITE_ID, C.LAST_UPDATED_BY, C.LAST_UPDATE_DATE
FROM SCM_MGR.DM_PLN_CFM_MKT_DEMAND_PLAN C
WHERE C.DIVISION_ID   = '40'
  AND C.PROJECT_CODE  = 'NT'
  AND C.SCM_SITE_ID   = 'Foxlink_CN_DGG'
  AND C.ITEM_ID       = 'MCSS22531-B1'
  AND C.DOM_EXP       = 'E'
  AND C.FCST_TYPE     = 'MPS'
  AND C.INCOTERMS     = 'DAP'
  AND C.MEASURE       = 'SCM_FCST'
  AND C.PLANT_SITE_ID = '/'
  AND C.YYYYMMDD     >= '20261012'
ORDER BY C.YYYYMMDD;

/* V5. 품목 배분 요일(BUCKET) — 주 수량이 어느 요일로 배분되는지
 *  기대: 비어 있거나 '0000000' 이면 40 기본 = 월요일('0100000', 일요일부터 7자리) */
SELECT B.*
FROM SCM_MGR.DM_MST_BUCKET_CONVERSION B
WHERE B.DIVISION_ID = '40'
  AND B.SCM_SITE_ID = 'Foxlink_CN_DGG'
  AND B.ITEM_ID     = 'MCSS22531-B1';

/* V6. 같은 시각 실행된 프로그램 — DMF0082 저장 → CFM_TO_MKT_FCST 순서로 돌았는지 (다른 화면 저장 개입 배제)
 *  ※ PROGRAM_NAME 은 패키지명(PKG_DMF0082)으로만 남는다 → IN_PARA 로 구분
 *     (저장 = p_yyyymmdd 등 포함 / CFM_TO_MKT_FCST = {"p_created_by":...} 만)
 *  기대: 저장 START~END 사이에 CFM_TO_MKT_FCST START/END 가 k0101 로 기록, 다른 PKG(DMF0003 등) 개입 없음 */
SELECT L.EVENT_DATE, L.PROGRAM_NAME, L.LOG_TYPE, SUBSTR(L.LOG_MESSAGE, 1, 120) AS LOG_MESSAGE, L.CREATED_BY
     , SUBSTR(L.DESCRIPTION, 1, 120) AS DESCRIPTION   -- CFM_TO_MKT_FCST START = '@p_created_by : k0101'
     , DBMS_LOB.SUBSTR(L.IN_PARA_DATA, 200, 1) AS IN_PARA
FROM SCM_MGR.SCM_SYS_LOG_BATCH L
WHERE L.EVENT_DATE >= TRUNC(SYSDATE)
  AND L.CREATED_BY  = 'k0101'
  AND L.LOG_TYPE IN ('START', 'END', 'ERROR')
ORDER BY L.EVENT_DATE;
