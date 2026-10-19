



/*
 * Program ID   : SSP0021_GET_SHIPMENT_DIVISION
 * Description  : DIVISION , COMPANY 정보
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *=================================================================================================== 
 * 2020/07/15   khj79          DIVISION , COMPANY 정보
 * 2024/10/01   KHJ            NERP_SSP
 * 2026/03/19   강주용		   [E20260206-001938] VP 권한 확장
 */

CREATE PROCEDURE [dbo].[SSP0021_GET_SHIPMENT_DIVISION]   
   @Param1 NVARCHAR(100)
 , @Param2 NVARCHAR(100) 
AS
BEGIN
	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	
	-- NERP 매핑코드
	DECLARE @v_G480			NVARCHAR(20);
	DECLARE @v_G670			NVARCHAR(20);
	DECLARE @v_G450			NVARCHAR(20);
	DECLARE @v_G630			NVARCHAR(20);
	SET @v_G480 = dbo.FN_GET_LOOKUP_VALUE('SSP0021_GET_SHIPMENT_DIVISION'  ,'G480' );
	SET @v_G670 = dbo.FN_GET_LOOKUP_VALUE('SSP0021_GET_SHIPMENT_DIVISION'  ,'G670' );
	SET @v_G450 = dbo.FN_GET_LOOKUP_VALUE('SSP0021_GET_SHIPMENT_DIVISION'  ,'G450' );
	SET @v_G630 = dbo.FN_GET_LOOKUP_VALUE('SSP0021_GET_SHIPMENT_DIVISION'  ,'G630' );

	BEGIN	
		-- START [E20260206-001938] VP 권한 확장
		IF OBJECT_ID('tempdb..##returnTable') IS NOT NULL
		DROP TABLE #returnTable
		-- END [E20260206-001938] VP 권한 확장

		Declare @AuthTypeParaDivisionOut40 varchar(100) = 'D'		   
		if(@Param1 = 'JV Planner') SET @AuthTypeParaDivisionOut40 = 'J';

		-- START [E20260206-001938] VP 권한 확장
		SELECT CODE,  MAX(NAME) AS NAME, MAX(ATTRIBUTE1) AS ATTRIBUTE1
		  INTO #returnTable
		  FROM 
		  (--일반권한
		-- END [E20260206-001938] VP 권한 확장
		  SELECT DIVISION_ID AS CODE, DIVISION_ID + ' ' + MIN([DIVISION_NAME]) AS NAME
		       , 1 AS ATTRIBUTE1 -- [E20260206-001938] VP 권한 확장
			FROM [dbo].[SCM_MST_DIVISION] WITH(NOLOCK)
		   WHERE DIVISION_ID IN (SELECT CODE FROM TB_FX_UserGroupAuthExtention AS A WITH(NOLOCK) WHERE GroupID = @Param1 AND UserID = @Param2 AND AuthType = @AuthTypeParaDivisionOut40)
		   AND DIVISION_ID != '40' 		   
		   AND ATTRIBUTE3 != 'EE'
		   AND DIVISION_ID NOT IN ('81_UC') -- 포함하지 않을 DIVISION 지정, 조건은 알아서 변경할것
		   GROUP BY DIVISION_ID
		-- START [E20260206-001938] VP 권한 확장 
		UNION --VP 추가 권한
		   SELECT DIVISION_ID AS CODE, DIVISION_ID + ' ' + MIN([DIVISION_NAME]) AS NAME, 0 AS ATTRIBUTE1
			FROM [dbo].[SCM_MST_DIVISION] WITH(NOLOCK)
		   WHERE DIVISION_ID IN (SELECT VS.DIVISION_ID
								   FROM SCM_MST_SITE AS VS WITH(NOLOCK) 
								   JOIN SCM_MST_SITE AS FS WITH(NOLOCK) 
								     ON VS.ATTRIBUTE9 = FS.SCM_SITE_ID
								   JOIN TB_FX_UserGroupAuthExtention AS A WITH(NOLOCK) 
								     ON FS.DIVISION_ID = A.CODE
								    AND FS.SITE_TYPE = 'PLANT'
							      WHERE A.AuthType = @AuthTypeParaDivisionOut40
								    AND A.GroupID  = @Param1 
								    AND A.UserID   = @Param2
								    AND FS.DIVISION_ID NOT IN ('81_UC') -- 포함하지 않을 DIVISION 지정, 조건은 알아서 변경할것
								    AND FS.DIVISION_ID != '40' 		   
                                 )
			 AND DIVISION_ID NOT IN ('81_UC') -- 포함하지 않을 DIVISION 지정, 조건은 알아서 변경할것
			 AND DIVISION_ID != '40' 		   
		     AND ATTRIBUTE3 != 'EE'
		   GROUP BY DIVISION_ID
		   ) A 
		   GROUP BY CODE
		   ;

		   SELECT *
		     FROM #returnTable
		    ORDER BY CODE ASC
		   ;
		   
		-- 일반 권한
		 SELECT CODE, NAME, DIVISION_ID 
		 FROM (
		-- END [E20260206-001938] VP 권한 확장
		SELECT
			S.COMPANY_ID AS CODE, D.SEGMENT2 AS NAME, S.DIVISION_ID
		FROM SCM_MST_SITE S WITH(NOLOCK)
		INNER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL D WITH(NOLOCK)
			ON S.COMPANY_ID = D.SEGMENT1 AND D.LOOKUP_TYPE = 'COMPANY_DESC'
		WHERE 1 = 1
		AND S.SITE_TYPE = 'PLANT'
		--AND 
		--AND S.COMPANY_ID NOT IN ('G480','G670') -- 포함하지 않을 COMPANY 지정, 조건은 알아서 변경할것
		AND (		S.COMPANY_ID != @v_G480 
				AND	S.COMPANY_ID != @v_G670
				--AND S.COMPANY_ID != @v_G450
				--AND S.COMPANY_ID != @v_G630
			) -- 표시하고자 하는 COMPANY 지정
		-- START [E20260206-001938] VP 권한 확장
		AND S.DIVISION_ID IN (SELECT CODE FROM #returnTable WHERE ATTRIBUTE1 = 1)
		GROUP BY S.COMPANY_ID, D.SEGMENT2, S.DIVISION_ID
		
		-- VP 추가 권한
		UNION 
		SELECT
			S.COMPANY_ID AS CODE, D.SEGMENT2 AS NAME, S.DIVISION_ID
		FROM SCM_MST_SITE S WITH(NOLOCK)
		INNER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL D WITH(NOLOCK)
			ON S.COMPANY_ID = D.SEGMENT1 AND D.LOOKUP_TYPE = 'COMPANY_DESC'
		WHERE 1 = 1
		AND S.SITE_TYPE = 'PLANT'
		AND (		S.COMPANY_ID != @v_G480 
				AND	S.COMPANY_ID != @v_G670
			)
		AND S.ATTRIBUTE9 IN (SELECT FS.SCM_SITE_ID
								FROM SCM_MST_SITE AS FS WITH(NOLOCK) 
								JOIN TB_FX_UserGroupAuthExtention AS A WITH(NOLOCK) 
								  ON FS.DIVISION_ID = A.CODE
								 AND FS.SITE_TYPE = 'PLANT'
							   WHERE A.AuthType = @AuthTypeParaDivisionOut40
								 AND A.GroupID  = @Param1 
								 AND A.UserID   = @Param2
								 AND FS.DIVISION_ID NOT IN ('81_UC') -- 포함하지 않을 DIVISION 지정, 조건은 알아서 변경할것
								 AND FS.DIVISION_ID != '40' 		   
								 AND FS.COMPANY_ID  != 'MI00'
						     )
		GROUP BY S.COMPANY_ID, D.SEGMENT2, S.DIVISION_ID
		
		) source
		GROUP BY CODE, NAME, DIVISION_ID

		DROP TABLE #returnTable
       -- END [E20260206-001938] VP 권한 확장

	END	

END
