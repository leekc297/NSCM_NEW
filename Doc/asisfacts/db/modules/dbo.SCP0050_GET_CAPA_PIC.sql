

/*
 * Program ID   : SCP0050_GET_CAPA_PIC
 * Description  : MDM Auth Management
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2020/07/20   khj79          [PJ20199555] 공급 대응력 향상을 위한 자재재공 수급 점검 체계 개선 - 최초작성
 * 2020/07/21   khj79          SCM_MASTER_MANAGER_M_SN 컬럼 변경 CATEGORY_ID , KEY_ID => LOSS_CODE 로 변경
 * 2021/01/26   khj79          YEILD LINE TYPE(ELECTRODE_TYPE) 제외 - YIELD 는 LINE TYPE 이 없음
 * 2021/03/08   khj79          PIC 사용자(USER_4 , USER_ 5) 추가
 */



CREATE PROCEDURE [dbo].[SCP0050_GET_CAPA_PIC]
	 @p_division_id			NVARCHAR(20)
	,@p_plant_id			NVARCHAR(MAX)
	,@p_group_id			NVARCHAR(MAX)
	,@p_factory_id			NVARCHAR(MAX)
	,@p_line_id				NVARCHAR(MAX)
	,@p_operation_id		NVARCHAR(MAX)
	,@p_category_id			NVARCHAR(MAX)
	,@p_key_id				NVARCHAR(MAX)   -- 사용안함
	,@p_loss_code			NVARCHAR(MAX)
	,@p_manager_name		NVARCHAR(MAX)
	,@p_language			NVARCHAR(2)
	,@debug_mode			CHAR(1)

AS
BEGIN
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	WITH LINE_INFO
	AS (
			SELECT DISTINCT
				   COMPANY_ID
				 , DIVISION_ID
				 , SITE_ID
				 , PLANT_ID
				 , FACTORY_ID
				 , OPERATION_ID
				 , LINE_ID
				 , LINE_NAME
				 , ELECTRODE_TYPE
			  FROM SCM_LINE_M_SN A
			 WHERE 1=1
			   AND ACTIVE_FLAG = 'Y'
			   /** FP라인 유무 조건 막음....
			   AND EXISTS (SELECT 1
							 FROM FP_INSTANCE_LINE_V_SN B WITH(NOLOCK)
							WHERE 1=1
							  AND A.COMPANY_ID		= B.COMPANY_ID
							  AND A.SITE_ID			= B.SITE_ID
							  AND A.PLANT_ID		= B.PLANT_ID
							  AND A.DIVISION_ID		= B.DIVISION_ID
							  AND A.FACTORY_ID		= B.FACTORY_ID
							  AND A.OPERATION_ID	= B.OPERATION_ID
							  AND A.LINE_ID			= B.LINE_ID
							  AND A.ELECTRODE_TYPE	= B.ELECTRODE_TYPE
						)
			   */
			   AND (( @p_division_id  IS NULL OR @p_division_id  ='') OR A.DIVISION_ID  IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@p_division_id	, ',')))
			   AND (( @p_plant_id     IS NULL OR @p_plant_id     ='') OR A.PLANT_ID     IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@p_plant_id		, ',')))
			   AND (( @p_factory_id   IS NULL OR @p_factory_id   ='') OR A.FACTORY_ID   IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@p_factory_id	, ',')))
			   AND (( @p_line_id      IS NULL OR @p_line_id      ='') OR A.LINE_ID      IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@p_line_id		, ',')))
			   AND (( @p_operation_id IS NULL OR @p_operation_id ='') OR A.OPERATION_ID IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@p_operation_id	, ',')))
		)
	, LOOKUP
	AS (
			SELECT SEGMENT1   AS LOSS_CODE
				 , ATTRIBUTE1 AS CATEGORY_ID
				 , ATTRIBUTE2 AS KEY_ID
				 , ATTRIBUTE3 AS DATA_TABLE
				 , ATTRIBUTE4 AS OFF_CAL
				 , ATTRIBUTE5 AS FP_UTIL_CAL
				 , ATTRIBUTE6 AS SCP_UTIL_CAL
				 , SORT_ORDER	
			  FROM SCM_SYS_LOOKUP_VALUE_SN LV WITH(NOLOCK)
			 WHERE 1=1
			   AND LOOKUP_TYPE_CODE = 'CAPA_UI_LOSS_TYPE_DEFINIT'
			   AND ACTIVE_FLAG = 'Y'
			   --AND SEGMENT1 NOT IN ( 'M11' ) -- Quality(%)
			   AND ATTRIBUTE7 = 'Y'
			   AND (( @p_category_id IS NULL OR @p_category_id ='') OR LV.ATTRIBUTE1 IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@p_category_id	, ',')))
			   AND (( @p_loss_code   IS NULL OR @p_loss_code   ='') OR LV.SEGMENT1   IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@p_loss_code	, ',')))
		)
	, MAIN
	AS (
			SELECT A.*, B.LOSS_CODE , B.CATEGORY_ID, B.KEY_ID, B.SORT_ORDER
			  FROM LINE_INFO A
				 , LOOKUP B
		)


	
	SELECT A.DIVISION_ID
		 , A.COMPANY_ID
		 , A.SITE_ID
		 , A.PLANT_ID
		 , A.FACTORY_ID
		 , F.FACTORY_NAME
		 , A.LINE_ID
		 , A.LINE_NAME
		 , A.ELECTRODE_TYPE
		 , A.OPERATION_ID
		 , O.OPERATION_NAME
		 , A.CATEGORY_ID
		 , A.KEY_ID
		 , A.LOSS_CODE
		 , ISNULL(A.DEPARTMENT, CASE WHEN A.SITE_ID = 'A001' THEN C.DEPT_NAME_KO
									 WHEN A.SITE_ID = 'A002' THEN C.DEPT_NAME_CN
									 ELSE DEPT_NAME_EN	
								END) AS DEPARTMENT
		 , A.USER_ID_1
		 , C.USER_NAME	AS USER_NAME_1
		 , A.USER_ID_2
		 , D.USER_NAME	AS USER_NAME_2
		 , A.USER_ID_3
		 , E.USER_NAME	AS USER_NAME_3
		 , A.USER_ID_4
		 , H.USER_NAME	AS USER_NAME_4
		 , A.USER_ID_5
		 , I.USER_NAME	AS USER_NAME_5
		 , A.USER_ID_6
		 , U6.USER_NAME	AS USER_NAME_6
		 , A.USER_ID_7
		 , U7.USER_NAME	AS USER_NAME_7
		 , A.USER_ID_8
		 , U8.USER_NAME	AS USER_NAME_8
		 , A.USER_ID_9
		 , U9.USER_NAME	AS USER_NAME_9
		 , A.USER_ID_10
		 , U10.USER_NAME	AS USER_NAME_10
	  FROM (SELECT T1.DIVISION_ID
				 , T1.COMPANY_ID
				 , T1.SITE_ID
				 , T1.PLANT_ID
				 , T1.FACTORY_ID
				 , T1.LINE_ID
				 , T1.LINE_NAME
				 , T1.OPERATION_ID
				 , T1.ELECTRODE_TYPE
				 , T1.CATEGORY_ID
				 , T1.KEY_ID
				 , T1.LOSS_CODE
				 , B.USER_ID_1
				 , B.USER_ID_2
				 , B.USER_ID_3
				 , B.USER_ID_4
				 , B.USER_ID_5
				 , B.USER_ID_6
				 , B.USER_ID_7
				 , B.USER_ID_8
				 , B.USER_ID_9
				 , B.USER_ID_10
				 , B.DEPARTMENT
			  FROM MAIN T1
			  LEFT JOIN SCM_MASTER_MANAGER_M_SN B WITH(NOLOCK)  --기준정보별 담당자 정보
				ON 1 = 1
			   AND T1.COMPANY_ID	= B.COMPANY_ID
			   AND T1.DIVISION_ID	= B.DIVISION_ID
			   AND T1.SITE_ID		= B.SITE_ID
			   AND T1.PLANT_ID		= B.PLANT_ID
			   AND T1.FACTORY_ID	= B.FACTORY_ID
			   AND T1.OPERATION_ID	= B.OPERATION_ID
			   AND T1.LINE_ID		= B.LINE_ID
			   AND T1.LOSS_CODE		= B.LOSS_CODE
			   AND T1.ELECTRODE_TYPE = B.ELECTRODE_TYPE

			 WHERE T1.LOSS_CODE <> 'LA003'  -- YIELD 제외

			  UNION ALL

			 SELECT T1.DIVISION_ID
				 , T1.COMPANY_ID
				 , T1.SITE_ID
				 , T1.PLANT_ID
				 , T1.FACTORY_ID
				 , T1.LINE_ID
				 , T1.LINE_NAME
				 , T1.OPERATION_ID
				 , '-'				AS ELECTRODE_TYPE
				 , T1.CATEGORY_ID
				 , T1.KEY_ID
				 , T1.LOSS_CODE
				 , B.USER_ID_1
				 , B.USER_ID_2
				 , B.USER_ID_3
				 , B.USER_ID_4
				 , B.USER_ID_5
				 , B.USER_ID_6
				 , B.USER_ID_7
				 , B.USER_ID_8
				 , B.USER_ID_9
				 , B.USER_ID_10
				 , B.DEPARTMENT
			  FROM (SELECT DISTINCT 
						   COMPANY_ID
						 , DIVISION_ID 
						 , SITE_ID
						 , PLANT_ID
						 , FACTORY_ID
						 , OPERATION_ID
						 , LINE_ID
						 , LINE_NAME
						 , LOSS_CODE
						 , CATEGORY_ID
						 , KEY_ID
					   FROM MAIN ) T1
			  LEFT JOIN SCM_MASTER_MANAGER_M_SN B WITH(NOLOCK)  --기준정보별 담당자 정보
				ON 1 = 1
			   AND T1.COMPANY_ID	= B.COMPANY_ID
			   AND T1.DIVISION_ID	= B.DIVISION_ID
			   AND T1.SITE_ID		= B.SITE_ID
			   AND T1.PLANT_ID		= B.PLANT_ID
			   AND T1.FACTORY_ID	= B.FACTORY_ID
			   AND T1.OPERATION_ID	= B.OPERATION_ID
			   AND T1.LINE_ID		= B.LINE_ID
			   AND T1.LOSS_CODE		= B.LOSS_CODE

			 WHERE T1.LOSS_CODE = 'LA003'  -- YIELD 만 조회
			) A

	  JOIN SCM_OPERATION_M_SN O WITH(NOLOCK) -- OPERATION 정보
		ON A.DIVISION_ID	= O.DIVISION_ID
	   AND A.COMPANY_ID		= O.COMPANY_ID
	   AND A.SITE_ID		= O.SITE_ID
	   AND A.OPERATION_ID	= O.OPERATION_ID

	  JOIN SCM_MST_FACTORY_SN F WITH(NOLOCK) -- FACTORY 정보
		ON A.FACTORY_ID		= F.FACTORY_ID
	   AND A.COMPANY_ID		= F.COMPANY_ID


	  JOIN SCM_SITE_M_SN S WITH(NOLOCK)
		ON A.COMPANY_ID		= S.COMPANY_ID
	   AND A.SITE_ID		= S.SITE_ID

	  LEFT JOIN (SELECT A.USER_NAME, A.USER_ID, A.DEPT_ID, B.DEPT_NAME_KO, B.DEPT_NAME_EN, B.DEPT_NAME_CN
				   FROM SCM_MST_SSO_USER_INFO A WITH(NOLOCK)
					  , SCM_MST_SSO_DEPT_INFO B WITH(NOLOCK)
				  WHERE 1=1
					AND A.DEPT_ID = B.DEPT_ID
				) C
	    ON 1 = 1
	   AND A.USER_ID_1 = C.USER_ID

	  LEFT OUTER JOIN SCM_MST_SSO_USER_INFO D WITH(NOLOCK)
	    ON 1 = 1
	   AND A.USER_ID_2 = D.USER_ID

	  LEFT OUTER JOIN SCM_MST_SSO_USER_INFO E WITH(NOLOCK)
	    ON 1=1
	   AND A.USER_ID_3 = E.USER_ID

	    LEFT OUTER JOIN SCM_MST_SSO_USER_INFO H WITH(NOLOCK)
	    ON 1=1
	   AND A.USER_ID_4 = H.USER_ID

	    LEFT OUTER JOIN SCM_MST_SSO_USER_INFO I WITH(NOLOCK)
	    ON 1=1
	   AND A.USER_ID_5 = I.USER_ID

	   LEFT OUTER JOIN SCM_MST_SSO_USER_INFO U6 WITH(NOLOCK)
	    ON 1=1
	   AND A.USER_ID_6 = U6.USER_ID

	   LEFT OUTER JOIN SCM_MST_SSO_USER_INFO U7 WITH(NOLOCK)
	    ON 1=1
	   AND A.USER_ID_7 = U7.USER_ID

	   LEFT OUTER JOIN SCM_MST_SSO_USER_INFO U8 WITH(NOLOCK)
	    ON 1=1
	   AND A.USER_ID_8 = U8.USER_ID

	   LEFT OUTER JOIN SCM_MST_SSO_USER_INFO U9 WITH(NOLOCK)
	    ON 1=1
	   AND A.USER_ID_9 = U9.USER_ID

	   LEFT OUTER JOIN SCM_MST_SSO_USER_INFO U10 WITH(NOLOCK)
	    ON 1=1
	   AND A.USER_ID_10 = U10.USER_ID

	 WHERE ( (@p_manager_name  IS NULL OR @p_manager_name  ='')
	     OR (A.USER_ID_1 LIKE '%' + @p_manager_name + '%')
		 OR (A.USER_ID_2 LIKE '%' + @p_manager_name + '%')
		 OR (A.USER_ID_3 LIKE '%' + @p_manager_name + '%')
		 OR (A.USER_ID_4 LIKE '%' + @p_manager_name + '%')
		 OR (A.USER_ID_5 LIKE '%' + @p_manager_name + '%')
		 OR (A.USER_ID_6 LIKE '%' + @p_manager_name + '%')
		 OR (A.USER_ID_7 LIKE '%' + @p_manager_name + '%')
		 OR (A.USER_ID_8 LIKE '%' + @p_manager_name + '%')
		 OR (A.USER_ID_9 LIKE '%' + @p_manager_name + '%')
		 OR (A.USER_ID_10 LIKE '%' + @p_manager_name + '%')
		 OR (C.USER_NAME LIKE '%' + @p_manager_name + '%')
		 OR (D.USER_NAME LIKE '%' + @p_manager_name + '%')
		 OR (E.USER_NAME LIKE '%' + @p_manager_name + '%')
		 OR (H.USER_NAME LIKE '%' + @p_manager_name + '%')
		 OR (I.USER_NAME LIKE '%' + @p_manager_name + '%')
		 OR (U6.USER_NAME LIKE '%' + @p_manager_name + '%')
		 OR (U7.USER_NAME LIKE '%' + @p_manager_name + '%')
		 OR (U8.USER_NAME LIKE '%' + @p_manager_name + '%')
		 OR (U9.USER_NAME LIKE '%' + @p_manager_name + '%')
		 OR (U10.USER_NAME LIKE '%' + @p_manager_name + '%')
		  )

	ORDER BY A.PLANT_ID
		 , A.FACTORY_ID
		 , A.LINE_ID
		 , A.OPERATION_ID
		 , O.OPERATION_NAME
		 , CASE WHEN A.ELECTRODE_TYPE = '-' THEN 'ZZZ' ELSE A.ELECTRODE_TYPE END
		 , A.LOSS_CODE

END
