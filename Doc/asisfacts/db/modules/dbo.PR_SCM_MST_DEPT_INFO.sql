/*
 * Program ID   : PR_SCM_MST_DEPT_INFO
 * Description  : 부서정보 I/F 
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2017.11.22   Kim Jaejung    Initial Release 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2020.12.15   P.C.I		   [C20201215-000324] ensol 분사 후 2level_dept_id에 ensol 적용
 *
 */

CREATE PROCEDURE [dbo].[PR_SCM_MST_DEPT_INFO]
AS
  BEGIN
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON; 
    SET XACT_ABORT ON;

    -- LOG 용 변수 설정
    DECLARE @v_batch_user NVARCHAR(150) = 'scm_batch';
	DECLARE @v_program_name NVARCHAR(150) = 'PR_SCM_MST_DEPT_INFO';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;
	DECLARE @v_first_dept NVARCHAR(150);
	DECLARE @v_ifseqno     NVARCHAR(30); -- 누락된 전체 데이터 insert

	-- 시작 LOG
    SET @v_log_type = 'START';
    SET @v_log_message = '########## Start of procedure ##########';
    SET @v_description = '[dbo].[XIF_SSO_DEPT_INFO_R_SN] to [scm_mst_sso_dept_info]';
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

    BEGIN TRY
      BEGIN

	    -- 인터페이스 테이블 처리 ROW UPDATE
	     UPDATE [dbo].[XIF_SSO_DEPT_INFO_R_SN]
		 SET    transfer_flag = 'P'
		 WHERE  ISNULL(transfer_flag,'N') = 'N'


		-- 지나간 배치까지 적용하기 위해 Cursor 로 처리
		DECLARE CUR_SSO_DEPT CURSOR FOR
	      SELECT IFSEQNO 
		  FROM   [dbo].[XIF_SSO_DEPT_INFO_R_SN] WITH(NOLOCK)
		  WHERE  transfer_flag = 'P'
		  GROUP BY IFSEQNO
		  ORDER BY IFSEQNO ASC;

		  -- History 데이터 처리를 위한 TEMP Table 삭제 및 생성
		IF OBJECT_ID('dbo.scm_mst_customer_temp$') IS NOT NULL 
		  DROP TABLE scm_mst_customer_temp$


		OPEN CUR_SSO_DEPT;
		FETCH NEXT FROM CUR_SSO_DEPT INTO @v_ifseqno ;

		  WHILE (@@FETCH_STATUS = 0)
		    BEGIN
	
              MERGE INTO [dbo].[scm_mst_sso_dept_info] A
		      USING (SELECT  /* PR_SCM_MST_DEPT_INFO */ 
				             code_numb
					        ,code_name_ko
					        ,code_name_en
					        ,code_name_cn
					        ,code_uper
					        ,valid_flag
					        ,create_date
				     FROM   [dbo].[XIF_SSO_DEPT_INFO_R_SN]WITH(NOLOCK)
				     WHERE  ifseqno = @v_ifseqno
				     AND    transfer_flag = 'P') B
		      ON     A.dept_id  =  B.code_numb
		      
			  WHEN MATCHED THEN
			    UPDATE SET A.dept_name_ko     =  B.code_name_ko 
				  	      ,A.dept_name_en     =  B.code_name_en   
					      ,A.dept_name_cn     =  B.code_name_cn      
					      ,A.upper_dept_id    =  B.code_uper
                          ,A.valid_yn         =  ISNULL(B.valid_flag ,'Y')
					      ,A.last_updated_by  =  @v_batch_user
                          ,A.last_update_date =  GETDATE()					                
		      
			  WHEN NOT MATCHED THEN
			    INSERT (dept_id
					   ,dept_name_ko
					   ,dept_name_en
					   ,dept_name_cn
					   ,upper_dept_id
					   ,valid_yn
					   ,created_by
					   ,creation_date
					   ,last_updated_by
					   ,last_update_date)
			    VALUES (B.code_numb
			           ,B.code_name_ko 
					   ,B.code_name_en   
					   ,B.code_name_cn      
					   ,B.code_uper
                       ,ISNULL(B.valid_flag ,'Y')
					   ,@v_batch_user  
					   ,GETDATE()
					   ,@v_batch_user
                       ,GETDATE()
					   );
			
			
			  -----------------------------------------------------------
              -- Merge LOG
              -----------------------------------------------------------
              SET @v_log_type = 'APPEND';
              SET @v_log_message = 'MERGE INTO scm_mst_sso_dept_info';
              SET @v_description = 'ifseqno = ' + @v_ifseqno;
              SET @d_event_date = SYSDATETIME();
              EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
              -----------------------------------------------------------
		;

		FETCH NEXT FROM CUR_SSO_DEPT INTO  @v_ifseqno
	  END
		
	  CLOSE CUR_SSO_DEPT;
	  DEALLOCATE CUR_SSO_DEPT; 

	  -- 처리 한 row 마킹
	  UPDATE [dbo].[XIF_SSO_DEPT_INFO_R_SN]
	  SET    transfer_flag = 'Y' 
	  WHERE  transfer_flag = 'P'
		

  	  -- 부서 코드에서 2레벨에 해당하는 코드 INSERT

	  SELECT @v_first_dept=segment1 
	  FROM   [dbo].[SCM_ADM_LOOKUP_MASTER_DETAIL] WITH(NOLOCK) 
	  WHERE  lookup_type = '1LEVEL_DEPT_ID' 
	  AND    valid_yn = 'Y';

	  WITH dept_level(child,name,parent,sort,dept_level2,dept_name)
		AS (SELECT dept_id AS child
				  ,dept_name_ko AS code_name_ko
				  ,upper_dept_id AS parent
			  	  ,CONVERT(NVARCHAR(255),CAST(dept_id AS NVARCHAR(255))) AS sort
				  ,'' AS dept_level2
			 	  ,CONVERT(NVARCHAR(255),[dept_name_ko]) AS dept_name
			FROM  [dbo].[SCM_MST_SSO_DEPT_INFO] WITH(NOLOCK)
			WHERE dept_id = @v_first_dept
			UNION ALL
			SELECT B.dept_id AS child
				  ,b.dept_name_ko AS name
				  ,b.upper_dept_id AS parent
				  ,CONVERT(NVARCHAR(255),CONVERT(NVARCHAR,c.sort) +'>' + CONVERT(NVARCHAR(255),b.dept_id)) sort
				  ,'' AS dept_level2
				  , CONVERT(NVARCHAR(255), CONVERT(NVARCHAR,c.dept_name) + '>' +  CONVERT(NVARCHAR(255), b.dept_name_ko)) dept_name
			FROM  [dbo].[SCM_MST_SSO_DEPT_INFO] B WITH(NOLOCK) INNER JOIN dept_level C
			ON    b.upper_dept_id = c.child)
		SELECT  child
		       ,name
		       ,parent
			   ,sort
			   --[C20201215-000324] ensol 분사 후 2level_dept_id에 ensol 적용
			   ,CASE WHEN CHARINDEX('>',sort) > 1 THEN SUBSTRING(sort, 0, CHARINDEX('>',sort)) ELSE sort END AS dept_level2
			   /*,CASE WHEN CHARINDEX('>',REPLACE(sort,@v_first_dept+'>','')) > 1 
			         THEN SUBSTRING(REPLACE(sort,@v_first_dept+'>',''),0,CHARINDEX('>',REPLACE(sort,@v_first_dept+'>','')))
			         ELSE REPLACE(sort,@v_first_dept+'>','') END dept_level2*/
			   ,CASE WHEN CHARINDEX('>',REPLACE(dept_name,'LG Chem>','')) > 1 
			         THEN SUBSTRING(REPLACE(dept_name,'LG Chem>',''),0,CHARINDEX('>',REPLACE(dept_name,'LG Chem>','')))
			         ELSE REPLACE(dept_name,'LG Chem>','') END dept_name 
		INTO TEMP_DEPT$ 
		FROM dept_level;

		-- 부서 레벨 및 부서명 표시, 개발용 추후 다시 확인
		MERGE INTO [dbo].[scm_mst_sso_dept_info] A
		USING ( 
				SELECT /* PR_SCM_MST_DEPT_INFO_2LEVEL_DEPT */ 
				       child
					  ,name
					  ,parent
					  ,sort
					  ,dept_level2
					  ,dept_name
				  FROM TEMP_DEPT$ WITH(NOLOCK)

				) B
			ON (          
				        A.dept_id           =  B.child
					AND A.upper_dept_id     =  B.parent
			   )
		WHEN MATCHED THEN
			 UPDATE SET A.[2level_dept_id] =  B.dept_level2
					   ,A.attribute1       =  B.dept_name   
					   ,A.attribute2       =  B.sort     
		;

		DROP TABLE TEMP_DEPT$;

        IF @@TRANCOUNT > 0
		  BEGIN
            COMMIT WORK;
		  END;

      END;
    END TRY
    
    BEGIN CATCH
      IF @@TRANCOUNT > 0
		  BEGIN
            ROLLBACK;
		  END;
      -- ERROR LOG
      SET @v_log_type = 'ERROR';
      SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
      SET @v_description = 'ERROR_LINE : ' + CAST(ERROR_LINE() AS nvarchar(10));
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

