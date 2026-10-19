




CREATE VIEW [dbo].[SCP_ANL_PRODUCTION_PLAN_DW_V] AS
/*
 * Program ID   : SCP_ANL_PRODUCTION_PLAN_DW_V
 * Description  : SCP Production Plan : DW용
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2022.04.28   KSG            Initial Release : PJ20216891 Digital SCM 3 Level 가속화를 위한 개선 : GM JV
 * 2023-04-03   HRK			   PJ20230691R LGES SCM 역량 강화 위한 SCP 개선과제 이행 : HM JV 가상 사업부 추가 대응
 * 
 */

  SELECT -- HM JV 대응 CASE WHEN DIVISION_ID = '81_UC' THEN '81' 
         -- HM JV 대응      WHEN DIVISION_ID = 'EE_UC' THEN 'EE' 
         -- HM JV 대응      ELSE DIVISION_ID 
		 -- HM JV 대응 END AS DIVISION_ID
		 D.ATTRIBUTE3	AS DIVISION_ID 
       , P.PLAN_START_YYYYMMDD
       , P.PLAN_TYPE
       , P.SEQ
       , P.OPERATION_GROUP
       , P.SCM_SITE_ID
       , P.ITEM_ID
       , P.LINE_ID
       , P.OPERATION_ID
       , P.MEASURE
       , P.YYYYMMDD
       , P.QTY
       -- HM JV 대응 , CASE WHEN ORIGIN_DIVISION_ID = '81_UC' THEN '81' ELSE ORIGIN_DIVISION_ID END AS ORIGIN_DIVISION_ID
	   , O.ATTRIBUTE3	AS ORIGIN_DIVISION_ID	-- HM JV 가상 사업부 추가 대응 
       , P.ELECTRODE_TYPE
       , P.CREATED_BY
       , P.CREATION_DATE
       , P.LAST_UPDATED_BY
       , P.LAST_UPDATE_DATE
       , P.ATTRIBUTE1
       , P.ATTRIBUTE2
       , P.ATTRIBUTE3
       , P.ATTRIBUTE4
       , P.ATTRIBUTE5
       , P.ATTRIBUTE6
       , P.ATTRIBUTE7
       , P.ATTRIBUTE8
       , P.ATTRIBUTE9
       , P.ATTRIBUTE10
       , P.CELL_QTY
	   , P.DIVISION_ID AS SCM_DIVISION_ID
	   , P.ORIGIN_DIVISION_ID AS SCM_ORIGIN_DIVISION_ID
  FROM   SCP_ANL_PRODUCTION_PLAN P WITH(NOLOCK)
		 INNER JOIN SCM_MST_DIVISION D WITH(NOLOCK)  -- HM JV 가상 사업부 추가 대응 
				 ON D.DIVISION_ID = P.DIVISION_ID 
				AND D.VALID_YN	  = 'Y'
		 LEFT  JOIN SCM_MST_DIVISION O WITH(NOLOCK)  -- HM JV 가상 사업부 추가 대응 
				 ON O.DIVISION_ID = P.ORIGIN_DIVISION_ID 
				AND O.VALID_YN	  = 'Y'
  ;

