/************************************************************************************************
 Program ID  : DM0035_GET_SPREAD_TITLE                                                           
 Description : Procedure 작성 가이드                                                             
 Usage       : Procedure 작성 시 참조하세요!                                                     
 Parameter   :                                                                                   
                                                                                                 
-------------------------------------------------------------------------------------------------
 Date        In Charge    Description                                                            
-------------------------------------------------------------------------------------------------
 2018/03/12  SeungJae.Hwnag       Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 20200714     P.C.I       [PJ20200138] Created_by 'WITHOUT_SP_W' 는 제외(화요일에 Sales Paln Cutoff 제외하고 생성된 SP Version)
 20200722     P.C.I       [PJ20200138] Created_by 'WITHOUT_SP_W' 는 제외 원복
 2021/07/03	HWI1993		하반기과제 속도개선 - 데이터 이동보관 처리  
 2021/12/13	  kdw2819	[과제 ]EDI Waterfall 조회 조건 추가      
 2022/02/24   kdw2819   [과제][PJ20216891R] LGES Digital SCM 3 Level 가속화를 위한 개선 - BMW EDI WATERFALL 
 2022/06/07	  kdw2819	business plan waterfall
 2022/06/22	  kdw2819	[C20220620-000557] GSCM DM 영역내, Version에 주차표기
 2022/09/30	  rosia27	[C20220929-000333] Plan이 없는 휴무 주차에는 PLAN명 뒤에 (NO PLAN)을 기입
 2023/05/03	kdmcc14	[EDI과제]
 2025/02/20   dsiol		[PJ2025-50017]LGES SCM DM 소형사업부 매출계획 동기화 개선			     -- 1. MF_SP 추가
 2025/04/23   dsiol		[PJ2025-50188]소형 매출계획 동기화 개선 고도화 : SCM_FCST - MEASURE 추가 -- 1. MF_SP를 MF_SP_SF으로 변경 / 2. MF_SF 추가
******************************************************************************************************/


CREATE PROCEDURE [dbo].[SCM0002_GET_VERSIONBYWATERFALLPOPUP]
    @p_start_yyyymmdd  NVARCHAR(8),
    @p_end_yyyymmdd    NVARCHAR(8),
	@p_created_by	   NVARCHAR(50),
	@p_division_id	   NVARCHAR(MAX),
	@p_version_type	   NVARCHAR(MAX),
	@p_version_no	   NVARCHAR(MAX)
AS
BEGIN
	
    SET NOCOUNT ON;
	DECLARE @V_VERSION_TYPE VARCHAR(100)

	   -- [과제 ]EDI Waterfall 조회 조건 추가 - EDI VERSION 조회시 CURRENT 제외
	   IF CHARINDEX('EC',@p_version_type) != 0 
	   BEGIN
	   		SELECT VERSION_NO AS CODE, CONCAT(VERSION_NO, '(',B.WEEK_NAME,')') AS VERSION_NO, VERSION_DESCRIPTION, VERSION_TYPE
					 , 'N' EDI_APPLY, VER_CRE_SEQ, YYYYMMDD, MAX(CREATED_BY) CREATED_BY, MAX(CREATION_DATE) CREATION_DATE
			 FROM [dbo].[DM_MST_VERSION]  AS A WITH(NOLOCK)
			 INNER JOIN SCM_SYS_CALENDAR_M AS B
			 ON A.YYYYMMDD = B.BASIS_YYYYMMDD
		   WHERE (YYYYMMDD >= @p_start_yyyymmdd and YYYYMMDD <= @p_end_yyyymmdd)  
			  AND DIVISION_ID IN (SELECT token FROM dbo.String_Split(@p_division_id	,','))  		
			  AND VERSION_TYPE IN (SELECT token FROM dbo.String_Split(@p_version_type	,','))    
			  AND Exists (Select * from dbo.UF_FX_String_Split (@p_version_no,',') as P Where [VERSION_NO] LIKE P.token +'%')
			  AND ISNULL(ATTRIBUTE1,'') <> 'MOVE'
			  --AND CREATED_BY <> 'WITHOUT_SP_W' -- [PJ20200138] Created_by 'WITHOUT_SP_W' 는 제외
		   GROUP BY VERSION_NO , VERSION_NO, VERSION_DESCRIPTION, VERSION_TYPE, VER_CRE_SEQ, YYYYMMDD, B.WEEK_NAME
		   ORDER BY CODE DESC, VERSION_NO DESC
	   END
	   ELSE IF CHARINDEX('BP',@p_version_type) != 0 
	   BEGIN
			SELECT 'BP_Z_CURRENT' AS CODE, 'Current' AS VERSION_NO, 'Current' VERSION_DESCRIPTION, '' VERSION_TYPE
					 , '' EDI_APPLY, '' VER_CRE_SEQ, '' YYYYMMDD, '' CREATED_BY, GETDATE() CREATION_DATE
			UNION ALL	
			SELECT VERSION_NO AS CODE, CONCAT(VERSION_NO, '(',B.WEEK_NAME,')') AS VERSION_NO, VERSION_DESCRIPTION, VERSION_TYPE
					 , 'N' EDI_APPLY, VER_CRE_SEQ, YYYYMMDD, CREATED_BY, CREATION_DATE  
			FROM [dbo].[DM_MST_VERSION] AS A WITH(NOLOCK)
			INNER JOIN SCM_SYS_CALENDAR_M AS B
		    ON A.YYYYMMDD = B.BASIS_YYYYMMDD
			WHERE (YYYYMMDD >= @p_start_yyyymmdd and YYYYMMDD <= @p_end_yyyymmdd)
			AND DIVISION_ID = @p_division_id 
			AND VERSION_TYPE IN (SELECT token FROM dbo.String_Split(@p_version_type	,','))  
			AND VERSION_DESCRIPTION like @p_version_no + '%'
			AND ISNULL(ATTRIBUTE1,'') <> 'MOVE'
			ORDER BY CODE DESC, VERSION_NO DESC
	   END
	   ELSE IF CHARINDEX('MF_SP_SF',@p_version_type) != 0 --[PJ2025-50188] MF_SP를 MF_SP_SF으로 변경
	   BEGIN							                  -- 작성기준 DMF0082_FcstNPrice_Mgmt.cs 에서 호출
		   SET @V_VERSION_TYPE = ''
		   --EXEC SCM0002_GET_VERSIONBYWATERFALLPOPUP '20250101','20250531','test','40','MF_SP_SF_D,MF_SP_SF_W,MF_SP_SF_M',''
		   IF CHARINDEX('MF_SP_SF_D',@p_version_type) != 0
				SET @V_VERSION_TYPE = 'SP_D,MF_D,SF_D,'
		   IF CHARINDEX('MF_SP_SF_W',@p_version_type) != 0
				SET @V_VERSION_TYPE = @V_VERSION_TYPE + 'SP_W,MF_W,SF_W,'				
		   IF CHARINDEX('MF_SP_SF_M',@p_version_type) != 0
				SET @V_VERSION_TYPE = @V_VERSION_TYPE + 'SP_M,MF_M,SF_M,'
		   
		   SET @V_VERSION_TYPE = LEFT(@V_VERSION_TYPE, LEN(@V_VERSION_TYPE)-1)

		   SELECT * FROM (
	   		   SELECT 'CURRENT' AS CODE, 'Current' AS VERSION_NO, 'Current' VERSION_DESCRIPTION, '' VERSION_TYPE
						, '' EDI_APPLY,'' VER_CRE_SEQ, '' YYYYMMDD, '' CREATED_BY, GETDATE() CREATION_DATE 
			   UNION ALL	
			   SELECT VERSION_NO AS CODE
					, CASE WHEN C.DM_RTF_YN = 'N' 
							THEN CONCAT(VERSION_NO, '(',B.WEEK_NAME,') (NO PLAN)') 
							ELSE CONCAT(VERSION_NO, '(',B.WEEK_NAME,')')
							END AS VERSION_NO
					, VERSION_DESCRIPTION, VERSION_TYPE
					, (CASE WHEN VERSION_TYPE = 'ME_S' THEN 'Y' ELSE 'N' END) AS EDI_APPLY
					, VER_CRE_SEQ, YYYYMMDD, MAX(CREATED_BY), MAX(CREATION_DATE)
				 FROM [dbo].[DM_MST_VERSION] AS A  WITH(NOLOCK)
			   INNER JOIN SCM_SYS_CALENDAR_M AS B
					ON A.YYYYMMDD = B.BASIS_YYYYMMDD
			   LEFT JOIN SCP_PLN_INTERFACE_YN AS C(NOLOCK)
					ON A.DIVISION_ID = C.DIVISION_ID
					AND B.BASIS_START_DATE = C.PLAN_START_YYYYMMDD
			   WHERE (YYYYMMDD >= @p_start_yyyymmdd and YYYYMMDD <= @p_end_yyyymmdd)  
				  AND A.DIVISION_ID IN (SELECT token FROM dbo.String_Split(@p_division_id	,','))  		
				  AND VERSION_TYPE IN (SELECT token FROM dbo.String_Split(@V_VERSION_TYPE	,','))    
				  AND Exists (Select * from dbo.UF_FX_String_Split (@p_version_no,',') as P Where [VERSION_NO] LIKE P.token +'%')
				  AND ISNULL(ATTRIBUTE1,'') <> 'MOVE'
				  --AND CREATED_BY <> 'WITHOUT_SP_W' -- [PJ20200138] Created_by 'WITHOUT_SP_W' 는 제외
			   GROUP BY VERSION_NO , VERSION_NO, VERSION_DESCRIPTION, VERSION_TYPE, VER_CRE_SEQ, YYYYMMDD, B.WEEK_NAME, C.DM_RTF_YN
		   )A
		   --팝업에 표시되는 기준 CURRENT가 제일 위, 그 다음은 코드에 상관없이 최근 생성 시간순으로 정렬 (필요시 아래 참고해서 변경바람)
		   ORDER BY CASE WHEN CODE = 'CURRENT'          THEN 1	--팝업에 표시되는 순서1
		                 --WHEN CHARINDEX('SP',CODE) <> 0 THEN 2 	--팝업에 표시되는 순서2
						 --WHEN CHARINDEX('MF',CODE) <> 0 THEN 3	--팝업에 표시되는 순서3
						 --WHEN CHARINDEX('SF',CODE) <> 0 THEN 4	--팝업에 표시되는 순서4
						 ELSE 5
						 --END, VERSION_NO DESC
						 END, CREATION_DATE DESC
	   END
	   ELSE IF CHARINDEX('MF_SF',@p_version_type) != 0 --[PJ2025-50188] 2. MF_SF 추가
	   BEGIN										   -- 작성기준 DMF0035_MktFcstWaterfall.cs 에서 호출
		   SET @V_VERSION_TYPE = ''
		   --EXEC SCM0002_GET_VERSIONBYWATERFALLPOPUP '20250101','20250531','test','40','MF_SF_D,MF_SF_W,MF_SF_M',''
		   IF CHARINDEX('MF_SF_D',@p_version_type) != 0
				SET @V_VERSION_TYPE = 'MF_D,SF_D,'
		   IF CHARINDEX('MF_SF_W',@p_version_type) != 0
				SET @V_VERSION_TYPE = @V_VERSION_TYPE + 'MF_W,SF_W,'				
		   IF CHARINDEX('MF_SF_M',@p_version_type) != 0
				SET @V_VERSION_TYPE = @V_VERSION_TYPE + 'MF_M,SF_M,'
		   
		   SET @V_VERSION_TYPE = LEFT(@V_VERSION_TYPE, LEN(@V_VERSION_TYPE)-1)

		   SELECT * FROM (
	   		   SELECT 'CURRENT' AS CODE, 'Current' AS VERSION_NO, 'Current' VERSION_DESCRIPTION, '' VERSION_TYPE
						, '' EDI_APPLY,'' VER_CRE_SEQ, '' YYYYMMDD, '' CREATED_BY, GETDATE() CREATION_DATE 
			   UNION ALL	
			   SELECT VERSION_NO AS CODE
					, CASE WHEN C.DM_RTF_YN = 'N' 
							THEN CONCAT(VERSION_NO, '(',B.WEEK_NAME,') (NO PLAN)') 
							ELSE CONCAT(VERSION_NO, '(',B.WEEK_NAME,')')
							END AS VERSION_NO
					, VERSION_DESCRIPTION, VERSION_TYPE
					, (CASE WHEN VERSION_TYPE = 'ME_S' THEN 'Y' ELSE 'N' END) AS EDI_APPLY
					, VER_CRE_SEQ, YYYYMMDD, MAX(CREATED_BY), MAX(CREATION_DATE)
				 FROM [dbo].[DM_MST_VERSION] AS A  WITH(NOLOCK)
			   INNER JOIN SCM_SYS_CALENDAR_M AS B
					ON A.YYYYMMDD = B.BASIS_YYYYMMDD
			   LEFT JOIN SCP_PLN_INTERFACE_YN AS C(NOLOCK)
					ON A.DIVISION_ID = C.DIVISION_ID
					AND B.BASIS_START_DATE = C.PLAN_START_YYYYMMDD
			   WHERE (YYYYMMDD >= @p_start_yyyymmdd and YYYYMMDD <= @p_end_yyyymmdd)  
				  AND A.DIVISION_ID IN (SELECT token FROM dbo.String_Split(@p_division_id	,','))  		
				  AND VERSION_TYPE IN (SELECT token FROM dbo.String_Split(@V_VERSION_TYPE	,','))    
				  AND Exists (Select * from dbo.UF_FX_String_Split (@p_version_no,',') as P Where [VERSION_NO] LIKE P.token +'%')
				  AND ISNULL(ATTRIBUTE1,'') <> 'MOVE'
				  --AND CREATED_BY <> 'WITHOUT_SP_W' -- [PJ20200138] Created_by 'WITHOUT_SP_W' 는 제외
			   GROUP BY VERSION_NO , VERSION_NO, VERSION_DESCRIPTION, VERSION_TYPE, VER_CRE_SEQ, YYYYMMDD, B.WEEK_NAME, C.DM_RTF_YN
		   )A
		   --팝업에 표시되는 기준 CURRENT가 제일 위, 그 다음은 코드에 상관없이 최근 생성 시간순으로 정렬 (필요시 아래 참고해서 변경바람)
		   ORDER BY CASE WHEN CODE = 'CURRENT'          THEN 1		--팝업에 표시되는 순서1
		                 --WHEN CHARINDEX('SP',CODE) <> 0 THEN 2 	--팝업에 표시되는 순서2
						 --WHEN CHARINDEX('MF',CODE) <> 0 THEN 3	--팝업에 표시되는 순서3
						 --WHEN CHARINDEX('SF',CODE) <> 0 THEN 4	--팝업에 표시되는 순서4
						 ELSE 5
						 --END, VERSION_NO DESC
						 END, CREATION_DATE DESC
	   END
	   ELSE
	   BEGIN
	   	   SELECT 'SP_Z_CURRENT' AS CODE, 'Current' AS VERSION_NO, 'Current' VERSION_DESCRIPTION, '' VERSION_TYPE
					, '' EDI_APPLY,'' VER_CRE_SEQ, '' YYYYMMDD, '' CREATED_BY, GETDATE() CREATION_DATE 
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
			 FROM [dbo].[DM_MST_VERSION] AS A  WITH(NOLOCK)
		   INNER JOIN SCM_SYS_CALENDAR_M AS B
				ON A.YYYYMMDD = B.BASIS_YYYYMMDD
		   LEFT JOIN SCP_PLN_INTERFACE_YN AS C(NOLOCK)
				ON A.DIVISION_ID = C.DIVISION_ID
				AND B.BASIS_START_DATE = C.PLAN_START_YYYYMMDD
		   WHERE (YYYYMMDD >= @p_start_yyyymmdd and YYYYMMDD <= @p_end_yyyymmdd)  
			  AND A.DIVISION_ID IN (SELECT token FROM dbo.String_Split(@p_division_id	,','))  		
			  AND VERSION_TYPE IN (SELECT token FROM dbo.String_Split(@p_version_type	,','))    
			  AND Exists (Select * from dbo.UF_FX_String_Split (@p_version_no,',') as P Where [VERSION_NO] LIKE P.token +'%')
			  AND ISNULL(ATTRIBUTE1,'') <> 'MOVE'
			  --AND CREATED_BY <> 'WITHOUT_SP_W' -- [PJ20200138] Created_by 'WITHOUT_SP_W' 는 제외
		   GROUP BY VERSION_NO , VERSION_NO, VERSION_DESCRIPTION, VERSION_TYPE, VER_CRE_SEQ, YYYYMMDD, B.WEEK_NAME, C.DM_RTF_YN
		   ORDER BY CODE DESC, VERSION_NO DESC
	   END

END