
/*
 * Program ID   : [DMF0074_EXCEL_UPLOAD]
 * Description  : 이동계획 판가 메탈연동 - 엑셀업로드
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2024.07.02		KJJ			[PJ2024-50244]SCM DM 고객수요관리 고도화 및 개선 - 최초 작성
 * 2024.09.12		KJJ			[PJ2024-50461] 메탈링크 업로드시 팀정보 관리 안하므로 제거
 * 2024.10.02		KJJ			[PJ2024-50461] 업로드 대상은 '제품(P)'만 해당
 * 2024.10.15		KJJ			[PJ2024-50461] 업로드시 에너지 값이 없는것은 제외(82사업부만 적용)
 * 2024.10.22		KJJ			[PJ2024-50461] 템플릿 다운시 CURRENCY가 없을 경우 SSPM의 값을 가져오게 되어져 있으므로
										업로드시에도 해당조건 추가하여 업로드 가능하게 변경
 * 2024.10.24		KJJ			[PJ2024-50611]소형 이동계획 확산
 */

 --EXEC DMF0074_EXCEL_UPLOAD '2', 'kjj0070'  

 CREATE PROCEDURE [dbo].[DMF0074_EXCEL_UPLOAD]
	@p_mode		   INT,
	@p_created_by  NVARCHAR(150)		

AS

BEGIN

    SET NOCOUNT ON;

    DECLARE @v_program_id     AS NVARCHAR(40) = 'DMF0074';


    DECLARE @v_sheet_name     AS NVARCHAR(40) = 'Metal Link Price';	
	DECLARE @v_sql_text       AS NVARCHAR(MAX);
	DECLARE @v_creation_date  AS NVARCHAR(40);
	DECLARE @v_count          AS INT;
	DECLARE @v_start_yyyymmdd AS NVARCHAR(8);
	DECLARE @v_end_yyyymmdd AS NVARCHAR(8);
	DECLARE @v_division		AS NVARCHAR(10); 

	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'DMF0074_EXCEL_UPLOAD';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;

	SET @v_log_type = 'START';
    SET @v_log_message = '########## Start of procedure ##########';
	SET @v_description = '';
	SET @d_event_date = SYSDATETIME();
	EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
	

	SELECT @v_creation_date = CONVERT(NVARCHAR(40), MAX(T.CREATION_DATE), 121)
	FROM   [dbo].[SCM_ADM_EXCEL_UPLOAD] T
	WHERE  T.PROGRAM_ID  LIKE @v_program_id + '%'
	AND    T.SHEET_NAME = @v_sheet_name
	AND    T.CREATED_BY = @p_created_by;

		 
	IF @v_creation_date IS NULL BEGIN
			SET @v_log_type = 'END';
			SET @v_log_message = '########## END of procedure ##########';
			SET @v_description = 'Data Not Found [' + CONVERT(CHAR(19), @v_creation_date, 121) +']';
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
    END;

		BEGIN
			SELECT TOP 1  @v_division = ATTRIBUTE1 FROM [dbo].[SCM_ADM_EXCEL_UPLOAD] 
			WHERE  PROGRAM_ID     LIKE @v_program_id + '%'
			AND    SHEET_NAME    = @v_sheet_name
			AND    CREATED_BY    = @p_created_by
			AND    CONVERT(NVARCHAR(40), CREATION_DATE, 121) = @v_creation_date
			AND    UPLOAD_STATUS_CODE = 'SUCCESS';
		END


	----[PJ2024-50461]DIV별 최신 버전
	IF OBJECT_ID('TEMPDB..#TEMP_VERSION_NO') IS NOT NULL
		DROP TABLE #TEMP_VERSION_NO;

		CREATE TABLE #TEMP_VERSION_NO(
						DIVISION_ID					NVARCHAR(100),
						VERSION_NO					NVARCHAR(100),
						YYYYMMDD					NVARCHAR(100),
						YYYYMM						NVARCHAR(100),
						RESULT_FROM					NVARCHAR(100),
						RESULT_TO					NVARCHAR(100),
						PLAN_TO						NVARCHAR(100)
				)

		INSERT INTO #TEMP_VERSION_NO
			SELECT 
			--[PJ2024-50461]조회시 * 가져오지 말고 구체적 필드 표시START
			  A.DIVISION_ID
			, A.VERSION_NO
			, A.YYYYMMDD
			--[PJ2024-50461]조회시 * 가져오지 말고 구체적 필드 표시END
			, B.BASIS_YYYYMM YYYYMM 
			, CASE WHEN B.BASIS_YYYYMM > CONVERT(CHAR(6), DATEADD(DD, -7, dbo.FN_NEXT_DAY( A.YYYYMMDD, 'MON')), 112)
				THEN CONVERT(CHAR(8), DATEADD(MONTH, -1,CONVERT(VARCHAR, B.BASIS_YYYYMM + '01', 112) ), 112)
				ELSE CONVERT(VARCHAR, B.BASIS_YYYYMM + '01', 112) END RESULT_FROM
			, CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY( A.YYYYMMDD, 'MON')), 112) RESULT_TO
			, CONVERT(CHAR(8), DATEADD(DD, - 1, DATEADD(WW, 52, CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY( A.YYYYMMDD, 'MON')), 112) )),  112)  PLAN_TO
			FROM
			(
				SELECT DIVISION_ID, MAX(VERSION_NO) VERSION_NO,  max(yyyymmdd) yyyymmdd
							FROM DM_MST_VERSION WITH(NOLOCK)
							WHERE VERSION_TYPE	= 'SP_W' 
							AND ISNULL(ATTRIBUTE7, 'N') = 'Y'
				GROUP BY DIVISION_ID
			) A
			INNER JOIN SCM_SYS_CALENDAR_M B
					ON B.BASIS_YYYYMMDD = A.yyyymmdd 
------------------------------------------------------------

	--[PJ2024-50461]업로드시 type이 '제품' 인 것만 조회되게 tmp table생성 start
	IF OBJECT_ID('TEMPDB..#TEMP_MST_ITEM') IS NOT NULL
		DROP TABLE #TEMP_MST_ITEM;

		SELECT DISTINCT DIVISION_ID, ITEM_ID 
		INTO   #TEMP_MST_ITEM
		FROM   DM_MST_ITEM_SINGLE_V SV WITH(NOLOCK)
		WHERE  SV.ITEM_TYPE = 'P'--'제품(P)'만 해당
		AND    SV.ACTIVE_FLAG = 'Y'
	--[PJ2024-50461]업로드시 type이 '제품' 인 것만 조회되게 tmp table생성 end



	--[PJ2024-50461]업로드시 Energy가 있는 모델만(82사업부만 적용) start
	IF OBJECT_ID('TEMPDB..#TEMP_MST_ITEM_ENERGY') IS NOT NULL
		DROP TABLE #TEMP_MST_ITEM_ENERGY;

		SELECT DISTINCT DIVISION_ID, ITEM_ID 
		INTO   #TEMP_MST_ITEM_ENERGY
		FROM   DM_MST_ITEM_SINGLE_V SV WITH(NOLOCK)
		WHERE  DIVISION_ID = '82'
		AND	  ISNULL(SV.ENERGE, '') <> ''
		AND    SV.ACTIVE_FLAG = 'Y'
	--[PJ2024-50461]업로드시 Energy가 있는 모델만(82사업부만 적용) end

	--[PJ2024-50611]엑셀 업로드된 데이터를 모든 사업부가 같은 컬럼을 바라보게 사용하기 위해 tmp 테이블 생성 --start
	IF OBJECT_ID('TEMPDB..#TMP_EXCEL_UPLOAD_RAW') IS NOT NULL
		DROP TABLE #TMP_EXCEL_UPLOAD_RAW;

	CREATE TABLE #TMP_EXCEL_UPLOAD_RAW(
	[UPLOAD_ID] [bigint] NOT NULL,
	[PROGRAM_ID] [nvarchar](100) NOT NULL,
	[SHEET_NAME] [nvarchar](150) NOT NULL,
	[UPLOAD_STATUS_CODE] [nvarchar](40) NULL,
	[MESSAGE_TEXT] [nvarchar](4000) NULL,
	[CREATED_BY] [nvarchar](150) NULL,
	[CREATION_DATE] [datetime] NOT NULL,
	[LAST_UPDATED_BY] [nvarchar](150) NULL,
	[LAST_UPDATE_DATE] [datetime] NOT NULL,
	[ATTRIBUTE1] [nvarchar](150) NULL,
	[ATTRIBUTE2] [nvarchar](150) NULL,

	[ATTRIBUTE4] [nvarchar](150) NULL,
	[ATTRIBUTE5] [nvarchar](150) NULL,
	[ATTRIBUTE7] [nvarchar](150) NULL,
	[ATTRIBUTE8] [nvarchar](150) NULL,
	[ATTRIBUTE9] [nvarchar](150) NULL,
	[ATTRIBUTE10] [nvarchar](150) NULL,
	[ATTRIBUTE11] [nvarchar](150) NULL,
	[ATTRIBUTE12] [nvarchar](150) NULL,
	[ATTRIBUTE13] [nvarchar](150) NULL,
	[ATTRIBUTE14] [nvarchar](150) NULL,
	[ATTRIBUTE15] [nvarchar](150) NULL,
	[ATTRIBUTE16] [nvarchar](150) NULL,
	[ATTRIBUTE17] [nvarchar](150) NULL,
	[ATTRIBUTE18] [nvarchar](150) NULL,
	[ATTRIBUTE19] [nvarchar](150) NULL,
	[ATTRIBUTE20] [nvarchar](150) NULL,
	[ATTRIBUTE21] [nvarchar](150) NULL,
	[ATTRIBUTE22] [nvarchar](150) NULL,
	[ATTRIBUTE23] [nvarchar](150) NULL,
	[ATTRIBUTE24] [nvarchar](150) NULL,
	[ATTRIBUTE25] [nvarchar](150) NULL,
	[ATTRIBUTE26] [nvarchar](150) NULL,
	[ATTRIBUTE27] [nvarchar](150) NULL,
	[ATTRIBUTE28] [nvarchar](150) NULL,
	[ATTRIBUTE29] [nvarchar](150) NULL,
	[ATTRIBUTE30] [nvarchar](150) NULL,
	[ATTRIBUTE31] [nvarchar](150) NULL,
	[ATTRIBUTE32] [nvarchar](150) NULL,
	[ATTRIBUTE33] [nvarchar](150) NULL,
	[ATTRIBUTE34] [nvarchar](150) NULL,
	[ATTRIBUTE35] [nvarchar](150) NULL,
	[ATTRIBUTE36] [nvarchar](150) NULL,
	[ATTRIBUTE37] [nvarchar](150) NULL,
	[ATTRIBUTE38] [nvarchar](150) NULL,
	[ATTRIBUTE39] [nvarchar](150) NULL,
	[ATTRIBUTE40] [nvarchar](150) NULL,
	[ATTRIBUTE41] [nvarchar](150) NULL,
	[ATTRIBUTE42] [nvarchar](150) NULL,
	[ATTRIBUTE43] [nvarchar](150) NULL,
	[ATTRIBUTE44] [nvarchar](150) NULL,
	[ATTRIBUTE45] [nvarchar](150) NULL,
	[ATTRIBUTE46] [nvarchar](150) NULL,
	[ATTRIBUTE47] [nvarchar](150) NULL,
	[ATTRIBUTE48] [nvarchar](150) NULL,
	[ATTRIBUTE49] [nvarchar](150) NULL,
	[ATTRIBUTE50] [nvarchar](150) NULL,
	[ATTRIBUTE51] [nvarchar](150) NULL,
	[ATTRIBUTE52] [nvarchar](150) NULL,
	[ATTRIBUTE53] [nvarchar](150) NULL,
	[ATTRIBUTE54] [nvarchar](150) NULL,
	[ATTRIBUTE55] [nvarchar](150) NULL
	)
	--[PJ2024-50611]엑셀 업로드된 데이터를 모든 사업부가 같은 컬럼을 바라보게 사용하기 위해 tmp 테이블 생성 --end

	-- @p_mode = 0 이면 Validation
	IF ISNULL(@p_mode, 0) = 0 
	BEGIN
		BEGIN
		UPDATE [dbo].[SCM_ADM_EXCEL_UPLOAD] 
        SET    UPLOAD_STATUS_CODE = 'UPLOAD'
             , MESSAGE_TEXT       = NULL             
        FROM   [dbo].[SCM_ADM_EXCEL_UPLOAD] T
		WHERE  T.PROGRAM_ID    LIKE @v_program_id + '%'
        AND    T.SHEET_NAME    = @v_sheet_name
        AND    T.CREATED_BY    = @p_created_by
        AND    CONVERT(NVARCHAR(40), T.CREATION_DATE, 121) = @v_creation_date
        AND    ISNULL(T.UPLOAD_STATUS_CODE,'X') != 'UPLOAD';
    	END;

		BEGIN
        ------------------------------------------------------------------------
	    SET @v_log_type = '1';
	    SET @v_log_message = '########## RESET Status = UPLOAD ##########';
	    SET @v_description = '';
	    SET @d_event_date = SYSDATETIME();
	    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
        ------------------------------------------------------------------------
		END;

		BEGIN
	    UPDATE [dbo].[SCM_ADM_EXCEL_UPLOAD] 
        SET    UPLOAD_STATUS_CODE = 'SKIP'
        WHERE  PROGRAM_ID     LIKE @v_program_id + '%'
        AND    SHEET_NAME    = @v_sheet_name
        AND    CREATED_BY    = @p_created_by
        AND    CONVERT(NVARCHAR(40), CREATION_DATE, 121) = @v_creation_date
		 --ATTRIBUTE1 ~ ATTRIBUTE13까지는 빈칸임(헤더가 2줄이라서)
		AND    ATTRIBUTE1 = ''
		AND    ATTRIBUTE2 = ''
		AND    ATTRIBUTE3 = ''
		AND    ATTRIBUTE4 = ''
		AND    ATTRIBUTE5 = ''
		AND    ATTRIBUTE6 = ''
		AND    ATTRIBUTE7 = ''
		AND    ATTRIBUTE8 = ''
		AND    ATTRIBUTE9 = ''
		AND    ATTRIBUTE10 = ''
		AND    ATTRIBUTE11 = ''
		AND    ATTRIBUTE12 = ''
		AND    ATTRIBUTE13 = ''
		END;

	    BEGIN
        ------------------------------------------------------------------------
		SET @v_log_type = '2';
		SET @v_log_message = '########## SKIP EMPTY LINE ##########';
		SET @v_description = '';
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
        ------------------------------------------------------------------------
		END;

		BEGIN
		UPDATE [dbo].[SCM_ADM_EXCEL_UPLOAD] 
        SET    UPLOAD_STATUS_CODE = '@TITLE'
        WHERE  PROGRAM_ID    LIKE @v_program_id + '%'
        AND    SHEET_NAME    = @v_sheet_name
        AND    CREATED_BY    = @p_created_by
        AND    CONVERT(NVARCHAR(40), CREATION_DATE, 121) = @v_creation_date
        AND    UPPER(ATTRIBUTE1) = 'DIV';               
        END;

		BEGIN
		------------------------------------------------------------------------
		SET @v_log_type = '3';
		SET @v_log_message = '########## TITLE Header Line ##########';
	    SET @v_description = '';
	    SET @d_event_date = SYSDATETIME();
	    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
        ------------------------------------------------------------------------
		END;

		--본격적 VALIDATION 시작
		-- [PJ2024-50611]tmp table 에 업로드한것 적재 start
		-- 40번 사업부일 경우 2칸 조정한다
		BEGIN
			INSERT INTO #TMP_EXCEL_UPLOAD_RAW
			SELECT

			[UPLOAD_ID] ,
			[PROGRAM_ID] ,
			[SHEET_NAME] ,
			[UPLOAD_STATUS_CODE] ,
			[MESSAGE_TEXT],
			[CREATED_BY] ,
			[CREATION_DATE] ,
			[LAST_UPDATED_BY] ,
			[LAST_UPDATE_DATE] ,

			ATTRIBUTE1	--DIVISION_ID
			,ATTRIBUTE2	--PLAN_YYYYMM
			--[PJ2024-50461] 메탈링크 업로드시 팀정보 관리 안하므로 제거
			--,ATTRIBUTE3	--DEPT_NAME
			--[PJ2024-50461] 메탈링크 업로드시 팀정보 관리 안하므로 제거
			,ATTRIBUTE4	--End Customer
			,CASE WHEN ATTRIBUTE1 = '40' THEN '' ELSE ATTRIBUTE5 END	--Project Code(소형사업부는 공백처리)
			,CASE WHEN ATTRIBUTE1 = '40' THEN ATTRIBUTE5 ELSE ATTRIBUTE7 END	--MODEL Code
			,CASE WHEN ATTRIBUTE1 = '40' THEN ATTRIBUTE6 ELSE ATTRIBUTE8 END	--Metal Link
			,CASE WHEN ATTRIBUTE1 = '40' THEN ATTRIBUTE7 ELSE ATTRIBUTE9 END	--Sales Site
			,CASE WHEN ATTRIBUTE1 = '40' THEN ATTRIBUTE8 ELSE ATTRIBUTE10 END	--Currency
			,CASE WHEN ATTRIBUTE1 = '40' THEN ATTRIBUTE9 ELSE ATTRIBUTE11 END	--FCST type
			,CASE WHEN ATTRIBUTE1 = '40' THEN ATTRIBUTE10 ELSE ATTRIBUTE12 END	--Exception
			,CASE WHEN ATTRIBUTE1 = '40' THEN ATTRIBUTE11 ELSE ATTRIBUTE13 END	--Energy
																		  
			,CASE WHEN ATTRIBUTE1 = '40' THEN ATTRIBUTE12 ELSE ATTRIBUTE14 END	--Ni		APPLY_PRICE_TYPE_CODE1
			,CASE WHEN ATTRIBUTE1 = '40' THEN ATTRIBUTE13 ELSE ATTRIBUTE15 END	--Co		APPLY_PRICE_TYPE_CODE2
			,CASE WHEN ATTRIBUTE1 = '40' THEN ATTRIBUTE14 ELSE ATTRIBUTE16 END	--Li2CO3	APPLY_PRICE_TYPE_CODE3
			,CASE WHEN ATTRIBUTE1 = '40' THEN ATTRIBUTE15 ELSE ATTRIBUTE17 END	--LIOH		APPLY_PRICE_TYPE_CODE4
			,CASE WHEN ATTRIBUTE1 = '40' THEN ATTRIBUTE16 ELSE ATTRIBUTE18 END	--Al		APPLY_PRICE_TYPE_CODE5
			,CASE WHEN ATTRIBUTE1 = '40' THEN ATTRIBUTE17 ELSE ATTRIBUTE19 END	--Mn		APPLY_PRICE_TYPE_CODE6
			,CASE WHEN ATTRIBUTE1 = '40' THEN ATTRIBUTE18 ELSE ATTRIBUTE20 END	--Cu		APPLY_PRICE_TYPE_CODE7
																		  
			,CASE WHEN ATTRIBUTE1 = '40' THEN ATTRIBUTE19 ELSE ATTRIBUTE21 END	--Ni		FROM_PERIOD1
			,CASE WHEN ATTRIBUTE1 = '40' THEN ATTRIBUTE20 ELSE ATTRIBUTE22 END	--Co		FROM_PERIOD2
			,CASE WHEN ATTRIBUTE1 = '40' THEN ATTRIBUTE21 ELSE ATTRIBUTE23 END	--Li2CO3	FROM_PERIOD3
			,CASE WHEN ATTRIBUTE1 = '40' THEN ATTRIBUTE22 ELSE ATTRIBUTE24 END	--LIOH		FROM_PERIOD4
			,CASE WHEN ATTRIBUTE1 = '40' THEN ATTRIBUTE23 ELSE ATTRIBUTE25 END	--Al		FROM_PERIOD5
			,CASE WHEN ATTRIBUTE1 = '40' THEN ATTRIBUTE24 ELSE ATTRIBUTE26 END	--Mn		FROM_PERIOD6
			,CASE WHEN ATTRIBUTE1 = '40' THEN ATTRIBUTE25 ELSE ATTRIBUTE27 END	--Cu		FROM_PERIOD7
																		  
			,CASE WHEN ATTRIBUTE1 = '40' THEN ATTRIBUTE26 ELSE ATTRIBUTE28 END	--Ni		TO_PERIOD1
			,CASE WHEN ATTRIBUTE1 = '40' THEN ATTRIBUTE27 ELSE ATTRIBUTE29 END	--Co		TO_PERIOD2
			,CASE WHEN ATTRIBUTE1 = '40' THEN ATTRIBUTE28 ELSE ATTRIBUTE30 END	--Li2CO3	TO_PERIOD3
			,CASE WHEN ATTRIBUTE1 = '40' THEN ATTRIBUTE29 ELSE ATTRIBUTE31 END	--LIOH		TO_PERIOD4
			,CASE WHEN ATTRIBUTE1 = '40' THEN ATTRIBUTE30 ELSE ATTRIBUTE32 END	--Al		TO_PERIOD5
			,CASE WHEN ATTRIBUTE1 = '40' THEN ATTRIBUTE31 ELSE ATTRIBUTE33 END	--Mn		TO_PERIOD6
			,CASE WHEN ATTRIBUTE1 = '40' THEN ATTRIBUTE32 ELSE ATTRIBUTE34 END	--Cu		TO_PERIOD7
																		  
			,CASE WHEN ATTRIBUTE1 = '40' THEN ATTRIBUTE33 ELSE ATTRIBUTE35 END	--Ni		CONTRACT_UNIT1
			,CASE WHEN ATTRIBUTE1 = '40' THEN ATTRIBUTE34 ELSE ATTRIBUTE36 END	--Co		CONTRACT_UNIT2
			,CASE WHEN ATTRIBUTE1 = '40' THEN ATTRIBUTE35 ELSE ATTRIBUTE37 END	--Li2CO3	CONTRACT_UNIT3
			,CASE WHEN ATTRIBUTE1 = '40' THEN ATTRIBUTE36 ELSE ATTRIBUTE38 END	--LIOH		CONTRACT_UNIT4
			,CASE WHEN ATTRIBUTE1 = '40' THEN ATTRIBUTE37 ELSE ATTRIBUTE39 END	--Al		CONTRACT_UNIT5
			,CASE WHEN ATTRIBUTE1 = '40' THEN ATTRIBUTE38 ELSE ATTRIBUTE40 END	--Mn		CONTRACT_UNIT6
			,CASE WHEN ATTRIBUTE1 = '40' THEN ATTRIBUTE39 ELSE ATTRIBUTE41 END	--Cu		CONTRACT_UNIT7
																		  
			,CASE WHEN ATTRIBUTE1 = '40' THEN ATTRIBUTE40 ELSE ATTRIBUTE42 END	--Ni		METAL_APPLY1
			,CASE WHEN ATTRIBUTE1 = '40' THEN ATTRIBUTE41 ELSE ATTRIBUTE43 END	--Co		METAL_APPLY2
			,CASE WHEN ATTRIBUTE1 = '40' THEN ATTRIBUTE42 ELSE ATTRIBUTE44 END	--Li2CO3	METAL_APPLY3
			,CASE WHEN ATTRIBUTE1 = '40' THEN ATTRIBUTE43 ELSE ATTRIBUTE45 END	--LIOH		METAL_APPLY4
			,CASE WHEN ATTRIBUTE1 = '40' THEN ATTRIBUTE44 ELSE ATTRIBUTE46 END	--Al		METAL_APPLY5
			,CASE WHEN ATTRIBUTE1 = '40' THEN ATTRIBUTE45 ELSE ATTRIBUTE47 END	--Mn		METAL_APPLY6
			,CASE WHEN ATTRIBUTE1 = '40' THEN ATTRIBUTE46 ELSE ATTRIBUTE48 END	--Cu		METAL_APPLY7
																		  
			,CASE WHEN ATTRIBUTE1 = '40' THEN ATTRIBUTE47 ELSE ATTRIBUTE49 END	--Ni		METAL_REQR1
			,CASE WHEN ATTRIBUTE1 = '40' THEN ATTRIBUTE48 ELSE ATTRIBUTE50 END	--Co		METAL_REQR2
			,CASE WHEN ATTRIBUTE1 = '40' THEN ATTRIBUTE49 ELSE ATTRIBUTE51 END	--Li2CO3	METAL_REQR3
			,CASE WHEN ATTRIBUTE1 = '40' THEN ATTRIBUTE50 ELSE ATTRIBUTE52 END	--LIOH		METAL_REQR4
			,CASE WHEN ATTRIBUTE1 = '40' THEN ATTRIBUTE51 ELSE ATTRIBUTE53 END	--Al		METAL_REQR5
			,CASE WHEN ATTRIBUTE1 = '40' THEN ATTRIBUTE52 ELSE ATTRIBUTE54 END	--Mn		METAL_REQR6
			,CASE WHEN ATTRIBUTE1 = '40' THEN ATTRIBUTE53 ELSE ATTRIBUTE55 END	--Cu		METAL_REQR7

			FROM   [dbo].[SCM_ADM_EXCEL_UPLOAD]  WITH(NOLOCK)
			WHERE  1 = 1
			AND    PROGRAM_ID     LIKE @v_program_id + '%'
			AND    SHEET_NAME    = @v_sheet_name
			AND    CREATED_BY    = @p_created_by
			AND    UPLOAD_STATUS_CODE = 'UPLOAD'
			AND    CONVERT(NVARCHAR(40), CREATION_DATE, 121) =  @v_creation_date
			-- [PJ2024-50611]tmp table 에 업로드한것 적재 end
		END

		/* #################################################### */
		/* 필수 값 NULL 값 체크	(요청사항 변경으로 인해 광물은 별도로 체크)			*/
		/* ATTRIBUTE1  : Div									*/
		/* ATTRIBUTE2  : Plan Date								*/
		/* ATTRIBUTE3  : Team									*/
		/* ATTRIBUTE4  : End Customer							*/
		/* ATTRIBUTE5 : Project Code							*/
		/* ATTRIBUTE9 : Sales Site								*/
		/* ATTRIBUTE10 : Currency								*/
		/* ATTRIBUTE11 : FCST type								*/
		/* ATTRIBUTE8 : Metal Link(2024.09.06 추가됨)								*/
		/* 추가 체크(2024.07.08  박필수 책임)*/
		/* ATTRIBUTE14 ~ ATTRIBUTE20 : APPLY_PRICE_TYPE_CODE(요청사항 변경으로 인해 하단에서 별도로 체크)*/
		/* ATTRIBUTE21 ~ ATTRIBUTE27 : FROM_PERIOD_YYYYMM(요청사항 변경으로 인해 하단에서 별도로 체크)*/
		/* ATTRIBUTE28 ~ ATTRIBUTE34 : TO_PERIOD_YYYYMM(요청사항 변경으로 인해 하단에서 별도로 체크)*/
		/* ATTRIBUTE3  : 필수 체크에서 제외 [PJ2024-50461] Team Mapping*/
		/* ATTRIBUTE5 : 소형사업부는 프로젝트 코드 체크 안함 --[PJ2024-50611]소형 이동계획 확산*/
		/* #################################################### */
		--Div	Team	End Customer	Project Code	Currency
		BEGIN
			UPDATE #TMP_EXCEL_UPLOAD_RAW
			   SET UPLOAD_STATUS_CODE	= 'ERROR'
				 , MESSAGE_TEXT			= CASE WHEN ISNULL(ATTRIBUTE1,'')=''  THEN 'NULL DIVISION.' 
											   WHEN ISNULL(ATTRIBUTE2,'')=''  THEN 'NULL PLAN DATE.' 
				 							   --WHEN ISNULL(ATTRIBUTE3,'')=''  THEN 'NULL TEAM.' --[PJ2024-50461] 메탈링크 업로드시 팀정보 관리 안하므로 제거
				 							   WHEN ISNULL(ATTRIBUTE4,'')=''  THEN 'NULL END CUSTOMER.' 
				 							   WHEN ISNULL(ATTRIBUTE5,'')='' AND ATTRIBUTE1 <> '40' THEN 'NULL PROJECT CODE.' --[PJ2024-50461] 소형 이동계획 확산 : 소형사업부는 프로젝트 코드 체크 안함
				 							   WHEN ISNULL(ATTRIBUTE9,'')=''  THEN 'NULL SALES SITE.' 
											   WHEN ISNULL(ATTRIBUTE10,'')=''  THEN 'NULL CURRENCY.' 
											   WHEN ISNULL(ATTRIBUTE11,'')=''  THEN 'NULL FCST TYPE.' 
											   WHEN ISNULL(ATTRIBUTE8,'')=''  THEN 'NULL Metal Link.' 
										   END
			 WHERE UPLOAD_STATUS_CODE = 'UPLOAD' 
			 AND (   --[PJ2024-50461] 팀정보 관리 안하므로 ATTRIBUTE3 체크 제외
					ISNULL(ATTRIBUTE1,'')='' OR ISNULL(ATTRIBUTE2, '')='' /*OR ISNULL(ATTRIBUTE3, '')='' */OR ISNULL(ATTRIBUTE4,'')='' OR (ISNULL(ATTRIBUTE5,'')='' AND ATTRIBUTE1 <> '40' )----[PJ2024-50611]소형 이동계획 확산 : 소형사업부는 프로젝트 코드 체크 안함
					OR ISNULL(ATTRIBUTE9, '')='' OR ISNULL(ATTRIBUTE10, '')='' OR ISNULL(ATTRIBUTE11,'')=''
					OR ISNULL(ATTRIBUTE8, '') = ''
					) ;

			SET @v_log_type = 'UPDATE';
			SET @n_log_count = @n_log_count + 1;
			SET @v_log_message = '########## START : VALIDATION CHECK  ##########';
			SET @v_description = CONVERT(nvarchar,@@ROWCOUNT);
			SET @d_event_date = SYSDATETIME();
				
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		END;

		/* #################################################### */
		/* 업로드 시에도 금주차 컷오프 버전이 있는지 체크해야 함			*/
		/* #################################################### */
		DECLARE @V_YYYYMMDD			NVARCHAR(08);
		DECLARE @V_FROM_YYYYMMDD	NVARCHAR(08);
		DECLARE @V_TO_YYYYMMDD		NVARCHAR(08);

		SET @V_YYYYMMDD =  CONVERT(CHAR(8), GETDATE(),  112)

		SELECT @V_FROM_YYYYMMDD = MIN(B.BASIS_YYYYMMDD) --금주 시작일
		, @V_TO_YYYYMMDD = MAX(B.BASIS_YYYYMMDD) --금주 종료일
		FROM SCM_SYS_CALENDAR_M A
		INNER JOIN SCM_SYS_CALENDAR_M B
				ON A.ISO_YYYYWW = B.ISO_YYYYWW 
		WHERE A.BASIS_YYYYMMDD = CONVERT(CHAR(8), @V_YYYYMMDD,  112) 

		BEGIN
			UPDATE #TMP_EXCEL_UPLOAD_RAW 
			SET    UPLOAD_STATUS_CODE = 'ERROR'
				 , MESSAGE_TEXT       = 'There is no version of Monthly Rolling Forest:Y in Sales Plan Waterfall this week.'
			WHERE  UPLOAD_STATUS_CODE = 'UPLOAD' 
			 AND NOT EXISTS  (  SELECT 1
									FROM #TEMP_VERSION_NO T_VER WITH(NOLOCK)
								   WHERE T_VER.DIVISION_ID = #TMP_EXCEL_UPLOAD_RAW.ATTRIBUTE1 --Div
									)	
		END;

		
		/* #################################################### */
		/* 광물은 7개중 5개 이상 입력해야 함			*/
		/* =>요청사항변경(2024-08-21 : 1개만 입력도 가능하게)			*/
		/* ATTRIBUTE14 ~ ATTRIBUTE20	*/
		/* #################################################### */
		BEGIN
			UPDATE #TMP_EXCEL_UPLOAD_RAW
			SET    UPLOAD_STATUS_CODE = 'ERROR'
				 , MESSAGE_TEXT       = 'NULL APPLY PRICE TYPE CODE.'
			WHERE  UPLOAD_STATUS_CODE = 'UPLOAD'
			AND (ATTRIBUTE8 = 'Y' AND (ATTRIBUTE12 ='N' OR ATTRIBUTE12 ='')) --[PJ2024-50461]Metal Link : Y 이고 EXCEPTION : N 일때만 체크
			AND (
					ISNULL(ATTRIBUTE14, '') = '' 
					AND ISNULL(ATTRIBUTE15, '') = ''
					AND ISNULL(ATTRIBUTE16, '') = '' 
					AND ISNULL(ATTRIBUTE17, '') = '' 
					AND ISNULL(ATTRIBUTE18, '') = '' 
					AND ISNULL(ATTRIBUTE19, '') = ''
					AND ISNULL(ATTRIBUTE20,'') = ''
			)
		END;

		/* #################################################### */
		/* 광물 룩업VALUE 체크						*/
		/* ATTRIBUTE14 ~ ATTRIBUTE20	*/
		/* #################################################### */
		BEGIN
			UPDATE #TMP_EXCEL_UPLOAD_RAW
			SET    UPLOAD_STATUS_CODE = 'ERROR'
				 , MESSAGE_TEXT       = 'Invalid KEY CODE : Ni'
			WHERE  UPLOAD_STATUS_CODE = 'UPLOAD' 
			 AND (ATTRIBUTE8 = 'Y' AND (ATTRIBUTE12 ='N' OR ATTRIBUTE12 ='')) --[PJ2024-50461]Metal Link : Y 이고 EXCEPTION : N 일때만 체크
			AND	   LEN(ATTRIBUTE14) > 0
			AND		NOT EXISTS  (  SELECT 1
									FROM SCM_ADM_LOOKUP_MASTER_DETAIL LUP WITH(NOLOCK)
								   WHERE LUP.LOOKUP_TYPE = 'METAL_KEY_VALUE'
									 AND LUP.VALID_YN = 'Y'
									 AND LUP.SEGMENT1 = SUBSTRING(#TMP_EXCEL_UPLOAD_RAW.ATTRIBUTE1, 1,2) --Div
									 AND LUP.SEGMENT2 = 'Ni' --KEY
									 AND LUP.SEGMENT3 = #TMP_EXCEL_UPLOAD_RAW.ATTRIBUTE14 --CODE
									)	

			UPDATE #TMP_EXCEL_UPLOAD_RAW 
			SET    UPLOAD_STATUS_CODE = 'ERROR'
				 , MESSAGE_TEXT       = 'Invalid KEY CODE : Co'
			WHERE    UPLOAD_STATUS_CODE = 'UPLOAD' 
			 AND (ATTRIBUTE8 = 'Y' AND (ATTRIBUTE12 ='N' OR ATTRIBUTE12 ='')) --[PJ2024-50461]Metal Link : Y 이고 EXCEPTION : N 일때만 체크
			AND	   LEN(ATTRIBUTE15) > 0
			AND		NOT EXISTS  (  SELECT 1
									FROM SCM_ADM_LOOKUP_MASTER_DETAIL LUP WITH(NOLOCK)
								   WHERE LUP.LOOKUP_TYPE = 'METAL_KEY_VALUE'
									 AND LUP.VALID_YN = 'Y'
									 AND LUP.SEGMENT1 = SUBSTRING(#TMP_EXCEL_UPLOAD_RAW.ATTRIBUTE1, 1,2) --Div
									 AND LUP.SEGMENT2 = 'Co' --KEY
									 AND LUP.SEGMENT3 = #TMP_EXCEL_UPLOAD_RAW.ATTRIBUTE15 --CODE
									)	

			UPDATE #TMP_EXCEL_UPLOAD_RAW
			SET    UPLOAD_STATUS_CODE = 'ERROR'
				 , MESSAGE_TEXT       = 'Invalid KEY CODE : Li2CO3'
			WHERE    UPLOAD_STATUS_CODE = 'UPLOAD' 
			 AND (ATTRIBUTE8 = 'Y' AND (ATTRIBUTE12 ='N' OR ATTRIBUTE12 ='')) --[PJ2024-50461]Metal Link : Y 이고 EXCEPTION : N 일때만 체크
			AND	   LEN(ATTRIBUTE16) > 0
			AND		NOT EXISTS  (  SELECT 1
									FROM SCM_ADM_LOOKUP_MASTER_DETAIL LUP WITH(NOLOCK)
								   WHERE LUP.LOOKUP_TYPE = 'METAL_KEY_VALUE'
									 AND LUP.VALID_YN = 'Y'
									 AND LUP.SEGMENT1 = SUBSTRING(#TMP_EXCEL_UPLOAD_RAW.ATTRIBUTE1, 1,2) --Div
									 AND LUP.SEGMENT2 = 'Li2CO3' --KEY
									 AND LUP.SEGMENT3 = #TMP_EXCEL_UPLOAD_RAW.ATTRIBUTE16 --CODE
									)	

			UPDATE #TMP_EXCEL_UPLOAD_RAW
			SET    UPLOAD_STATUS_CODE = 'ERROR'
				 , MESSAGE_TEXT       = 'Invalid KEY CODE : LIOH'
			WHERE    UPLOAD_STATUS_CODE = 'UPLOAD' 
			 AND (ATTRIBUTE8 = 'Y' AND (ATTRIBUTE12 ='N' OR ATTRIBUTE12 ='')) --[PJ2024-50461]Metal Link : Y 이고 EXCEPTION : N 일때만 체크
			AND	   LEN(ATTRIBUTE17) > 0
			AND		NOT EXISTS  (  SELECT 1
									FROM SCM_ADM_LOOKUP_MASTER_DETAIL LUP WITH(NOLOCK)
								   WHERE LUP.LOOKUP_TYPE = 'METAL_KEY_VALUE'
									 AND LUP.VALID_YN = 'Y'
									 AND LUP.SEGMENT1 = SUBSTRING(#TMP_EXCEL_UPLOAD_RAW.ATTRIBUTE1, 1,2) --Div
									 AND LUP.SEGMENT2 = 'LIOH' --KEY
									 AND LUP.SEGMENT3 = #TMP_EXCEL_UPLOAD_RAW.ATTRIBUTE17 --CODE
									)	

			UPDATE #TMP_EXCEL_UPLOAD_RAW
			SET    UPLOAD_STATUS_CODE = 'ERROR'
				 , MESSAGE_TEXT       = 'Invalid KEY CODE : Al'
			WHERE    UPLOAD_STATUS_CODE = 'UPLOAD' 
			 AND (ATTRIBUTE8 = 'Y' AND (ATTRIBUTE12 ='N' OR ATTRIBUTE12 ='')) --[PJ2024-50461]Metal Link : Y 이고 EXCEPTION : N 일때만 체크
			AND	   LEN(ATTRIBUTE18) > 0
			AND		NOT EXISTS  (  SELECT 1
									FROM SCM_ADM_LOOKUP_MASTER_DETAIL LUP WITH(NOLOCK)
								   WHERE LUP.LOOKUP_TYPE = 'METAL_KEY_VALUE'
									 AND LUP.VALID_YN = 'Y'
									 AND LUP.SEGMENT1 = SUBSTRING(#TMP_EXCEL_UPLOAD_RAW.ATTRIBUTE1, 1,2) --Div
									 AND LUP.SEGMENT2 = 'Al' --KEY
									 AND LUP.SEGMENT3 = #TMP_EXCEL_UPLOAD_RAW.ATTRIBUTE18 --CODE
									)	

			UPDATE #TMP_EXCEL_UPLOAD_RAW 
			SET    UPLOAD_STATUS_CODE = 'ERROR'
				 , MESSAGE_TEXT       = 'Invalid KEY CODE : Mn'
			WHERE    UPLOAD_STATUS_CODE = 'UPLOAD' 
			 AND (ATTRIBUTE8 = 'Y' AND (ATTRIBUTE12 ='N' OR ATTRIBUTE12 ='')) --[PJ2024-50461]Metal Link : Y 이고 EXCEPTION : N 일때만 체크
			AND	   LEN(ATTRIBUTE19) > 0
			AND		NOT EXISTS  (  SELECT 1
									FROM SCM_ADM_LOOKUP_MASTER_DETAIL LUP WITH(NOLOCK)
								   WHERE LUP.LOOKUP_TYPE = 'METAL_KEY_VALUE'
									 AND LUP.VALID_YN = 'Y'
									 AND LUP.SEGMENT1 = SUBSTRING(#TMP_EXCEL_UPLOAD_RAW.ATTRIBUTE1, 1,2) --Div
									 AND LUP.SEGMENT2 = 'Mn' --KEY
									 AND LUP.SEGMENT3 = #TMP_EXCEL_UPLOAD_RAW.ATTRIBUTE19 --CODE
									)	

			UPDATE #TMP_EXCEL_UPLOAD_RAW 
			SET    UPLOAD_STATUS_CODE = 'ERROR'
				 , MESSAGE_TEXT       = 'Invalid KEY CODE : Cu'
			WHERE   UPLOAD_STATUS_CODE = 'UPLOAD' 
			 AND  (ATTRIBUTE8 = 'Y' AND (ATTRIBUTE12 ='N' OR ATTRIBUTE12 ='')) --[PJ2024-50461]Metal Link : Y 이고 EXCEPTION : N 일때만 체크
			AND	   LEN(ATTRIBUTE20) > 0
			AND		NOT EXISTS  (  SELECT 1
									FROM SCM_ADM_LOOKUP_MASTER_DETAIL LUP WITH(NOLOCK)
								   WHERE LUP.LOOKUP_TYPE = 'METAL_KEY_VALUE'
									 AND LUP.VALID_YN = 'Y'
									 AND LUP.SEGMENT1 = SUBSTRING(#TMP_EXCEL_UPLOAD_RAW.ATTRIBUTE1, 1,2) --Div
									 AND LUP.SEGMENT2 = 'Cu' --KEY
									 AND LUP.SEGMENT3 = #TMP_EXCEL_UPLOAD_RAW.ATTRIBUTE20 --CODE
									)	
		END;
		
		

		/* #################################################### */
		/* 동일아이템 중복 체크			*/
		/* ATTRIBUTE1  : Div									*/
		/* ATTRIBUTE2  : Plan Date								*/
		/* ATTRIBUTE3  : Team									*/
		/* ATTRIBUTE4  : End Customer							*/
		/* ATTRIBUTE5 : Project Code							*/
		/* ATTRIBUTE7 : Model Code								*/
		/* ATTRIBUTE9 : Sales Site								*/
		/* ATTRIBUTE10 : Currency								*/
		/* ATTRIBUTE11 : FCST type								*/
		/* ATTRIBUTE3 :  중복체크에서 제외	[PJ2024-50461] 메탈링크 업로드시 팀정보 관리 안하므로 제거*/
		/* #################################################### */
		BEGIN
		UPDATE #TMP_EXCEL_UPLOAD_RAW 
        SET    UPLOAD_STATUS_CODE = 'ERROR'
             , MESSAGE_TEXT       = 'Duplication Model.'
        WHERE    UPLOAD_STATUS_CODE = 'UPLOAD' 
			 AND EXISTS (SELECT 1
		            FROM  (SELECT X.ATTRIBUTE1 AS COL1
                                , X.ATTRIBUTE2 AS COL2
                                --, X.ATTRIBUTE3 AS COL3--[PJ2024-50461] 메탈링크 업로드시 팀정보 관리 안하므로 제거
                                , X.ATTRIBUTE4 AS COL4
								, X.ATTRIBUTE5 AS COL5
								, X.ATTRIBUTE7 AS COL7
								, X.ATTRIBUTE9 AS COL9
								, X.ATTRIBUTE10 AS COL10
								, X.ATTRIBUTE11 AS COL11
                           FROM   #TMP_EXCEL_UPLOAD_RAW X  WITH(NOLOCK)
                           GROUP BY X.ATTRIBUTE1
                                  , X.ATTRIBUTE2
                                  --, X.ATTRIBUTE3--[PJ2024-50461] 메탈링크 업로드시 팀정보 관리 안하므로 제거
                                  , X.ATTRIBUTE4
								  , X.ATTRIBUTE5
								  , X.ATTRIBUTE7
								  , X.ATTRIBUTE9
								  , X.ATTRIBUTE10
								  , X.ATTRIBUTE11
                           HAVING COUNT(*) > 1 ) T
					WHERE 1 = 1										 
	 			    AND T.COL1 = ATTRIBUTE1
                    AND T.COL2 = ATTRIBUTE2
                    --AND T.COL3 = ATTRIBUTE3--[PJ2024-50461] 메탈링크 업로드시 팀정보 관리 안하므로 제거
                    AND T.COL4 = ATTRIBUTE4
					AND T.COL5 = ATTRIBUTE5
					AND T.COL7 = ATTRIBUTE7
					AND T.COL9 = ATTRIBUTE9
					AND T.COL10 = ATTRIBUTE10
					AND T.COL11 = ATTRIBUTE11
				   );
		END

		/* #################################################### */
		/* PLAN_YYYYMM  체크									*/
		/* #################################################### */
		BEGIN
			UPDATE #TMP_EXCEL_UPLOAD_RAW
			SET    UPLOAD_STATUS_CODE = 'ERROR'
				 , MESSAGE_TEXT       = 'Invalid Date Format.'
			WHERE    UPLOAD_STATUS_CODE = 'UPLOAD' 
			 AND (LEN(ATTRIBUTE2) <> 6 OR ISDATE(ATTRIBUTE2 + '01') = 0)
		END;

		--당월 이후만 입력가능
		BEGIN
			UPDATE #TMP_EXCEL_UPLOAD_RAW
			SET    UPLOAD_STATUS_CODE = 'ERROR'
				 , MESSAGE_TEXT       = 'Past Date.'
			WHERE    UPLOAD_STATUS_CODE = 'UPLOAD' 
			 AND ATTRIBUTE2 < CONVERT(VARCHAR(6), GETDATE(), 112) 
		END;

		/* #################################################### */
		/* TEAM 체크											*/
		/* 체크 안함 : [PJ2024-50461] 메탈링크 업로드시 팀정보 관리 안하므로 제거*/
		/* #################################################### */
		/*BEGIN
			UPDATE [dbo].[SCM_ADM_EXCEL_UPLOAD] 
			   SET UPLOAD_STATUS_CODE = 'ERROR'
				 , MESSAGE_TEXT       = 'Invalid TEAM.'
			 WHERE PROGRAM_ID         = @v_program_id
			   AND SHEET_NAME         = @v_sheet_name
			   AND CREATED_BY         = @p_created_by
			   AND CONVERT(NVARCHAR(40), CREATION_DATE, 121) = @v_creation_date
			   AND UPLOAD_STATUS_CODE = 'UPLOAD'
			   AND NOT EXISTS  (  /*SELECT 1
									FROM SCM_MST_SSO_DEPT_INFO DI WITH(NOLOCK)
								   WHERE 1 = 1
									 AND DEPT_NAME_KO = [SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE3
									 AND DI.VALID_YN = 'Y'*/
									SELECT 1
									FROM SCM_MST_SITE S WITH(NOLOCK)
									inner JOIN [10.34.221.78,7433].LGCE_SCMPROD.DBO.SCM_MST_SSO_DEPT_INFO DI WITH(NOLOCK)
										ON	DI.DEPT_ID = S.DEPT_ID
										AND DI.DEPT_NAME_KO = [SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE3
										AND DI.VALID_YN = 'Y'
									WHERE S.DIVISION_ID   = [SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE1
									AND S.SCM_SITE_ID   = [SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE9
									AND S.SITE_TYPE     = 'SALES' 
									AND S.VALID_YN = 'Y'

									)	 ;

			SET @v_log_type = 'UPDATE';
			SET @n_log_count = @n_log_count + 1;
			SET @v_log_message = '########## Invalid TEAM. ##########';
			SET @v_description = CONVERT(nvarchar,@@ROWCOUNT);
			SET @d_event_date = SYSDATETIME();

			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		END;
		*/

		/* #################################################### */
		/* END CUSTOMER 체크									*/
		/* #################################################### */
		BEGIN
			UPDATE #TMP_EXCEL_UPLOAD_RAW
			   SET UPLOAD_STATUS_CODE = 'ERROR'
				 , MESSAGE_TEXT       = 'Invalid END CUSTOMER.'
			 WHERE   UPLOAD_STATUS_CODE = 'UPLOAD' 
			 --긴급 수정 =>[PJ2024-50461]END CUSTOMER는 룩업에 등록된 것들 기준으로 변경
			 AND NOT EXISTS  (  SELECT 1
									FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
									WHERE  LOOKUP_TYPE = 'END_CUSTOMER'
									AND    SEGMENT1 = #TMP_EXCEL_UPLOAD_RAW.ATTRIBUTE1
									AND    SEGMENT2 = #TMP_EXCEL_UPLOAD_RAW.ATTRIBUTE4
									AND VALID_YN = 'Y'
									)	 ;
		END;

		/* #################################################### */
		/* PROJECT CODE 체크									*/
		/* #################################################### */
		BEGIN
			UPDATE #TMP_EXCEL_UPLOAD_RAW
			   SET UPLOAD_STATUS_CODE = 'ERROR'
				 , MESSAGE_TEXT       = 'Invalid PROJECT CODE.'
			 WHERE ATTRIBUTE1 <> '40' --[PJ2024-50611]소형 이동계획 확산 : 40 사업부는 체크안함
			   AND   UPLOAD_STATUS_CODE = 'UPLOAD' 
			 AND NOT EXISTS  (  SELECT 1
									FROM SCM_MST_PROJECT MP WITH(NOLOCK)
								   WHERE 1 = 1
									 AND MP.DIVISION_ID = #TMP_EXCEL_UPLOAD_RAW.ATTRIBUTE1
									 AND MP.PROJECT_CODE = #TMP_EXCEL_UPLOAD_RAW.ATTRIBUTE5
									)	 ;
		END;

		/* #################################################### */
		/* MODEL 체크										*/
		/* #################################################### */
		BEGIN
			UPDATE #TMP_EXCEL_UPLOAD_RAW 
			   SET UPLOAD_STATUS_CODE = 'ERROR'
				 , MESSAGE_TEXT       = 'Invalid MODEL.'
			 WHERE   UPLOAD_STATUS_CODE = 'UPLOAD' 
			 AND ISNULL(ATTRIBUTE7, '') <> ''--Model
			   AND NOT EXISTS  (  SELECT 1
									FROM SCM_MST_SITE MS WITH(NOLOCK)
									INNER JOIN SCM_MST_SITE_ITEM ITM WITH(NOLOCK)
										ON ITM.DIVISION_ID = #TMP_EXCEL_UPLOAD_RAW.ATTRIBUTE1
										--[PJ2024-50611]소형일 경우 ATTRIBUTE4(END_CUSTOMER)로 비교. 나머지는 ATTRIBUTE5(PROJECT_CODE)로 비교
										--AND ITM.PROJECT_CODE = [SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE5 
										AND ITM.PROJECT_CODE = CASE WHEN ITM.DIVISION_ID = '40' THEN #TMP_EXCEL_UPLOAD_RAW.ATTRIBUTE4 ELSE #TMP_EXCEL_UPLOAD_RAW.ATTRIBUTE5 END
										--[PJ2024-50611]소형일 경우 ATTRIBUTE4(END_CUSTOMER)로 비교. 나머지는 ATTRIBUTE5(PROJECT_CODE)로 비교

										AND ITM.SCM_SITE_ID = MS.SCM_SITE_ID
										AND ITM.ITEM_ID = #TMP_EXCEL_UPLOAD_RAW.ATTRIBUTE7
										AND ITM.VALID_YN = 'Y'
								   WHERE 1 = 1
									 AND MS.DIVISION_ID = #TMP_EXCEL_UPLOAD_RAW.ATTRIBUTE1
									 --AND MS.END_CUSTOMER = [SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE4--[PJ2024-50461]END_CUSTOMER는 필수값이 아니므로 조인 조건에서 제외
									 AND MS.VALID_YN = 'Y'
								)	 ;


			--[PJ2024-50461]에너지 없는 모델일 경우 별도 메세지(82번 사업부만)-----
			UPDATE #TMP_EXCEL_UPLOAD_RAW
			   SET UPLOAD_STATUS_CODE = 'ERROR'
				 , MESSAGE_TEXT       = 'Invalid MODEL : NULL ENERGY'
			 WHERE   UPLOAD_STATUS_CODE = 'UPLOAD' 
			 AND ISNULL(ATTRIBUTE7, '') <> ''--Model
			   AND ATTRIBUTE1 = '82' --82번 사업부만
			   AND NOT EXISTS  (  
								SELECT 1
									FROM #TEMP_MST_ITEM_ENERGY SV WITH(NOLOCK)
								   WHERE 1 = 1
									 AND SV.DIVISION_ID = #TMP_EXCEL_UPLOAD_RAW.ATTRIBUTE1
									 AND SV.ITEM_ID = #TMP_EXCEL_UPLOAD_RAW.ATTRIBUTE7
								)	 ;
 
			--[PJ2024-50461]제품TYPE이 P가 아닌경우 별도 메세지-----
			UPDATE #TMP_EXCEL_UPLOAD_RAW 
			   SET UPLOAD_STATUS_CODE = 'ERROR'
				 , MESSAGE_TEXT       = 'Invalid MODEL : TYPE P.'
			 WHERE   UPLOAD_STATUS_CODE = 'UPLOAD' 
			 AND ISNULL(ATTRIBUTE7, '') <> ''--Model
			   AND NOT EXISTS  (  
								SELECT 1
									FROM #TEMP_MST_ITEM SV WITH(NOLOCK)
								   WHERE 1 = 1
									 AND SV.DIVISION_ID = #TMP_EXCEL_UPLOAD_RAW.ATTRIBUTE1
									 AND SV.ITEM_ID = #TMP_EXCEL_UPLOAD_RAW.ATTRIBUTE7
								)	 ;


			UPDATE #TMP_EXCEL_UPLOAD_RAW 
			   SET UPLOAD_STATUS_CODE = 'ERROR'
				 , MESSAGE_TEXT       = 'Invalid Sales Plan Waterfall MODEL.'
			 WHERE   UPLOAD_STATUS_CODE = 'UPLOAD' 
			 AND ISNULL(ATTRIBUTE7, '') <> ''--Model
			   AND NOT EXISTS  (  
									SELECT 1 FROM DM_PLN_SALES_PLAN_RESULT_C RC WITH(NOLOCK)
										INNER JOIN #TEMP_VERSION_NO T_VER 
											ON RC.DIVISION_ID = T_VER.DIVISION_ID
											AND RC.VERSION_NO = T_VER.VERSION_NO
										INNER JOIN SCM_MST_SITE_ITEM SI WITH(NOLOCK)--[PJ2024-50461]CURRENCY 처리 위해 조인 추가
											ON SI.DIVISION_ID = RC.DIVISION_ID
											AND SI.PROJECT_CODE = RC.PROJECT_CODE
											AND SI.SCM_SITE_ID = RC.SCM_SITE_ID
											AND SI.ITEM_ID = RC.ITEM_ID
											AND SI.VALID_YN = 'Y'
									WHERE RC.DIVISION_ID = #TMP_EXCEL_UPLOAD_RAW.ATTRIBUTE1
									
									--[PJ2024-50611]소형일 경우 ATTRIBUTE4(END_CUSTOMER)로 비교. 나머지는 ATTRIBUTE5(PROJECT_CODE)로 비교
									--AND RC.PROJECT_CODE = [SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE5
									AND RC.PROJECT_CODE = CASE WHEN RC.DIVISION_ID = '40' THEN #TMP_EXCEL_UPLOAD_RAW.ATTRIBUTE4 ELSE #TMP_EXCEL_UPLOAD_RAW.ATTRIBUTE5 END
									--[PJ2024-50611]소형일 경우 ATTRIBUTE4(END_CUSTOMER)로 비교. 나머지는 ATTRIBUTE5(PROJECT_CODE)로 비교

									AND RC.ITEM_ID = #TMP_EXCEL_UPLOAD_RAW.ATTRIBUTE7
									AND RC.SCM_SITE_ID = #TMP_EXCEL_UPLOAD_RAW.ATTRIBUTE9
									AND CASE WHEN ISNULL(RC.CURRENCY, '') = '' THEN SI.CURRENCY ELSE RC.CURRENCY END = #TMP_EXCEL_UPLOAD_RAW.ATTRIBUTE10--[PJ2024-50461]CURRENCY가 없을 경우 SSPM의 값을 가져옴
									AND FCST_TYPE IN 
									(
										SELECT LUP.SEGMENT1
										FROM SCM_ADM_LOOKUP_MASTER_DETAIL LUP WITH(NOLOCK)
										WHERE LUP.LOOKUP_TYPE = 'SALES_TYPE_CODE'
											AND LUP.VALID_YN = 'Y'
											AND LUP.SEGMENT4 <> 'FREE'----FCST_TYPE_NOT_FREE
											AND LUP.SEGMENT2 = #TMP_EXCEL_UPLOAD_RAW.ATTRIBUTE11											
									)
									AND RC.YYYYMMDD >= T_VER.RESULT_FROM
									AND RC.YYYYMMDD < T_VER.RESULT_TO
									UNION ALL
									SELECT 1 FROM DM_PLN_SALES_PLAN_C PC WITH(NOLOCK)
										INNER JOIN #TEMP_VERSION_NO T_VER 
											ON PC.DIVISION_ID = T_VER.DIVISION_ID
											AND PC.VERSION_NO = T_VER.VERSION_NO
										INNER JOIN SCM_MST_SITE_ITEM SI WITH(NOLOCK)--[PJ2024-50461] CURRENCY 처리 위해 조인 추가
											ON SI.DIVISION_ID = PC.DIVISION_ID
											AND SI.PROJECT_CODE = PC.PROJECT_CODE
											AND SI.SCM_SITE_ID = PC.SCM_SITE_ID
											AND SI.ITEM_ID = PC.ITEM_ID
											AND SI.VALID_YN = 'Y'
									WHERE PC.DIVISION_ID = #TMP_EXCEL_UPLOAD_RAW.ATTRIBUTE1

									--[PJ2024-50611]소형일 경우 ATTRIBUTE4(END_CUSTOMER)로 비교. 나머지는 ATTRIBUTE5(PROJECT_CODE)로 비교
									--AND PC.PROJECT_CODE = [SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE5
									AND PC.PROJECT_CODE = CASE WHEN PC.DIVISION_ID = '40' THEN #TMP_EXCEL_UPLOAD_RAW.ATTRIBUTE4 ELSE #TMP_EXCEL_UPLOAD_RAW.ATTRIBUTE5 END
									--[PJ2024-50611]소형일 경우 ATTRIBUTE4(END_CUSTOMER)로 비교. 나머지는 ATTRIBUTE5(PROJECT_CODE)로 비교

									AND PC.ITEM_ID = #TMP_EXCEL_UPLOAD_RAW.ATTRIBUTE7
									AND PC.SCM_SITE_ID = #TMP_EXCEL_UPLOAD_RAW.ATTRIBUTE9
									AND CASE WHEN ISNULL(PC.CURRENCY, '') = '' THEN SI.CURRENCY ELSE PC.CURRENCY END = #TMP_EXCEL_UPLOAD_RAW.ATTRIBUTE10--[PJ2024-50461] CURRENCY가 없을 경우 SSPM의 값을 가져옴
									AND FCST_TYPE IN 
									(
										SELECT LUP.SEGMENT1
										FROM SCM_ADM_LOOKUP_MASTER_DETAIL LUP WITH(NOLOCK)
										WHERE LUP.LOOKUP_TYPE = 'SALES_TYPE_CODE'
											AND LUP.VALID_YN = 'Y'
											AND LUP.SEGMENT4 <> 'FREE'----FCST_TYPE_NOT_FREE
											AND LUP.SEGMENT2 = #TMP_EXCEL_UPLOAD_RAW.ATTRIBUTE11											
									)
									--[PJ2024-50461]날짜 조건 추가
									AND PC.YYYYMMDD >= T_VER.RESULT_TO
									AND PC.YYYYMMDD <= T_VER.PLAN_TO
								)	 ;
		END;

		/* #################################################### */
		/* Metal Link  체크										*/
		/* #################################################### */
		BEGIN
			UPDATE #TMP_EXCEL_UPLOAD_RAW 
			SET    UPLOAD_STATUS_CODE = 'ERROR'
				 , MESSAGE_TEXT       = 'Invalid Metal Link.'
			WHERE    UPLOAD_STATUS_CODE = 'UPLOAD' 
			 AND UPPER(ATTRIBUTE8) NOT IN ('Y', 'N')
		END;

		/* #################################################### */
		/* Sales Site  체크										*/
		/* #################################################### */
		BEGIN
			UPDATE #TMP_EXCEL_UPLOAD_RAW
			SET    UPLOAD_STATUS_CODE = 'ERROR'
				 , MESSAGE_TEXT       = 'Invalid Sales Site.'
			WHERE    UPLOAD_STATUS_CODE = 'UPLOAD' 
			 AND NOT EXISTS (
					SELECT 1 FROM SCM_MST_SITE MS WITH(NOLOCK)
					WHERE MS.DIVISION_ID = #TMP_EXCEL_UPLOAD_RAW.ATTRIBUTE1
					AND MS.VALID_YN = 'Y'
					AND MS.SCM_SITE_ID = #TMP_EXCEL_UPLOAD_RAW.ATTRIBUTE9		
			)
		END;
		
		/* #################################################### */
		/* CURRENCY 체크										*/
		/* #################################################### */
		BEGIN
			UPDATE #TMP_EXCEL_UPLOAD_RAW
			   SET UPLOAD_STATUS_CODE = 'ERROR'
				 , MESSAGE_TEXT       = 'Invalid CURRENCY.'
			 WHERE   UPLOAD_STATUS_CODE = 'UPLOAD' 
			 AND NOT EXISTS  (  SELECT 1
									FROM DM_MST_EXCHANGE_RATE ER WITH(NOLOCK)
								   WHERE 1 = 1
									 AND ER.DIVISION_ID = #TMP_EXCEL_UPLOAD_RAW.ATTRIBUTE1
									 AND ER.UNIT_CURRENCY = #TMP_EXCEL_UPLOAD_RAW.ATTRIBUTE10
									)	 ;

		END;

		/* #################################################### */
		/* FCST type 체크										*/
		/* #################################################### */
		BEGIN
			UPDATE #TMP_EXCEL_UPLOAD_RAW
			   SET UPLOAD_STATUS_CODE = 'ERROR'
				 , MESSAGE_TEXT       = 'Invalid FCST TYPE.'
			 WHERE   UPLOAD_STATUS_CODE = 'UPLOAD' 
			 AND NOT EXISTS  (  SELECT 1
									FROM SCM_ADM_LOOKUP_MASTER_DETAIL LUP WITH(NOLOCK)
									WHERE LUP.LOOKUP_TYPE = 'SALES_TYPE_CODE'
										AND LUP.VALID_YN = 'Y'
										AND LUP.SEGMENT4 <> 'FREE'----FCST_TYPE_NOT_FREE
										AND LUP.SEGMENT2 = #TMP_EXCEL_UPLOAD_RAW.ATTRIBUTE11
									)	 ;
		END;

		/* #################################################### */
		/* EXCEPTION  체크										*/
		/* #################################################### */
		BEGIN
			UPDATE #TMP_EXCEL_UPLOAD_RAW 
			SET    UPLOAD_STATUS_CODE = 'ERROR'
				 , MESSAGE_TEXT       = 'Invalid EXCEPTION.'
			WHERE    UPLOAD_STATUS_CODE = 'UPLOAD' 
			 AND ISNULL(ATTRIBUTE12, '') <> ''
			AND	   UPPER(ATTRIBUTE12) NOT IN ('Y', 'N')
		END;

		/* #################################################### */
		/* 광물의 값이 미사용 / 미연동 일 경우 입력금지 			*/
		/* 		
        ATTRIBUTE14 = 'Ni'		: Period(Fr) = 21	/	Period(To) = 28	/	Contract Price(/kg) = 35	/	Change Price(/kg) = 42	/	Metal Index (kg/Biz type) = 49
		ATTRIBUTE15 = 'Co' 		: Period(Fr) = 22	/	Period(To) = 29	/	Contract Price(/kg) = 36	/	Change Price(/kg) = 43	/	Metal Index (kg/Biz type) = 50
		ATTRIBUTE16 = 'Li2CO3' 	: Period(Fr) = 23	/	Period(To) = 30	/	Contract Price(/kg) = 37	/	Change Price(/kg) = 44	/	Metal Index (kg/Biz type) = 51
		ATTRIBUTE17 = 'LIOH' 	: Period(Fr) = 24	/	Period(To) = 31	/	Contract Price(/kg) = 38	/	Change Price(/kg) = 45	/	Metal Index (kg/Biz type) = 52
		ATTRIBUTE18 = 'Al' 		: Period(Fr) = 25	/	Period(To) = 32	/	Contract Price(/kg) = 39	/	Change Price(/kg) = 46	/	Metal Index (kg/Biz type) = 53
		ATTRIBUTE19 = 'Mn' 		: Period(Fr) = 26	/	Period(To) = 33	/	Contract Price(/kg) = 40	/	Change Price(/kg) = 47	/	Metal Index (kg/Biz type) = 54
		ATTRIBUTE20 = 'Cu' 		: Period(Fr) = 27	/	Period(To) = 34	/	Contract Price(/kg) = 41	/	Change Price(/kg) = 48	/	Metal Index (kg/Biz type) = 55	*/
		/* #################################################### */
		--룩업에 등록된 미사용 / 미연동 코드값 저장
		IF OBJECT_ID('TEMPDB..#TMP_NOTUSE_CODE') IS NOT NULL
			DROP TABLE #TMP_NOTUSE_CODE;

		SELECT SEGMENT3 AS NOTUSE_CODE
		INTO #TMP_NOTUSE_CODE
		FROM SCM_ADM_LOOKUP_MASTER_DETAIL METAL_KEY_MN WITH(NOLOCK)
		WHERE METAL_KEY_MN.LOOKUP_TYPE = 'METAL_KEY_VALUE'
		AND VALID_YN = 'Y'
		AND SEGMENT4 IN (N'미사용', N'미연동')


			UPDATE #TMP_EXCEL_UPLOAD_RAW
			   SET UPLOAD_STATUS_CODE = 'ERROR'
				 , MESSAGE_TEXT       = 'NEED EMPTY VALUE - Ni : '
				 + CASE WHEN ISNULL(ATTRIBUTE21,'') <> ''  THEN 'Period(Fr) ' 
						WHEN ISNULL(ATTRIBUTE28,'') <> ''  THEN 'Period(To) '
						WHEN ISNULL(ATTRIBUTE35,'') <> ''  THEN 'Contract Price '
						WHEN ISNULL(ATTRIBUTE42,'') <> ''  THEN 'Change Price '
						WHEN ISNULL(ATTRIBUTE49,'') <> ''  THEN 'Metal Index (Fr) '
						END
			 WHERE   UPLOAD_STATUS_CODE = 'UPLOAD' 
			 AND (ATTRIBUTE8 = 'Y' AND (ATTRIBUTE12 ='N' OR ATTRIBUTE12 ='')) --[PJ2024-50461]Metal Link : Y 이고 EXCEPTION : N 일때만 체크
			   AND 
			   (
					(
						ISNULL(ATTRIBUTE14,'') = '' OR ATTRIBUTE14 IN (SELECT NOTUSE_CODE FROM #TMP_NOTUSE_CODE)
					)
					AND (ISNULL(ATTRIBUTE21,'') <> '' OR ISNULL(ATTRIBUTE28,'') <> '' OR ISNULL(ATTRIBUTE35,'') <> '' OR ISNULL(ATTRIBUTE42,'') <> '' OR ISNULL(ATTRIBUTE49,'') <> '')
			   )

			UPDATE #TMP_EXCEL_UPLOAD_RAW 
			   SET UPLOAD_STATUS_CODE = 'ERROR'
				 , MESSAGE_TEXT       = 'NEED EMPTY VALUE - Co : '
				 + CASE WHEN ISNULL(ATTRIBUTE22,'') <> ''  THEN 'Period(Fr) ' 
						WHEN ISNULL(ATTRIBUTE29,'') <> ''  THEN 'Period(To) '
						WHEN ISNULL(ATTRIBUTE36,'') <> ''  THEN 'Contract Price '
						WHEN ISNULL(ATTRIBUTE43,'') <> ''  THEN 'Change Price '
						WHEN ISNULL(ATTRIBUTE50,'') <> ''  THEN 'Metal Index (Fr) '
						END
			 WHERE  UPLOAD_STATUS_CODE = 'UPLOAD' 
			 AND  (ATTRIBUTE8 = 'Y' AND (ATTRIBUTE12 ='N' OR ATTRIBUTE12 ='')) --[PJ2024-50461]Metal Link : Y 이고 EXCEPTION : N 일때만 체크
			   AND 
			   (
					(
						ISNULL(ATTRIBUTE15,'') = '' OR ATTRIBUTE15 IN (SELECT NOTUSE_CODE FROM #TMP_NOTUSE_CODE)
					)
					AND (ISNULL(ATTRIBUTE22,'') <> '' OR ISNULL(ATTRIBUTE29,'') <> '' OR ISNULL(ATTRIBUTE36,'') <> '' OR ISNULL(ATTRIBUTE43,'') <> '' OR ISNULL(ATTRIBUTE50,'') <> '')
					
			   )

			UPDATE #TMP_EXCEL_UPLOAD_RAW 
			   SET UPLOAD_STATUS_CODE = 'ERROR'
				 , MESSAGE_TEXT       = 'NEED EMPTY VALUE - Li2CO3 : '
				 + CASE WHEN ISNULL(ATTRIBUTE23,'') <> ''  THEN 'Period(Fr) ' 
						WHEN ISNULL(ATTRIBUTE30,'') <> ''  THEN 'Period(To) '
						WHEN ISNULL(ATTRIBUTE37,'') <> ''  THEN 'Contract Price '
						WHEN ISNULL(ATTRIBUTE44,'') <> ''  THEN 'Change Price '
						WHEN ISNULL(ATTRIBUTE51,'') <> ''  THEN 'Metal Index (Fr) '
						END
			 WHERE  UPLOAD_STATUS_CODE = 'UPLOAD' 
			 AND  (ATTRIBUTE8 = 'Y' AND (ATTRIBUTE12 ='N' OR ATTRIBUTE12 ='')) --[PJ2024-50461]Metal Link : Y 이고 EXCEPTION : N 일때만 체크
			   AND 
			   (
					(
						ISNULL(ATTRIBUTE16,'') = '' OR ATTRIBUTE16 IN (SELECT NOTUSE_CODE FROM #TMP_NOTUSE_CODE)
					)
					AND (ISNULL(ATTRIBUTE23,'') <> '' OR ISNULL(ATTRIBUTE30,'') <> '' OR ISNULL(ATTRIBUTE37,'') <> '' OR ISNULL(ATTRIBUTE44,'') <> '' OR ISNULL(ATTRIBUTE51,'') <> '')
			   )

			UPDATE #TMP_EXCEL_UPLOAD_RAW 
			   SET UPLOAD_STATUS_CODE = 'ERROR'
				 , MESSAGE_TEXT       = 'NEED EMPTY VALUE - LIOH : '
				 + CASE WHEN ISNULL(ATTRIBUTE24,'') <> ''  THEN 'Period(Fr) ' 
						WHEN ISNULL(ATTRIBUTE31,'') <> ''  THEN 'Period(To) '
						WHEN ISNULL(ATTRIBUTE38,'') <> ''  THEN 'Contract Price '
						WHEN ISNULL(ATTRIBUTE45,'') <> ''  THEN 'Change Price '
						WHEN ISNULL(ATTRIBUTE52,'') <> ''  THEN 'Metal Index (Fr) '
						END
			 WHERE  UPLOAD_STATUS_CODE = 'UPLOAD' 
			 AND  (ATTRIBUTE8 = 'Y' AND (ATTRIBUTE12 ='N' OR ATTRIBUTE12 ='')) --[PJ2024-50461]Metal Link : Y 이고 EXCEPTION : N 일때만 체크
			   AND 
			   (
					(
						ISNULL(ATTRIBUTE17,'') = '' OR ATTRIBUTE17 IN (SELECT NOTUSE_CODE FROM #TMP_NOTUSE_CODE)
					)
					AND (ISNULL(ATTRIBUTE24,'') <> '' OR ISNULL(ATTRIBUTE31,'') <> '' OR ISNULL(ATTRIBUTE38,'') <> '' OR ISNULL(ATTRIBUTE45,'') <> '' OR ISNULL(ATTRIBUTE52,'') <> '')
			   )

			UPDATE #TMP_EXCEL_UPLOAD_RAW 
			   SET UPLOAD_STATUS_CODE = 'ERROR'
				 , MESSAGE_TEXT       = 'NEED EMPTY VALUE - Al : '
				 + CASE WHEN ISNULL(ATTRIBUTE25,'') <> ''  THEN 'Period(Fr) ' 
						WHEN ISNULL(ATTRIBUTE32,'') <> ''  THEN 'Period(To) '
						WHEN ISNULL(ATTRIBUTE39,'') <> ''  THEN 'Contract Price '
						WHEN ISNULL(ATTRIBUTE46,'') <> ''  THEN 'Change Price '
						WHEN ISNULL(ATTRIBUTE53,'') <> ''  THEN 'Metal Index (Fr) '
						END
			 WHERE  UPLOAD_STATUS_CODE = 'UPLOAD' 
			 AND  (ATTRIBUTE8 = 'Y' AND (ATTRIBUTE12 ='N' OR ATTRIBUTE12 ='')) --[PJ2024-50461]Metal Link : Y 이고 EXCEPTION : N 일때만 체크
			   AND 
			   (
					(
						ISNULL(ATTRIBUTE18,'') = '' OR ATTRIBUTE18 IN (SELECT NOTUSE_CODE FROM #TMP_NOTUSE_CODE)
					)
					AND (ISNULL(ATTRIBUTE25,'') <> '' OR ISNULL(ATTRIBUTE32,'') <> '' OR ISNULL(ATTRIBUTE39,'') <> '' OR ISNULL(ATTRIBUTE46,'') <> '' OR ISNULL(ATTRIBUTE53,'') <> '')
			   )

			UPDATE #TMP_EXCEL_UPLOAD_RAW 
			   SET UPLOAD_STATUS_CODE = 'ERROR'
				 , MESSAGE_TEXT       = 'NEED EMPTY VALUE - Mn : '
				 + CASE WHEN ISNULL(ATTRIBUTE26,'') <> ''  THEN 'Period(Fr) ' 
						WHEN ISNULL(ATTRIBUTE33,'') <> ''  THEN 'Period(To) '
						WHEN ISNULL(ATTRIBUTE40,'') <> ''  THEN 'Contract Price '
						WHEN ISNULL(ATTRIBUTE47,'') <> ''  THEN 'Change Price '
						WHEN ISNULL(ATTRIBUTE54,'') <> ''  THEN 'Metal Index (Fr) '
						END
			 WHERE  UPLOAD_STATUS_CODE = 'UPLOAD' 
			 AND  (ATTRIBUTE8 = 'Y' AND (ATTRIBUTE12 ='N' OR ATTRIBUTE12 ='')) --[PJ2024-50461]Metal Link : Y 이고 EXCEPTION : N 일때만 체크
			   AND 
			   (
					(
						ISNULL(ATTRIBUTE19,'') = '' OR ATTRIBUTE19 IN (SELECT NOTUSE_CODE FROM #TMP_NOTUSE_CODE)
					)
					AND (ISNULL(ATTRIBUTE26,'') <> '' OR ISNULL(ATTRIBUTE33,'') <> '' OR ISNULL(ATTRIBUTE40,'') <> '' OR ISNULL(ATTRIBUTE47,'') <> '' OR ISNULL(ATTRIBUTE54,'') <> '')
			   )

			UPDATE #TMP_EXCEL_UPLOAD_RAW 
			   SET UPLOAD_STATUS_CODE = 'ERROR'
				 , MESSAGE_TEXT       = 'NEED EMPTY VALUE - Cu : '
				 + CASE WHEN ISNULL(ATTRIBUTE27,'') <> ''  THEN 'Period(Fr) ' 
						WHEN ISNULL(ATTRIBUTE34,'') <> ''  THEN 'Period(To) '
						WHEN ISNULL(ATTRIBUTE41,'') <> ''  THEN 'Contract Price '
						WHEN ISNULL(ATTRIBUTE48,'') <> ''  THEN 'Change Price '
						WHEN ISNULL(ATTRIBUTE55,'') <> ''  THEN 'Metal Index (Fr) '
						END
			 WHERE  UPLOAD_STATUS_CODE = 'UPLOAD' 
			 AND  (ATTRIBUTE8 = 'Y' AND (ATTRIBUTE12 ='N' OR ATTRIBUTE12 ='')) --[PJ2024-50461]Metal Link : Y 이고 EXCEPTION : N 일때만 체크
			   AND 
			   (
					(
						ISNULL(ATTRIBUTE20,'') = '' OR ATTRIBUTE20 IN (SELECT NOTUSE_CODE FROM #TMP_NOTUSE_CODE)
					)
					AND (ISNULL(ATTRIBUTE27,'') <> '' OR ISNULL(ATTRIBUTE34,'') <> '' OR ISNULL(ATTRIBUTE41,'') <> '' OR ISNULL(ATTRIBUTE48,'') <> '' OR ISNULL(ATTRIBUTE55,'') <> '')
			   )

		/* #################################################### */
		/* 각 광물별 입력값 체크
		광물의 값이 있고 미사용/미전송이 아닐 경우에, 쌍이되는 5개 항목 체크
        ATTRIBUTE14 = 'Ni'		: Period(Fr) = 21	/	Period(To) = 28	/	Contract Price(/kg) = 35	/	Change Price(/kg) = 42	/	Metal Index (kg/Biz type) = 49
		ATTRIBUTE15 = 'Co' 		: Period(Fr) = 22	/	Period(To) = 29	/	Contract Price(/kg) = 36	/	Change Price(/kg) = 43	/	Metal Index (kg/Biz type) = 50
		ATTRIBUTE16 = 'Li2CO3' 	: Period(Fr) = 23	/	Period(To) = 30	/	Contract Price(/kg) = 37	/	Change Price(/kg) = 44	/	Metal Index (kg/Biz type) = 51
		ATTRIBUTE17 = 'LIOH' 	: Period(Fr) = 24	/	Period(To) = 31	/	Contract Price(/kg) = 38	/	Change Price(/kg) = 45	/	Metal Index (kg/Biz type) = 52
		ATTRIBUTE18 = 'Al' 		: Period(Fr) = 25	/	Period(To) = 32	/	Contract Price(/kg) = 39	/	Change Price(/kg) = 46	/	Metal Index (kg/Biz type) = 53
		ATTRIBUTE19 = 'Mn' 		: Period(Fr) = 26	/	Period(To) = 33	/	Contract Price(/kg) = 40	/	Change Price(/kg) = 47	/	Metal Index (kg/Biz type) = 54
		ATTRIBUTE20 = 'Cu' 		: Period(Fr) = 27	/	Period(To) = 34	/	Contract Price(/kg) = 41	/	Change Price(/kg) = 48	/	Metal Index (kg/Biz type) = 55
		*/
		/*[PJ2024-50461]81번 사업부는 광물 미입력 체크 안함*/
		/* #################################################### */
		BEGIN
			UPDATE #TMP_EXCEL_UPLOAD_RAW 
			   SET UPLOAD_STATUS_CODE = 'ERROR'
				 , MESSAGE_TEXT       = 'NULL Ni : '
				 + CASE WHEN ISNULL(ATTRIBUTE21,'')=''  THEN 'Period(Fr) ' 
						WHEN ISNULL(ATTRIBUTE28,'')=''  THEN 'Period(To) '
						WHEN ISNULL(ATTRIBUTE35,'')=''  THEN 'Contract Price '
						WHEN ISNULL(ATTRIBUTE42,'')=''  THEN 'Change Price '
						WHEN ISNULL(ATTRIBUTE49,'')=''  THEN 'Metal Index (Fr) '
						END
			 WHERE  UPLOAD_STATUS_CODE = 'UPLOAD' 
			 AND  SUBSTRING(ATTRIBUTE1, 1,2) <> '81'--[PJ2024-50461]81_JV 사업부는 광물 미입력 체크 안함
			   AND		(ATTRIBUTE8 = 'Y' AND (ATTRIBUTE12 ='N' OR ATTRIBUTE12 ='')) --[PJ2024-50461]Metal Link : Y 이고 EXCEPTION : N 일때만 체크
			   AND 
			   (
					ISNULL(ATTRIBUTE14, '') <> '' AND ATTRIBUTE14 NOT IN (SELECT NOTUSE_CODE FROM #TMP_NOTUSE_CODE) AND (ISNULL(ATTRIBUTE21,'') = '' OR ISNULL(ATTRIBUTE28,'') = '' OR ISNULL(ATTRIBUTE35,'') = '' OR ISNULL(ATTRIBUTE42,'') = '' OR ISNULL(ATTRIBUTE49,'') = '')
			   )

			UPDATE #TMP_EXCEL_UPLOAD_RAW 
			   SET UPLOAD_STATUS_CODE = 'ERROR'
				 , MESSAGE_TEXT       = 'NULL Co : '
				 + CASE WHEN ISNULL(ATTRIBUTE22,'')=''  THEN 'Period(Fr) ' 
						WHEN ISNULL(ATTRIBUTE29,'')=''  THEN 'Period(To) '
						WHEN ISNULL(ATTRIBUTE36,'')=''  THEN 'Contract Price '
						WHEN ISNULL(ATTRIBUTE43,'')=''  THEN 'Change Price '
						WHEN ISNULL(ATTRIBUTE50,'')=''  THEN 'Metal Index (Fr) '
						END
			 WHERE  UPLOAD_STATUS_CODE = 'UPLOAD'
			 AND SUBSTRING(ATTRIBUTE1, 1,2) <> '81'--[PJ2024-50461]81_JV 사업부는 광물 미입력 체크 안함
			   AND		(ATTRIBUTE8 = 'Y' AND (ATTRIBUTE12 ='N' OR ATTRIBUTE12 ='')) --[PJ2024-50461]Metal Link : Y 이고 EXCEPTION : N 일때만 체크
			   AND 
			   (
					ISNULL(ATTRIBUTE15, '') <> '' AND ATTRIBUTE15 NOT IN (SELECT NOTUSE_CODE FROM #TMP_NOTUSE_CODE) AND (ISNULL(ATTRIBUTE22,'') = '' OR ISNULL(ATTRIBUTE29,'') = '' OR ISNULL(ATTRIBUTE36,'') = '' OR ISNULL(ATTRIBUTE43,'') = '' OR ISNULL(ATTRIBUTE50,'') = '')
			   )

			UPDATE #TMP_EXCEL_UPLOAD_RAW 
			   SET UPLOAD_STATUS_CODE = 'ERROR'
				 , MESSAGE_TEXT       = 'NULL Li2CO3 : '
				 + CASE WHEN ISNULL(ATTRIBUTE23,'')=''  THEN 'Period(Fr) ' 
						WHEN ISNULL(ATTRIBUTE30,'')=''  THEN 'Period(To) '
						WHEN ISNULL(ATTRIBUTE37,'')=''  THEN 'Contract Price '
						WHEN ISNULL(ATTRIBUTE44,'')=''  THEN 'Change Price '
						WHEN ISNULL(ATTRIBUTE51,'')=''  THEN 'Metal Index (Fr) '
						END
			 WHERE  UPLOAD_STATUS_CODE = 'UPLOAD' 
			 AND  SUBSTRING(ATTRIBUTE1, 1,2) <> '81'--[PJ2024-50461]81_JV 사업부는 광물 미입력 체크 안함
			   AND		(ATTRIBUTE8 = 'Y' AND (ATTRIBUTE12 ='N' OR ATTRIBUTE12 ='')) --[PJ2024-50461]Metal Link : Y 이고 EXCEPTION : N 일때만 체크
			   AND 
			   (
					ISNULL(ATTRIBUTE16, '') <> '' AND ATTRIBUTE16 NOT IN (SELECT NOTUSE_CODE FROM #TMP_NOTUSE_CODE) AND (ISNULL(ATTRIBUTE23,'') = '' OR ISNULL(ATTRIBUTE30,'') = '' OR ISNULL(ATTRIBUTE37,'') = '' OR ISNULL(ATTRIBUTE44,'') = '' OR ISNULL(ATTRIBUTE51,'') = '')
			   )

			UPDATE #TMP_EXCEL_UPLOAD_RAW 
			   SET UPLOAD_STATUS_CODE = 'ERROR'
				 , MESSAGE_TEXT       = 'NULL LIOH : '
				 + CASE WHEN ISNULL(ATTRIBUTE24,'')=''  THEN 'Period(Fr) ' 
						WHEN ISNULL(ATTRIBUTE31,'')=''  THEN 'Period(To) '
						WHEN ISNULL(ATTRIBUTE38,'')=''  THEN 'Contract Price '
						WHEN ISNULL(ATTRIBUTE45,'')=''  THEN 'Change Price '
						WHEN ISNULL(ATTRIBUTE52,'')=''  THEN 'Metal Index (Fr) '
						END
			 WHERE  UPLOAD_STATUS_CODE = 'UPLOAD' 
			 AND  SUBSTRING(ATTRIBUTE1, 1,2) <> '81'--[PJ2024-50461]81_JV 사업부는 광물 미입력 체크 안함
			   AND		(ATTRIBUTE8 = 'Y' AND (ATTRIBUTE12 ='N' OR ATTRIBUTE12 ='')) --[PJ2024-50461]Metal Link : Y 이고 EXCEPTION : N 일때만 체크
			   AND 
			   (
					ISNULL(ATTRIBUTE17, '') <> '' AND ATTRIBUTE17 NOT IN (SELECT NOTUSE_CODE FROM #TMP_NOTUSE_CODE) AND (ISNULL(ATTRIBUTE24,'') = '' OR ISNULL(ATTRIBUTE31,'') = '' OR ISNULL(ATTRIBUTE38,'') = '' OR ISNULL(ATTRIBUTE45,'') = '' OR ISNULL(ATTRIBUTE52,'') = '')
			   )

			UPDATE #TMP_EXCEL_UPLOAD_RAW
			   SET UPLOAD_STATUS_CODE = 'ERROR'
				 , MESSAGE_TEXT       = 'NULL Al : '
				 + CASE WHEN ISNULL(ATTRIBUTE25,'')=''  THEN 'Period(Fr) ' 
						WHEN ISNULL(ATTRIBUTE32,'')=''  THEN 'Period(To) '
						WHEN ISNULL(ATTRIBUTE39,'')=''  THEN 'Contract Price '
						WHEN ISNULL(ATTRIBUTE46,'')=''  THEN 'Change Price '
						WHEN ISNULL(ATTRIBUTE53,'')=''  THEN 'Metal Index (Fr) '
						END
			 WHERE  UPLOAD_STATUS_CODE = 'UPLOAD' 
			 AND  SUBSTRING(ATTRIBUTE1, 1,2) <> '81'--[PJ2024-50461]81_JV 사업부는 광물 미입력 체크 안함
			   AND		(ATTRIBUTE8 = 'Y' AND (ATTRIBUTE12 ='N' OR ATTRIBUTE12 ='')) --[PJ2024-50461]Metal Link : Y 이고 EXCEPTION : N 일때만 체크
			   AND 
			   (
					ISNULL(ATTRIBUTE18, '') <> '' AND ATTRIBUTE18 NOT IN (SELECT NOTUSE_CODE FROM #TMP_NOTUSE_CODE) AND (ISNULL(ATTRIBUTE25,'') = '' OR ISNULL(ATTRIBUTE32,'') = '' OR ISNULL(ATTRIBUTE39,'') = '' OR ISNULL(ATTRIBUTE46,'') = '' OR ISNULL(ATTRIBUTE53,'') = '')
			   )

			UPDATE #TMP_EXCEL_UPLOAD_RAW 
			   SET UPLOAD_STATUS_CODE = 'ERROR'
				 , MESSAGE_TEXT       = 'NULL Mn : '
				 + CASE WHEN ISNULL(ATTRIBUTE26,'')=''  THEN 'Period(Fr) ' 
						WHEN ISNULL(ATTRIBUTE33,'')=''  THEN 'Period(To) '
						WHEN ISNULL(ATTRIBUTE40,'')=''  THEN 'Contract Price '
						WHEN ISNULL(ATTRIBUTE47,'')=''  THEN 'Change Price '
						WHEN ISNULL(ATTRIBUTE54,'')=''  THEN 'Metal Index (Fr) '
						END
			 WHERE  UPLOAD_STATUS_CODE = 'UPLOAD' 
			 AND  SUBSTRING(ATTRIBUTE1, 1,2) <> '81'--[PJ2024-50461]81_JV 사업부는 광물 미입력 체크 안함
			   AND		(ATTRIBUTE8 = 'Y' AND (ATTRIBUTE12 ='N' OR ATTRIBUTE12 ='')) --[PJ2024-50461]Metal Link : Y 이고 EXCEPTION : N 일때만 체크
			   AND 
			   (
					ISNULL(ATTRIBUTE19, '') <> '' AND ATTRIBUTE19 NOT IN (SELECT NOTUSE_CODE FROM #TMP_NOTUSE_CODE) AND (ISNULL(ATTRIBUTE26,'') = '' OR ISNULL(ATTRIBUTE33,'') = '' OR ISNULL(ATTRIBUTE40,'') = '' OR ISNULL(ATTRIBUTE47,'') = '' OR ISNULL(ATTRIBUTE54,'') = '')
			   )

			UPDATE #TMP_EXCEL_UPLOAD_RAW 
			   SET UPLOAD_STATUS_CODE = 'ERROR'
				 , MESSAGE_TEXT       = 'NULL Cu : '
				 + CASE WHEN ISNULL(ATTRIBUTE27,'')=''  THEN 'Period(Fr) ' 
						WHEN ISNULL(ATTRIBUTE34,'')=''  THEN 'Period(To) '
						WHEN ISNULL(ATTRIBUTE41,'')=''  THEN 'Contract Price '
						WHEN ISNULL(ATTRIBUTE48,'')=''  THEN 'Change Price '
						WHEN ISNULL(ATTRIBUTE55,'')=''  THEN 'Metal Index (Fr) '
						END
			 WHERE  UPLOAD_STATUS_CODE = 'UPLOAD' 
			 AND  SUBSTRING(ATTRIBUTE1, 1,2) <> '81'--[PJ2024-50461]81_JV 사업부는 광물 미입력 체크 안함
			   AND		(ATTRIBUTE8 = 'Y' AND (ATTRIBUTE12 ='N' OR ATTRIBUTE12 ='')) --[PJ2024-50461]Metal Link : Y 이고 EXCEPTION : N 일때만 체크
			   AND 
			   (
					ISNULL(ATTRIBUTE20, '') <> '' AND ATTRIBUTE20 NOT IN (SELECT NOTUSE_CODE FROM #TMP_NOTUSE_CODE) AND (ISNULL(ATTRIBUTE27,'') = '' OR ISNULL(ATTRIBUTE34,'') = '' OR ISNULL(ATTRIBUTE41,'') = '' OR ISNULL(ATTRIBUTE48,'') = '' OR ISNULL(ATTRIBUTE55,'') = '')
			   )
		END;


		/* #################################################### */
		/* 숫자여부 체크(ATTRIBUTE21 ~ ATTRIBUTE55)	
			FROM_PERIOD_YYYYMM							
			TO_PERIOD_YYYYMM							
			CONTRACT_UNIT_PRICE							
			METAL_APPLY_UNIT_PRICE							
			METAL_REQR_QTY			
		*/
		/* #################################################### */
		BEGIN
			UPDATE #TMP_EXCEL_UPLOAD_RAW 
			   SET UPLOAD_STATUS_CODE = 'ERROR'
				 , MESSAGE_TEXT       = 'Invalid NUMERIC.'
			 WHERE  UPLOAD_STATUS_CODE = 'UPLOAD' 
			 AND  (ATTRIBUTE8 = 'Y' AND (ATTRIBUTE12 ='N' OR ATTRIBUTE12 ='')) --[PJ2024-50461]Metal Link : Y 이고 EXCEPTION : N 일때만 체크
			   AND 
			   (
					(ISNULL(ATTRIBUTE21, '') <> '' AND ISNUMERIC(ATTRIBUTE21) = 0) OR
					(ISNULL(ATTRIBUTE22, '') <> '' AND ISNUMERIC(ATTRIBUTE22) = 0) OR
					(ISNULL(ATTRIBUTE23, '') <> '' AND ISNUMERIC(ATTRIBUTE23) = 0) OR
					(ISNULL(ATTRIBUTE24, '') <> '' AND ISNUMERIC(ATTRIBUTE24) = 0) OR
					(ISNULL(ATTRIBUTE25, '') <> '' AND ISNUMERIC(ATTRIBUTE25) = 0) OR
					(ISNULL(ATTRIBUTE26, '') <> '' AND ISNUMERIC(ATTRIBUTE26) = 0) OR
					(ISNULL(ATTRIBUTE27, '') <> '' AND ISNUMERIC(ATTRIBUTE27) = 0) OR
					(ISNULL(ATTRIBUTE28, '') <> '' AND ISNUMERIC(ATTRIBUTE28) = 0) OR
					(ISNULL(ATTRIBUTE29, '') <> '' AND ISNUMERIC(ATTRIBUTE29) = 0) OR
					(ISNULL(ATTRIBUTE30, '') <> '' AND ISNUMERIC(ATTRIBUTE30) = 0) OR
					(ISNULL(ATTRIBUTE31, '') <> '' AND ISNUMERIC(ATTRIBUTE31) = 0) OR
					(ISNULL(ATTRIBUTE32, '') <> '' AND ISNUMERIC(ATTRIBUTE32) = 0) OR
					(ISNULL(ATTRIBUTE33, '') <> '' AND ISNUMERIC(ATTRIBUTE33) = 0) OR
					(ISNULL(ATTRIBUTE34, '') <> '' AND ISNUMERIC(ATTRIBUTE34) = 0) OR
					(ISNULL(ATTRIBUTE35, '') <> '' AND ISNUMERIC(ATTRIBUTE35) = 0) OR
					(ISNULL(ATTRIBUTE36, '') <> '' AND ISNUMERIC(ATTRIBUTE36) = 0) OR
					(ISNULL(ATTRIBUTE37, '') <> '' AND ISNUMERIC(ATTRIBUTE37) = 0) OR
					(ISNULL(ATTRIBUTE38, '') <> '' AND ISNUMERIC(ATTRIBUTE38) = 0) OR
					(ISNULL(ATTRIBUTE39, '') <> '' AND ISNUMERIC(ATTRIBUTE39) = 0) OR
					(ISNULL(ATTRIBUTE40, '') <> '' AND ISNUMERIC(ATTRIBUTE40) = 0) OR
					(ISNULL(ATTRIBUTE41, '') <> '' AND ISNUMERIC(ATTRIBUTE41) = 0) OR
					(ISNULL(ATTRIBUTE42, '') <> '' AND ISNUMERIC(ATTRIBUTE42) = 0) OR
					(ISNULL(ATTRIBUTE43, '') <> '' AND ISNUMERIC(ATTRIBUTE43) = 0) OR
					(ISNULL(ATTRIBUTE44, '') <> '' AND ISNUMERIC(ATTRIBUTE44) = 0) OR
					(ISNULL(ATTRIBUTE45, '') <> '' AND ISNUMERIC(ATTRIBUTE45) = 0) OR
					(ISNULL(ATTRIBUTE46, '') <> '' AND ISNUMERIC(ATTRIBUTE46) = 0) OR
					(ISNULL(ATTRIBUTE47, '') <> '' AND ISNUMERIC(ATTRIBUTE47) = 0) OR
					(ISNULL(ATTRIBUTE48, '') <> '' AND ISNUMERIC(ATTRIBUTE48) = 0) OR
					(ISNULL(ATTRIBUTE49, '') <> '' AND ISNUMERIC(ATTRIBUTE49) = 0) OR
					(ISNULL(ATTRIBUTE50, '') <> '' AND ISNUMERIC(ATTRIBUTE50) = 0) OR
					(ISNULL(ATTRIBUTE51, '') <> '' AND ISNUMERIC(ATTRIBUTE51) = 0) OR
					(ISNULL(ATTRIBUTE52, '') <> '' AND ISNUMERIC(ATTRIBUTE52) = 0) OR
					(ISNULL(ATTRIBUTE53, '') <> '' AND ISNUMERIC(ATTRIBUTE53) = 0) OR
					(ISNULL(ATTRIBUTE54, '') <> '' AND ISNUMERIC(ATTRIBUTE54) = 0) OR
					(ISNULL(ATTRIBUTE55, '') <> '' AND ISNUMERIC(ATTRIBUTE55) = 0) 
			   )

		END;

		/* #################################################### */
		/* 마이너스 여부 체크(ATTRIBUTE21 ~ ATTRIBUTE55)	
			FROM_PERIOD_YYYYMM							
			TO_PERIOD_YYYYMM							
			CONTRACT_UNIT_PRICE							
			METAL_APPLY_UNIT_PRICE							
			METAL_REQR_QTY(Metal Index OR Cost Impact : 이름변경 필요?)	=>음수체크 제외		(49 ~ 55)										*/
		/* #################################################### */
		BEGIN
			UPDATE #TMP_EXCEL_UPLOAD_RAW 
			   SET UPLOAD_STATUS_CODE = 'ERROR'
				 , MESSAGE_TEXT       = 'Negative Number.'
			 WHERE  UPLOAD_STATUS_CODE = 'UPLOAD' 
			 AND  (ATTRIBUTE8 = 'Y' AND (ATTRIBUTE12 ='N' OR ATTRIBUTE12 ='')) --[PJ2024-50461]Metal Link : Y 이고 EXCEPTION : N 일때만 체크
			   AND 
			   (
					(ISNULL(ATTRIBUTE21, '') <> '' AND ISNUMERIC(ATTRIBUTE21) = 1 AND CONVERT(FLOAT, ATTRIBUTE21) < 0) OR
					(ISNULL(ATTRIBUTE22, '') <> '' AND ISNUMERIC(ATTRIBUTE22) = 1 AND CONVERT(FLOAT, ATTRIBUTE22) < 0) OR
					(ISNULL(ATTRIBUTE23, '') <> '' AND ISNUMERIC(ATTRIBUTE23) = 1 AND CONVERT(FLOAT, ATTRIBUTE23) < 0) OR
					(ISNULL(ATTRIBUTE24, '') <> '' AND ISNUMERIC(ATTRIBUTE24) = 1 AND CONVERT(FLOAT, ATTRIBUTE24) < 0) OR
					(ISNULL(ATTRIBUTE25, '') <> '' AND ISNUMERIC(ATTRIBUTE25) = 1 AND CONVERT(FLOAT, ATTRIBUTE25) < 0) OR
					(ISNULL(ATTRIBUTE26, '') <> '' AND ISNUMERIC(ATTRIBUTE26) = 1 AND CONVERT(FLOAT, ATTRIBUTE26) < 0) OR
					(ISNULL(ATTRIBUTE27, '') <> '' AND ISNUMERIC(ATTRIBUTE27) = 1 AND CONVERT(FLOAT, ATTRIBUTE27) < 0) OR
					(ISNULL(ATTRIBUTE28, '') <> '' AND ISNUMERIC(ATTRIBUTE28) = 1 AND CONVERT(FLOAT, ATTRIBUTE28) < 0) OR
					(ISNULL(ATTRIBUTE29, '') <> '' AND ISNUMERIC(ATTRIBUTE29) = 1 AND CONVERT(FLOAT, ATTRIBUTE29) < 0) OR
					(ISNULL(ATTRIBUTE30, '') <> '' AND ISNUMERIC(ATTRIBUTE30) = 1 AND CONVERT(FLOAT, ATTRIBUTE30) < 0) OR
					(ISNULL(ATTRIBUTE31, '') <> '' AND ISNUMERIC(ATTRIBUTE31) = 1 AND CONVERT(FLOAT, ATTRIBUTE31) < 0) OR
					(ISNULL(ATTRIBUTE32, '') <> '' AND ISNUMERIC(ATTRIBUTE32) = 1 AND CONVERT(FLOAT, ATTRIBUTE32) < 0) OR
					(ISNULL(ATTRIBUTE33, '') <> '' AND ISNUMERIC(ATTRIBUTE33) = 1 AND CONVERT(FLOAT, ATTRIBUTE33) < 0) OR
					(ISNULL(ATTRIBUTE34, '') <> '' AND ISNUMERIC(ATTRIBUTE34) = 1 AND CONVERT(FLOAT, ATTRIBUTE34) < 0) OR
					(ISNULL(ATTRIBUTE35, '') <> '' AND ISNUMERIC(ATTRIBUTE35) = 1 AND CONVERT(FLOAT, ATTRIBUTE35) < 0) OR
					(ISNULL(ATTRIBUTE36, '') <> '' AND ISNUMERIC(ATTRIBUTE36) = 1 AND CONVERT(FLOAT, ATTRIBUTE36) < 0) OR
					(ISNULL(ATTRIBUTE37, '') <> '' AND ISNUMERIC(ATTRIBUTE37) = 1 AND CONVERT(FLOAT, ATTRIBUTE37) < 0) OR
					(ISNULL(ATTRIBUTE38, '') <> '' AND ISNUMERIC(ATTRIBUTE38) = 1 AND CONVERT(FLOAT, ATTRIBUTE38) < 0) OR
					(ISNULL(ATTRIBUTE39, '') <> '' AND ISNUMERIC(ATTRIBUTE39) = 1 AND CONVERT(FLOAT, ATTRIBUTE39) < 0) OR
					(ISNULL(ATTRIBUTE40, '') <> '' AND ISNUMERIC(ATTRIBUTE40) = 1 AND CONVERT(FLOAT, ATTRIBUTE40) < 0) OR
					(ISNULL(ATTRIBUTE41, '') <> '' AND ISNUMERIC(ATTRIBUTE41) = 1 AND CONVERT(FLOAT, ATTRIBUTE41) < 0) OR
					(ISNULL(ATTRIBUTE42, '') <> '' AND ISNUMERIC(ATTRIBUTE42) = 1 AND CONVERT(FLOAT, ATTRIBUTE42) < 0) OR
					(ISNULL(ATTRIBUTE43, '') <> '' AND ISNUMERIC(ATTRIBUTE43) = 1 AND CONVERT(FLOAT, ATTRIBUTE43) < 0) OR
					(ISNULL(ATTRIBUTE44, '') <> '' AND ISNUMERIC(ATTRIBUTE44) = 1 AND CONVERT(FLOAT, ATTRIBUTE44) < 0) OR
					(ISNULL(ATTRIBUTE45, '') <> '' AND ISNUMERIC(ATTRIBUTE45) = 1 AND CONVERT(FLOAT, ATTRIBUTE45) < 0) OR
					(ISNULL(ATTRIBUTE46, '') <> '' AND ISNUMERIC(ATTRIBUTE46) = 1 AND CONVERT(FLOAT, ATTRIBUTE46) < 0) OR
					(ISNULL(ATTRIBUTE47, '') <> '' AND ISNUMERIC(ATTRIBUTE47) = 1 AND CONVERT(FLOAT, ATTRIBUTE47) < 0) OR
					(ISNULL(ATTRIBUTE48, '') <> '' AND ISNUMERIC(ATTRIBUTE48) = 1 AND CONVERT(FLOAT, ATTRIBUTE48) < 0) 
			   )

		END;

		/* #################################################### */
		/* 0 ~ 12 여부 체크(ATTRIBUTE21 ~ ATTRIBUTE34)	
			FROM_PERIOD_YYYYMM							
			TO_PERIOD_YYYYMM	
			정수만 입력가능
			1)12보다 큰가
			2).이 있나
			
			*/
		/* #################################################### */
		BEGIN
			UPDATE #TMP_EXCEL_UPLOAD_RAW 
			   SET UPLOAD_STATUS_CODE = 'ERROR'
				 , MESSAGE_TEXT       = 'Invalid INTEGER 0 ~ 12.'
			 WHERE  UPLOAD_STATUS_CODE = 'UPLOAD' 
			 AND  (ATTRIBUTE8 = 'Y' AND (ATTRIBUTE12 ='N' OR ATTRIBUTE12 ='')) --[PJ2024-50461]Metal Link : Y 이고 EXCEPTION : N 일때만 체크
			   AND 
			   (
					(ISNULL(ATTRIBUTE21, '') <> '' AND ISNUMERIC(ATTRIBUTE21) = 1 AND (CONVERT(FLOAT, ATTRIBUTE21) > 12 OR CHARINDEX('.', ATTRIBUTE21) > 0)) OR
					(ISNULL(ATTRIBUTE22, '') <> '' AND ISNUMERIC(ATTRIBUTE22) = 1 AND (CONVERT(FLOAT, ATTRIBUTE22) > 12 OR CHARINDEX('.', ATTRIBUTE22) > 0)) OR
					(ISNULL(ATTRIBUTE23, '') <> '' AND ISNUMERIC(ATTRIBUTE23) = 1 AND (CONVERT(FLOAT, ATTRIBUTE23) > 12 OR CHARINDEX('.', ATTRIBUTE23) > 0)) OR
					(ISNULL(ATTRIBUTE24, '') <> '' AND ISNUMERIC(ATTRIBUTE24) = 1 AND (CONVERT(FLOAT, ATTRIBUTE24) > 12 OR CHARINDEX('.', ATTRIBUTE24) > 0)) OR
					(ISNULL(ATTRIBUTE25, '') <> '' AND ISNUMERIC(ATTRIBUTE25) = 1 AND (CONVERT(FLOAT, ATTRIBUTE25) > 12 OR CHARINDEX('.', ATTRIBUTE25) > 0)) OR
					(ISNULL(ATTRIBUTE26, '') <> '' AND ISNUMERIC(ATTRIBUTE26) = 1 AND (CONVERT(FLOAT, ATTRIBUTE26) > 12 OR CHARINDEX('.', ATTRIBUTE26) > 0)) OR
					(ISNULL(ATTRIBUTE27, '') <> '' AND ISNUMERIC(ATTRIBUTE27) = 1 AND (CONVERT(FLOAT, ATTRIBUTE27) > 12 OR CHARINDEX('.', ATTRIBUTE27) > 0)) OR
					(ISNULL(ATTRIBUTE28, '') <> '' AND ISNUMERIC(ATTRIBUTE28) = 1 AND (CONVERT(FLOAT, ATTRIBUTE28) > 12 OR CHARINDEX('.', ATTRIBUTE28) > 0)) OR
					(ISNULL(ATTRIBUTE29, '') <> '' AND ISNUMERIC(ATTRIBUTE29) = 1 AND (CONVERT(FLOAT, ATTRIBUTE29) > 12 OR CHARINDEX('.', ATTRIBUTE29) > 0)) OR
					(ISNULL(ATTRIBUTE30, '') <> '' AND ISNUMERIC(ATTRIBUTE30) = 1 AND (CONVERT(FLOAT, ATTRIBUTE30) > 12 OR CHARINDEX('.', ATTRIBUTE30) > 0)) OR
					(ISNULL(ATTRIBUTE31, '') <> '' AND ISNUMERIC(ATTRIBUTE31) = 1 AND (CONVERT(FLOAT, ATTRIBUTE31) > 12 OR CHARINDEX('.', ATTRIBUTE31) > 0)) OR
					(ISNULL(ATTRIBUTE32, '') <> '' AND ISNUMERIC(ATTRIBUTE32) = 1 AND (CONVERT(FLOAT, ATTRIBUTE32) > 12 OR CHARINDEX('.', ATTRIBUTE32) > 0)) OR
					(ISNULL(ATTRIBUTE33, '') <> '' AND ISNUMERIC(ATTRIBUTE33) = 1 AND (CONVERT(FLOAT, ATTRIBUTE33) > 12 OR CHARINDEX('.', ATTRIBUTE33) > 0)) OR
					(ISNULL(ATTRIBUTE34, '') <> '' AND ISNUMERIC(ATTRIBUTE34) = 1 AND (CONVERT(FLOAT, ATTRIBUTE34) > 12 OR CHARINDEX('.', ATTRIBUTE34) > 0))
			   )

		END;

		/* #################################################### */
		/* Period(To) < Period(From) 체크(ATTRIBUTE21 ~ ATTRIBUTE34)	
			From 이 커야 함
			쌍이 되는 ATTRIBUTE
			ATTRIBUTE21 : ATTRIBUTE28
			ATTRIBUTE22 : ATTRIBUTE29
			ATTRIBUTE23 : ATTRIBUTE30
			ATTRIBUTE24 : ATTRIBUTE31
			ATTRIBUTE25 : ATTRIBUTE32
			ATTRIBUTE26 : ATTRIBUTE33
			ATTRIBUTE27 : ATTRIBUTE34
			체크 로직 : 쌍이 되는 ATTRIBUTE 둘다 빈 값이 아니고, 둘 다 숫자이고, FROM VALUE <= TO VALUE 이면 튕겨냄
			*/
		/* #################################################### */
		BEGIN
			UPDATE #TMP_EXCEL_UPLOAD_RAW 
			   SET UPLOAD_STATUS_CODE = 'ERROR'
				 , MESSAGE_TEXT       = 'From Value must be larger than To Value.'
			 WHERE  UPLOAD_STATUS_CODE = 'UPLOAD' 
			 AND  (ATTRIBUTE8 = 'Y' AND (ATTRIBUTE12 ='N' OR ATTRIBUTE12 ='')) --[PJ2024-50461]Metal Link : Y 이고 EXCEPTION : N 일때만 체크
			   AND 
			   (
					(ISNULL(ATTRIBUTE21, '') <> '' AND ISNULL(ATTRIBUTE28, '') <> '' AND ISNUMERIC(ATTRIBUTE21) = 1 AND ISNUMERIC(ATTRIBUTE28) = 1 AND CONVERT(FLOAT, ATTRIBUTE21) <= CONVERT(FLOAT, ATTRIBUTE28)) OR
					(ISNULL(ATTRIBUTE22, '') <> '' AND ISNULL(ATTRIBUTE29, '') <> '' AND ISNUMERIC(ATTRIBUTE22) = 1 AND ISNUMERIC(ATTRIBUTE29) = 1 AND CONVERT(FLOAT, ATTRIBUTE22) <= CONVERT(FLOAT, ATTRIBUTE29)) OR
					(ISNULL(ATTRIBUTE23, '') <> '' AND ISNULL(ATTRIBUTE30, '') <> '' AND ISNUMERIC(ATTRIBUTE23) = 1 AND ISNUMERIC(ATTRIBUTE30) = 1 AND CONVERT(FLOAT, ATTRIBUTE23) <= CONVERT(FLOAT, ATTRIBUTE30)) OR
					(ISNULL(ATTRIBUTE24, '') <> '' AND ISNULL(ATTRIBUTE31, '') <> '' AND ISNUMERIC(ATTRIBUTE24) = 1 AND ISNUMERIC(ATTRIBUTE31) = 1 AND CONVERT(FLOAT, ATTRIBUTE24) <= CONVERT(FLOAT, ATTRIBUTE31)) OR
					(ISNULL(ATTRIBUTE25, '') <> '' AND ISNULL(ATTRIBUTE32, '') <> '' AND ISNUMERIC(ATTRIBUTE25) = 1 AND ISNUMERIC(ATTRIBUTE32) = 1 AND CONVERT(FLOAT, ATTRIBUTE25) <= CONVERT(FLOAT, ATTRIBUTE32)) OR
					(ISNULL(ATTRIBUTE26, '') <> '' AND ISNULL(ATTRIBUTE33, '') <> '' AND ISNUMERIC(ATTRIBUTE26) = 1 AND ISNUMERIC(ATTRIBUTE33) = 1 AND CONVERT(FLOAT, ATTRIBUTE26) <= CONVERT(FLOAT, ATTRIBUTE33)) OR
					(ISNULL(ATTRIBUTE27, '') <> '' AND ISNULL(ATTRIBUTE34, '') <> '' AND ISNUMERIC(ATTRIBUTE27) = 1 AND ISNUMERIC(ATTRIBUTE34) = 1 AND CONVERT(FLOAT, ATTRIBUTE27) <= CONVERT(FLOAT, ATTRIBUTE34))
			   )

			SET @v_log_type = 'UPDATE';
			SET @n_log_count = @n_log_count + 1;
			SET @v_log_message = '########## END : VALIDATION CHECK. ##########';
			SET @v_description = CONVERT(nvarchar,@@ROWCOUNT);
			SET @d_event_date = SYSDATETIME();

			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		END;

		/* #################################################### */
		/* 소숫점 2자리 체크(ATTRIBUTE35 ~ ATTRIBUTE55)			*/
		/* 체크 안하고 셋째 자리에서 반올림 처리해서 둘째자리까지 반영(2024.07.08 박필수 책임 확인)*/
		/* #################################################### */
		/*BEGIN
			UPDATE [dbo].[SCM_ADM_EXCEL_UPLOAD] 
			   SET UPLOAD_STATUS_CODE = 'ERROR'
				 , MESSAGE_TEXT       = 'Invalid two decimal places.'
			 WHERE PROGRAM_ID         = @v_program_id
			   AND SHEET_NAME         = @v_sheet_name
			   AND CREATED_BY         = @p_created_by
			   AND CONVERT(NVARCHAR(40), CREATION_DATE, 121) = @v_creation_date
			   AND UPLOAD_STATUS_CODE = 'UPLOAD'
			   AND 
			   (
					(ISNULL(ATTRIBUTE35, '') <> '' AND ISNUMERIC(ATTRIBUTE35) = 1 AND LEN(DBO.FN_SCM_SPLIT(ATTRIBUTE35, 2, '.')) > 2) OR
					(ISNULL(ATTRIBUTE36, '') <> '' AND ISNUMERIC(ATTRIBUTE36) = 1 AND LEN(DBO.FN_SCM_SPLIT(ATTRIBUTE36, 2, '.')) > 2) OR
					(ISNULL(ATTRIBUTE37, '') <> '' AND ISNUMERIC(ATTRIBUTE37) = 1 AND LEN(DBO.FN_SCM_SPLIT(ATTRIBUTE37, 2, '.')) > 2) OR
					(ISNULL(ATTRIBUTE38, '') <> '' AND ISNUMERIC(ATTRIBUTE38) = 1 AND LEN(DBO.FN_SCM_SPLIT(ATTRIBUTE38, 2, '.')) > 2) OR
					(ISNULL(ATTRIBUTE39, '') <> '' AND ISNUMERIC(ATTRIBUTE39) = 1 AND LEN(DBO.FN_SCM_SPLIT(ATTRIBUTE39, 2, '.')) > 2) OR
					(ISNULL(ATTRIBUTE40, '') <> '' AND ISNUMERIC(ATTRIBUTE40) = 1 AND LEN(DBO.FN_SCM_SPLIT(ATTRIBUTE40, 2, '.')) > 2) OR
					(ISNULL(ATTRIBUTE41, '') <> '' AND ISNUMERIC(ATTRIBUTE41) = 1 AND LEN(DBO.FN_SCM_SPLIT(ATTRIBUTE41, 2, '.')) > 2) OR
					(ISNULL(ATTRIBUTE42, '') <> '' AND ISNUMERIC(ATTRIBUTE42) = 1 AND LEN(DBO.FN_SCM_SPLIT(ATTRIBUTE42, 2, '.')) > 2) OR
					(ISNULL(ATTRIBUTE43, '') <> '' AND ISNUMERIC(ATTRIBUTE43) = 1 AND LEN(DBO.FN_SCM_SPLIT(ATTRIBUTE43, 2, '.')) > 2) OR
					(ISNULL(ATTRIBUTE44, '') <> '' AND ISNUMERIC(ATTRIBUTE44) = 1 AND LEN(DBO.FN_SCM_SPLIT(ATTRIBUTE44, 2, '.')) > 2) OR
					(ISNULL(ATTRIBUTE45, '') <> '' AND ISNUMERIC(ATTRIBUTE45) = 1 AND LEN(DBO.FN_SCM_SPLIT(ATTRIBUTE45, 2, '.')) > 2) OR
					(ISNULL(ATTRIBUTE46, '') <> '' AND ISNUMERIC(ATTRIBUTE46) = 1 AND LEN(DBO.FN_SCM_SPLIT(ATTRIBUTE46, 2, '.')) > 2) OR
					(ISNULL(ATTRIBUTE47, '') <> '' AND ISNUMERIC(ATTRIBUTE47) = 1 AND LEN(DBO.FN_SCM_SPLIT(ATTRIBUTE47, 2, '.')) > 2) OR
					(ISNULL(ATTRIBUTE48, '') <> '' AND ISNUMERIC(ATTRIBUTE48) = 1 AND LEN(DBO.FN_SCM_SPLIT(ATTRIBUTE48, 2, '.')) > 2) OR
					(ISNULL(ATTRIBUTE49, '') <> '' AND ISNUMERIC(ATTRIBUTE49) = 1 AND LEN(DBO.FN_SCM_SPLIT(ATTRIBUTE49, 2, '.')) > 2) OR
					(ISNULL(ATTRIBUTE50, '') <> '' AND ISNUMERIC(ATTRIBUTE50) = 1 AND LEN(DBO.FN_SCM_SPLIT(ATTRIBUTE50, 2, '.')) > 2) OR
					(ISNULL(ATTRIBUTE51, '') <> '' AND ISNUMERIC(ATTRIBUTE51) = 1 AND LEN(DBO.FN_SCM_SPLIT(ATTRIBUTE51, 2, '.')) > 2) OR
					(ISNULL(ATTRIBUTE52, '') <> '' AND ISNUMERIC(ATTRIBUTE52) = 1 AND LEN(DBO.FN_SCM_SPLIT(ATTRIBUTE52, 2, '.')) > 2) OR
					(ISNULL(ATTRIBUTE53, '') <> '' AND ISNUMERIC(ATTRIBUTE53) = 1 AND LEN(DBO.FN_SCM_SPLIT(ATTRIBUTE53, 2, '.')) > 2) OR
					(ISNULL(ATTRIBUTE54, '') <> '' AND ISNUMERIC(ATTRIBUTE54) = 1 AND LEN(DBO.FN_SCM_SPLIT(ATTRIBUTE54, 2, '.')) > 2) OR
					(ISNULL(ATTRIBUTE55, '') <> '' AND ISNUMERIC(ATTRIBUTE55) = 1 AND LEN(DBO.FN_SCM_SPLIT(ATTRIBUTE55, 2, '.')) > 2)
			   )

			SET @v_log_type = 'UPDATE';
			SET @n_log_count = @n_log_count + 1;
			SET @v_log_message = '########## Invalid two decimal places. ##########';
			SET @v_description = CONVERT(nvarchar,@@ROWCOUNT);
			SET @d_event_date = SYSDATETIME();

			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		END;
		*/


		-----------------------------------------------------------------------------------------------
		--[PJ2024-50611]VALIDATION 결과를 원본 테이블에 업데이트한다
		BEGIN
		UPDATE SCM_ADM_EXCEL_UPLOAD
		SET
			UPLOAD_STATUS_CODE = TMP.UPLOAD_STATUS_CODE
			,MESSAGE_TEXT = TMP.MESSAGE_TEXT
		FROM #TMP_EXCEL_UPLOAD_RAW TMP
		WHERE SCM_ADM_EXCEL_UPLOAD.UPLOAD_ID = TMP.UPLOAD_ID
		AND TMP.UPLOAD_STATUS_CODE = 'ERROR'
		END;
		-----------------------------------------------------------------------------------------------

		-- 정상(SUCCESS) 처리
		BEGIN
		UPDATE [dbo].[SCM_ADM_EXCEL_UPLOAD] 
        SET    UPLOAD_STATUS_CODE = 'SUCCESS'
        WHERE  PROGRAM_ID         LIKE @v_program_id + '%'
        AND    SHEET_NAME         = @v_sheet_name
        AND    CREATED_BY         = @p_created_by
        AND    CONVERT(NVARCHAR(40), CREATION_DATE, 121)  = @v_creation_date
        AND    UPLOAD_STATUS_CODE = 'UPLOAD';
		END;

		BEGIN
        ----------------------------------------------------------------------------
        --scm2_mgr.xLOG('SUCCESS              ', SQL%ROWCOUNT, 10, TRUE);
	    SET @v_log_type = '16';
	    SET @v_log_message = '########## SUCCESS ##########';
	    SET @v_description = '';
	    SET @d_event_date = SYSDATETIME();
	    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
        ----------------------------------------------------------------------------
		END;

	END

------------------------------------- validation 로직 종료 ----------------------------------------------
------------------------------------- validation 로직 종료 ----------------------------------------------
------------------------------------- validation 로직 종료 ----------------------------------------------

	BEGIN
    ----------------------------------------------------------------------------
    --scm2_mgr.xLOG('SUCCESS              ', SQL%ROWCOUNT, 10, TRUE);
	SET @v_log_type = '17';
	SET @v_log_message = '########## INSERT DATA START ##########';
	SET @v_description = @p_mode; --CONVERT(CHAR(30), @v_creation_date, 121);
	SET @d_event_date = SYSDATETIME();
	EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
    ----------------------------------------------------------------------------
	END;

    --//======================================================================================
    SELECT @v_count = COUNT(1)
    FROM   [dbo].[SCM_ADM_EXCEL_UPLOAD] T  WITH(NOLOCK)
    WHERE  T.PROGRAM_ID          LIKE @v_program_id + '%'
    AND    T.SHEET_NAME         = @v_sheet_name
    AND    T.CREATED_BY         = @p_created_by
    AND    CONVERT(NVARCHAR(40), T.CREATION_DATE, 121) = @v_creation_date
    AND    T.UPLOAD_STATUS_CODE = 'ERROR' ;




	--실제 업무처리
	IF @p_mode > 0 AND @v_count = 0	
	BEGIN

		--------------------------------------------------
		-- 1)엑셀 업로드용 TMP 테이블 생성 및 데이터 저장
		--------------------------------------------------
		BEGIN TRANSACTION METAL_LINK_PRICE;
		BEGIN TRY

			--엑셀 업로드된것들 중 ITEM_ID 있는 데이터
			IF OBJECT_ID('TEMPDB..#TMP_EXCEL_UPLOAD_WITH_ITEM') IS NOT NULL
				DROP TABLE #TMP_EXCEL_UPLOAD_WITH_ITEM;

			--프로젝트별로 ITEM_ID 추가된 최종 엑셀 업로드 버전 
			IF OBJECT_ID('TEMPDB..#TMP_EXCEL_UPLOAD_FINAL') IS NOT NULL
				DROP TABLE #TMP_EXCEL_UPLOAD_FINAL;

			--APPLY_PRICE_TYPE 데이터 UNPIVOT
			IF OBJECT_ID('TEMPDB..#TMP_APPLY_PRICE_TYPE') IS NOT NULL
				DROP TABLE #TMP_APPLY_PRICE_TYPE;

			--FROM_PERIOD 데이터 UNPIVOT
			IF OBJECT_ID('TEMPDB..#TMP_FROM_PERIOD') IS NOT NULL
				DROP TABLE #TMP_FROM_PERIOD;

			--TO_PERIOD 데이터 UNPIVOT
			IF OBJECT_ID('TEMPDB..#TMP_TO_PERIOD') IS NOT NULL
				DROP TABLE #TMP_TO_PERIOD;

			--CONTRACT_UNIT 데이터 UNPIVOT
			IF OBJECT_ID('TEMPDB..#TMP_CONTRACT_UNIT') IS NOT NULL
				DROP TABLE #TMP_CONTRACT_UNIT;

			--METAL_APPLY 데이터 UNPIVOT
			IF OBJECT_ID('TEMPDB..#TMP_METAL_APPLY') IS NOT NULL
				DROP TABLE #TMP_METAL_APPLY;

			--METAL_REQR 데이터 UNPIVOT
			IF OBJECT_ID('TEMPDB..#TMP_METAL_REQR') IS NOT NULL
				DROP TABLE #TMP_METAL_REQR;

			--UNPIVOT 된 데이터 합쳐서 DM_BPS_METAL_LINK_PRICE에 저장할 최종본
			IF OBJECT_ID('TEMPDB..#TMP_METAL_LINK_PRICE') IS NOT NULL
				DROP TABLE #TMP_METAL_LINK_PRICE;

			CREATE TABLE #TMP_EXCEL_UPLOAD(
				DIVISION_ID					NVARCHAR(100),
				PLAN_YYYYMM					NVARCHAR(100),
				--[PJ2024-50461] 메탈링크 업로드시 팀정보 관리 안하므로 제거
				--DEPT_NAME					NVARCHAR(100),
				--[PJ2024-50461] 메탈링크 업로드시 팀정보 관리 안하므로 제거
				END_CUSTOMER				NVARCHAR(100),
				PROJECT_CODE				NVARCHAR(100),
				--PLANT_SITE_ID				NVARCHAR(100),
				--COMPANY_ID					NVARCHAR(100),
				ITEM_ID						NVARCHAR(100),
				METAL_LINK_YN				NVARCHAR(100),
				SCM_SITE_ID					NVARCHAR(100),
				CURRENCY					NVARCHAR(100),
				FCST_TYPE					NVARCHAR(100),
				METAL_EXCEPTION_YN			NVARCHAR(100),
				ENERGY						NVARCHAR(100),
				APPLY_PRICE_TYPE_CODE1		NVARCHAR(100),	--METAL_KIND_CODE :  Ni		APPLY_PRICE_TYPE_CODE
				APPLY_PRICE_TYPE_CODE2		NVARCHAR(100),	--METAL_KIND_CODE :  Co		APPLY_PRICE_TYPE_CODE	
				APPLY_PRICE_TYPE_CODE3		NVARCHAR(100),	--METAL_KIND_CODE :  Li2CO3 APPLY_PRICE_TYPE_CODE	
				APPLY_PRICE_TYPE_CODE4		NVARCHAR(100),	--METAL_KIND_CODE :  LIOH	APPLY_PRICE_TYPE_CODE	
				APPLY_PRICE_TYPE_CODE5		NVARCHAR(100),	--METAL_KIND_CODE :  Al		APPLY_PRICE_TYPE_CODE		
				APPLY_PRICE_TYPE_CODE6		NVARCHAR(100),	--METAL_KIND_CODE :  Mn		APPLY_PRICE_TYPE_CODE		
				APPLY_PRICE_TYPE_CODE7		NVARCHAR(100),	--METAL_KIND_CODE :  Cu		APPLY_PRICE_TYPE_CODE	
				FROM_PERIOD1				NVARCHAR(100),	--METAL_KIND_CODE :  Ni		FROM_PERIOD_YYYYMM
				FROM_PERIOD2				NVARCHAR(100),	--METAL_KIND_CODE :  Co		FROM_PERIOD_YYYYMM	
				FROM_PERIOD3				NVARCHAR(100),	--METAL_KIND_CODE :  Li2CO3 FROM_PERIOD_YYYYMM	
				FROM_PERIOD4				NVARCHAR(100),	--METAL_KIND_CODE :  LIOH	FROM_PERIOD_YYYYMM	
				FROM_PERIOD5				NVARCHAR(100),	--METAL_KIND_CODE :  Al		FROM_PERIOD_YYYYMM		
				FROM_PERIOD6				NVARCHAR(100),	--METAL_KIND_CODE :  Mn		FROM_PERIOD_YYYYMM		
				FROM_PERIOD7				NVARCHAR(100),	--METAL_KIND_CODE :  Cu		FROM_PERIOD_YYYYMM	

				TO_PERIOD1				NVARCHAR(100),	--METAL_KIND_CODE :  Ni		TO_PERIOD_YYYYMM
				TO_PERIOD2				NVARCHAR(100),	--METAL_KIND_CODE :  Co		TO_PERIOD_YYYYMM	
				TO_PERIOD3				NVARCHAR(100),	--METAL_KIND_CODE :  Li2CO3 TO_PERIOD_YYYYMM	
				TO_PERIOD4				NVARCHAR(100),	--METAL_KIND_CODE :  LIOH	TO_PERIOD_YYYYMM	
				TO_PERIOD5				NVARCHAR(100),	--METAL_KIND_CODE :  Al		TO_PERIOD_YYYYMM		
				TO_PERIOD6				NVARCHAR(100),	--METAL_KIND_CODE :  Mn		TO_PERIOD_YYYYMM		
				TO_PERIOD7				NVARCHAR(100),	--METAL_KIND_CODE :  Cu		TO_PERIOD_YYYYMM	
	
				CONTRACT_UNIT1				NVARCHAR(100),	--METAL_KIND_CODE :  Ni		CONTRACT_UNIT
				CONTRACT_UNIT2				NVARCHAR(100),	--METAL_KIND_CODE :  Co		CONTRACT_UNIT	
				CONTRACT_UNIT3				NVARCHAR(100),	--METAL_KIND_CODE :  Li2CO3 CONTRACT_UNIT	
				CONTRACT_UNIT4				NVARCHAR(100),	--METAL_KIND_CODE :  LIOH	CONTRACT_UNIT	
				CONTRACT_UNIT5				NVARCHAR(100),	--METAL_KIND_CODE :  Al		CONTRACT_UNIT		
				CONTRACT_UNIT6				NVARCHAR(100),	--METAL_KIND_CODE :  Mn		CONTRACT_UNIT		
				CONTRACT_UNIT7				NVARCHAR(100),	--METAL_KIND_CODE :  Cu		CONTRACT_UNIT	

				METAL_APPLY1				NVARCHAR(100),	--METAL_KIND_CODE :  Ni		METAL_APPLY
				METAL_APPLY2				NVARCHAR(100),	--METAL_KIND_CODE :  Co		METAL_APPLY	
				METAL_APPLY3				NVARCHAR(100),	--METAL_KIND_CODE :  Li2CO3 METAL_APPLY	
				METAL_APPLY4				NVARCHAR(100),	--METAL_KIND_CODE :  LIOH	METAL_APPLY	
				METAL_APPLY5				NVARCHAR(100),	--METAL_KIND_CODE :  Al		METAL_APPLY		
				METAL_APPLY6				NVARCHAR(100),	--METAL_KIND_CODE :  Mn		METAL_APPLY		
				METAL_APPLY7				NVARCHAR(100),	--METAL_KIND_CODE :  Cu		METAL_APPLY	

				--METAL_REQR
				METAL_REQR1				NVARCHAR(100),	--METAL_KIND_CODE :  Ni		METAL_REQR
				METAL_REQR2				NVARCHAR(100),	--METAL_KIND_CODE :  Co		METAL_REQR	
				METAL_REQR3				NVARCHAR(100),	--METAL_KIND_CODE :  Li2CO3 METAL_REQR	
				METAL_REQR4				NVARCHAR(100),	--METAL_KIND_CODE :  LIOH	METAL_REQR	
				METAL_REQR5				NVARCHAR(100),	--METAL_KIND_CODE :  Al		METAL_REQR		
				METAL_REQR6				NVARCHAR(100),	--METAL_KIND_CODE :  Mn		METAL_REQR		
				METAL_REQR7				NVARCHAR(100),	--METAL_KIND_CODE :  Cu		METAL_REQR	

			)

			--[PJ2024-50611]40번 사업부일 경우 컬럼을 2칸 조정 start
			INSERT INTO #TMP_EXCEL_UPLOAD
			SELECT
			ATTRIBUTE1	--DIVISION_ID
			,ATTRIBUTE2	--PLAN_YYYYMM
			--[PJ2024-50461] 메탈링크 업로드시 팀정보 관리 안하므로 제거
			--,ATTRIBUTE3	--DEPT_NAME
			--[PJ2024-50461] 메탈링크 업로드시 팀정보 관리 안하므로 제거
			,ATTRIBUTE4	--End Customer
			,CASE WHEN ATTRIBUTE1 = '40' THEN '' ELSE ATTRIBUTE5 END	--Project Code(소형사업부는 공백처리)
			,CASE WHEN ATTRIBUTE1 = '40' THEN ATTRIBUTE5 ELSE ATTRIBUTE7 END	--MODEL Code
			,CASE WHEN ATTRIBUTE1 = '40' THEN ATTRIBUTE6 ELSE ATTRIBUTE8 END	--Metal Link
			,CASE WHEN ATTRIBUTE1 = '40' THEN ATTRIBUTE7 ELSE ATTRIBUTE9 END	--Sales Site
			,CASE WHEN ATTRIBUTE1 = '40' THEN ATTRIBUTE8 ELSE ATTRIBUTE10 END	--Currency
			,CASE WHEN ATTRIBUTE1 = '40' THEN ATTRIBUTE9 ELSE ATTRIBUTE11 END	--FCST type
			,CASE WHEN ATTRIBUTE1 = '40' THEN ATTRIBUTE10 ELSE ATTRIBUTE12 END	--Exception
			,CASE WHEN ATTRIBUTE1 = '40' THEN ATTRIBUTE11 ELSE ATTRIBUTE13 END	--Energy

			,CASE WHEN ATTRIBUTE1 = '40' THEN ATTRIBUTE12 ELSE ATTRIBUTE14 END	--Ni		APPLY_PRICE_TYPE_CODE1
			,CASE WHEN ATTRIBUTE1 = '40' THEN ATTRIBUTE13 ELSE ATTRIBUTE15 END	--Co		APPLY_PRICE_TYPE_CODE2
			,CASE WHEN ATTRIBUTE1 = '40' THEN ATTRIBUTE14 ELSE ATTRIBUTE16 END	--Li2CO3	APPLY_PRICE_TYPE_CODE3
			,CASE WHEN ATTRIBUTE1 = '40' THEN ATTRIBUTE15 ELSE ATTRIBUTE17 END	--LIOH		APPLY_PRICE_TYPE_CODE4
			,CASE WHEN ATTRIBUTE1 = '40' THEN ATTRIBUTE16 ELSE ATTRIBUTE18 END	--Al		APPLY_PRICE_TYPE_CODE5
			,CASE WHEN ATTRIBUTE1 = '40' THEN ATTRIBUTE17 ELSE ATTRIBUTE19 END	--Mn		APPLY_PRICE_TYPE_CODE6
			,CASE WHEN ATTRIBUTE1 = '40' THEN ATTRIBUTE18 ELSE ATTRIBUTE20 END	--Cu		APPLY_PRICE_TYPE_CODE7

			,CASE WHEN ATTRIBUTE1 = '40' THEN ATTRIBUTE19 ELSE ATTRIBUTE21 END	--Ni		FROM_PERIOD1
			,CASE WHEN ATTRIBUTE1 = '40' THEN ATTRIBUTE20 ELSE ATTRIBUTE22 END	--Co		FROM_PERIOD2
			,CASE WHEN ATTRIBUTE1 = '40' THEN ATTRIBUTE21 ELSE ATTRIBUTE23 END	--Li2CO3	FROM_PERIOD3
			,CASE WHEN ATTRIBUTE1 = '40' THEN ATTRIBUTE22 ELSE ATTRIBUTE24 END	--LIOH		FROM_PERIOD4
			,CASE WHEN ATTRIBUTE1 = '40' THEN ATTRIBUTE23 ELSE ATTRIBUTE25 END	--Al		FROM_PERIOD5
			,CASE WHEN ATTRIBUTE1 = '40' THEN ATTRIBUTE24 ELSE ATTRIBUTE26 END	--Mn		FROM_PERIOD6
			,CASE WHEN ATTRIBUTE1 = '40' THEN ATTRIBUTE25 ELSE ATTRIBUTE27 END	--Cu		FROM_PERIOD7

			,CASE WHEN ATTRIBUTE1 = '40' THEN ATTRIBUTE26 ELSE ATTRIBUTE28 END	--Ni		TO_PERIOD1
			,CASE WHEN ATTRIBUTE1 = '40' THEN ATTRIBUTE27 ELSE ATTRIBUTE29 END	--Co		TO_PERIOD2
			,CASE WHEN ATTRIBUTE1 = '40' THEN ATTRIBUTE28 ELSE ATTRIBUTE30 END	--Li2CO3	TO_PERIOD3
			,CASE WHEN ATTRIBUTE1 = '40' THEN ATTRIBUTE29 ELSE ATTRIBUTE31 END	--LIOH		TO_PERIOD4
			,CASE WHEN ATTRIBUTE1 = '40' THEN ATTRIBUTE30 ELSE ATTRIBUTE32 END	--Al		TO_PERIOD5
			,CASE WHEN ATTRIBUTE1 = '40' THEN ATTRIBUTE31 ELSE ATTRIBUTE33 END	--Mn		TO_PERIOD6
			,CASE WHEN ATTRIBUTE1 = '40' THEN ATTRIBUTE32 ELSE ATTRIBUTE34 END	--Cu		TO_PERIOD7

			,CASE WHEN ATTRIBUTE1 = '40' THEN ATTRIBUTE33 ELSE ATTRIBUTE35 END	--Ni		CONTRACT_UNIT1
			,CASE WHEN ATTRIBUTE1 = '40' THEN ATTRIBUTE34 ELSE ATTRIBUTE36 END	--Co		CONTRACT_UNIT2
			,CASE WHEN ATTRIBUTE1 = '40' THEN ATTRIBUTE35 ELSE ATTRIBUTE37 END	--Li2CO3	CONTRACT_UNIT3
			,CASE WHEN ATTRIBUTE1 = '40' THEN ATTRIBUTE36 ELSE ATTRIBUTE38 END	--LIOH		CONTRACT_UNIT4
			,CASE WHEN ATTRIBUTE1 = '40' THEN ATTRIBUTE37 ELSE ATTRIBUTE39 END	--Al		CONTRACT_UNIT5
			,CASE WHEN ATTRIBUTE1 = '40' THEN ATTRIBUTE38 ELSE ATTRIBUTE40 END	--Mn		CONTRACT_UNIT6
			,CASE WHEN ATTRIBUTE1 = '40' THEN ATTRIBUTE39 ELSE ATTRIBUTE41 END	--Cu		CONTRACT_UNIT7

			,CASE WHEN ATTRIBUTE1 = '40' THEN ATTRIBUTE40 ELSE ATTRIBUTE42 END	--Ni		METAL_APPLY1
			,CASE WHEN ATTRIBUTE1 = '40' THEN ATTRIBUTE41 ELSE ATTRIBUTE43 END	--Co		METAL_APPLY2
			,CASE WHEN ATTRIBUTE1 = '40' THEN ATTRIBUTE42 ELSE ATTRIBUTE44 END	--Li2CO3	METAL_APPLY3
			,CASE WHEN ATTRIBUTE1 = '40' THEN ATTRIBUTE43 ELSE ATTRIBUTE45 END	--LIOH		METAL_APPLY4
			,CASE WHEN ATTRIBUTE1 = '40' THEN ATTRIBUTE44 ELSE ATTRIBUTE46 END	--Al		METAL_APPLY5
			,CASE WHEN ATTRIBUTE1 = '40' THEN ATTRIBUTE45 ELSE ATTRIBUTE47 END	--Mn		METAL_APPLY6
			,CASE WHEN ATTRIBUTE1 = '40' THEN ATTRIBUTE46 ELSE ATTRIBUTE48 END	--Cu		METAL_APPLY7

			,CASE WHEN ATTRIBUTE1 = '40' THEN ATTRIBUTE47 ELSE ATTRIBUTE49 END	--Ni		METAL_REQR1
			,CASE WHEN ATTRIBUTE1 = '40' THEN ATTRIBUTE48 ELSE ATTRIBUTE50 END	--Co		METAL_REQR2
			,CASE WHEN ATTRIBUTE1 = '40' THEN ATTRIBUTE49 ELSE ATTRIBUTE51 END	--Li2CO3	METAL_REQR3
			,CASE WHEN ATTRIBUTE1 = '40' THEN ATTRIBUTE50 ELSE ATTRIBUTE52 END	--LIOH		METAL_REQR4
			,CASE WHEN ATTRIBUTE1 = '40' THEN ATTRIBUTE51 ELSE ATTRIBUTE53 END	--Al		METAL_REQR5
			,CASE WHEN ATTRIBUTE1 = '40' THEN ATTRIBUTE52 ELSE ATTRIBUTE54 END	--Mn		METAL_REQR6
			,CASE WHEN ATTRIBUTE1 = '40' THEN ATTRIBUTE53 ELSE ATTRIBUTE55 END	--Cu		METAL_REQR7
			FROM   [dbo].[SCM_ADM_EXCEL_UPLOAD]  WITH(NOLOCK)
			WHERE  1 = 1
			AND    PROGRAM_ID    LIKE @v_program_id + '%'
			AND    SHEET_NAME    = @v_sheet_name
			AND    CREATED_BY    = @p_created_by
			AND    UPLOAD_STATUS_CODE = 'SUCCESS'
			AND    CONVERT(NVARCHAR(40), CREATION_DATE, 121) =  @v_creation_date
			--[PJ2024-50611]40번 사업부일 경우 컬럼을 2칸 조정 end
			-------------------------------------------------------------------------
			--2)동일 PJT에 속한 모든 ITEMID 가져오기
			-------------------------------------------------------------------------
	IF OBJECT_ID('TEMPDB..#TEMP_SP_ITEM') IS NOT NULL
		DROP TABLE #TEMP_SP_ITEM;

		CREATE TABLE #TEMP_SP_ITEM(
						  DIVISION_ID	NVARCHAR(100)
						, VERSION_NO	NVARCHAR(100)
						, PROJECT_CODE	NVARCHAR(100)
						, SCM_SITE_ID	NVARCHAR(100)
						, ITEM_ID	NVARCHAR(100)
						, DOM_EXP	NVARCHAR(100)
						, FCST_TYPE	NVARCHAR(100)
						, INCOTERMS	NVARCHAR(100)
						, MEASURE	NVARCHAR(100)
						, PLANT_SITE_ID	NVARCHAR(100)
						, YYYYMMDD	NVARCHAR(100)
						, CURRENCY	NVARCHAR(100)
				)
 
 
				insert into #TEMP_SP_ITEM
				SELECT distinct PC.DIVISION_ID, PC.VERSION_NO, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, PC.YYYYMMDD , CURRENCY
				FROM DM_PLN_SALES_PLAN_C PC WITH(NOLOCK)
					INNER JOIN #TEMP_VERSION_NO T_VER
						ON PC.DIVISION_ID = T_VER.DIVISION_ID
						AND PC.VERSION_NO = T_VER.VERSION_NO
				WHERE PC.QTY <> 0
				AND PC.MEASURE = 'RTF_SYS_RP'
				--[PJ2024-50461]버전의 날짜로 처리
				AND PC.YYYYMMDD >= T_VER.RESULT_TO
				AND PC.YYYYMMDD <= T_VER.PLAN_TO
				UNION ALL
				SELECT distinct RC.DIVISION_ID, RC.VERSION_NO, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, RC.YYYYMMDD , CURRENCY
				FROM DM_PLN_SALES_PLAN_RESULT_C RC WITH(NOLOCK)
					INNER JOIN #TEMP_VERSION_NO T_VER
						ON RC.DIVISION_ID = T_VER.DIVISION_ID
						AND RC.VERSION_NO = T_VER.VERSION_NO
				WHERE RC.QTY <> 0
				AND RC.MEASURE = 'RTF_SYS_RP'
				--[PJ2024-50461]버전의 날짜로 처리
				AND RC.YYYYMMDD >= T_VER.RESULT_FROM
				AND RC.YYYYMMDD < T_VER.RESULT_TO
			-------------------------------------------------------------------------
			--2-1)ITEMID 없는것 처리(전체) 
			-------------------------------------------------------------------------
			SELECT 
			TMP.DIVISION_ID
			,TMP.PLAN_YYYYMM
			--[PJ2024-50461] 메탈링크 업로드시 팀정보 관리 안하므로 제거
			--,DI.DEPT_ID
			--[PJ2024-50461] 메탈링크 업로드시 팀정보 관리 안하므로 제거
			,TMP.END_CUSTOMER
			--[PJ2024-50611]40 사업부는 프로젝트 코드 공백처리
			--,TMP.PROJECT_CODE
			, CASE WHEN TMP.DIVISION_ID = '40' THEN '' ELSE TMP.PROJECT_CODE END AS PROJECT_CODE
			--[PJ2024-50611]40 사업부는 프로젝트 코드 공백처리
			,ITM.SALES_PLANT AS PLANT_SITE_ID
			,ITM.ITEM_ID
			,TMP.METAL_LINK_YN
			,TMP.SCM_SITE_ID
			,TMP.CURRENCY
			,LUP.SEGMENT1 FCST_TYPE
			,TMP.METAL_EXCEPTION_YN
			,TMP.ENERGY
			,TMP.APPLY_PRICE_TYPE_CODE1
			,TMP.APPLY_PRICE_TYPE_CODE2
			,TMP.APPLY_PRICE_TYPE_CODE3
			,TMP.APPLY_PRICE_TYPE_CODE4
			,TMP.APPLY_PRICE_TYPE_CODE5
			,TMP.APPLY_PRICE_TYPE_CODE6
			,TMP.APPLY_PRICE_TYPE_CODE7
			,TMP.FROM_PERIOD1
			,TMP.FROM_PERIOD2
			,TMP.FROM_PERIOD3
			,TMP.FROM_PERIOD4
			,TMP.FROM_PERIOD5
			,TMP.FROM_PERIOD6
			,TMP.FROM_PERIOD7
			,TMP.TO_PERIOD1
			,TMP.TO_PERIOD2
			,TMP.TO_PERIOD3
			,TMP.TO_PERIOD4
			,TMP.TO_PERIOD5
			,TMP.TO_PERIOD6
			,TMP.TO_PERIOD7
			,TMP.CONTRACT_UNIT1
			,TMP.CONTRACT_UNIT2
			,TMP.CONTRACT_UNIT3
			,TMP.CONTRACT_UNIT4
			,TMP.CONTRACT_UNIT5
			,TMP.CONTRACT_UNIT6
			,TMP.CONTRACT_UNIT7
			,TMP.METAL_APPLY1
			,TMP.METAL_APPLY2
			,TMP.METAL_APPLY3
			,TMP.METAL_APPLY4
			,TMP.METAL_APPLY5
			,TMP.METAL_APPLY6
			,TMP.METAL_APPLY7
			,TMP.METAL_REQR1
			,TMP.METAL_REQR2
			,TMP.METAL_REQR3
			,TMP.METAL_REQR4
			,TMP.METAL_REQR5
			,TMP.METAL_REQR6
			,TMP.METAL_REQR7
			INTO #TMP_EXCEL_UPLOAD_FINAL
			FROM #TMP_EXCEL_UPLOAD TMP
			INNER JOIN SCM_MST_SITE_ITEM ITM WITH(NOLOCK)
				ON ITM.DIVISION_ID = TMP.DIVISION_ID
				--[PJ2024-50611]소형일 경우 END_CUSTOMER(ATTRIBUTE4)로 비교. 나머지는 PROJECT_CODE(ATTRIBUTE5)로 비교
				--AND ITM.PROJECT_CODE = TMP.PROJECT_CODE
				AND ITM.PROJECT_CODE = CASE WHEN TMP.DIVISION_ID = '40' THEN TMP.END_CUSTOMER ELSE TMP.PROJECT_CODE END
				--[PJ2024-50611]소형일 경우 END_CUSTOMER(ATTRIBUTE4)로 비교. 나머지는 PROJECT_CODE(ATTRIBUTE5)로 비교
				AND ITM.SCM_SITE_ID = TMP.SCM_SITE_ID
				AND ITM.VALID_YN = 'Y'
			--[PJ2024-50461] 40번 사업부 외 적용하던 로직 제거 start
			/*INNER JOIN SCM_MST_SITE S WITH(NOLOCK)
				ON S.DIVISION_ID   = TMP.DIVISION_ID
				AND S.SCM_SITE_ID   = TMP.SCM_SITE_ID
				AND S.SITE_TYPE     = 'SALES' 
				AND S.VALID_YN = 'Y' 
			inner JOIN SCM_MST_SSO_DEPT_INFO DI WITH(NOLOCK)
				ON	DI.DEPT_ID = S.DEPT_ID
				AND DI.DEPT_NAME_KO = TMP.DEPT_NAME
				AND DI.VALID_YN = 'Y'*/ 
			--[PJ2024-50461] 40번 사업부 외 적용하던 로직 제거 end
			--FCST type
			inner JOIN SCM_ADM_LOOKUP_MASTER_DETAIL LUP WITH(NOLOCK)
				ON LUP.LOOKUP_TYPE = 'SALES_TYPE_CODE'
				AND LUP.VALID_YN = 'Y'
				AND LUP.SEGMENT4 <> 'FREE'----FCST_TYPE_NOT_FREE
				AND LUP.SEGMENT2 = TMP.FCST_TYPE
				--[PJ2024-50461]업로드 대상은 '제품(P)'만 해당
			INNER JOIN #TEMP_MST_ITEM SV WITH(NOLOCK)
			ON SV.DIVISION_ID = ITM.DIVISION_ID
			AND SV.ITEM_ID = ITM.ITEM_ID
			WHERE ISNULL(TMP.ITEM_ID, '') = ''
			--[PJ2024-50461]Sales Plan Waterfall 에 있는 아이템만 적용되어야 함 start
			AND ITM.ITEM_ID IN
			(

				SELECT ITEM_ID FROM #TEMP_SP_ITEM PC WITH(NOLOCK)
 
				WHERE PC.DIVISION_ID = TMP.DIVISION_ID
				--[PJ2024-50611]소형일 경우 END_CUSTOMER(ATTRIBUTE4)로 비교. 나머지는 PROJECT_CODE(ATTRIBUTE5)로 비교
				--AND PROJECT_CODE = TMP.PROJECT_CODE
				AND PROJECT_CODE = CASE WHEN TMP.DIVISION_ID = '40' THEN TMP.END_CUSTOMER ELSE TMP.PROJECT_CODE END
				--[PJ2024-50611]소형일 경우 END_CUSTOMER(ATTRIBUTE4)로 비교. 나머지는 PROJECT_CODE(ATTRIBUTE5)로 비교

				AND SCM_SITE_ID = TMP.SCM_SITE_ID
				AND CURRENCY = TMP.CURRENCY
				AND FCST_TYPE = LUP.SEGMENT1
			)
			--[PJ2024-50461]Sales Plan Waterfall 에 있는 아이템만 적용되어야 함 end
			AND (
				--[PJ2024-50461]82번 사업부는 에너지 있는 모델만 추출 start
					(TMP.DIVISION_ID = '82' AND ITM.ITEM_ID IN
						(
							SELECT ITEM_ID FROM #TEMP_MST_ITEM_ENERGY WITH(NOLOCK)
						)
					) OR
					(TMP.DIVISION_ID <> '82')
				--[PJ2024-50461]82번 사업부는 에너지 있는 모델만 추출 end
			)
			
			-------------------------------------------------------------------------
			--2-2)ITEMID 있는것 처리
			-------------------------------------------------------------------------
			SELECT 
			TMP.DIVISION_ID
			,TMP.PLAN_YYYYMM
			--[PJ2024-50461] 메탈링크 업로드시 팀정보 관리 안하므로 제거
			--,DI.DEPT_ID
			--[PJ2024-50461] 메탈링크 업로드시 팀정보 관리 안하므로 제거
			,TMP.END_CUSTOMER

			--[PJ2024-50611]40 사업부는 프로젝트 코드 공백처리
			--,TMP.PROJECT_CODE
			, CASE WHEN TMP.DIVISION_ID = '40' THEN '' ELSE TMP.PROJECT_CODE END AS PROJECT_CODE
			--[PJ2024-50611]40 사업부는 프로젝트 코드 공백처리

			,ITM.SALES_PLANT AS PLANT_SITE_ID
			,ITM.ITEM_ID
			,TMP.METAL_LINK_YN
			,TMP.SCM_SITE_ID
			,TMP.CURRENCY
			,LUP.SEGMENT1 FCST_TYPE
			,TMP.METAL_EXCEPTION_YN
			,TMP.ENERGY
			,TMP.APPLY_PRICE_TYPE_CODE1
			,TMP.APPLY_PRICE_TYPE_CODE2
			,TMP.APPLY_PRICE_TYPE_CODE3
			,TMP.APPLY_PRICE_TYPE_CODE4
			,TMP.APPLY_PRICE_TYPE_CODE5
			,TMP.APPLY_PRICE_TYPE_CODE6
			,TMP.APPLY_PRICE_TYPE_CODE7
			,TMP.FROM_PERIOD1
			,TMP.FROM_PERIOD2
			,TMP.FROM_PERIOD3
			,TMP.FROM_PERIOD4
			,TMP.FROM_PERIOD5
			,TMP.FROM_PERIOD6
			,TMP.FROM_PERIOD7
			,TMP.TO_PERIOD1
			,TMP.TO_PERIOD2
			,TMP.TO_PERIOD3
			,TMP.TO_PERIOD4
			,TMP.TO_PERIOD5
			,TMP.TO_PERIOD6
			,TMP.TO_PERIOD7
			,TMP.CONTRACT_UNIT1
			,TMP.CONTRACT_UNIT2
			,TMP.CONTRACT_UNIT3
			,TMP.CONTRACT_UNIT4
			,TMP.CONTRACT_UNIT5
			,TMP.CONTRACT_UNIT6
			,TMP.CONTRACT_UNIT7
			,TMP.METAL_APPLY1
			,TMP.METAL_APPLY2
			,TMP.METAL_APPLY3
			,TMP.METAL_APPLY4
			,TMP.METAL_APPLY5
			,TMP.METAL_APPLY6
			,TMP.METAL_APPLY7
			,TMP.METAL_REQR1
			,TMP.METAL_REQR2
			,TMP.METAL_REQR3
			,TMP.METAL_REQR4
			,TMP.METAL_REQR5
			,TMP.METAL_REQR6
			,TMP.METAL_REQR7
			INTO #TMP_EXCEL_UPLOAD_WITH_ITEM
			FROM #TMP_EXCEL_UPLOAD TMP
			INNER JOIN SCM_MST_SITE_ITEM ITM WITH(NOLOCK)
				ON ITM.DIVISION_ID = TMP.DIVISION_ID

				--[PJ2024-50611]소형일 경우 END_CUSTOMER(ATTRIBUTE4)로 비교. 나머지는 PROJECT_CODE(ATTRIBUTE5)로 비교
				--AND ITM.PROJECT_CODE = TMP.PROJECT_CODE
				AND ITM.PROJECT_CODE = CASE WHEN TMP.DIVISION_ID = '40' THEN TMP.END_CUSTOMER ELSE TMP.PROJECT_CODE END
				--[PJ2024-50611]소형일 경우 END_CUSTOMER(ATTRIBUTE4)로 비교. 나머지는 PROJECT_CODE(ATTRIBUTE5)로 비교

				AND ITM.SCM_SITE_ID = TMP.SCM_SITE_ID
				AND ITM.ITEM_ID = TMP.ITEM_ID
				AND ITM.VALID_YN = 'Y'
			--[PJ2024-50461] 40번 사업부 외 적용하던 로직 제거 start
			/*INNER JOIN SCM_MST_SITE S WITH(NOLOCK)
				ON S.DIVISION_ID   = TMP.DIVISION_ID
				AND S.SCM_SITE_ID   = TMP.SCM_SITE_ID
				AND S.SITE_TYPE     = 'SALES' 
				AND S.VALID_YN = 'Y'
			inner JOIN SCM_MST_SSO_DEPT_INFO DI WITH(NOLOCK)
				ON	DI.DEPT_ID = S.DEPT_ID
				AND DI.DEPT_NAME_KO = TMP.DEPT_NAME
				AND DI.VALID_YN = 'Y'*/
			--[PJ2024-50461] 40번 사업부 외 적용하던 로직 제거 end
			--FCST type
			inner JOIN SCM_ADM_LOOKUP_MASTER_DETAIL LUP WITH(NOLOCK)
				ON LUP.LOOKUP_TYPE = 'SALES_TYPE_CODE'
				AND LUP.VALID_YN = 'Y'
				AND LUP.SEGMENT4 <> 'FREE'----FCST_TYPE_NOT_FREE
				AND LUP.SEGMENT2 = TMP.FCST_TYPE
				--[PJ2024-50461]업로드 대상은 '제품(P)'만 해당
			INNER JOIN #TEMP_MST_ITEM SV WITH(NOLOCK)
			ON SV.DIVISION_ID = ITM.DIVISION_ID
			AND SV.ITEM_ID = ITM.ITEM_ID
			-------------------------------------------------------------------------
			--2-3)합치기
			-------------------------------------------------------------------------
			MERGE INTO #TMP_EXCEL_UPLOAD_FINAL AS A
			USING #TMP_EXCEL_UPLOAD_WITH_ITEM AS B
			   ON (
					A.DIVISION_ID = B.DIVISION_ID
						AND A.PLAN_YYYYMM = B.PLAN_YYYYMM
						--[PJ2024-50461] 메탈링크 업로드시 팀정보 관리 안하므로 제거
						--AND A.DEPT_ID = B.DEPT_ID
						--[PJ2024-50461] 메탈링크 업로드시 팀정보 관리 안하므로 제거
						AND A.END_CUSTOMER = B.END_CUSTOMER
						AND A.PROJECT_CODE = B.PROJECT_CODE
						AND A.PLANT_SITE_ID = B.PLANT_SITE_ID
						AND A.ITEM_ID = B.ITEM_ID
						AND A.SCM_SITE_ID = B.SCM_SITE_ID
						AND A.CURRENCY = B.CURRENCY
						AND A.FCST_TYPE = B.FCST_TYPE
				)
			WHEN MATCHED THEN
				UPDATE SET 
					A.METAL_LINK_YN = B.METAL_LINK_YN
					,A.METAL_EXCEPTION_YN = B.METAL_EXCEPTION_YN
					,A.ENERGY = B.ENERGY
					,A.APPLY_PRICE_TYPE_CODE1 = CASE WHEN B.APPLY_PRICE_TYPE_CODE1 = '' THEN A.APPLY_PRICE_TYPE_CODE1 ELSE B.APPLY_PRICE_TYPE_CODE1 END
					,A.APPLY_PRICE_TYPE_CODE2 = CASE WHEN B.APPLY_PRICE_TYPE_CODE2 = '' THEN A.APPLY_PRICE_TYPE_CODE2 ELSE B.APPLY_PRICE_TYPE_CODE2 END
					,A.APPLY_PRICE_TYPE_CODE3 = CASE WHEN B.APPLY_PRICE_TYPE_CODE3 = '' THEN A.APPLY_PRICE_TYPE_CODE3 ELSE B.APPLY_PRICE_TYPE_CODE3 END
					,A.APPLY_PRICE_TYPE_CODE4 = CASE WHEN B.APPLY_PRICE_TYPE_CODE4 = '' THEN A.APPLY_PRICE_TYPE_CODE4 ELSE B.APPLY_PRICE_TYPE_CODE4 END
					,A.APPLY_PRICE_TYPE_CODE5 = CASE WHEN B.APPLY_PRICE_TYPE_CODE5 = '' THEN A.APPLY_PRICE_TYPE_CODE5 ELSE B.APPLY_PRICE_TYPE_CODE5 END
					,A.APPLY_PRICE_TYPE_CODE6 = CASE WHEN B.APPLY_PRICE_TYPE_CODE6 = '' THEN A.APPLY_PRICE_TYPE_CODE6 ELSE B.APPLY_PRICE_TYPE_CODE6 END
					,A.APPLY_PRICE_TYPE_CODE7 = CASE WHEN B.APPLY_PRICE_TYPE_CODE7 = '' THEN A.APPLY_PRICE_TYPE_CODE7 ELSE B.APPLY_PRICE_TYPE_CODE7 END
					,A.FROM_PERIOD1 = CASE WHEN B.FROM_PERIOD1 = '' THEN A.FROM_PERIOD1 ELSE B.FROM_PERIOD1 END
					,A.FROM_PERIOD2 = CASE WHEN B.FROM_PERIOD2 = '' THEN A.FROM_PERIOD2 ELSE B.FROM_PERIOD2 END
					,A.FROM_PERIOD3 = CASE WHEN B.FROM_PERIOD3 = '' THEN A.FROM_PERIOD3 ELSE B.FROM_PERIOD3 END
					,A.FROM_PERIOD4 = CASE WHEN B.FROM_PERIOD4 = '' THEN A.FROM_PERIOD4 ELSE B.FROM_PERIOD4 END
					,A.FROM_PERIOD5 = CASE WHEN B.FROM_PERIOD5 = '' THEN A.FROM_PERIOD5 ELSE B.FROM_PERIOD5 END
					,A.FROM_PERIOD6 = CASE WHEN B.FROM_PERIOD6 = '' THEN A.FROM_PERIOD6 ELSE B.FROM_PERIOD6 END
					,A.FROM_PERIOD7 = CASE WHEN B.FROM_PERIOD7 = '' THEN A.FROM_PERIOD7 ELSE B.FROM_PERIOD7 END
					,A.TO_PERIOD1 = CASE WHEN B.TO_PERIOD1 = '' THEN A.TO_PERIOD1 ELSE B.TO_PERIOD1 END
					,A.TO_PERIOD2 = CASE WHEN B.TO_PERIOD2 = '' THEN A.TO_PERIOD2 ELSE B.TO_PERIOD2 END
					,A.TO_PERIOD3 = CASE WHEN B.TO_PERIOD3 = '' THEN A.TO_PERIOD3 ELSE B.TO_PERIOD3 END
					,A.TO_PERIOD4 = CASE WHEN B.TO_PERIOD4 = '' THEN A.TO_PERIOD4 ELSE B.TO_PERIOD4 END
					,A.TO_PERIOD5 = CASE WHEN B.TO_PERIOD5 = '' THEN A.TO_PERIOD5 ELSE B.TO_PERIOD5 END
					,A.TO_PERIOD6 = CASE WHEN B.TO_PERIOD6 = '' THEN A.TO_PERIOD6 ELSE B.TO_PERIOD6 END
					,A.TO_PERIOD7 = CASE WHEN B.TO_PERIOD7 = '' THEN A.TO_PERIOD7 ELSE B.TO_PERIOD7 END
					,A.CONTRACT_UNIT1 = CASE WHEN B.CONTRACT_UNIT1 = '' THEN A.CONTRACT_UNIT1 ELSE B.CONTRACT_UNIT1 END
					,A.CONTRACT_UNIT2 = CASE WHEN B.CONTRACT_UNIT2 = '' THEN A.CONTRACT_UNIT2 ELSE B.CONTRACT_UNIT2 END
					,A.CONTRACT_UNIT3 = CASE WHEN B.CONTRACT_UNIT3 = '' THEN A.CONTRACT_UNIT3 ELSE B.CONTRACT_UNIT3 END
					,A.CONTRACT_UNIT4 = CASE WHEN B.CONTRACT_UNIT4 = '' THEN A.CONTRACT_UNIT4 ELSE B.CONTRACT_UNIT4 END
					,A.CONTRACT_UNIT5 = CASE WHEN B.CONTRACT_UNIT5 = '' THEN A.CONTRACT_UNIT5 ELSE B.CONTRACT_UNIT5 END
					,A.CONTRACT_UNIT6 = CASE WHEN B.CONTRACT_UNIT6 = '' THEN A.CONTRACT_UNIT6 ELSE B.CONTRACT_UNIT6 END
					,A.CONTRACT_UNIT7 = CASE WHEN B.CONTRACT_UNIT7 = '' THEN A.CONTRACT_UNIT7 ELSE B.CONTRACT_UNIT7 END
					,A.METAL_APPLY1 = CASE WHEN B.METAL_APPLY1 = '' THEN A.METAL_APPLY1 ELSE B.METAL_APPLY1 END
					,A.METAL_APPLY2 = CASE WHEN B.METAL_APPLY2 = '' THEN A.METAL_APPLY2 ELSE B.METAL_APPLY2 END
					,A.METAL_APPLY3 = CASE WHEN B.METAL_APPLY3 = '' THEN A.METAL_APPLY3 ELSE B.METAL_APPLY3 END
					,A.METAL_APPLY4 = CASE WHEN B.METAL_APPLY4 = '' THEN A.METAL_APPLY4 ELSE B.METAL_APPLY4 END
					,A.METAL_APPLY5 = CASE WHEN B.METAL_APPLY5 = '' THEN A.METAL_APPLY5 ELSE B.METAL_APPLY5 END
					,A.METAL_APPLY6 = CASE WHEN B.METAL_APPLY6 = '' THEN A.METAL_APPLY6 ELSE B.METAL_APPLY6 END
					,A.METAL_APPLY7 = CASE WHEN B.METAL_APPLY7 = '' THEN A.METAL_APPLY7 ELSE B.METAL_APPLY7 END
					,A.METAL_REQR1 = CASE WHEN B.METAL_REQR1 = '' THEN A.METAL_REQR1 ELSE B.METAL_REQR1 END
					,A.METAL_REQR2 = CASE WHEN B.METAL_REQR2 = '' THEN A.METAL_REQR2 ELSE B.METAL_REQR2 END
					,A.METAL_REQR3 = CASE WHEN B.METAL_REQR3 = '' THEN A.METAL_REQR3 ELSE B.METAL_REQR3 END
					,A.METAL_REQR4 = CASE WHEN B.METAL_REQR4 = '' THEN A.METAL_REQR4 ELSE B.METAL_REQR4 END
					,A.METAL_REQR5 = CASE WHEN B.METAL_REQR5 = '' THEN A.METAL_REQR5 ELSE B.METAL_REQR5 END
					,A.METAL_REQR6 = CASE WHEN B.METAL_REQR6 = '' THEN A.METAL_REQR6 ELSE B.METAL_REQR6 END
					,A.METAL_REQR7 = CASE WHEN B.METAL_REQR7 = '' THEN A.METAL_REQR7 ELSE B.METAL_REQR7 END
			WHEN NOT MATCHED THEN
				INSERT 
				(	
					DIVISION_ID					,
					PLAN_YYYYMM					,
					--[PJ2024-50461] 메탈링크 업로드시 팀정보 관리 안하므로 제거
					--DEPT_ID						,
					--[PJ2024-50461] 메탈링크 업로드시 팀정보 관리 안하므로 제거
					END_CUSTOMER				,
					PROJECT_CODE				,
					PLANT_SITE_ID				,
					ITEM_ID						,
					METAL_LINK_YN				,
					SCM_SITE_ID					,
					CURRENCY					,
					FCST_TYPE					,
					METAL_EXCEPTION_YN			,
					ENERGY						,
					APPLY_PRICE_TYPE_CODE1		,	
					APPLY_PRICE_TYPE_CODE2		,	
					APPLY_PRICE_TYPE_CODE3		,	
					APPLY_PRICE_TYPE_CODE4		,	
					APPLY_PRICE_TYPE_CODE5		,		
					APPLY_PRICE_TYPE_CODE6		,		
					APPLY_PRICE_TYPE_CODE7		,	
					FROM_PERIOD1				,	
					FROM_PERIOD2				,	
					FROM_PERIOD3				,	
					FROM_PERIOD4				,	
					FROM_PERIOD5				,	
					FROM_PERIOD6				,	
					FROM_PERIOD7				,	

					TO_PERIOD1				,	
					TO_PERIOD2				,	
					TO_PERIOD3				,	
					TO_PERIOD4				,	
					TO_PERIOD5				,	
					TO_PERIOD6				,	
					TO_PERIOD7				,	
	
					CONTRACT_UNIT1				,	
					CONTRACT_UNIT2				,	
					CONTRACT_UNIT3				,	
					CONTRACT_UNIT4				,	
					CONTRACT_UNIT5				,		
					CONTRACT_UNIT6				,		
					CONTRACT_UNIT7				,	

					METAL_APPLY1				,	
					METAL_APPLY2				,	
					METAL_APPLY3				,	
					METAL_APPLY4				,	
					METAL_APPLY5				,	
					METAL_APPLY6				,	
					METAL_APPLY7				,	

					--METAL_REQR
					METAL_REQR1				,	
					METAL_REQR2				,	
					METAL_REQR3				,	
					METAL_REQR4				,	
					METAL_REQR5				,	
					METAL_REQR6				,	
					METAL_REQR7				
					)
				VALUES
				(
					B.DIVISION_ID				,
					B.PLAN_YYYYMM				,
					--[PJ2024-50461] 메탈링크 업로드시 팀정보 관리 안하므로 제거
					--B.DEPT_ID					,
					--[PJ2024-50461] 메탈링크 업로드시 팀정보 관리 안하므로 제거
					B.END_CUSTOMER				,
					B.PROJECT_CODE				,
					B.PLANT_SITE_ID				,
					B.ITEM_ID					,
					B.METAL_LINK_YN				,
					B.SCM_SITE_ID				,
					B.CURRENCY					,
					B.FCST_TYPE					,
					B.METAL_EXCEPTION_YN		,
					B.ENERGY					,
					B.APPLY_PRICE_TYPE_CODE1	,	
					B.APPLY_PRICE_TYPE_CODE2	,	
					B.APPLY_PRICE_TYPE_CODE3	,	
					B.APPLY_PRICE_TYPE_CODE4	,	
					B.APPLY_PRICE_TYPE_CODE5	,		
					B.APPLY_PRICE_TYPE_CODE6	,		
					B.APPLY_PRICE_TYPE_CODE7	,	
					B.FROM_PERIOD1				,	
					B.FROM_PERIOD2				,	
					B.FROM_PERIOD3				,	
					B.FROM_PERIOD4				,	
					B.FROM_PERIOD5				,	
					B.FROM_PERIOD6				,	
					B.FROM_PERIOD7				,	
					B.TO_PERIOD1				,	
					B.TO_PERIOD2				,	
					B.TO_PERIOD3				,	
					B.TO_PERIOD4				,	
					B.TO_PERIOD5				,	
					B.TO_PERIOD6				,	
					B.TO_PERIOD7				,	
					B.CONTRACT_UNIT1				,	
					B.CONTRACT_UNIT2				,	
					B.CONTRACT_UNIT3				,	
					B.CONTRACT_UNIT4				,	
					B.CONTRACT_UNIT5				,		
					B.CONTRACT_UNIT6				,		
					B.CONTRACT_UNIT7				,	
					B.METAL_APPLY1				,	
					B.METAL_APPLY2				,	
					B.METAL_APPLY3				,	
					B.METAL_APPLY4				,	
					B.METAL_APPLY5				,	
					B.METAL_APPLY6				,	
					B.METAL_APPLY7				,	
					B.METAL_REQR1				,	
					B.METAL_REQR2				,	
					B.METAL_REQR3				,	
					B.METAL_REQR4				,	
					B.METAL_REQR5				,	
					B.METAL_REQR6				,	
					B.METAL_REQR7				
				);
			-------------------------------------------------------------------------
			--UNPIVOT 위한 #TMP_EXCEL_UPLOAD_FINAL 완성
			-------------------------------------------------------------------------

			-------------------------------------------------------------------------
			--3) 각 그룹 별 UNPIVOT
			/*(
				APPLY_PRICE_TYPE_CODE,							
				FROM_PERIOD_YYYYMM,							
				TO_PERIOD_YYYYMM,							
				CONTRACT_UNIT_PRICE,							
				METAL_APPLY_UNIT_PRICE			
			)
			*/
			-------------------------------------------------------------------------

			-------------------------------------------------------------------------
			--3-1) APPLY_PRICE_TYPE UNPIVOT
			-------------------------------------------------------------------------
			SELECT 
			DIVISION_ID
			,PLAN_YYYYMM
			--[PJ2024-50461] 메탈링크 업로드시 팀정보 관리 안하므로 제거
			--,DEPT_ID
			--[PJ2024-50461] 메탈링크 업로드시 팀정보 관리 안하므로 제거
			,END_CUSTOMER
			,PROJECT_CODE
			,PLANT_SITE_ID
			,ITEM_ID
			,METAL_LINK_YN
			,SCM_SITE_ID
			,CURRENCY
			,FCST_TYPE
			,METAL_EXCEPTION_YN
			,ENERGY
			,CASE METAL_KIND_CODE_COL 
			WHEN 'APPLY_PRICE_TYPE_CODE1' THEN 'Ni'
			WHEN 'APPLY_PRICE_TYPE_CODE2' THEN 'Co'
			WHEN 'APPLY_PRICE_TYPE_CODE3' THEN 'Li2CO3'
			WHEN 'APPLY_PRICE_TYPE_CODE4' THEN 'LIOH'
			WHEN 'APPLY_PRICE_TYPE_CODE5' THEN 'Al'
			WHEN 'APPLY_PRICE_TYPE_CODE6' THEN 'Mn'
			WHEN 'APPLY_PRICE_TYPE_CODE7' THEN 'Cu'
			END METAL_KIND_CODE
			,APPLY_PRICE_TYPE_CODE
			INTO #TMP_APPLY_PRICE_TYPE
			FROM
			(
				SELECT * FROM #TMP_EXCEL_UPLOAD_FINAL
			) RAWDATA
			UNPIVOT
			(
				APPLY_PRICE_TYPE_CODE FOR METAL_KIND_CODE_COL IN (
					APPLY_PRICE_TYPE_CODE1,APPLY_PRICE_TYPE_CODE2,APPLY_PRICE_TYPE_CODE3,APPLY_PRICE_TYPE_CODE4,APPLY_PRICE_TYPE_CODE5,APPLY_PRICE_TYPE_CODE6,APPLY_PRICE_TYPE_CODE7
				)
			) AS UNPIVOT_DATA

			-------------------------------------------------------------------------
			--3-2) FROM_PERIOD UNPIVOT
			-------------------------------------------------------------------------
			SELECT 
			DIVISION_ID
			,PLAN_YYYYMM
			--[PJ2024-50461] 메탈링크 업로드시 팀정보 관리 안하므로 제거
			--,DEPT_ID
			--[PJ2024-50461] 메탈링크 업로드시 팀정보 관리 안하므로 제거
			,END_CUSTOMER
			,PROJECT_CODE
			,PLANT_SITE_ID
			,ITEM_ID
			,METAL_LINK_YN
			,SCM_SITE_ID
			,CURRENCY
			,FCST_TYPE
			,METAL_EXCEPTION_YN
			,ENERGY
			,CASE METAL_KIND_CODE_COL 
			WHEN 'FROM_PERIOD1' THEN 'Ni'
			WHEN 'FROM_PERIOD2' THEN 'Co'
			WHEN 'FROM_PERIOD3' THEN 'Li2CO3'
			WHEN 'FROM_PERIOD4' THEN 'LIOH'
			WHEN 'FROM_PERIOD5' THEN 'Al'
			WHEN 'FROM_PERIOD6' THEN 'Mn'
			WHEN 'FROM_PERIOD7' THEN 'Cu'
			END METAL_KIND_CODE
			,FROM_PERIOD
			INTO #TMP_FROM_PERIOD
			FROM
			(
				SELECT * FROM #TMP_EXCEL_UPLOAD_FINAL
			) RAWDATA
			UNPIVOT
			(
				FROM_PERIOD FOR METAL_KIND_CODE_COL IN (
					FROM_PERIOD1,FROM_PERIOD2,FROM_PERIOD3,FROM_PERIOD4,FROM_PERIOD5,FROM_PERIOD6,FROM_PERIOD7
				)
			) AS UNPIVOT_DATA

			-------------------------------------------------------------------------
			--3-3) TO_PERIOD UNPIVOT
			-------------------------------------------------------------------------
			SELECT 
			DIVISION_ID
			,PLAN_YYYYMM
			--[PJ2024-50461] 메탈링크 업로드시 팀정보 관리 안하므로 제거
			--,DEPT_ID
			--[PJ2024-50461] 메탈링크 업로드시 팀정보 관리 안하므로 제거
			,END_CUSTOMER
			,PROJECT_CODE
			,PLANT_SITE_ID
			,ITEM_ID
			,METAL_LINK_YN
			,SCM_SITE_ID
			,CURRENCY
			,FCST_TYPE
			,METAL_EXCEPTION_YN
			,ENERGY
			,CASE METAL_KIND_CODE_COL 
			WHEN 'TO_PERIOD1' THEN 'Ni'
			WHEN 'TO_PERIOD2' THEN 'Co'
			WHEN 'TO_PERIOD3' THEN 'Li2CO3'
			WHEN 'TO_PERIOD4' THEN 'LIOH'
			WHEN 'TO_PERIOD5' THEN 'Al'
			WHEN 'TO_PERIOD6' THEN 'Mn'
			WHEN 'TO_PERIOD7' THEN 'Cu'
			END METAL_KIND_CODE
			,TO_PERIOD
			INTO #TMP_TO_PERIOD
			FROM
			(
				SELECT * FROM #TMP_EXCEL_UPLOAD_FINAL
			) RAWDATA
			UNPIVOT
			(
				TO_PERIOD FOR METAL_KIND_CODE_COL IN (
					TO_PERIOD1,TO_PERIOD2,TO_PERIOD3,TO_PERIOD4,TO_PERIOD5,TO_PERIOD6,TO_PERIOD7
				)
			) AS UNPIVOT_DATA

			-------------------------------------------------------------------------
			--3-4) CONTRACT_UNIT UNPIVOT
			-------------------------------------------------------------------------
			SELECT 
			DIVISION_ID
			,PLAN_YYYYMM
			--[PJ2024-50461] 메탈링크 업로드시 팀정보 관리 안하므로 제거
			--,DEPT_ID
			--[PJ2024-50461] 메탈링크 업로드시 팀정보 관리 안하므로 제거
			,END_CUSTOMER
			,PROJECT_CODE
			,PLANT_SITE_ID
			,ITEM_ID
			,METAL_LINK_YN
			,SCM_SITE_ID
			,CURRENCY
			,FCST_TYPE
			,METAL_EXCEPTION_YN
			,ENERGY
			,CASE METAL_KIND_CODE_COL 
			WHEN 'CONTRACT_UNIT1' THEN 'Ni'
			WHEN 'CONTRACT_UNIT2' THEN 'Co'
			WHEN 'CONTRACT_UNIT3' THEN 'Li2CO3'
			WHEN 'CONTRACT_UNIT4' THEN 'LIOH'
			WHEN 'CONTRACT_UNIT5' THEN 'Al'
			WHEN 'CONTRACT_UNIT6' THEN 'Mn'
			WHEN 'CONTRACT_UNIT7' THEN 'Cu'
			END METAL_KIND_CODE
			,CONTRACT_UNIT
			INTO #TMP_CONTRACT_UNIT
			FROM
			(
				SELECT * FROM #TMP_EXCEL_UPLOAD_FINAL
			) RAWDATA
			UNPIVOT
			(
				CONTRACT_UNIT FOR METAL_KIND_CODE_COL IN (
					CONTRACT_UNIT1,CONTRACT_UNIT2,CONTRACT_UNIT3,CONTRACT_UNIT4,CONTRACT_UNIT5,CONTRACT_UNIT6,CONTRACT_UNIT7
				)
			) AS UNPIVOT_DATA

			-------------------------------------------------------------------------
			--3-5) METAL_APPLY UNPIVOT
			-------------------------------------------------------------------------
			SELECT 
			DIVISION_ID
			,PLAN_YYYYMM
			--[PJ2024-50461] 메탈링크 업로드시 팀정보 관리 안하므로 제거
			--,DEPT_ID
			--[PJ2024-50461] 메탈링크 업로드시 팀정보 관리 안하므로 제거
			,END_CUSTOMER
			,PROJECT_CODE
			,PLANT_SITE_ID
			,ITEM_ID
			,METAL_LINK_YN
			,SCM_SITE_ID
			,CURRENCY
			,FCST_TYPE
			,METAL_EXCEPTION_YN
			,ENERGY
			,CASE METAL_KIND_CODE_COL 
			WHEN 'METAL_APPLY1' THEN 'Ni'
			WHEN 'METAL_APPLY2' THEN 'Co'
			WHEN 'METAL_APPLY3' THEN 'Li2CO3'
			WHEN 'METAL_APPLY4' THEN 'LIOH'
			WHEN 'METAL_APPLY5' THEN 'Al'
			WHEN 'METAL_APPLY6' THEN 'Mn'
			WHEN 'METAL_APPLY7' THEN 'Cu'
			END METAL_KIND_CODE
			,METAL_APPLY
			INTO #TMP_METAL_APPLY
			FROM
			(
				SELECT * FROM #TMP_EXCEL_UPLOAD_FINAL
			) RAWDATA
			UNPIVOT
			(
				METAL_APPLY FOR METAL_KIND_CODE_COL IN (
					METAL_APPLY1,METAL_APPLY2,METAL_APPLY3,METAL_APPLY4,METAL_APPLY5,METAL_APPLY6,METAL_APPLY7
				)
			) AS UNPIVOT_DATA

			-------------------------------------------------------------------------
			--3-6) METAL_APPLY UNPIVOT
			-------------------------------------------------------------------------
			SELECT 
			DIVISION_ID
			,PLAN_YYYYMM
			--[PJ2024-50461] 메탈링크 업로드시 팀정보 관리 안하므로 제거
			--,DEPT_ID
			--[PJ2024-50461] 메탈링크 업로드시 팀정보 관리 안하므로 제거
			,END_CUSTOMER
			,PROJECT_CODE
			,PLANT_SITE_ID
			,ITEM_ID
			,METAL_LINK_YN
			,SCM_SITE_ID
			,CURRENCY
			,FCST_TYPE
			,METAL_EXCEPTION_YN
			,ENERGY
			,CASE METAL_KIND_CODE_COL 
			WHEN 'METAL_REQR1' THEN 'Ni'
			WHEN 'METAL_REQR2' THEN 'Co'
			WHEN 'METAL_REQR3' THEN 'Li2CO3'
			WHEN 'METAL_REQR4' THEN 'LIOH'
			WHEN 'METAL_REQR5' THEN 'Al'
			WHEN 'METAL_REQR6' THEN 'Mn'
			WHEN 'METAL_REQR7' THEN 'Cu'
			END METAL_KIND_CODE
			,METAL_REQR
			INTO #TMP_METAL_REQR
			FROM
			(
				SELECT * FROM #TMP_EXCEL_UPLOAD_FINAL
			) RAWDATA
			UNPIVOT
			(
				METAL_REQR FOR METAL_KIND_CODE_COL IN (
					METAL_REQR1,METAL_REQR2,METAL_REQR3,METAL_REQR4,METAL_REQR5,METAL_REQR6,METAL_REQR7
				)
			) AS UNPIVOT_DATA

			-------------------------------------------------------------------------
			--3-7)합치기
			-------------------------------------------------------------------------
			SELECT 
			APPLY_PRICE_TYPE.DIVISION_ID
			,APPLY_PRICE_TYPE.PLAN_YYYYMM
			--[PJ2024-50461] 메탈링크 업로드시 팀정보 관리 안하므로 제거
			--,APPLY_PRICE_TYPE.DEPT_ID
			--[PJ2024-50461] 메탈링크 업로드시 팀정보 관리 안하므로 제거
			,APPLY_PRICE_TYPE.END_CUSTOMER
			,APPLY_PRICE_TYPE.PROJECT_CODE
			,APPLY_PRICE_TYPE.PLANT_SITE_ID
			,APPLY_PRICE_TYPE.ITEM_ID
			,APPLY_PRICE_TYPE.METAL_LINK_YN
			,APPLY_PRICE_TYPE.SCM_SITE_ID
			,APPLY_PRICE_TYPE.CURRENCY
			,APPLY_PRICE_TYPE.FCST_TYPE
			,APPLY_PRICE_TYPE.METAL_EXCEPTION_YN
			,ROUND(APPLY_PRICE_TYPE.ENERGY, 3) ENERGY
			,APPLY_PRICE_TYPE.METAL_KIND_CODE
			,APPLY_PRICE_TYPE.APPLY_PRICE_TYPE_CODE
			,FROM_PERIOD
			,TO_PERIOD
			--셋째 자리에서 반올림 처리
			,ROUND(CONTRACT_UNIT, 2) CONTRACT_UNIT
			,ROUND(METAL_APPLY, 2) METAL_APPLY
			,ROUND(METAL_REQR, 2) METAL_REQR
			,T_VER.VERSION_NO
			INTO #TMP_METAL_LINK_PRICE
			FROM #TMP_APPLY_PRICE_TYPE APPLY_PRICE_TYPE
			INNER JOIN #TMP_FROM_PERIOD FROM_PERIOD
				ON APPLY_PRICE_TYPE.DIVISION_ID = FROM_PERIOD.DIVISION_ID
				AND APPLY_PRICE_TYPE.PLAN_YYYYMM = FROM_PERIOD.PLAN_YYYYMM
				--[PJ2024-50461] 메탈링크 업로드시 팀정보 관리 안하므로 제거
				--AND APPLY_PRICE_TYPE.DEPT_ID = FROM_PERIOD.DEPT_ID
				--[PJ2024-50461] 메탈링크 업로드시 팀정보 관리 안하므로 제거
				AND APPLY_PRICE_TYPE.END_CUSTOMER = FROM_PERIOD.END_CUSTOMER
				AND APPLY_PRICE_TYPE.PROJECT_CODE = FROM_PERIOD.PROJECT_CODE
				AND APPLY_PRICE_TYPE.PLANT_SITE_ID = FROM_PERIOD.PLANT_SITE_ID
				AND APPLY_PRICE_TYPE.ITEM_ID = FROM_PERIOD.ITEM_ID
				AND APPLY_PRICE_TYPE.METAL_LINK_YN = FROM_PERIOD.METAL_LINK_YN
				AND APPLY_PRICE_TYPE.SCM_SITE_ID = FROM_PERIOD.SCM_SITE_ID
				AND APPLY_PRICE_TYPE.CURRENCY = FROM_PERIOD.CURRENCY
				AND APPLY_PRICE_TYPE.FCST_TYPE = FROM_PERIOD.FCST_TYPE
				AND APPLY_PRICE_TYPE.METAL_EXCEPTION_YN = FROM_PERIOD.METAL_EXCEPTION_YN
				AND APPLY_PRICE_TYPE.ENERGY = FROM_PERIOD.ENERGY
				AND APPLY_PRICE_TYPE.METAL_KIND_CODE = FROM_PERIOD.METAL_KIND_CODE
			INNER JOIN #TMP_TO_PERIOD TO_PERIOD
				ON APPLY_PRICE_TYPE.DIVISION_ID = TO_PERIOD.DIVISION_ID
				AND APPLY_PRICE_TYPE.PLAN_YYYYMM = TO_PERIOD.PLAN_YYYYMM
				--[PJ2024-50461] 메탈링크 업로드시 팀정보 관리 안하므로 제거
				--AND APPLY_PRICE_TYPE.DEPT_ID = TO_PERIOD.DEPT_ID
				--[PJ2024-50461] 메탈링크 업로드시 팀정보 관리 안하므로 제거
				AND APPLY_PRICE_TYPE.END_CUSTOMER = TO_PERIOD.END_CUSTOMER
				AND APPLY_PRICE_TYPE.PROJECT_CODE = TO_PERIOD.PROJECT_CODE
				AND APPLY_PRICE_TYPE.PLANT_SITE_ID = TO_PERIOD.PLANT_SITE_ID
				AND APPLY_PRICE_TYPE.ITEM_ID = TO_PERIOD.ITEM_ID
				AND APPLY_PRICE_TYPE.METAL_LINK_YN = TO_PERIOD.METAL_LINK_YN
				AND APPLY_PRICE_TYPE.SCM_SITE_ID = TO_PERIOD.SCM_SITE_ID
				AND APPLY_PRICE_TYPE.CURRENCY = TO_PERIOD.CURRENCY
				AND APPLY_PRICE_TYPE.FCST_TYPE = TO_PERIOD.FCST_TYPE
				AND APPLY_PRICE_TYPE.METAL_EXCEPTION_YN = TO_PERIOD.METAL_EXCEPTION_YN
				AND APPLY_PRICE_TYPE.ENERGY = TO_PERIOD.ENERGY
				AND APPLY_PRICE_TYPE.METAL_KIND_CODE = TO_PERIOD.METAL_KIND_CODE
			INNER JOIN #TMP_CONTRACT_UNIT CONTRACT_UNIT
				ON APPLY_PRICE_TYPE.DIVISION_ID = CONTRACT_UNIT.DIVISION_ID
				AND APPLY_PRICE_TYPE.PLAN_YYYYMM = CONTRACT_UNIT.PLAN_YYYYMM
				--[PJ2024-50461] 메탈링크 업로드시 팀정보 관리 안하므로 제거
				--AND APPLY_PRICE_TYPE.DEPT_ID = CONTRACT_UNIT.DEPT_ID
				--[PJ2024-50461] 메탈링크 업로드시 팀정보 관리 안하므로 제거
				AND APPLY_PRICE_TYPE.END_CUSTOMER = CONTRACT_UNIT.END_CUSTOMER
				AND APPLY_PRICE_TYPE.PROJECT_CODE = CONTRACT_UNIT.PROJECT_CODE
				AND APPLY_PRICE_TYPE.PLANT_SITE_ID = CONTRACT_UNIT.PLANT_SITE_ID
				AND APPLY_PRICE_TYPE.ITEM_ID = CONTRACT_UNIT.ITEM_ID
				AND APPLY_PRICE_TYPE.METAL_LINK_YN = CONTRACT_UNIT.METAL_LINK_YN
				AND APPLY_PRICE_TYPE.SCM_SITE_ID = CONTRACT_UNIT.SCM_SITE_ID
				AND APPLY_PRICE_TYPE.CURRENCY = CONTRACT_UNIT.CURRENCY
				AND APPLY_PRICE_TYPE.FCST_TYPE = CONTRACT_UNIT.FCST_TYPE
				AND APPLY_PRICE_TYPE.METAL_EXCEPTION_YN = CONTRACT_UNIT.METAL_EXCEPTION_YN
				AND APPLY_PRICE_TYPE.ENERGY = CONTRACT_UNIT.ENERGY
				AND APPLY_PRICE_TYPE.METAL_KIND_CODE = CONTRACT_UNIT.METAL_KIND_CODE
			INNER JOIN #TMP_METAL_APPLY METAL_APPLY
				ON APPLY_PRICE_TYPE.DIVISION_ID = METAL_APPLY.DIVISION_ID
				AND APPLY_PRICE_TYPE.PLAN_YYYYMM = METAL_APPLY.PLAN_YYYYMM
				--[PJ2024-50461] 메탈링크 업로드시 팀정보 관리 안하므로 제거
				--AND APPLY_PRICE_TYPE.DEPT_ID = METAL_APPLY.DEPT_ID
				--[PJ2024-50461] 메탈링크 업로드시 팀정보 관리 안하므로 제거
				AND APPLY_PRICE_TYPE.END_CUSTOMER = METAL_APPLY.END_CUSTOMER
				AND APPLY_PRICE_TYPE.PROJECT_CODE = METAL_APPLY.PROJECT_CODE
				AND APPLY_PRICE_TYPE.PLANT_SITE_ID = METAL_APPLY.PLANT_SITE_ID
				AND APPLY_PRICE_TYPE.ITEM_ID = METAL_APPLY.ITEM_ID
				AND APPLY_PRICE_TYPE.METAL_LINK_YN = METAL_APPLY.METAL_LINK_YN
				AND APPLY_PRICE_TYPE.SCM_SITE_ID = METAL_APPLY.SCM_SITE_ID
				AND APPLY_PRICE_TYPE.CURRENCY = METAL_APPLY.CURRENCY
				AND APPLY_PRICE_TYPE.FCST_TYPE = METAL_APPLY.FCST_TYPE
				AND APPLY_PRICE_TYPE.METAL_EXCEPTION_YN = METAL_APPLY.METAL_EXCEPTION_YN
				AND APPLY_PRICE_TYPE.ENERGY = METAL_APPLY.ENERGY
				AND APPLY_PRICE_TYPE.METAL_KIND_CODE = METAL_APPLY.METAL_KIND_CODE
			INNER JOIN #TMP_METAL_REQR METAL_REQR
				ON APPLY_PRICE_TYPE.DIVISION_ID = METAL_REQR.DIVISION_ID
				AND APPLY_PRICE_TYPE.PLAN_YYYYMM = METAL_REQR.PLAN_YYYYMM
				--[PJ2024-50461] 메탈링크 업로드시 팀정보 관리 안하므로 제거
				--AND APPLY_PRICE_TYPE.DEPT_ID = METAL_REQR.DEPT_ID
				--[PJ2024-50461] 메탈링크 업로드시 팀정보 관리 안하므로 제거
				AND APPLY_PRICE_TYPE.END_CUSTOMER = METAL_REQR.END_CUSTOMER
				AND APPLY_PRICE_TYPE.PROJECT_CODE = METAL_REQR.PROJECT_CODE
				AND APPLY_PRICE_TYPE.PLANT_SITE_ID = METAL_REQR.PLANT_SITE_ID
				AND APPLY_PRICE_TYPE.ITEM_ID = METAL_REQR.ITEM_ID
				AND APPLY_PRICE_TYPE.METAL_LINK_YN = METAL_REQR.METAL_LINK_YN
				AND APPLY_PRICE_TYPE.SCM_SITE_ID = METAL_REQR.SCM_SITE_ID
				AND APPLY_PRICE_TYPE.CURRENCY = METAL_REQR.CURRENCY
				AND APPLY_PRICE_TYPE.FCST_TYPE = METAL_REQR.FCST_TYPE
				AND APPLY_PRICE_TYPE.METAL_EXCEPTION_YN = METAL_REQR.METAL_EXCEPTION_YN
				AND APPLY_PRICE_TYPE.ENERGY = METAL_REQR.ENERGY
				AND APPLY_PRICE_TYPE.METAL_KIND_CODE = METAL_REQR.METAL_KIND_CODE
			INNER JOIN #TEMP_VERSION_NO T_VER WITH(NOLOCK)--버전 정보 같이 저장(추후 TRACE 위해)
				ON T_VER.DIVISION_ID = APPLY_PRICE_TYPE.DIVISION_ID
			-------------------------------------------------------------------------
			--UPLOAD용 UNPIVOT 데이터 완성
			-------------------------------------------------------------------------

			-------------------------------------------------------------------------
			--4) DM_BPS_METAL_LINK_PRICE 저장
			-------------------------------------------------------------------------
			MERGE INTO DM_BPS_METAL_LINK_PRICE AS A
			USING #TMP_METAL_LINK_PRICE AS B
			   ON (
					A.DIVISION_ID = B.DIVISION_ID
						AND A.PLAN_YYYYMM = B.PLAN_YYYYMM
						--[PJ2024-50461] 메탈링크 업로드시 팀정보 관리 안하므로 제거
						--AND A.DEPT_ID = B.DEPT_ID
						--[PJ2024-50461] 메탈링크 업로드시 팀정보 관리 안하므로 제거
						AND A.END_CUSTOMER = B.END_CUSTOMER
						AND A.PROJECT_CODE = B.PROJECT_CODE
						AND A.PLANT_SITE_ID = B.PLANT_SITE_ID
						AND A.ITEM_ID = B.ITEM_ID
						AND A.SCM_SITE_ID = B.SCM_SITE_ID
						AND A.CURRENCY = B.CURRENCY	
						AND A.FCST_TYPE = B.FCST_TYPE
						AND A.METAL_KIND_CODE = B.METAL_KIND_CODE
				)
			WHEN MATCHED THEN
				UPDATE SET 
					A.METAL_EXCEPTION_YN = B.METAL_EXCEPTION_YN
					,A.ENERGY = B.ENERGY
					,A.METAL_LINK_YN = B.METAL_LINK_YN					
					,A.APPLY_PRICE_TYPE_CODE = B.APPLY_PRICE_TYPE_CODE
					,A.FROM_PERIOD_YYYYMM = B.FROM_PERIOD
					,A.TO_PERIOD_YYYYMM = B.TO_PERIOD
					,A.CONTRACT_UNIT_PRICE = B.CONTRACT_UNIT
					,A.METAL_APPLY_UNIT_PRICE = B.METAL_APPLY
					,A.METAL_REQR_QTY = B.METAL_REQR
					,A.LAST_UPDATED_BY = @p_created_by
					,A.LAST_UPDATE_DATE = GETDATE()
					,A.ATTRIBUTE10 = B.VERSION_NO--버전 정보 같이 저장(추후 TRACE 위해)
			WHEN NOT MATCHED THEN
				INSERT 
				(	
					DIVISION_ID
				   ,PLAN_YYYYMM
				   ,DEPT_ID
				   ,END_CUSTOMER
				   ,PROJECT_CODE
				   ,PLANT_SITE_ID
				   ,ITEM_ID
				   ,METAL_LINK_YN
				   ,SCM_SITE_ID
				   ,CURRENCY
				   ,FCST_TYPE
				   ,METAL_EXCEPTION_YN
				   ,ENERGY
				   ,METAL_KIND_CODE
				   ,APPLY_PRICE_TYPE_CODE
				   ,FROM_PERIOD_YYYYMM
				   ,TO_PERIOD_YYYYMM
				   ,CONTRACT_UNIT_PRICE
				   ,METAL_APPLY_UNIT_PRICE
				   ,METAL_REQR_QTY
				   ,CREATED_BY
				   ,CREATION_DATE
				   ,LAST_UPDATED_BY
				   ,LAST_UPDATE_DATE
				   ,ATTRIBUTE10
					)
				VALUES
				(
					B.DIVISION_ID
					,B.PLAN_YYYYMM
					--[PJ2024-50461] 메탈링크 업로드시 팀정보 관리 안하므로 공백저장
					--,B.DEPT_ID
					, ''
					--[PJ2024-50461] 메탈링크 업로드시 팀정보 관리 안하므로 공백저장
					,B.END_CUSTOMER
					,B.PROJECT_CODE
					,B.PLANT_SITE_ID
					,B.ITEM_ID
					,B.METAL_LINK_YN
					,B.SCM_SITE_ID
					,B.CURRENCY
					,B.FCST_TYPE
					,B.METAL_EXCEPTION_YN
					,B.ENERGY
					,B.METAL_KIND_CODE
					,B.APPLY_PRICE_TYPE_CODE
					,B.FROM_PERIOD
					,B.TO_PERIOD
					,B.CONTRACT_UNIT
					,B.METAL_APPLY
					,B.METAL_REQR
					,@p_created_by
					,GETDATE()
					,@p_created_by
					,GETDATE()
					,B.VERSION_NO
				);

			-------------------------------------------------------------------------
			--5) DM_BPS_METAL_LINK_PRICE_H 저장
			-------------------------------------------------------------------------
				INSERT INTO DM_BPS_METAL_LINK_PRICE_H
				(	
					DIVISION_ID
				   ,PLAN_YYYYMM
				   ,DEPT_ID
				   ,END_CUSTOMER
				   ,PROJECT_CODE
				   ,PLANT_SITE_ID
				   ,ITEM_ID
				   ,METAL_LINK_YN
				   ,SCM_SITE_ID
				   ,CURRENCY
				   ,FCST_TYPE
				   ,METAL_EXCEPTION_YN
				   ,ENERGY
				   ,METAL_KIND_CODE
				   ,APPLY_PRICE_TYPE_CODE
				   ,FROM_PERIOD_YYYYMM
				   ,TO_PERIOD_YYYYMM
				   ,CONTRACT_UNIT_PRICE
				   ,METAL_APPLY_UNIT_PRICE
				   ,METAL_REQR_QTY
				   ,CREATED_BY
				   ,CREATION_DATE
				   ,LAST_UPDATED_BY
				   ,LAST_UPDATE_DATE
				   ,ATTRIBUTE10
					)
				SELECT 
					B.DIVISION_ID
					,B.PLAN_YYYYMM
					--[PJ2024-50461] 메탈링크 업로드시 팀정보 관리 안하므로 공백저장
					--,B.DEPT_ID
					, ''
					--[PJ2024-50461] 메탈링크 업로드시 팀정보 관리 안하므로 공백저장
					,B.END_CUSTOMER
					,B.PROJECT_CODE
					,B.PLANT_SITE_ID
					,B.ITEM_ID
					,B.METAL_LINK_YN
					,B.SCM_SITE_ID
					,B.CURRENCY
					,B.FCST_TYPE
					,B.METAL_EXCEPTION_YN
					,B.ENERGY
					,B.METAL_KIND_CODE
					,B.APPLY_PRICE_TYPE_CODE
					,B.FROM_PERIOD
					,B.TO_PERIOD
					,B.CONTRACT_UNIT
					,B.METAL_APPLY
					,B.METAL_REQR
					,@p_created_by
					,GETDATE()
					,@p_created_by
					,GETDATE()	
					,B.VERSION_NO					
				FROM #TMP_METAL_LINK_PRICE B

		--COMMIT WORK;
		COMMIT TRANSACTION METAL_LINK_PRICE;

		END TRY
		BEGIN CATCH
			ROLLBACK TRANSACTION METAL_LINK_PRICE;


			INSERT INTO scm_sys_log_batch (program_name,log_type,log_count,log_message,description,event_date,creation_date,created_by,last_update_date,last_updated_by)
			VALUES (ERROR_PROCEDURE(),'ERROR',NULL,ERROR_MESSAGE(),NULL,SYSDATETIME(),SYSDATETIME(),ERROR_PROCEDURE(),SYSDATETIME(),ERROR_PROCEDURE());
		END CATCH
	END

	BEGIN
    ----------------------------------------------------------------------------
    --scm2_mgr.xLOG('SUCCESS              ', SQL%ROWCOUNT, 10, TRUE);
	SET @v_log_type = 'END';
	SET @v_log_message = '########## INSERT DATA END ##########';
	SET @v_description = @p_mode; --CONVERT(CHAR(30), @v_creation_date, 121);
	SET @d_event_date = SYSDATETIME();
	EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
    ----------------------------------------------------------------------------
	END;

END





