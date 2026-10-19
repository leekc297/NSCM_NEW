---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*********************************************************************************************
* Program ID  : DMF0002_GET_ITEM_BY_DIVISION_POPUPEx                                          
* Description : Procedure 작성 가이드                                                          
* Usage       : Procedure 작성 시 참조하세요!                                                  
* Parameter   :                                                                               
*		DMF0002_GET_ITEM_BY_DIVISION_POPUPEx_kcw '81', 'ALL', 'ALL', '', 'ALL', ''  , ''                                                                                          
*---------------------------------------------------------------------------------------------
* Date        In Charge    Description                                                        
*---------------------------------------------------------------------------------------------
* 2017/10/24  SongDH       Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트 
* 2018/06/11    JYE			소형 관련 수정                                                      
* 20181205 nick name 조회요청으로 변경                                                            
* 20181218		JYE       82 currency 수정                                                     
* 20190123		JYE       42, 44 추가                                                    
* 20220428		rosia27		과제PJ20216891R
* 20231130      HMIN     [E20231019-001234] DM시스템의 모델코드 사용중지 정보 제공 개선 
* 2024.04.04    KCW3408  DM 프로시저 속도개선 
/* 2024/08/14	KJJ			[PJ2024-50461] Team Mapping*/

   exec DMF0002_GET_ITEM_BY_DIVISION_POPUPEx @p_division_id=N'81',@p_dept_id=N'ALL',@p_end_customer=N'ALL',@p_project_code=N'',@p_scm_site_id=N'ALL',@p_item_id=N'APBMW12V0-A1-D13',@p_mdmActive_Sw=N'Y'
****************************************************************************************************/
CREATE PROCEDURE [dbo].[DMF0002_GET_ITEM_BY_DIVISION_POPUPEx_250219BK]  
   @p_division_id   NVARCHAR(MAX)
 , @p_dept_id       NVARCHAR(MAX)	--Department
 , @p_end_customer  NVARCHAR(MAX)	--Endcustomer
 , @p_project_code  NVARCHAR(MAX)
 , @p_scm_site_id   NVARCHAR(MAX)
 , @p_item_id       NVARCHAR(MAX)
 , @p_mdmActive_Sw  NVARCHAR(MAX)  --[E20231019-001234] DM시스템의 모델코드 사용중지 정보 제공 개선 (개발서버 및 운영배포시 NULL SETTING 제거) 
AS
BEGIN
	
  SET NOCOUNT ON;

  /* Temp Table 존재 여부 체크 (BEGIN)  */
  IF OBJECT_ID (N'tempdb..#TMP_81_UC_EXCEPTION', N'U') IS NOT NULL   
  DROP TABLE #TMP_81_UC_EXCEPTION  
  IF OBJECT_ID (N'tempdb..#TEMP_DM_MST_ITEM_SINGLE_V', N'U') IS NOT NULL   
  DROP TABLE #TEMP_DM_MST_ITEM_SINGLE_V  

  print 'DMF0002-01-' + convert(varchar(30), getdate(), 121)  

  /* 2024.04.04    KCW3408  DM 프로시저 속도개선 */
  SELECT DISTINCT A.DIVISION_ID, A.ITEM_ID, ITEM_CLASS  
   , ITEM_NAME, ITEM_CLASS_NAME, NICK_NAME, ITEM_TYPE, MIN_CAPACITY  
   , FORECAST_INFO_BIZ_TYPE, FORECAST_INFO_CELL_PACK_COUNT, FORECAST_INFO_PRODUCT_GROUP  
   , FORECAST_INFO_CELL_MODEL, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION  
   , ENERGE, CELL_QUANTITY  
   , MDM_PROJECT_NAME, CELL_TYPE,ACTIVE_FLAG 
  INTO #TEMP_DM_MST_ITEM_SINGLE_V   
  FROM 
  (
			SELECT	T1.DIVISION_ID,
				T1.ITEM_ID, 
				MAX(T1.ITEM_NAME)					AS ITEM_NAME,				--해당 컬럼이 NULL인 경우가 잇으므로 하나로 통일
				MAX(T1.ITEM_CLASS)					AS ITEM_CLASS,				--해당 컬럼이 NULL인 경우가 잇으므로 하나로 통일
				MAX(T1.ITEM_CLASS_NAME)					AS ITEM_CLASS_NAME,		--해당 컬럼이 NULL인 경우가 잇으므로 하나로 통일
				MAX(T1.NICK_NAME)						AS NICK_NAME,			--닉네임이 NULL인 경우가 있으므로 하나로 통일
				case  min( case when T1.item_type = 'P' then 1					--타입이 사이트와 사업부, 법인에 따라 다양하게 존재 하므로 하나로 통일
								when T1.item_type = 'H' then 2					--또한 가장 완성된 상태의 자재 타입을 판매한다고 가정, 해당 자재타입을 사용함
								when T1.item_type = 'Q' then 3
								else 4 end )  
												when 1 then 'P' 
												when 2 then 'H'
												when 3 then 'Q'
												else 'R' end	AS ITEM_TYPE,
				MAX(T1.MATERIAL_CLASS_NAME				)		AS MATERIAL_CLASS_NAME,
				MAX(T1.ITEM_UOM							)		AS ITEM_UOM,
				MAX(T1.SPEC								)		AS SPEC,
				MAX(T1.MDM_PROJECT_NAME					)		AS MDM_PROJECT_NAME,
				MAX(T1.MIN_CAPACITY						)		AS MIN_CAPACITY,
				MAX(T2.FORECAST_INFO_BIZ_TYPE			)		AS FORECAST_INFO_BIZ_TYPE,
				MAX(T2.FORECAST_INFO_PRODUCT_GROUP		)		AS FORECAST_INFO_PRODUCT_GROUP,
				MAX(T2.FORECAST_INFO_CELL_MODEL			)		AS FORECAST_INFO_CELL_MODEL,
				MAX(T2.FORECAST_INFO_CELL_PACK_COUNT	)		AS FORECAST_INFO_CELL_PACK_COUNT,
				MAX(T2.FORECAST_INFO_SPEC				)		AS FORECAST_INFO_SPEC,
				MAX(T2.FORECAST_INFOR_VERSION			)		AS FORECAST_INFOR_VERSION,
				MAX(T1.ACTIVE_FLAG						)		AS ACTIVE_FLAG,  -- 20180720 ADD 'Y'대상중 1건 추출
				MAX(T2.CELL_TYPE						)		AS CELL_TYPE,  -- 20180911 ADD cell_type
				MAX(T1.ENERGE							)  	    AS ENERGE,			-- 20200116 khsong ADD ENERGE
				MAX(T1.CELL_QUANTITY					)	    AS CELL_QUANTITY,	-- 20200116 khsong ADD CELL_QUANTITY
				MAX(T1.SCP_EXTRA_SPEC)						  AS SCP_EXTRA_SPEC		-- [20210428 SJHAN / CSR ID:C20210323-000420]
			FROM SCM_MST_ITEM_SN T1 WITH(NOLOCK)					
			INNER JOIN ( SELECT DIVISION_ID, LEFT(ITEM_ID, 12) AS ITEM_ID
							, MAX(FORECAST_INFO_BIZ_TYPE) AS FORECAST_INFO_BIZ_TYPE
							, MAX(FORECAST_INFO_PRODUCT_GROUP) AS FORECAST_INFO_PRODUCT_GROUP
							, MAX(FORECAST_INFO_CELL_MODEL) AS FORECAST_INFO_CELL_MODEL
							, MAX(FORECAST_INFO_CELL_PACK_COUNT) AS FORECAST_INFO_CELL_PACK_COUNT
							, MAX(FORECAST_INFO_SPEC) AS FORECAST_INFO_SPEC
							, MAX(FORECAST_INFOR_VERSION) AS FORECAST_INFOR_VERSION
							, MAX(CELL_TYPE) AS CELL_TYPE
						FROM  SCM_MST_ITEM_SN T2 WITH(NOLOCK) 
					   WHERE  DIVISION_ID =  @p_division_id
						GROUP BY DIVISION_ID, LEFT(ITEM_ID, 12)
					) T2 ON T1.DIVISION_ID = T2.DIVISION_ID
				AND SUBSTRING(T1.ITEM_ID,1,12) = T2.ITEM_ID
			where 1=1
			AND		T1.DIVISION_ID = @p_division_id
			--AND		T1.ACTIVE_FLAG = 'Y'  --이걸 막아야 건수가 동일해짐 수정전/후 count
			--WHERE ACTIVE_FLAG = 'Y'  -- 20180720 ADD 'Y'대상만
			--LGCE_FPDEV_TR.DBO.SCM_ITEM_M T1
			group by T1.DIVISION_ID, T1.ITEM_ID
  ) A 
  WHERE A.DIVISION_ID = @p_division_id
  
CREATE CLUSTERED INDEX [IDX1_TEMP_DM_MST_ITEM_SINGLE_V] ON [#TEMP_DM_MST_ITEM_SINGLE_V]
(division_id   ASC
,item_id       ASC
)WITH (PAD_INDEX = ON, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
;

  --START [E20231019-001234] DM시스템의 모델코드 사용중지 정보 제공 개선
  CREATE TABLE #TMP_81_UC_EXCEPTION (
	  DIVISION_ID		NVARCHAR(30)		
	, ITEM_ID			NVARCHAR(50)			
	, ACTIVE_FLAG	    NVARCHAR(2)
	)

	DECLARE @V_EXCEPT_SW AS NVARCHAR(2);
	SET @V_EXCEPT_SW = 'N';  --Default : N

	--81_UC의 MDM중지여부 데이터가 없는 경우 → 81의 MDM중지여부 데이터와 동일하게 반영하기를 요청 (오윤종PI님)		
	IF ( @p_division_id = '81_UC' )
		BEGIN
			SET @V_EXCEPT_SW = 'Y';
		END 


	INSERT INTO #TMP_81_UC_EXCEPTION (DIVISION_ID, ITEM_ID, ACTIVE_FLAG)				
	SELECT @P_DIVISION_ID AS DIVISION_ID, V.ITEM_ID, V.ACTIVE_FLAG
	FROM 
	(
		SELECT @p_division_id AS DIVISION_ID,  V.ITEM_ID,  V.ACTIVE_FLAG
		FROM #TEMP_DM_MST_ITEM_SINGLE_V V WITH (NOLOCK)
		WHERE V.DIVISION_ID = '81'  --고정값사용 (81_UC의 경우 81번 값으로 대체 처리 , ACTIVE_FLAG 가 NULL인경우에 한함.)
		GROUP BY V.ITEM_ID, V.ACTIVE_FLAG
	) V
	INNER JOIN
	(
		SELECT S.DIVISION_ID, S.ITEM_ID
		FROM SCM_MST_SITE_ITEM S WITH (NOLOCK)
		WHERE S.DIVISION_ID = @p_division_id
		AND ISNULL(S.ITEM_ID, '') <> ''					
		GROUP BY S.DIVISION_ID, S.ITEM_ID
	)  S ON S.DIVISION_ID = V.DIVISION_ID AND S.ITEM_ID = V.ITEM_ID
	WHERE 1=1
	--AND ISNULL(S.ITEM_ID ,'') <> ''		
	GROUP BY V.ITEM_ID, V.ACTIVE_FLAG
	HAVING CASE WHEN ISNULL(@V_EXCEPT_SW,'N')  = @V_EXCEPT_SW THEN @V_EXCEPT_SW ELSE 'X' END = CASE WHEN ISNULL(@V_EXCEPT_SW,'N')  = 'Y' THEN @V_EXCEPT_SW ELSE 'XX' END
	--END==========================================================================================

  print 'DMF0002-02-' + convert(varchar(30), getdate(), 121)  

--SELECT @p_mdmActive_Sw  RETURN;

  /* 2024.04.04    KCW3408  DM 프로시저 속도개선 */
  SELECT I.DIVISION_ID
     , I.DIVISION_ID  AS DIVISION_NAME
     , D.PROJECT_CODE
     , A.PROJECT_NAME
     , S.SCM_SITE_ID
     , S.SITE_DESCRIPTION
     , D.ITEM_ID	 
	 , T.ITEM_NAME
	 , T.ITEM_TYPE
	 , ITEM_TYPE_CODE.NAME AS ITEM_TYPE_NAME
	 , T.NICK_NAME
	 , T.ITEM_CLASS_NAME
	 , TEAM.DEPT_ID
	 , TEAM.DEPT_NAME_KO
	 , S.END_CUSTOMER
	 , D.CURRENCY
	 , D.PROJECT_CODE AS END_CUSTOMER40
  FROM [dbo].[SCM_MST_DIVISION] I WITH(NOLOCK) 
       LEFT JOIN  [dbo].[SCM_MST_SITE_ITEM] D WITH(NOLOCK)  
	   ON I.DIVISION_ID  = D.DIVISION_ID
	  AND D.VALID_YN='Y'
       LEFT JOIN [dbo].[SCM_MST_PROJECT] A WITH(NOLOCK)
	   ON I.DIVISION_ID  = D.DIVISION_ID	   
	  AND D.PROJECT_CODE = A.PROJECT_CODE
       LEFT JOIN [dbo].[SCM_MST_SITE] S WITH(NOLOCK) 
	   ON D.SCM_SITE_ID  = S.SCM_SITE_ID   
	  AND S.VALID_YN='Y'
	   --LEFT JOIN [dbo].[SCM_MST_ITEM_SN]     T WITH(NOLOCK)
	   LEFT JOIN #TEMP_DM_MST_ITEM_SINGLE_V T WITH(NOLOCK)
	   ON I.DIVISION_ID  = T.DIVISION_ID AND    D.ITEM_ID      = T.ITEM_ID
	   
       /* 2024.04.04    KCW3408  DM 프로시저 속도개선 */
	   /*
	   LEFT JOIN  SCM_MST_SITE C WITH(NOLOCK)  
	   ON I.DIVISION_ID = C.DIVISION_ID AND D.SCM_SITE_ID = C.SCM_SITE_ID AND C.VALID_YN = 'Y'
	   */


	   --[PJ2024-50461]
	   /*
	   LEFT JOIN SCM_MST_SSO_DEPT_INFO TEAM WITH(NOLOCK) 			       
	   ON S.DEPT_ID = TEAM.DEPT_ID
	  AND TEAM.VALID_YN='Y'*/
		LEFT JOIN (
			SELECT B.USER_ID, B.USER_NAME, B.USER_NAME_EN, B.DEPT_ID, C.DEPT_NAME_KO, C.UPPER_DEPT_ID 
			FROM [SCM_MST_SSO_USER_INFO] AS B WITH(NOLOCK)
			INNER JOIN SCM_MST_SSO_DEPT_INFO AS C WITH(NOLOCK)
			ON B.DEPT_ID = C.DEPT_ID
		) AS TEAM
		ON      
		TEAM.USER_ID   IN (SELECT top 1 token FROM [dbo].[String_Split](D.owner, ','))
		--====================================================================================


	   LEFT JOIN (
					 SELECT  SEGMENT1 AS CODE, SEGMENT2 AS NAME
					 FROM [dbo].SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK) 
					WHERE
					VALID_YN ='Y' 
					AND LOOKUP_TYPE = 'ITEM_TYPE_CODE'
	   )  AS ITEM_TYPE_CODE			       
	   ON T.ITEM_TYPE = ITEM_TYPE_CODE.CODE
	   LEFT OUTER JOIN #TMP_81_UC_EXCEPTION  EX ON EX.DIVISION_ID = D.DIVISION_ID AND EX.ITEM_ID = D.ITEM_ID  --[E20231019-001234] DM시스템의 모델코드 사용중지 정보 제공 개선
WHERE   I.DIVISION_ID = @p_division_id   -- DIVISION 이 자동차인 경우에는 SITE-ITEM에 연결된것 만 조회 
  AND   I.DIVISION_ID LIKE '81%'    
  AND   I.VALID_YN='Y'   
  AND   S.SITE_TYPE = 'SALES'
  /*
  AND   CASE WHEN @p_division_id = 'ALL' THEN 'ALL'
		   		 ELSE I.DIVISION_ID			
			END IN (
					Select * from dbo.UF_FX_String_SplitForIN (@p_division_id,',') as P Where 
					(CASE WHEN @p_division_id = 'ALL' THEN 'ALL' ELSE I.DIVISION_ID END) = P.data
	               )
  */
		AND CASE WHEN @p_dept_id = 'ALL' THEN 'ALL'
		   		 ELSE TEAM.DEPT_ID			
			END IN (
					Select * from dbo.UF_FX_String_SplitForIN (@p_dept_id,',') as P Where 
					(CASE WHEN @p_dept_id = 'ALL' THEN 'ALL' ELSE TEAM.DEPT_ID END) = P.data
	               )
		AND CASE WHEN @p_end_customer = 'ALL' THEN 'ALL'
		   		 ELSE isnull(S.END_CUSTOMER,'')			
			END IN (
					Select * from dbo.UF_FX_String_SplitForIN (@p_end_customer,',') as P Where 
					(CASE WHEN @p_end_customer = 'ALL' THEN 'ALL' ELSE isnull(S.END_CUSTOMER,'') END) = P.data
	               )				   
		 
		AND CASE WHEN @p_scm_site_id = 'ALL' THEN 'ALL'
		   		 ELSE S.SCM_SITE_ID			
			END IN (
					Select * from dbo.UF_FX_String_SplitForIN (@p_scm_site_id,',') as P Where 
					(CASE WHEN @p_scm_site_id = 'ALL' THEN 'ALL' ELSE S.SCM_SITE_ID END) = P.data
	               )
	 AND (
		 Exists (Select * from dbo.UF_FX_String_Split (@p_project_code,',') as P Where D.PROJECT_CODE LIKE P.token +'%')
	     OR
		 Exists (Select * from dbo.UF_FX_String_Split (@p_project_code,',') as P Where A.PROJECT_NAME LIKE P.token +'%')
		 )
	 AND (
		 Exists (Select * from dbo.UF_FX_String_Split (@p_item_id,',') as P Where D.ITEM_ID LIKE P.token +'%')
	  --   OR
		 --Exists (Select * from dbo.UF_FX_String_Split (@p_item_id,',') as P Where T.ITEM_NAME LIKE P.token +'%')
		  OR
		 Exists (Select * from dbo.UF_FX_String_Split (@p_item_id,',') as P Where T.nick_name LIKE P.token +'%')
		 )	 -- 20181205 nick name 조회요청으로 변경
	
	--[E20231019-001234] DM시스템의 모델코드 사용중지 정보 제공 개선 
	AND CASE WHEN @p_division_id = '81_UC' THEN 
			CASE WHEN ISNULL(@p_mdmActive_Sw, '') = '' THEN ''  ELSE ISNULL(T.ACTIVE_FLAG,EX.ACTIVE_FLAG)  END
		ELSE 
			CASE WHEN ISNULL(@p_mdmActive_Sw, '') = '' THEN ''  ELSE T.ACTIVE_FLAG END		 
		END = CASE WHEN ISNULL(@p_mdmActive_Sw, '') = '' THEN ''  ELSE 'Y' END
	         



UNION 

  SELECT DISTINCT I.DIVISION_ID
     , I.DIVISION_ID  AS DIVISION_NAME
     , D.PROJECT_CODE
     , A.PROJECT_NAME
     , S.SCM_SITE_ID
     , S.SITE_DESCRIPTION
     , T.ITEM_ID	 
	 , T.ITEM_NAME
	 , T.ITEM_TYPE
	 , ITEM_TYPE_CODE.NAME AS ITEM_TYPE_NAME
	 , T.NICK_NAME
	 , T.ITEM_CLASS_NAME
	 , TEAM.DEPT_ID
	 , TEAM.DEPT_NAME_KO
	 , S.END_CUSTOMER
	 , D.CURRENCY
	 , D.PROJECT_CODE AS END_CUSTOMER40
  FROM  [dbo].[SCM_MST_DIVISION] I WITH(NOLOCK) 
       LEFT JOIN  [dbo].[SCM_MST_SITE_ITEM] D WITH(NOLOCK)  
	   ON I.DIVISION_ID  = D.DIVISION_ID
	  AND D.VALID_YN='Y' 
       LEFT JOIN [dbo].[SCM_MST_PROJECT] A WITH(NOLOCK)
	   ON I.DIVISION_ID  = D.DIVISION_ID	   
	  AND D.PROJECT_CODE = A.PROJECT_CODE
       LEFT JOIN [dbo].[SCM_MST_SITE] S WITH(NOLOCK) 
	   ON I.DIVISION_ID  = D.DIVISION_ID	   
	  AND D.SCM_SITE_ID  = S.SCM_SITE_ID   
	  AND S.VALID_YN='Y' 
    LEFT OUTER JOIN #TEMP_DM_MST_ITEM_SINGLE_V  T WITH(NOLOCK)
    ON I.DIVISION_ID  = T.DIVISION_ID AND D.ITEM_ID = T.ITEM_ID AND T.ITEM_TYPE not in ( 'H', 'R')  AND T.ITEM_ID LIKE 'E%' -- 자재 반재품 는 제외
	
    /* 2024.04.04    KCW3408  DM 프로시저 속도개선 */
	/*
    LEFT JOIN (SELECT DISTINCT DIVISION_ID, SCM_SITE_ID, DEPT_ID, END_CUSTOMER FROM SCM_MST_SITE WITH(NOLOCK) WHERE VALID_YN = 'Y') AS C 
    ON I.DIVISION_ID = C.DIVISION_ID AND D.SCM_SITE_ID = C.SCM_SITE_ID
	*/

	--[PJ2024-50461]
	/*
	LEFT JOIN SCM_MST_SSO_DEPT_INFO TEAM WITH(NOLOCK) 			       
	ON S.DEPT_ID = TEAM.DEPT_ID
   AND TEAM.VALID_YN='Y'  */   
		LEFT JOIN (
			SELECT B.USER_ID, B.USER_NAME, B.USER_NAME_EN, B.DEPT_ID, C.DEPT_NAME_KO, C.UPPER_DEPT_ID 
			FROM [SCM_MST_SSO_USER_INFO] AS B WITH(NOLOCK)
			INNER JOIN SCM_MST_SSO_DEPT_INFO AS C WITH(NOLOCK)
			ON B.DEPT_ID = C.DEPT_ID
		) AS TEAM
		ON      
		TEAM.USER_ID   IN (SELECT top 1 token FROM [dbo].[String_Split](D.owner, ','))
		--====================================================================================

    LEFT JOIN (
     SELECT  SEGMENT1 AS CODE, SEGMENT2 AS NAME
     FROM [dbo].SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK) 
     WHERE
     VALID_YN ='Y' 
     AND LOOKUP_TYPE = 'ITEM_TYPE_CODE'
    )  AS ITEM_TYPE_CODE          
    ON T.ITEM_TYPE = ITEM_TYPE_CODE.CODE
	   
WHERE   I.DIVISION_ID = @p_division_id   
  AND   I.DIVISION_ID = '82'    
  AND   I.VALID_YN='Y'   
  AND   SITE_TYPE = 'SALES'
--  AND   D.PROJECT_CODE = 'DC-17-001'

  /*
  AND   CASE WHEN @p_division_id = 'ALL' THEN 'ALL'
		   		 ELSE I.DIVISION_ID			
			END IN (
					Select * from dbo.UF_FX_String_SplitForIN (@p_division_id,',') as P Where 
					(CASE WHEN @p_division_id = 'ALL' THEN 'ALL' ELSE I.DIVISION_ID END) = P.data
	               )
  */
		AND CASE WHEN @p_dept_id = 'ALL' THEN 'ALL'
		   		 ELSE TEAM.DEPT_ID			
			END IN (
					Select * from dbo.UF_FX_String_SplitForIN (@p_dept_id,',') as P Where 
					(CASE WHEN @p_dept_id = 'ALL' THEN 'ALL' ELSE TEAM.DEPT_ID END) = P.data
	               )
		AND CASE WHEN @p_end_customer = 'ALL' THEN 'ALL'
		   		 ELSE isnull(S.END_CUSTOMER,'')			
			END IN (
					Select * from dbo.UF_FX_String_SplitForIN (@p_end_customer,',') as P Where 
					(CASE WHEN @p_end_customer = 'ALL' THEN 'ALL' ELSE isnull(S.END_CUSTOMER,'') END) = P.data
	               )				   
		 
		AND CASE WHEN @p_scm_site_id = 'ALL' THEN 'ALL'
		   		 ELSE S.SCM_SITE_ID			
			END IN (
					Select * from dbo.UF_FX_String_SplitForIN (@p_scm_site_id,',') as P Where 
					(CASE WHEN @p_scm_site_id = 'ALL' THEN 'ALL' ELSE S.SCM_SITE_ID END) = P.data
	               )
	 AND (
		 Exists (Select * from dbo.UF_FX_String_Split (@p_project_code,',') as P Where D.PROJECT_CODE LIKE P.token +'%')
	     OR
		 Exists (Select * from dbo.UF_FX_String_Split (@p_project_code,',') as P Where A.PROJECT_NAME LIKE P.token +'%')
		 )
	 AND (
		 Exists (Select * from dbo.UF_FX_String_Split (@p_item_id,',') as P Where T.ITEM_ID LIKE P.token +'%')
	  --   OR
		 --Exists (Select * from dbo.UF_FX_String_Split (@p_item_id,',') as P Where T.ITEM_NAME LIKE P.token +'%')
		  OR
		 Exists (Select * from dbo.UF_FX_String_Split (@p_item_id,',') as P Where T.nick_name LIKE P.token +'%')
		 )	 -- 20181205 nick name 조회요청으로 변경
	 --[E20231019-001234] DM시스템의 모델코드 사용중지 정보 제공 개선
	 AND CASE WHEN ISNULL(@p_mdmActive_Sw, '') = '' THEN ''  ELSE T.ACTIVE_FLAG END = CASE WHEN ISNULL(@p_mdmActive_Sw, '') = '' THEN ''  ELSE 'Y' END --20231127 
     
	 UNION -- 20180611 소형 추가, 42, 44

SELECT DISTINCT I.DIVISION_ID
     , I.DIVISION_ID  AS DIVISION_NAME
     , D.PROJECT_CODE
     , '' AS PROJECT_NAME
     , S.SCM_SITE_ID
     , S.SITE_DESCRIPTION
     , D.ITEM_ID	 
	 , T.ITEM_NAME
	 , T.ITEM_TYPE
	 , ITEM_TYPE_CODE.NAME AS ITEM_TYPE_NAME
	 , T.NICK_NAME
	 , T.ITEM_CLASS_NAME
	 , TEAM.DEPT_ID
	 , TEAM.DEPT_NAME_KO
	 , S.END_CUSTOMER
	 , D.CURRENCY
	 , D.PROJECT_CODE AS END_CUSTOMER40
  FROM  [dbo].[SCM_MST_DIVISION] I WITH(NOLOCK) 
       LEFT JOIN [dbo].[SCM_MST_SITE_ITEM] D WITH(NOLOCK) 
	   ON I.DIVISION_ID  = D.DIVISION_ID 
	  AND D.VALID_YN='Y' 
	   LEFT JOIN SCM_MST_SSO_USER_INFO USER_INFO WITH(NOLOCK) 			       
	   ON D.OWNER = USER_INFO.USER_ID 
	   LEFT JOIN SCM_MST_SSO_DEPT_INFO TEAM WITH(NOLOCK) 			       
	   ON USER_INFO.DEPT_ID = TEAM.DEPT_ID 
	  AND TEAM.VALID_YN='Y' 
       LEFT JOIN [dbo].[SCM_MST_SITE] S WITH(NOLOCK) 
	   ON I.DIVISION_ID  = D.DIVISION_ID	   
	  AND D.SCM_SITE_ID  = S.SCM_SITE_ID   
	  AND S.VALID_YN='Y' 
	   LEFT JOIN #TEMP_DM_MST_ITEM_SINGLE_V     T WITH(NOLOCK)
	   ON I.DIVISION_ID  = T.DIVISION_ID AND    D.ITEM_ID      = T.ITEM_ID
	   /* 
	   LEFT JOIN (SELECT DISTINCT DIVISION_ID, SCM_SITE_ID, DEPT_ID, END_CUSTOMER FROM SCM_MST_SITE WITH(NOLOCK) WHERE VALID_YN = 'Y') AS C 
	   ON I.DIVISION_ID = C.DIVISION_ID AND D.SCM_SITE_ID = C.SCM_SITE_ID
	   */
	   LEFT JOIN (
					 SELECT  SEGMENT1 AS CODE, SEGMENT2 AS NAME
					 FROM [dbo].SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK) 
					WHERE
					VALID_YN ='Y' 
					AND LOOKUP_TYPE = 'ITEM_TYPE_CODE'
	   )  AS ITEM_TYPE_CODE			       
	   ON T.ITEM_TYPE = ITEM_TYPE_CODE.CODE
	   LEFT OUTER JOIN #TMP_81_UC_EXCEPTION  EX ON EX.DIVISION_ID = D.DIVISION_ID AND EX.ITEM_ID = D.ITEM_ID --[E20231019-001234] DM시스템의 모델코드 사용중지 정보 제공 개선
WHERE   I.DIVISION_ID = @p_division_id		-- 20190123  
  AND   I.DIVISION_ID LIKE '4%'    
  AND   I.VALID_YN ='Y'   
  AND   SITE_TYPE = 'SALES'
  /*
  AND   CASE WHEN @p_division_id = 'ALL' THEN 'ALL'
		   		 ELSE I.DIVISION_ID			
			END IN (
					Select * from dbo.UF_FX_String_SplitForIN (@p_division_id,',') as P Where 
					(CASE WHEN @p_division_id = 'ALL' THEN 'ALL' ELSE I.DIVISION_ID END) = P.data
	               )
 */
		AND CASE WHEN @p_dept_id = 'ALL' THEN 'ALL'
		   		 ELSE TEAM.DEPT_ID			
			END IN (
					Select * from dbo.UF_FX_String_SplitForIN (@p_dept_id,',') as P Where 
					(CASE WHEN @p_dept_id = 'ALL' THEN 'ALL' ELSE TEAM.DEPT_ID END) = P.data
	            )
		/*20180611. 소형 수정
		AND CASE WHEN @p_end_customer = 'ALL' THEN 'ALL'
		   		 ELSE isnull(C.END_CUSTOMER,'')			
			END IN (
					Select * from dbo.UF_FX_String_SplitForIN (@p_end_customer,',') as P Where 
					(CASE WHEN @p_end_customer = 'ALL' THEN 'ALL' ELSE isnull(C.END_CUSTOMER,'') END) = P.data
	               )				   
		 */
		 AND CASE WHEN @p_end_customer = 'ALL' THEN 'ALL'
		   		 ELSE isnull(
					CASE WHEN @p_division_id <> '40' THEN S.END_CUSTOMER ELSE D.PROJECT_CODE END
				 ,'')			
			END IN (
					Select * from dbo.UF_FX_String_SplitForIN (@p_end_customer,',') as P Where 
					(CASE WHEN @p_end_customer = 'ALL' THEN 'ALL' ELSE isnull(
						CASE WHEN @p_division_id <> '40' THEN S.END_CUSTOMER ELSE D.PROJECT_CODE END
					,'') END) = P.data
	               )

		AND CASE WHEN @p_scm_site_id = 'ALL' THEN 'ALL'
		   		 ELSE S.SCM_SITE_ID			
			END IN (
					Select * from dbo.UF_FX_String_SplitForIN (@p_scm_site_id,',') as P Where 
					(CASE WHEN @p_scm_site_id = 'ALL' THEN 'ALL' ELSE S.SCM_SITE_ID END) = P.data
	               )
	 --AND (
		-- Exists (Select * from dbo.UF_FX_String_Split (@p_project_code,',') as P Where D.PROJECT_CODE LIKE P.token +'%')
	 --    OR
		-- Exists (Select * from dbo.UF_FX_String_Split (@p_project_code,',') as P Where A.PROJECT_NAME LIKE P.token +'%')
		-- )
	 AND (
		 Exists (Select * from dbo.UF_FX_String_Split (@p_item_id,',') as P Where D.ITEM_ID LIKE P.token +'%')
	  --   OR
		 --Exists (Select * from dbo.UF_FX_String_Split (@p_item_id,',') as P Where T.ITEM_NAME LIKE P.token +'%')
		  OR
		 Exists (Select * from dbo.UF_FX_String_Split (@p_item_id,',') as P Where T.nick_name LIKE P.token +'%')
		 )  -- 20181205 nick name 조회요청으로 변경
     
	 --[E20231019-001234] DM시스템의 모델코드 사용중지 정보 제공 개선
	 --AND CASE WHEN ISNULL(@p_mdmActive_Sw, '') = '' THEN ''  ELSE T.ACTIVE_FLAG END = CASE WHEN ISNULL(@p_mdmActive_Sw, '') = '' THEN ''  ELSE 'Y' END --20231127 
	 AND CASE WHEN @p_division_id = '81_UC' THEN 
			CASE WHEN ISNULL(@p_mdmActive_Sw, '') = '' THEN ''  ELSE ISNULL(T.ACTIVE_FLAG,EX.ACTIVE_FLAG)  END
		ELSE 
			CASE WHEN ISNULL(@p_mdmActive_Sw, '') = '' THEN ''  ELSE T.ACTIVE_FLAG END		 
		END = CASE WHEN ISNULL(@p_mdmActive_Sw, '') = '' THEN ''  ELSE 'Y' END
  ORDER BY I.DIVISION_ID
         , D.PROJECT_CODE
         --, A.PROJECT_NAME
         , S.SCM_SITE_ID
         , S.SITE_DESCRIPTION
         , D.ITEM_ID
	     , T.ITEM_NAME

END


  print 'DMF0002-03-' + convert(varchar(30), getdate(), 121)  

  /*  
  SELECT I.DIVISION_ID
     , I.DIVISION_NAME
     , D.PROJECT_CODE
     , A.PROJECT_NAME
     , S.SCM_SITE_ID
     , S.SITE_DESCRIPTION
     , D.ITEM_ID	 
	 , T.ITEM_NAME
	 , T.ITEM_TYPE
	 , ITEM_TYPE_CODE.NAME AS ITEM_TYPE_NAME
	 , T.NICK_NAME
	 , T.ITEM_CLASS_NAME
	 , TEAM.DEPT_ID
	 , TEAM.DEPT_NAME_KO
	 , C.END_CUSTOMER
	 , D.CURRENCY

  FROM   (SELECT * FROM [dbo].[SCM_MST_DIVISION] WITH(NOLOCK) WHERE VALID_YN='Y') AS  I 
       LEFT JOIN (SELECT * FROM [dbo].[SCM_MST_SITE_ITEM] WITH(NOLOCK) WHERE VALID_YN='Y') AS D 
	   ON I.DIVISION_ID  = D.DIVISION_ID
       LEFT JOIN (SELECT * FROM [dbo].[SCM_MST_PROJECT] WITH(NOLOCK)) AS A 
	   ON D.PROJECT_CODE = A.PROJECT_CODE
       LEFT JOIN (SELECT * FROM [dbo].[SCM_MST_SITE] WITH(NOLOCK) WHERE VALID_YN='Y') S 
	   ON D.SCM_SITE_ID  = S.SCM_SITE_ID
	   --LEFT JOIN [dbo].[SCM_MST_ITEM_SN]     T WITH(NOLOCK)
	   LEFT JOIN [dbo].DM_MST_ITEM_SINGLE_V     T WITH(NOLOCK)
	   ON I.DIVISION_ID  = T.DIVISION_ID AND    D.ITEM_ID      = T.ITEM_ID
	   LEFT JOIN (SELECT DISTINCT DIVISION_ID, SCM_SITE_ID, DEPT_ID, 1END_CUSTOMER FROM SCM_MST_SITE WITH(NOLOCK) WHERE VALID_YN = 'Y') AS C 
	   ON I.DIVISION_ID = C.DIVISION_ID AND D.SCM_SITE_ID = C.SCM_SITE_ID
	   LEFT JOIN (SELECT * FROM SCM_MST_SSO_DEPT_INFO WITH(NOLOCK) WHERE VALID_YN = 'Y')  AS TEAM			       
	   ON C.DEPT_ID = TEAM.DEPT_ID
	   LEFT JOIN (
					SELECT  LOOKUP_CODE AS CODE, [DESCRIPTION] AS NAME
					FROM [dbo].[SCM_ADM_LOOKUP_VALUES] WITH(NOLOCK) 
					WHERE
					VALID_YN ='Y' 
					AND LOOKUP_TYPE = 'ITEM_TYPE_CODE'
	   )  AS ITEM_TYPE_CODE			       
	   ON T.ITEM_TYPE = ITEM_TYPE_CODE.CODE
	   

WHERE 
        CASE WHEN @p_division_id = 'ALL' THEN 'ALL'
		   		 ELSE I.DIVISION_ID			
			END IN (
					Select * from dbo.UF_FX_String_SplitForIN (@p_division_id,',') as P Where 
					(CASE WHEN @p_division_id = 'ALL' THEN 'ALL' ELSE I.DIVISION_ID END) = P.data
	               )
		AND CASE WHEN @p_dept_id = 'ALL' THEN 'ALL'
		   		 ELSE TEAM.DEPT_ID			
			END IN (
					Select * from dbo.UF_FX_String_SplitForIN (@p_dept_id,',') as P Where 
					(CASE WHEN @p_dept_id = 'ALL' THEN 'ALL' ELSE TEAM.DEPT_ID END) = P.data
	               )
		AND CASE WHEN @p_end_customer = 'ALL' THEN 'ALL'
		   		 ELSE isnull(C.END_CUSTOMER,'')			
			END IN (
					Select * from dbo.UF_FX_String_SplitForIN (@p_end_customer,',') as P Where 
					(CASE WHEN @p_end_customer = 'ALL' THEN 'ALL' ELSE isnull(C.END_CUSTOMER,'') END) = P.data
	               )				   
		 
		AND CASE WHEN @p_scm_site_id = 'ALL' THEN 'ALL'
		   		 ELSE S.SCM_SITE_ID			
			END IN (
					Select * from dbo.UF_FX_String_SplitForIN (@p_scm_site_id,',') as P Where 
					(CASE WHEN @p_scm_site_id = 'ALL' THEN 'ALL' ELSE S.SCM_SITE_ID END) = P.data
	               )
		--AND CASE WHEN @p_project_code = '' THEN ''
		--   		 ELSE A.PROJECT_CODE			
		--	END IN (
		--			Select * from dbo.UF_FX_String_SplitForIN (@p_project_code,',') as P Where 
		--			(CASE WHEN @p_project_code = '' THEN '' ELSE A.PROJECT_CODE END) = P.data
	 --              )
		--AND CASE WHEN @p_project_code = '' THEN ''
		--   		 ELSE A.PROJECT_NAME			
		--	END IN (
		--			Select * from dbo.UF_FX_String_SplitForIN (@p_project_code,',') as P Where 
		--			(CASE WHEN @p_project_code = '' THEN '' ELSE A.PROJECT_NAME END) = P.data
	 --              ) 

		--AND CASE WHEN @p_item_id = '' THEN ''
		--   		 ELSE D.ITEM_ID			
		--	END IN (
		--			Select * from dbo.UF_FX_String_SplitForIN (@p_item_id,',') as P Where 
		--			(CASE WHEN @p_item_id = '' THEN '' ELSE D.ITEM_ID END) = P.data
	 --              )
		--AND CASE WHEN @p_item_id = '' THEN ''
		--   		 ELSE T.ITEM_NAME			
		--	END IN (
		--			Select * from dbo.UF_FX_String_SplitForIN (@p_item_id,',') as P Where 
		--			(CASE WHEN @p_item_id = '' THEN '' ELSE T.ITEM_NAME END) = P.data
	 --              )
	 AND (
		 Exists (Select * from dbo.UF_FX_String_Split (@p_project_code,',') as P Where A.PROJECT_CODE LIKE P.token +'%')
	     OR
		 Exists (Select * from dbo.UF_FX_String_Split (@p_project_code,',') as P Where A.PROJECT_NAME LIKE P.token +'%')
		 )
	 AND (
		 Exists (Select * from dbo.UF_FX_String_Split (@p_item_id,',') as P Where D.ITEM_ID LIKE P.token +'%')
	     OR
		 Exists (Select * from dbo.UF_FX_String_Split (@p_item_id,',') as P Where T.ITEM_NAME LIKE P.token +'%')
		 )	 
	 --AND    (   A.PROJECT_CODE LIKE '%'+ @p_project_code + '%'
		--  OR A.PROJECT_NAME LIKE '%'+ @p_project_code + '%'
		-- )
  
  --   AND    (   D.ITEM_ID   LIKE '%' + @p_item_id + '%' 
  --        OR T.ITEM_NAME LIKE '%' + @p_item_id + '%' )


  GROUP BY 
		I.DIVISION_ID
     , I.DIVISION_NAME
     , D.PROJECT_CODE
     , A.PROJECT_NAME
     , S.SCM_SITE_ID
     , S.SITE_DESCRIPTION
     , D.ITEM_ID	 
	 , T.ITEM_NAME
	 , T.ITEM_TYPE
	 , ITEM_TYPE_CODE.NAME
	 , T.NICK_NAME
	 , T.ITEM_CLASS_NAME
	 , TEAM.DEPT_ID
	 , TEAM.DEPT_NAME_KO
	 , C.END_CUSTOMER
	 , D.CURRENCY

  ORDER BY I.DIVISION_ID
         , D.PROJECT_CODE
         , A.PROJECT_NAME
         , S.SCM_SITE_ID
         , S.SITE_DESCRIPTION
         , D.ITEM_ID
	     , T.ITEM_NAME
*/



