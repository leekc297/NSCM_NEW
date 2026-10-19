



CREATE VIEW [dbo].[SCP_MST_FORMATION_V] AS
/*
 * Program ID   : SCP_MST_FORMATION_V
 * Description  : 활성화 및 특성수율, 활성화 LEAD TIME
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2019.02.22  yydok     Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2019.07.09  KTH       SSP_MODIFY_YIELD 추가 (자동차 시물레이션 YIELD 계산에서 요청
 * 2024.05.28  KSG       PJ20244573 LGES SCM SCP 생산모델 기반 공급계획 수립체계 구성 : ssp 수율 처리 변경
 */
SELECT DIVISION_ID,
       PLANT_SITE_ID,
       ITEM_ID,
       ISNULL(FORMATION_YIELD,1.0) AS FORMATION_YIELD,
       ISNULL(CHAR_YIELD,1.0)      AS CHAR_YIELD,
       ISNULL(FORMATION_YIELD,1.0) * ISNULL(CHAR_YIELD,1.0) AS FORMATION_TOTAL_YIELD,
       LT_FORMATION,
       CONVERT(NUMERIC,ISNULL(ATTRIBUTE1,'0.0')) AS ADD_LT_FORMATION,
       LT_FORMATION + CONVERT(NUMERIC,ISNULL(ATTRIBUTE1,'0.0')) AS TOTAL_LT_FORMATION,
	   -- 20240528 PJ20244573 : ssp 수율 처리 변경 - NULL 인 경우 0.0 에서 계산으로 변경
       ISNULL(SSP_MODIFY_YIELD,
	          ISNULL(FORMATION_YIELD,1.0) * ISNULL(CHAR_YIELD,1.0)	   
	         ) AS SSP_MODIFY_YIELD
  FROM SCP_MST_FORMATION WITH(NOLOCK)

