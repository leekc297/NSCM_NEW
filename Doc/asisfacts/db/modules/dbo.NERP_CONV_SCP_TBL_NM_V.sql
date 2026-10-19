





CREATE   VIEW [dbo].[NERP_CONV_SCP_TBL_NM_V] AS
/*
 * Program ID   : NERP_CONV_SCP_TBL_NM_V
 * Description  : NERP_CONV 대상중 SCP 처리 항목별 테이블 이름
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2025.03.30   김준규         Initial Release : NERP_CONV 대상중 SCP 처리 항목별 테이블 이름
 * 2025.05.25   김준규         NERP) 컨버전 프로시저 컬럼 추가
 *
 */

  SELECT DISTINCT 1 AS SORT_SEQ
       , 'LOOKUP'   AS RTYPE
       , PROGRAM_ID AS TABLE_NAME
       , 'PR_SCP_NERP_COLUMN_CONVERTER_UPDATE_LOOKUP' AS CONV_PR_NAME
  from ZNERP_DEV_ITEM_SCHEDULE
  where dev_type in ( 'Batch_LOOKUP')
  and mapping_use = 'Y'
  and dev_remark IN ('SCP', 'COMMON')
  and dev_detail != 'INCOTERMS' --> DM에서 조치 협의
  UNION ALL
  SELECT DISTINCT 2 AS SORT_SEQ
       , 'MASTER'   AS RTYPE
       , PROGRAM_ID AS TABLE_NAME
       , 'PR_SCP_NERP_COLUMN_CONVERTER_UPDATE_MASTER' AS CONV_PR_NAME
    FROM ZNERP_DEV_ITEM_SCHEDULE WITH (NOLOCK)
   where DEV_TYPE = 'Batch_Conversion'
     AND mapping_use IN ( 'IN')
  UNION ALL
  SELECT DISTINCT 3 AS SORT_SEQ
       , 'STORAGE'  AS RTYPE
       , PROGRAM_ID AS TABLE_NAME
       , 'PR_SCP_NERP_COLUMN_CONVERTER_UPDATE_STORAGE' AS CONV_PR_NAME
  FROM   ZNERP_DEV_ITEM_SCHEDULE WITH (NOLOCK)
  WHERE  DEV_TYPE = 'Batch_Conversion'
  AND    mapping_use IN ( 'UP', 'CA')
  AND    MAPPING_COLUMN = 'STORAGE_ID'
  UNION ALL
  SELECT DISTINCT 4 AS SORT_SEQ
       , 'TABLES'   AS RTYPE
       , PROGRAM_ID AS TABLE_NAME
       , 'PR_SCP_NERP_COLUMN_CONVERTER_UPDATE_TABLES' AS CONV_PR_NAME
   FROM ZNERP_DEV_ITEM_SCHEDULE WITH (NOLOCK)
  where DEV_TYPE = 'Batch_Conversion'
  and mapping_use IN ( 'UP' ,'CA')
  and mapping_column  in ('COMPANY_ID','PLANT_ID','END_CUSTOMER_ID','VENDOR_ID','SCM_SITE_ID', 'SCM_SITE_DESCRIPTION', 'PACKER_CODE', 'PSI_VALUE', 'PLANT_VENDOR','PLANT_DESCRIPTION', 'WAERS','PRCTR')  -- STORAGE 별도 처리
  and dev_detail != 'INCOTERMS'
  UNION ALL
  SELECT DISTINCT 5 AS SORT_SEQ
       , 'DUPLICATION' AS RTYPE
       , PROGRAM_ID AS TABLE_NAME
       , 'PR_SCP_NERP_COLUMN_CONVERTER_UPDATE_DUPLICATION' AS CONV_PR_NAME
   FROM ZNERP_DEV_ITEM_SCHEDULE WITH (NOLOCK)
  where DEV_TYPE = 'Batch_Conversion'
  AND   MAPPING_USE IN ( 'DP')
  UNION ALL
  SELECT DISTINCT 6 AS SORT_SEQ
       , 'CUTOFF_MASTER' AS RTYPE
       , M.TABLE_NAME AS TABLE_NAME
       , 'PR_SCP_NERP_COLUMN_CONVERTER_UPDATE_CUTOFF' AS CONV_PR_NAME
  FROM   NERP_CONV_SCP_CUTOFF_MASTER M  WITH (NOLOCK)
  WHERE  M.MAPPING_USE = 'Y'
  UNION ALL
  SELECT DISTINCT 7 AS SORT_SEQ
       , 'LOOKUP_TYPE' AS RTYPE
       , DIS.DEV_DETAIL AS TABLE_NAME
       , 'PR_SCP_NERP_COLUMN_CONVERTER_UPDATE_LOOKUP' AS CONV_PR_NAME
  from ZNERP_DEV_ITEM_SCHEDULE DIS  WITH (NOLOCK)
  where dev_type in ( 'Batch_LOOKUP')
  and mapping_use = 'Y'
  and dev_remark IN ('SCP', 'COMMON')
  and dev_detail != 'INCOTERMS'
  --ORDER BY SORT_SEQ,TABLE_NAME
  ;




