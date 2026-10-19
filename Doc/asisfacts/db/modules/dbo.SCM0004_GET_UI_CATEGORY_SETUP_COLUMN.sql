

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*
 * Program ID   : SCP0107_GET_CAPA_TEEP
 * Description  :
 * Program History
 *================================================================================================================================================
 * Date         In Charge                          Description
 *================================================================================================================================================
 * 2018/01/03   byunghunjung	                   Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018/05/18   byunghunjung	                   개발, 운영간 소스일치화
 * 2018/05/24   hwyoon			                   조회쿼리 수정(리턴값 콤보박스용 컬럼 5개 추가)
 * 2018/06/19	hwyoon			                   유저카테고리 조회 항목 추가
 * 2018/07/09	KYH				                   DIVISION_ID 추가
 * 2023/01/26	ChoiYS			                   Program Name 추가
 * 2024/02/19   chaan        V1.1.1                PJ20230692  SCM 역량 강화 위한 SCP 개선과제 이행 Phase2     - 이상 데이터 조회 가능하도록 수정(키값에 널값 포함...)
*/


CREATE PROCEDURE [dbo].[SCM0004_GET_UI_CATEGORY_SETUP_COLUMN]
	  @p_program_id						NVARCHAR(MAX)
	, @p_sheet_name						NVARCHAR(MAX)
	, @p_column_name					NVARCHAR(MAX)
	, @p_colmum_lavel_name				NVARCHAR(MAX)
	, @p_default_flag					NVARCHAR(MAX)
	, @p_valid_yn						NVARCHAR(MAX)
AS
BEGIN
	--DECLARE @p_program_id				NVARCHAR(MAX)			= N'';
	--DECLARE @p_sheet_name				NVARCHAR(MAX)			= N'';
	--DECLARE @p_column_name				NVARCHAR(MAX)			= N'';
	--DECLARE @p_colmum_lavel_name		NVARCHAR(MAX)			= N'';
	--DECLARE @p_default_flag				NVARCHAR(MAX)			= N'';
	--DECLARE @p_valid_yn					NVARCHAR(MAX)			= N'';

	
	SET NOCOUNT ON;

    SELECT  A.*
    FROM    (
	            SELECT	  C.PROGRAM_ID
			            , C.SHEET_NAME
			            , C.COLUMN_NAME
			            , C.COLUMN_LABEL_NAME
			            , C.SORT_ORDER_NO
			            , C.DATA_SORT_METHOD_CODE
			            , C.SMALL_CLASS_LABEL_NAME
			            , C.LARGE_CLASS_LABEL_NAME
			            , C.FIXED_FLAG
			            , C.COLUMN_WIDTH
			            , C.CELL_CONTROL_OBJECT_TYPE_CODE
			            , C.CELL_COMBO_DATA_TYPE
			            , C.DATA_SCALE_NUMBER
			            , C.DATA_MAX_LENGTH
			            , C.HORIZONTAL_ALIGN_CODE
			            , C.UPPERCASE_APPLY_FLAG
			            , C.VISIBLE_FLAG
			            , CASE WHEN DEFAULT_FLAG= 'NLL' THEN 'NULL' ELSE DEFAULT_FLAG END AS DEFAULT_FLAG
			            , C.USER_SELECTABLE_FLAG
			            , C.DIVISION_ID
			            , C.VALID_YN
			            , C.CREATED_BY
			            , C.CREATION_DATE
			            , C.LAST_UPDATED_BY
			            , C.LAST_UPDATE_DATE
			            , C.ATTRIBUTE1
			            , C.ATTRIBUTE2
			            , C.ATTRIBUTE3
			            , C.ATTRIBUTE4
			            , C.ATTRIBUTE5
			            , C.ATTRIBUTE6
			            , B.TITLE AS PROGRAM_NAME
                FROM	SCM_MST_SHEET_COLUMNS C
		                LEFT JOIN TB_FX_MENUITEMINFO B ON
					            C.PROGRAM_ID	= B.PROGRAMID
				            AND B.MENULEVEL		= 3
	            WHERE   1=1
		            AND (@p_program_id          IS NULL OR @p_program_id          = '' OR C.PROGRAM_ID LIKE '%'+ @p_program_id + '%' )
		            AND (@p_sheet_name          IS NULL OR @p_sheet_name          = '' OR C.SHEET_NAME LIKE '%'+ @p_sheet_name + '%' )
		            AND (@p_column_name         IS NULL OR @p_column_name         = '' OR C.COLUMN_NAME LIKE '%'+ @p_column_name + '%' )
		            AND (@p_colmum_lavel_name   IS NULL OR @p_colmum_lavel_name   = '' OR C.COLUMN_LABEL_NAME LIKE '%'+ @p_colmum_lavel_name + '%' )
		            --AND (C.DEFAULT_FLAG = @p_default_flag)
		            AND (@p_valid_yn           IS NULL OR @p_valid_yn             = '' OR C.VALID_YN = @p_valid_yn)
            ) A
    WHERE   1=1
        AND A.PROGRAM_ID IS NOT NULL 
        AND A.PROGRAM_ID <> ''
    ORDER BY A.PROGRAM_ID, A.SHEET_NAME, A.SORT_ORDER_NO
END
