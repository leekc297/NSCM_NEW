
/*
 * Program ID   : PR_DM_MST_CUST_FCST_WEEKLY_ROLLING
 * Description  : Customer FCST Weekly Rollling (매주 월요일 00시 기준 정기 배치작업)
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018. 01. 23    DWOK/KHSONG     Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2020/09/09     P.C.I		[C20200909-000203] LOG 표준화 적용
 2022.04.05   hwi1993     GM JV 작업
 2022.08.26		HWI1993		주차를 가져올 때 CALENDAR 테이블을 이용해서 ISO_WEEK 를 가져오도록 변경
 2022.10.26		KDW2819		[C20221024-000507]CUST FCST Upload 오류 수정
 *

	EXEC [PR_DM_MST_CUST_FCST_WEEKLY_ROLLING]
 */

CREATE PROCEDURE [dbo].[PR_DM_MST_CUST_FCST_WEEKLY_ROLLING]

AS

BEGIN

    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON; 
    SET XACT_ABORT ON;
	

	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'PR_DM_MST_CUST_FCST_WEEKLY_ROLLING';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;

	DECLARE @v_division_id			NVARCHAR(MAX);
	DECLARE @v_ver_description		NVARCHAR(MAX);
	DECLARE @v_ver_type				NVARCHAR(MAX);
	DECLARE @v_rolling_type			NVARCHAR(MAX);
	DECLARE @v_created_by			NVARCHAR(MAX);
	DECLARE @v_ver_return_no		NVARCHAR(MAX);
	DECLARE @v_OK_description		NVARCHAR(MAX);
	DECLARE @V_PLAN_WEEK			NVARCHAR(6);
	-- DECLARE @V_BF_PLAN_WEEK			NVARCHAR(6);
	DECLARE @V_BF_PLAN_ISO_WEEK		INT;
	DECLARE @V_PLAN_MONTH			NVARCHAR(2);



		-- 시작 LOG
		SET @v_log_type = 'START';
		SET @v_log_message = '########## Start of procedure ##########';
		SET @v_description = '';
		SET @d_event_date = SYSDATETIME();
		EXEC  PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

		-- 트랜잭션 (START)
		BEGIN TRANSACTION CUST_FCST_WEEKLY_ROLLING;

	--------------------------------------------------------------------------------------------	
		BEGIN TRY
	--------------------------------------------------------------------------------------------	
	
	BEGIN
		SELECT @V_PLAN_WEEK = ISO_YYYYWW, @V_PLAN_MONTH = CALENDAR_MONTH
		FROM SCM_SYS_CALENDAR_M
		WHERE BASIS_YYYYMMDD = CONVERT(NVARCHAR(8), GETDATE(), 112)

		SELECT @V_BF_PLAN_ISO_WEEK = ISO_WEEK
		FROM SCM_SYS_CALENDAR_M
		WHERE BASIS_YYYYMMDD = CONVERT(NVARCHAR(8), DATEADD(WEEK, -1, GETDATE()), 112)

		-- 당주값이 있으면 삭제		
		DELETE 
		FROM DM_MST_CUSTOMER_FCST
		WHERE PLAN_WEEK = @V_PLAN_WEEK
		;
	
		-- 당주값 INSERT
		INSERT INTO DM_MST_CUSTOMER_FCST
		(
		   DIVISION_ID
		 , PLAN_WEEK
		 , CUSTOMER_CODE
		 , SCM_SITE_ID
		 , SUMMARY_BUCKET_VALUE
		 , MEASURE_GROUP 
		 , MEASURE
		 , VALID_YN
		 , CUSTOMER_PSI
		 , UPLOAD_UOM
		 , UPLOAD_BUCKET_TYPE
		 , SUMMARY_BUCKET_TYPE
		 , EDI_FCST_YN
		 , UPLOAD_USER_ID
		 , CREATED_BY
		 , CREATION_DATE
		 , LAST_UPDATED_BY
		 , LAST_UPDATE_DATE
		 , ATTRIBUTE1
		 , ATTRIBUTE2
		 , ATTRIBUTE3
		 , ATTRIBUTE4
		 , ATTRIBUTE5
		 , ATTRIBUTE6
		 , ATTRIBUTE7
		 , ATTRIBUTE8
		 , ATTRIBUTE9
		 , ATTRIBUTE10
		)
		select DIVISION_ID, @V_PLAN_WEEK, CUSTOMER_CODE, SCM_SITE_ID
			 , CASE WHEN SUMMARY_BUCKET_VALUE = '99999999' THEN '99999999' 
				    ELSE convert( varchar, cast(SUMMARY_BUCKET_VALUE as datetime) + 7 , 112) END  -- PSI 데이터의 날짜는 제외시킴
			 , MEASURE_GROUP, MEASURE, VALID_YN, CUSTOMER_PSI
			 , UPLOAD_UOM, UPLOAD_BUCKET_TYPE, SUMMARY_BUCKET_TYPE, EDI_FCST_YN, UPLOAD_USER_ID
			 , CREATED_BY, CREATION_DATE, 'SYSTEM', getdate()
			 , ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
		  from dbo.DM_MST_CUSTOMER_FCST a WITH(NOLOCK)
		-- where plan_week = '201803'
		 where cast( substring(plan_week,5,2) as int ) = @V_BF_PLAN_ISO_WEEK   -- 전주 값을 찾아서 Rolling
		   and SUMMARY_BUCKET_TYPE in ( 'DAILY','WEEKLY')
		   and a.valid_yn = 'Y' -- 유효한 것만 Rolling
		 UNION
		-- 월이 변하지 않을 때
		select 
		DIVISION_ID, @V_PLAN_WEEK, CUSTOMER_CODE, SCM_SITE_ID
			 , SUMMARY_BUCKET_VALUE
			 , MEASURE_GROUP, MEASURE, VALID_YN, CUSTOMER_PSI
			 , UPLOAD_UOM, UPLOAD_BUCKET_TYPE, SUMMARY_BUCKET_TYPE, EDI_FCST_YN, UPLOAD_USER_ID
			 , CREATED_BY, CREATION_DATE, 'SYSTEM', getdate()
			 , ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
		  from dbo.DM_MST_CUSTOMER_FCST a  WITH(NOLOCK)
			  ,dbo.SCM_SYS_CALENDAR_M b  WITH(NOLOCK)
		 where a.plan_week = b.iso_yyyyww
		   and b.calendar_month = @V_PLAN_MONTH
		   and cast( substring(plan_week,5,2) as int ) = @V_BF_PLAN_ISO_WEEK -- 전주 값을 찾아서 Rolling
		   and SUMMARY_BUCKET_TYPE in ( 'MONTHLY')
		   and a.valid_yn = 'Y' -- 유효한 것만 Rolling
		   and b.DAYOFWEEK = 'MON'  -- (20180405 Songkh Added) 중복으로 인하여 조건 추가
		UNION
		-- 월이 변할 때
		select 
		DIVISION_ID, @V_PLAN_WEEK, CUSTOMER_CODE, SCM_SITE_ID
			 , CASE WHEN SUMMARY_BUCKET_VALUE = '99999999' THEN '99999999' 
				    ELSE convert(varchar,dateadd(S,-1,dateadd(mm,datediff(m,0, dateadd( mm, 1, cast(SUMMARY_BUCKET_VALUE as datetime) )  )+0,1)),112) END
			 , MEASURE_GROUP, MEASURE, VALID_YN, CUSTOMER_PSI
			 , UPLOAD_UOM, UPLOAD_BUCKET_TYPE, SUMMARY_BUCKET_TYPE, EDI_FCST_YN, UPLOAD_USER_ID
			 , CREATED_BY, CREATION_DATE, 'SYSTEM', getdate()
			 , ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
		  from dbo.DM_MST_CUSTOMER_FCST a  WITH(NOLOCK)
			  ,dbo.SCM_SYS_CALENDAR_M b  WITH(NOLOCK)
		 where a.plan_week = b.iso_yyyyww
		   and b.calendar_month <> @V_PLAN_MONTH -- 전주와 당주의 월이 달라지는 경우
		   and cast( substring(plan_week,5,2) as int )  = @V_BF_PLAN_ISO_WEEK -- 전주 값을 찾아서 Rolling
		   and SUMMARY_BUCKET_TYPE in ( 'MONTHLY')
		   and a.valid_yn = 'Y' -- 유효한 것만 Rolling
		   and b.DAYOFWEEK = 'MON'  -- (20180405 Songkh Added) 중복으로 인하여 조건 추가
		 ;

		-- master 값 이관전 중복확인후 삭제 (20180406 Songkh Added)
		DELETE FROM DM_MST_CUSTOMER_FCST
		WHERE 1=1
		  and SUMMARY_BUCKET_VALUE in ('20000101','20000102','20000103')
		  and PLAN_WEEK = @V_PLAN_WEEK
		;

		-- master 값 이관 (20180406 Songkh Added)
		INSERT INTO DM_MST_CUSTOMER_FCST
		(
		DIVISION_ID, PLAN_WEEK, CUSTOMER_CODE, SCM_SITE_ID, SUMMARY_BUCKET_VALUE, MEASURE_GROUP, MEASURE
		, VALID_YN, CUSTOMER_PSI, UPLOAD_UOM, UPLOAD_BUCKET_TYPE, SUMMARY_BUCKET_TYPE, EDI_FCST_YN, UPLOAD_USER_ID
		, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3
		, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
		)
		select 
		DIVISION_ID, @V_PLAN_WEEK, CUSTOMER_CODE, SCM_SITE_ID
			 , SUMMARY_BUCKET_VALUE
			 , MEASURE_GROUP, MEASURE, VALID_YN, CUSTOMER_PSI, UPLOAD_UOM, UPLOAD_BUCKET_TYPE, SUMMARY_BUCKET_TYPE, EDI_FCST_YN, UPLOAD_USER_ID
			 , CREATED_BY, CREATION_DATE, 'SYSTEM', getdate()
			 , ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
		  from dbo.DM_MST_CUSTOMER_FCST a  WITH(NOLOCK)
		    where 1=1
			  and SUMMARY_BUCKET_VALUE in ('20000101','20000102','20000103')
	END
	--
		-- 과거 주차 정보 DM_MST_CUSTOMER_FCST_C 로 옮기기
		-- 2W 이전 정보는 DM_MST_CUSTOMER_FCST_C 로 옮기자.
			/* CUTOFF DATA INSERT */
			BEGIN

				-- 커서를 이용해 DIVISION_ID 만큼 LOOP
				DECLARE CUST_FCST_WEEKLY_ROLLING_CUR CURSOR FAST_FORWARD FOR
												SELECT	DIVISION_ID		
												  FROM	SCM_MST_DIVISION A WITH(NOLOCK)
												  
				OPEN CUST_FCST_WEEKLY_ROLLING_CUR
				FETCH NEXT FROM CUST_FCST_WEEKLY_ROLLING_CUR INTO @v_division_id

				WHILE @@FETCH_STATUS = 0
				BEGIN

						EXEC	[dbo].[PR_DM_PLN_VERSION_CREATE]	--@return_value = [dbo].[PR_DM_PLN_VERSION_CREATE]
								 @v_division_id
								,'DM_MST_CUSTOMER_FCST CUTOFF'
								,'CF_W'
								,'SYSTEM'
								,@v_ver_return_no  OUTPUT
								,@v_OK_description OUTPUT

						-- INSERT -> DELETE
						INSERT INTO [dbo].DM_MST_CUSTOMER_FCST_C (
								DIVISION_ID
								,VERSION_NO
								,CUTOFF_TYPE
								,CUTOFF_DATE
								,PLAN_WEEK
								,CUSTOMER_CODE
								,SCM_SITE_ID
								,SUMMARY_BUCKET_VALUE
								,MEASURE_GROUP
								,CUSTOMER_PSI
								,MEASURE
								,VALID_YN
								,UPLOAD_UOM
								,UPLOAD_BUCKET_TYPE
								,SUMMARY_BUCKET_TYPE
								,EDI_FCST_YN
								,UPLOAD_USER_ID
								,CREATED_BY
								,CREATION_DATE
								,LAST_UPDATED_BY
								,LAST_UPDATE_DATE
								,ATTRIBUTE1
								,ATTRIBUTE2
								,ATTRIBUTE3
								,ATTRIBUTE4
								,ATTRIBUTE5
								,ATTRIBUTE6
								,ATTRIBUTE7
								,ATTRIBUTE8
								,ATTRIBUTE9
								,ATTRIBUTE10		)
						SELECT 
							 DIVISION_ID
							,@v_ver_return_no AS VERSION_NO			--VERSION_NO
							,'CF_W' AS CUTOFF_TYPE					-- CUTOFF_TYPE
							,CONVERT(CHAR(8), CURRENT_TIMESTAMP, 112) AS CUTOFF_YYYYMMDD  -- CUTOFF_YYYYMMDD
							,PLAN_WEEK
							,CUSTOMER_CODE
							,SCM_SITE_ID
							,SUMMARY_BUCKET_VALUE
							,MEASURE_GROUP
							,CUSTOMER_PSI
							,MEASURE
							,VALID_YN
							,UPLOAD_UOM
							,UPLOAD_BUCKET_TYPE
							,SUMMARY_BUCKET_TYPE
							,EDI_FCST_YN
							,UPLOAD_USER_ID
							,CREATED_BY
							,CREATION_DATE
							,LAST_UPDATED_BY
							,LAST_UPDATE_DATE
							,ATTRIBUTE1
							,ATTRIBUTE2
							,ATTRIBUTE3
							,ATTRIBUTE4
							,ATTRIBUTE5
							,ATTRIBUTE6
							,ATTRIBUTE7
							,ATTRIBUTE8
							,ATTRIBUTE9
							,ATTRIBUTE10			
						FROM [dbo].[DM_MST_CUSTOMER_FCST] 
					   WHERE DIVISION_ID  = @v_division_id
						 AND PLAN_WEEK < @V_PLAN_WEEK

						DELETE 
						FROM [dbo].[DM_MST_CUSTOMER_FCST] 
					   WHERE DIVISION_ID  = @v_division_id
						 AND PLAN_WEEK < @V_PLAN_WEEK

						FETCH NEXT FROM CUST_FCST_WEEKLY_ROLLING_CUR INTO @v_division_id
			
				END;	-- WHILE @@FETCH_STATUS = 0

				CLOSE CUST_FCST_WEEKLY_ROLLING_CUR
				DEALLOCATE CUST_FCST_WEEKLY_ROLLING_CUR

			END

			COMMIT WORK;

		END TRY
			
	--------------------------------------------------------------	
	BEGIN CATCH
	--------------------------------------------------------------	
	--[C20200909-000203] LOG 표준화 적용
	-- 트랜잭션 (END)
	ROLLBACK TRANSACTION  CUST_FCST_WEEKLY_ROLLING;

      -- ERROR LOG
      SET @v_log_type = 'ERROR';
      SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
      SET @v_description = 'ERROR_LINE : ' + STR(ERROR_LINE());
      SET @d_event_date = SYSDATETIME();

	  SELECT '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE();
	
		--[C20200909-000203] LOG 표준화 적용
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		

	--------------------------------------------------------------	
    END CATCH;
	--------------------------------------------------------------	

	-- 종료 LOG
    SET @v_log_type = 'END';
    SET @v_log_message = '########## END of procedure ##########';
    SET @v_description = '';
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

  END;						




