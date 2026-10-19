
/*
 * Program ID   : [PR_DM_METAL_LINK_CUTOFF]
 * Description  : BPS I/F 위해사용자가 업로드한 메탈링크 데이터를 컷오프한다
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2024.07.23   KJJ			[PJ2024-50244]SCM DM 고객수요관리 고도화 및 개선 - 신규생성		
 * 2024.11.06	KJJ			[PJ2024-50611] 실 테이블 저장시 Merge문 대신 delete/insert로 변경
 */

 --EXEC PR_DM_METAL_LINK_CUTOFF '81_UC'

 CREATE PROCEDURE [dbo].[PR_DM_METAL_LINK_CUTOFF]
	@p_division_id				NVARCHAR(30) 	

AS

/*
단일 division_id 만 처리하는 버전
*/
BEGIN

    SET NOCOUNT ON;

	IF OBJECT_ID (N'tempdb..#TMP_CUTOFF_TARGET', N'U') IS NOT NULL 
		DROP TABLE #TMP_CUTOFF_TARGET ;

	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'PR_DM_METAL_LINK_CUTOFF';
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
	
	DECLARE @V_VERSION_NO		NVARCHAR(100);
	DECLARE @V_YYYYMMDD			NVARCHAR(100);
	DECLARE @V_YYYYMM			NVARCHAR(100);

	IF OBJECT_ID (N'tempdb..#TEMP_VERSION_NO', N'U') IS NOT NULL 
		DROP TABLE #TEMP_VERSION_NO  

	SELECT 
	--[PJ2024-50611]조회시 * 가져오지 말고 구체적 필드 표시START
	A.DIVISION_ID
	,A.VERSION_NO
	, A.YYYYMMDD
	--[PJ2024-50611]조회시 * 가져오지 말고 구체적 필드 표시END
	, B.BASIS_YYYYMM AS YYYYMM

	--[PJ2024-50611]날짜조작 데이터 변수로 처리
	, CONVERT(CHAR(6), DATEADD(DD, - 1, DATEADD(WW, 52, CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY( A.YYYYMMDD , 'MON')), 112) )),  112) AS TO_YYYYMMDD
	--[PJ2024-50611]날짜조작 데이터 변수로 처리

	INTO #TEMP_VERSION_NO
	FROM
	(
		SELECT DIVISION_ID, MAX(VERSION_NO) VERSION_NO,  max(yyyymmdd) yyyymmdd
					FROM DM_MST_VERSION WITH(NOLOCK)
					WHERE DIVISION_ID = CASE WHEN @p_division_id = 'ALL' THEN DIVISION_ID ELSE @p_division_id END
					AND VERSION_TYPE	= 'SP_W' 
					AND ISNULL(ATTRIBUTE7, 'N') = 'Y'
		GROUP BY DIVISION_ID
	) A
	INNER JOIN SCM_SYS_CALENDAR_M B WITH(NOLOCK)
			ON B.BASIS_YYYYMMDD = A.yyyymmdd 

	BEGIN TRANSACTION METAL_LINK_PRICE;
	BEGIN TRY


			SELECT LP.[DIVISION_ID]
				  ,LP.[PLAN_YYYYMM]
				  ,LP.[DEPT_ID]
				  ,LP.[FCST_TYPE]
				  ,LP.[SCM_SITE_ID]
				  ,LP.[END_CUSTOMER]
				  ,LP.[PROJECT_CODE]
				  ,LP.[PLANT_SITE_ID]
				  ,LP.[ITEM_ID]
				  ,LP.[METAL_KIND_CODE]
				  ,LP.[CURRENCY]
				  ,LP.[METAL_EXCEPTION_YN]
				  ,LP.[METAL_LINK_YN]
				  ,LP.[APPLY_PRICE_TYPE_CODE]
				  ,LP.[FROM_PERIOD_YYYYMM]
				  ,LP.[TO_PERIOD_YYYYMM]
				  ,LP.[CONTRACT_UNIT_PRICE]
				  ,LP.[METAL_APPLY_UNIT_PRICE]
				  ,LP.[METAL_REQR_QTY]
				  ,LP.[ENERGY]
				  ,T_VER.VERSION_NO 
				  ,T_VER.yyyymmdd 
				INTO #TMP_CUTOFF_TARGET
			  FROM [dbo].[DM_BPS_METAL_LINK_PRICE] LP WITH(NOLOCK)
			  INNER JOIN #TEMP_VERSION_NO T_VER
				ON LP.DIVISION_ID = T_VER.DIVISION_ID
			  AND PLAN_YYYYMM >= T_VER.YYYYMM
			  --[PJ2024-50611]날짜조작 데이터 변수로 처리
			  --AND PLAN_YYYYMM <= (CONVERT(CHAR(6), DATEADD(DD, - 1, DATEADD(WW, 52, CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY( T_VER.YYYYMMDD , 'MON')), 112) )),  112))
			  AND PLAN_YYYYMM <= T_VER.TO_YYYYMMDD
			  --[PJ2024-50611]날짜조작 데이터 변수로 처리
		
		
		--[PJ2024-50611]실 테이블 저장시 Merge문 대신 delete/insert로 변경 start

		--해당 버전 삭제 
		DELETE METAL_C 
		FROM DM_BPS_METAL_LINK_PRICE_C METAL_C
		INNER JOIN #TMP_CUTOFF_TARGET TMP
			ON METAL_C.DIVISION_ID = TMP.DIVISION_ID
			AND METAL_C.VERSION_NO = TMP.VERSION_NO


		--저장
		INSERT INTO DM_BPS_METAL_LINK_PRICE_C
		(	
			[DIVISION_ID]
			,[PLAN_YYYYMM]
			,[VERSION_NO]
			,[CUTOFF_TYPE]
			,[CUTOFF_YYYYMMDD]
			,[DEPT_ID]
			,[FCST_TYPE]
			,[SCM_SITE_ID]
			,[END_CUSTOMER]
			,[PROJECT_CODE]
			,[PLANT_SITE_ID]
			,[ITEM_ID]
			,[METAL_KIND_CODE]
			,[CURRENCY]
			,[METAL_EXCEPTION_YN]
			,[METAL_LINK_YN]
			,[APPLY_PRICE_TYPE_CODE]
			,[FROM_PERIOD_YYYYMM]
			,[TO_PERIOD_YYYYMM]
			,[CONTRACT_UNIT_PRICE]
			,[METAL_APPLY_UNIT_PRICE]
			,[METAL_REQR_QTY]
			,[ENERGY]
			,[CREATED_BY]
			,[CREATION_DATE]
			,[LAST_UPDATED_BY]
			,[LAST_UPDATE_DATE]
			)
		SELECT
			TMP.DIVISION_ID
			,TMP.PLAN_YYYYMM
			,TMP.VERSION_NO
			,'SP_W'
			,TMP.YYYYMMDD
			,TMP.DEPT_ID
			,TMP.FCST_TYPE
			,TMP.SCM_SITE_ID
			,TMP.END_CUSTOMER
			,TMP.PROJECT_CODE
			,TMP.PLANT_SITE_ID
			,TMP.ITEM_ID
			,TMP.METAL_KIND_CODE
			,TMP.CURRENCY
			,TMP.METAL_EXCEPTION_YN
			,TMP.METAL_LINK_YN
			,TMP.APPLY_PRICE_TYPE_CODE
			,TMP.FROM_PERIOD_YYYYMM
			,TMP.TO_PERIOD_YYYYMM
			,TMP.CONTRACT_UNIT_PRICE
			,TMP.METAL_APPLY_UNIT_PRICE
			,TMP.METAL_REQR_QTY
			,TMP.ENERGY
			,'SYSTEM'
			,GETDATE()
			,'SYSTEM'
			,GETDATE()
		FROM #TMP_CUTOFF_TARGET TMP


		/*
			MERGE INTO DM_BPS_METAL_LINK_PRICE_C AS A
			USING #TMP_CUTOFF_TARGET AS B
			   ON (
					A.DIVISION_ID = B.DIVISION_ID
						AND A.PLAN_YYYYMM = B.PLAN_YYYYMM
						AND A.VERSION_NO = @V_VERSION_NO
						AND A.CUTOFF_TYPE = 'SP_W'
						AND A.CUTOFF_YYYYMMDD = CONVERT(VARCHAR(8), GETDATE(), 112)
						AND A.DEPT_ID = B.DEPT_ID
						AND A.END_CUSTOMER = B.END_CUSTOMER
						AND A.PROJECT_CODE = B.PROJECT_CODE
						AND A.PLANT_SITE_ID = B.PLANT_SITE_ID
						--AND A.COMPANY_ID = B.COMPANY_ID
						AND A.ITEM_ID = B.ITEM_ID
						AND A.SCM_SITE_ID = B.SCM_SITE_ID
						AND A.CURRENCY = B.CURRENCY	
						AND A.FCST_TYPE = B.FCST_TYPE
						AND A.METAL_KIND_CODE = B.METAL_KIND_CODE
				)
			WHEN MATCHED THEN
				UPDATE SET 
					A.METAL_EXCEPTION_YN = B.METAL_EXCEPTION_YN
					,A.METAL_LINK_YN = B.METAL_LINK_YN
					,A.APPLY_PRICE_TYPE_CODE = B.APPLY_PRICE_TYPE_CODE
					,A.FROM_PERIOD_YYYYMM = B.FROM_PERIOD_YYYYMM
					,A.TO_PERIOD_YYYYMM = B.TO_PERIOD_YYYYMM
					,A.CONTRACT_UNIT_PRICE = B.CONTRACT_UNIT_PRICE
					,A.METAL_APPLY_UNIT_PRICE = B.METAL_APPLY_UNIT_PRICE
					,A.METAL_REQR_QTY = B.METAL_REQR_QTY
					,A.ENERGY = B.ENERGY
					,A.LAST_UPDATED_BY = 'SYSTEM'
					,A.LAST_UPDATE_DATE = GETDATE()
			WHEN NOT MATCHED THEN
				INSERT 
				(	
					[DIVISION_ID]
					,[PLAN_YYYYMM]
					,[VERSION_NO]
					,[CUTOFF_TYPE]
					,[CUTOFF_YYYYMMDD]
					,[DEPT_ID]
					,[FCST_TYPE]
					,[SCM_SITE_ID]
					--,[COMPANY_ID]
					,[END_CUSTOMER]
					,[PROJECT_CODE]
					,[PLANT_SITE_ID]
					,[ITEM_ID]
					,[METAL_KIND_CODE]
					,[CURRENCY]
					,[METAL_EXCEPTION_YN]
					,[METAL_LINK_YN]
					,[APPLY_PRICE_TYPE_CODE]
					,[FROM_PERIOD_YYYYMM]
					,[TO_PERIOD_YYYYMM]
					,[CONTRACT_UNIT_PRICE]
					,[METAL_APPLY_UNIT_PRICE]
					,[METAL_REQR_QTY]
					,[ENERGY]
					,[CREATED_BY]
					,[CREATION_DATE]
					,[LAST_UPDATED_BY]
					,[LAST_UPDATE_DATE]
					)
				VALUES
				(
					B.DIVISION_ID
					,B.PLAN_YYYYMM
					,@V_VERSION_NO
					,'SP_W'
					,CONVERT(VARCHAR(8), GETDATE(), 112)
					,B.DEPT_ID
					,B.FCST_TYPE
					,B.SCM_SITE_ID
					--,B.COMPANY_ID
					,B.END_CUSTOMER
					,B.PROJECT_CODE
					,B.PLANT_SITE_ID
					,B.ITEM_ID
					,B.METAL_KIND_CODE
					,B.CURRENCY
					,B.METAL_EXCEPTION_YN
					,B.METAL_LINK_YN
					,B.APPLY_PRICE_TYPE_CODE
					,B.FROM_PERIOD_YYYYMM
					,B.TO_PERIOD_YYYYMM
					,B.CONTRACT_UNIT_PRICE
					,B.METAL_APPLY_UNIT_PRICE
					,B.METAL_REQR_QTY
					,B.ENERGY
					,'SYSTEM'
					,GETDATE()
					,'SYSTEM'
					,GETDATE()
				);		
		*/

		--[PJ2024-50611]실 테이블 저장시 Merge문 대신 delete/insert로 변경 END

		COMMIT TRANSACTION METAL_LINK_PRICE;
	END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION METAL_LINK_PRICE;
		INSERT INTO scm_sys_log_batch (program_name,log_type,log_count,log_message,description,event_date,creation_date,created_by,last_update_date,last_updated_by)
		VALUES (ERROR_PROCEDURE(),'ERROR',NULL,ERROR_MESSAGE(),NULL,SYSDATETIME(),SYSDATETIME(),ERROR_PROCEDURE(),SYSDATETIME(),ERROR_PROCEDURE());
	END CATCH
		

	BEGIN
    ----------------------------------------------------------------------------
    --scm2_mgr.xLOG('SUCCESS              ', SQL%ROWCOUNT, 10, TRUE);
	SET @v_log_type = 'END';
	SET @v_log_message = '########## INSERT DATA END ##########';
	SET @v_description = ''; --CONVERT(CHAR(30), @v_creation_date, 121);
	SET @d_event_date = SYSDATETIME();
	EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
    ----------------------------------------------------------------------------
	END;

END





