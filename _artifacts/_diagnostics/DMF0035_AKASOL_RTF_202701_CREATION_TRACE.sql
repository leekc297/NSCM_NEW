--------------------------------------------------------------------------------
-- DMF0035 Mkt Fcst Waterfall — Akasol 2027-01 RTF 457,600 생성시점 추적
--
-- 대상 : 클라우드 Oracle (SCM_MGR)
-- 근거 : PKG_DMF0035 "MF/SF 버전 계획 데이터 INSERT (미래구간)" 블록
--          Division 40 → (CASE WHEN P_DIVISION_ID='40' THEN 1 ELSE 2 END)=1 분기
--          → 원천 = SCM_MGR.DM_PLN_CFM_MKT_DEMAND_PLAN_C
--        비-_C 테이블(DM_PLN_CFM_MKT_DEMAND_PLAN)은 VERSION_NO 컬럼이 없어 버전 조회 불가.
--
-- 대상 행(TOBE xlsx 실측) :
--   Div 40 / End Customer Akasol / Sales Site Akasol Inc_US_HZP
--   Model MCCM348018A3-000 (M50L) / Incoterms DAP / FCST Type Mass
--   Customs Handbook(DOM_EXP) E / Cell Prod Site 오창A / Version SF_W_20260907_V001
--   2027-01 = 457,600
--
-- 표기 매핑 (SCM_ADM_LOOKUP_MASTER_DETAIL, LOOKUP_TYPE='SP_CELL_PROD_SITE') :
--   오창A = SEGMENT1 IN ('A010-A','HQ06-A')  /  오창2A = 'HQ10-A'
--   남경A = 'NJ01-A'  /  미국AA = 'AZ00-A'  /  Common = '-'
--   ※ ATTRIBUTE1 이 표시값 — 아래 Q1 은 코드 하드코딩 대신 이 마스터를 조인해 '오창A' 로 건다.
--
-- YYYYMMDD 는 월 버킷 첫날 저장 ('20270101' = 2027-01).
--------------------------------------------------------------------------------

--==============================================================================
-- Q1. 단건 정밀 — 해당 행의 생성/최종수정 시점
--==============================================================================
SELECT F.MEASURE
     , F.YYYYMMDD
     , F.QTY
     , F.CELL_PROD_SITE_ID
     , NVL(EE.ATTRIBUTE1, 'Common')                       AS CELL_PROD_SITE_NM
     , TO_CHAR(F.CREATION_DATE,    'YYYY-MM-DD HH24:MI:SS') AS 생성일시
     , F.CREATED_BY                                         AS 생성자
     , TO_CHAR(F.LAST_UPDATE_DATE, 'YYYY-MM-DD HH24:MI:SS') AS 최종수정일시
     , F.LAST_UPDATED_BY                                    AS 최종수정자
     , F.CUTOFF_TYPE
     , F.CUTOFF_YYYYMMDD
     , F.PROJECT_CODE
     , F.PLANT_SITE_ID
  FROM SCM_MGR.DM_PLN_CFM_MKT_DEMAND_PLAN_C F
  LEFT JOIN SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL EE
         ON EE.LOOKUP_TYPE = 'SP_CELL_PROD_SITE'
        AND EE.SEGMENT1    = CASE WHEN LENGTH(NVL(F.CELL_PROD_SITE_ID,'')) = 0
                                  THEN '-' ELSE F.CELL_PROD_SITE_ID END
        AND EE.SEGMENT2 = '-' AND EE.SEGMENT3 = '-'
        AND EE.SEGMENT4 = '-' AND EE.SEGMENT5 = '-'
        AND EE.VALID_YN = 'Y'
 WHERE F.DIVISION_ID  = '40'
   AND F.VERSION_NO   = 'SF_W_20260907_V001'
   AND F.END_CUSTOMER = 'Akasol'
   AND F.SCM_SITE_ID  = 'Akasol Inc_US_HZP'
   AND F.ITEM_ID      = 'MCCM348018A3-000'
   AND F.INCOTERMS    = 'DAP'
   AND F.FCST_TYPE    = 'Mass'
   AND F.DOM_EXP      = 'E'
   AND F.MEASURE      IN ('RTF', 'RTF_SYS_RP')
   AND F.YYYYMMDD     = '20270101'
   AND NVL(EE.ATTRIBUTE1, 'Common') = '오창A'
 ORDER BY F.MEASURE;

--==============================================================================
-- Q2. 동일 키 전 기간·전 Measure — 이 행만 늦게 들어왔는지(행 단위 생성시각 편차) 확인
--==============================================================================
SELECT F.MEASURE
     , F.YYYYMMDD
     , F.QTY
     , TO_CHAR(F.CREATION_DATE,    'YYYY-MM-DD HH24:MI:SS') AS 생성일시
     , F.CREATED_BY                                         AS 생성자
     , TO_CHAR(F.LAST_UPDATE_DATE, 'YYYY-MM-DD HH24:MI:SS') AS 최종수정일시
     , F.LAST_UPDATED_BY                                    AS 최종수정자
  FROM SCM_MGR.DM_PLN_CFM_MKT_DEMAND_PLAN_C F
 WHERE F.DIVISION_ID  = '40'
   AND F.VERSION_NO   = 'SF_W_20260907_V001'
   AND F.END_CUSTOMER = 'Akasol'
   AND F.SCM_SITE_ID  = 'Akasol Inc_US_HZP'
   AND F.ITEM_ID      = 'MCCM348018A3-000'
   AND F.INCOTERMS    = 'DAP'
   AND F.FCST_TYPE    = 'Mass'
   AND F.DOM_EXP      = 'E'
 ORDER BY F.MEASURE, F.YYYYMMDD;

--==============================================================================
-- Q3. 같은 버전 RTF 전체의 생성시각 분포
--     → 버전 생성 배치와 같은 시각이면 "원래 있던 데이터", 늦은 시각이면 "사후 생성/수정"
--==============================================================================
SELECT TO_CHAR(F.CREATION_DATE, 'YYYY-MM-DD HH24:MI') AS 생성분
     , F.CREATED_BY                                   AS 생성자
     , F.MEASURE
     , COUNT(*)                                       AS 건수
     , MIN(F.YYYYMMDD)                                AS 최소월
     , MAX(F.YYYYMMDD)                                AS 최대월
  FROM SCM_MGR.DM_PLN_CFM_MKT_DEMAND_PLAN_C F
 WHERE F.DIVISION_ID = '40'
   AND F.VERSION_NO  = 'SF_W_20260907_V001'
   AND F.MEASURE     IN ('RTF', 'RTF_SYS_RP')
 GROUP BY TO_CHAR(F.CREATION_DATE, 'YYYY-MM-DD HH24:MI'), F.CREATED_BY, F.MEASURE
 ORDER BY 1, 3;

--==============================================================================
-- Q4. (참고) 버전 전체 Measure 별 생성시각 — RTF 만 다른 시각인지 대조
--==============================================================================
SELECT F.MEASURE
     , COUNT(*)                                                  AS 건수
     , TO_CHAR(MIN(F.CREATION_DATE), 'YYYY-MM-DD HH24:MI:SS')    AS 최초생성
     , TO_CHAR(MAX(F.CREATION_DATE), 'YYYY-MM-DD HH24:MI:SS')    AS 최종생성
     , TO_CHAR(MAX(F.LAST_UPDATE_DATE), 'YYYY-MM-DD HH24:MI:SS') AS 최종수정
     , COUNT(DISTINCT F.CREATED_BY)                              AS 생성자수
  FROM SCM_MGR.DM_PLN_CFM_MKT_DEMAND_PLAN_C F
 WHERE F.DIVISION_ID = '40'
   AND F.VERSION_NO  = 'SF_W_20260907_V001'
 GROUP BY F.MEASURE
 ORDER BY F.MEASURE;
