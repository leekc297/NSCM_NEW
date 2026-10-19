



CREATE VIEW [dbo].[SCM_KPI_TIMELINE_DW_V] AS
/*
 * Program ID   : SCM_KPI_TIMELINE_DW_V
 * Description  : KPI Timeline : DW용
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2022.04.28   KSG            Initial Release : PJ20216891 Digital SCM 3 Level 가속화를 위한 개선 : GM JV
 * 2023.04.03	HRK			   PJ20230691R LGES SCM 역량 강화 위한 SCP 개선과제 이행 : HM JV 가상 사업부 추가 대응
 * 
 */

  SELECT -- HM JV CASE WHEN DIVISION_ID = '81_UC' THEN '81' 
         -- HM JV      WHEN DIVISION_ID = 'EE_UC' THEN 'EE' 
         -- HM JV      ELSE DIVISION_ID 
		 -- HM JV END AS DIVISION_ID
		 D.ATTRIBUTE3	AS DIVISION_ID	-- HM JV 가상 사업부 추가 대응 
       , K.PLAN_START_YYYYMMDD
       , K.PLAN_TYPE
       , K.PLAN_SEQ
       , K.PLAN_START_DATE
       , K.PLAN_START_WEEK_DAY
       , K.PLAN_WEEK_DAY
       , K.PLAN_START_TIME
       , K.PLAN_TIME
       , K.VALID_TYPE
       , K.CREATED_BY
       , K.CREATION_DATE
       , K.LAST_UPDATED_BY
       , K.LAST_UPDATE_DATE
       , K.ATTRIBUTE1
       , K.ATTRIBUTE2
       , K.ATTRIBUTE3
       , K.ATTRIBUTE4
       , K.ATTRIBUTE5
       , K.ATTRIBUTE6
       , K.ATTRIBUTE7
       , K.ATTRIBUTE8
       , K.ATTRIBUTE9
       , K.ATTRIBUTE10
	   , K.DIVISION_ID AS SCM_DIVISION_ID
  FROM   SCM_KPI_TIMELINE K WITH(NOLOCK)
		 INNER JOIN SCM_MST_DIVISION D WITH(NOLOCK)  -- HM JV 가상 사업부 추가 대응 
				 ON D.DIVISION_ID = K.DIVISION_ID 
				AND D.VALID_YN	  = 'Y'
  ;

