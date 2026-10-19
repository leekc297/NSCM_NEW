


CREATE VIEW [dbo].[SCM_MST_FINAL_ITEM_V] AS  
/****************************************************************************  
* PROJECT       : LG CHEM SCP PRJ.  
* VIEW NAME     : SCM_MST_FINAL_ITEM_V  
* DESCRIPTION   : 전극,셀,팩공정그룹의 최종공정의 ITEM을 조회   
*  
* PROGRAM HISTORY  
*--------------------------------------------------------------  
*  DATE      IN CHARGE           DESCRIPTION  
*--------------------------------------------------------------  
* 2018-01-19   YYDOK        INITIAL  
* 2018-01-30   YYDOK        조회기준변경:   
*                            이전:ROUTING등록된 ITEM  
*                            이후:ITEM_TYPE,MODEL 체계반영.  
* 2018-02-08   YYDOK        전극이 현재는 ITEM TYPE=H(반제품)밖에 없으나, 향후  
*                           제품이 존재할수 있음을 고려(ITEM_TYPE=P)   
* 2018-04-18   YYDOK        82(ESS) 'EC' CELL ITEM이 81(자동차전지)에 보일수 있게 추가  
* 2018-05-31   YYDOK        81,40 DIVISON의 CELL,PACK도 다른 사업부에 FINAL ITEM으로 보일수 있게 수정  
* 2018-07-04   KTH          CTE로 'EE' DIVISION 추가  
* 2018-07-25   KTH          운영버전으로 반영함
* 2018-08-15   YYDOK        TCO_CELL_YN COLUMN ADD
* 2019-07-02   KSG          82(ESS) 'EC' CELL ITEM이 40(소형전지)에 보일수 있게 추가  
* 2020-10-14   KSG          PJ20202001 LG화학 전지. 공급 대응력 향상을 위한 SCM 관리 체계 개선 : RACK
* 2021-09-13   KSG          PJ20214907 LGES SCP 계획 수립 시간 단축 및 분석 기능 강화 : MEB(P5200) 추가
*                             --> 2021.12.13 PI 요청으로 원복함
* 2021-12-15   KSG          PJ20214907 LGES SCP 계획 수립 시간 단축 및 분석 기능 강화 : ESS EP Final Item 추가 : item_class = 'EM0308'
* 2022-01-08   KSG          PJ20216891 Digital SCM 3 Level 가속화를 위한 개선 : DC Item 구분 : item_class = 'EM0307'
* 2022-03-23   KSG          PJ20216891 Digital SCM 3 Level 가속화를 위한 개선 : GM JV 가상 Division
* 2022-06-02   KSG          PJ20216891 Digital SCM 3 Level 가속화를 위한 개선 : ISUZU Item 구분
* 2022-12-20   KSG          PJ20216894 Digital SCM 3 Level 가속화를 위한 개선 Phase2 : Trust BCU Item 구분 : item_class = 'EM0306'
* 2023-04-03   HRK			PJ20230691R LGES SCM 역량 강화 위한 SCP 개선과제 이행 : HM JV 가상 사업부 추가 대응
* 2023-06-01   KSG          PJ20230691R LGES SCM 역량 강화 위한 SCP 개선과제 이행 : 활성화 대응 준비 - SCM_MST_FINAL_ITEM_ORIGIN_DIV_V 사용
****************************************************************************/  
  
/*********************************************
-- 1. SCM_MST_FINAL_ITEM_ORIGIN_DIV_V
*********************************************/
SELECT DISTINCT   
       i.DIVISION_ID,  
       i.ITEM_ID,  
       /* E:ELECTRODE, A:CELL, P:PACK */  
       I.OPERATION_GROUP_ID,  
       I.NICK_NAME,  
       I.ITEM_CLASS,  
       I.ITEM_CLASS_NAME,  
       I.ELECTRODE_TYPE,
       I.TCO_CELL_YN,
       I.RACK_YN, -- 20201014 PJ20202001 RACK Item Flag 추가
       I.DC_YN,
       I.IS_YN,   -- 20220602 PJ20216891 ISUZU Item 구분
	   I.CELL_TYPE
FROM   SCM_MST_FINAL_ITEM_ORIGIN_DIV_V I WITH(NOLOCK)  
WHERE  1=1  

UNION
  
/*********************************************
-- 2.  CELL,PACK은 다른 사업부에 FINAL ITEM으로 보여야 함 : JV 는 별도 처리 필요 없음
*********************************************/
SELECT DISTINCT   
      '40' AS DIVISION_ID,  
       i.ITEM_ID,  
       /* E:ELECTRODE, A:CELL, P:PACK */  
       I.OPERATION_GROUP_ID,  
       I.NICK_NAME,  
       I.ITEM_CLASS,  
       I.ITEM_CLASS_NAME,  
       I.ELECTRODE_TYPE,
       I.TCO_CELL_YN,
       I.RACK_YN, -- 20201014 PJ20202001 RACK Item Flag 추가
       I.DC_YN,
       I.IS_YN,   -- 20220602 PJ20216891 ISUZU Item 구분
	   I.CELL_TYPE
FROM   SCM_MST_FINAL_ITEM_ORIGIN_DIV_V I WITH(NOLOCK)  
WHERE  1=1  
AND    I.DIVISION_ID IN ('81', '82') 
AND    I.OPERATION_GROUP_ID IN ('A', 'P', '')

UNION   

SELECT DISTINCT   
       '81' AS DIVISION_ID,  
       i.ITEM_ID,  
       /* E:ELECTRODE, A:CELL, P:PACK */  
       I.OPERATION_GROUP_ID,  
       I.NICK_NAME,  
       I.ITEM_CLASS,  
       I.ITEM_CLASS_NAME,  
       I.ELECTRODE_TYPE,
       I.TCO_CELL_YN,
       I.RACK_YN, -- 20201014 PJ20202001 RACK Item Flag 추가
       I.DC_YN,
       I.IS_YN,   -- 20220602 PJ20216891 ISUZU Item 구분
	   I.CELL_TYPE
FROM   SCM_MST_FINAL_ITEM_ORIGIN_DIV_V I WITH(NOLOCK)  
WHERE  1=1  
AND    I.DIVISION_ID IN ('40', '82') 
AND    I.OPERATION_GROUP_ID IN ('A', 'P', '')

UNION  

SELECT DISTINCT   
      '82' AS DIVISION_ID,  
       i.ITEM_ID,  
       /* E:ELECTRODE, A:CELL, P:PACK */  
       I.OPERATION_GROUP_ID,  
       I.NICK_NAME,  
       I.ITEM_CLASS,  
       I.ITEM_CLASS_NAME,  
       I.ELECTRODE_TYPE,
       I.TCO_CELL_YN,
       I.RACK_YN, -- 20201014 PJ20202001 RACK Item Flag 추가
       I.DC_YN,
       I.IS_YN,   -- 20220602 PJ20216891 ISUZU Item 구분
	   I.CELL_TYPE
FROM   SCM_MST_FINAL_ITEM_ORIGIN_DIV_V I WITH(NOLOCK)  
WHERE  1=1  
AND    I.DIVISION_ID IN ('40', '81') 
AND    I.OPERATION_GROUP_ID IN ('A', 'P', '')

;  

