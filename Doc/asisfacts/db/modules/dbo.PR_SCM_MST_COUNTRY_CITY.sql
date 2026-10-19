/*
 * Program ID   : PR_SCM_MST_COUNTRY_CITY
 * Description  : MDM City, Country 정보 I/F 
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018. 3. 27    Kim Jaejung      Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018. 4. 11    Kim Jaejung	   처리 결과 MQ 전송을 위해 로직 추가. 처리 결과를 XIF_MDM_IF_RESULT_S 테이블에 INSERT 
   2024.05.29	P.C.I			[PJ20228272] NERP 대응- IF_ID 변경
 *
 */

CREATE PROCEDURE [dbo].[PR_SCM_MST_COUNTRY_CITY]
AS
  BEGIN
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON; 
    SET XACT_ABORT ON;

    -- LOG 용 변수 설정
    DECLARE @v_batch_user NVARCHAR(150) = 'scm_batch';
	DECLARE @v_program_name NVARCHAR(150) = 'PR_SCM_MST_COUNTRY_CITY';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;
	DECLARE @v_ifseqno      NVARCHAR(30); 
	DECLARE @v_instanceid     NVARCHAR(40); 
	DECLARE @n_mq_seq	BIGINT;

	-- 시작 LOG
    SET @v_log_type = 'START';
    SET @v_log_message = '########## Start of procedure ##########';
    SET @v_description = '';
    SET @d_event_date = SYSDATETIME();

    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

    BEGIN TRY
      BEGIN
	    -- 인터페이스 테이블 처리 ROW UPDATE
		UPDATE [dbo].[xif_mdm_city_r_sn]
		SET    proc_flag = 'P'
		WHERE  ISNULL(proc_flag,'N') = 'N';

		-- key 값이 공백이거나 null 녀석들은 처리하지 말고 proc_flag = 'E' 처리
		UPDATE [dbo].[xif_mdm_city_r_sn]
		SET    proc_flag = 'F' , proc_date = GETDATE() , proc_msg = 'Key Value Error'
	    WHERE  proc_flag = 'P'
		AND    proc_flag != 'E'
		AND    ISNULL(city,'') = ''

		UPDATE [dbo].[xif_mdm_city_r_sn]
		SET    proc_flag = 'F' , proc_date = GETDATE() , proc_msg = 'Key Value Error'
	    WHERE  proc_flag = 'P'
		AND    proc_flag != 'E'
		AND    ISNULL(country,'') = '';
	  
	    -- 지나간 배치까지 적용하기 위해 Cursor 로 처리
	    DECLARE CUR_CITY CURSOR FOR
	      SELECT if_seq 
	      FROM   [dbo].[xif_mdm_city_r_sn] WITH(NOLOCK)
	      WHERE  proc_flag IN('P','F')
	      GROUP BY if_seq
	      ORDER BY if_seq ASC;

	    -- 2018. 4. 11 I/F 처리 결과 MQ 전송 로직 추가
		SET @n_mq_seq = NEXT VALUE FOR SEQ1_XIF_MDM_CITY_R;


	  OPEN CUR_CITY;
	  FETCH NEXT FROM CUR_CITY INTO @v_ifseqno ;
		 
	    WHILE (@@FETCH_STATUS = 0)
		  BEGIN
		   
		    
		    MERGE INTO [dbo].[scm_mst_city] A
			USING (
				  SELECT    /* PR_SCM_MST_COUNTRY_CITY - CITY  MERGE */
							country 
						   ,LEFT(city,5) city
						   ,LEFT(MAX(city_name),100) city_name
						   ,MAX(state_cd) state_cd
						   ,CASE MAX(status) WHEN 'BLCK' THEN 'N' ELSE 'Y' END status
					FROM   xif_mdm_city_r_sn WITH(NOLOCK)
					WHERE   if_seq = @v_ifseqno
					AND     proc_flag = 'P'
					GROUP BY country, city

					) B
			ON (       
						   A.country	=  B.country
					   AND A.city	    =  B.city

			   )
			WHEN MATCHED THEN
				 UPDATE SET 
							 
							 A.city_name					=  B.city_name
							,A.state_cd						=  B.state_cd
							,A.valid_yn						=  B.status
							,A.last_updated_by				=  @v_batch_user
							,A.last_update_date				=  GETDATE()

					                
			WHEN NOT MATCHED THEN
				 INSERT (  
				             country
							,city
							,city_name
							,state_cd
							,valid_yn
					        ,created_by
						    ,creation_date
						    ,last_updated_by
						    ,last_update_date						  								
						)
				 VALUES (   
							 B.country
							,B.city
							,B.city_name
							,B.state_cd
							,B.status
						    ,@v_batch_user
						    ,GETDATE()
						    ,@v_batch_user
						    ,GETDATE() 
						)
			;

			MERGE INTO [dbo].[scm_mst_country] A
			USING (
				  SELECT    /* PR_SCM_MST_COUNTRY_CITY - COUNTRY  MERGE */
							country 
						   ,LEFT(MAX(country_name),50) country_name
						   ,LEFT(MAX(country_name_kor),50) country_name_kor
					FROM   xif_mdm_city_r_sn WITH(NOLOCK)
					WHERE   if_seq = @v_ifseqno
					AND     proc_flag = 'P'
					GROUP BY country


					) B
			ON (       
							A.country	=  B.country

			   )
			WHEN MATCHED THEN
				 UPDATE SET 
							 
							 A.country_name					=  B.country_name
							,A.country_kr_name				=  B.country_name_kor
							,A.valid_yn						=  'Y'
							,A.last_updated_by				=  @v_batch_user
							,A.last_update_date				=  GETDATE()

					                
			WHEN NOT MATCHED THEN
				 INSERT (  
				             country
							,country_name
							,country_kr_name
							,valid_yn
					        ,created_by
						    ,creation_date
						    ,last_updated_by
						    ,last_update_date						  								
						)
				 VALUES (   
							 B.country
							,B.country_name
							,B.country_name_kor
							,'Y'
						    ,@v_batch_user
						    ,GETDATE()
						    ,@v_batch_user
						    ,GETDATE() 
						)
			;				

			 -- 2018. 4. 11 I/F 처리 결과 MQ 전송 로직 추가 시작
			INSERT INTO xif_mdm_if_result_s_sn
					   (if_seq
					   ,if_type
					   ,if_id
					   ,if_ins_date
					   ,if_flag
					   ,instanceid
					   ,eai_status
					   ,eai_message)
			SELECT 
					   'OFP0'+CONVERT(VARCHAR,GETDATE(),112)+ dbo.FN_ZERO_LPAD(CONVERT(VARCHAR,NEXT VALUE FOR SEQ1_XIF_MDM_IF_RESULT_S),10)
					   ,'I'
					   ,'OFP0_GMDM_MDM_CITYCODE_RESULT' --[PJ20228272] NERP 대응- IF_ID 변경(OFP0_DMDM_MDM_CITYCODE_RESULT -> OFP0_GMDM_MDM_CITYCODE_RESULT)
					   ,GETDATE()
					   ,'N'
					   ,instanceid
					   ,CASE proc_flag WHEN 'P' THEN 'S' ELSE 'E' END
					   ,proc_msg
			FROM   xif_mdm_city_r_sn WITH(NOLOCK)
			WHERE if_seq = @v_ifseqno
		   -- 2018. 4. 11 I/F 처리 결과 MQ 전송 로직 종료

			FETCH NEXT FROM CUR_CITY INTO  @v_ifseqno
			END
		
		CLOSE CUR_CITY;
		DEALLOCATE CUR_CITY; 
		
		-- 처리 row 마킹
		UPDATE [dbo].[xif_mdm_city_r_sn]
		SET proc_flag	=  'Y' , proc_date = GETDATE()
		WHERE proc_flag = 'P';

		-- 처리 row 마킹
		UPDATE [dbo].[xif_mdm_city_r_sn]
		SET proc_flag	=  'E' , proc_date = GETDATE()
		WHERE proc_flag = 'F';


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
  
  
