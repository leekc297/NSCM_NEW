





CREATE VIEW [dbo].[SCM_MST_OPERATION_FLOW_V] AS
/****************************************************************************
  * PROJECT       : LG CHEM SCP PRJ.
  * VIEW NAME     : SCM_MST_OPERATION_FLOW_V
  * DESCRIPTION   : 전극,셀,팩공정그룹의 Flow 정보를 조회 
  *
  * PROGRAM HISTORY
  *--------------------------------------------------------------
  *  DATE        IN CHARGE           DESCRIPTION
  *--------------------------------------------------------------
  * 2018-03-06   KSG                 INITIAL
  * 2018-07-20   KSG                 소형을 위한 VALID 조정
  * 2022-03-23   KSG                 PJ20216891 Digital SCM 3 Level 가속화를 위한 개선 : GM JV 가상 Division
  * 2023-04-03   HRK				 PJ20230691R LGES SCM 역량 강화 위한 SCP 개선과제 이행 : HM JV 가상 사업부 추가 대응
  ****************************************************************************/
SELECT t.*
     , CASE WHEN SUBSTRING(t.operation_id, 1, 1) = 'F' THEN 'A' -- 활성화 => CELL
            WHEN SUBSTRING(t.operation_id, 1, 1) = 'S' THEN 'E' -- SRS => 전극
           -- WHEN SUBSTRING(t.operation_id, 1, 1) = 'E' AND SUBSTRING(t.flow_id, 1, 2) <> 'E2' THEN 'X'
            ELSE SUBSTRING(t.operation_id, 1, 1)
       END operation_group
     , CASE WHEN     t.division_id = '40'
	             AND t.operation_id IN ('F6200', 'F7000', 'F7100', 'F7200', 'F7300') 
                                                     THEN 'Y' -- 2018-07-20 소형을 위한 VALID 조정
            WHEN SUBSTRING(t.operation_id, 1, 1) = 'F' THEN 'N' -- 활성화 => CELL
            WHEN SUBSTRING(t.operation_id, 1, 1) = 'S' THEN 'N' -- SRS => 전극
           -- WHEN SUBSTRING(t.operation_id, 1, 1) = 'E' AND SUBSTRING(t.flow_id, 1, 2) <> 'E2' THEN 'N'
            ELSE 'Y'
       END valid_yn
FROM   dbo.scm_mst_operation_flow_sn t WITH(NOLOCK) 
		INNER JOIN SCM_MST_DIVISION D WITH(NOLOCK)  -- PJ20230691R HM JV 가상 사업부 추가 대응 
			    ON D.DIVISION_ID = T.DIVISION_ID
			   AND D.ATTRIBUTE3  <> 'EE' --IN ('40', '81', '82')  
			   AND D.VALID_YN	 = 'Y'
WHERE 1=1  -- HM JV t.division_id IN ('40', '81', '82', '81_UC')  -- 20220323 PJ20216891 GM JV 가상 Division 추가


