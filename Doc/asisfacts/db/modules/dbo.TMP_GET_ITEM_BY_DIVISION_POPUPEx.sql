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
CREATE PROCEDURE [dbo].[TMP_GET_ITEM_BY_DIVISION_POPUPEx]  
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

   print 'DMF0002-01-' + convert(varchar(30), getdate(), 121);

-- Philsu Park: 기존 Temp 사용하던 구문 With절로 처리하고 불필요한 컬럼 쳐냄.
WITH TEMP_DM_MST_ITEM_SINGLE_V AS 
    (   SELECT    A.DIVISION_ID, A.ITEM_ID
                , ITEM_NAME, ITEM_CLASS_NAME, NICK_NAME, ITEM_TYPE
                , ACTIVE_FLAG 
        FROM    (   SELECT  T1.DIVISION_ID          AS DIVISION_ID,
                            T1.ITEM_ID              AS ITEM_ID,
                            MAX(T1.ITEM_NAME)		AS ITEM_NAME,				--해당 컬럼이 NULL인 경우가 잇으므로 하나로 통일
                            MAX(T1.ITEM_CLASS_NAME)	AS ITEM_CLASS_NAME,		--해당 컬럼이 NULL인 경우가 잇으므로 하나로 통일
                            MAX(T1.NICK_NAME)		AS NICK_NAME,			--닉네임이 NULL인 경우가 있으므로 하나로 통일
                            CASE  MIN( CASE WHEN T1.ITEM_TYPE = 'P' THEN 1					--타입이 사이트와 사업부, 법인에 따라 다양하게 존재 하므로 하나로 통일
                                            WHEN T1.ITEM_TYPE = 'H' THEN 2					--또한 가장 완성된 상태의 자재 타입을 판매한다고 가정, 해당 자재타입을 사용함
                                            WHEN T1.ITEM_TYPE = 'Q' THEN 3
                                            ELSE 4 END )
                                WHEN 1 THEN 'P'
                                WHEN 2 THEN 'H'
                                WHEN 3 THEN 'Q'
                                ELSE 'R' END        AS ITEM_TYPE,
                            MAX(T1.ACTIVE_FLAG)		AS ACTIVE_FLAG  -- 20180720 ADD 'Y'대상중 1건 추출
                    FROM    SCM_MST_ITEM_SN T1 WITH(NOLOCK)
                    WHERE   T1.DIVISION_ID  = @p_division_id
                    GROUP BY T1.DIVISION_ID, T1.ITEM_ID
                ) A 
        WHERE A.DIVISION_ID = @p_division_id
    )
    , TMP_81_UC_EXCEPTION AS 
    (
        SELECT @P_DIVISION_ID AS DIVISION_ID, V.ITEM_ID, V.ACTIVE_FLAG
        FROM    (   SELECT  @p_division_id AS DIVISION_ID,  V.ITEM_ID,  V.ACTIVE_FLAG
                    FROM    TEMP_DM_MST_ITEM_SINGLE_V V WITH (NOLOCK)
                    WHERE   V.DIVISION_ID = '81'  --고정값사용 (81_UC의 경우 81번 값으로 대체 처리 , ACTIVE_FLAG 가 NULL인경우에 한함.)
                    GROUP BY V.ITEM_ID, V.ACTIVE_FLAG
                ) V
        INNER JOIN (    SELECT  S.DIVISION_ID, S.ITEM_ID
                        FROM    SCM_MST_SITE_ITEM S WITH (NOLOCK)
                        WHERE   S.DIVISION_ID   = @p_division_id
                        AND     S.ITEM_ID      != ''
                        GROUP BY S.DIVISION_ID, S.ITEM_ID
                    )  S
            ON  S.DIVISION_ID   = V.DIVISION_ID 
            AND S.ITEM_ID       = V.ITEM_ID
        WHERE   1=1
        AND     @p_division_id  = '81_UC'  --Philsu Park: Having절 대체. 굳이 Having으로 할 필요가??
        GROUP BY V.ITEM_ID, V.ACTIVE_FLAG
        -- HAVING CASE WHEN ISNULL(@p_division_id,'N')  = '81_UC' THEN @p_division_id ELSE 'X' END = CASE WHEN ISNULL(@p_division_id,'N')  = '81_UC' THEN @p_division_id ELSE 'XX' END
    )
    /* 2024.04.04    KCW3408  DM 프로시저 속도개선 */
    SELECT    I.DIVISION_ID
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
    FROM [SCM_MST_DIVISION] I WITH(NOLOCK) 
    LEFT JOIN  [SCM_MST_SITE_ITEM] D WITH(NOLOCK)
	    ON  I.DIVISION_ID   = D.DIVISION_ID
	    AND D.VALID_YN      = 'Y'
    LEFT JOIN [SCM_MST_PROJECT] A WITH(NOLOCK)
	    ON  I.DIVISION_ID   = D.DIVISION_ID	   
	    AND D.PROJECT_CODE  = A.PROJECT_CODE
    LEFT JOIN [SCM_MST_SITE] S WITH(NOLOCK) 
	    ON  D.SCM_SITE_ID   = S.SCM_SITE_ID
	    AND S.VALID_YN      = 'Y'
    LEFT JOIN TEMP_DM_MST_ITEM_SINGLE_V T WITH(NOLOCK)
        ON  I.DIVISION_ID   = T.DIVISION_ID 
        AND D.ITEM_ID       = T.ITEM_ID
    LEFT JOIN (
                SELECT B.USER_ID, B.USER_NAME, B.USER_NAME_EN, B.DEPT_ID, C.DEPT_NAME_KO, C.UPPER_DEPT_ID 
                FROM [SCM_MST_SSO_USER_INFO] AS B WITH(NOLOCK)
                INNER JOIN SCM_MST_SSO_DEPT_INFO AS C WITH(NOLOCK)
                ON B.DEPT_ID = C.DEPT_ID ) AS TEAM
        ON  TEAM.USER_ID IN (SELECT top 1 token FROM [dbo].[String_Split](D.owner, ','))
    LEFT JOIN (
                SELECT  SEGMENT1 AS CODE, SEGMENT2 AS NAME
                FROM    SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK) 
                WHERE   VALID_YN ='Y' 
                AND     LOOKUP_TYPE = 'ITEM_TYPE_CODE'
	            )  AS ITEM_TYPE_CODE
        ON T.ITEM_TYPE = ITEM_TYPE_CODE.CODE
    LEFT OUTER JOIN TMP_81_UC_EXCEPTION  EX ON EX.DIVISION_ID = D.DIVISION_ID AND EX.ITEM_ID = D.ITEM_ID  --[E20231019-001234] DM시스템의 모델코드 사용중지 정보 제공 개선
    WHERE   I.DIVISION_ID       = @p_division_id   -- DIVISION 이 자동차인 경우에는 SITE-ITEM에 연결된것 만 조회 
    AND   I.DIVISION_ID    LIKE '81%'    
    AND   I.VALID_YN          = 'Y'   
    AND   S.SITE_TYPE         = 'SALES'
    AND CASE WHEN @p_dept_id = 'ALL' THEN 'ALL'
        ELSE TEAM.DEPT_ID
         END IN (
                SELECT  *
                FROM    dbo.UF_FX_String_SplitForIN (@p_dept_id,',') AS P 
                WHERE   (CASE WHEN @p_dept_id = 'ALL' THEN 'ALL' ELSE TEAM.DEPT_ID END) = P.data
                )
    AND CASE WHEN @p_end_customer = 'ALL' THEN 'ALL'
        ELSE ISNULL(S.END_CUSTOMER,'')
         END IN (
                SELECT  * 
                FROM    dbo.UF_FX_String_SplitForIN (@p_end_customer,',') AS P 
                WHERE   (CASE WHEN @p_end_customer = 'ALL' THEN 'ALL' ELSE isnull(S.END_CUSTOMER,'') END) = P.data
                )				   
    AND CASE WHEN @p_scm_site_id = 'ALL' THEN 'ALL'
        ELSE S.SCM_SITE_ID			
            END IN (
                SELECT  *
                FROM    dbo.UF_FX_String_SplitForIN (@p_scm_site_id,',') as P 
                WHERE   (CASE WHEN @p_scm_site_id = 'ALL' THEN 'ALL' ELSE S.SCM_SITE_ID END) = P.data
                )
    AND (
		 EXISTS (SELECT * FROM dbo.UF_FX_String_Split (@p_project_code,',') as P Where D.PROJECT_CODE LIKE P.token +'%')
	     OR
		 EXISTS (SELECT * FROM dbo.UF_FX_String_Split (@p_project_code,',') as P Where A.PROJECT_NAME LIKE P.token +'%')
		)
    AND (
		 EXISTS (SELECT * FROM dbo.UF_FX_String_Split (@p_item_id,',') as P Where D.ITEM_ID LIKE P.token +'%')
		  OR
		 EXISTS (SELECT * FROM dbo.UF_FX_String_Split (@p_item_id,',') as P Where T.nick_name LIKE P.token +'%')
		)	 -- 20181205 nick name 조회요청으로 변경
	--[E20231019-001234] DM시스템의 모델코드 사용중지 정보 제공 개선 
	AND CASE WHEN @p_division_id = '81_UC' THEN 
                CASE WHEN ISNULL(@p_mdmActive_Sw, '') = '' THEN ''  ELSE ISNULL(T.ACTIVE_FLAG,EX.ACTIVE_FLAG)  END
		ELSE 
			    CASE WHEN ISNULL(@p_mdmActive_Sw, '') = '' THEN ''  ELSE T.ACTIVE_FLAG END
		END = CASE WHEN ISNULL(@p_mdmActive_Sw, '') = '' THEN ''  ELSE 'Y' END
    UNION
    SELECT    I.DIVISION_ID
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
    FROM    [SCM_MST_DIVISION] I WITH(NOLOCK) 
    LEFT JOIN   [SCM_MST_SITE_ITEM] D WITH(NOLOCK)  
    ON  I.DIVISION_ID   = D.DIVISION_ID
    AND D.VALID_YN      = 'Y'
    LEFT JOIN [SCM_MST_PROJECT] A WITH(NOLOCK)
    ON  I.DIVISION_ID   = D.DIVISION_ID	   
    AND D.PROJECT_CODE  = A.PROJECT_CODE
    LEFT JOIN [SCM_MST_SITE] S WITH(NOLOCK) 
    ON  I.DIVISION_ID   = D.DIVISION_ID	   
    AND D.SCM_SITE_ID   = S.SCM_SITE_ID   
    AND S.VALID_YN      = 'Y' 
    LEFT OUTER JOIN TEMP_DM_MST_ITEM_SINGLE_V  T WITH(NOLOCK)
        ON  I.DIVISION_ID       = T.DIVISION_ID 
        AND D.ITEM_ID           = T.ITEM_ID 
        AND T.ITEM_TYPE    NOT IN ( 'H', 'R')  
        AND T.ITEM_ID        LIKE 'E%' -- 자재 반재품 는 제외
    LEFT JOIN (
                SELECT B.USER_ID, B.USER_NAME, B.USER_NAME_EN, B.DEPT_ID, C.DEPT_NAME_KO, C.UPPER_DEPT_ID 
                FROM [SCM_MST_SSO_USER_INFO] AS B WITH(NOLOCK)
                INNER JOIN SCM_MST_SSO_DEPT_INFO AS C WITH(NOLOCK)
                ON B.DEPT_ID = C.DEPT_ID
                ) AS TEAM
        ON  TEAM.USER_ID IN (SELECT TOP 1 TOKEN FROM [dbo].[String_Split](D.owner, ','))
    LEFT JOIN ( SELECT  SEGMENT1 AS CODE, SEGMENT2 AS NAME
                FROM    SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK) 
                WHERE   LOOKUP_TYPE = 'ITEM_TYPE_CODE'
                AND     VALID_YN    = 'Y' 
                )  AS ITEM_TYPE_CODE
        ON T.ITEM_TYPE  = ITEM_TYPE_CODE.CODE
    WHERE   I.DIVISION_ID   = @p_division_id   
    AND     I.DIVISION_ID   = '82'
    AND     I.VALID_YN      = 'Y'
    AND     S.SITE_TYPE     = 'SALES'
    AND CASE WHEN @p_dept_id = 'ALL' THEN 'ALL'
        ELSE TEAM.DEPT_ID			
         END IN (
                Select * from dbo.UF_FX_String_SplitForIN (@p_dept_id,',') as P Where 
                (CASE WHEN @p_dept_id = 'ALL' THEN 'ALL' ELSE TEAM.DEPT_ID END) = P.data
                )
    AND CASE WHEN @p_end_customer = 'ALL' THEN 'ALL'
        ELSE ISNULL(S.END_CUSTOMER,'')			
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
        OR
        Exists (Select * from dbo.UF_FX_String_Split (@p_item_id,',') as P Where T.nick_name LIKE P.token +'%')
        )	 -- 20181205 nick name 조회요청으로 변경
	 --[E20231019-001234] DM시스템의 모델코드 사용중지 정보 제공 개선
    AND CASE WHEN ISNULL(@p_mdmActive_Sw, '') = '' THEN ''  ELSE T.ACTIVE_FLAG END = CASE WHEN ISNULL(@p_mdmActive_Sw, '') = '' THEN ''  ELSE 'Y' END --20231127 
    UNION -- 20180611 소형 추가, 42, 44
    SELECT    I.DIVISION_ID
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
    FROM  [SCM_MST_DIVISION] I WITH(NOLOCK) 
    LEFT JOIN [SCM_MST_SITE_ITEM] D WITH(NOLOCK) 
        ON  I.DIVISION_ID   = D.DIVISION_ID 
        AND D.VALID_YN      = 'Y'
    LEFT JOIN SCM_MST_SSO_USER_INFO USER_INFO WITH(NOLOCK) 			       
        ON  D.OWNER = USER_INFO.USER_ID 
    LEFT JOIN SCM_MST_SSO_DEPT_INFO TEAM WITH(NOLOCK) 			       
	    ON  USER_INFO.DEPT_ID   = TEAM.DEPT_ID 
	    AND TEAM.VALID_YN       = 'Y' 
    LEFT JOIN [SCM_MST_SITE] S WITH(NOLOCK) 
	    ON  I.DIVISION_ID   = D.DIVISION_ID	   
        AND D.SCM_SITE_ID   = S.SCM_SITE_ID   
        AND S.VALID_YN      ='Y' 
    LEFT JOIN TEMP_DM_MST_ITEM_SINGLE_V     T WITH(NOLOCK)
	   ON   I.DIVISION_ID   = T.DIVISION_ID 
       AND  D.ITEM_ID       = T.ITEM_ID
    LEFT JOIN   (
                SELECT  SEGMENT1 AS CODE, SEGMENT2 AS NAME
                FROM    SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK) 
                WHERE   LOOKUP_TYPE = 'ITEM_TYPE_CODE'
                AND     VALID_YN    = 'Y' 
	            )  AS ITEM_TYPE_CODE
        ON T.ITEM_TYPE = ITEM_TYPE_CODE.CODE
    LEFT OUTER JOIN TMP_81_UC_EXCEPTION  EX ON EX.DIVISION_ID = D.DIVISION_ID AND EX.ITEM_ID = D.ITEM_ID --[E20231019-001234] DM시스템의 모델코드 사용중지 정보 제공 개선
    WHERE   I.DIVISION_ID       = @p_division_id		-- 20190123  
    AND     I.DIVISION_ID    LIKE '4%'    
    AND     I.VALID_YN          = 'Y'   
    AND     S.SITE_TYPE         = 'SALES'
    AND     CASE WHEN @p_dept_id = 'ALL' THEN 'ALL'
            ELSE TEAM.DEPT_ID			
			 END IN (
					Select * from dbo.UF_FX_String_SplitForIN (@p_dept_id,',') as P Where 
					(CASE WHEN @p_dept_id = 'ALL' THEN 'ALL' ELSE TEAM.DEPT_ID END) = P.data
	                )
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
    AND (
        Exists (Select * from dbo.UF_FX_String_Split (@p_item_id,',') as P Where D.ITEM_ID LIKE P.token +'%')
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

