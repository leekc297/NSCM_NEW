

/****************************************************************************
  * PROJECT       : PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선
  * VIEW NAME     : SCM_MST_ALTER_BOM_V
  * DESCRIPTION   : 대치 BOM 
  *
  * PROGRAM HISTORY
  *--------------------------------------------------------------
  *  DATE      IN CHARGE           DESCRIPTION
  *--------------------------------------------------------------
  * 2021-03-08   SDS          PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선: 대치 BOM 
  *								- 대치 BOM에서 계획 수립 대상은 한 개로 제한
  * 2025.08.31   kimcd       PJ20257329 최적화 Planning Input Constraint UI 개발 및 Master Validation 확산  : 
  *                          Item 비활성의 경우 SCP 미반영으로 설정
  ****************************************************************************/
CREATE VIEW [dbo].[SCM_MST_ALTER_BOM_V] AS

SELECT B.DIVISION_ID
	 , B.SITE_ID
	 , B.PLANT_ID
	 , B.PARENT_ITEM_ID
	 , B.CHILD_ITEM_ID
	 , B.ALT_ID
	 , B.ALT_PRIORITY
	 , B.BOM_VERSION_ID
	 , B.KEY_DATE 
	 , B.EFF_START_DATE
	 , B.EFF_END_DATE
	 , B.PARENT_QTY
	 , B.PARENT_UOM
	 , B.CHILD_QTY
	 , B.CHILD_UOM
	 , B.VIEW_SCP_PLAN_YN AS SCP_PLAN_YN 
	 , B.COMMON_CELL_YN 
	 , B.CHILD_ITEM_TYPE
  FROM ( SELECT X.*
	   , CASE
	    -- 2025.08.31   kimcd       PJ20257329 최적화 Planning Input Constraint UI 개발 및 Master Validation 확산  : 
        --                          Item 비활성의 경우 SCP 미반영으로 설정
			--대치 BOM일 경우 반드시 1개는 계획이 수립이 되도록 한다.
			--단일 대치BOM 또는 모두 SCP_PLAN_YN = 'N'일 경우 등...
			WHEN ATTRIBUTE13 = 'N' THEN 'N'
			WHEN ROW_NUMBER() OVER(PARTITION BY DIVISION_ID, SITE_ID, PLANT_ID, PARENT_ITEM_ID, ALT_ID ORDER BY SCP_PLAN_YN DESC, ALT_PRIORITY, EFF_START_DATE, EFF_END_DATE) = 1 THEN 'Y' 
			ELSE 'N' 
		 END AS VIEW_SCP_PLAN_YN
	FROM DBO.SCM_MST_ALTER_BOM X WITH(NOLOCK)
	WHERE 1=1
	--AND   CHILD_ITEM_TYPE <> 'R'	--원자재 제외
       ) B
 WHERE 1=1
;

