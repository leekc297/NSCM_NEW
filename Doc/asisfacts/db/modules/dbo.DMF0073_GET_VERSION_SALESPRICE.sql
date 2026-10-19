/************************************************************************************************
 Program ID  : DMF0073_GET_VERSION_SALESPRICE                                                        
 Description : Procedure 작성 가이드                                                             
 Usage       : Procedure 작성 시 참조하세요!                                                     
 Parameter   :                                                                                   
                                                                                                 
-------------------------------------------------------------------------------------------------
 Date        In Charge    Description                                                            
-------------------------------------------------------------------------------------------------
 2024/05/13  KJJ       신규생성
 * 2025.01.01	P.C.I			[PJ20228272] NERP 대응. No Plan 날짜 Start_date를 ISO_YYYYWW 기준으로 변경

******************************************************************************************************/


CREATE PROCEDURE [dbo].[DMF0073_GET_VERSION_SALESPRICE]
    @p_start_yyyymmdd  NVARCHAR(8),
    @p_end_yyyymmdd    NVARCHAR(8),
	@p_created_by	   NVARCHAR(50),
	@p_division_id	   NVARCHAR(MAX),
	@p_version_type	   NVARCHAR(MAX),
	@p_description	   NVARCHAR(MAX)

	-- EXEC DMF0073_GET_VERSION_SALESPRICE @p_start_yyyymmdd='20240401', @p_end_yyyymmdd='20240601', @p_created_by='20140001', @p_division_id='82', @p_version_type='SP_W', @p_description=''


AS
BEGIN
	
    SET NOCOUNT ON;

	SELECT 'SP_Z_CURRENT' AS CODE, 'Current' AS VERSION_NO, 'Current' VERSION_DESCRIPTION, '' VERSION_TYPE
			, '' EDI_APPLY,'' VER_CRE_SEQ, '' YYYYMMDD, '' CREATED_BY, GETDATE() CREATION_DATE 
			, '' MONTHLY_ROLLING_FCST , 'N' EDITABLE
	UNION ALL	
	SELECT VERSION_NO AS CODE
		, CASE WHEN C.DM_RTF_YN = 'N' 
				THEN CONCAT(VERSION_NO, '(',B.WEEK_NAME,') (NO PLAN)') 
				ELSE CONCAT(VERSION_NO, '(',B.WEEK_NAME,')')
				END AS VERSION_NO
		, VERSION_DESCRIPTION, VERSION_TYPE
		, (CASE WHEN VERSION_TYPE = 'ME_S' THEN 'Y'
					ELSE 'N' END) AS EDI_APPLY
		, VER_CRE_SEQ, YYYYMMDD, MAX(CREATED_BY), MAX(CREATION_DATE)
		, ISNULL(A.ATTRIBUTE7, 'N') MONTHLY_ROLLING_FCST
		, CASE WHEN B.ISO_WEEK = DATEPART(WEEK, GETDATE()) THEN 'Y' ELSE 'N' END EDITABLE --현재 주차만 수정가능
		FROM [dbo].[DM_MST_VERSION] AS A  WITH(NOLOCK)
	INNER JOIN SCM_SYS_CALENDAR_M AS B
		ON A.YYYYMMDD = B.BASIS_YYYYMMDD
	LEFT JOIN SCP_PLN_INTERFACE_YN AS C(NOLOCK)
		ON A.DIVISION_ID = C.DIVISION_ID
		--AND B.BASIS_START_DATE = C.PLAN_START_YYYYMMDD --[PJ20228272] NERP 대응. No Plan 날짜 Start_date를 ISO_YYYYWW 기준으로 변경
		AND ( SELECT MIN(BASIS_YYYYMMDD) FROM SCM_SYS_CALENDAR_M WITH(NOLOCK) WHERE  ISO_YYYYWW = B.ISO_YYYYWW) = C.PLAN_START_YYYYMMDD
	WHERE (YYYYMMDD >= @p_start_yyyymmdd and YYYYMMDD <= @p_end_yyyymmdd)  
		AND A.DIVISION_ID IN (SELECT token FROM dbo.String_Split(@p_division_id	,','))  		
		AND VERSION_TYPE IN (SELECT token FROM dbo.String_Split(@p_version_type	,','))    
		--AND Exists (Select * from dbo.UF_FX_String_Split (@p_version_no,',') as P Where [VERSION_NO] LIKE P.token +'%')
		AND VERSION_DESCRIPTION LIKE '%' + @p_description + '%'
		AND ISNULL(ATTRIBUTE1,'') <> 'MOVE'
	GROUP BY VERSION_NO , VERSION_NO, VERSION_DESCRIPTION, VERSION_TYPE, VER_CRE_SEQ, YYYYMMDD, B.WEEK_NAME, C.DM_RTF_YN,ISNULL(A.ATTRIBUTE7, 'N'), B.ISO_WEEK
	ORDER BY CODE DESC, VERSION_NO DESC

END
