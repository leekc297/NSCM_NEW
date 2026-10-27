CREATE VIEW [dbo].[SCM_ITEM_V]
AS
SELECT DISTINCT
        ISNULL(B.NEW_COMPANY_ID, A.COMPANY_ID ) AS COMPANY_ID
      , ISNULL(B.NEW_DIVISION_ID, A.DIVISION_ID) AS DIVISION_ID
      , ISNULL(B.NEW_SITE_ID, A.SITE_ID) AS SITE_ID
      , A.ITEM_ID
      , A.ITEM_NAME
      , A.NICK_NAME
      , A.ITEM_TYPE
      , A.ITEM_CLASS_LEVEL_1
      , A.ITEM_CLASS_LEVEL_2
      , A.ITEM_CLASS_LEVEL_3
      , A.ITEM_CLASS_LEVEL_4
      , A.ITEM_CLASS
      , A.ITEM_CLASS_NAME
      , A.MATERIAL_CLASS
      , A.MATERIAL_CLASS_NAME
      , A.ELECTRODE_TYPE
      , A.SIDE_TYPE
      , A.ITEM_GROUP_ID
      , A.SETUP_GROUP_ID_1
      , A.SETUP_GROUP_ID_2
      , A.SETUP_GROUP_ID_3
      , A.FLOW_ID
      , A.ERP_EOL
      , A.SCP_EOL
      , A.ITEM_UOM
      , A.SPEC
      , A.DEMAND_LOT_SIZE
      , A.ITEM_ATTRIBUTE
      , A.SETUP_ATTRIBUTE
      , A.BATCH_RATIO_ID
      , A.OUTSOURCING_FACTORY
      , A.FINITE_TERM
      , A.FINITE_TERM_UOM
      , A.COATED_LENGTH
      , A.UNCOATED_LENGTH
      , A.LENGTH_UOM
      , A.SLURRY_LOSS_RATE
      , A.DESCRIPTION
      , A.ACTIVE_FLAG
      , A.INSERT_ID
      , A.INSERT_TIME
      , A.UPDATE_ID
      , A.UPDATE_TIME
FROM   SCM_ITEM_M A
       LEFT OUTER JOIN (
                        SELECT *
                        FROM   (
                                SELECT ITEM_ID FROM SCM_ITEM_M WHERE COMPANY_ID = 'G450' AND DIVISION_ID  = '81' AND SITE_ID = 'A002'
                                EXCEPT
                                SELECT ITEM_ID FROM SCM_ITEM_M WHERE COMPANY_ID = 'G180' AND DIVISION_ID  = '40' AND SITE_ID = 'A002'
                               ) A,
                               (
                                SELECT 'G450' AS COMPANY_ID,  'G180'  AS NEW_COMPANY_ID   
                                     , '81'   AS DIVISION_ID, '40'    AS NEW_DIVISION_ID
                                     , 'A002' AS SITE_ID,     'A002'  AS NEW_SITE_ID 
                                UNION  ALL
                                SELECT 'G450' AS COMPANY_ID,  'G450'  AS NEW_COMPANY_ID
                                     , '81' DIVISION_ID,      '81'    AS NEW_DIVISION_ID
                                     , 'A002' AS SITE_ID,     'A002'  AS NEW_SITE_ID       
                               ) B
                        WHERE  1=1
                       ) B
     ON    A.COMPANY_ID = B.COMPANY_ID
     AND   A.DIVISION_ID = B.DIVISION_ID
     AND   A.SITE_ID = B.SITE_ID
     AND   A.ITEM_ID = B.ITEM_ID
