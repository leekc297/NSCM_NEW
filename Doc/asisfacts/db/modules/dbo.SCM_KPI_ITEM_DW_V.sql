



CREATE VIEW [dbo].[SCM_KPI_ITEM_DW_V] AS
/*
 * Program ID   : SCM_KPI_ITEM_DW_V
 * Description  : KPI Item : DW용
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2022.04.28   KSG            Initial Release : PJ20216891 Digital SCM 3 Level 가속화를 위한 개선 : GM JV
 * 2023.04.03	HRK			   PJ20230691R LGES SCM 역량 강화 위한 SCP 개선과제 이행 : HM JV 가상 사업부 추가 대응
 * 
 */

  SELECT -- HM JV CASE WHEN DIVISION_ID = '81_UC' THEN '81' ELSE DIVISION_ID END AS DIVISION_ID
		 D.ATTRIBUTE3	AS DIVISION_ID	-- HM JV 가상 사업부 추가 대응 
       , V.ITEM_ID
       , V.ITEM_NAME
       , V.NICK_NAME
       , V.ITEM_TYPE
       , V.ITEM_TYPE_NAME
       , V.ITEM_UOM
       , V.SPEC
       , V.OPERATION_GROUP
       , V.OPERATION_GROUP_ID
       , V.FLOW_ID
       , V.OPERATION_GROUP_NAME
	   , V.DIVISION_ID AS SCM_DIVISION_ID
  FROM   SCM_KPI_ITEM_V V WITH(NOLOCK)
		 INNER JOIN SCM_MST_DIVISION D WITH(NOLOCK)  -- HM JV 가상 사업부 추가 대응 
				 ON D.DIVISION_ID = V.DIVISION_ID 
				AND D.VALID_YN	  = 'Y'
  ;

