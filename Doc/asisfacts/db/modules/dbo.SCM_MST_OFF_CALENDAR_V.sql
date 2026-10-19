

CREATE VIEW [dbo].[SCM_MST_OFF_CALENDAR_V] AS
/*
 * Program ID   : SCM_MST_OFF_CALENDAR_V
 * Description  : 라인별 WORK OFF 시간 계산용 
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018. 1. 08  Kim Jaejung      Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018. 1. 13  YYDOK            SCM_MST_EQUIPMENT_EXCEPT_SN 대상 장비제외처리
 *
 */
 WITH A AS 
  (SELECT		 C.COMPANY_ID
                 ,C.DIVISION_ID
		         ,C.SITE_ID
		         ,C.PLANT_ID
		         ,C.FACTORY_ID
		         ,C.OPERATION_ID
		         ,C.LINE_ID
		         ,C.EQUIPMENT_ID
		         ,C.OFF_START_TIME AS OFF_TIME
		         ,datediff(minute,C.OFF_START_TIME,C.OFF_END_TIME) OFF_TIME_MINUTE
             FROM (SELECT A.COMPANY_ID,A.DIVISION_ID,A.SITE_ID,A.PLANT_ID,A.FACTORY_ID,A.OPERATION_ID,A.LINE_ID,A.EQUIPMENT_ID
	                       ,dateadd(hour,replace(B.SEGMENT2,'0','')*-1,A.OFF_START_TIME) OFF_START_TIME
	                       ,dateadd(hour,replace(B.SEGMENT2,'0','')*-1,A.OFF_END_TIME) OFF_END_TIME
                     FROM [dbo].[SCM_MST_OFF_CALENDAR_SN] A WITH(NOLOCK)
                     JOIN [dbo].[SCM_ADM_LOOKUP_VALUE_FP_SN] B WITH(NOLOCK)
                     ON A.PLANT_ID = B.SEGMENT1
                     AND B.LOOKUP_TYPE_CODE = 'BASIS_START_TIME_PLANT') C
           )
SELECT   A.COMPANY_ID
        ,A.DIVISION_ID
		,A.SITE_ID
		,A.PLANT_ID
		,A.FACTORY_ID
		,A.OPERATION_ID
		,A.LINE_ID
		,convert(char(8),A.OFF_TIME,112) OFF_DAY
        ,SUM(A.OFF_TIME_MINUTE) OFF_TIME_MINUTE 
		FROM  A
	 WHERE 	1=1
	   AND NOT EXISTS (
	                    SELECT 'X'
	                      FROM SCM_MST_EQUIPMENT_EXCEPT_SN B WITH(NOLOCK)
	                     WHERE B.COMPANY_ID     = A.COMPANY_ID
	                       AND B.DIVISION_ID    = A.DIVISION_ID
	                       AND B.SITE_ID        = A.SITE_ID
	                       AND B.PLANT_ID       = A.PLANT_ID
	                       AND B.FACTORY_ID     = A.FACTORY_ID
	                       AND B.EQUIPMENT_ID   = A.EQUIPMENT_ID
	                       AND B.START_TIME <= convert(char(8),A.OFF_TIME,112)
                         AND B.END_TIME       >= convert(char(8),A.OFF_TIME,112)
                         AND B.ACTIVE_FLAG    = 'Y'  
	                   )
  GROUP BY A.COMPANY_ID
        ,A.DIVISION_ID
		,A.SITE_ID
		,A.PLANT_ID
		,A.FACTORY_ID
		,A.OPERATION_ID
		,A.LINE_ID
	    ,CONVERT(CHAR(8),A.OFF_TIME,112)
