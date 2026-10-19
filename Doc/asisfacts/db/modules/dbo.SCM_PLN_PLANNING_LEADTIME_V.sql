CREATE VIEW [dbo].[SCM_PLN_PLANNING_LEADTIME_V] AS
/*
 * Program ID   : SCM_PLN_PLANNING_LEADTIME_V
 * Description  : DM CUTOFF ~ SCP FINAL PLAN CONFIRM LEADTIME 지표추출
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018.12.03  YYDOK         Initial Release 전지본부 GSCM 구축 프로젝트
 */
SELECT DM.DIVISION_ID,
       CAL.WEEK_NAME,
       CAL.BASIS_YYYYMMDD,
       DM.CUTOFF_DATE,
       DM.VERSION_NO,
       SCP.CONFIRM_DATE,
       (SELECT DAYOFWEEK
          FROM SCM_SYS_CALENDAR_M WITH(NOLOCK)
         WHERE BASIS_YYYYMMDD = CONVERT(VARCHAR,SCP.CONFIRM_DATE,112)) AS SCP_CONFIRM_DAYOFWEEK,
       ROUND((DATEDIFF(HOUR, DM.CUTOFF_DATE,SCP.CONFIRM_DATE))/24.0,2) AS PLANNING_LEADTIME
FROM
      (SELECT 
               division_id
              ,version_type
              ,CONVERT(VARCHAR(08), DATEADD(WW, -1, DBO.FN_NEXT_DAY(yyyymmdd, 'MON')), 112) AS week_day
              ,MAX(version_no) AS version_no
              ,MAX(CREATION_DATE) AS CUTOFF_DATE
         FROM dm_mst_version WITH(NOLOCK)
        WHERE version_type = 'MF_W'
          AND DIVISION_ID IN ('81','40')
        GROUP BY division_id
              ,version_type
              ,CONVERT(VARCHAR(08), DATEADD(WW, -1, DBO.FN_NEXT_DAY(yyyymmdd, 'MON')), 112)
      ) DM,
      (
        SELECT B.DIVISION_ID,
               A.PLAN_NAME,
               B.CONFIRM_DATE
          FROM SCM_MST_PLAN  A WITH(NOLOCK),
               SCM_MST_PLAN_DETAIL B WITH(NOLOCK)
         WHERE B.DIVISION_ID IN ('81','40')
           AND B.PLAN_TYPE='FN'
           AND B.CONFIRM_FLAG='Y'
           AND B.DIVISION_ID = A.DIVISION_ID
           AND B.PLAN_ID = A.PLAN_ID
        --ORDER BY PLAN_ID
      ) SCP,
      (
        SELECT '81' AS DIVISION_ID,
               BASIS_YYYYMMDD,
               WEEK_NAME
          FROM SCM_SYS_CALENDAR_M WITH(NOLOCK)
         WHERE DAYOFWEEK='MON'
           AND BASIS_YYYYMMDD >='20180601'
        UNION ALL
        SELECT '40' AS DIVISION_ID,
               BASIS_YYYYMMDD,
               WEEK_NAME
          FROM SCM_SYS_CALENDAR_M WITH(NOLOCK)
         WHERE DAYOFWEEK='MON'
           AND BASIS_YYYYMMDD >='20181001'
      ) CAL
WHERE DM.DIVISION_ID = SCP.DIVISION_ID
  AND DM.WEEK_DAY    = SCP.PLAN_NAME
  AND DM.DIVISION_ID = CAL.DIVISION_ID
  AND DM.WEEK_DAY    = CAL.BASIS_YYYYMMDD
