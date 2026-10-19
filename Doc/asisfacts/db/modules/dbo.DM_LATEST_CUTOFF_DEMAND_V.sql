
CREATE VIEW [dbo].[DM_LATEST_CUTOFF_DEMAND_V]
AS
/*==============================================================================================================================
 * PROJECT       : LGES SCM
 * VIEW NAME     : DM_LATEST_CUTOFF_DEMAND_V_20240418
 * DESCRIPTION   : 최신 확정 기준 Mkt Fcst 및 RTF 등 DM 계획정보를 조회
 * PROGRAM HISTORY
 *==============================================================================================================================
 *  DATE        IN CHARGE			DESCRIPTION
 *==============================================================================================================================
 * 2024.04.01	Philsu Park         Initial Release.
 * 2024.04.15	Philsu Park         KEEP Table 포함 View 확장. 
									[E20240405-002034]_DM 데이터 AWS 전송 기준 변경 건 주차별 최신CUTOFF정보 표출
 * 2024.05.17	Philsu Park         주차별 최신 버전 -> 주차 내 모든 버전 조회.
 * 2024.05.17	Philsu Park         [E20250114-000438]_View table 컬럼 추가 요청의 건(Project_code)
 * 2025.03.11	JSSBAE		        [E20250305-000530]_View table 컬럼 추가 요청의 건(plant_site, sold_to_code 칼럼 추가)
==============================================================================================================================*/
    --DQ106 : MKT FCST Waterfall 버전별 주차별 데이터 추출
    SELECT FINAL_DATA.DIVISION_ID		AS DIVISION_ID
         , FINAL_DATA.VERSION_NO		AS VERSION_NO     
         , FINAL_DATA.CUTOFF_YYYYMMDD   AS PLAN_DATE --[E20240227-000623]
         , FINAL_DT.CALENDAR_YYYY       AS PLAN_YYYY --[E20240227-000623]
         , FINAL_DT.CALENDAR_MONTH      AS PLAN_MM   --[E20240227-000623]
         , FINAL_DT.CALENDAR_DAY        AS PLAN_DD   --[E20240227-000623]
         , FINAL_DT.ISO_WEEK            AS PLAN_WEEK  --[E20240227-000623]
         , FINAL_DATA.MODEL_CODE		AS MODEL_CODE
         , FINAL_DATA.END_CUSTOMER		AS END_CUSTOMER
         , FINAL_DATA.SOLDTO_CUSTOMER	AS SOLDTO_CUSTOMER
         , FINAL_DATA.SCM_SITE_ID       AS SCM_SITE_ID --[E20240227-000623]
         , FINAL_DATA.PRODUCT_LEVEL1	AS PRODUCT_LEVEL1
         , FINAL_DATA.ITEM_ID			AS ITEM_ID
         , FINAL_DATA.NICK_NAME			AS NICK_NAME --[E20240227-000623]
         , FINAL_DATA.FCST_TYPE         AS FCST_TYPE --[E20240227-000623]
         , FINAL_DATA.INCOTERMS         AS INCOTERMS --[E20240227-000623]
         , FINAL_DATA.YYYYMM			AS YYYYMM
         , FINAL_DATA.ISO_YYYYWW		AS ISO_YYYYWW
         , FINAL_DATA.MKT_QTY			AS MKT_QTY
         , FINAL_DATA.RTF_QTY			AS RTF_QTY
         , CASE WHEN FINAL_DATA.YYYYMM >= '202301' THEN  FINAL_DATA.CUST_FCST_QTY	ELSE 0 END	AS CUST_FCST_QTY
		 , FINAL_DATA.PROJECT_CODE		AS PROJECT_CODE --[E20250114-000438]_View table 컬럼 추가 요청의 건
		 , FINAL_DATA.PLANT_SITE_ID		AS PLANT_SITE_ID	--[E20250305-000530]_plant_site 컬럼 추가
		 , FINAL_DATA.SOLDTO_CODE		AS SOLD_TO_CODE		--[E20250305-000530]_sold_to_code  컬럼 추가
    FROM (
        SELECT ALL_DATA.*  	    		
            , TB.END_CUSTOMER
            , TB.SOLDTO_CUSTOMER
            , TB.VMI_YN
            , TC.BIZ_TYPE_NAME   AS [BIZ.TYPE]
            , TC.PROJECT_NAME
            , TC.PROJECT_STATUS
            , TC.PROJECT_OWNER	 AS PROJECT_OWNER
            , TD.OWNER_NAME		 AS OWNER
            , TD.CELL_PER_CAR	 AS CELL_PER_CAR
            , TD.CELL_PER_MODULE AS CELL_PER_MODULE
            , CASE WHEN TD.CELL_PER_MODULE  <> 0 THEN TD.CELL_PER_CAR / TD.CELL_PER_MODULE ELSE 0 END AS MODULE_PER_CAR	
            , TD.SALES_COMPANY
            , TD.ATTRIBUTE8		 AS KWH_CELL
            , CASE WHEN ALL_DATA.DIVISION_ID LIKE '81%' AND TD.CELL_PER_MODULE > 0 AND ISNULL(TD.ATTRIBUTE8, '') <> '' 
                    THEN CONVERT(FLOAT,(TD.CELL_PER_MODULE * TD.ATTRIBUTE8)) 
                ELSE NULL END AS KWH_MODULE
            , CASE WHEN ALL_DATA.DIVISION_ID LIKE '81%' AND TD.CELL_PER_CAR > 0 AND ISNULL(TD.ATTRIBUTE8, '') <> '' 
                    THEN CONVERT(FLOAT,(TD.CELL_PER_CAR * TD.ATTRIBUTE8)) 
                ELSE NULL END AS KWH_PACK
            , J.COUNTRY_NAME     AS COUNTRY
            , H.CITY_NAME		 AS CITY
            , L.SOLDTO_CODE      AS SOLDTO_CODE
            , CASE WHEN SUBSTRING(ALL_DATA.DIVISION_ID, 1,2) = '81' OR ALL_DATA.DIVISION_ID = '82' THEN SCP_INFO.GROUP_CODE6
                ELSE SCP_INFO.CELL_TYPE_GROUP_NAME END PRODUCT_LEVEL1
            , LEFT(ALL_DATA.ITEM_ID, 12) AS MODEL_CODE  /* SUFFIX 제거 */
            , MST_ITEM_SN.NICK_NAME  --[E20240227-000623]
        FROM (
            SELECT DIVISION_ID,VERSION_NO, SCM_SITE_ID, PROJECT_CODE, ITEM_ID, INCOTERMS, DOM_EXP, FCST_TYPE, SUBSTRING(YYYYMMDD, 1,6) AS YYYYMM, ISO_YYYYWW, WEEK_NAME
				, PLANT_SITE_ID --[E20250305-000530]_plant_site 컬럼 추가
                --, MEASURE
                , SUM(MKT_FCST_QTY)	AS MKT_QTY
                , SUM(RTF_QTY)		AS RTF_QTY
                , SUM(CUST_FCST_QTY)	AS CUST_FCST_QTY
                , MAX(CUTOFF_YYYYMMDD) AS CUTOFF_YYYYMMDD --0226
            FROM (
                SELECT TA.DIVISION_ID, TA.SCM_SITE_ID, TA.PROJECT_CODE, TA.ITEM_ID, TA.INCOTERMS, TA.DOM_EXP, TA.FCST_TYPE, TA.MEASURE, TA.YYYYMMDD, TA.QTY , VERSION_NO	
					, TA.PLANT_SITE_ID --[E20250305-000530]_plant_site 컬럼 추가
                    ,CALENDAR.ISO_YYYYWW
                    ,CALENDAR.[ISO_WEEK]
                    ,CALENDAR.WEEK_NAME					
                    ,MKT_FCST_QTY
                    ,RTF_QTY
                    ,CUST_FCST_QTY 
                    ,CUTOFF_YYYYMMDD --0226
                --FROM #RAW_DATA  TA
                FROM 
                (
        -----------------------------------------------
                    SELECT TA.DIVISION_ID, TA.VERSION_NO,TA.SCM_SITE_ID,TA.PROJECT_CODE, TA.ITEM_ID, TA.DOM_EXP, TA.FCST_TYPE, TA.INCOTERMS, TA.PLANT_SITE_ID	
                            , TA.YYYYMMDD	
                            , TA.MEASURE
                            , SUM(QTY) AS QTY
                            , SUM(CASE WHEN TA.MEASURE = 'MKT_FCST'	  AND TA.GUBUN = 'P'  THEN TA.QTY ELSE 0 END) 
                            + SUM(CASE WHEN TA.MEASURE = 'RTF_SYS_RP' AND TA.GUBUN = 'R'  THEN TA.QTY ELSE 0 END) AS MKT_FCST_QTY /* (R+P) */
    
                            , SUM(CASE WHEN TA.MEASURE = 'RTF_SYS_RP'		THEN TA.QTY ELSE 0 END) AS RTF_QTY	 
                            , SUM(CASE WHEN TA.MEASURE = 'CUST_FCST_EDI'	THEN TA.QTY ELSE 0 END) AS CUST_FCST_QTY	 
                            , MAX(CUTOFF_YYYYMMDD) AS CUTOFF_YYYYMMDD --0226
                    FROM (
                        SELECT 'P' AS GUBUN
                            , A.DIVISION_ID,A.VERSION_NO,CUTOFF_TYPE,CUTOFF_YYYYMMDD,PROJECT_CODE,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE,INCOTERMS
                            , MEASURE,PLANT_SITE_ID ,A.YYYYMMDD,QTY,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4,ATTRIBUTE5,ATTRIBUTE6,ATTRIBUTE7
                            , ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10
                            , CREATED_BY,CREATION_DATE,LAST_UPDATED_BY,LAST_UPDATE_DATE
                        --FROM DM_PLN_MKT_FCST_C_KEEP A WITH (NOLOCK)	
                        FROM DM_PLN_MKT_FCST_C A WITH (NOLOCK)	
                        CROSS APPLY ( select DIVISION_ID
                                            , MAX(YYYYMMDD) AS YYYYMMDD
                                            , VERSION_NO  AS VERSION_NO  --, VERSION_TYPE, YYYYMMDD 
                                            , VERSION_TYPE
                                            , MAX(CL.BASIS_START_DATE) AS START_YYYYMMDD
                                            , MAX(CONVERT(CHAR(8), DATEADD(DD, -7-1, DBO.FN_NEXT_DAY(CONVERT(CHAR(8), DATEADD(WW, 52, CL.BASIS_START_DATE),112), 'MON')), 112)) AS END_YYYYMMDD
                                             , MAX(CONVERT(CHAR(8), DATEADD(DD, -7*52, DBO.FN_NEXT_DAY(CL.BASIS_START_DATE, 'MON')), 112)) AS RESULT_START_YYYYMMDD
                                             , MAX(CONVERT(CHAR(8), DATEADD(DD, -7-1 , DBO.FN_NEXT_DAY(CL.BASIS_START_DATE, 'MON')), 112)) AS RESULT_END_YYYYMMDD
                                            -- , MAX(CONVERT(CHAR(8), DATEADD(DD, -7, DBO.FN_NEXT_DAY(YYYYMMDD, 'MON')), 112)) AS START_YYYYMMDD		 
                                            -- , MAX(CONVERT(CHAR(8), DATEADD(DD, -7-1, DBO.FN_NEXT_DAY(CONVERT(CHAR(8), DATEADD(WW, 52, YYYYMMDD),112), 'MON')), 112)) AS END_YYYYMMDD
                                            -- , MAX(CONVERT(CHAR(8), DATEADD(DD, -7*52, DBO.FN_NEXT_DAY(YYYYMMDD, 'MON')), 112)) AS RESULT_START_YYYYMMDD
                                            -- , MAX(CONVERT(CHAR(8), DATEADD(DD, -7-1 , DBO.FN_NEXT_DAY(YYYYMMDD, 'MON')), 112)) AS RESULT_END_YYYYMMDD	
                                        from DM_MST_VERSION VR WITH(NOLOCK)
                                       inner join SCM_SYS_CALENDAR_M CL WITH(NOLOCK)
                                          on VR.YYYYMMDD = CL.BASIS_YYYYMMDD
                                       where 1=1 
                                        -- AND A.DIVISION_ID =  VR.DIVISION_ID --'81'				
                                        -- AND A.VERSION_NO  =  VR.VERSION_NO		
                                        -- AND A.CUTOFF_TYPE = VR.VERSION_TYPE
                                        -- AND A.CUTOFF_YYYYMMDD = VR.YYYYMMDD
                                        -- and A.YYYYMMDD >= CONVERT(CHAR(8), DATEADD(DD, -7, DBO.FN_NEXT_DAY(YYYYMMDD, 'MON')), 112)
                                        -- and A.YYYYMMDD <= CONVERT(CHAR(8), DATEADD(DD, -7-1, DBO.FN_NEXT_DAY(CONVERT(CHAR(8), DATEADD(WW, 52, YYYYMMDD),112), 'MON')), 112)
                                        and VR.VERSION_TYPE = 'MF_W'
                                        group by VR.DIVISION_ID, VR.VERSION_NO, CL.ISO_YYYYWW, VR.VERSION_TYPE
                                        --and A.YYYYMMDD  >= VR.START
                                      ) B
                        WHERE 1=1
                        AND A.DIVISION_ID =  B.DIVISION_ID --'81'				
                        AND A.VERSION_NO  =  B.VERSION_NO		
                        AND A.CUTOFF_TYPE = B.VERSION_TYPE
                        AND A.CUTOFF_YYYYMMDD = B.YYYYMMDD
                        /* 버전별 구간설정  */
                        --AND A.YYYYMMDD   >= @PARAM_FROM_DATE AND A.YYYYMMDD <= @PARAM_TO_DATE 
                        AND A.YYYYMMDD	   >= B.START_YYYYMMDD AND A.YYYYMMDD <= B.END_YYYYMMDD 
                        --AND A.YYYYMMDD     >= CONVERT(CHAR(8), DATEADD(DD, -7, DBO.FN_NEXT_DAY(SUBSTRING(B.VERSION_NO,6,8), 'MON')), 112)
                        AND A.QTY <> 0
                        AND MEASURE IN ('MKT_FCST','RTF_SYS_RP','CUST_FCST_EDI')
                        --and A.YYYYMMDD like '202308%'
                        UNION ALL
                        SELECT 'P' AS GUBUN
                            , A.DIVISION_ID,A.VERSION_NO,CUTOFF_TYPE,CUTOFF_YYYYMMDD,PROJECT_CODE,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE,INCOTERMS
                            , MEASURE,PLANT_SITE_ID ,A.YYYYMMDD,QTY,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4,ATTRIBUTE5,ATTRIBUTE6,ATTRIBUTE7
                            , ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10
                            , CREATED_BY,CREATION_DATE,LAST_UPDATED_BY,LAST_UPDATE_DATE
                        --FROM DM_PLN_MKT_FCST_C_KEEP A WITH (NOLOCK)	
                        FROM DM_PLN_MKT_FCST_C_KEEP A WITH (NOLOCK)	
                        CROSS APPLY ( select DIVISION_ID
                                            , MAX(YYYYMMDD) AS YYYYMMDD
                                            , VERSION_NO  AS VERSION_NO  --, VERSION_TYPE, YYYYMMDD 
                                            , VERSION_TYPE
                                            , MAX(CL.BASIS_START_DATE) AS START_YYYYMMDD
                                            , MAX(CONVERT(CHAR(8), DATEADD(DD, -7-1, DBO.FN_NEXT_DAY(CONVERT(CHAR(8), DATEADD(WW, 52, CL.BASIS_START_DATE),112), 'MON')), 112)) AS END_YYYYMMDD
                                             , MAX(CONVERT(CHAR(8), DATEADD(DD, -7*52, DBO.FN_NEXT_DAY(CL.BASIS_START_DATE, 'MON')), 112)) AS RESULT_START_YYYYMMDD
                                             , MAX(CONVERT(CHAR(8), DATEADD(DD, -7-1 , DBO.FN_NEXT_DAY(CL.BASIS_START_DATE, 'MON')), 112)) AS RESULT_END_YYYYMMDD
                                            -- , MAX(CONVERT(CHAR(8), DATEADD(DD, -7, DBO.FN_NEXT_DAY(YYYYMMDD, 'MON')), 112)) AS START_YYYYMMDD		 
                                            -- , MAX(CONVERT(CHAR(8), DATEADD(DD, -7-1, DBO.FN_NEXT_DAY(CONVERT(CHAR(8), DATEADD(WW, 52, YYYYMMDD),112), 'MON')), 112)) AS END_YYYYMMDD
                                            -- , MAX(CONVERT(CHAR(8), DATEADD(DD, -7*52, DBO.FN_NEXT_DAY(YYYYMMDD, 'MON')), 112)) AS RESULT_START_YYYYMMDD
                                            -- , MAX(CONVERT(CHAR(8), DATEADD(DD, -7-1 , DBO.FN_NEXT_DAY(YYYYMMDD, 'MON')), 112)) AS RESULT_END_YYYYMMDD	
                                        from DM_MST_VERSION VR WITH(NOLOCK)
                                       inner join SCM_SYS_CALENDAR_M CL WITH(NOLOCK)
                                          on VR.YYYYMMDD = CL.BASIS_YYYYMMDD
                                       where 1=1 
                                        -- AND A.DIVISION_ID =  VR.DIVISION_ID --'81'				
                                        -- AND A.VERSION_NO  =  VR.VERSION_NO		
                                        -- AND A.CUTOFF_TYPE = VR.VERSION_TYPE
                                        -- AND A.CUTOFF_YYYYMMDD = VR.YYYYMMDD
                                        -- and A.YYYYMMDD >= CONVERT(CHAR(8), DATEADD(DD, -7, DBO.FN_NEXT_DAY(YYYYMMDD, 'MON')), 112)
                                        -- and A.YYYYMMDD <= CONVERT(CHAR(8), DATEADD(DD, -7-1, DBO.FN_NEXT_DAY(CONVERT(CHAR(8), DATEADD(WW, 52, YYYYMMDD),112), 'MON')), 112)
                                        and VR.VERSION_TYPE = 'MF_W'
                                        group by VR.DIVISION_ID, VR.VERSION_NO, CL.ISO_YYYYWW, VR.VERSION_TYPE
                                        --and A.YYYYMMDD  >= VR.START
                                      ) B
                        WHERE 1=1
                        AND A.DIVISION_ID =  B.DIVISION_ID --'81'				
                        AND A.VERSION_NO  =  B.VERSION_NO		
                        AND A.CUTOFF_TYPE = B.VERSION_TYPE
                        AND A.CUTOFF_YYYYMMDD = B.YYYYMMDD
                        /* 버전별 구간설정  */
                        --AND A.YYYYMMDD   >= @PARAM_FROM_DATE AND A.YYYYMMDD <= @PARAM_TO_DATE 
                        AND A.YYYYMMDD	   >= B.START_YYYYMMDD AND A.YYYYMMDD <= B.END_YYYYMMDD 
                        --AND A.YYYYMMDD     >= CONVERT(CHAR(8), DATEADD(DD, -7, DBO.FN_NEXT_DAY(SUBSTRING(B.VERSION_NO,6,8), 'MON')), 112)
                        AND A.QTY <> 0
                        AND MEASURE IN ('MKT_FCST','RTF_SYS_RP','CUST_FCST_EDI')
                        /* KEEP 은 보관주기 초과된 대상 가져오는거라 무의미.
                        UNION ALL
                        SELECT 'P' AS GUBUN
                            , A.DIVISION_ID,A.VERSION_NO,CUTOFF_TYPE,CUTOFF_YYYYMMDD,PROJECT_CODE,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE,INCOTERMS
                            , MEASURE,PLANT_SITE_ID ,A.YYYYMMDD,QTY,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4,ATTRIBUTE5,ATTRIBUTE6,ATTRIBUTE7
                            , ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10
                            , CREATED_BY,CREATION_DATE,LAST_UPDATED_BY,LAST_UPDATE_DATE
                        FROM DM_PLN_MKT_FCST_C_KEEP A WITH (NOLOCK)						
                        , TEMP_VERSION B --#TEMP_VERSION
                        WHERE 1=1
                        AND A.DIVISION_ID =  B.VER
                        AND A.VERSION_NO  =  B.VERSION_NO		
                        AND A.VERSION_NO  =  @PARAM_VERSION_NO --20240207★필수
                        AND A.CUTOFF_TYPE = 'MF_W'
                        AND A.CUTOFF_YYYYMMDD = B.YYYYMMDD
                        /* 버전별 구간설정  */					
                        AND A.YYYYMMDD	   >= B.START_YYYYMMDD AND A.YYYYMMDD <= B.END_YYYYMMDD 
                        AND A.YYYYMMDD     >= CONVERT(CHAR(8), DATEADD(DD, -7, DBO.FN_NEXT_DAY(SUBSTRING(B.VERSION_NO,6,8), 'MON')), 112)
                        AND A.QTY <> 0
                        AND MEASURE IN ('MKT_FCST','RTF_SYS_RP','CUST_FCST_EDI')*/
                        UNION ALL
                        SELECT 'R' AS GUBUN
                            , A.DIVISION_ID,A.VERSION_NO,CUTOFF_TYPE,CUTOFF_YYYYMMDD,PROJECT_CODE,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE,INCOTERMS
                            , MEASURE,PLANT_SITE_ID ,A.YYYYMMDD,QTY,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4,ATTRIBUTE5,ATTRIBUTE6,ATTRIBUTE7
                            , ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10
                            , CREATED_BY,CREATION_DATE,LAST_UPDATED_BY,LAST_UPDATE_DATE
                        --FROM DM_PLN_MKT_FCST_RESULT_C_KEEP A WITH (NOLOCK)
                        FROM DM_PLN_MKT_FCST_RESULT_C A WITH (NOLOCK)
                        CROSS APPLY ( select DIVISION_ID
                                            , MAX(YYYYMMDD) AS YYYYMMDD
                                            , VR.VERSION_NO  AS VERSION_NO  --, VERSION_TYPE, YYYYMMDD 
                                            , VERSION_TYPE
                                            , MAX(CL.BASIS_START_DATE) AS START_YYYYMMDD
                                            , MAX(CONVERT(CHAR(8), DATEADD(DD, -7-1, DBO.FN_NEXT_DAY(CONVERT(CHAR(8), DATEADD(WW, 52, CL.BASIS_START_DATE),112), 'MON')), 112)) AS END_YYYYMMDD
                                             , MAX(CONVERT(CHAR(8), DATEADD(DD, -7*52, DBO.FN_NEXT_DAY(CL.BASIS_START_DATE, 'MON')), 112)) AS RESULT_START_YYYYMMDD
                                             , MAX(CONVERT(CHAR(8), DATEADD(DD, -7-1 , DBO.FN_NEXT_DAY(CL.BASIS_START_DATE, 'MON')), 112)) AS RESULT_END_YYYYMMDD
                                            -- , MAX(CONVERT(CHAR(8), DATEADD(DD, -7, DBO.FN_NEXT_DAY(YYYYMMDD, 'MON')), 112)) AS START_YYYYMMDD		 
                                            -- , MAX(CONVERT(CHAR(8), DATEADD(DD, -7-1, DBO.FN_NEXT_DAY(CONVERT(CHAR(8), DATEADD(WW, 52, YYYYMMDD),112), 'MON')), 112)) AS END_YYYYMMDD
                                            -- , MAX(CONVERT(CHAR(8), DATEADD(DD, -7*52, DBO.FN_NEXT_DAY(YYYYMMDD, 'MON')), 112)) AS RESULT_START_YYYYMMDD
                                            -- , MAX(CONVERT(CHAR(8), DATEADD(DD, -7-1 , DBO.FN_NEXT_DAY(YYYYMMDD, 'MON')), 112)) AS RESULT_END_YYYYMMDD	
                                        from DM_MST_VERSION VR WITH(NOLOCK)
                                       inner join SCM_SYS_CALENDAR_M CL WITH(NOLOCK)
                                          on VR.YYYYMMDD = CL.BASIS_YYYYMMDD
                                       where 1=1 
                                        -- AND A.DIVISION_ID =  VR.DIVISION_ID --'81'				
                                        -- AND A.VERSION_NO  =  VR.VERSION_NO		
                                        -- AND A.CUTOFF_TYPE = VR.VERSION_TYPE
                                        -- AND A.CUTOFF_YYYYMMDD = VR.YYYYMMDD
                                        -- and A.YYYYMMDD >= CONVERT(CHAR(8), DATEADD(DD, -7, DBO.FN_NEXT_DAY(YYYYMMDD, 'MON')), 112)
                                        -- and A.YYYYMMDD <= CONVERT(CHAR(8), DATEADD(DD, -7-1, DBO.FN_NEXT_DAY(CONVERT(CHAR(8), DATEADD(WW, 52, YYYYMMDD),112), 'MON')), 112)
                                        and VR.VERSION_TYPE = 'MF_W'
                                        group by VR.DIVISION_ID, VR.VERSION_NO, CL.ISO_YYYYWW, VR.VERSION_TYPE
                                        --and A.YYYYMMDD  >= VR.START
                                      ) B
                        WHERE 1=1
                        AND A.DIVISION_ID = B.DIVISION_ID
                        AND A.VERSION_NO  =  B.VERSION_NO
                        AND A.CUTOFF_TYPE = B.VERSION_TYPE
                        AND A.CUTOFF_YYYYMMDD = B.YYYYMMDD
                        /* 버전별 구간설정  */						
                        --AND A.YYYYMMDD   >= @PARAM_FROM_DATE --★실적구간처리일자★
                        AND A.YYYYMMDD   >= B.RESULT_START_YYYYMMDD --★실적구간처리일자★
                        AND A.YYYYMMDD   <  B.START_YYYYMMDD -- 계획 전날까지.
                        AND QTY <> 0
                        AND MEASURE IN ('MKT_FCST','RTF_SYS_RP','CUST_FCST_EDI')
                        UNION ALL
                        SELECT 'R' AS GUBUN
                            , A.DIVISION_ID,A.VERSION_NO,CUTOFF_TYPE,CUTOFF_YYYYMMDD,PROJECT_CODE,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE,INCOTERMS
                            , MEASURE,PLANT_SITE_ID ,A.YYYYMMDD,QTY,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4,ATTRIBUTE5,ATTRIBUTE6,ATTRIBUTE7
                            , ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10
                            , CREATED_BY,CREATION_DATE,LAST_UPDATED_BY,LAST_UPDATE_DATE
                        --FROM DM_PLN_MKT_FCST_RESULT_C_KEEP A WITH (NOLOCK)
                        FROM DM_PLN_MKT_FCST_RESULT_C_KEEP A WITH (NOLOCK)
                        CROSS APPLY ( select DIVISION_ID
                                            , MAX(YYYYMMDD) AS YYYYMMDD
                                            , VR.VERSION_NO  AS VERSION_NO  --, VERSION_TYPE, YYYYMMDD 
                                            , VERSION_TYPE
                                            , MAX(CL.BASIS_START_DATE) AS START_YYYYMMDD
                                            , MAX(CONVERT(CHAR(8), DATEADD(DD, -7-1, DBO.FN_NEXT_DAY(CONVERT(CHAR(8), DATEADD(WW, 52, CL.BASIS_START_DATE),112), 'MON')), 112)) AS END_YYYYMMDD
                                             , MAX(CONVERT(CHAR(8), DATEADD(DD, -7*52, DBO.FN_NEXT_DAY(CL.BASIS_START_DATE, 'MON')), 112)) AS RESULT_START_YYYYMMDD
                                             , MAX(CONVERT(CHAR(8), DATEADD(DD, -7-1 , DBO.FN_NEXT_DAY(CL.BASIS_START_DATE, 'MON')), 112)) AS RESULT_END_YYYYMMDD
                                            -- , MAX(CONVERT(CHAR(8), DATEADD(DD, -7, DBO.FN_NEXT_DAY(YYYYMMDD, 'MON')), 112)) AS START_YYYYMMDD		 
                                            -- , MAX(CONVERT(CHAR(8), DATEADD(DD, -7-1, DBO.FN_NEXT_DAY(CONVERT(CHAR(8), DATEADD(WW, 52, YYYYMMDD),112), 'MON')), 112)) AS END_YYYYMMDD
                                            -- , MAX(CONVERT(CHAR(8), DATEADD(DD, -7*52, DBO.FN_NEXT_DAY(YYYYMMDD, 'MON')), 112)) AS RESULT_START_YYYYMMDD
                                            -- , MAX(CONVERT(CHAR(8), DATEADD(DD, -7-1 , DBO.FN_NEXT_DAY(YYYYMMDD, 'MON')), 112)) AS RESULT_END_YYYYMMDD	
                                        from DM_MST_VERSION VR WITH(NOLOCK)
                                       inner join SCM_SYS_CALENDAR_M CL WITH(NOLOCK)
                                          on VR.YYYYMMDD = CL.BASIS_YYYYMMDD
                                       where 1=1 
                                        -- AND A.DIVISION_ID =  VR.DIVISION_ID --'81'				
                                        -- AND A.VERSION_NO  =  VR.VERSION_NO		
                                        -- AND A.CUTOFF_TYPE = VR.VERSION_TYPE
                                        -- AND A.CUTOFF_YYYYMMDD = VR.YYYYMMDD
                                        -- and A.YYYYMMDD >= CONVERT(CHAR(8), DATEADD(DD, -7, DBO.FN_NEXT_DAY(YYYYMMDD, 'MON')), 112)
                                        -- and A.YYYYMMDD <= CONVERT(CHAR(8), DATEADD(DD, -7-1, DBO.FN_NEXT_DAY(CONVERT(CHAR(8), DATEADD(WW, 52, YYYYMMDD),112), 'MON')), 112)
                                        and VR.VERSION_TYPE = 'MF_W'
                                        group by VR.DIVISION_ID, VR.VERSION_NO, CL.ISO_YYYYWW, VR.VERSION_TYPE
                                        --and A.YYYYMMDD  >= VR.START
                                      ) B
                        WHERE 1=1
                        AND A.DIVISION_ID = B.DIVISION_ID
                        AND A.VERSION_NO  =  B.VERSION_NO
                        AND A.CUTOFF_TYPE = B.VERSION_TYPE
                        AND A.CUTOFF_YYYYMMDD = B.YYYYMMDD
                        /* 버전별 구간설정  */						
                        --AND A.YYYYMMDD   >= @PARAM_FROM_DATE --★실적구간처리일자★
                        AND A.YYYYMMDD   >= B.RESULT_START_YYYYMMDD --★실적구간처리일자★
                        AND A.YYYYMMDD   <  B.START_YYYYMMDD -- 계획 전날까지.
                        AND QTY <> 0
                        AND MEASURE IN ('MKT_FCST','RTF_SYS_RP','CUST_FCST_EDI')
                        --
                        /*
                        UNION ALL
                        SELECT 'R' AS GUBUN
                            , A.DIVISION_ID,A.VERSION_NO,CUTOFF_TYPE,CUTOFF_YYYYMMDD,PROJECT_CODE,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE,INCOTERMS
                            , MEASURE,PLANT_SITE_ID ,A.YYYYMMDD,QTY,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4,ATTRIBUTE5,ATTRIBUTE6,ATTRIBUTE7
                            , ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10
                            , CREATED_BY,CREATION_DATE,LAST_UPDATED_BY,LAST_UPDATE_DATE
                        FROM DM_PLN_MKT_FCST_RESULT_C_KEEP A WITH (NOLOCK)
                        , (/* 버전  1년단위 설정위해 파라메터 처리 , 버전 년도 일괄추출기능은 처리됨. (속도가 나와야 해당 정보 사용이 가능함) */
                                SELECT DIVISION_ID, YYYYMMDD
                                    , MAX(VERSION_NO)  AS VERSION_NO  --, VERSION_TYPE, YYYYMMDD 
                                    , CONVERT(CHAR(8), DATEADD(DD, -7,    DBO.FN_NEXT_DAY(YYYYMMDD, 'MON')), 112) AS START_YYYYMMDD		 
                                    , CONVERT(CHAR(8), DATEADD(DD, -7-1,  DBO.FN_NEXT_DAY(CONVERT(CHAR(8), DATEADD(WW, 52, YYYYMMDD),112), 'MON')), 112) AS END_YYYYMMDD
                                    , CONVERT(CHAR(8), DATEADD(DD, -7*52, DBO.FN_NEXT_DAY(YYYYMMDD, 'MON')), 112) AS RESULT_START_YYYYMMDD
                                    , CONVERT(CHAR(8), DATEADD(DD, -7-1 , DBO.FN_NEXT_DAY(YYYYMMDD, 'MON')), 112) AS RESULT_END_YYYYMMDD	
                                FROM DM_MST_VERSION WITH (NOLOCK)
                                WHERE DIVISION_ID = @PARAM_DIVISION_ID --81						
                                AND CASE WHEN @PARAM_VERSION_NO = '' THEN '' ELSE VERSION_NO END = CASE WHEN @PARAM_VERSION_NO = ''	 THEN ''  ELSE @PARAM_VERSION_NO  END
                                --AND VERSION_NO  =  @PARAM_VERSION_NO --20240207★필수
                                AND VERSION_TYPE = 'MF_W'
                                --AND YYYYMMDD BETWEEN @PARAM_FROM_DATE AND @PARAM_TO_DATE						
                                GROUP BY DIVISION_ID, YYYYMMDD
                                )  B --#TEMP_VERSION
                        WHERE 1=1
                        AND A.DIVISION_ID = @PARAM_DIVISION_ID --'81'				
                        AND A.VERSION_NO  =  B.VERSION_NO
                        AND A.VERSION_NO  =  @PARAM_VERSION_NO --20240207★필수
                        AND A.CUTOFF_TYPE = 'MF_W'
                        AND A.CUTOFF_YYYYMMDD = B.YYYYMMDD
                        /* 버전별 구간설정  */											
                        --AND A.YYYYMMDD   >= @PARAM_FROM_DATE --★실적구간처리일자★
                        AND A.YYYYMMDD   >= B.RESULT_START_YYYYMMDD --★실적구간처리일자★
                        AND A.YYYYMMDD   <  CONVERT(CHAR(8), DATEADD(DD, -7, DBO.FN_NEXT_DAY(SUBSTRING(B.VERSION_NO,6,8), 'MON')), 112)					
                        AND QTY <> 0
                        AND MEASURE IN ('MKT_FCST','RTF_SYS_RP','CUST_FCST_EDI')*/
                    ) TA
                    GROUP BY TA.DIVISION_ID, TA.VERSION_NO,TA.SCM_SITE_ID,TA.PROJECT_CODE, TA.ITEM_ID, TA.DOM_EXP, TA.FCST_TYPE, TA.INCOTERMS, TA.PLANT_SITE_ID	
                            , TA.YYYYMMDD	
                            , TA.MEASURE
        -----------------------------------------------
                ) TA		
                INNER JOIN (
                    SELECT  A.BASIS_YYYYMMDD , A.ISO_YYYYWW, A.ISO_WEEK, A.WEEK_NAME , A.BASIS_START_DATE, A.BASIS_END_DATE, A.MONTH_NAME
                    FROM	DBO.SCM_SYS_CALENDAR_M A WITH (NOLOCK)
                    WHERE	1=1	
                    AND A.BASIS_YYYYMMDD >='20190101'  --디폴트 구간 설정해서 줄이기!
                )  CALENDAR ON CALENDAR.BASIS_YYYYMMDD = TA.YYYYMMDD 
                WHERE 1=1 --TA.DIVISION_ID	= @PARAM_DIVISION_ID --'81'
                --AND TA.VERSION_NO  =  @PARAM_VERSION_NO --20240207★필수		
                --AND CASE WHEN @PARAM_VERSION_NO = ''   THEN @PARAM_VERSION_NO ELSE TA.VERSION_NO     END  IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@PARAM_VERSION_NO,','))
                --AND CASE WHEN @PARAM_PROJECT_CODE = '' THEN @PARAM_PROJECT_CODE ELSE TA.PROJECT_CODE END  IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@PARAM_PROJECT_CODE,','))
                --AND CASE WHEN @PARAM_ITEM_ID = ''      THEN @PARAM_ITEM_ID      ELSE TA.ITEM_ID      END  IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@PARAM_ITEM_ID,','))		

            ) T
            GROUP BY DIVISION_ID, SCM_SITE_ID, PROJECT_CODE, ITEM_ID, INCOTERMS, DOM_EXP, FCST_TYPE, SUBSTRING(YYYYMMDD, 1,6), ISO_YYYYWW, WEEK_NAME , VERSION_NO  --, MEASURE
				   , PLANT_SITE_ID --[E20250305-000530]_plant_site 컬럼추가
        ) ALL_DATA
        INNER JOIN
        (   /* SCM_MST_SITE 정보 : END_CUSTOMER, VMI_YN */
            SELECT B.DIVISION_ID, B.SCM_SITE_ID, B.SITE_TYPE, B.DEPT_ID, B.VALID_YN  , B.END_CUSTOMER	
                ,B.COUNTRY , B.CITY , B.VMI_YN , B.SOLDTO_CUSTOMER	
            FROM SCM_MST_SITE B WITH (NOLOCK)
            WHERE 1=1
            --AND DIVISION_ID			= @PARAM_DIVISION_ID --'81'
            AND ISNULL(VALID_YN,'') = 'Y'	
        ) TB ON ALL_DATA.DIVISION_ID = TB.DIVISION_ID 
            AND ALL_DATA.SCM_SITE_ID = TB.SCM_SITE_ID	 --18
        left outer JOIN
        (   /* SCM_MST_PROJECT 정보, 소형은 Pjt 단위 관리 안하기 때문에 Outer 처리. */
            SELECT C.DIVISION_ID, C.PROJECT_CODE, C.PROJECT_NAME, C.BIZ_TYPE, C.BIZ_TYPE_NAME  , C.PROJECT_STATUS , C.PROJECT_OWNER
            FROM SCM_MST_PROJECT C WITH (NOLOCK)
            WHERE 1=1
            --AND DIVISION_ID		 = @PARAM_DIVISION_ID --'81'
        ) TC ON ALL_DATA.DIVISION_ID   = TC.DIVISION_ID 
            AND ALL_DATA.PROJECT_CODE  = TC.PROJECT_CODE
        LEFT OUTER JOIN
        (
            SELECT D.DIVISION_ID,D.PROJECT_CODE, D.SCM_SITE_ID, D.ITEM_ID , D.VALID_YN 
                , D.CUST_GROUP
                , D.CUST_GROUP_DTL
                , D.APPLICATION
                , D.ROUTE
                , D.ATTRIBUTE5
                , D.CELL_PER_CAR
                , D.CELL_PER_MODULE
                , D.ATTRIBUTE7
                , D.ATTRIBUTE1
                , D.ATTRIBUTE2
                , D.REPORT_GROUP6	
                , D.SALES_COMPANY
                , D.ATTRIBUTE8
                ,(SELECT SU.DEPT_ID  
                    FROM SCM_MST_SSO_USER_INFO SU WITH (NOLOCK)
                    WHERE SU.USER_ID = (SELECT TOP 1 TOKEN FROM [DBO].[STRING_SPLIT](D.OWNER, ',')) ) DEPT_ID
                , DBO.FN_GET_DM_MKT_OWNER_NAME (D.OWNER, ',', 'EN' )     AS OWNER_NAME
                , DBO.FN_GET_DM_MKT_OWNER_NAME (D.OWNER, ',', 'KO' )     AS OWNER_NAME_KO			
            FROM SCM_MST_SITE_ITEM D WITH (NOLOCK)
            WHERE 1=1
            --AND DIVISION_ID     = @PARAM_DIVISION_ID --'81'
            --AND VALID_YN = 'Y'
        ) TD ON ALL_DATA.DIVISION_ID  = TD.DIVISION_ID 
            AND ALL_DATA.PROJECT_CODE = TD.PROJECT_CODE
            AND ALL_DATA.SCM_SITE_ID  = TD.SCM_SITE_ID
            AND ALL_DATA.ITEM_ID      = TD.ITEM_ID
        LEFT OUTER JOIN SCM_MST_CITY	H		 WITH (NOLOCK) ON H.CITY		 = TB.CITY
        LEFT OUTER JOIN SCM_MST_COUNTRY J		 WITH (NOLOCK) ON J.COUNTRY		 = TB.COUNTRY	
        LEFT OUTER JOIN SCM_MST_SITE_CUSTOMER K	 WITH (NOLOCK) ON TB.DIVISION_ID = K.DIVISION_ID AND TB.SCM_SITE_ID = K.SCM_SITE_ID AND K.REP_YN = 'Y'
        LEFT OUTER JOIN SCM_MST_CUSTOMER	  L  WITH (NOLOCK) ON K.DIVISION_ID  = L.DIVISION_ID  AND K.SHIPTO_CODE = L.SHIPTO_CODE  AND K.SOLDTO_CODE = L.SOLDTO_CODE	
        LEFT OUTER JOIN 
        (
            SELECT DIVISION_ID, ITEM_ID
                , CELL_NICKNAME
                , BASIC_NICKNAME_CELL40
                , NICKNAME_40
                , GROUP_CODE1
                , GROUP_CODE4
                , GROUP_CODE5
                , GROUP_CODE6
                , GROUP_CODE7
                , CELL_TYPE_GROUP_NAME
            FROM (
                SELECT  SCP_P.DIVISION_ID
                        , SCP_P.ITEM_ID
                        , SCP_P.CELL_NICKNAME
                        , SCP_P.BASIC_NICKNAME_CELL40
                        , SCP_P.NICKNAME_40
                        , SCP_P.GROUP_CODE1
                        , SCP_P.GROUP_CODE4
                        , SCP_P.GROUP_CODE5
                        , SCP_P.GROUP_CODE6
                        , SCP_P.GROUP_CODE7
                        , CASE WHEN SCP_P.LEVEL_EXCEPT = 'EC' THEN 'POUCH'
                            WHEN SCP_P.LEVEL_EXCEPT = 'AM' THEN 'CYLINDRICAL'
                            WHEN SUBSTRING(SCP_P.ITEM_ID, 3, 1) = 'M' AND SCP_P.OPERATION_ID = 'P9500' THEN 'POUCH'
                        ELSE SCP_G.CELL_TYPE_GROUP_NAME END AS CELL_TYPE_GROUP_NAME
                FROM (
                        SELECT DIVISION_ID
                            , FLOW_ID                       AS OPERATION_ID
                            , ITEM_ID
                            , SUBSTRING(A.ITEM_ID, 3, 1)    AS CELL_TYPE_CODE
                            , SUBSTRING(A.ITEM_ID, 1, 2)    AS LEVEL_EXCEPT -- 예외적용
                            , CASE WHEN SUBSTRING(A.DIVISION_ID, 1, 2) = '81'  THEN GROUP_CODE1
                                WHEN A.DIVISION_ID = '82'                  THEN LEVEL2_CODE
                            ELSE '' END AS CELL_NICKNAME
                            , CASE WHEN SUBSTRING(A.ITEM_ID, 1, 2) = 'EC' THEN 'ESS'
                                WHEN SUBSTRING(A.ITEM_ID, 1, 2) = 'AM' THEN 'M50L'
                            ELSE CASE WHEN A.OPERATION_GROUP = 'P' 
                                        THEN (SELECT NICK_NAME 
                                            FROM SCP_MST_FINAL_ITEM B WITH(NOLOCK) 
                                            WHERE B.DIVISION_ID = A.DIVISION_ID 
                                            AND B.ITEM_ID = (SELECT TOP 1 DOE FROM SCM_MST_ITEM_SN B WITH(NOLOCK) 
                                                            WHERE B.DIVISION_ID = A.DIVISION_ID AND B.ITEM_ID = A.ATTRIBUTE1 AND B.DOE IS NOT NULL))
                                ELSE (SELECT NICK_NAME 
                                        FROM SCP_MST_FINAL_ITEM B WITH(NOLOCK) 
                                        WHERE B.DIVISION_ID = A.DIVISION_ID 
                                        AND B.ITEM_ID = (SELECT TOP 1 DOE FROM SCM_MST_ITEM_SN B WITH(NOLOCK) 
                                                        WHERE B.DIVISION_ID = A.DIVISION_ID AND B.ITEM_ID = A.ITEM_ID AND B.DOE IS NOT NULL)) 
                                END
                            END  AS BASIC_NICKNAME_CELL40
                            , A.NICK_NAME  AS NICKNAME_40
                            , A.GROUP_CODE4
                            , A.GROUP_CODE5
                            , A.GROUP_CODE6
                            , A.GROUP_CODE7
                            , A.GROUP_CODE1
                            , CASE WHEN A.FLOW_ID IN ('A3000', 'A9000') THEN 'C' ELSE 'E' END  AS FLOW_TYPE	
                        FROM    SCP_MST_FINAL_ITEM A WITH(NOLOCK)
                        WHERE   1=1
                            AND (SUBSTRING(A.ATTRIBUTE8, 1, 2) <> 'CA' OR A.ATTRIBUTE8 = '' OR A.ATTRIBUTE8 IS NULL) --활성화코드 분리
                            --AND A.DIVISION_ID = @PARAM_DIVISION_ID  --81
                            --AND (( @PARAM_ITEM_ID IS NULL OR @PARAM_ITEM_ID ='') OR A.ITEM_ID IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@PARAM_ITEM_ID , ',')))					
                ) SCP_P
                LEFT OUTER JOIN (				
                        SELECT  A.CODE                  AS CELL_TYPE_CODE
                            , SUBSTRING(A.NAME, 1, 1)   AS FLOW_TYPE
                            , A.GROUP_CODE              AS CELL_TYPE_GROUP_CODE
                            , G.NAME                    AS CELL_TYPE_GROUP_NAME
                            , A.DISPLAY_SEQ		
                        FROM    
                        (
                            SELECT    B.SEGMENT1 CODE
                                    , B.SEGMENT2 NAME
                                    , B.SEGMENT3 GROUP_CODE
                                    , B.DISPLAY_SEQ
                            FROM    SCM_ADM_LOOKUP_MASTER A		WITH(NOLOCK)
                            JOIN SCM_ADM_LOOKUP_MASTER_DETAIL B WITH(NOLOCK) ON A.LOOKUP_TYPE = B.LOOKUP_TYPE			       
                            AND B.VALID_YN = 'Y'
                            WHERE   1=1
                                AND A.LOOKUP_TYPE   = 'CELL_TYPE_ITEM_CODE'
                                AND A.VALID_YN      = 'Y'
                        ) A
                        JOIN
                        (
                            SELECT    B.SEGMENT1 CODE
                                    , B.SEGMENT2 NAME
                            FROM    SCM_ADM_LOOKUP_MASTER A		WITH(NOLOCK)
                            JOIN SCM_ADM_LOOKUP_MASTER_DETAIL B WITH(NOLOCK) ON A.LOOKUP_TYPE = B.LOOKUP_TYPE  AND B.VALID_YN = 'Y'
                            WHERE   1=1
                                AND A.LOOKUP_TYPE   = 'CELL_TYPE_ITEM_GROUP'
                                AND A.VALID_YN      = 'Y'
                        ) G ON A.GROUP_CODE = G.CODE
                ) SCP_G ON SCP_G.FLOW_TYPE = SCP_P.FLOW_TYPE AND SCP_G.CELL_TYPE_CODE  = SCP_P.CELL_TYPE_CODE  
            )  T
        ) SCP_INFO ON SCP_INFO.DIVISION_ID  = ALL_DATA.DIVISION_ID AND SCP_INFO.ITEM_ID = ALL_DATA.ITEM_ID
        --[E20240227-000623]
        LEFT OUTER JOIN 
        (   /* SSPM T_SINGLE 참고 */
            SELECT	T1.DIVISION_ID
                , T1.ITEM_ID
                , MAX(T1.ITEM_NAME)					AS ITEM_NAME
                , CASE  MIN(CASE WHEN T1.ITEM_TYPE = 'P' THEN 1	
                                WHEN T1.ITEM_TYPE = 'H' THEN 2	
                                WHEN T1.ITEM_TYPE = 'Q' THEN 3
                                ELSE 4 END )  
                                    WHEN 1 THEN 'P' 
                                    WHEN 2 THEN 'H'
                                    WHEN 3 THEN 'Q'
                                    ELSE 'R' END	AS ITEM_TYPE
                , MAX(T1.ITEM_CLASS_NAME)			AS ITEM_CLASS_NAME
                , MAX(T1.NICK_NAME)					AS NICK_NAME	
            FROM SCM_MST_ITEM_SN T1 WITH (NOLOCK)					
            WHERE 1=1
            --AND T1.DIVISION_ID = @PARAM_DIVISION_ID --'81'		
            GROUP BY T1.DIVISION_ID, T1.ITEM_ID
        ) MST_ITEM_SN  ON ALL_DATA.DIVISION_ID = MST_ITEM_SN.DIVISION_ID AND ALL_DATA.ITEM_ID = MST_ITEM_SN.ITEM_ID	
        WHERE 1=1
        --AND CASE WHEN @PARAM_VERSION_NO = '' THEN '' ELSE VERSION_NO END = CASE WHEN @PARAM_VERSION_NO = ''	 THEN ''  ELSE @PARAM_VERSION_NO  END	
    ) FINAL_DATA
    LEFT OUTER JOIN 
    (   --[E20240227-000623]
        SELECT  A.BASIS_START_DATE , A.BASIS_YYYYMMDD, A.CALENDAR_YYYY, A.CALENDAR_MONTH, A.CALENDAR_DAY, ISO_WEEK 	      
        FROM	DBO.SCM_SYS_CALENDAR_M A WITH (NOLOCK)
        WHERE	1=1	
        AND A.BASIS_YYYYMMDD >='20190101'
    )  FINAL_DT ON FINAL_DT.BASIS_YYYYMMDD = FINAL_DATA.CUTOFF_YYYYMMDD 
    WHERE 1=1

