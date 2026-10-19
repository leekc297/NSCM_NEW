/*
 * Program ID   : PR_SCP_MST_WORKING_TIME_BATCH
 * Description  : Working time 생성 프로시져. 
				: 금일 기준 + 380일치 working time 을 생성해준다. (라인별 Default 로 설정해 놓은 Working Time 적용)
				: 기존에 데이터가 있는 녀석은 제외함.
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018.04.17   Kim Jaejung    Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018.05.30   Kim Jihye      Working Time 0 버그 수정
 * 2018.06.01   Kim Jihye      Line 별 Default Working Time 적용
 * 2018.08.16   Kim Jihye      Working Time 소수점 1자리->2자리 관리로 수정
 * 2020.02.06   khj79          ESS 외주 Pakcer Line 생산 Target 적용
 *                             OSP 에서 ESS 외주 Line 제외 하지 않음(타 화면에서 라인('-') 사용함 ) 조건 : isnull(ms.ATTRIBUTE1,'N') <> 'Y'
 * 2021.01.25   KSG            PJ20209642 LGES 전지GSCM 상반기 프로젝트 : OSP Plant Site 정보만 생성
 * 2021.05.28   KSG            PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 대응
 * 2022.03.25   sclee          PJ20216891 LGES Digital SCM 3 Level 가속화를 위한 개선 - 새사업부 추가
 */

CREATE PROCEDURE [dbo].[PR_SCP_MST_WORKING_TIME_BATCH]
AS
  BEGIN
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON; 
    SET XACT_ABORT ON;

    -- LOG 용 변수 설정
    DECLARE @v_batch_user   NVARCHAR(150) = 'scm_batch';
	DECLARE @v_program_name NVARCHAR(150) = 'PR_SCP_MST_WORKING_TIME_BATCH';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;
	DECLARE @v_ifseqno      NVARCHAR(30); 
	DECLARE @v_instanceid   NVARCHAR(40); 
	DECLARE @n_mq_seq	    BIGINT;
	DECLARE @n_dayofweek    INT = 1;
	DECLARE @n_period       INT = 380;

	-- 시작 LOG
    SET @v_log_type = 'START';
    SET @v_log_message = '########## Start of procedure ##########';
    SET @v_description = '';
    SET @d_event_date = SYSDATETIME();

    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

    BEGIN TRY
      BEGIN  
	  	  
		-- 20210528 PJ20209642 : Working Time 생성 구간
		-- SELECT @n_period = DATEDIFF(D,  CONVERT(DATE, plan_name), CONVERT(DATE, horizon_end_date) ) + 1
		-- FROM   dbo.scm_mst_plan p WITH(NOLOCK)
		-- WHERE  p.division_id = '81'
        -- AND    p.plan_cycle  = 'WEEKLY'
		-- AND    p.plan_name   = CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112) -- 당주 월요일 YYYYMMDD
		
        -- PJ20216891
        SELECT TOP 1 @n_period = DATEDIFF(D,  CONVERT(DATE, plan_name), CONVERT(DATE, MAX(horizon_end_date)) ) + 1
		FROM   dbo.scm_mst_plan p WITH(NOLOCK)
		WHERE  p.plan_cycle  = 'WEEKLY'
		AND    p.plan_name   = CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112) -- 당주 월요일 YYYYMMDD
		GROUP BY plan_name
	  
	    -- 1. Default Working Time 계산 (2018.06.01   Kim Jihye)
		-- 1.1 Working Time 계산 임시 테이블 생성
		IF OBJECT_ID('dbo.scp_mst_working_time_default_temp$') IS NOT NULL DROP TABLE scp_mst_working_time_default_temp$

		CREATE TABLE scp_mst_working_time_default_temp$ (
	       division_id	        NVARCHAR(30)
		  ,plant_site_id        NVARCHAR(30)
		  ,factory_id           NVARCHAR(30)
		  ,operation_id         NVARCHAR(30)
		  ,line_id              NVARCHAR(50)
		  ,working_time_default NUMERIC(3,2) -- 2018.08.16, Working Time 소수점 1자리->2자리 관리로 수정
		  ,working_time_remain  NUMERIC(3,2) -- 2018.08.16, Working Time 소수점 1자리->2자리 관리로 수정
		  ,working_time_calc    NUMERIC(3,2) -- 2018.08.16, Working Time 소수점 1자리->2자리 관리로 수정
		  ,dayofweek            NVARCHAR(3)
		);

		-- 1.2 Working Time Default 데이타 생성
		-- 1.2.1 Monday
		INSERT INTO scp_mst_working_time_default_temp$
		SELECT td.division_id
              ,td.plant_site_id
	          ,td.factory_id
	          ,td.operation_id
	          ,td.line_id
	          ,td.working_time_default
	          ,(td.working_time_default-1) working_time_remain
	          ,CASE WHEN td.working_time_default >= 1 THEN 1 ELSE td.working_time_default END working_time_calc
	          ,'MON' dayofweek
        FROM   scp_mst_working_time_default td WITH(NOLOCK)
               -- 20210125 PJ20209642 : OSP Plant Site 정보만 생성
               INNER JOIN scm_mst_site s WITH(NOLOCK)
               ON  td.division_id   = s.division_id
               AND td.plant_site_id = s.scm_site_id
               AND s.osp_yn         = 'Y'

        WHERE  td.working_time_default >= 0
        AND    td.working_time_default <= 7 
        AND    td.valid_yn = 'Y';

		-- 1.2.2 Tuesday ~ Sunday
		WHILE @n_dayofweek < 7
		BEGIN		  

		  INSERT INTO scp_mst_working_time_default_temp$
		  SELECT tdt.division_id
			    ,tdt.plant_site_id
			    ,tdt.factory_id
			    ,tdt.operation_id
			    ,tdt.line_id
			    ,tdt.working_time_default
			    ,(tdt.working_time_remain-1) working_time_remain
			    ,CASE WHEN tdt.working_time_remain >= 1 THEN 1 
				      WHEN tdt.working_time_remain < 0  THEN 0
					  ELSE tdt.working_time_remain 
				 END working_time_calc
			    ,CASE WHEN @N_dayofweek = 1 THEN 'TUE' 
				      WHEN @N_dayofweek = 2 THEN 'WED' 
					  WHEN @N_dayofweek = 3 THEN 'THU' 
					  WHEN @N_dayofweek = 4 THEN 'FRI' 
					  WHEN @N_dayofweek = 5 THEN 'SAT' 
					  WHEN @N_dayofweek = 6 THEN 'SUN' 
				 END dayofweek
		  FROM   scp_mst_working_time_default_temp$ tdt WITH(NOLOCK)
		  WHERE  tdt.dayofweek = CASE WHEN @N_dayofweek = 1 THEN 'MON' 
									  WHEN @N_dayofweek = 2 THEN 'TUE' 
									  WHEN @N_dayofweek = 3 THEN 'WED' 
									  WHEN @N_dayofweek = 4 THEN 'THU' 
									  WHEN @N_dayofweek = 5 THEN 'FRI' 
									  WHEN @N_dayofweek = 6 THEN 'SAT' 
								 END
		  ;

		  SET @n_dayofweek = @n_dayofweek + 1;

		END;
	   
	    -- 2. Working Time 생성
	    MERGE INTO scp_mst_working_time a
		USING ( SELECT  a.division_id
					   ,a.scm_site_id
					   ,a.factory_id
					   ,a.operation_id
					   ,a.line_id
					   ,c.basis_yyyymmdd
					   ,(dt.working_time_calc * 1440) AS working_time
				FROM   (
                        -- 20210125 PJ20209642 : OSP Plant Site 정보만 생성 : Start
				        -- 전지본부 Plant
				   /*     SELECT  DISTINCT 
								a.division_id
							   ,ISNULL(dbo.FN_GET_SCM_SITE_ID_PLANT(a.plant_id,b.shop_group_id),'-') scm_site_id
							   ,b.factory_id
							   ,a.operation_id
							   ,a.line_id
						FROM   scm_mst_line_sn a WITH(NOLOCK)
						INNER JOIN scm_mst_factory_sn b WITH(NOLOCK)
						ON     a.company_id  = b.company_id
						AND    a.division_id = b.division_id
						AND    a.site_id	 = b.site_id
						AND    a.plant_id	 = b.plant_id
						AND    a.factory_id  = b.factory_id
						AND    a.division_id IN ('40', '81', '82') -- 20190325 전지본부만
						AND    b.shop_group_id IS NOT NULL
						AND    a.operation_id IN (SELECT DISTINCT b.segment4
												  FROM   scm_adm_lookup_master_detail b WITH(NOLOCK)
												  WHERE  b.lookup_type = 'LOCATION_GROUP_ROUTE'
												  AND    b.valid_yn = 'Y'
												  AND    b.segment3 = 'Y')
												  
						UNION */
                        -- 20210125 PJ20209642 : OSP Plant Site 정보만 생성 : End

						-- OSP
						SELECT ms.division_id
							  ,ms.scm_site_id
							  ,'-'         as factory_id
							  ,ms.plant_id as operation_id
							  ,'-'         as line_id
						FROM   scm_mst_site ms
						WHERE  ms.site_type = 'PLANT'
						AND    ms.osp_yn    = 'Y'
						AND    ms.valid_yn  = 'Y'

						-- ESS 외주 Pakcer Line 생산 Target 적용
						UNION
						SELECT a.division_id
							 , a.scm_site_id
							 , '-'           as factory_id
							 , a.operation_id
							 , a.line_id
						FROM SCM_MST_LINE_OSP A 
						JOIN SCM_MST_SITE B ON A.DIVISION_ID = B.DIVISION_ID AND A.SCM_SITE_ID = B.SCM_SITE_ID
						WHERE b.attribute1 = 'Y'
 
					   ) a
				JOIN   scp_mst_working_time_default_temp$ dt WITH(NOLOCK)
				ON     a.division_id  = dt.division_id
				AND    a.scm_site_id  = dt.plant_site_id
				AND    a.factory_id   = dt.factory_id
				AND    a.operation_id = dt.operation_id
				AND    a.line_id      = dt.line_id
				LEFT OUTER JOIN scm_sys_calendar_m c WITH(NOLOCK)
				ON     c.basis_yyyymmdd >= CONVERT(CHAR(8), GETDATE(), 112)
				AND    c.basis_yyyymmdd <  CONVERT(CHAR(8), GETDATE() + @n_period, 112)
				AND    dt.dayofweek     = c.dayofweek
				WHERE  a.division_id
				      +a.scm_site_id
					  +a.factory_id
					  +a.operation_id
					  +a.line_id
					  +basis_yyyymmdd NOT IN (SELECT  wt.division_id
					                                 +wt.plant_site_id
													 +wt.factory_id
													 +wt.operation_id
													 +wt.line_id
													 +wt.yyyymmdd
						                      FROM   scp_mst_working_time wt WITH(NOLOCK)
						                      JOIN   scp_mst_working_time_default td WITH(NOLOCK)
						                      ON     wt.division_id   = td.division_id
						                      AND    wt.plant_site_id = td.plant_site_id
						                      AND    wt.factory_id    = td.factory_id
						                      AND    wt.operation_id  = td.operation_id
						                      AND    wt.line_id       = td.line_id 
						                      WHERE  yyyymmdd >= CONVERT(char(8), GETDATE(), 112)
						                      AND    yyyymmdd <  CONVERT(char(8), GETDATE() + @n_period, 112)
						                      AND    working_time IS NOT NULL  -- 2018.05.30 Kimjhy
						                      -- AND    ISNULL(working_time, '') != ''
						                      )
				AND    c.basis_yyyymmdd IS NOT NULL
			  ) B
		ON (       
				    A.division_id	= B.division_id
				AND A.plant_site_id	= B.scm_site_id
				AND A.factory_id	= B.factory_id
				AND A.operation_id	= B.operation_id
				AND A.line_id		= B.line_id
				AND A.yyyymmdd		= B.basis_yyyymmdd
		  )
		WHEN MATCHED THEN
		  UPDATE SET 
					 A.working_time					=  B.working_time
					,A.last_updated_by				=  @v_batch_user
					,A.last_update_date				=  GETDATE()
					                
		WHEN NOT MATCHED THEN
		  INSERT (
		          division_id
			     ,plant_site_id
			     ,factory_id
			     ,operation_id
			     ,line_id
			     ,yyyymmdd
			     ,working_time
				 ,created_by
				 ,creation_date
				 ,last_updated_by
				 ,last_update_date
				 )
		  VALUES (
		          B.division_id
			 	 ,B.scm_site_id
				 ,B.factory_id
				 ,B.operation_id
				 ,B.line_id
				 ,B.basis_yyyymmdd
				 ,B.working_time
			     ,@v_batch_user
			     ,GETDATE()
			     ,@v_batch_user
			     ,GETDATE() 
			     )
		;
		
		-- 3. 임시 테이블 Drop
		DROP TABLE scp_mst_working_time_default_temp$;

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
      SET @v_log_type = 'ERROR';
      SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
      SET @v_description = 'ERROR_LINE : '+ CAST(ERROR_LINE() AS nvarchar(10));;
      SET @d_event_date = SYSDATETIME();
      EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
    END CATCH;

    -- 종료 LOG
    SET @v_log_type = 'END';
    SET @v_log_message = '########## END of procedure ##########';
    SET @v_description = '';
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

  END;
