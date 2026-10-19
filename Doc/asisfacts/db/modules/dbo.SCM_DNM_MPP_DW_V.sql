


CREATE VIEW [dbo].[SCM_DNM_MPP_DW_V] AS
/*
 * Program ID   : SCM_DNM_MPP_DW_V
 * Description  : MPP : DW용
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2022.04.28   KSG            Initial Release : PJ20216891 Digital SCM 3 Level 가속화를 위한 개선 : GM JV
 * 2023.04.03	HRK			   PJ20230691R LGES SCM 역량 강화 위한 SCP 개선과제 이행 : HM JV 가상 사업부 추가 대응
 * 
 */

  SELECT -- HM JV CASE WHEN DIVISION_ID = '81_UC' THEN '81' ELSE DIVISION_ID END AS DIVISION_ID
		 D.ATTRIBUTE3	AS DIVISION_ID -- HM JV 가상 사업부 추가 대응
       , P.SITE_ID
       , P.PLANT_ID
       , P.BUILDING
       , P.OPERATION_ID
       , P.LINE_ID
       , P.LINE_NAME
       , P.PROD_TYPE
       , P.BASIC_MODEL
       , P.ITEM_ID
       , P.NICK_NAME
       , P.EXTRA_SPEC
       , P.ITEM_CLASS
       , P.CUSTOMER
       , P.PIC
       , P.BASIS_YEAR
       , P.BASIS_MONTH
       , P.BASIS_WEEK
       , P.BASIS_DATE
       , P.MPP_QTY
       , P.RESULT_QTY
       , P.MPP_QTY_CELL
       , P.RESULT_QTY_CELL
       , P.Init_by
       , P.Init_dttm
       , P.up_by
       , P.up_dttm
       , P.OPERATION_GROUP
	   , P.DIVISION_ID AS SCM_DIVISION_ID
  FROM   SCM_DNM_MPP  P WITH(NOLOCK)
		 INNER JOIN SCM_MST_DIVISION D WITH(NOLOCK)  -- HM JV 가상 사업부 추가 대응
				 ON D.DIVISION_ID = P.DIVISION_ID
				AND D.VALID_YN	  = 'Y'
  ;

