---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/***************************************************************************************************
 Program ID  : DMF0043_GET_CONT_VIEW_VERSIONPOPUP                                                 
 Description : Procedure 작성 가이드                                                              
 Usage       : Procedure 작성 시 참조하세요!                                                      
 Parameter   :                                                                                    
                                                                                                  
--------------------------------------------------------------------------------------------------
 Date        In Charge    Description                                                             
--------------------------------------------------------------------------------------------------
 2019/08/19  JYE       Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트    
 2020/01/28  P.C.I     [CSR ID:prepare] Report Plan List 조회로 변경                              
 2020/06/12  HWI1993	[C20200605-000077] GSCM 해외법인 기여율 매출 버전 리스트 정리 요청의 건 
 2021/07/03	HWI1993		하반기과제 속도개선 - 데이터 이동보관 처리       
**************************************************************************************************/
CREATE PROCEDURE [dbo].[DMF0043_GET_CONT_VIEW_VERSIONPOPUP]
    @p_start_yyyymmdd  NVARCHAR(8),
    @p_end_yyyymmdd    NVARCHAR(8),
	--@p_created_by	   NVARCHAR(50),
	@p_division_id	   NVARCHAR(MAX),
	@p_version_type	   NVARCHAR(MAX),
	--@p_version_no	   NVARCHAR(MAX),
	@p_description	   NVARCHAR(1000)
AS
BEGIN
	
    SET NOCOUNT ON;
	/*
	   SELECT VERSION_NO AS CODE, VERSION_NO, VERSION_DESCRIPTION, VERSION_TYPE, VER_CRE_SEQ, YYYYMMDD, MAX(CREATED_BY), MAX(CREATION_DATE)
		 FROM [dbo].[DM_MST_VERSION]  WITH(NOLOCK)
	   WHERE (YYYYMMDD >= @p_start_yyyymmdd and YYYYMMDD <= @p_end_yyyymmdd)  
		  AND DIVISION_ID IN (SELECT token FROM dbo.String_Split(@p_division_id	,','))  		
		  AND VERSION_TYPE IN (SELECT token FROM dbo.String_Split(@p_version_type	,','))    
		  AND Exists (Select * from dbo.UF_FX_String_Split (@p_version_no,',') as P Where [VERSION_NO] LIKE P.token +'%')
	   GROUP BY VERSION_NO , VERSION_NO, VERSION_DESCRIPTION, VERSION_TYPE, VER_CRE_SEQ, YYYYMMDD
	   ORDER BY CODE DESC, VERSION_NO DESC*/

	    
		SELECT VERSION_NO AS CODE, VERSION_NO, VERSION_DESCRIPTION, VERSION_TYPE, VER_CRE_SEQ, YYYYMMDD, MAX(CREATED_BY), MAX(CREATION_DATE)
		FROM DM_MDF_VERSION
		WHERE 
			DIVISION_ID = @p_division_id
			AND YYYYMMDD BETWEEN @p_start_yyyymmdd AND @p_end_yyyymmdd
			AND VERSION_TYPE = @p_version_type
			AND VERSION_DESCRIPTION LIKE '%' + @p_description + '%'
			AND SEND_YN <> 'D'
			AND ISNULL(ATTRIBUTE1,'') <> 'MOVE'
	   GROUP BY VERSION_NO , VERSION_NO, VERSION_DESCRIPTION, VERSION_TYPE, VER_CRE_SEQ, YYYYMMDD
	   ORDER BY CODE DESC, VERSION_NO DESC
		 
END



