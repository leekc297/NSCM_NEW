

CREATE VIEW [dbo].[SCP_PLN_PROD_PLAN_TARGET_V] AS
/**********************************************************************************************************************
  * PROJECT       : LG CHEM SCP PRJ.
  * VIEW NAME     : SCP_PLN_PROD_PLAN_TARGET_V
  * DESCRIPTION   : FP, MRP용 PROD TARGET VIEW
  * PROGRAM HISTORY
  *-------------------------------------------------------------------------------------------------------------------
  *  DATE      IN CHARGE           DESCRIPTION
  *-------------------------------------------------------------------------------------------------------------------
  * 2018-03-28   YYDOK        INITIAL
  * 2018-04-20   YYDOK        0나누기 오류로 COMPLETE_QTY >= 1.0 조건추가
  * 2018-04-25   YYDOK        PLANT_ID가져오기 수정
  * 2018-05-02   YYDOK        주별 월요일가져오는 부분 수정
  * 2018-05-11   YYDOK        PACKER는 PLANT_ID 대신에 LOGISTIC_PLANT_ID로 변경
  * 2018-05-15   YYDOK        중국만 납선을 구분하고,나머지는 'D'로 셋팅요청(FP.정인천)
  * 2018-07-02   YYDOK        소형 packer에 대하여 item id 12번째자리를 packer site의 suffix정보로 변경처리로직반영
  *                           EE 사업부인 경우,셀계획 제외처리,ORIGIN_DIVISION_ID ADD  
  * 2018.07.24   YYDOK        소형 특성후공정셀관련 공정코드추가(F6200,F7000,F7100,F7200,F7300)
  *                           left(P.operation_id,1) <> 'F' --'F'로 시작하는 공정 제외=> left(P.operation_id,5) NOT IN ( 'F1000','F6000') --활성화,특성제외 
  * 2018.08.08   YYDOK        EE인 경우, PLANT_CD NULL로 나오는 오류수정
  * 2019.01.10   YYDOK        EE관련 외주업체 OPERATION누락으로 외주PACKER의 업체코드체크시 DIVISION_ID체크제외함.
  * 2019.09.03   KSG          [CSR ID 4074962] SCP생산계획 송신(to MRP) 버켓단위 변경 요청 건 : Partial 기준 Week 시작일자 정보 추가
  * 2020.10.28   KSW          PJ20202001 LG화학 전지. 공급 대응력 향상을 위한 SCM 관리 체계 개선 : RACK biz. 대응
  * 2021.11.15   KSG          PJ20214907 LGES SCP 계획 수립 시간 단축 및 분석 기능 강화 : MEBC
  * 2022-03-23   KSG          PJ20216891 Digital SCM 3 Level 가속화를 위한 개선 : GM JV 가상 Division
  * 2022.07.01   sclee.lee    PJ20216891 Digital SCM 3 Level 가속화를 위한 개선 - isuzu관련 조회구문 변경
  * 2023-02-27   KSG          PJ20230691I  LGES SCM 역량 강화 위한 SCP 개선과제 이행 : Line 제외 대비 Target ID 변경 (적용보류)
  * 2023-04-04   HRK		  PJ20230691R  LGES SCM 역량 강화 위한 SCP 개선과제 이행 : HM JV 가상 사업부 추가 대응
  * 2024-06-09   vadabi3      NERP - 특정 Company 별도 처리 개선
                              A002 = dbo.FN_GET_LOOKUP_VALUE('SCP_PLN_PROD_PLAN_TARGET_V','WarrantyPlant')
  * 2024-10-30   vadabi3      NERP - 개발 DB 적용
  **********************************************************************************************************************
  SELECT * 
  FROM SCP_PLN_PROD_PLAN_TARGET_V
  WHERE  DIVISION_ID = '40'
  AND PLAN_START_YYYYMMDD = '20240415'
  AND PLAN_TYPE = 'MA'
  AND ITEM_ID = 'MACE130705A4-E01'

 SELECT * 
  FROM NERP_SCP_PLN_PROD_PLAN_TARGET_V
  WHERE  DIVISION_ID = '40'
  AND PLAN_START_YYYYMMDD = '20240415'
  AND PLAN_TYPE = 'MA'
  AND ITEM_ID = 'MACE130705A4-E01'
  
  */
          SELECT    
                   P.DIVISION_ID            AS DIVISION_ID
                 , P.PLAN_START_YYYYMMDD    AS PLAN_START_YYYYMMDD
                 , P.PLAN_TYPE              AS PLAN_TYPE
                 , P.SEQ                    AS SEQ
				 -- 20230227 PJ20230691I  Line 제외 대비 Target ID 에서 Line ID 제외, 기존 ID 는 TARGET_ID_LINE으로 Name으로 변경
       --          , P.DIVISION_ID + '^' + P.SITE_ID + '^' + CONVERT(VARCHAR,P.END_TIME,112) + '^' + P.ITEM_ID + '^' + '-'+ '^' + P.OPERATION_ID+ '^' +  PP.FCST_TYPE+ '^'
       --            + (CASE WHEN S.SITE_ID ='A002' THEN  PP.DOM_EXP  ELSE 'D' END ) + '^'
				   --+ (CASE WHEN eng_demand_id = 'UNPEGGING' THEN '-'
       --                    ELSE SUBSTRING(eng_demand_id, 1, CHARINDEX('::', eng_demand_id)-1)
       --               END)
       --                                     AS TARGET_ID

                 , P.DIVISION_ID + '^' + P.SITE_ID + '^' + CONVERT(VARCHAR,P.END_TIME,112) + '^' + P.ITEM_ID + '^' + P.RESOURCE_ID+ '^' + P.OPERATION_ID+ '^' +  PP.FCST_TYPE+ '^'
                   + (CASE WHEN S.SITE_ID = dbo.FN_GET_LOOKUP_VALUE('SCP_PLN_PROD_PLAN_TARGET_V','WarrantyPlant') THEN  PP.DOM_EXP  ELSE 'D' END ) + '^'
				   + (CASE WHEN eng_demand_id = 'UNPEGGING' THEN '-'
                           ELSE SUBSTRING(eng_demand_id, 1, CHARINDEX('::', eng_demand_id)-1)
                      END)
                                            AS TARGET_ID -- TARGET_ID_LINE
                -- , (CASE WHEN ( P.DIVISION_ID='40' AND P.OPERATION_GROUP ='P' ) THEN [dbo].[FN_GET_MOBILE_PACKER_ITEM_ID]( P.DIVISION_ID, P.SITE_ID,P.ITEM_ID )
                --         ELSE  P.ITEM_ID
                --    END )                   AS ITEM_ID
                 , P.ITEM_ID                AS ITEM_ID
                 , [dbo].[FN_GET_ITEM_NICKNAME]( P.DIVISION_ID, P.ITEM_ID )
                                            AS NICK_NAME
				 --, ( SELECT TOP 1 ISNULL(NICK_NAME,'')
					-- FROM DBO.SCM_MST_ITEM_SN WITH(NOLOCK)
					-- WHERE ITEM_ID             = P.ITEM_ID ) AS NICK_NAME
                 , P.OPERATION_GROUP        AS OPERATION_GROUP
                 , P.OPERATION_ID           AS OPERATION_ID
                 , P.SITE_ID                AS SITE_ID
                 , ( SELECT TOP 1 ( CASE OSP_YN  WHEN 'Y' THEN S.LOGISTIC_PLANT_ID
                                         ELSE S.PLANT_ID 
                              END ) 
                       FROM SCM_MST_SITE S WITH(NOLOCK)
                      WHERE 1=1 --S.DIVISION_ID = P.DIVISION_ID --EE사업부인경우를 고려하여 COMMENT처리 2018.08.08
                        AND S.SCM_SITE_ID = P.SITE_ID
                    )                       AS PLANT_ID
                 , ( SELECT basis_yyyymmdd
		                   FROM scm_sys_calendar_m cm WITH(NOLOCK)
		                  WHERE iso_yyyyww IN (SELECT iso_yyyyww
                                             FROM scm_sys_calendar_m WITH(NOLOCK)
                                            WHERE basis_yyyymmdd = CONVERT(VARCHAR,P.END_TIME,112)
                                            )
		                    AND dayofweek = 'MON'
		                )                       AS PROD_WEEK
                 -- 20190903 [CSR ID 4074962] SCP생산계획 송신(to MRP) 버켓단위 변경 요청 건 : Partial 기준 Week 시작일자 정보 추가
                 , ( SELECT basis_start_date
		               FROM scm_sys_calendar_m cm WITH(NOLOCK)
		              WHERE basis_yyyymmdd = CONVERT(VARCHAR,P.END_TIME,112)
		                )                       AS PROD_PARTIAL_WEEK
                 , CONVERT(VARCHAR,P.END_TIME,112) 
                                            AS YYYYMMDD
                 , ROUND(SUM(ISNULL(PP.ALLOCATION_QTY,0) * (P.OPERATION_QTY / P.COMPLETE_QTY )),4)  --MRP 소숫점전달  
                                            AS PROD_IN_QTY 
                /* , ROUND(SUM(ISNULL(PP.ALLOCATION_QTY,0) / [dbo].[FN_GET_ITEM_LINE_YIELD](P.DIVISION_ID, P.SITE_ID,P.ITEM_ID,P.RESOURCE_ID,P.OPERATION_ID,CONVERT(VARCHAR,P.END_TIME,112))),0)
                                            AS PROD_IN_QTY */
                 , ROUND(SUM(ISNULL(PP.ALLOCATION_QTY,0)),0)  
                                            AS PROD_QTY
                 , ROUND(SUM(ISNULL(PP.ALLOCATION_QTY,0)),4)  
                                            AS PROD_QTY_MRP -- MRP : 정수가 아닌 원래 값으로 전달
                 , PP.FCST_TYPE             AS FCST_TYPE
                 , P.RESOURCE_ID            AS PRODUCTION_LINE
                 , MAX(ISNULL(PP.ENG_DEMAND_PRIORITY,'')) 
                                            AS PRIORITY
                -- , PP.DOM_EXP               AS DOM_EXP
                 , ( CASE WHEN S.SITE_ID = dbo.FN_GET_LOOKUP_VALUE('SCP_PLN_PROD_PLAN_TARGET_V','WarrantyPlant') THEN  PP.DOM_EXP
                          ELSE 'D'
                     END )                  AS DOM_EXP
                 , P.ORIGIN_DIVISION_ID     AS ORIGIN_DIVISION_ID
                 , 'SCP'                    AS CREATE_USER_ID
                 , GETDATE()                AS CREATE_DATE
                 , 'SCP'                    AS MODIFY_USER_ID
                 , GETDATE()                AS MODIFY_DATE
				 -- 20211115 PJ20214907 : MEB : Pegging된 Demand Item 추가
				 , CASE WHEN eng_demand_id = 'UNPEGGING' THEN '-'
                        ELSE SUBSTRING(eng_demand_id, 1, CHARINDEX('::', eng_demand_id)-1)
                   END                      AS DEMAND_ITEM
               FROM  dbo.SCP_PLN_PRODUCTION_PLAN         P  WITH(NOLOCK)
					 INNER JOIN SCM_MST_DIVISION		 D WITH(NOLOCK)		-- PJ20230691R HM JV 가상 사업부 추가 대응
							 ON D.DIVISION_ID = P.DIVISION_ID 
							AND D.VALID_YN	  = 'Y'
               LEFT HASH JOIN dbo.SCP_PLN_PRODUCTION_PLAN_PEGGING PP  WITH(NOLOCK)
                      ON P.DIVISION_ID = PP.DIVISION_ID
                     AND P.PLAN_START_YYYYMMDD = PP.PLAN_START_YYYYMMDD
                     AND P.PLAN_TYPE           = PP.PLAN_TYPE
                     AND P.SEQ                 = PP.SEQ
                     AND P.WORK_ORDER_ID       = PP.WORK_ORDER_ID
               LEFT JOIN DBO.SCM_MST_SITE     S WITH(NOLOCK)
                      ON P.DIVISION_ID         = S.DIVISION_ID
                     AND P.SITE_ID             = S.SCM_SITE_ID                     
              WHERE 1=1
             --   AND P.DIVISION_ID              = '81'
             --   AND P.PLAN_START_YYYYMMDD      = '20180319'
             --   AND P.PLAN_TYPE                = 'PR'
             --   AND P.SEQ                      = 11
                --AND P.OPERATION_ID IN ('E2000','A3000','A9000','P5500','P9500')
                AND ( LEFT(P.operation_id,5) IN (--LOOKUP_TYPE 'SCP_PLAN_OPERATION' 에 정의된 공정만 조회
                                                  SELECT segment1 AS OPERATION_ID
                                                    FROM scm_adm_lookup_master_detail WITH(NOLOCK)   
                                                   WHERE lookup_type = 'SCP_PLAN_OPERATION' )
												   
                     -- PJ20216891 (sclee.lee)	
                     -- ISUZU item
                     OR (
                         P.operation_id = 'P5000'
                         AND EXISTS (
                                     SELECT 1
                                     FROM   dbo.SCM_MST_FINAL_ITEM_V A WITH(NOLOCK)
										INNER JOIN dbo.SCP_MST_FINAL_ITEM_V B WITH(NOLOCK) 
										ON A.ITEM_ID = B.ITEM_ID
                                     WHERE  A.ITEM_ID = P.ITEM_ID
                                       AND A.IS_YN = 'Y'									
                                    )
                        )
												   
                     OR

					 -- 2020.10.28   KSW          PJ20202001 LG화학 전지. 공급 대응력 향상을 위한 SCM 관리 체계 개선 : RACK biz. 대응 - start
					 -- old version
                     --P.operation_id        IN (--외주PACKER의 업체코드
					 (CASE WHEN CHARINDEX('_', P.operation_id) > 0 THEN (SUBSTRING(P.operation_id, 1, DBO.FN_CHARINDEX_REV(P.operation_id, '_', 0)-1)) ELSE P.operation_id END) IN (--외주PACKER의 업체코드
					 -- 2020.10.28   KSW          PJ20202001 LG화학 전지. 공급 대응력 향상을 위한 SCM 관리 체계 개선 : RACK biz. 대응 - end

                                                 SELECT PLANT_ID  AS OPERATION_ID
                                                   FROM SCM_MST_SITE WITH(NOLOCK)      
                                                  WHERE 1=1
                                                    AND SITE_TYPE   = 'PLANT'
                                                    AND OSP_YN      = 'Y'  
                                               ) 
                   )
                AND left(P.operation_id,5) NOT IN ( 'F1000','F6000') --활성화,특성제외 
                AND P.COMPLETE_QTY >= 1.0
				AND (D.ATTRIBUTE3 != 'EE'								 -- PJ20230691R HM JV 가상 사업부 추가 대응
					 OR 												 -- PJ20230691R HM JV 가상 사업부 추가 대응
					 (D.ATTRIBUTE3 = 'EE' AND P.OPERATION_GROUP = 'E'))  -- PJ20230691R HM JV 가상 사업부 추가 대응
                --AND ( ( P.DIVISION_ID <> 'EE' ) OR ( P.DIVISION_ID = 'EE' AND P.OPERATION_GROUP <> 'A' )) 
                -- HM JV 대응 AND ( ( P.DIVISION_ID IN ('81','82','40','81_UC') )                    -- 20220323 PJ20216891 GM JV 추가
                -- HM JV 대응    OR ( P.DIVISION_ID IN ('EE', 'EE_UC') AND P.OPERATION_GROUP = 'E' ) -- 20220323 PJ20216891 GM JV 추가
                -- HM JV 대응     ) 
              GROUP BY P.DIVISION_ID
                      ,P.PLAN_START_YYYYMMDD
                      ,P.PLAN_TYPE
                      ,P.SEQ
                      ,P.ITEM_ID
                      ,P.OPERATION_GROUP
                      ,P.OPERATION_ID
                      ,P.SITE_ID
                      ,CONVERT(VARCHAR,P.END_TIME,112)
                      ,PP.FCST_TYPE       
                      ,P.RESOURCE_ID      
                      ,P.DIVISION_ID      
                      , ( CASE WHEN S.SITE_ID = dbo.FN_GET_LOOKUP_VALUE('SCP_PLN_PROD_PLAN_TARGET_V','WarrantyPlant') THEN  PP.DOM_EXP  ELSE 'D' END )  
                      ,P.ORIGIN_DIVISION_ID    
				      -- 20211115 PJ20214907 : MEB : Pegging된 Demand Item 추가
				      , CASE WHEN eng_demand_id = 'UNPEGGING' THEN '-'
                             ELSE SUBSTRING(eng_demand_id, 1, CHARINDEX('::', eng_demand_id)-1)
                        END
             HAVING ROUND(SUM(ISNULL(PP.ALLOCATION_QTY,0)),0)>= 1
              ;

