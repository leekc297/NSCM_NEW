--------------------------------------------------------------------------------
-- DMF0044 / SHEET 'MDF Reports' — INPUT_TP_CD 'S' 원복
-- 마커 : E20260903-DMF0044TPREVERT
--------------------------------------------------------------------------------
-- 배경 : ETC INSERT 시 저장 안 되는 21개 컬럼을 편집불가('S')로 임시 변경했으나,
--        DMF0049 배선 확인이 끝나지 않아 원복한다.
-- 원복값 : DEPARTMENT_ID -> 'IM' (Insert Mandatory) / 나머지 20 -> 'IO' (Insert Optional)
-- 안전장치 : WHERE ... AND INPUT_TP_CD='S' — 이미 원복된 행은 건드리지 않음(멱등).
-- 기대 결과 : 21행 갱신. 원복 후 분포 IM 1 / IO 32 / S 13
-- 적용 계정 : SCM_MGR
--------------------------------------------------------------------------------
SET DEFINE OFF

UPDATE SCM_MGR.SCM_MST_SHEET_COLUMNS
   SET INPUT_TP_CD      = 'IM'
     , LAST_UPDATED_BY  = 'admin'
     , LAST_UPDATE_DATE = SYSDATE
 WHERE PROGRAM_ID  = 'DMF0044'
   AND SHEET_NAME  = 'MDF Reports'
   AND COLUMN_NAME = 'DEPARTMENT_ID'
   AND INPUT_TP_CD = 'S';

UPDATE SCM_MGR.SCM_MST_SHEET_COLUMNS
   SET INPUT_TP_CD      = 'IO'
     , LAST_UPDATED_BY  = 'admin'
     , LAST_UPDATE_DATE = SYSDATE
 WHERE PROGRAM_ID  = 'DMF0044'
   AND SHEET_NAME  = 'MDF Reports'
   AND INPUT_TP_CD = 'S'
   AND COLUMN_NAME IN (
         'END_CUSTOMER'      , 'SOLDTO_CODE'   , 'SOLDTO_CUST_REPORT', 'CUST_GROUP_DTL',
         'ITEM_NAME'         , 'ENERGE_WH'     , 'ENERGE_KWH'        , 'PRODUCT_DETAILS',
         'CELL_PROD_SITE'    , 'BIZ_TYPE'      , 'APPLICATION_GR'    , 'COUNTRY_CODE',
         'PLANT_SITE_ID'     , 'CELL_PER_CAR'  , 'MODULE_PER_CAR'    , 'MODEL_TYPE',
         'ITEM_USE'          , 'SOLDTO_COUNTRY', 'SHIPTO_COUNTRY'    , 'PROJECT_Name',
         'Cell_Name' );

COMMIT;

--------------------------------------------------------------------------------
-- 검증 : 기대 IM 1 / IO 32 / S 13
--------------------------------------------------------------------------------
SELECT NVL(INPUT_TP_CD,'<NULL>') AS INPUT_TP_CD, COUNT(*) AS 행수
  FROM SCM_MGR.SCM_MST_SHEET_COLUMNS
 WHERE PROGRAM_ID = 'DMF0044' AND SHEET_NAME = 'MDF Reports'
 GROUP BY INPUT_TP_CD
 ORDER BY 1;
