/*
 * Program ID   : PR_SCM_MST_USER_INFO
 * Description  : USER 정보 I/F 
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2017.11.27   Kim Jaejung    Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018.04.10   Kim Jaejung    tb_fx_user 테이블에 DEPT_ID 최신값으로 동기화. DM 요청.
 * 2020.01.06	hwyoon		   SSO USER 공백제거 후 MERGE
 * 2023.02.22   FP Pjt.        attribute9:부서변경일자, attribute10:이전부서코드  
 * 2024.01.25   vadabi3        NERP - 특정 Company 별도 처리 개선
 * 2024.10.28	vadabi5		   NERP) QA DB 적용
 ----------------------------------------------------------------------------------------------------
 */

CREATE PROCEDURE [dbo].[PR_SCM_MST_USER_INFO]
AS
  BEGIN
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON; 
    SET XACT_ABORT ON;

    -- LOG 용 변수 설정
    DECLARE @v_batch_user NVARCHAR(150) = 'scm_batch';
	DECLARE @v_program_name NVARCHAR(150) = 'PR_SCM_MST_USER_INFO';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;
	DECLARE @v_ifseqno     NVARCHAR(30); -- 최초 한번은 전체 데이터 insert

	-- NERP 매핑코드
    DECLARE @v_COMPANY_SALES NVARCHAR(8);
    DECLARE @v_ESOC NVARCHAR(8);
	SELECT @v_COMPANY_SALES = dbo.FN_GET_LOOKUP_VALUE('PR_SCM_MST_USER_INFO','COMPANY_SALES');
	SELECT @v_ESOC = dbo.FN_GET_LOOKUP_VALUE('PR_SCM_MST_USER_INFO','ESOC');

	-- 시작 LOG
    SET @v_log_type = 'START';
    SET @v_log_message = '########## Start of procedure ##########';
    SET @v_description = '';
    SET @d_event_date = SYSDATETIME();

    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

    BEGIN TRY
      BEGIN

	  -- 인터페이스 테이블 처리 ROW UPDATE

			UPDATE [dbo].[XIF_SSO_USER_INFO_R_SN]
			SET attribute15 = 'P'
			WHERE ISNULL(attribute15,'N') = 'N';

	  -- 지나간 배치까지 적용하기 위해 Cursor 로 처리
	  DECLARE CUR_SSO_USER CURSOR FOR
	  SELECT IFSEQNO 
	  FROM  [dbo].[XIF_SSO_USER_INFO_R_SN] WITH(NOLOCK)
	  WHERE ATTRIBUTE15 = 'P'
	  GROUP BY IFSEQNO
	  ORDER BY IFSEQNO ASC;

		 OPEN CUR_SSO_USER;
		 FETCH NEXT FROM CUR_SSO_USER INTO @v_ifseqno ;
		 
		 WHILE (@@FETCH_STATUS = 0)
		 BEGIN
		 
			 MERGE INTO [dbo].[scm_mst_sso_user_info] A
			 USING ( 
					SELECT /* PR_SCM_MST_USER_INFO */ 
						   RTRIM(sa_user) AS sa_user
						  ,sa_name
						  ,sa_name_e
						  --,sa_user+'@lgchem.com' as email
						  ,CASE WHEN sa_dept IS NULL THEN sa_dept_new ELSE sa_dept END sa_dept
						  ,sa_jobx
						  ,sa_jobx_name
						  ,CASE WHEN sa_comp =  @v_COMPANY_SALES  THEN @v_ESOC	
								ELSE sa_comp 
								END sa_comp
						  ,sso_ex_flag
						  --,(case isnull(sso_ex_flag,'d') when 'd' then 'n' else 'y' end) as useyn
						  ,sa_gnmu
						  ,sa_gnmu_name
						  ,sso_locate
						  ,create_date
					  FROM [dbo].[XIF_SSO_USER_INFO_R_SN] A WITH(NOLOCK)
					  WHERE ifseqno = @v_ifseqno
					 -- AND SA_COMP IN(SELECT company_id from [dbo].[SCM_MST_SITE_SN] WITH(NOLOCK))
					  AND attribute15 = 'P'

					) B
			ON (           A.user_id           =  B.sa_user
			   )
			WHEN MATCHED THEN
				 UPDATE SET A.user_name        =  B.sa_name
						   ,A.user_name_en     =  B.sa_name_e  
						   --,A.email          =  B.email      
						   ,A.dept_id          =  B.sa_dept
						   ,A.job_code         =  B.sa_jobx    
						   ,A.job_name         =  B.sa_jobx_name
						   ,A.company_id       =  B.sa_comp
						   ,A.working_code     =  B.sa_gnmu    
						   ,A.working_name     =  B.sa_gnmu_name
						   ,A.sso_locate       =  B.sso_locate
						   ,A.active_flag      =  B.sso_ex_flag
						  --,A.valid_yn      =  B.useyn
						  --,A.created_by       =  @v_batch_user
						  --,A.creation_date    =  B.create_date      
						   ,A.last_updated_by  =  @v_batch_user
						   ,A.last_update_date =  GETDATE()
						   ,A.ATTRIBUTE9       = IIF(A.DEPT_ID != B.SA_DEPT, CONVERT(NVARCHAR, GETDATE(), 112) , A.ATTRIBUTE9)  --부서 변경일자
						   ,A.ATTRIBUTE10      = IIF(A.DEPT_ID != B.SA_DEPT, A.DEPT_ID , A.ATTRIBUTE10)                         --이전 부서코드
					                
			WHEN NOT MATCHED THEN
				 INSERT (    user_id
							,user_name
							,user_name_en
							--,email
							,dept_id
							--,funccode
							--,funcname
							,job_code
							,job_name
							,company_id
							,working_code
							,working_name
							,sso_locate
							,active_flag
							,created_by
							,creation_date
							,last_updated_by
							,last_update_date

						)
				 VALUES (    B.sa_user
							,B.sa_name
							,B.sa_name_e
							--,B.email
							,B.sa_dept
							--,B.sa_func
							--,B.sa_func_name_e
							--,B.useyn
							,B.sa_jobx    
							,B.sa_jobx_name
							,B.sa_comp
							,B.sa_gnmu    
							,B.sa_gnmu_name
							,B.sso_locate
							,B.sso_ex_flag
							,@v_batch_user
							,GETDATE()
							,@v_batch_user
							,GETDATE()
						)
			;

			 -----------------------------------------------------------
              -- Merge LOG
              -----------------------------------------------------------
              SET @v_log_type = 'APPEND';
              SET @v_log_message = 'MERGE INTO scm_mst_sso_user_info';
              SET @v_description = 'ifseqno = ' + @v_ifseqno;
              SET @d_event_date = SYSDATETIME();
              EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
              -----------------------------------------------------------

			-- 2018.04.10 tb_fx_user 테이블에 DEPT_ID 최신값으로 동기화. DM 요청
			UPDATE tb_fx_user
			SET   
				  dept_id		 =  rs.sa_dept
				 ,UpdateUserId	 =  @v_batch_user
				 ,UpdateDateTime =  GETDATE()
			FROM  tb_fx_user fu WITH(NOLOCK)
			JOIN  xif_sso_user_info_r_sn rs WITH(NOLOCK)
			ON    fu.userid		 = rs.sa_user
			AND   fu.dept_id    != rs.sa_dept
			WHERE rs.ifseqno	 = @v_ifseqno
			AND   rs.attribute15 = 'P'

			 -----------------------------------------------------------
              -- Merge LOG
              -----------------------------------------------------------
              SET @v_log_type = 'APPEND';
              SET @v_log_message = 'UPDATE tb_fx_user';
              SET @v_description = 'ifseqno = ' + @v_ifseqno;
              SET @d_event_date = SYSDATETIME();
              EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

		
			FETCH NEXT FROM CUR_SSO_USER INTO  @v_ifseqno
			END
		
		CLOSE CUR_SSO_USER;
		DEALLOCATE CUR_SSO_USER; 

		-- 처리 한 row 마킹
		
		UPDATE [dbo].[XIF_SSO_USER_INFO_R_SN] set attribute15='Y' 
		where attribute15 = 'P'

        -- TXN LOG
		/*
        SET @v_log_type = 'TXN';
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_message = 'INSERT INTO scm_sys_log_batch';
        SET @v_description = 'Description...';
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		*/
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
      SET @v_description = 'ERROR_LINE : ';
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
