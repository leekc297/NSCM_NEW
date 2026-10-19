/*
 * Program ID   : PR_SCP_MST_SHIPMENT_WORKING_TIME_BATCH
 * Description  : SHIPMENT Working Day 생성 프로시져
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2023/01/31   lwy			   Initial Release [] - PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - (외주) 출하일 관리
 */

CREATE PROCEDURE [dbo].[PR_SCP_MST_SHIPMENT_WORKING_TIME_BATCH]
AS
  BEGIN
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    -- LOG 용 변수 설정
    DECLARE @V_BATCH_USER   NVARCHAR(150) = 'SCM_BATCH';
	DECLARE @V_PROGRAM_NAME NVARCHAR(150) = 'PR_SCP_MST_SHIPMENT_WORKING_TIME_BATCH';
    DECLARE @V_LOG_TYPE     NVARCHAR(30);
    DECLARE @N_LOG_COUNT    INTEGER = 0;
    DECLARE @V_LOG_MESSAGE  NVARCHAR(1000);
    DECLARE @V_DESCRIPTION  NVARCHAR(500);
    DECLARE @D_EVENT_DATE   DATETIME;
	DECLARE @V_IFSEQNO      NVARCHAR(30);
	DECLARE @V_INSTANCEID   NVARCHAR(40);
	DECLARE @N_MQ_SEQ	    BIGINT;
	DECLARE @N_DAYOFWEEK    INT = 1;
	DECLARE @N_PERIOD       INT = 380;

	-- 시작 LOG
    SET @V_LOG_TYPE = 'START';
    SET @V_LOG_MESSAGE = '########## START OF PROCEDURE ##########';
    SET @V_DESCRIPTION = '';
    SET @D_EVENT_DATE = SYSDATETIME();

    EXEC PR_SCM_SYS_LOG_BATCH @V_PROGRAM_NAME, @V_LOG_TYPE, @N_LOG_COUNT, @V_LOG_MESSAGE, @V_DESCRIPTION, @D_EVENT_DATE;

    BEGIN TRY
      BEGIN

        SELECT TOP 1 @N_PERIOD = DATEDIFF(D,  CONVERT(DATE, PLAN_NAME), CONVERT(DATE, MAX(HORIZON_END_DATE)) ) + 1
		FROM   DBO.SCM_MST_PLAN P WITH(NOLOCK)
		WHERE  P.PLAN_CYCLE  = 'WEEKLY'
		AND    P.PLAN_NAME   = CONVERT(CHAR(8), DATEADD(DD, -7, DBO.FN_NEXT_DAY(GETDATE(), 'MON')), 112) -- 당주 월요일 YYYYMMDD
		GROUP BY PLAN_NAME
		;

		-- 1.1 WORKING TIME 계산 임시 테이블 생성
		IF OBJECT_ID('tempdb..#TMP_SCP0096_WORKING_TIME_DEFAULT') IS NOT NULL
		DROP TABLE #TMP_SCP0096_WORKING_TIME_DEFAULT

		CREATE TABLE #TMP_SCP0096_WORKING_TIME_DEFAULT (
	       division_id	        NVARCHAR(30)
		  ,plant_site_id        NVARCHAR(30)
		  ,working_time_default NUMERIC(3,2)
		  ,working_time_remain  NUMERIC(3,2)
		  ,working_time_calc    NUMERIC(3,2)
		  ,dayofweek            NVARCHAR(3)
		);

		-- 1.2 WORKING TIME DEFAULT 데이타 생성
		-- 1.2.1 MONDAY
		INSERT INTO #TMP_SCP0096_WORKING_TIME_DEFAULT
		SELECT td.division_id
              ,td.plant_site_id	          
	          ,td.working_time_default
	          ,(td.working_time_default-1) working_time_remain
	          ,CASE WHEN td.working_time_default >= 1 THEN 1 ELSE td.working_time_default END working_time_calc
	          ,'MON' dayofweek
        FROM   SCP_MST_SHIPMENT_WORKING_DAY_DEFAULT td WITH(NOLOCK)
               INNER JOIN scm_mst_site s WITH(NOLOCK)
               ON  td.division_id   = s.division_id
               AND td.plant_site_id = s.scm_site_id
               AND s.osp_yn         = 'Y'

        WHERE  td.working_time_default >= 0
        AND    td.working_time_default <= 7

		-- 1.2.2 TUESDAY ~ SUNDAY
		WHILE @N_DAYOFWEEK < 7
		BEGIN

		  INSERT INTO #TMP_SCP0096_WORKING_TIME_DEFAULT
		  SELECT TDT.DIVISION_ID
			    ,TDT.PLANT_SITE_ID
			    ,TDT.WORKING_TIME_DEFAULT
			    ,(TDT.WORKING_TIME_REMAIN-1) WORKING_TIME_REMAIN
			    ,CASE WHEN TDT.WORKING_TIME_REMAIN >= 1 THEN 1
				      WHEN TDT.WORKING_TIME_REMAIN < 0  THEN 0
					  ELSE TDT.WORKING_TIME_REMAIN
				 END WORKING_TIME_CALC
			    ,CASE WHEN @N_DAYOFWEEK = 1 THEN 'TUE'
				      WHEN @N_DAYOFWEEK = 2 THEN 'WED'
					  WHEN @N_DAYOFWEEK = 3 THEN 'THU'
					  WHEN @N_DAYOFWEEK = 4 THEN 'FRI'
					  WHEN @N_DAYOFWEEK = 5 THEN 'SAT'
					  WHEN @N_DAYOFWEEK = 6 THEN 'SUN'
				 END DAYOFWEEK
		  FROM   #TMP_SCP0096_WORKING_TIME_DEFAULT TDT WITH(NOLOCK)
		  WHERE  TDT.DAYOFWEEK = CASE WHEN @N_DAYOFWEEK = 1 THEN 'MON'
									  WHEN @N_DAYOFWEEK = 2 THEN 'TUE'
									  WHEN @N_DAYOFWEEK = 3 THEN 'WED'
									  WHEN @N_DAYOFWEEK = 4 THEN 'THU'
									  WHEN @N_DAYOFWEEK = 5 THEN 'FRI'
									  WHEN @N_DAYOFWEEK = 6 THEN 'SAT'
								 END
		  ;

		  SET @N_DAYOFWEEK = @N_DAYOFWEEK + 1;

		END;

	    -- 2. WORKING TIME(day) 생성
	    MERGE INTO SCP_MST_SHIPMENT_WORKING_DAY_OSP A
		USING ( SELECT  A.DIVISION_ID
					   ,A.SCM_SITE_ID
					   ,A.FACTORY_ID
					   ,A.OPERATION_ID
					   ,A.LINE_ID
					   ,C.BASIS_YYYYMMDD
					   ,(DT.WORKING_TIME_CALC * 1440) AS WORKING_TIME
				FROM   (
						-- OSP
						SELECT MS.DIVISION_ID
							  ,MS.SCM_SITE_ID
							  ,'-'         AS FACTORY_ID
							  ,MS.PLANT_ID AS OPERATION_ID
							  ,'-'         AS LINE_ID
						FROM   SCM_MST_SITE MS
						WHERE  MS.SITE_TYPE = 'PLANT'
						AND    MS.OSP_YN    = 'Y'
						AND    MS.VALID_YN  = 'Y'

						-- ESS 외주 PAKCER LINE 생산 TARGET 적용
						--UNION
						--SELECT A.DIVISION_ID
						--	 , A.SCM_SITE_ID
						--	 , '-'           AS FACTORY_ID
						--	 , A.OPERATION_ID
						--	 , A.LINE_ID
						--FROM SCM_MST_LINE_OSP A
						--JOIN SCM_MST_SITE B ON A.DIVISION_ID = B.DIVISION_ID AND A.SCM_SITE_ID = B.SCM_SITE_ID
						--WHERE B.ATTRIBUTE1 = 'Y'

					   ) A
				JOIN   #TMP_SCP0096_WORKING_TIME_DEFAULT DT WITH(NOLOCK)
				ON     A.DIVISION_ID  = DT.DIVISION_ID
				AND    A.SCM_SITE_ID  = DT.PLANT_SITE_ID
				LEFT OUTER JOIN SCM_SYS_CALENDAR_M C WITH(NOLOCK)
				ON     C.BASIS_YYYYMMDD >= CONVERT(CHAR(8), GETDATE(), 112)
				AND    C.BASIS_YYYYMMDD <  CONVERT(CHAR(8), GETDATE() + @N_PERIOD, 112)
				AND    DT.DAYOFWEEK     = C.DAYOFWEEK
				WHERE  A.DIVISION_ID
				      +A.SCM_SITE_ID
					  +BASIS_YYYYMMDD NOT IN (SELECT  WT.DIVISION_ID
					                                 +WT.PLANT_SITE_ID
													 +WT.YYYYMMDD
						                      FROM   SCP_MST_SHIPMENT_WORKING_DAY_OSP WT WITH(NOLOCK)
						                      JOIN   SCP_MST_SHIPMENT_WORKING_DAY_DEFAULT TD WITH(NOLOCK)
						                      ON     WT.DIVISION_ID   = TD.DIVISION_ID
						                      AND    WT.PLANT_SITE_ID = TD.PLANT_SITE_ID
						                      WHERE  YYYYMMDD >= CONVERT(CHAR(8), GETDATE(), 112)
						                      AND    YYYYMMDD <  CONVERT(CHAR(8), GETDATE() + @N_PERIOD, 112)
						                      AND    SHIPMENT_YN IS NOT NULL
						                      )
				AND    C.BASIS_YYYYMMDD IS NOT NULL
			  ) B
		ON (
				    A.DIVISION_ID	= B.DIVISION_ID
				AND A.PLANT_SITE_ID	= B.SCM_SITE_ID
				AND A.YYYYMMDD		= B.BASIS_YYYYMMDD
		  )
		WHEN MATCHED THEN
		  UPDATE SET
					 A.SHIPMENT_YN		=  CASE WHEN B.WORKING_TIME = '1440' THEN 'Y' ELSE 'N' END
					,A.LAST_UPDATED_BY	=  B.WORKING_TIME--@V_BATCH_USER
					,A.LAST_UPDATE_DATE	=  GETDATE()

		WHEN NOT MATCHED THEN
		  INSERT (
		          DIVISION_ID
			     ,PLANT_SITE_ID
			     ,YYYYMMDD
				 ,MEASURE
			     ,SHIPMENT_YN
				 ,CREATED_BY
				 ,CREATION_DATE
				 ,LAST_UPDATED_BY
				 ,LAST_UPDATE_DATE
				 )
		  VALUES (
		          B.DIVISION_ID
			 	 ,B.SCM_SITE_ID
				 ,B.BASIS_YYYYMMDD
				 ,'SHIPMENT WORKING DAY'
				 ,CASE WHEN B.WORKING_TIME = '1440' THEN 'Y' ELSE 'N' END --B.WORKING_TIME
			     ,@V_BATCH_USER
			     ,GETDATE()
			     ,@V_BATCH_USER
			     ,GETDATE()
			     )
		;

		-- 3. 임시 테이블 DROP
		DROP TABLE #TMP_SCP0096_WORKING_TIME_DEFAULT;

        IF @@TRANCOUNT > 0
		  BEGIN
            COMMIT WORK;
		  END;

      END
    END TRY

    BEGIN CATCH
	  IF @@TRANCOUNT > 0
        BEGIN
          ROLLBACK;
        END;
      -- ERROR LOG
      SET @V_LOG_TYPE = 'ERROR';
      SET @V_LOG_MESSAGE = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
      SET @V_DESCRIPTION = 'ERROR_LINE : '+ CAST(ERROR_LINE() AS NVARCHAR(10));;
      SET @D_EVENT_DATE = SYSDATETIME();
      EXEC PR_SCM_SYS_LOG_BATCH @V_PROGRAM_NAME, @V_LOG_TYPE, @N_LOG_COUNT, @V_LOG_MESSAGE, @V_DESCRIPTION, @D_EVENT_DATE;
    END CATCH;

    -- 종료 LOG
    SET @V_LOG_TYPE = 'END';
    SET @V_LOG_MESSAGE = '########## END OF PROCEDURE ##########';
    SET @V_DESCRIPTION = '';
    SET @D_EVENT_DATE = SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH @V_PROGRAM_NAME, @V_LOG_TYPE, @N_LOG_COUNT, @V_LOG_MESSAGE, @V_DESCRIPTION, @D_EVENT_DATE;

  END;
