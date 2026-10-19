
/*
 * Program ID   : [DMF0071_GET_BPCUTOFF_LIST]
 * Description  : 
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2024-03-13   KJJ				LGES SCM 역량 강화 위한 SCP 개선과제 이행
 * ex)
    EXEC DMF0071_GET_BPCUTOFF_LIST '81','20230501','20240914','','','','',''
 */
CREATE PROCEDURE [dbo].[DMF0071_GET_BPCUTOFF_LIST]
 (
  	 @P_DIVISION_ID		NVARCHAR(30)
	 ,@P_FROMDT			NVARCHAR(8)  
	 ,@P_TODT			NVARCHAR(8)  
	 ,@P_FCST_VER		NVARCHAR(50) = ''
	 ,@P_RTF_VER		NVARCHAR(50) = ''
	 ,@P_DESC			NVARCHAR(MAX)
	 ,@P_BPYEAR			NVARCHAR(4)
	 ,@P_CUTOFF_YEAR	NVARCHAR(4)
 )
AS
BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	SET NOCOUNT ON;

	   SELECT 
			DIVISION_ID
			, VERSION_NO
			, VERSION_DESCRIPTION
		   ,ISNULL((
				SELECT TOP 1 TRANSFER_FLAG FROM DM_PLN_BIZPLAN_C  WITH(NOLOCK)
				WHERE DIVISION_ID = mv.division_id
				AND VERSION_NO = MV.VERSION_NO
		   ), 'N') BP_CONFIRM
		   ,ATTRIBUTE9 FCST_VERSION
		   ,SUBSTRING(ATTRIBUTE10, 1, LEN(ATTRIBUTE10) - 4) RTF_VERSION
			, VERSION_TYPE
			, CREATED_BY
			, CREATION_DATE
		 FROM [dbo].[DM_MST_VERSION] mv  WITH(NOLOCK)
	   WHERE (YYYYMMDD >= @P_FROMDT and YYYYMMDD <= @P_TODT)  
		  AND DIVISION_ID = @p_division_id
		  AND SUBSTRING(VERSION_NO, 3, 5) = 'BP_DM'
		  AND VERSION_TYPE = 'BP_M'
		  AND (@P_DESC = '' OR VERSION_DESCRIPTION LIKE '%' + @P_DESC + '%')
		  AND (@P_FCST_VER = '' OR ATTRIBUTE9 = @P_FCST_VER)
		  AND (@P_RTF_VER = '' OR ATTRIBUTE10 = @P_RTF_VER)
		  AND (@P_BPYEAR = '' OR VERSION_NO LIKE SUBSTRING(@P_BPYEAR, 3,2) + '%')
		  AND (@P_CUTOFF_YEAR = '' OR VERSION_NO LIKE '%' + @P_CUTOFF_YEAR + '%')
	   ORDER BY VERSION_NO DESC

END
