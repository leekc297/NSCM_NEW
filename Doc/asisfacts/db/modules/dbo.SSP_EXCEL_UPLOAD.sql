
/*
 * Program ID   : ExcelUploadForm2
 * Description  : 엑셀 업로드 파일 유효성 체크
 * Program History
 *===========================================================================================================
 *   Date       In Charge		Description
 *===========================================================================================================
 * 2019/04/19	MCTHEJ			[PJ20189106] 전지.GSCM 고도화 이행- PRODUCTION PLAN OSP UPLOAD
 * 2019/08/01	AYJ				[CSR ID:4030199] SSP Distribution route엑셀 업로드를 통한 신규등록/수정기능 구현
 */

 CREATE PROCEDURE [dbo].[SSP_EXCEL_UPLOAD]
	@p_program_id  NVARCHAR(200),
	@p_sheet_name  NVARCHAR(200)
AS

BEGIN
    SET NOCOUNT ON;

	IF @p_program_id = 'SSP0018'
	BEGIN
		IF @p_sheet_name = 'Production Plan(OSP)'
		BEGIN
			SELECT 
				DIVISION_ID,      SCM_SITE_ID   AS PLANT_SITE_CODE
			FROM SCM_MST_SITE WITH(NOLOCK) 
			WHERE DIVISION_ID = '40'--@P_DIVISION_ID 
			AND   SITE_TYPE  = 'PLANT'
			AND   OSP_YN  = 'Y'
			AND   VALID_YN = 'Y';

			SELECT 
				ITEM_ID  AS MODEL 
			FROM SCP_MST_FINAL_ITEM_V WITH(NOLOCK) ;
		END
	END

	IF @p_program_id = 'SCP0005'
	BEGIN
		IF @p_sheet_name = 'Distribution Route'
		BEGIN
			--LT TYPE, TRANS MODE 
			SELECT LOOKUP_TYPE
				 , SEGMENT1 --CODE
			FROM SCM_ADM_LOOKUP_MASTER_DETAIL
			WHERE VALID_YN = 'Y'

			--COUNTRY, CITY
			SELECT COUNTRY
				 , CITY
			FROM SCM_MST_CITY WITH(NOLOCK)
			WHERE  VALID_YN = 'Y'

			--PRIORITY
			SELECT FROM_COUNTRY
				 , FROM_CITY 
				 , PRIORITY
				 , TO_COUNTRY
				 , TO_CITY
			 FROM SCP_MST_DISTRIBUTION_ROUTE WITH(NOLOCK)
			WHERE 1 = 1

			--데이터 중복체크
			SELECT FROM_COUNTRY
				 , FROM_CITY
				 , TRANSPORT_MODE
				 , D_COUNTRY
				 , D_PORT_CODE
				 , REPLACE(D_PORT_NAME, ' ', '') AS D_PORT_NAME
				 , A_COUNTRY
				 , A_PORT_CODE
				 , REPLACE(A_PORT_NAME, ' ', '') AS A_PORT_NAME
				 , SHIPPING_COMPANY
				 , TO_COUNTRY
				 , TO_CITY
				 , LT_TYPE
			 FROM SCP_MST_DISTRIBUTION_ROUTE WITH(NOLOCK)
			WHERE 1 = 1

			--데이터 중복체크
			SELECT ROUTE_ID
				 , FROM_COUNTRY
				 , FROM_CITY
				 , TRANSPORT_MODE
				 , D_COUNTRY
				 , D_PORT_CODE
				 , REPLACE(D_PORT_NAME, ' ', '') AS D_PORT_NAME
				 , A_COUNTRY
				 , A_PORT_CODE
				 , REPLACE(A_PORT_NAME, ' ', '') AS A_PORT_NAME
				 , SHIPPING_COMPANY
				 , TO_COUNTRY
				 , TO_CITY
				 , LT_TYPE
			 FROM SCP_MST_DISTRIBUTION_ROUTE WITH(NOLOCK)
			WHERE 1 = 1			
			
			SELECT ROUTE_ID
			 FROM SCP_MST_DISTRIBUTION_ROUTE WITH(NOLOCK)
			WHERE 1 = 1



		END
	END
	
END;	
