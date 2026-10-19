/*
 * Program ID   : PR_SCM_MST_CUST_SHORT_NAME
 * Description  : Customer Short Name 정보 I/F
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018. 3. 27    Kim Jaejung      Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018. 4. 11    Kim Jaejung	   처리 결과 MQ 전송을 위해 로직 추가. 처리 결과를 XIF_MDM_IF_RESULT_S 테이블에 INSERT 
								   division 값이 ',' 구분해서 두개이상이 들어올 수 있어서 SELECT 로직 변경
   2024.05.29	P.C.I			[PJ20228272] NERP 대응- IF_ID 변경
 *
 */

CREATE PROCEDURE [dbo].[PR_SCM_MST_CUST_SHORT_NAME]
AS
  BEGIN
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON; 
    SET XACT_ABORT ON;

    -- LOG 용 변수 설정
    DECLARE @v_batch_user NVARCHAR(150) = 'scm_batch';
	DECLARE @v_program_name NVARCHAR(150) = 'PR_SCM_MST_CUST_SHORT_NAME';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;
	DECLARE @v_ifseqno     NVARCHAR(30); 
	DECLARE @n_mq_seq	BIGINT;
	DECLARE @v_instanceid     NVARCHAR(40); 

	-- 시작 LOG
    SET @v_log_type = 'START';
    SET @v_log_message = '########## Start of procedure ##########';
    SET @v_description = '';
    SET @d_event_date = SYSDATETIME();

    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

    BEGIN TRY
      BEGIN
	    -- 인터페이스 테이블 처리 ROW UPDATE
		UPDATE [dbo].[xif_mdm_cust_short_name_r_sn]
		SET    proc_flag = 'P'
		WHERE  ISNULL(proc_flag,'N') = 'N';

		-- key 값이 공백이거나 null 녀석들은 처리하지 말고 proc_flag = 'E' 처리 , division 데이터 마지막에 쉼표가 찍혔을 때 발생함.
		UPDATE [dbo].[xif_mdm_cust_short_name_r_sn]
		SET    proc_flag = 'F' , proc_date = GETDATE() , proc_msg = 'Key Value Error'
	    FROM   xif_mdm_cust_short_name_r_sn A WITH(NOLOCK) 
		OUTER  APPLY STRING_SPLIT(A.division,',')
		INNER  JOIN (
					SELECT if_seq,instanceid,codeid,customer_short_name,token
					FROM   xif_mdm_cust_short_name_r_sn WITH(NOLOCK) 
					OUTER APPLY STRING_SPLIT(division,',')
					WHERE ISNULL(token,'') = ''
					) B
		ON		A.if_seq			  = B.if_seq
		AND		A.instanceid		  = B.instanceid
		AND		A.codeid			  = B.codeid
		AND		A.customer_short_name = B.customer_short_name
		WHERE	A.proc_flag = 'P'
		AND		A.proc_flag != 'E'
		AND		ISNULL(B.token,'') = '';
	  
	    -- 지나간 배치까지 적용하기 위해 Cursor 로 처리
	    DECLARE CUR_SHORT_NAME CURSOR FOR
	      SELECT   if_seq 
	      FROM     [dbo].[xif_mdm_cust_short_name_r_sn] WITH(NOLOCK)
	      WHERE	   proc_flag IN('P','F')
	      GROUP BY if_seq
	      ORDER BY if_seq ASC;

		-- 2018. 4. 11 I/F 처리 결과 MQ 전송 로직 추가
	    SET @n_mq_seq = NEXT VALUE FOR SEQ1_XIF_MDM_CUST_SHORT_NAME_R

	    OPEN CUR_SHORT_NAME;
	    FETCH NEXT FROM CUR_SHORT_NAME INTO @v_ifseqno ;
		 
	    WHILE (@@FETCH_STATUS = 0)
		  BEGIN
		   
		     /* 
				history 처리 로직은 화면 history 처리 로직으로 대체함 - 대상 데이터 모두 history 에 저장......
	            추후 화면쪽 프로시져 히스토리 데이터 변경이 있을 시에 같이 변경이 필요함.		 
			 */

		    INSERT INTO SCM_ADM_LOOKUP_MASTER_DETAIL_H
					    (
							history_seq, lookup_type, description, display_seq, valid_yn, segment1, segment2, segment3, segment4, segment5, created_by, creation_date,
							last_updated_by, last_update_date
						)
			SELECT			NEXT VALUE FOR [dbo].[SEQ1_SCM_ADM_LOOKUP_MASTER_DETAIL_H] history_seq
						   ,'END_CUSTOMER' lookup_type 
						   ,null
						   ,1 display_seq
						   ,CASE status WHEN 'BLCK' THEN 'N' ELSE 'Y' END valid_yn
						   ,token segment1 -- 2018. 4. 11
						   ,customer_short_name segment2
						   ,customer_short_name segment3
						   ,'-' segment4
						   ,'-' segment5
						  ,@v_batch_user
						   ,GETDATE()
						   ,@v_batch_user
						   ,GETDATE() 
					FROM   xif_mdm_cust_short_name_r_sn WITH(NOLOCK)
					OUTER APPLY STRING_SPLIT(division,',') -- 2018. 4. 11
					WHERE  if_seq    = @v_ifseqno
					AND    proc_flag = 'P';

			-- HISTORY LOG
		
				SET @v_log_type = 'HISTORY';
				SET @n_log_count = @@ROWCOUNT;
				SET @v_log_message = 'INSERT INTO scm_adm_lookup_master_detail_h';
				SET @v_description = '@v_ifseqno - END_CUSTOMER' +':'+ CAST(@v_ifseqno AS nvarchar(100));
				SET @d_event_date = SYSDATETIME();
				EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

			INSERT INTO SCM_ADM_LOOKUP_MASTER_DETAIL_H
					    (
							history_seq, lookup_type, description, display_seq, valid_yn, segment1, segment2, segment3, segment4, segment5, created_by, creation_date,
							last_updated_by, last_update_date
						)
			SELECT			NEXT VALUE FOR [dbo].[SEQ1_SCM_ADM_LOOKUP_MASTER_DETAIL_H] history_seq
						   ,'SOLD_CUSTOMER' lookup_type 
						   ,null
						   ,1 display_seq
						   ,CASE status WHEN 'BLCK' THEN 'N' ELSE 'Y' END valid_yn
						   ,token segment1 -- 2018. 4. 11
						   ,customer_short_name segment2
						   ,customer_short_name segment3
						   ,'-' segment4
						   ,'-' segment5
						   ,@v_batch_user
						   ,GETDATE()
						   ,@v_batch_user
						   ,GETDATE() 
					FROM   xif_mdm_cust_short_name_r_sn WITH(NOLOCK)
					OUTER APPLY STRING_SPLIT(division,',') -- 2018. 4. 11
					WHERE  if_seq = @v_ifseqno
					AND    proc_flag = 'P';
	    
				-- HISTORY LOG
		
				SET @v_log_type = 'HISTORY';
				SET @n_log_count = @@ROWCOUNT;
				SET @v_log_message = 'INSERT INTO scm_adm_lookup_master_detail_h';
				SET @v_description = '@v_ifseqno - SOLD_CUSTOMER' +':'+ CAST(@v_ifseqno AS nvarchar(100));
				SET @d_event_date = SYSDATETIME();
				EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		    
		    MERGE INTO [dbo].[scm_adm_lookup_master_detail] A
			USING (
				  SELECT    /* PR_SCM_MST_CUST_SHORT_NAME - END MERGE */
							'END_CUSTOMER' lookup_type 
						   ,token segment1 -- 2018. 4. 11
						   ,customer_short_name segment2
						   ,customer_short_name segment3
						   ,'-' segment4
						   ,'-' segment5
						   ,1 display_seq
						   ,CASE status WHEN 'BLCK' THEN 'N' ELSE 'Y' END valid_yn
					FROM   xif_mdm_cust_short_name_r_sn WITH(NOLOCK) 
					OUTER APPLY STRING_SPLIT(division,',') -- 2018. 4. 11
					WHERE   if_seq = @v_ifseqno
					AND     proc_flag = 'P'

					) B
			ON (       
						   A.lookup_type	=  B.lookup_type
					   AND A.segment1	    =  B.segment1
					   AND A.segment2	    =  B.segment2
					   AND A.segment3	    =  B.segment3

			   )
			WHEN MATCHED THEN
				 UPDATE SET 
							 
							 A.valid_yn						=  B.valid_yn
							,A.last_updated_by				=  @v_batch_user
							,A.last_update_date				=  GETDATE()

					                
			WHEN NOT MATCHED THEN
				 INSERT (  
				             lookup_type
							,segment1
							,segment2
							,segment3
							,segment4
							,segment5
							,display_seq
							,valid_yn
					        ,created_by
						    ,creation_date
						    ,last_updated_by
						    ,last_update_date						  								
						)
				 VALUES (   
							 B.lookup_type
							,B.segment1
							,B.segment2
							,B.segment3
							,B.segment4
							,B.segment5
							,B.display_seq
							,B.valid_yn
						    ,@v_batch_user
						    ,GETDATE()
						    ,@v_batch_user
						    ,GETDATE() 
						)
			;

			MERGE INTO [dbo].[scm_adm_lookup_master_detail] A
			USING (
				  SELECT    /* PR_SCM_MST_CUST_SHORT_NAME - SOLD MERGE */
							'SOLD_CUSTOMER' lookup_type 
						   ,token segment1 -- 2018. 4. 11
						   ,customer_short_name segment2
						   ,customer_short_name segment3
						   ,'-' segment4
						   ,'-' segment5
						   ,1 display_seq
						   ,CASE status WHEN 'BLCK' THEN 'N' ELSE 'Y' END valid_yn
					FROM   xif_mdm_cust_short_name_r_sn WITH(NOLOCK)
					OUTER APPLY STRING_SPLIT(division,',') -- 2018. 4. 11
					WHERE   if_seq = @v_ifseqno
					AND    proc_flag = 'P'

					) B
			ON (       
						   A.lookup_type	=  B.lookup_type
					   AND A.segment1	    =  B.segment1
					   AND A.segment2	    =  B.segment2
					   AND A.segment3	    =  B.segment3

			   )
			WHEN MATCHED THEN
				 UPDATE SET 
							 
							 A.valid_yn						=  B.valid_yn
							,A.last_updated_by				=  @v_batch_user
							,A.last_update_date				=  GETDATE()

					                
			WHEN NOT MATCHED THEN
				 INSERT (  
				             lookup_type
							,segment1
							,segment2
							,segment3
							,segment4
							,segment5
							,display_seq
							,valid_yn
					        ,created_by
						    ,creation_date
						    ,last_updated_by
						    ,last_update_date						  								
						)
				 VALUES (   
							 B.lookup_type
							,B.segment1
							,B.segment2
							,B.segment3
							,B.segment4
							,B.segment5
							,B.display_seq
							,B.valid_yn
						    ,@v_batch_user
						    ,GETDATE()
						    ,@v_batch_user
						    ,GETDATE() 
						)
			;

			-- 2018. 4. 11 I/F 처리 결과 MQ 전송 로직 추가
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
					   ,'OFP0_GMDM_MDM_CUSSNAME_RESULT' --[PJ20228272] NERP 대응- IF_ID 변경(OFP0_DMDM_MDM_CUSSNAME_RESULT -> OFP0_GMDM_MDM_CUSSNAME_RESULT)
					   ,GETDATE()
					   ,'N'
					   ,instanceid
					   ,CASE proc_flag WHEN 'P' THEN 'S' ELSE 'E' END
					   ,proc_msg
			FROM   xif_mdm_cust_short_name_r_sn WITH(NOLOCK)
			WHERE if_seq = @v_ifseqno;
		   -- 2018. 4. 11 I/F 처리 결과 MQ 전송 로직 종료


			FETCH NEXT FROM CUR_SHORT_NAME INTO  @v_ifseqno
			END
		
		CLOSE CUR_SHORT_NAME;
		DEALLOCATE CUR_SHORT_NAME; 


		-- 처리 row 마킹
		UPDATE [dbo].[xif_mdm_cust_short_name_r_sn]
		SET proc_flag	=  'Y' , proc_date = GETDATE()
		WHERE proc_flag = 'P';

		-- 처리 row 마킹
		UPDATE [dbo].[xif_mdm_cust_short_name_r_sn]
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





