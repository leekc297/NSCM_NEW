


CREATE VIEW [dbo].[SCP_MST_FINAL_ITEM_DW_V] AS
/*
 * Program ID   : SCP_MST_FINAL_ITEM_DW_V
 * Description  : SCP Plan용 Item : DW용
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2022.04.28   KSG            Initial Release : PJ20216891 Digital SCM 3 Level 가속화를 위한 개선 : GM JV
 * 2023.04.04   HRK			   PJ20230691R LGES SCM 역량 강화 위한 SCP 개선과제 이행 : HM JV 가상 사업부 추가 대응
 * 
 */

  SELECT -- PJ20230691R HM JV 대응 CASE WHEN DIVISION_ID = '81_UC' THEN '81' ELSE DIVISION_ID END AS DIVISION_ID
	     D.ATTRIBUTE3 AS DIVISION_ID	-- PJ20230691R HM JV 가상 사업부 추가 대응
       , I.ITEM_ID
       , I.NICK_NAME
       , I.ITEM_CLASS
       , I.OPERATION_GROUP
       , I.OPERATION_GROUP_ID
       , I.ELECTRODE_TYPE
       , I.FLOW_ID
       , I.DEMAND_GROUPING_DAYS
       , I.CREATED_BY
       , I.CREATION_DATE
       , I.LAST_UPDATED_BY
       , I.LAST_UPDATE_DATE
       , I.PACKER_PLAN_ITEM_ID
       , I.TCO_CELL_YN
       , I.CELL_TYPE_GROUP_CODE
       , I.CELL_ITEM_ID
       , I.CONVERT_QTY_CELL
       , I.FCST_YN
       , I.MIN_DUE_DATE
       , I.ATTRIBUTE1
       , I.ATTRIBUTE2
       , I.ATTRIBUTE3
       , I.ATTRIBUTE4
       , I.ATTRIBUTE5
       , I.ATTRIBUTE6
       , I.ATTRIBUTE7
       , I.ATTRIBUTE8
       , I.ATTRIBUTE9
       , I.ATTRIBUTE10
       , I.GROUP_CODE1
       , I.GROUP_CODE2
       , I.GROUP_CODE3
       , I.GROUP_CODE4
       , I.GROUP_CODE5  
	   , I.DIVISION_ID AS SCM_DIVISION_ID
  FROM   SCP_MST_FINAL_ITEM I WITH(NOLOCK)
		 INNER JOIN SCM_MST_DIVISION D WITH(NOLOCK)  -- PJ20230691R HM JV 가상 사업부 추가 대응
				 ON D.DIVISION_ID = I.DIVISION_ID 
				AND D.VALID_YN	  = 'Y'
  ;

