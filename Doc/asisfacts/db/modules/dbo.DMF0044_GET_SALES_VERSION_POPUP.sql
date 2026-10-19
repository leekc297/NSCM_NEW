

/*************************************************************************************************
 Program ID  : [DMF0044_GET_MDF_VERSION_POPUP]                                            
 Description : Procedure 작성 가이드                                                              
 Usage       : Procedure 작성 시 참조하세요!                                                      
 Parameter   :                                                                                    
                                                                                                  
--------------------------------------------------------------------------------------------------
 Date        In Charge    Description                                                             
--------------------------------------------------------------------------------------------------
 2019/05/27  JYE			      
 20191121		HWI1993		DMF0044_GET_SALES_VERSION_POPUP, DMF0044_GET_COPY_VERSION_POPUP 팝업 통합
							기존 팝업의 기능을 유지하기 위해 @p_Description 파라미터를 받아서 상황에 따라 VERSION_NO 또는 DESCRIPTION 에 걸어줌
							
 2020/06/10	hwi1993		날짜 검색조건을 yyyymmdd(CutoffDate) 에서 Creation_date 로 변경
 20200714     P.C.I       [PJ20200138] Created_by 'WITHOUT_SP_W' 는 제외(화요일에 Sales Paln Cutoff 제외하고 생성된 SP Version) 
 20200722     P.C.I       [PJ20200138] Created_by 'WITHOUT_SP_W' 는 제외 원복 
 2021/07/03	HWI1993		하반기과제 속도개선 - 데이터 이동보관 처리    
 DMF0044_GET_SALES_VERSION_POPUP '40', '20200501', '20200630', 'report_sp_w', ''		

***************************************************************************************************/
CREATE PROCEDURE [dbo].[DMF0044_GET_SALES_VERSION_POPUP]
	@p_division_id   NVARCHAR(30),
	@p_sdt			NVARCHAR(10),
	@p_edt			NVARCHAR(10),
	@p_version_type   NVARCHAR(50),
	@p_Description	NVARCHAR(1000)
AS
BEGIN
	
    SET NOCOUNT ON;

	IF @p_version_type LIKE 'REPORT%'
	BEGIN
		SELECT 
			DIVISION_ID,VERSION_NO, ORI_VERSION_NO AS ORI_VERSION
			,VERSION_DESCRIPTION,VERSION_TYPE
			, SEND_YN, VER_CRE_SEQ
			, CASE WHEN ATTRIBUTE1 = 'CP' AND ISDATE(ATTRIBUTE2) > 0 THEN LEFT(ATTRIBUTE2, 4) + '-' + SUBSTRING(ATTRIBUTE2, 5, 2) + '-' + RIGHT(ATTRIBUTE2, 2) ELSE NULL END AS YYYYMMDD
			, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY AS UPDATED_BY, LAST_UPDATE_DATE AS UPDATE_DATE
			, CASE WHEN ISNULL(MV_PLAN_YYYYMM,'') <> '' THEN LEFT(MV_PLAN_YYYYMM, 4) + N'-' + RIGHT(MV_PLAN_YYYYMM, 2) ELSE '' END AS MV_PLAN_YYYYMM
		FROM DM_MDF_VERSION
		WHERE 
			DIVISION_ID = @p_division_id
			--AND YYYYMMDD BETWEEN @p_sdt AND @p_edt
			AND CREATION_DATE >= dbo.FN_CHAR_TO_DATE(@p_sdt) 
			AND CREATION_DATE < DATEADD(DAY, 1, dbo.FN_CHAR_TO_DATE(@p_edt))
			AND VERSION_TYPE = @p_version_type
			AND VERSION_DESCRIPTION LIKE '%' + @p_Description + '%'
			AND SEND_YN <> 'D'
		ORDER BY CREATION_DATE DESC, VERSION_NO
	END
	ELSE
	BEGIN
		-- DIVISION_ID 를 넣어서 중복이 없으므로 GROUP BY 를 하지 않음.
		SELECT 	DIVISION_ID,VERSION_NO,VERSION_DESCRIPTION,VERSION_TYPE
			, NULL AS REPORT_DATE, NULL  AS SEND_YN
			, NULL AS YYYYMMDD
			, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY AS UPDATED_BY, LAST_UPDATE_DATE AS UPDATE_DATE
		FROM [dbo].[DM_MST_VERSION]  WITH(NOLOCK)
		WHERE (YYYYMMDD >= @p_sdt and YYYYMMDD <= @p_edt)  
		  AND DIVISION_ID = @p_division_id
		  AND VERSION_TYPE = @p_version_type
		  AND Exists (Select * from dbo.UF_FX_String_Split (@p_Description,',') as P Where [VERSION_NO] LIKE P.token +'%')
		  --AND CREATED_BY <> 'WITHOUT_SP_W' -- [PJ20200138] Created_by 'WITHOUT_SP_W' 는 제외
		  AND ISNULL(ATTRIBUTE1,'') <> 'MOVE'
	   ORDER BY CONVERT(CHAR(8), CREATION_DATE, 112) DESC, VERSION_NO

	END

END







