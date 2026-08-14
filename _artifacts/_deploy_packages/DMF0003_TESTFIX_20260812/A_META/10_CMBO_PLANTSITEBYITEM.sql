-- DMF0003 정본 재대사 보완 — CMBO PlantSiteByItem 신설 (CD-10 행별 Plant Site, AS-IS UP_FX L5858~5884 1:1)
SET DEFINE OFF;

DECLARE
  v_sql CLOB;
BEGIN
  v_sql := 'SELECT DISTINCT
       S.SCM_SITE_ID AS CODE
     , S.SCM_SITE_ID AS NAME
FROM   SCM_MST_SITE S
INNER JOIN (SELECT DISTINCT I.DIVISION_ID, I.COMPANY_ID
                 , (CASE WHEN I.SCP_OPERATION_GROUP = ''E'' THEN ''A'' ELSE I.SCP_OPERATION_GROUP END) AS SCP_OPERATION_GROUP
            FROM   SCM_MST_PROJECT_ITEM SI
            INNER JOIN SCM_MST_ITEM_SN I
                ON SI.ITEM_ID = I.ITEM_ID
            WHERE  I.ITEM_TYPE IS NOT NULL
            AND    (@divisionId IS NULL OR @divisionId = '''' OR SI.DIVISION_ID = @divisionId)
            AND    (@projectCode IS NULL OR @projectCode = '''' OR SI.PROJECT_CODE = @projectCode)
            AND    (@itemId IS NULL OR @itemId = '''' OR SI.ITEM_ID = @itemId)
           ) SS
    ON  S.DIVISION_ID = SS.DIVISION_ID
    AND S.OPERATION_GROUP = NVL(SS.SCP_OPERATION_GROUP, S.OPERATION_GROUP)
    AND S.COMPANY_ID = SS.COMPANY_ID
WHERE  S.SITE_TYPE = ''PLANT''
AND    (@divisionId IS NULL OR @divisionId = '''' OR S.DIVISION_ID = @divisionId)
ORDER BY 1, 2';
  MERGE INTO SCM_MGR.SCM_ADM_CMBO_SQL_M T
  USING (SELECT 'PlantSiteByItem' SQL_ID FROM DUAL) S
     ON (T.SQL_ID = S.SQL_ID)
   WHEN MATCHED THEN UPDATE SET T.SQL_DTL_CTN = v_sql, T.SQL_NM = 'DMF0003 행별 Plant Site (AS-IS UP_FX PlantSiteByItem 1:1 — project/item 조건)', T.USE_YN = 'Y',
          T.LAST_UPDATED_BY = 'admin', T.LAST_UPDATE_DATE = SYSDATE
   WHEN NOT MATCHED THEN INSERT (SQL_ID, MDU_DIVS_CD, SQL_NM, SQL_DTL_CTN, USE_YN,
          CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
        VALUES ('PlantSiteByItem', 'DM', 'DMF0003 행별 Plant Site (AS-IS UP_FX PlantSiteByItem 1:1 — project/item 조건)', v_sql, 'Y', 'admin', SYSDATE, 'admin', SYSDATE);
END;
/
COMMIT;