


/****************************************************************************  
 * PROJECT       : LG CHEM SCP PRJ.  
 * VIEW NAME     : SCP_MST_FINAL_ITEM_V  
 * DESCRIPTION   : 전극,셀,팩공정그룹의 최종공정의 ITEM을 조회   
 *                 ITEM ID에 대하여 하나의 정보만 조회되어야 함
 * PROGRAM HISTORY  
 *--------------------------------------------------------------  
 *  DATE      IN CHARGE           DESCRIPTION  
 *--------------------------------------------------------------  
 * 2018-07-04   KTH          INITIAL  
 * 2018-08-15   YYDOK        TCO_CELL_YN ADD
 * 2018-11-27   YYDOK        CELL_LIST(ATTRIBUTE1) ADD
 * 2019-11-20   KSG          BOM 이슈로 GROUP BY 처리
 * 2020-10-14   KSG          PJ20202001 LG화학 전지. 공급 대응력 향상을 위한 SCM 관리 체계 개선 : RACK
 * 2022-01-08   KSG          PJ20216891 Digital SCM 3 Level 가속화를 위한 개선 : DC Item 구분 : item_class = 'EM0307'
 * 2022-06-02   KSG          PJ20216891 Digital SCM 3 Level 가속화를 위한 개선 : ISUZU Item 구분
 * 2023-06-02   KSG          PJ20230691 LGES SCM 역량 강화 위한 SCP 개선과제 이행 : 활성화 대응 Cell Prod/Assy 구분자 추가
 ****************************************************************************/  

CREATE VIEW [dbo].[SCP_MST_FINAL_ITEM_V]
AS
SELECT --DISTINCT 
       ITEM_ID
      ,MIN(OPERATION_GROUP)         AS OPERATION_GROUP
      ,MIN(ELECTRODE_TYPE)          AS ELECTRODE_TYPE
      ,MIN(TCO_CELL_YN)             AS TCO_CELL_YN
      ,MIN(ATTRIBUTE1)              AS CELL_LIST
      ,MIN(ISNULL(ATTRIBUTE3, 'N')) AS RACK_YN -- 20201014 PJ20202001 RACK Item Flag 추가
      ,MIN(ISNULL(ATTRIBUTE4, 'N')) AS DC_YN -- 20220107 DC Item 구분
      ,MIN(ISNULL(ATTRIBUTE5, 'N')) AS IS_YN -- 20220602 PJ20216891 ISUZU Item 구분
	  ,MIN(ISNULL(ATTRIBUTE8, 'N')) AS CELL_TYPE  -- 20230601 PJ20230691 활성화 대응 Cell Prod/Assy 구분자 추가
FROM   SCP_MST_FINAL_ITEM WITH (NOLOCK)
GROUP BY ITEM_ID
--GROUP BY ITEM_ID, OPERATION_GROUP, ELECTRODE_TYPE, TCO_CELL_YN, ISNULL(ATTRIBUTE3, 'N')

