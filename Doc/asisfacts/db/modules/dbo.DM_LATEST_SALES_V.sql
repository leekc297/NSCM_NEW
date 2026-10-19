
CREATE VIEW [dbo].[DM_LATEST_SALES_V]
AS
/*==============================================================================================================================
* PROJECT       : LGES SCM
* VIEW NAME     : DM_LATEST_SALES_V
* DESCRIPTION   : 매출실적 Query
* PROGRAM HISTORY
*==============================================================================================================================
*  DATE        IN CHARGE           DESCRIPTION
*==============================================================================================================================
* 2024.05.03  Philsu Park         Initial Release. - SQL작성
* 2024.05.03  HMIN                VIEW생성  [E20240422-000076]_데이터 AWS 전송 데이터 추가 건(DM 실적)
* 2025.03.11  JSSBAE		      [E20250305-000530]_View table 컬럼 추가 요청의 건(project_code, plant_site, sold_to_code 칼럼 추가)
==============================================================================================================================*/

SELECT FINAL_DATA.DIVISION_ID    AS DIVISION_ID
    , FINAL_DATA.MODEL_CODE      AS MODEL_CODE
    , FINAL_DATA.END_CUSTOMER    AS END_CUSTOMER
    , FINAL_DATA.SOLDTO_CUSTOMER AS SOLDTO_CUSTOMER
    , FINAL_DATA.SCM_SITE_ID     AS SCM_SITE_ID --[E20240227-000623]
    , FINAL_DATA.PRODUCT_LEVEL1  AS PRODUCT_LEVEL1
	, FINAL_DATA.ITEM_ID         AS ITEM_ID
    , FINAL_DATA.NICK_NAME       AS NICK_NAME --[E20240227-000623]
    , FINAL_DATA.FCST_TYPE       AS FCST_TYPE --[E20240227-000623]
    , FINAL_DATA.INCOTERMS       AS INCOTERMS --[E20240227-000623]
    , FINAL_DATA.YYYYMM          AS YYYYMM
	, FINAL_DATA.ISO_YYYYWW      AS ISO_YYYYWW
    , FINAL_DATA.RESULT_QTY      AS RESULT_QTY
    , FINAL_DATA.PROJECT_CODE	 AS PROJECT_CODE --[E20250305-000530]_project_code 추가
    , FINAL_DATA.SOLDTO_CODE	 AS SOLDTO_CODE  --[E20250305-000530]_sold_to_code 추가
    , FINAL_DATA.PLANT_SITE_ID	 AS PLANT_SITE_ID  --[E20250305-000530]_plant_site 추가
FROM (
    SELECT ALL_DATA.*
        , TB.END_CUSTOMER
        , TB.SOLDTO_CUSTOMER
        , TB.VMI_YN
        , TC.BIZ_TYPE_NAME   AS [BIZ.TYPE]
        , TC.PROJECT_NAME
		, TC.PROJECT_STATUS
        , TC.PROJECT_OWNER   AS PROJECT_OWNER
        , TD.OWNER_NAME      AS OWNER
        , TD.CELL_PER_CAR    AS CELL_PER_CAR
        , TD.CELL_PER_MODULE AS CELL_PER_MODULE
        , CASE WHEN TD.CELL_PER_MODULE  <> 0 THEN TD.CELL_PER_CAR / TD.CELL_PER_MODULE ELSE 0 END AS MODULE_PER_CAR
        , TD.SALES_COMPANY
        , TD.ATTRIBUTE8      AS KWH_CELL
        , CASE WHEN ALL_DATA.DIVISION_ID LIKE '81%' AND TD.CELL_PER_MODULE > 0 AND ISNULL(TD.ATTRIBUTE8, '') <> ''
               THEN CONVERT(FLOAT,(TD.CELL_PER_MODULE * TD.ATTRIBUTE8))
            ELSE NULL END AS KWH_MODULE
		, CASE WHEN ALL_DATA.DIVISION_ID LIKE '81%' AND TD.CELL_PER_CAR > 0 AND ISNULL(TD.ATTRIBUTE8, '') <> ''
               THEN CONVERT(FLOAT,(TD.CELL_PER_CAR * TD.ATTRIBUTE8))
            ELSE NULL END AS KWH_PACK
        , J.COUNTRY_NAME     AS COUNTRY
        , H.CITY_NAME        AS CITY
        , L.SOLDTO_CODE      AS SOLDTO_CODE
        , CASE WHEN SUBSTRING(ALL_DATA.DIVISION_ID, 1,2) = '81' OR ALL_DATA.DIVISION_ID = '82' THEN SCP_INFO.GROUP_CODE6
            ELSE SCP_INFO.CELL_TYPE_GROUP_NAME END PRODUCT_LEVEL1
        , LEFT(ALL_DATA.ITEM_ID, 12) AS MODEL_CODE  /* SUFFIX 제거 */
        , MST_ITEM_SN.NICK_NAME  --[E20240227-000623]
    FROM (
        SELECT DIVISION_ID, SCM_SITE_ID, PROJECT_CODE, ITEM_ID, INCOTERMS, DOM_EXP, FCST_TYPE, SUBSTRING(YYYYMMDD, 1,6) AS YYYYMM, ISO_YYYYWW, WEEK_NAME
		    --, MEASURE
            , SUM(RESULT_QTY)   AS RESULT_QTY
			, PLANT_SITE_ID --[E20250305-000530]_plant_site 추가
        FROM (
            SELECT TA.DIVISION_ID, TA.SCM_SITE_ID, TA.PROJECT_CODE, TA.ITEM_ID, TA.INCOTERMS, TA.DOM_EXP, TA.FCST_TYPE, TA.MEASURE, TA.YYYYMMDD--, TA.QTY
                ,CALENDAR.ISO_YYYYWW
                ,CALENDAR.[ISO_WEEK]
                ,CALENDAR.WEEK_NAME                
                ,RESULT_QTY
				,TA.PLANT_SITE_ID --[E20250305-000530]_plant_site 추가
            --FROM #RAW_DATA  TA
            FROM
            (
    -----------------------------------------------
                SELECT TA.DIVISION_ID, TA.SCM_SITE_ID,TA.PROJECT_CODE, TA.ITEM_ID, TA.DOM_EXP, TA.FCST_TYPE, TA.INCOTERMS, TA.PLANT_SITE_ID
                        , TA.YYYYMMDD  
                        , TA.MEASURE
                        , SUM(QTY) AS RESULT_QTY
                FROM DM_PLN_MKT_FCST_RESULT TA
                where MEASURE = 'RTF_SYS_RP'
                and QTY <> 0
                GROUP BY TA.DIVISION_ID, TA.SCM_SITE_ID,TA.PROJECT_CODE, TA.ITEM_ID, TA.DOM_EXP, TA.FCST_TYPE, TA.INCOTERMS, TA.PLANT_SITE_ID  
                        , TA.YYYYMMDD  
                        , TA.MEASURE
    -----------------------------------------------
            ) TA        
            INNER JOIN (
                SELECT  A.BASIS_YYYYMMDD , A.ISO_YYYYWW, A.ISO_WEEK, A.WEEK_NAME , A.BASIS_START_DATE, A.BASIS_END_DATE, A.MONTH_NAME
                FROM    DBO.SCM_SYS_CALENDAR_M A WITH (NOLOCK)
                WHERE   1=1
                AND A.BASIS_YYYYMMDD >='20190101'  --디폴트 구간 설정해서 줄이기!
            )  CALENDAR ON CALENDAR.BASIS_YYYYMMDD = TA.YYYYMMDD
            WHERE 1=1 --TA.DIVISION_ID  = @PARAM_DIVISION_ID --'81'
            --AND TA.VERSION_NO  =  @PARAM_VERSION_NO --20240207★필수    
            --AND CASE WHEN @PARAM_VERSION_NO = ''   THEN @PARAM_VERSION_NO ELSE TA.VERSION_NO     END  IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@PARAM_VERSION_NO,','))
            --AND CASE WHEN @PARAM_PROJECT_CODE = '' THEN @PARAM_PROJECT_CODE ELSE TA.PROJECT_CODE END  IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@PARAM_PROJECT_CODE,','))
            --AND CASE WHEN @PARAM_ITEM_ID = ''      THEN @PARAM_ITEM_ID      ELSE TA.ITEM_ID      END  IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@PARAM_ITEM_ID,','))    
        ) T
        GROUP BY DIVISION_ID, SCM_SITE_ID, PROJECT_CODE, ITEM_ID, INCOTERMS, DOM_EXP, FCST_TYPE, SUBSTRING(YYYYMMDD, 1,6), ISO_YYYYWW, WEEK_NAME
			   , PLANT_SITE_ID --[E20250305-000530]_plant_site 추가
    ) ALL_DATA
    INNER JOIN
    (   /* SCM_MST_SITE 정보 : END_CUSTOMER, VMI_YN */
        SELECT B.DIVISION_ID, B.SCM_SITE_ID, B.SITE_TYPE, B.DEPT_ID, B.VALID_YN  , B.END_CUSTOMER  
            ,B.COUNTRY , B.CITY , B.VMI_YN , B.SOLDTO_CUSTOMER  
        FROM SCM_MST_SITE B WITH (NOLOCK)
        WHERE 1=1
        --AND DIVISION_ID           = @PARAM_DIVISION_ID --'81'
        AND ISNULL(VALID_YN,'') = 'Y'  
    ) TB ON ALL_DATA.DIVISION_ID = TB.DIVISION_ID
        AND ALL_DATA.SCM_SITE_ID = TB.SCM_SITE_ID    --18
    left outer JOIN
    (   /* SCM_MST_PROJECT 정보, 소형은 Pjt 단위 관리 안하기 때문에 Outer 처리. */
        SELECT C.DIVISION_ID, C.PROJECT_CODE, C.PROJECT_NAME, C.BIZ_TYPE, C.BIZ_TYPE_NAME  , C.PROJECT_STATUS , C.PROJECT_OWNER
        FROM SCM_MST_PROJECT C WITH (NOLOCK)
        WHERE 1=1
        --AND DIVISION_ID        = @PARAM_DIVISION_ID --'81'
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
    LEFT OUTER JOIN SCM_MST_CITY    H        WITH (NOLOCK) ON H.CITY         = TB.CITY
    LEFT OUTER JOIN SCM_MST_COUNTRY J        WITH (NOLOCK) ON J.COUNTRY      = TB.COUNTRY  
    LEFT OUTER JOIN SCM_MST_SITE_CUSTOMER K  WITH (NOLOCK) ON TB.DIVISION_ID = K.DIVISION_ID AND TB.SCM_SITE_ID = K.SCM_SITE_ID AND K.REP_YN = 'Y'
    LEFT OUTER JOIN SCM_MST_CUSTOMER      L  WITH (NOLOCK) ON K.DIVISION_ID  = L.DIVISION_ID  AND K.SHIPTO_CODE = L.SHIPTO_CODE  AND K.SOLDTO_CODE = L.SOLDTO_CODE  
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
                        FROM    SCM_ADM_LOOKUP_MASTER A     WITH(NOLOCK)
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
                        FROM    SCM_ADM_LOOKUP_MASTER A     WITH(NOLOCK)
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
        SELECT  T1.DIVISION_ID
            , T1.ITEM_ID
            , MAX(T1.ITEM_NAME)                 AS ITEM_NAME
            , CASE  MIN(CASE WHEN T1.ITEM_TYPE = 'P' THEN 1
                            WHEN T1.ITEM_TYPE = 'H' THEN 2  
                            WHEN T1.ITEM_TYPE = 'Q' THEN 3
                            ELSE 4 END )  
                                WHEN 1 THEN 'P'
                                WHEN 2 THEN 'H'
                                WHEN 3 THEN 'Q'
                                ELSE 'R' END    AS ITEM_TYPE
            , MAX(T1.ITEM_CLASS_NAME)           AS ITEM_CLASS_NAME
            , MAX(T1.NICK_NAME)                 AS NICK_NAME    
        FROM SCM_MST_ITEM_SN T1 WITH (NOLOCK)                  
        WHERE 1=1
        --AND T1.DIVISION_ID = @PARAM_DIVISION_ID --'81'        
        GROUP BY T1.DIVISION_ID, T1.ITEM_ID
    ) MST_ITEM_SN  ON ALL_DATA.DIVISION_ID = MST_ITEM_SN.DIVISION_ID AND ALL_DATA.ITEM_ID = MST_ITEM_SN.ITEM_ID
    WHERE 1=1
    --AND CASE WHEN @PARAM_VERSION_NO = '' THEN '' ELSE VERSION_NO END = CASE WHEN @PARAM_VERSION_NO = ''    THEN ''  ELSE @PARAM_VERSION_NO  END  
) FINAL_DATA
WHERE 1=1

