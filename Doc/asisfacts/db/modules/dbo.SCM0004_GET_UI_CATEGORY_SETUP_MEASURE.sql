
/*===================================================================================================
 * Program ID   : SCM0004_GET_UI_CATEGORY_SETUP_MEASURE
 * Description  : UI CATEGORY SETUP MEASURE 조회
				  Admin > System > UI Category Setup
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2018/01/03   kimjaejung		Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018/07/09	KYH				DIVISION_ID 추가
 * 2019/02/8	YHW				[CSR:]ATTRIBUTE3(MEASURE COLOR) 추가
 * 2023/01/26	ChoiYS			Program Name 추가
 * 2025/07/09	JSSBAE			[E20250529-001488]_Sales Plan Waterfall 데이터 조회 로직 개선
 ===================================================================================================*/

CREATE PROCEDURE [dbo].[SCM0004_GET_UI_CATEGORY_SETUP_MEASURE]
	  @p_program_id			NVARCHAR(MAX)
	, @p_sheet_name			NVARCHAR(MAX)     
	, @p_column_name		NVARCHAR(MAX)      
	, @p_colmum_lavel_name  NVARCHAR(MAX)      
	, @p_default_flag		NVARCHAR(MAX)      
	, @p_valid_yn			NVARCHAR(MAX)

AS
BEGIN	
    SET NOCOUNT ON;
	SELECT C.PROGRAM_ID, C.SHEET_NAME, C.COLUMN_NAME, C.COLUMN_LABEL_NAME, C.SORT_ORDER_NO, C.SMALL_CLASS_LABEL_NAME
		 , C.LARGE_CLASS_LABEL_NAME, CASE WHEN C.DEFAULT_FLAG= '' THEN 'NULL' ELSE C.DEFAULT_FLAG END AS DEFAULT_FLAG
		 , C.USER_SELECTABLE_FLAG, C.DIVISION_ID, C.VALID_YN, C.CREATED_BY, C.CREATION_DATE, C.LAST_UPDATED_BY
		 , C.LAST_UPDATE_DATE, C.ATTRIBUTE3 AS MEASURE_COLOR, B.TITLE AS Program_Name
		----------------------------------------------------------------------------------------------------------------------------
		--[E20250529-001488]_SCM_MST_SHEET_MEASURE에서 ATTRIBUTE를 화면에서 보고 사용하고자 하는 니즈가 있어 해당 부분 노출되도록 추가 (START)
		 , C.ATTRIBUTE1, C.ATTRIBUTE2, C.ATTRIBUTE4, C.ATTRIBUTE5, C.ATTRIBUTE6, C.ATTRIBUTE7, C.ATTRIBUTE8, C.ATTRIBUTE9, C.ATTRIBUTE10  
		--[E20250529-001488]_SCM_MST_SHEET_MEASURE에서 ATTRIBUTE를 화면에서 보고 사용하고자 하는 니즈가 있어 해당 부분 노출되도록 추가 (END)
		----------------------------------------------------------------------------------------------------------------------------
	FROM SCM_MST_SHEET_MEASURE C WITH(NOLOCK)
	LEFT OUTER JOIN TB_FX_MenuItemInfo B WITH(NOLOCK)
				 ON C.PROGRAM_ID = B.PROGRAMID 
				AND B.MENULEVEL = 3
	WHERE 1=1
	AND (@p_program_id IS NULL OR C.PROGRAM_ID LIKE '%'+ @p_program_id + '%' )
	AND (@p_sheet_name IS NULL OR C.SHEET_NAME LIKE '%'+ @p_sheet_name + '%' )
	AND (@p_column_name IS NULL OR C.COLUMN_NAME LIKE '%'+ @p_column_name + '%' )
	AND (@p_colmum_lavel_name IS NULL OR C.COLUMN_LABEL_NAME LIKE '%'+ @p_colmum_lavel_name + '%' )
	--AND (c.DEFAULT_FLAG = @p_default_flag)
	AND (C.VALID_YN = @p_valid_yn)
    ORDER BY C.PROGRAM_ID, C.SHEET_NAME, C.SORT_ORDER_NO
END

