




/*
- 테이블 입력 : FP_NETJOB_QUEUE
- 참조 프로시저 : PR_SCM_NETJOB_RUN_CN_CELL

*/

CREATE PROCEDURE [dbo].[PR_SCM_OF_RELEASE_AUTO_PROCESSING]
  @p_site_id nvarchar(MAX) = '-'

WITH EXEC AS CALLER
AS
/***********************************************************************************************/
/** 프로그램 ID   : PR_SCM_OF_RELEASE_AUTO_PROCESSING                                         **/
/** 프로그램 명   :                                                                           **/
/** 설 명         :                                                                           **/
/** Version       : 1.0.0                                                                     **/
/**                                                                                           **/
/** Argument                                                                                  **/
/**                                                                                           **/
/**  [검색 조건]                                                                              **/
/**                                                                                           **/
/** [Biz Logic]                                                                               **/
/**                                                                                           **/
/**-------------------------------------------------------------------------------------------**/
/** 작 성 일 자    작 성 자      사     유                                                    **/
/**===========================================================================================**/
/** 2021.01.26    LJS          최초 작성                                                      **/
/** 2024.04.04    KIMJS        NERP PLANT_ID 변경에 따른 CONVERSION 반영                      **/
/** 2026/06/08   kimcd      [PJ2026-50273] MI ESS LINK 공장 SCM(SCP/FP/PSCM ) 대응.            **/
/**                         Pack 공정군 로직에 LINK 공정군 추가                                 **/
/***********************************************************************************************/
/*
  EXEC PR_SCM_OF_RELEASE_AUTO_PROCESSING
*/
BEGIN
  SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON; 
  SET XACT_ABORT ON;

  -- 필수 칼럼
  DECLARE @v_master_id      nvarchar(30)
  DECLARE @v_plan_id        nvarchar(30)
  DECLARE @v_plan_date      nvarchar(30)
  DECLARE @v_release_id     nvarchar(50)
  DECLARE @v_unit_id        nvarchar(50)
  DECLARE @v_factory_id     nvarchar(50)
  DECLARE @v_plan_group_id  nvarchar(50)
  
  DECLARE @v_division_id    nvarchar(50)
  DECLARE @v_site_id        nvarchar(50)
  DECLARE @v_description    nvarchar(50)
  DECLARE @v_user_id        nvarchar(50)
  DECLARE @v_release_plan_id nvarchar(50)
  DECLARE @v_PIC_option     nvarchar(50) -- PIC 기능 활성화 여부
  DECLARE @v_MRP_flag       nvarchar(50) -- MRP 전송 처리 여부

  -- LOG 용 변수 설정
  DECLARE @v_proc_name      nvarchar(100) = 'PR_SCM_OF_RELEASE_AUTO_PROCESSING'
  DECLARE @v_table_name     nvarchar(100)
  DECLARE @v_message        nvarchar(250)
  DECLARE @v_descr          nvarchar(250)
  DECLARE @n_row_count      Integer  = 0
  DECLARE @n_log_count      Integer  = 0
  DECLARE @v_log_code       nvarchar(10)

  DECLARE @n_order_seq      Integer  = 0
        , @v_amend_type     nvarchar(30)      -- amend 유형 정보
        , @v_confirm_area   nvarchar(30)      -- factory, plan group 
		, @v_instance_type  nvarchar(30)
		, @v_rowCount       Integer  = 0
        
  DECLARE @v_run_master_id      nvarchar(30)
        , @v_run_event_time     datetime
        
  DECLARE @sysdate          DATETIME2 = GETDATE()
  DECLARE @v_insert_dttm    date

  DECLARE @v_temp1          nvarchar(1000)
  DECLARE @v_temp2          nvarchar(1000)
  -- try-catch 용 변수
  DECLARE @v_catch_count    Integer  = 0
  DECLARE @v_catch_mesTrans nvarchar(30)
  DECLARE @v_catch_release  nvarchar(30)

  DECLARE @v_plan_run_flag  nvarchar(10)  = 'SKIP'

  DECLARE @v_job_seq int
  
  -------------------------------------------------------------------------------------------
  SET @v_site_id   = @p_site_id
  SET @v_master_id = '-'
  SET @v_plan_id   = '-'

  SET @v_temp1 = 'S' + replicate('0', 4-LEN(CAST(ERROR_LINE() AS nvarchar(10)))) + CAST(ERROR_LINE() AS nvarchar(10))
  SET @v_temp2 = 'E' + replicate('0', 4-LEN(CAST(ERROR_LINE() AS nvarchar(10)))) + CAST(ERROR_LINE() AS nvarchar(10))

  -- 배포 프로세스 시작
  SET @n_log_count = @n_log_count + 1
  SET @sysdate = GETDATE()
  SET @v_descr = '############### Start of procedure ############### SITE :: ' + @v_site_id;

  EXEC PR_LOG_PROCESS @sysdate, @v_master_id, @v_plan_id, @v_proc_name, null, 'START', @n_log_count, null, @v_descr, null

  EXEC PR_XIF_LOG @v_proc_name, NULL, 'START', @n_log_count, @v_temp1, '############### Start of procedure ###############', NULL, @sysdate

  BEGIN TRY
	
	-- site 별 시업시간을 반영한 당일을 검색... plant 가 여러개일 경우, 시업시간이 먼저인 쪽을 선택(MIN)
	SELECT 	@v_plan_date = CASE WHEN FORMAT(dbo.FN_SITE_TIME(A.SITE_ID) ,'yyyyMMddHHmmss') < CONVERT(VARCHAR,dbo.FN_SITE_TIME(A.SITE_ID),112) + A.BASIS_START_TIME THEN CONVERT(VARCHAR, DATEADD(DD,-1,dbo.FN_SITE_TIME(A.SITE_ID)), 112)
        				                                                                                                                                           ELSE CONVERT(VARCHAR, dbo.FN_SITE_TIME(A.SITE_ID), 112) END
	FROM (
		SELECT @v_site_id AS SITE_ID, MIN(B.CODE_ID) AS BASIS_START_TIME
		FROM   FP_INSTANCE_INFO_V A WITH(NOLOCK)
		LEFT OUTER JOIN (
			SELECT SEGMENT1 AS PLANT_ID, SEGMENT2 AS CODE_ID
			FROM SCM_SYS_LOOKUP_VALUE B WITH(NOLOCK)
			WHERE LOOKUP_TYPE_CODE = 'BASIS_START_TIME_PLANT'
			AND   ACTIVE_FLAG = 'Y'
		) B
		ON     A.PLANT_ID = B.PLANT_ID
		WHERE  1=1
		AND    A.SITE_ID = @v_site_id
	) A

	SET @v_proc_name = 'PR_SCM_OF_RELEASE_AUTO_PROCESSING'

	-- * 진행중인 프로세스가 있으면 skip, 없으면 진행
	-- JOB_TYPE : R / P / C /E  : READY / PROCEEDING / COMPLETE / ERROR
	SELECT	@v_plan_run_flag = CASE WHEN ISNULL(CNT,0) > 0 THEN 'SKIP' ELSE 'RUN' END
	FROM	(
			SELECT COUNT(JOB_TYPE) AS CNT
			FROM   FP_NETJOB_QUEUE A WITH(NOLOCK)
			WHERE  1=1
			AND	   A.INSTANCE_DATE = @v_plan_date
			AND    A.PARAMETER4    = @v_site_id
			AND    A.PROC_NAME     = @v_proc_name
			AND	   A.ACTIVE_FLAG   = 'Y'
			AND	   A.JOB_TYPE      = 'P'
  	) A
	WHERE	1=1
     
	SET @n_log_count = @n_log_count + 1
	SET @v_descr = 'QUEUE RUN FLAG : ' + @v_plan_run_flag
	EXEC PR_LOG_PROCESS @sysdate, @v_master_id, @v_plan_id, @v_proc_name, 'FP_NETJOB_QUEUE', 'SELECT', @n_log_count, NULL, @v_descr, null


    -- 필수 DATA 쿼리
	-- 프로시져 수행 여부 check
	IF @v_plan_run_flag = 'RUN'
    BEGIN
	  
	  SET @v_table_name = 'FP_NETJOB_QUEUE'
	  SET @v_job_seq = 0
	  		
	  -- 대기중인 job 중에서 이전 순번 가져온다.
	  SELECT @v_job_seq = MIN(JOB_SEQ)
	  FROM	 FP_NETJOB_QUEUE A WITH(NOLOCK)
	  WHERE	 1=1
	  AND	 A.INSTANCE_DATE = @v_plan_date
	  AND    A.PARAMETER4    = @v_site_id
	  AND    A.PROC_NAME     = @v_proc_name
	  AND	 A.ACTIVE_FLAG	 = 'Y'
	  AND	 A.JOB_TYPE		 = 'R'
	  

	  -- 진행
	  UPDATE FP_NETJOB_QUEUE
	  SET	 JOB_TYPE      = 'P'
	  	   , UPDATE_DTTM   = GETDATE()
	  WHERE	 INSTANCE_DATE = @v_plan_date
	  AND    PARAMETER4    = @v_site_id
	  AND    PROC_NAME     = @v_proc_name
	  AND	 ACTIVE_FLAG   = 'Y'
	  AND	 JOB_TYPE      = 'R'
	  AND	 JOB_SEQ	   = @v_job_seq
	  
	  
	  SELECT  @v_master_id    = INSTANCE_ID
	        , @v_plan_id      = FP_PLAN_ID
	  		, @v_division_id  = A.PARAMETER3
	  		, @v_factory_id   = A.PARAMETER5
	  		, @v_description  = A.ATTRIBUTE1
	  		, @v_user_id      = A.ATTRIBUTE2
			, @v_MRP_flag     = ISNULL(A.ATTRIBUTE3, 'N')
	  FROM	  FP_NETJOB_QUEUE A WITH(NOLOCK)
	  WHERE	  1=1
	  AND	  A.INSTANCE_DATE = @v_plan_date
	  AND	  A.PARAMETER4    = @v_site_id
	  AND     A.PROC_NAME     = @v_proc_name
	  AND	  A.ACTIVE_FLAG	  = 'Y'
	  AND	  A.JOB_SEQ		  = @v_job_seq
	  

	  SET @v_descr = 'INSTANCE_ID : ' + @v_master_id
	               + ' / FP_PLAN_ID : ' + @v_plan_id
	               + ' / DIVISION_ID : ' + @v_division_id
				   + ' / FACTORY_ID : ' + @v_factory_id
				   + ' / DESCRIPTION : ' + @v_description
				   + ' / USER_ID : ' + @v_user_id
				   + ' / MRP_FLAG : ' + @v_MRP_flag
				   + ' / JOB_SEQ : ' + CONVERT(NVARCHAR,@v_job_seq)
	  
	  SET @n_log_count = @n_log_count + 1
	  SET @sysdate = GETDATE()
	  EXEC PR_LOG_PROCESS @sysdate, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'SELECT', @n_log_count, NULL, @v_descr, null


	  IF @v_job_seq > 0 OR  @v_plan_id != '-' 
	  BEGIN
	  
		  ----------------------------------- 1. PR_SCM_FP_CALCURATION 시작 -----------------------------------
		  SET @v_amend_type = 'AMEND UI'

		  SELECT @v_amend_type = ISNULL(MAX(B.ATTRIBUTE1), 'AMEND UI')
		  FROM   SCM_SYS_LOOKUP_TYPE_M  A
			   , SCM_SYS_LOOKUP_VALUE   B
		  WHERE  A.LOOKUP_TYPE_CODE = 'INSTANCE AMEND UI'
		  AND    A.LOOKUP_TYPE_CODE = B.LOOKUP_TYPE_CODE
		  AND    B.SEGMENT1         = @v_master_id

		  --LOG 생성
		  SET @v_message = 'AMEND_TYPE : ' + @v_amend_type
		  SET @n_log_count = @n_log_count + 1
		  EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'SELECT', @n_log_count, @v_log_code, @v_message, null


		  -- CONFIRM_AREA 확인
		  SELECT @v_confirm_area  = A.ATTRIBUTE1
			   , @v_instance_type = A.ATTRIBUTE9
		  FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)
		  WHERE  A.LOOKUP_TYPE_CODE = 'INSTANCE_ID'
		  AND    A.ACTIVE_FLAG = 'Y'
		  AND    A.SEGMENT1 = @v_master_id


		  BEGIN
      
			SELECT @n_order_seq = ISNULL(MAX(ORDER_SEQ), 0)
			FROM   FP_RELEASE_CALCULATION_STATUS_H
			WHERE  ORDER_SEQ > 0
        
			MERGE INTO FP_RELEASE_CALCULATION_STATUS_H A
			USING (
					SELECT
						   @v_master_id     AS INSTANCE_ID
				  ) B
			ON    A.INSTANCE_ID   = B.INSTANCE_ID
			WHEN  MATCHED THEN
				  UPDATE  SET CALCULATION_STATUS  = 'WAIT'
							, ORDER_SEQ           = @n_order_seq + 1
							, EVENT_TIME          = GETDATE()
							, CALCULATION_START   = NULL
							, CALCULATION_END     = NULL
			WHEN  NOT MATCHED THEN
				  INSERT ( INSTANCE_ID, CALCULATION_STATUS, ORDER_SEQ, EVENT_TIME )
				  VALUES ( @v_master_id, 'WAIT', @n_order_seq + 1, GETDATE() )
			;
      
		  END

		  WHILE 1=1
		  BEGIN
      
			SELECT TOP 1
				   @v_run_master_id       = A.INSTANCE_ID
				 , @v_run_event_time      = A.EVENT_TIME
			FROM   FP_RELEASE_CALCULATION_STATUS_H A WITH(NOLOCK)
			WHERE  ORDER_SEQ > 0
			ORDER  BY ORDER_SEQ, INSTANCE_ID
        
			IF    @v_run_master_id      = @v_master_id
			  BREAK

			IF DATEDIFF(SECOND, @v_run_event_time, GETDATE()) > 300
			BEGIN

			  UPDATE A
			  SET    A.CALCULATION_STATUS = 'ERROR'
				   , A.ORDER_SEQ          = 0
				   , A.EVENT_TIME         = GETDATE()
			  FROM   FP_RELEASE_CALCULATION_STATUS_H A
			  WHERE  A.INSTANCE_ID        = @v_run_master_id
			  AND    A.ORDER_SEQ          > 0
			  AND    DATEDIFF(SECOND, A.EVENT_TIME, GETDATE()) > 300    -- 5분 이상 차이가 나면 다음 STEP 이 돌도록 설정
          
			END

			WAITFOR DELAY '0:0:1'
            
		  END

		  UPDATE FP_RELEASE_CALCULATION_STATUS_H
		  SET    CALCULATION_STATUS = 'RUN'
			   , EVENT_TIME         = GETDATE()
			   , CALCULATION_START  = GETDATE()
		  WHERE  INSTANCE_ID        = @v_master_id

      
		  --------------------------------------------------------------------------
		  -- WPP / MPP 프로시저 실행
		  --------------------------------------------------------------------------
		  BEGIN
      
			IF    CHARINDEX('CELL', @v_master_id) > 0
			  OR  CHARINDEX('PACK', @v_master_id) > 0
			  OR  CHARINDEX('LINK', @v_master_id) > 0  -- 2026/06/08 kimcd [PJ2026-50273] MI ESS LINK 공장 SCM(SCP/FP/PSCM ) 대응. Pack 공정군 로직에 LINK 공정군 추가  
			BEGIN
        
			  EXEC dbo.PR_SCM_FP_WPPMPP_REBUILD_LINE    @v_master_id, @v_plan_id
        
			END
        
			IF    CHARINDEX('E_PRE',  @v_master_id) > 0
			  --OR  CHARINDEX('E_PMIX', @v_master_id) > 0
			BEGIN
        
			  EXEC dbo.PR_SCM_FP_WPPMPP_REBUILD_ELEC    @v_master_id, @v_plan_id
          
			END
      
			IF    CHARINDEX('E_POST',  @v_master_id) > 0	--@@@ 후공정 추가 
			BEGIN
				EXEC dbo.PR_SCM_FP_REBUILD_POST    @v_master_id, @v_plan_id
			END
        
		  END
      

		  --------------------------------------------------------------------------
		  -- CALCULATION 프로시저 실행
		  --------------------------------------------------------------------------
		  IF @v_amend_type = 'PSI AMEND UI'
			BEGIN

			  -- 2018.05.15 : 사용자가 시뮬레이션 버튼을 안해서, 여기서 진행하도록 함
			  IF CHARINDEX('FORM', @v_master_id) > 0 AND @v_master_id <> 'CN_FORM_T'
				EXEC dbo.PR_SCM_OF_PSI_AMEND_UI_CALCULATION_FORM    @v_master_id, @v_plan_id , 'Y'
          
			  ELSE
				EXEC dbo.PR_SCM_OF_PSI_AMEND_UI_CALCULATION         @v_master_id, @v_plan_id, 'Y'
        
			END
          
		  UPDATE FP_RELEASE_CALCULATION_STATUS_H
		  SET    CALCULATION_STATUS = 'END'
			   , ORDER_SEQ          = 0
			   , EVENT_TIME         = GETDATE()
			   , CALCULATION_END    = GETDATE()
		  WHERE  INSTANCE_ID    = @v_master_id

		  ----------------------------------- PR_SCM_FP_CALCURATION 종료 -----------------------------------

		  ----------------------------------- 2. plan detail 테이블 update 시작 -----------------------------------

			IF @v_confirm_area = 'BUILDING'
			BEGIN
					MERGE INTO SCM_FP_PLAN_DETAIL_H AS A
					USING (SELECT @v_plan_date AS PLAN_DATE, @v_master_id AS INSTANCE_ID
								, @v_division_id AS DIVISION_ID, @v_factory_id AS FACTORY_ID) AS B
					ON (A.PLAN_DATE   = B.PLAN_DATE
					AND A.INSTANCE_ID = B.INSTANCE_ID
					AND A.DIVISION_ID = B.DIVISION_ID
					AND A.FACTORY_ID  = B.FACTORY_ID)
					WHEN MATCHED THEN
					UPDATE SET
						 PLAN_ID      = @v_plan_id
						,CONFIRM_ID   = @v_user_id
						,CONFIRM_TIME = dbo.FN_SITE_TIME(@v_site_id)
						,CONFIRM_FLAG = 'P'
						,RELEASE_TIME = NULL
						,RELEASE_FLAG = 'N'
						,RELEASE_PLAN_ID = NULL
						,MES_TRANSFER_FLAG = 'N'
						,MES_TRANSFER_TIME = NULL
						,UPDATE_ID    = @v_user_id
						,UPDATE_TIME  = DBO.FN_SITE_TIME(@v_site_id)
					WHEN NOT MATCHED THEN
					INSERT (
						PLAN_DATE
						,INSTANCE_ID
						,DIVISION_ID
						,FACTORY_ID
						,PLAN_ID
						,CONFIRM_ID
						,CONFIRM_TIME
						,CONFIRM_FLAG
						,DESCRIPTION
						,INSERT_ID, INSERT_TIME, UPDATE_ID, UPDATE_TIME
					) VALUES (
						@v_plan_date
						,@v_master_id
						,@v_division_id
						,@v_factory_id
						,@v_plan_id
						,@v_user_id
						,dbo.FN_SITE_TIME(@v_site_id)
						,'P'
						,@v_description
						,@v_user_id, dbo.FN_SITE_TIME(@v_site_id), @v_user_id, dbo.FN_SITE_TIME(@v_site_id)
					)
					;

					MERGE INTO HIS_FP_PLAN_DETAIL_H AS A
					USING (SELECT @v_plan_date AS PLAN_DATE, @v_master_id AS INSTANCE_ID
								, @v_division_id AS DIVISION_ID, @v_factory_id AS FACTORY_ID, @v_plan_id AS PLAN_ID) AS B
					ON (A.PLAN_DATE   = B.PLAN_DATE
					AND A.INSTANCE_ID = B.INSTANCE_ID
					AND A.DIVISION_ID = B.DIVISION_ID
					AND A.FACTORY_ID  = B.FACTORY_ID
					AND A.PLAN_ID     = B.PLAN_ID)
					WHEN MATCHED THEN
					UPDATE SET
						PLAN_ID      = @v_plan_id
						,CONFIRM_ID   = @v_user_id
						,CONFIRM_TIME = dbo.FN_SITE_TIME(@v_site_id)
						,CONFIRM_FLAG = 'Y'
						,RELEASE_TIME = NULL
						,RELEASE_FLAG = 'N'
						,RELEASE_PLAN_ID = NULL
						,MES_TRANSFER_FLAG = 'N'
						,MES_TRANSFER_TIME = NULL
						,UPDATE_ID    = @v_user_id
						,UPDATE_TIME  = DBO.FN_SITE_TIME(@v_site_id)
					WHEN NOT MATCHED THEN
					INSERT (
						PLAN_DATE
						,INSTANCE_ID
						,DIVISION_ID
						,FACTORY_ID
						,PLAN_ID
						,CONFIRM_ID
						,CONFIRM_TIME
						,CONFIRM_FLAG
						,RELEASE_TIME
						,RELEASE_FLAG
						,RELEASE_PLAN_ID
						,DESCRIPTION
						,MES_TRANSFER_FLAG
						,MES_TRANSFER_TIME
						,INSERT_ID, INSERT_TIME, UPDATE_ID, UPDATE_TIME
						,JOB_USER_ID, JOB_TIME, JOB_TYPE
					) VALUES (
						@v_plan_date
						,@v_master_id
						,@v_division_id
						,@v_factory_id
						,@v_plan_id
						,@v_user_id
						,dbo.FN_SITE_TIME(@v_site_id)
						,'Y'
						,NULL
						,'N'
						,NULL
						,@v_description
						,'N'
						,NULL
						,@v_user_id, dbo.FN_SITE_TIME(@v_site_id), @v_user_id, dbo.FN_SITE_TIME(@v_site_id)
						,@v_user_id, dbo.FN_SITE_TIME(@v_site_id), 'CONFIRM'
					)
					;

					--LOG 생성
					SET @v_message = 'Plan Detail'
					SET @n_log_count = @n_log_count + 1
					EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, 'SCM_FP_PLAN_DETAIL_H', 'UPDATE', @n_log_count, @v_log_code, @v_message, null

			END	
			ELSE
			BEGIN
				  MERGE INTO SCM_FP_PLAN_GROUP_DETAIL_H AS A
				  USING (SELECT @v_plan_date AS PLAN_DATE, @v_master_id AS INSTANCE_ID
							  , @v_division_id AS DIVISION_ID, @v_factory_id AS FACTORY_ID) AS B
					ON (A.PLAN_DATE   = B.PLAN_DATE
					AND A.INSTANCE_ID = B.INSTANCE_ID
					AND A.PLAN_GROUP_ID  = B.FACTORY_ID)
				  WHEN MATCHED THEN
					UPDATE SET
					  PLAN_ID      = @v_plan_id
					 ,CONFIRM_ID   = @v_user_id
					 ,CONFIRM_TIME = dbo.FN_SITE_TIME(@v_site_id)
					 ,CONFIRM_FLAG = 'P'
					 ,RELEASE_TIME = NULL
					 ,RELEASE_FLAG = 'N'
					 ,RELEASE_PLAN_ID = NULL
					 ,MES_TRANSFER_FLAG = 'N'
					 ,MES_TRANSFER_TIME = NULL
					 ,UPDATE_ID    = @v_user_id
					 ,UPDATE_TIME  = DBO.FN_SITE_TIME(@v_site_id)
				  WHEN NOT MATCHED THEN
					INSERT (
					   PLAN_DATE
					  ,INSTANCE_ID
					  ,PLAN_GROUP_ID
					  ,PLAN_ID
					  ,CONFIRM_ID
					  ,CONFIRM_TIME
					  ,CONFIRM_FLAG
					  ,DESCRIPTION
					  ,INSERT_ID, INSERT_TIME, UPDATE_ID, UPDATE_TIME
					) VALUES (
					   @v_plan_date
					  ,@v_master_id
					  ,@v_factory_id
					  ,@v_plan_id
					  ,@v_user_id
					  ,dbo.FN_SITE_TIME(@v_site_id)
					  ,'P'
					  ,@v_description
					  ,@v_user_id, dbo.FN_SITE_TIME(@v_site_id), @v_user_id, dbo.FN_SITE_TIME(@v_site_id)
					)
					;

				  MERGE INTO HIS_FP_PLAN_GROUP_DETAIL_H AS A
				  USING (SELECT @v_plan_date AS PLAN_DATE, @v_master_id AS INSTANCE_ID
							  , @v_factory_id AS PLAN_GROUP_ID, @v_plan_id AS PLAN_ID) AS B
					ON (A.PLAN_DATE     = B.PLAN_DATE
					AND A.INSTANCE_ID   = B.INSTANCE_ID
					AND A.PLAN_GROUP_ID = B.PLAN_GROUP_ID
					AND A.PLAN_ID       = B.PLAN_ID)
				  WHEN MATCHED THEN
					UPDATE SET
					  PLAN_ID      = @v_plan_id
					 ,CONFIRM_ID   = @v_user_id
					 ,CONFIRM_TIME = dbo.FN_SITE_TIME(@v_site_id)
					 ,CONFIRM_FLAG = 'Y'
					 ,RELEASE_TIME = NULL
					 ,RELEASE_FLAG = 'N'
					 ,RELEASE_PLAN_ID = NULL
					 ,MES_TRANSFER_FLAG = 'N'
					 ,MES_TRANSFER_TIME = NULL
					 ,UPDATE_ID    = @v_user_id
					 ,UPDATE_TIME  = DBO.FN_SITE_TIME(@v_site_id)
				  WHEN NOT MATCHED THEN
					INSERT (
					   PLAN_DATE
					  ,INSTANCE_ID
					  ,PLAN_GROUP_ID
					  ,PLAN_ID
					  ,CONFIRM_ID
					  ,CONFIRM_TIME
					  ,CONFIRM_FLAG
					  ,RELEASE_TIME
					  ,RELEASE_FLAG
					  ,RELEASE_PLAN_ID
					  ,DESCRIPTION
					  ,MES_TRANSFER_FLAG
					  ,MES_TRANSFER_TIME
					  ,INSERT_ID, INSERT_TIME, UPDATE_ID, UPDATE_TIME
					  ,JOB_USER_ID, JOB_TIME, JOB_TYPE
					) VALUES (
					   @v_plan_date
					  ,@v_master_id
					  ,@v_factory_id
					  ,@v_plan_id
					  ,@v_user_id
					  ,dbo.FN_SITE_TIME(@v_site_id)
					  ,'Y'
					  ,NULL
					  ,'N'
					  ,NULL
					  ,@v_description
					  ,'N'
					  ,NULL
					  ,@v_user_id, dbo.FN_SITE_TIME(@v_site_id), @v_user_id, dbo.FN_SITE_TIME(@v_site_id)
					  ,@v_user_id, dbo.FN_SITE_TIME(@v_site_id), 'CONFIRM'
					)
				  ;

					--LOG 생성
					SET @v_message = 'Plan Group Detail'
					SET @n_log_count = @n_log_count + 1
					EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, 'SCM_FP_PLAN_GROUP_DETAIL_H', 'UPDATE', @n_log_count, @v_log_code, @v_message, null

			END

			UPDATE SCM_FP_PLAN_H SET
				   CONFIRM_FLAG = 'Y'
				 , CONFIRM_ID   = @v_user_id
				 , CONFIRM_TIME = dbo.FN_SITE_TIME(@v_site_id)
			WHERE  INSTANCE_ID  = @v_master_id
			AND    PLAN_ID      = @v_plan_id


			WAITFOR DELAY '0:0:2' -- 2초 db 내부저장시간용 버퍼시간

			----------------------------------- plan detail 테이블 update 종료 -----------------------------------


			----------------------------------- 3. 배포프로시저 시작 -----------------------------------
			EXEC PR_SCM_FP_CONFIRM_RELEASE @v_master_id, @v_plan_id, @v_factory_id, @v_user_id

			WAITFOR DELAY '0:0:2' -- 2초 db 내부저장시간용 버퍼시간
			----------------------------------- 3. 배포프로시저 종료 -----------------------------------


			----------------------------------- 4. 수량검증 메일 프로시저 시작 -----------------------------------
			IF @v_confirm_area = 'BUILDING'
				EXEC PR_SCM_PLAN_RESULT_SEND @v_master_id, @v_plan_date, @v_factory_id, NULL
			ELSE
				EXEC PR_SCM_PLAN_RESULT_SEND @v_master_id, @v_plan_date, NULL, @v_factory_id

			----------------------------------- 4. 수량검증 메일 프로시저 종료 -----------------------------------

			-- release plan id 조회
			IF @v_confirm_area = 'BUILDING'
			BEGIN
				SELECT @v_release_plan_id = RELEASE_PLAN_ID
				FROM   SCM_FP_PLAN_DETAIL_H A WITH(NOLOCK)
				WHERE  1=1
				AND    A.PLAN_DATE   = @v_plan_date
				AND    A.INSTANCE_ID = @v_master_id
				AND    A.FACTORY_ID  = @v_factory_id
				AND    A.PLAN_ID     = @v_plan_id

			END
			ELSE 
			BEGIN
				SELECT @v_release_plan_id = RELEASE_PLAN_ID
				FROM   SCM_FP_PLAN_GROUP_DETAIL_H A WITH(NOLOCK)
				WHERE  1=1
				AND    A.PLAN_DATE     = @v_plan_date
				AND    A.INSTANCE_ID   = @v_master_id
				AND    A.PLAN_GROUP_ID = @v_factory_id
				AND    A.PLAN_ID       = @v_plan_id

			END

			----------------------------------- 5. 수량검증 쿼리 시작 -----------------------------------
			SET @v_rowCount = 0

			IF @v_confirm_area = 'BUILDING'
			BEGIN
			  WITH TARGET_PLAN AS
			  (
                   SELECT INSTANCE_ID 
                       -- , INSTANCE_DATE 
			           , (CASE WHEN SLV2.AMEND_LIMIT_YN = 'Y' THEN SLV2.AMEND_LIMIT_DATE ELSE INSTANCE_DATE END) AS INSTANCE_DATE  -- release validation block 로직 추가... 20230622
			           , DIVISION_ID, FACTORY_ID, PLAN_GROUP_ID , RELEASE_PLAN_ID PLAN_ID, AMEND_PLAN_ID BASIS_PLAN_ID, SLV.ATTRIBUTE1 AS UI_TYPE 
			           , ROW_NUMBER() OVER ( PARTITION BY INSTANCE_ID, INSTANCE_DATE, DIVISION_ID, FACTORY_ID, PLAN_GROUP_ID  ORDER BY INSERT_TIME DESC ) NUMS 
                       , SLV2.AMEND_LIMIT_YN, SLV2.AMEND_LIMIT_DATE  -- release validation block 로직 추가... 20230622
			       FROM   FP_RELEASE_PLAN_INFO_H H WITH(NOLOCK)    
				   -- release validation block 로직 추가... 20230622
			       LEFT OUTER JOIN (
			 			SELECT SLV2.SEGMENT1 AS REL_INST, SLV2.SEGMENT2 AS REL_FACT 
			 				 , SLV2.ATTRIBUTE7 AS AMEND_LIMIT_YN, SLV2.ATTRIBUTE8 AS AMEND_LIMIT_DATE 
			 			FROM   SCM_SYS_LOOKUP_VALUE  SLV2 WITH(NOLOCK) 
			 			WHERE  1=1 
			 			AND    SLV2.LOOKUP_TYPE_CODE = 'INSTANCE_FACTORY_RELEASE_TERM' 
			 			AND    SLV2.ACTIVE_FLAG = 'Y' 
			 			AND    SLV2.SEGMENT1 = @v_master_id
						AND    SLV2.SEGMENT2 = @v_factory_id
			       ) SLV2 
			       ON  1=1 
			       AND H.INSTANCE_ID = SLV2.REL_INST 
			       AND H.FACTORY_ID  = SLV2.REL_FACT 
						, SCM_SYS_LOOKUP_VALUE  SLV WITH(NOLOCK)
				   WHERE  INSTANCE_ID   = @v_master_id
				   AND    INSTANCE_DATE = @v_plan_date
				   AND    FACTORY_ID    = @v_factory_id
      			   AND    SLV.LOOKUP_TYPE_CODE = 'INSTANCE AMEND UI'
      			   AND    SLV.SEGMENT1  = H.INSTANCE_ID
			  )
			  SELECT @v_rowCount = COUNT(*)
			  FROM (
				  SELECT PLANT_ID, FACTORY_ID, OPERATION_ID, ITEM_ID, MAKE_DATE, PLAN_ID
					   , SUM(case when groups = 'ERP' then make_qty else 0 end) 'ERP'
					   , SUM(case when groups = 'MES' then make_qty else 0 end)  'MES' 
					   , SUM(case when groups = 'RELEASE' then make_qty else 0 end ) 'RELEASE'
					   , SUM(case when groups = 'AMEND' then make_qty else 0 end ) 'AMEND'
					   , SUM(case when groups = 'PLAN_EQUIPMENT_R' then make_qty else 0 end ) 'PLAN_EQUIPMENT_R'
					   , CASE WHEN  SUM(case when groups = 'AMEND' then make_qty else 0 end ) <> SUM(case when groups = 'RELEASE' then make_qty else 0 end ) THEN 'NG_RELEASE' ELSE '' END CHK1_RELEASE
					   , CASE WHEN  SUM(case when groups = 'RELEASE' then make_qty else 0 end ) <> SUM(case when groups = 'MES' then make_qty else 0 end) THEN 'NG_MES' ELSE '' END CHK2_MES
					   , CASE WHEN  SUM(case when groups = 'MES' then make_qty else 0 end) <> SUM(case when groups = 'ERP' then make_qty else 0 end) THEN 'NG_ERP' ELSE '' END CHK3_ERP
				  from (
						  select max(groups) as groups, plant_id, factory_id, operation_id, item_id, make_date, sum(make_qty) as make_qty, plan_id
						  from  ( select 'ERP' groups , plant_id, a.factory_id, OPERATION_ID, item_id,SUBSTRING(a.plan_date,1,8) make_date
									  , FP_PLAN_QTY AS MAKE_QTY
									  , A.FP_PLAN_ID AS PLAN_ID
								 FROM   SY_XIF_ERP_PRODUCTION_PLAN_S A  WITH(NOLOCK)
									   ,TARGET_PLAN  PLANS  WITH(NOLOCK)
								 WHERE  FP_PLAN_ID = PLANS.PLAN_ID
								 AND    PLANS.NUMS = 1
      						AND   (A.TOP_BACK_IND = 'B' OR A.TOP_BACK_IND IS NULL)
      						AND    A.FIX_TYPE = 'Y'
						  UNION ALL
      						  SELECT 'ERP' AS GROUPS, A.PLANT_ID, A.FACTORY_ID, A.OPERATION_ID, A.ITEM_ID, CONVERT( VARCHAR, A.PLAN_DATE, 112) , A.PLAN_QTY
									  , A.FP_PLAN_ID AS PLAN_ID
      						FROM   [DBO].[FP_PRODUCTION_PLAN_EQUIPMENT_R] A WITH(NOLOCK)
      							  ,TARGET_PLAN  PLANS  WITH(NOLOCK)
      						WHERE A.FP_PLAN_ID = PLANS.PLAN_ID
      						AND  FIX_TYPE   IN ('F','N')
      						AND  ORDER_TYPE IN ('W')
      						AND PLANS.NUMS = 1
      						AND  NOT EXISTS ( SELECT 1
										  FROM   [dbo].[SY_XIF_ERP_PRODUCTION_PLAN_S] XEP WITH(NOLOCK)
              											WHERE  XEP.FP_PLAN_ID = A.FP_PLAN_ID
              											AND    XEP.WORK_ORDER_ID = A.WORK_ORDER_ID )
      						) PLANSS
						  group by plant_id, factory_id, OPERATION_ID, item_id,make_date, plan_id
						UNION ALL
						  select max(groups) as groups, plant_id, factory_id, OPERATION_ID, item_id, make_date, sum(make_qty) as make_qty, plan_id
						  from  ( select 'MES' as groups
                                         , F.PLANT_ID -- 2024-04-08 NERP PLANT_ID 변경에 따른 CONVERSION 반영
                                         , a.builno factory_id
                                         , OPERATION_ID
                                         , item_id
                                         , replace( SUBSTRING(a.plan_date,1,10) ,'-','') make_date
									   ,CAST(ATTR_08 AS NUMERIC) AS MAKE_QTY
									   ,a.PLAN_ID
								 from   SY_XIF_MES_WO_S a  with(nolock)
                                INNER   JOIN SCM_FACTORY_M F WITH(NOLOCK)
                                   ON   F.FACTORY_ID = a.BUILNO  -- 2024-04-08 NERP PLANT_ID 변경에 따른 CONVERSION 반영
									   ,target_plan  plans  with(nolock)
								 where a.plan_id  = plans.plan_id
								 and   plans.nums = 1
                					 and   (a.attr_05 = 'B' or a.attr_05 is null)
                					 AND   A.IS_RELEASE = 'Y'
								 and   if_id <> 'OFP0_OPLM_FP_WO' 
							UNION ALL
        						   SELECT 'MES' AS GROUPS, A.PLANT_ID, A.FACTORY_ID, A.OPERATION_ID, A.ITEM_ID, CONVERT( VARCHAR, A.PLAN_DATE, 112) , A.PLAN_QTY
										, A.FP_PLAN_ID AS PLAN_ID
        						   FROM   [DBO].[FP_PRODUCTION_PLAN_EQUIPMENT_R] A WITH(NOLOCK)
        								, TARGET_PLAN  PLANS  WITH(NOLOCK)
        						   WHERE A.FP_PLAN_ID = PLANS.PLAN_ID
        						   AND  FIX_TYPE   IN ('F','N')
        						   AND  PLANS.NUMS = 1
        						   AND  NOT EXISTS ( SELECT 1
        											 FROM   [dbo].[SY_XIF_MES_WO_S] XMW WITH(NOLOCK)
        											 WHERE  XMW.PLAN_ID   = A.FP_PLAN_ID
        											 AND    XMW.WO        = A.WORK_ORDER_ID
        											 AND    XMW.WO_DETAIL = A.WORK_ORDER_SPL_ID )
      						) planss
						  group by plant_id, factory_id, OPERATION_ID, item_id, make_date, plan_id
						UNION ALL
						select 'AMEND' as groups, ( select f.plant_id from dbo.scm_factory_m f where f.factory_id = w.after_site_id ) as PLANT_ID
								,after_site_id as FACTORY_ID, after_operation_id, ITEM_ID, after_plan_date make_date , CEILING(sum(after_qty)) make_qty
      							  ,plans.plan_id
						  FROM  [dbo].[FP_AMEND_PRODUCTION_PLAN_R] w with(nolock)
      						   ,target_plan plans
							   ,( select DEMAND_ID, MIN(AFTER_PLAN_DATE) AS PLAN_DATE
								  FROM   [dbo].[FP_AMEND_PRODUCTION_PLAN_R] w with(nolock)
										,target_plan plans
								  where master_id = plans.instance_id
								  and  w.plan_id = plans.basis_plan_id
      								AND  w.after_in_qty > 0
								  and  plans.nums = 1
                					  AND  PLANS.UI_TYPE = 'AMEND UI'
                					  AND  W.AFTER_SITE_ID = plans.factory_id
								  group by DEMAND_ID
								  ) x
						  where master_id = plans.instance_id
						  and  w.plan_id = plans.basis_plan_id
						  AND  PLANS.UI_TYPE = 'AMEND UI'
						  and  w.demand_id = x.demand_id
      						AND  W.AFTER_SITE_ID = plans.factory_id
						  --and  PLAN_DATE <= dateadd(dd,(SELECT CONVERT(NUMERIC(5), SLV.SEGMENT3)
						  AND  PLAN_DATE <= dateadd(dd,( SELECT (CASE WHEN SLV.ATTRIBUTE7 = 'Y' THEN 0 ELSE CONVERT(NUMERIC(5), SLV.SEGMENT3) END) AS INSTANCE_DATE  -- release validation block 로직 추가... 20230622
      											 FROM   DBO.SCM_SYS_LOOKUP_VALUE  SLV WITH(NOLOCK)
      											 WHERE  SLV.LOOKUP_TYPE_CODE = 'INSTANCE_FACTORY_RELEASE_TERM'
      											 AND    SLV.ACTIVE_FLAG = 'Y'
      											 AND    SLV.SEGMENT1 = plans.INSTANCE_ID
      											 AND    SLV.SEGMENT2 = plans.factory_id), convert(datetime,plans.instance_date) )
						  and  plans.nums = 1
						  and  exists (
										  select 1
										  from   FP_INSTANCE_CONFIG_M k
										  where  k.instance_id = w.master_id
										  AND    k.CATEGORY_ID  = 'PLAN_CATEGORY'
										  AND    k.KEY_ID       = 'CELL_HARD_PEGGING'
										  AND    k.KEY_VALUE    = 'Y'
									  )
						  group by after_site_id, after_operation_id, ITEM_ID, after_plan_date, plans.plan_id
						UNION ALL
						  select 'AMEND' as groups, ( select f.plant_id from dbo.scm_factory_m f WITH(NOLOCK) where f.factory_id = w.after_site_id ) as PLANT_ID
								  ,after_site_id as FACTORY_ID, after_operation_id, ITEM_ID, after_plan_date make_date , CEILING(sum(after_qty)) make_qty
      								,plans.plan_id
						  FROM  [dbo].[FP_AMEND_PRODUCTION_PLAN_R] w with(nolock)
      							  ,target_plan  plans  with(nolock)
						  where master_id = plans.instance_id
						  and   w.plan_id = plans.basis_plan_id
						  AND   PLANS.UI_TYPE = 'AMEND UI'
      						AND  W.AFTER_SITE_ID = plans.factory_id
						  and  plans.nums = 1
						  and  w.after_in_qty > 0
						  --and  after_plan_date <= dateadd(dd,(SELECT CONVERT(NUMERIC(5), SLV.SEGMENT3)
						  AND  after_plan_date <= dateadd( dd,( SELECT (CASE WHEN SLV.ATTRIBUTE7 = 'Y' THEN 0 ELSE CONVERT(NUMERIC(5), SLV.SEGMENT3) END) AS INSTANCE_DATE  -- release validation block 로직 추가... 20230622
      												FROM   DBO.SCM_SYS_LOOKUP_VALUE  SLV WITH(NOLOCK)
      												WHERE  SLV.LOOKUP_TYPE_CODE = 'INSTANCE_FACTORY_RELEASE_TERM'
      												AND    SLV.ACTIVE_FLAG = 'Y'
      												AND    SLV.SEGMENT1 = plans.INSTANCE_ID
      												AND    SLV.SEGMENT2 = plans.factory_id), convert(datetime,plans.instance_date) )
						  and  not exists (
										  select 1
										  from   FP_INSTANCE_CONFIG_M k
										  where  k.instance_id = w.master_id
										  AND    k.CATEGORY_ID  = 'PLAN_CATEGORY'
										  AND    k.KEY_ID       = 'CELL_HARD_PEGGING'
										  AND    k.KEY_VALUE    = 'Y'
									  )
						  group by after_site_id, after_operation_id, ITEM_ID, after_plan_date, plans.plan_id
						UNION ALL
						  select 'AMEND' as groups, MAX(W.PLANT_ID) AS PLANT_ID
								  ,W.FACTORY_ID as FACTORY_ID, W.operation_id, W.ITEM_ID, PLAN_DATE make_date , CEILING(sum(OUT_QTY)) make_qty
      								,plans.plan_id
						  FROM  [dbo].[FP_AMEND_PLAN_R] w with(nolock)
      							 ,target_plan  plans  with(nolock)
						  where w.instance_id = plans.instance_id
						  and   w.fp_plan_id  = plans.basis_plan_id
						  AND   PLANS.UI_TYPE = 'PSI AMEND UI'
      						AND   W.factory_id = plans.factory_id
						  and   plans.nums = 1
						  and   in_qty > 0
						  --and  plan_date <= dateadd(dd,(SELECT CONVERT(NUMERIC(5), SLV.SEGMENT3)
						  AND  plan_date <= dateadd(dd,(SELECT (CASE WHEN SLV.ATTRIBUTE7 = 'Y' THEN 0 ELSE CONVERT(NUMERIC(5), SLV.SEGMENT3) END) AS INSTANCE_DATE -- release validation block 로직 추가... 20230622
      											FROM   DBO.SCM_SYS_LOOKUP_VALUE  SLV WITH(NOLOCK)
      											WHERE  SLV.LOOKUP_TYPE_CODE = 'INSTANCE_FACTORY_RELEASE_TERM'
      											AND    SLV.ACTIVE_FLAG = 'Y'
      											AND    SLV.SEGMENT1 = plans.INSTANCE_ID
      											AND    SLV.SEGMENT2 = plans.FACTORY_ID), convert(datetime,plans.instance_date) )
						  group by W.FACTORY_ID, operation_id, ITEM_ID, plan_date, plans.plan_id
						UNION ALL
						  SELECT 'RELEASE', ( select f.plant_id from scm_factory_m f  with(nolock) where f.factory_id = w.FACTORY_ID ) as PLANT_ID
								, W.FACTORY_ID , W.OPERATION_ID , W.ITEM_ID , CONVERT(VARCHAR, W.PLAN_DATE,112) AS PLAN_DATE , CEILING(sum(PLAN_QTY)) make_qty
								,plans.plan_id
						  FROM   FP_RELEASE_FIX_PLAN_H  W  with(nolock)
								,target_plan  plans  with(nolock)
						  where W.INSTANCE_ID     = plans.instance_id
						  and   w.AMEND_PLAN_ID   = plans.basis_plan_id
						  and   w.RELEASE_PLAN_ID = plans.PLAN_ID
						  and   plans.nums        = 1
						  group by W.FACTORY_ID, W.operation_id, W.ITEM_ID, W.plan_date, plans.plan_id
						UNION ALL
						  select 'PLAN_EQUIPMENT_R', a.PLANT_ID, a.FACTORY_ID, a.OPERATION_ID, a.ITEM_ID, convert( varchar, a.PLAN_DATE, 112), sum( a.plan_qty)
								,plans.plan_id
						  from   dbo.FP_PRODUCTION_PLAN_EQUIPMENT_R a  with(nolock)
								,target_plan plans with(nolock)
						  where a.FP_PLAN_ID = plans.plan_id
						  and   FIX_TYPE   IN ('F','N')
						  and   ORDER_TYPE IN ('W','M')
						  group by a.PLANT_ID, a.FACTORY_ID, a.OPERATION_ID, a.ITEM_ID, convert( varchar, a.PLAN_DATE, 112),plans.plan_id
				  ) A
				  --WHERE  OPERATION_ID != 'A6000'
				  GROUP BY PLANT_ID, FACTORY_ID, OPERATION_ID, ITEM_ID, MAKE_DATE, PLAN_ID
				  HAVING ( ABS(SUM(CASE WHEN GROUPS = 'AMEND' THEN MAKE_QTY ELSE 0 END ) - SUM(CASE WHEN GROUPS = 'RELEASE' THEN MAKE_QTY ELSE 0 END ))/( CASE WHEN SUM(CASE WHEN GROUPS = 'AMEND' THEN MAKE_QTY ELSE 0 END ) = 0 THEN 1 ELSE SUM(CASE WHEN GROUPS = 'AMEND' THEN MAKE_QTY ELSE 0 END ) END) > 0.0015
					  OR ABS(SUM(CASE WHEN GROUPS = 'AMEND' THEN MAKE_QTY ELSE 0 END ) - SUM(CASE WHEN GROUPS = 'MES' THEN MAKE_QTY ELSE 0 END ))/( CASE WHEN SUM(CASE WHEN GROUPS = 'AMEND' THEN MAKE_QTY ELSE 0 END ) = 0 THEN 1 ELSE SUM(CASE WHEN GROUPS = 'AMEND' THEN MAKE_QTY ELSE 0 END ) END) > 0.0015 )
				  AND ( ABS(SUM(CASE WHEN GROUPS = 'AMEND' THEN MAKE_QTY ELSE 0 END ) - SUM(CASE WHEN GROUPS = 'RELEASE' THEN MAKE_QTY ELSE 0 END )) > 1
					  OR ABS(SUM(CASE WHEN GROUPS = 'AMEND' THEN MAKE_QTY ELSE 0 END ) - SUM(CASE WHEN GROUPS = 'MES' THEN MAKE_QTY ELSE 0 END ))> 1 )
				  UNION
				  SELECT PLANT_ID, FACTORY_ID, OPERATION_ID, ITEM_ID, SUBSTRING(Z.PLAN_DATE,1,8), FP_PLAN_ID
							   , 0 'ERP'
							   , 0  'MES' 
							   , 0 'RELEASE'
							   , 0 'AMEND'
							   , count(distinct batch_id) 'PLAN_EQUIPMENT_R'
							   , z.batch_order_id CHK1_RELEASE
							   , 'NG_BATCH_ORDER_ID' CHK2_MES
							   , 'NG_BATCH_ORDER_ID' CHK3_ERP
				  FROM (
						  SELECT ISNULL((SELECT  B.BATCH_ID 
										 FROM    SCM_BATCH_M B
										 WHERE   B.PLANT_ID = A.PLANT_ID
										 AND     B.ITEM_ID = A.ITEM_ID), ITEM_ID) AS BATCH_ID , A.*
						  FROM   SY_XIF_ERP_PRODUCTION_PLAN_S A WITH(NOLOCK)
							   , TARGET_PLAN PLANS WITH(NOLOCK)
						  WHERE A.FP_PLAN_ID = PLANS.PLAN_ID
						  AND   BATCH_ORDER_ID <> '-'
					   ) z
				  GROUP BY Z.PLANT_ID, Z.FACTORY_ID, Z.OPERATION_ID, Z.ITEM_ID, SUBSTRING(Z.PLAN_DATE,1,8), FP_PLAN_ID, BATCH_ORDER_ID
				  HAVING COUNT(DISTINCT z.BATCH_ID) > 1
				) A
		  
			  --LOG 생성
			  SET @v_message = 'Validation 1 - Factory: ' + CONVERT(VARCHAR,@v_rowCount)
			  SET @n_log_count = @n_log_count + 1
			  EXECUTE pr_log_process  null, @v_master_id, @v_release_plan_id, @v_proc_name, @v_table_name, 'SELECT', @n_log_count, @v_log_code, @v_message, null

			END
			ELSE 
			BEGIN
			
			  WITH TARGET_PLAN AS
			  (
				   --SELECT INSTANCE_ID, INSTANCE_DATE, DIVISION_ID, FACTORY_ID, PLAN_GROUP_ID , RELEASE_PLAN_ID PLAN_ID, AMEND_PLAN_ID BASIS_PLAN_ID, SLV.ATTRIBUTE1 AS UI_TYPE
				   SELECT INSTANCE_ID
				   , (CASE WHEN SLV2.AMEND_LIMIT_YN = 'Y' THEN SLV2.AMEND_LIMIT_DATE ELSE INSTANCE_DATE END) AS INSTANCE_DATE -- release validation block 로직 추가... 20230622
				   , DIVISION_ID, FACTORY_ID, PLAN_GROUP_ID , RELEASE_PLAN_ID PLAN_ID, AMEND_PLAN_ID BASIS_PLAN_ID, SLV.ATTRIBUTE1 AS UI_TYPE 
						, ROW_NUMBER() OVER ( PARTITION BY INSTANCE_ID, INSTANCE_DATE, DIVISION_ID, FACTORY_ID, PLAN_GROUP_ID  ORDER BY INSERT_TIME DESC ) NUMS
                        , SLV2.AMEND_LIMIT_YN, SLV2.AMEND_LIMIT_DATE -- release validation block 로직 추가... 20230622
				   FROM   FP_RELEASE_PLAN_INFO_H H WITH(NOLOCK)
					-- release validation block 로직 추가... 20230622
				   LEFT OUTER JOIN ( 
             			SELECT SLV2.SEGMENT1 AS REL_INST, SLV2.SEGMENT2 AS REL_FACT 
             			     , SLV2.ATTRIBUTE7 AS AMEND_LIMIT_YN, SLV2.ATTRIBUTE8 AS AMEND_LIMIT_DATE 
             			FROM   SCM_SYS_LOOKUP_VALUE  SLV2 WITH(NOLOCK) 
             			WHERE  1=1 
             			AND    SLV2.LOOKUP_TYPE_CODE = 'INSTANCE_PLANNING_GROUP'
             			AND    SLV2.ACTIVE_FLAG = 'Y'
             			AND    SLV2.SEGMENT1 = @v_master_id
						AND    SLV2.SEGMENT2 = @v_factory_id
				   ) SLV2 
				   ON  1=1 
				   AND H.INSTANCE_ID   = SLV2.REL_INST 
				   AND H.PLAN_GROUP_ID = SLV2.REL_FACT 
						, SCM_SYS_LOOKUP_VALUE  SLV WITH(NOLOCK)
				   WHERE  INSTANCE_ID   = @v_master_id
				   AND    INSTANCE_DATE = @v_plan_date
				   AND    PLAN_GROUP_ID = @v_factory_id
      			   AND    SLV.LOOKUP_TYPE_CODE = 'INSTANCE AMEND UI'
      			   AND    SLV.SEGMENT1 = H.INSTANCE_ID
			  )
			  SELECT @v_rowCount = COUNT(*)
			  FROM (
				  SELECT PLANT_ID, FACTORY_ID, OPERATION_ID, ITEM_ID, MAKE_DATE, PLAN_ID
					   , SUM(case when groups = 'ERP' then make_qty else 0 end) 'ERP'
					   , SUM(case when groups = 'MES' then make_qty else 0 end)  'MES' 
					   , SUM(case when groups = 'RELEASE' then make_qty else 0 end ) 'RELEASE'
					   , SUM(case when groups = 'AMEND' then make_qty else 0 end ) 'AMEND'
					   , SUM(case when groups = 'PLAN_EQUIPMENT_R' then make_qty else 0 end ) 'PLAN_EQUIPMENT_R'
					   , CASE WHEN  SUM(case when groups = 'AMEND' then make_qty else 0 end ) <> SUM(case when groups = 'RELEASE' then make_qty else 0 end ) THEN 'NG_RELEASE' ELSE '' END CHK1_RELEASE
					   , CASE WHEN  SUM(case when groups = 'RELEASE' then make_qty else 0 end ) <> SUM(case when groups = 'MES' then make_qty else 0 end) THEN 'NG_MES' ELSE '' END CHK2_MES
					   , CASE WHEN  SUM(case when groups = 'MES' then make_qty else 0 end) <> SUM(case when groups = 'ERP' then make_qty else 0 end) THEN 'NG_ERP' ELSE '' END CHK3_ERP
				  from (
						  select max(groups) as groups, plant_id, factory_id, operation_id, item_id, make_date, sum(make_qty) as make_qty, plan_id
						  from  ( select 'ERP' groups , plant_id, a.factory_id, OPERATION_ID, item_id,SUBSTRING(a.plan_date,1,8) make_date
									  , FP_PLAN_QTY AS MAKE_QTY
									  , A.FP_PLAN_ID AS PLAN_ID
								 FROM   SY_XIF_ERP_PRODUCTION_PLAN_S A  WITH(NOLOCK)
									   ,TARGET_PLAN  PLANS  WITH(NOLOCK)
								 WHERE  FP_PLAN_ID = PLANS.PLAN_ID
								 AND    PLANS.NUMS = 1
                				 AND   (A.TOP_BACK_IND = 'B' OR A.TOP_BACK_IND IS NULL)
                				 AND    A.FIX_TYPE = 'Y'
								 UNION ALL
          						 SELECT 'ERP' AS GROUPS, A.PLANT_ID, A.FACTORY_ID, A.OPERATION_ID, A.ITEM_ID, CONVERT( VARCHAR, A.PLAN_DATE, 112) , A.PLAN_QTY
									  , A.FP_PLAN_ID AS PLAN_ID
          						 FROM   [DBO].[FP_PRODUCTION_PLAN_EQUIPMENT_R] A WITH(NOLOCK)
          								,TARGET_PLAN  PLANS  WITH(NOLOCK)
          						 WHERE A.FP_PLAN_ID = PLANS.PLAN_ID
            					 AND   FIX_TYPE   IN ('F','N')
            					 AND   ORDER_TYPE IN ('W')
          						 AND   PLANS.NUMS = 1
          						 AND   NOT EXISTS ( SELECT 1
                    								FROM   [dbo].[SY_XIF_ERP_PRODUCTION_PLAN_S] XEP WITH(NOLOCK)
                    								WHERE  XEP.FP_PLAN_ID = A.FP_PLAN_ID
                    								AND    XEP.WORK_ORDER_ID = A.WORK_ORDER_ID )
      						) PLANSS
						  group by plant_id, factory_id, OPERATION_ID, item_id,make_date, plan_id
						UNION ALL
						  select max(groups) as groups, plant_id, factory_id, OPERATION_ID, item_id, make_date, sum(make_qty) as make_qty, plan_id
						  from  ( select 'MES' as groups
                                         , F.PLANT_ID -- 2024-04-08 NERP PLANT_ID 변경에 따른 CONVERSION 반영
                                         , a.builno factory_id
                                         , OPERATION_ID
                                         , item_id
                                         , replace( SUBSTRING(a.plan_date,1,10) ,'-','') make_date
									     ,CAST(ATTR_08 AS NUMERIC) AS MAKE_QTY
									     ,a.PLAN_ID
								 from   SY_XIF_MES_WO_S a  with(nolock)
                                INNER   JOIN SCM_FACTORY_M F WITH(NOLOCK)
                                   ON   F.FACTORY_ID = a.BUILNO  -- 2024-04-08 NERP PLANT_ID 변경에 따른 CONVERSION 반영
									   ,target_plan  plans  with(nolock)
								 where a.plan_id  = plans.plan_id
								 and   plans.nums = 1
                				 and   (a.attr_05 = 'B' or a.attr_05 is null)
                				 AND   A.IS_RELEASE = 'Y'
								 and   if_id <> 'OFP0_OPLM_FP_WO' 
							  UNION ALL
          							SELECT 'MES' AS GROUPS, A.PLANT_ID, A.FACTORY_ID, A.OPERATION_ID, A.ITEM_ID, CONVERT( VARCHAR, A.PLAN_DATE, 112) , A.PLAN_QTY
										  , A.FP_PLAN_ID AS PLAN_ID
          							FROM   [DBO].[FP_PRODUCTION_PLAN_EQUIPMENT_R] A WITH(NOLOCK)
          								  , TARGET_PLAN  PLANS  WITH(NOLOCK)
          							WHERE A.FP_PLAN_ID = PLANS.PLAN_ID
          							AND   FIX_TYPE   IN ('F','N')
          							AND   PLANS.NUMS = 1
          							AND   NOT EXISTS (  SELECT 1
                      									FROM   [dbo].[SY_XIF_MES_WO_S] XMW WITH(NOLOCK)
                      									WHERE  XMW.PLAN_ID   = A.FP_PLAN_ID
                      									AND    XMW.WO        = A.WORK_ORDER_ID
                      									AND    XMW.WO_DETAIL = A.WORK_ORDER_SPL_ID )
      						) planss
						  group by plant_id, factory_id, OPERATION_ID, item_id, make_date, plan_id
						UNION ALL
						  select 'AMEND' as groups, ( select f.plant_id from dbo.scm_factory_m f where f.factory_id = w.after_site_id ) as PLANT_ID
								,after_site_id as FACTORY_ID, after_operation_id, ITEM_ID, after_plan_date make_date , CEILING(sum(after_qty)) make_qty
      							  ,plans.plan_id
						  FROM  [dbo].[FP_AMEND_PRODUCTION_PLAN_R] w with(nolock)
      						   ,target_plan plans
							   ,( select DEMAND_ID, MIN(AFTER_PLAN_DATE) AS PLAN_DATE
								  FROM   [dbo].[FP_AMEND_PRODUCTION_PLAN_R] w with(nolock)
										,target_plan plans
								  where master_id = plans.instance_id
								  and  w.plan_id = plans.basis_plan_id
      							  AND  w.after_in_qty > 0
								  and  plans.nums = 1
                					  AND  PLANS.UI_TYPE = 'AMEND UI'
									  -- 비활성화 라인까지 체크 필요함(기존 계획 정리 차원)
                					  AND  EXISTS (SELECT 1 
                									FROM   SCM_LINE_M   SLM WITH(NOLOCK)
                									WHERE  SLM.FACTORY_ID   = W.AFTER_SITE_ID
                									AND    SLM.LINE_ID      = W.AFTER_ROUTE_ID
                									AND    SLM.OPERATION_ID = W.AFTER_OPERATION_ID
                									AND    ( SLM.MODEL_TYPE = plans.PLAN_GROUP_ID ))
										group by DEMAND_ID ) x
						  where master_id = plans.instance_id
						  and  w.plan_id = plans.basis_plan_id
						  AND  PLANS.UI_TYPE = 'AMEND UI'
						  and  w.demand_id = x.demand_id
						  -- 비활성화 라인까지 체크 필요함(기존 계획 정리 차원)
						  AND  EXISTS ( SELECT 1 
                    							FROM   SCM_LINE_M   SLM WITH(NOLOCK)
                    							WHERE  SLM.FACTORY_ID   = W.AFTER_SITE_ID
                    							AND    SLM.LINE_ID      = W.AFTER_ROUTE_ID
                    							AND    SLM.OPERATION_ID = W.AFTER_OPERATION_ID
                    							AND    ( SLM.MODEL_TYPE = plans.PLAN_GROUP_ID ))
						  --and  PLAN_DATE <= dateadd(dd,(SELECT CONVERT(NUMERIC(5), SLV.SEGMENT3)
						  AND  PLAN_DATE <= dateadd(dd,( SELECT (CASE WHEN SLV.ATTRIBUTE7 = 'Y' THEN 0 ELSE CONVERT(NUMERIC(5), SLV.SEGMENT3) END) AS INSTANCE_DATE -- release validation block 로직 추가... 20230622
      											 FROM   DBO.SCM_SYS_LOOKUP_VALUE  SLV WITH(NOLOCK)
								   WHERE  SLV.LOOKUP_TYPE_CODE = 'INSTANCE_PLANNING_GROUP'
								   AND    SLV.ACTIVE_FLAG = 'Y'
								   AND    SLV.SEGMENT1 = plans.INSTANCE_ID
								   AND    SLV.SEGMENT2 = plans.PLAN_GROUP_ID), convert(datetime,plans.instance_date) )
						  and  plans.nums = 1
						  and  exists (
										  select 1
										  from   FP_INSTANCE_CONFIG_M k
										  where  k.instance_id = w.master_id
										  AND    k.CATEGORY_ID  = 'PLAN_CATEGORY'
										  AND    k.KEY_ID       = 'CELL_HARD_PEGGING'
										  AND    k.KEY_VALUE    = 'Y'
									  )
						  group by after_site_id, after_operation_id, ITEM_ID, after_plan_date, plans.plan_id
						UNION ALL
						  select 'AMEND' as groups, ( select f.plant_id from dbo.scm_factory_m f WITH(NOLOCK) where f.factory_id = w.after_site_id ) as PLANT_ID
								  ,after_site_id as FACTORY_ID, after_operation_id, ITEM_ID, after_plan_date make_date , CEILING(sum(after_qty)) make_qty
      								,plans.plan_id
						  FROM  [dbo].[FP_AMEND_PRODUCTION_PLAN_R] w with(nolock)
      							 ,target_plan  plans  with(nolock)
						  where master_id = plans.instance_id
						  and   w.plan_id = plans.basis_plan_id
						  AND   PLANS.UI_TYPE = 'AMEND UI'
						  -- 비활성화 라인까지 체크 필요함(기존 계획 정리 차원)
						  AND   EXISTS (SELECT 1 
      							FROM   SCM_LINE_M   SLM WITH(NOLOCK)
      							WHERE  SLM.FACTORY_ID   = W.AFTER_SITE_ID
      							AND    SLM.LINE_ID      = W.AFTER_ROUTE_ID
      							AND    SLM.OPERATION_ID = W.AFTER_OPERATION_ID
      							AND    ( SLM.MODEL_TYPE = plans.PLAN_GROUP_ID ))
						  and  plans.nums = 1
						  and  w.after_in_qty > 0
						  --and  after_plan_date <= dateadd(dd,(SELECT CONVERT(NUMERIC(5), SLV.SEGMENT3)
						  AND  after_plan_date <= dateadd( dd,( SELECT (CASE WHEN SLV.ATTRIBUTE7 = 'Y' THEN 0 ELSE CONVERT(NUMERIC(5), SLV.SEGMENT3) END) AS INSTANCE_DATE -- release validation block 로직 추가... 20230622
      												FROM   DBO.SCM_SYS_LOOKUP_VALUE  SLV WITH(NOLOCK)
									WHERE  SLV.LOOKUP_TYPE_CODE = 'INSTANCE_PLANNING_GROUP'
									AND    SLV.ACTIVE_FLAG = 'Y'
									AND    SLV.SEGMENT1 = plans.INSTANCE_ID
									AND    SLV.SEGMENT2 = plans.PLAN_GROUP_ID), convert(datetime,plans.instance_date) )
									and  not exists (
													select 1
													from   FP_INSTANCE_CONFIG_M k
													where  k.instance_id = w.master_id
													AND    k.CATEGORY_ID  = 'PLAN_CATEGORY'
													AND    k.KEY_ID       = 'CELL_HARD_PEGGING'
													AND    k.KEY_VALUE    = 'Y'
												)
						  group by after_site_id, after_operation_id, ITEM_ID, after_plan_date, plans.plan_id
						UNION ALL
						  select 'AMEND' as groups, MAX(W.PLANT_ID) AS PLANT_ID
								  ,W.FACTORY_ID as FACTORY_ID, W.operation_id, W.ITEM_ID, PLAN_DATE make_date , CEILING(sum(OUT_QTY)) make_qty
      								,plans.plan_id
						  FROM  [dbo].[FP_AMEND_PLAN_R] w with(nolock)
      							  ,target_plan  plans  with(nolock)
						  where w.instance_id = plans.instance_id
						  and   w.fp_plan_id  = plans.basis_plan_id
						  AND   PLANS.UI_TYPE = 'PSI AMEND UI'
						  -- 비활성화 라인까지 체크 필요함(기존 계획 정리 차원)
						  AND   EXISTS (SELECT 1 
      							FROM   SCM_LINE_M   SLM WITH(NOLOCK)
      							WHERE  SLM.FACTORY_ID   = W.FACTORY_ID
      							AND    SLM.LINE_ID      = W.LINE_ID
      							AND    SLM.OPERATION_ID = W.OPERATION_ID
      							AND    ( SLM.MODEL_TYPE = plans.PLAN_GROUP_ID ))
						  and  plans.nums = 1
						  and  in_qty > 0
						  --and  plan_date <= dateadd(dd,(SELECT CONVERT(NUMERIC(5), SLV.SEGMENT3)
						  AND  plan_date <= dateadd(dd,(SELECT (CASE WHEN SLV.ATTRIBUTE7 = 'Y' THEN 0 ELSE CONVERT(NUMERIC(5), SLV.SEGMENT3) END) AS INSTANCE_DATE -- release validation block 로직 추가... 20230622
                            											FROM   DBO.SCM_SYS_LOOKUP_VALUE  SLV WITH(NOLOCK)
														WHERE  SLV.LOOKUP_TYPE_CODE = 'INSTANCE_PLANNING_GROUP'
														AND    SLV.ACTIVE_FLAG = 'Y'
														AND    SLV.SEGMENT1 = plans.INSTANCE_ID
														AND    SLV.SEGMENT2 = plans.PLAN_GROUP_ID), convert(datetime,plans.instance_date) )
						  group by W.FACTORY_ID, operation_id, ITEM_ID, plan_date, plans.plan_id
						UNION ALL
						  SELECT 'RELEASE', ( select f.plant_id from scm_factory_m f  with(nolock) where f.factory_id = w.FACTORY_ID ) as PLANT_ID
								, W.FACTORY_ID , W.OPERATION_ID , W.ITEM_ID , CONVERT(VARCHAR, W.PLAN_DATE,112) AS PLAN_DATE , CEILING(sum(PLAN_QTY)) make_qty
								,plans.plan_id
						  FROM   FP_RELEASE_FIX_PLAN_H  W  with(nolock)
								,target_plan  plans  with(nolock)
						  where W.INSTANCE_ID     = plans.instance_id
						  and   w.AMEND_PLAN_ID   = plans.basis_plan_id
						  and   w.RELEASE_PLAN_ID = plans.PLAN_ID
						  and   plans.nums        = 1
						  group by W.FACTORY_ID, W.operation_id, W.ITEM_ID, W.plan_date, plans.plan_id
						UNION ALL
						  select 'PLAN_EQUIPMENT_R', a.PLANT_ID, a.FACTORY_ID, a.OPERATION_ID, a.ITEM_ID, convert( varchar, a.PLAN_DATE, 112), sum( a.plan_qty)
								,plans.plan_id
						  from   dbo.FP_PRODUCTION_PLAN_EQUIPMENT_R a  with(nolock)
								,target_plan plans with(nolock)
						  where a.FP_PLAN_ID = plans.plan_id
						  and   FIX_TYPE   IN ('F','N')
						  and   ORDER_TYPE IN ('W','M')
						  group by a.PLANT_ID, a.FACTORY_ID, a.OPERATION_ID, a.ITEM_ID, convert( varchar, a.PLAN_DATE, 112),plans.plan_id
				  ) A
				  WHERE  OPERATION_ID != 'A6000'
				  GROUP BY PLANT_ID, FACTORY_ID, OPERATION_ID, ITEM_ID, MAKE_DATE, PLAN_ID
				  HAVING ( ABS(SUM(CASE WHEN GROUPS = 'AMEND' THEN MAKE_QTY ELSE 0 END ) - SUM(CASE WHEN GROUPS = 'RELEASE' THEN MAKE_QTY ELSE 0 END ))/( CASE WHEN SUM(CASE WHEN GROUPS = 'AMEND' THEN MAKE_QTY ELSE 0 END ) = 0 THEN 1 ELSE SUM(CASE WHEN GROUPS = 'AMEND' THEN MAKE_QTY ELSE 0 END ) END) > 0.0015
					  OR ABS(SUM(CASE WHEN GROUPS = 'AMEND' THEN MAKE_QTY ELSE 0 END ) - SUM(CASE WHEN GROUPS = 'MES' THEN MAKE_QTY ELSE 0 END ))/( CASE WHEN SUM(CASE WHEN GROUPS = 'AMEND' THEN MAKE_QTY ELSE 0 END ) = 0 THEN 1 ELSE SUM(CASE WHEN GROUPS = 'AMEND' THEN MAKE_QTY ELSE 0 END ) END) > 0.0015 )
				  AND ( ABS(SUM(CASE WHEN GROUPS = 'AMEND' THEN MAKE_QTY ELSE 0 END ) - SUM(CASE WHEN GROUPS = 'RELEASE' THEN MAKE_QTY ELSE 0 END )) > 1
					  OR ABS(SUM(CASE WHEN GROUPS = 'AMEND' THEN MAKE_QTY ELSE 0 END ) - SUM(CASE WHEN GROUPS = 'MES' THEN MAKE_QTY ELSE 0 END ))> 1 )
				  UNION
				  SELECT PLANT_ID, FACTORY_ID, OPERATION_ID, ITEM_ID, SUBSTRING(Z.PLAN_DATE,1,8), FP_PLAN_ID
							   , 0 'ERP'
							   , 0  'MES' 
							   , 0 'RELEASE'
							   , 0 'AMEND'
							   , count(distinct batch_id) 'PLAN_EQUIPMENT_R'
							   , z.batch_order_id CHK1_RELEASE
							   , 'NG_BATCH_ORDER_ID' CHK2_MES
							   , 'NG_BATCH_ORDER_ID' CHK3_ERP
				  FROM (
						  SELECT ISNULL((SELECT  B.BATCH_ID 
										 FROM    SCM_BATCH_M B
										 WHERE   B.PLANT_ID = A.PLANT_ID
										 AND     B.ITEM_ID = A.ITEM_ID), ITEM_ID) AS BATCH_ID , A.*
						  FROM   SY_XIF_ERP_PRODUCTION_PLAN_S A WITH(NOLOCK)
							   , TARGET_PLAN PLANS WITH(NOLOCK)
						  WHERE A.FP_PLAN_ID = PLANS.PLAN_ID
						  AND   BATCH_ORDER_ID <> '-'
					   ) z
				  GROUP BY Z.PLANT_ID, Z.FACTORY_ID, Z.OPERATION_ID, Z.ITEM_ID, SUBSTRING(Z.PLAN_DATE,1,8), FP_PLAN_ID, BATCH_ORDER_ID
				  HAVING COUNT(DISTINCT z.BATCH_ID) > 1
				) A

			  --LOG 생성
			  SET @v_message = 'Validation 1 - Plan Group : ' + CONVERT(VARCHAR,@v_rowCount)
			  SET @n_log_count = @n_log_count + 1
			  EXECUTE pr_log_process  null, @v_master_id, @v_release_plan_id, @v_proc_name, @v_table_name, 'SELECT', @n_log_count, @v_log_code, @v_message, null

			END
		
			-- 수량 검증 오류시 rollback 처리 : 활성화는 실행안함
			IF @v_instance_type != 'F'
			BEGIN
				IF @v_rowCount > 0
				BEGIN
					-- confirm area 별로 테이블 구분해서 처리
					IF @v_confirm_area = 'BUILDING'
					BEGIN
				
						DELETE FROM SCM_FP_PLAN_DETAIL_H
						WHERE  PLAN_DATE   = @v_plan_date
						AND    INSTANCE_ID = @v_master_id
						AND    FACTORY_ID  = @v_factory_id
					
						DELETE FROM HIS_FP_PLAN_DETAIL_H
						WHERE  PLAN_DATE   = @v_plan_date
						AND    INSTANCE_ID = @v_master_id
						AND    PLAN_ID     = @v_plan_id
						AND    FACTORY_ID  = @v_factory_id
			
						INSERT INTO SCM_FP_PLAN_DETAIL_H (
      					       PLAN_DATE, INSTANCE_ID, DIVISION_ID, FACTORY_ID, PLAN_ID
      					     , CONFIRM_ID, CONFIRM_TIME, CONFIRM_FLAG
      					     , RELEASE_TIME, RELEASE_FLAG, RELEASE_PLAN_ID
      					     , MES_TRANSFER_FLAG, MES_TRANSFER_TIME, DESCRIPTION
      					     , INSERT_ID, INSERT_TIME
      					     , UPDATE_ID, UPDATE_TIME
						)
						SELECT A.PLAN_DATE, A.INSTANCE_ID, A.DIVISION_ID, A.FACTORY_ID, A.PLAN_ID
        					 , A.CONFIRM_ID, A.CONFIRM_TIME, A.CONFIRM_FLAG
        					 , A.RELEASE_TIME, A.RELEASE_FLAG, A.RELEASE_PLAN_ID
        					 , A.MES_TRANSFER_FLAG, A.MES_TRANSFER_TIME, A.DESCRIPTION
        					 , A.INSERT_ID, A.INSERT_TIME
        					 , A.UPDATE_ID, A.UPDATE_TIME
						FROM   HIS_FP_PLAN_DETAIL_H A WITH(NOLOCK)
						INNER JOIN (
      						SELECT A.*
      						FROM (
      							SELECT A.PLAN_DATE, A.INSTANCE_ID, A.DIVISION_ID, A.FACTORY_ID, A.PLAN_ID
      								 , ROW_NUMBER() OVER(PARTITION BY A.PLAN_DATE, A.INSTANCE_ID, A.FACTORY_ID ORDER BY A.JOB_SEQ DESC) AS ROW_NUM
      							FROM   HIS_FP_PLAN_DETAIL_H A WITH(NOLOCK)
      							WHERE  A.PLAN_DATE   = @v_plan_date
      							AND    A.INSTANCE_ID = @v_master_id
								AND    A.FACTORY_ID  = @v_factory_id
      						) A
      						WHERE A.ROW_NUM = 1
						) B
						ON  A.PLAN_DATE   = B.PLAN_DATE
						AND A.INSTANCE_ID = B.INSTANCE_ID
						AND A.DIVISION_ID = B.DIVISION_ID
						AND A.FACTORY_ID  = B.FACTORY_ID
						AND A.PLAN_ID	  = B.PLAN_ID


						--LOG 생성
						SET @v_message = 'RollBack 1 - Factory'
						SET @n_log_count = @n_log_count + 1
						EXECUTE pr_log_process  null, @v_master_id, @v_release_plan_id, @v_proc_name, @v_table_name, 'DELETE', @n_log_count, @v_log_code, @v_message, null

					END
					ELSE BEGIN
				
						DELETE FROM SCM_FP_PLAN_GROUP_DETAIL_H
						WHERE  PLAN_DATE     = @v_plan_date
						AND    INSTANCE_ID   = @v_master_id
						AND    PLAN_GROUP_ID = @v_factory_id
        
						DELETE FROM HIS_FP_PLAN_GROUP_DETAIL_H
						WHERE  PLAN_DATE     = @v_plan_date
						AND    INSTANCE_ID   = @v_master_id
						AND    PLAN_ID       = @v_plan_id
						AND    PLAN_GROUP_ID = @v_factory_id

						INSERT INTO SCM_FP_PLAN_GROUP_DETAIL_H (
							   PLAN_DATE, INSTANCE_ID, PLAN_GROUP_ID, PLAN_ID
        					 , CONFIRM_ID, CONFIRM_TIME, CONFIRM_FLAG
        					 , RELEASE_TIME, RELEASE_FLAG, RELEASE_PLAN_ID
        					 , MES_TRANSFER_FLAG, MES_TRANSFER_TIME, DESCRIPTION
        					 , INSERT_ID, INSERT_TIME
        					 , UPDATE_ID, UPDATE_TIME
						)
						SELECT A.PLAN_DATE, A.INSTANCE_ID, A.PLAN_GROUP_ID, A.PLAN_ID
        					 , A.CONFIRM_ID, A.CONFIRM_TIME, A.CONFIRM_FLAG
        					 , A.RELEASE_TIME, A.RELEASE_FLAG, A.RELEASE_PLAN_ID
        					 , A.MES_TRANSFER_FLAG, A.MES_TRANSFER_TIME, A.DESCRIPTION
        					 , A.INSERT_ID, A.INSERT_TIME
        					 , A.UPDATE_ID, A.UPDATE_TIME
						FROM   HIS_FP_PLAN_GROUP_DETAIL_H A WITH(NOLOCK)
						INNER JOIN (
      						SELECT A.*
      						FROM (
      							SELECT A.PLAN_DATE, A.INSTANCE_ID, A.PLAN_GROUP_ID, A.PLAN_ID
      								 , ROW_NUMBER() OVER(PARTITION BY A.PLAN_DATE, A.INSTANCE_ID, A.PLAN_GROUP_ID ORDER BY A.JOB_SEQ DESC) AS ROW_NUM
      							FROM   HIS_FP_PLAN_GROUP_DETAIL_H A WITH(NOLOCK)
      							WHERE  A.PLAN_DATE   = @v_plan_date
      							AND    A.INSTANCE_ID = @v_master_id
								AND    A.PLAN_GROUP_ID = @v_factory_id
      						) A
      						WHERE A.ROW_NUM = 1
						) B
						ON  A.PLAN_DATE     = B.PLAN_DATE
						AND A.INSTANCE_ID   = B.INSTANCE_ID
						AND A.PLAN_GROUP_ID = B.PLAN_GROUP_ID
						AND A.PLAN_ID	    = B.PLAN_ID


						--LOG 생성
						SET @v_message = 'RollBack 1 - Plan Group'
						SET @n_log_count = @n_log_count + 1
						EXECUTE pr_log_process  null, @v_master_id, @v_release_plan_id, @v_proc_name, @v_table_name, 'DELETE', @n_log_count, @v_log_code, @v_message, null

					END

					-- ROLLBACK 처리
					-- 1. UI 락 해제
					DELETE
					FROM   FP_IS_RUNNING_RELEASE_H
					WHERE  1=1
					AND    INSTANCE_ID  = @v_master_id
					AND    RELEASE_TYPE = @v_factory_id
					AND    FP_PLAN_ID   = @v_plan_id

					-- 2. netjob 에러 처리
					UPDATE FP_NETJOB_QUEUE
					SET	   JOB_TYPE       = 'E'
						 , UPDATE_DTTM    = GETDATE()
					WHERE  INSTANCE_DATE  = @v_plan_date
					AND    PARAMETER4     = @v_site_id
					AND    PROC_NAME      = @v_proc_name
					AND	   ACTIVE_FLAG    = 'Y'
					AND	   JOB_SEQ	      = @v_job_seq


					SET @n_log_count = @n_log_count + 1
					EXEC PR_LOG_PROCESS @sysdate, @v_master_id, @v_plan_id, @v_proc_name, null, 'END', 999999, null, '############### End of procedure ###############', null

					return; -- 수량 이상 있을경우 그냥 종료

				END

				-- validation 2
				SET @v_rowCount = 0

				SELECT @v_rowCount = COUNT(*)
				FROM (
					SELECT FP_PLAN_ID
						,PLANT_ID
						,FACTORY_ID
						,OPERATION_ID
						,WORK_ORDER_ID
						,PLAN_DATE
						,PARENT_ITEM_ID
						,LINE_ID
						,PLAN_QTY
						,PLAN_IN_QTY
						,CHILD_ITEM_ID 
						,CHILD_ASSIGN_LINE_ID
						,CHILD_ASSIGN_PRIORITY
						,CASE WHEN (
							SELECT PRIORITY
							FROM   SCM_ITEM_LINE_ASSIGN_EXCEPT_M KK WITH(NOLOCK)
							WHERE  PLANT_ID   =  A.PLANT_ID
							AND    FACTORY_ID = A.FACTORY_ID
							AND    ITEM_ID    = A.CHILD_ITEM_ID
							AND    LINE_ID    = A.LINE_ID
							AND    START_TIME <= A.PLAN_DATE
							AND    END_TIME   > A.PLAN_DATE
							AND    ACTIVE_FLAG = 'N') IS NULL THEN 'N' ELSE 'Y'END AS CHILD_ASSIGN_EXCEPT
					FROM (
						SELECT A.COMPANY_ID
								,A.DIVISION_ID
								,A.SITE_ID
								,A.PLANT_ID
								,A.FACTORY_ID
								,A.OPERATION_ID
								,A.WORK_ORDER_ID
								,PLAN_DATE
								,A.FP_PLAN_ID
								,A.LINE_ID
								,A.PLAN_QTY
								,A.PLAN_IN_QTY
								,PARENT_ITEM_ID
								,CHILD_ITEM_ID
								,I.LINE_ID AS CHILD_ASSIGN_LINE_ID
								,I.OPERATION_ID  AS CHILD_OPERATION_ID
								,I.PRIORITY AS CHILD_ASSIGN_PRIORITY
								,CASE WHEN A.ALT_ID IS NULL THEN 1 ELSE ROW_NUMBER() OVER ( PARTITION BY A.PARENT_ITEM_ID, A.WORK_ORDER_ID, A.ALT_ID ORDER BY I.LINE_ID DESC, A.ALT_PRIORITY, A.CHILD_ITEM_ID) END AS ORD_PRIORITY
						FROM (
							SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.OPERATION_ID, A.PLAN_DATE, A.FP_PLAN_ID, A.WORK_ORDER_ID, A.PLAN_QTY, A.PLAN_IN_QTY, A.LINE_ID 
									,B.PARENT_ITEM_ID
									,B.CHILD_ITEM_ID
									,B.ALT_ID
									,B.ALT_PRIORITY
							FROM DBO.FP_PRODUCTION_PLAN_EQUIPMENT_R A WITH(NOLOCK)
								,DBO.SCM_BOM_M B WITH(NOLOCK)
								,DBO.SCM_ITEM_M D WITH(NOLOCK)
							WHERE 1=1
								AND B.PARENT_ITEM_ID = A.ITEM_ID 
								AND B.PLANT_ID = A.PLANT_ID 
								AND CHILD_ITEM_ID LIKE 'ASL%' 
								AND EFF_START_DATE <= A.START_TIME
								AND EFF_END_DATE > A.START_TIME
								AND B.COMPANY_ID    = D.COMPANY_ID
								AND B.DIVISION_ID   = D.DIVISION_ID
								AND B.SITE_ID       = D.SITE_ID
								AND B.CHILD_ITEM_ID = D.ITEM_ID
								AND D.ACTIVE_FLAG   = 'Y'
								AND ORDER_TYPE = 'W'
								AND PLAN_IN_QTY > 0.0
								AND OPERATION_ID IN ( 'E2000', 'S2000')
								AND A.FP_PLAN_ID = @v_release_plan_id
						) A
						LEFT OUTER JOIN  DBO.SCM_ITEM_LINE_ASSIGN_M I WITH(NOLOCK)
							ON A.PLANT_ID =  I.PLANT_ID
							AND A.FACTORY_ID  = I.FACTORY_ID
							AND A.CHILD_ITEM_ID = I.ITEM_ID
							AND A.LINE_ID = I.LINE_ID
							AND ACTIVE_FLAG = 'Y'
							AND MONTH = CONVERT(VARCHAR(6),A.PLAN_DATE, 112)
							AND I.PRIORITY != '9'
							AND NOT EXISTS  (
								SELECT 1
								FROM   SCM_ITEM_LINE_ASSIGN_EXCEPT_M KK WITH(NOLOCK)
								WHERE PLANT_ID =  A.PLANT_ID
								AND FACTORY_ID  = A.FACTORY_ID
								AND ITEM_ID = A.CHILD_ITEM_ID
								AND OPERATION_ID = I.OPERATION_ID
								AND LINE_ID = I.LINE_ID
								AND START_TIME <= A.PLAN_DATE
								AND END_TIME >= A.PLAN_DATE
								AND  ( ACTIVE_FLAG = 'N'
									OR PRIORITY    = 0
									OR PRIORITY    = 9 )
							)
					) A
					WHERE ORD_PRIORITY = 1
					AND NOT EXISTS (
						SELECT 1 FROM DBO.FP_ORDER_PEGGING_R B WITH(NOLOCK)
						WHERE B.FP_PLAN_ID       = A.FP_PLAN_ID
						AND   B.TO_WORK_ORDER_ID = A.WORK_ORDER_ID
						AND   B.FROM_ITEM_ID     = A.CHILD_ITEM_ID
					)
				) A

				--LOG 생성
				SET @v_message = 'Validation 2 : ' + CONVERT(VARCHAR,@v_rowCount)
				SET @n_log_count = @n_log_count + 1
				EXECUTE pr_log_process  null, @v_master_id, @v_release_plan_id, @v_proc_name, @v_table_name, 'SELECT', @n_log_count, @v_log_code, @v_message, null

				-- validation 2 에 걸려서 rollback
				IF @v_rowCount > 0
				BEGIN
					-- confirm area 별로 테이블 구분해서 처리
					IF @v_confirm_area = 'BUILDING'
					BEGIN
					    
						DELETE FROM SCM_FP_PLAN_DETAIL_H
						WHERE  PLAN_DATE   = @v_plan_date
						AND    INSTANCE_ID = @v_master_id
						AND    FACTORY_ID  = @v_factory_id
					
						DELETE FROM HIS_FP_PLAN_DETAIL_H
						WHERE  PLAN_DATE   = @v_plan_date
						AND    INSTANCE_ID = @v_master_id
						AND    PLAN_ID     = @v_plan_id
						AND    FACTORY_ID  = @v_factory_id
			
						INSERT INTO SCM_FP_PLAN_DETAIL_H (
      						PLAN_DATE, INSTANCE_ID, DIVISION_ID, FACTORY_ID, PLAN_ID
      					  , CONFIRM_ID, CONFIRM_TIME, CONFIRM_FLAG
      					  , RELEASE_TIME, RELEASE_FLAG, RELEASE_PLAN_ID
      					  , MES_TRANSFER_FLAG, MES_TRANSFER_TIME, DESCRIPTION
      					  , INSERT_ID, INSERT_TIME
      					  , UPDATE_ID, UPDATE_TIME
						)
						SELECT A.PLAN_DATE, A.INSTANCE_ID, A.DIVISION_ID, A.FACTORY_ID, A.PLAN_ID
        					 , A.CONFIRM_ID, A.CONFIRM_TIME, A.CONFIRM_FLAG
        					 , A.RELEASE_TIME, A.RELEASE_FLAG, A.RELEASE_PLAN_ID
        					 , A.MES_TRANSFER_FLAG, A.MES_TRANSFER_TIME, A.DESCRIPTION
        					 , A.INSERT_ID, A.INSERT_TIME
        					 , A.UPDATE_ID, A.UPDATE_TIME
						FROM   HIS_FP_PLAN_DETAIL_H A WITH(NOLOCK)
						INNER JOIN (
      						SELECT A.*
      						FROM (
      							SELECT A.PLAN_DATE, A.INSTANCE_ID, A.DIVISION_ID, A.FACTORY_ID, A.PLAN_ID
      								 , ROW_NUMBER() OVER(PARTITION BY A.PLAN_DATE, A.INSTANCE_ID, A.FACTORY_ID ORDER BY A.JOB_SEQ DESC) AS ROW_NUM
      							FROM   HIS_FP_PLAN_DETAIL_H A WITH(NOLOCK)
      							WHERE  A.PLAN_DATE   = @v_plan_date
      							AND    A.INSTANCE_ID = @v_master_id
								AND    A.FACTORY_ID  = @v_factory_id
      						) A
      						WHERE A.ROW_NUM = 1
						) B
						ON  A.PLAN_DATE   = B.PLAN_DATE
						AND A.INSTANCE_ID = B.INSTANCE_ID
						AND A.DIVISION_ID = B.DIVISION_ID
						AND A.FACTORY_ID  = B.FACTORY_ID
						AND A.PLAN_ID	    = B.PLAN_ID


						--LOG 생성
						SET @v_message = 'RollBack 2 - Factory'
						SET @n_log_count = @n_log_count + 1
						EXECUTE pr_log_process  null, @v_master_id, @v_release_plan_id, @v_proc_name, @v_table_name, 'DELETE', @n_log_count, @v_log_code, @v_message, null

					END
					ELSE BEGIN
				
						DELETE FROM SCM_FP_PLAN_GROUP_DETAIL_H
						WHERE  PLAN_DATE     = @v_plan_date
						AND    INSTANCE_ID   = @v_master_id
						AND    PLAN_GROUP_ID = @v_factory_id
        
						DELETE FROM HIS_FP_PLAN_GROUP_DETAIL_H
						WHERE  PLAN_DATE     = @v_plan_date
						AND    INSTANCE_ID   = @v_master_id
						AND    PLAN_ID       = @v_plan_id
						AND    PLAN_GROUP_ID = @v_factory_id

						INSERT INTO SCM_FP_PLAN_GROUP_DETAIL_H (
								  PLAN_DATE, INSTANCE_ID, PLAN_GROUP_ID, PLAN_ID
        						, CONFIRM_ID, CONFIRM_TIME, CONFIRM_FLAG
        						, RELEASE_TIME, RELEASE_FLAG, RELEASE_PLAN_ID
        						, MES_TRANSFER_FLAG, MES_TRANSFER_TIME, DESCRIPTION
        						, INSERT_ID, INSERT_TIME
        						, UPDATE_ID, UPDATE_TIME
						)
						SELECT A.PLAN_DATE, A.INSTANCE_ID, A.PLAN_GROUP_ID, A.PLAN_ID
        						, A.CONFIRM_ID, A.CONFIRM_TIME, A.CONFIRM_FLAG
        						, A.RELEASE_TIME, A.RELEASE_FLAG, A.RELEASE_PLAN_ID
        						, A.MES_TRANSFER_FLAG, A.MES_TRANSFER_TIME, A.DESCRIPTION
        						, A.INSERT_ID, A.INSERT_TIME
        						, A.UPDATE_ID, A.UPDATE_TIME
						FROM   HIS_FP_PLAN_GROUP_DETAIL_H A WITH(NOLOCK)
						INNER JOIN (
      						SELECT A.*
      						FROM (
      							SELECT A.PLAN_DATE, A.INSTANCE_ID, A.PLAN_GROUP_ID, A.PLAN_ID
      									, ROW_NUMBER() OVER(PARTITION BY A.PLAN_DATE, A.INSTANCE_ID, A.PLAN_GROUP_ID ORDER BY A.JOB_SEQ DESC) AS ROW_NUM
      							FROM   HIS_FP_PLAN_GROUP_DETAIL_H A WITH(NOLOCK)
      							WHERE  A.PLAN_DATE   = @v_plan_date
      							AND    A.INSTANCE_ID = @v_master_id
								AND    A.PLAN_GROUP_ID = @v_factory_id
      						) A
      						WHERE A.ROW_NUM = 1
						) B
						ON  A.PLAN_DATE     = B.PLAN_DATE
						AND A.INSTANCE_ID   = B.INSTANCE_ID
						AND A.PLAN_GROUP_ID = B.PLAN_GROUP_ID
						AND A.PLAN_ID	    = B.PLAN_ID


						--LOG 생성
						SET @v_message = 'RollBack 2 - Plan Group'
						SET @n_log_count = @n_log_count + 1
						EXECUTE pr_log_process  null, @v_master_id, @v_release_plan_id, @v_proc_name, @v_table_name, 'DELETE', @n_log_count, @v_log_code, @v_message, null

					END

					-- ROLLBACK 처리
					-- 1. UI 락 해제
					DELETE
					FROM   FP_IS_RUNNING_RELEASE_H
					WHERE  1=1
					AND    INSTANCE_ID  = @v_master_id
					AND    RELEASE_TYPE = @v_factory_id
					AND    FP_PLAN_ID   = @v_plan_id

					-- 2. netjob 에러 처리
					UPDATE FP_NETJOB_QUEUE
					SET	   JOB_TYPE       = 'E'
						 , UPDATE_DTTM    = GETDATE()
					WHERE  INSTANCE_DATE  = @v_plan_date
					AND    PARAMETER4     = @v_site_id
					AND    PROC_NAME      = @v_proc_name
					AND	   ACTIVE_FLAG    = 'Y'
					AND	   JOB_SEQ	      = @v_job_seq


					SET @n_log_count = @n_log_count + 1
					EXEC PR_LOG_PROCESS @sysdate, @v_master_id, @v_plan_id, @v_proc_name, null, 'END', 999999, null, '############### End of procedure ###############', null

					return; -- 수량 이상 있을경우 그냥 종료
				END

			END -- 수량검증 check end

			----------------------------------- 6. mes, erp 전송 update 쿼리 시작 -----------------------------------
			IF @v_instance_type != 'F'
			BEGIN
				
				UPDATE SY_XIF_ERP_PRODUCTION_PLAN_S
				SET    SY_XIF_ERP_PRODUCTION_PLAN_S.TRANSFER_FLAG = 'N'
				FROM   SY_XIF_ERP_PRODUCTION_PLAN_S A 
				WHERE  A.TRANSFER_FLAG = 'X'
				AND    (CASE WHEN CHARINDEX('E_POST',@v_master_id) = 0 THEN 1 ELSE 0 END) = 1 -- 후공정은 실행안함... 20201203
				AND    A.FP_PLAN_ID = @v_release_plan_id
				;
        
				UPDATE SY_XIF_MES_WO_S
				SET    SY_XIF_MES_WO_S.IF_FLAG = 'N'
				FROM   SY_XIF_MES_WO_S A 
				WHERE  A.IF_FLAG       = 'X'
				AND    A.PLAN_ID       = @v_release_plan_id
				;
			
				UPDATE SY_XIF_MES_DAILY_PP_S
				SET    SY_XIF_MES_DAILY_PP_S.IF_FLAG = 'N'
				FROM   SY_XIF_MES_DAILY_PP_S A 
				WHERE  A.IF_FLAG       = 'X'
				AND    A.PLAN_ID       = @v_release_plan_id
				;

				-- PDS 테이블 추가... 20230920
				UPDATE SY_XIF_PDS_WO_S
				SET    SY_XIF_PDS_WO_S.IF_FLAG = 'N'
				FROM   SY_XIF_PDS_WO_S A 
				WHERE  A.IF_FLAG       = 'X'
				AND    A.PLAN_ID       = @v_release_plan_id
				/*
				-- 유효 인스턴스에 대해서만 업데이트
				AND    @v_master_id IN (
					SELECT SEGMENT1
					FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)
					WHERE  1=1
					AND    LOOKUP_TYPE_CODE = 'PDS_INSTANCE'
					AND    ACTIVE_FLAG = 'Y'
					AND    SEGMENT2 = 'Y' -- USE FLAG
					AND    SEGMENT1 = @v_master_id
				)
				*/
				;
				
				IF @v_confirm_area = 'BUILDING'
				BEGIN
				
					UPDATE SCM_FP_PLAN_DETAIL_H
					SET    MES_TRANSFER_FLAG = 'Y'
						  ,MES_TRANSFER_TIME = GETDATE()
					WHERE  PLAN_DATE     = @v_plan_date
					AND    INSTANCE_ID   = @v_master_id
					AND    RELEASE_FLAG  = 'Y'
					AND    PLAN_ID       = @v_plan_id
				
					UPDATE HIS_FP_PLAN_DETAIL_H
					SET    HIS_FP_PLAN_DETAIL_H.RELEASE_TIME    = dbo.FN_SITE_TIME(@v_site_id)
						 , HIS_FP_PLAN_DETAIL_H.RELEASE_FLAG    = 'Y'
						 , HIS_FP_PLAN_DETAIL_H.RELEASE_PLAN_ID = B.RELEASE_PLAN_ID
						 , MES_TRANSFER_FLAG = 'Y'
						 , MES_TRANSFER_TIME = GETDATE()
					FROM   HIS_FP_PLAN_DETAIL_H A
					INNER JOIN SCM_FP_PLAN_DETAIL_H B
					ON     A.PLAN_DATE    = B.PLAN_DATE
					AND    A.INSTANCE_ID  = B.INSTANCE_ID
					AND    A.FACTORY_ID   = B.FACTORY_ID
					WHERE  A.PLAN_DATE    = @v_plan_date
					AND    A.INSTANCE_ID  = @v_master_id
					AND    A.PLAN_ID      = @v_plan_id
					AND    A.FACTORY_ID   = @v_factory_id
				
				END
				ELSE BEGIN

					UPDATE SCM_FP_PLAN_GROUP_DETAIL_H
					SET    MES_TRANSFER_FLAG = 'Y'
						  ,MES_TRANSFER_TIME = GETDATE()
					WHERE  PLAN_DATE     = @v_plan_date
					AND    INSTANCE_ID   = @v_master_id
					AND    RELEASE_FLAG  = 'Y'
					AND    PLAN_ID       = @v_plan_id
				
					UPDATE HIS_FP_PLAN_GROUP_DETAIL_H
					SET    HIS_FP_PLAN_GROUP_DETAIL_H.RELEASE_TIME    = dbo.FN_SITE_TIME(@v_site_id)
						 , HIS_FP_PLAN_GROUP_DETAIL_H.RELEASE_FLAG    = 'Y'
						 , HIS_FP_PLAN_GROUP_DETAIL_H.RELEASE_PLAN_ID = B.RELEASE_PLAN_ID
						 , MES_TRANSFER_FLAG = 'Y'
						 , MES_TRANSFER_TIME = GETDATE()
					FROM   HIS_FP_PLAN_GROUP_DETAIL_H A
					INNER JOIN SCM_FP_PLAN_GROUP_DETAIL_H B
					ON     A.PLAN_DATE     = B.PLAN_DATE
					AND    A.INSTANCE_ID   = B.INSTANCE_ID
					AND    A.PLAN_GROUP_ID = B.PLAN_GROUP_ID
					WHERE  A.PLAN_DATE     = @v_plan_date
					AND    A.INSTANCE_ID   = @v_master_id
					AND    A.PLAN_ID       = @v_plan_id
					AND    A.PLAN_GROUP_ID = @v_factory_id
				
				END

			END


			--LOG 생성
			SET @v_message = 'MES Transfer'
			SET @n_log_count = @n_log_count + 1
			EXECUTE pr_log_process  null, @v_master_id, @v_release_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, @v_log_code, @v_message, null

			----------------------------------- 6. mes, erp 전송 update 쿼리 종료 -----------------------------------


			----------------------------------- 7. desc update 쿼리 시작 -----------------------------------
			UPDATE SCM_FP_PLAN_H SET
				   REL_DESC    = @v_description
			WHERE  INSTANCE_ID = @v_master_id
			AND    PLAN_ID     = @v_release_plan_id

			-- 7.1. MRP Transit
			IF @v_MRP_flag = 'Y'
			BEGIN
				UPDATE SCM_FP_PLAN_H SET
					   MRP_FLAG    = 'N'
				WHERE  INSTANCE_ID = @v_master_id
				AND    PLAN_ID     = @v_release_plan_id

				--LOG 생성
				SET @v_message = '7.1. MRP Transit'
				SET @n_log_count = @n_log_count + 1
				EXECUTE pr_log_process  null, @v_master_id, @v_release_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, @v_log_code, @v_message, null

			END
		
			----------------------------------- 7. desc update 쿼리 종료 -----------------------------------


			----------------------------------- 8. 최종 배포결과 메일 프로시저 시작 -----------------------------------
			/* 2023-07-20 PR_SCM_RELEASE_PLAN_ATTACH_FILE 호출로 변경 */
			/*
			IF @v_confirm_area = 'BUILDING'
				EXEC PR_SCM_RELEASE_PLAN_SEND @v_master_id, @v_plan_date, @v_factory_id, NULL, @v_description
			ELSE
				EXEC PR_SCM_RELEASE_PLAN_SEND @v_master_id, @v_plan_date, NULL, @v_factory_id, @v_description

			--LOG 생성
			SET @v_message = 'Result Mail'
			SET @n_log_count = @n_log_count + 1
			EXECUTE pr_log_process  null, @v_master_id, @v_release_plan_id, 'PR_SCM_RELEASE_PLAN_SEND', @v_table_name, 'CALL', @n_log_count, @v_log_code, @v_message, null
			*/
			/* 2023-07-20 PR_SCM_RELEASE_PLAN_ATTACH_FILE 호출로 변경 */
			IF @v_confirm_area = 'BUILDING'
				EXEC PR_SCM_RELEASE_PLAN_ATTACH_FILE
				  @P_INSTANCE_ID     = @v_master_id
				, @P_INSTANCE_DATE   = @v_plan_date
				, @P_FACTORY_ID      = @v_factory_id
				, @P_PLAN_GROUP_ID   = NULL
				, @P_PLAN_DESCRIPTION   =  @v_description
			ELSE
				EXEC PR_SCM_RELEASE_PLAN_ATTACH_FILE
				  @P_INSTANCE_ID     = @v_master_id
				, @P_INSTANCE_DATE   = @v_plan_date
				, @P_FACTORY_ID      = NULL
				, @P_PLAN_GROUP_ID   = @v_factory_id
				, @P_PLAN_DESCRIPTION   =  @v_description

			--LOG 생성
			SET @v_message = 'Result Mail'
			SET @n_log_count = @n_log_count + 1
			EXECUTE pr_log_process  null, @v_master_id, @v_release_plan_id, 'PR_SCM_RELEASE_PLAN_ATTACH_FILE', @v_table_name, 'CALL', @n_log_count, @v_log_code, @v_message, null

			----------------------------------- 8. 최종 배포결과 메일 프로시저 종료 -----------------------------------


			----------------------------------- 9. SMS 전송 프로시저 시작 -----------------------------------
			EXEC PR_SCM_CONFIRM_SMS_SEND @v_master_id, @v_release_plan_id, @v_factory_id
		
			--LOG 생성
			SET @v_message = 'SMS'
			SET @n_log_count = @n_log_count + 1
			EXECUTE pr_log_process  null, @v_master_id, @v_release_plan_id, 'PR_SCM_CONFIRM_SMS_SEND', @v_table_name, 'CALL', @n_log_count, @v_log_code, @v_message, null

			----------------------------------- 9. SMS 전송 프로시저 종료 -----------------------------------


			----------------------------------- 10. PR_XIF_MES_ERP_WO_MASTER 프로시저 실행 시작 -----------------------------------
			-- 활성화는 실행안함
			IF @v_instance_type != 'F'
			BEGIN
				EXEC PR_XIF_MES_ERP_WO_MASTER @v_release_plan_id

				--LOG 생성
				SET @v_message = ''
				SET @n_log_count = @n_log_count + 1
				EXECUTE pr_log_process  null, @v_master_id, @v_release_plan_id, 'PR_XIF_MES_ERP_WO_MASTER', @v_table_name, 'CALL', @n_log_count, @v_log_code, @v_message, null
			
			END

			----------------------------------- 10. PR_XIF_MES_ERP_WO_MASTER 프로시저 실행 종료 -----------------------------------


			----------------------------------- 11. 배포 락 해제 시작 -----------------------------------
			DELETE FROM FP_IS_RUNNING_RELEASE_H
			WHERE  INSTANCE_ID  = @v_master_id
			AND    RELEASE_TYPE = @v_factory_id

			--LOG 생성
			SET @v_message = 'UI Unlock'
			SET @n_log_count = @n_log_count + 1
			EXECUTE pr_log_process  null, @v_master_id, @v_release_plan_id, @v_proc_name, @v_table_name, 'DELETE', @n_log_count, @v_log_code, @v_message, null

			----------------------------------- 11. 배포 락 해제 종료 -----------------------------------


			----------------------------------- 12. PR_SCM_OF_ASSY_ELEC_REPORT 프로시저 시작 -----------------------------------
			-- 후공정 실행 제외
			IF CHARINDEX('POST', @v_master_id) = 0
			BEGIN
				EXEC PR_SCM_OF_ASSY_ELEC_REPORT @v_master_id

				--LOG 생성
				SET @v_message = ''
				SET @n_log_count = @n_log_count + 1
				EXECUTE pr_log_process  null, @v_master_id, @v_release_plan_id, 'PR_SCM_OF_ASSY_ELEC_REPORT', @v_table_name, 'CALL', @n_log_count, @v_log_code, @v_message, null

			END
		
			----------------------------------- 12. PR_SCM_OF_ASSY_ELEC_REPORT 프로시저 종료 -----------------------------------


			----------------------------------- 13. pack 한정 실행 시작 -----------------------------------
			IF CHARINDEX('PACK', @v_master_id) > 0
			BEGIN
/*
				EXEC PR_SCM_OF_PACK_REQUIRE_CEL @v_master_id, '', 'Y', '', '', 'N', @v_user_id, NULL

				EXEC PR_SCM_OF_PACK_TO_CELL @v_master_id , @v_release_plan_id
*/
				-- 넷잡으로 변경
				INSERT INTO FP_NETJOB_QUEUE (
					   INSTANCE_DATE
					 , INSTANCE_ID
					 , FP_PLAN_ID
					 , PROC_NAME
					 , JOB_SEQ
					 , JOB_TYPE
					 , ACTIVE_FLAG
					 , PARAMETER1
					 , PARAMETER2
					 , PARAMETER3
					 , PARAMETER4
					 , PARAMETER5
					 , ATTRIBUTE1
					 , ATTRIBUTE2
					 , INSERT_ID
					 , INSERT_DTTM
					 , UPDATE_ID
					 , UPDATE_DTTM
				)
				SELECT @v_plan_date
      				 , @v_master_id
      				 , @v_release_plan_id
      				 , 'PR_SCM_OF_PACK_TO_CELL_AUTO'
      				 , NEXT VALUE FOR SEQ_FP_NETJOB
      				 , 'R'
      				 , 'Y'
      				 , @v_master_id
      				 , @v_release_plan_id
      				 , null
      				 , null
      				 , null
      				 , null
      				 , null
      				 , @v_user_id
      				 , GETDATE()
      				 , @v_user_id
      				 , GETDATE()

				--LOG 생성
				SET @v_message = ''
				SET @n_log_count = @n_log_count + 1
				EXECUTE pr_log_process  null, @v_master_id, @v_release_plan_id, 'PR_SCM_OF_PACK_REQUIRE_CEL', @v_table_name, 'CALL', @n_log_count, @v_log_code, @v_message, null

			END

			----------------------------------- 13. pack 한정 실행 종료 -----------------------------------

			----------------------------------- 14. 활성화 한정 실행 시작 -----------------------------------
			IF @v_instance_type = 'F'
			BEGIN
				EXEC PR_SCM_OF_CELL_DELIVERY_PLAN @v_master_id, '', 'Y', '', '', 'N', @v_user_id, NULL

				--LOG 생성
				SET @v_message = ''
				SET @n_log_count = @n_log_count + 1
				EXECUTE pr_log_process  null, @v_master_id, @v_release_plan_id, 'PR_SCM_OF_CELL_DELIVERY_PLAN', @v_table_name, 'CALL', @n_log_count, @v_log_code, @v_message, null

			END

			----------------------------------- 14. 활성화 한정 실행 종료 -----------------------------------

			----------------------------------- 15. PIC 기능 실행 시작 -----------------------------------
			SELECT @v_PIC_option = ISNULL(MAX(ATTRIBUTE1), 'N')
			FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)
			WHERE  1=1
			AND    LOOKUP_TYPE_CODE = 'INSTANCE_OPTION'
			AND    SEGMENT1 = @v_master_id


			IF @v_PIC_option = 'Y'
			BEGIN
				EXEC PR_SCM_PIC_ALARM @v_master_id, @v_release_plan_id

				--LOG 생성
				SET @v_message = ''
				SET @n_log_count = @n_log_count + 1
				EXECUTE pr_log_process  null, @v_master_id, @v_release_plan_id, 'PR_SCM_PIC_ALARM', @v_table_name, 'CALL', @n_log_count, @v_log_code, @v_message, null

			END

			----------------------------------- 15. PIC 기능 실행 종료 -----------------------------------


			UPDATE FP_NETJOB_QUEUE
			SET	   JOB_TYPE       = 'C'
			     , UPDATE_DTTM    = GETDATE()
			WHERE  INSTANCE_DATE  = @v_plan_date
			AND    PARAMETER4     = @v_site_id
			AND    PROC_NAME      = @v_proc_name
			AND	   ACTIVE_FLAG    = 'Y'
			AND	   JOB_SEQ	      = @v_job_seq

			--LOG 생성
			SET @n_log_count = @n_log_count + 1
			SET @v_descr = '--- FP_NETJOB_QUEUE END ---'
			EXEC PR_LOG_PROCESS @sysdate, @v_master_id, @v_plan_id, @v_proc_name, 'FP_NETJOB_QUEUE', 'UPDATE', @n_log_count, NULL, @v_descr, null

		END -- @v_job_seq > 0 OR  @v_plan_id != '-' 

    END -- @v_plan_run_flag = 'RUN'

  END TRY

  BEGIN CATCH
    -- ROLLBACK 처리
	-- 1. UI 락 해제
	DELETE
	FROM   FP_IS_RUNNING_RELEASE_H
	WHERE  1=1
	AND    INSTANCE_ID  = @v_master_id
	AND    RELEASE_TYPE = @v_factory_id
	AND    FP_PLAN_ID   = @v_plan_id

	-- 2. netjob 에러 처리
	UPDATE FP_NETJOB_QUEUE
	SET	   JOB_TYPE       = 'E'
		 , UPDATE_DTTM    = GETDATE()
	WHERE  INSTANCE_DATE  = @v_plan_date
	AND    PARAMETER4     = @v_site_id
	AND    PROC_NAME      = @v_proc_name
	AND	   ACTIVE_FLAG    = 'Y'
	AND	   JOB_SEQ	      = @v_job_seq


    SET @v_descr = ERROR_MESSAGE()
    SET @sysdate = GETDATE()

    EXEC PR_LOG_PROCESS @sysdate, @v_master_id, @v_plan_id, @v_proc_name, null, 'ERROR', null, @v_temp2, null, @v_descr
    
/*
	-- exception 시 롤백은 오류 상태정보까지 지워지기때문에 일단 ui lock만 해제하도록 정의
	IF @v_confirm_area = 'BUILDING'
	BEGIN

		SELECT @v_catch_count    = COUNT(@v_plan_date)
		     , @v_catch_mesTrans = MAX(A.MES_TRANSFER_FLAG)
			 , @v_catch_release  = MAX(A.RELEASE_FLAG)
		FROM   SCM_FP_PLAN_DETAIL_H A WITH(NOLOCK)
		WHERE  A.PLAN_DATE   = @v_plan_date
		AND    A.INSTANCE_ID = @v_master_id
		AND    A.FACTORY_ID  = @v_factory_id
		AND    A.PLAN_ID     = @v_plan_id

		-- * 풀 롤백 조건
		-- plan detail 데이터가 아예 없거나
		-- (활성화 아닐때) MES_TRANSFER_FLAG = 'Y' 가 아닐때
		-- (활성화 일때) RELEASE_FLAG = 'Y' 가 아닐때
		IF @v_catch_count = 0  OR (CHARINDEX('FORM', @V_MASTER_ID) = 0 AND @v_catch_mesTrans <> 'Y') OR (CHARINDEX('FORM', @V_MASTER_ID) > 0 AND @v_catch_release <> 'Y')
		BEGIN
			
			DELETE FROM SCM_FP_PLAN_DETAIL_H
			WHERE  PLAN_DATE   = @v_plan_date
			AND    INSTANCE_ID = @v_master_id
			AND    FACTORY_ID  = @v_factory_id
					
			DELETE FROM HIS_FP_PLAN_DETAIL_H
			WHERE  PLAN_DATE   = @v_plan_date
			AND    INSTANCE_ID = @v_master_id
			AND    PLAN_ID     = @v_plan_id
			AND    FACTORY_ID  = @v_factory_id
			
			INSERT INTO SCM_FP_PLAN_DETAIL_H (
      			   PLAN_DATE, INSTANCE_ID, DIVISION_ID, FACTORY_ID, PLAN_ID
      			 , CONFIRM_ID, CONFIRM_TIME, CONFIRM_FLAG
      			 , RELEASE_TIME, RELEASE_FLAG, RELEASE_PLAN_ID
      			 , MES_TRANSFER_FLAG, MES_TRANSFER_TIME, DESCRIPTION
      			 , INSERT_ID, INSERT_TIME
      			 , UPDATE_ID, UPDATE_TIME
			)
			SELECT A.PLAN_DATE, A.INSTANCE_ID, A.DIVISION_ID, A.FACTORY_ID, A.PLAN_ID
        		 , A.CONFIRM_ID, A.CONFIRM_TIME, A.CONFIRM_FLAG
        		 , A.RELEASE_TIME, A.RELEASE_FLAG, A.RELEASE_PLAN_ID
        		 , A.MES_TRANSFER_FLAG, A.MES_TRANSFER_TIME, A.DESCRIPTION
        		 , A.INSERT_ID, A.INSERT_TIME
        		 , A.UPDATE_ID, A.UPDATE_TIME
			FROM   HIS_FP_PLAN_DETAIL_H A WITH(NOLOCK)
			INNER JOIN (
      			SELECT A.*
      			FROM (
      				SELECT A.PLAN_DATE, A.INSTANCE_ID, A.DIVISION_ID, A.FACTORY_ID, A.PLAN_ID
      						, ROW_NUMBER() OVER(PARTITION BY A.PLAN_DATE, A.INSTANCE_ID, A.FACTORY_ID ORDER BY A.JOB_SEQ DESC) AS ROW_NUM
      				FROM   HIS_FP_PLAN_DETAIL_H A WITH(NOLOCK)
      				WHERE  A.PLAN_DATE   = @v_plan_date
      				AND    A.INSTANCE_ID = @v_master_id
					AND    A.FACTORY_ID  = @v_factory_id
      			) A
      			WHERE A.ROW_NUM = 1
			) B
			ON  A.PLAN_DATE   = B.PLAN_DATE
			AND A.INSTANCE_ID = B.INSTANCE_ID
			AND A.DIVISION_ID = B.DIVISION_ID
			AND A.FACTORY_ID  = B.FACTORY_ID
			AND A.PLAN_ID	    = B.PLAN_ID


			DELETE
			FROM   FP_IS_RUNNING_RELEASE_H
			WHERE  1=1
			AND    INSTANCE_ID  = @p_instance_id
			AND    RELEASE_TYPE = @p_factory_id
			AND    FP_PLAN_ID   = @p_plan_id


			--LOG 생성
			SET @v_message = 'Full RollBack by Error - Factory'
			SET @n_log_count = @n_log_count + 1
			EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'DELETE', @n_log_count, @v_log_code, @v_message, null

		END
		-- * ui 락만 해제
		-- (활성화 아닐때) MES_TRANSFER_FLAG = 'Y' 일때
		-- (활성화 일때) RELEASE_FLAG = 'Y' 일때
		ELSE IF (CHARINDEX('FORM', @V_MASTER_ID) = 0 AND @v_catch_mesTrans = 'Y') OR (CHARINDEX('FORM', @V_MASTER_ID) > 0 AND @v_catch_release = 'Y')
		BEGIN
			
			DELETE
			FROM   FP_IS_RUNNING_RELEASE_H
			WHERE  1=1
			AND    INSTANCE_ID  = @p_instance_id
			AND    RELEASE_TYPE = @p_factory_id
			AND    FP_PLAN_ID   = @p_plan_id

			--LOG 생성
			SET @v_message = 'RollBack by Error - Factory'
			SET @n_log_count = @n_log_count + 1
			EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'DELETE', @n_log_count, @v_log_code, @v_message, null

		END

	END
	-- plan group
	ELSE
	BEGIN
		
		SELECT @v_catch_count    = COUNT(@v_plan_date)
		     , @v_catch_mesTrans = MAX(A.MES_TRANSFER_FLAG)
			 , @v_catch_release  = MAX(A.RELEASE_FLAG)
		FROM   SCM_FP_PLAN_GROUP_DETAIL_H A WITH(NOLOCK)
		WHERE  A.PLAN_DATE     = @v_plan_date
		AND    A.INSTANCE_ID   = @v_master_id
		AND    A.PLAN_GROUP_ID = @v_factory_id
		AND    A.PLAN_ID       = @v_plan_id

		-- * 풀 롤백 조건
		-- plan detail 데이터가 아예 없거나
		-- (활성화 아닐때) MES_TRANSFER_FLAG = 'Y' 가 아닐때
		-- (활성화 일때) RELEASE_FLAG = 'Y' 가 아닐때
		IF @v_catch_count = 0  OR (CHARINDEX('FORM', @V_MASTER_ID) = 0 AND @v_catch_mesTrans <> 'Y') OR (CHARINDEX('FORM', @V_MASTER_ID) > 0 AND @v_catch_release <> 'Y')
		BEGIN
			
			DELETE FROM SCM_FP_PLAN_GROUP_DETAIL_H
			WHERE  PLAN_DATE     = @v_plan_date
			AND    INSTANCE_ID   = @v_master_id
			AND    PLAN_GROUP_ID = @v_factory_id
			
			DELETE FROM HIS_FP_PLAN_GROUP_DETAIL_H
			WHERE  PLAN_DATE     = @v_plan_date
			AND    INSTANCE_ID   = @v_master_id
			AND    PLAN_ID       = @v_plan_id
			AND    PLAN_GROUP_ID = @v_factory_id

			INSERT INTO SCM_FP_PLAN_GROUP_DETAIL_H (
				   PLAN_DATE, INSTANCE_ID, PLAN_GROUP_ID, PLAN_ID
        		 , CONFIRM_ID, CONFIRM_TIME, CONFIRM_FLAG
        		 , RELEASE_TIME, RELEASE_FLAG, RELEASE_PLAN_ID
        		 , MES_TRANSFER_FLAG, MES_TRANSFER_TIME, DESCRIPTION
        		 , INSERT_ID, INSERT_TIME
        		 , UPDATE_ID, UPDATE_TIME
			)
			SELECT A.PLAN_DATE, A.INSTANCE_ID, A.PLAN_GROUP_ID, A.PLAN_ID
        		 , A.CONFIRM_ID, A.CONFIRM_TIME, A.CONFIRM_FLAG
        		 , A.RELEASE_TIME, A.RELEASE_FLAG, A.RELEASE_PLAN_ID
        		 , A.MES_TRANSFER_FLAG, A.MES_TRANSFER_TIME, A.DESCRIPTION
        		 , A.INSERT_ID, A.INSERT_TIME
        		 , A.UPDATE_ID, A.UPDATE_TIME
			FROM   HIS_FP_PLAN_GROUP_DETAIL_H A WITH(NOLOCK)
			INNER JOIN (
      			SELECT A.*
      			FROM (
      				SELECT A.PLAN_DATE, A.INSTANCE_ID, A.PLAN_GROUP_ID, A.PLAN_ID
      					 , ROW_NUMBER() OVER(PARTITION BY A.PLAN_DATE, A.INSTANCE_ID, A.PLAN_GROUP_ID ORDER BY A.JOB_SEQ DESC) AS ROW_NUM
      				FROM   HIS_FP_PLAN_GROUP_DETAIL_H A WITH(NOLOCK)
      				WHERE  A.PLAN_DATE   = @v_plan_date
      				AND    A.INSTANCE_ID = @v_master_id
					AND    A.PLAN_GROUP_ID = @v_factory_id
      			) A
      			WHERE A.ROW_NUM = 1
			) B
			ON  A.PLAN_DATE     = B.PLAN_DATE
			AND A.INSTANCE_ID   = B.INSTANCE_ID
			AND A.PLAN_GROUP_ID = B.PLAN_GROUP_ID
			AND A.PLAN_ID	    = B.PLAN_ID


			DELETE
			FROM   FP_IS_RUNNING_RELEASE_H
			WHERE  1=1
			AND    INSTANCE_ID  = @p_instance_id
			AND    RELEASE_TYPE = @p_factory_id
			AND    FP_PLAN_ID   = @p_plan_id

			--LOG 생성
			SET @v_message = 'Full RollBack by Error - Plan Group'
			SET @n_log_count = @n_log_count + 1
			EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'DELETE', @n_log_count, @v_log_code, @v_message, null

		END
		-- * ui 락만 해제
		-- (활성화 아닐때) MES_TRANSFER_FLAG = 'Y' 일때
		-- (활성화 일때) RELEASE_FLAG = 'Y' 일때
		ELSE IF (CHARINDEX('FORM', @V_MASTER_ID) = 0 AND @v_catch_mesTrans = 'Y') OR (CHARINDEX('FORM', @V_MASTER_ID) > 0 AND @v_catch_release = 'Y')
		BEGIN
			
			DELETE
			FROM   FP_IS_RUNNING_RELEASE_H
			WHERE  1=1
			AND    INSTANCE_ID  = @p_instance_id
			AND    RELEASE_TYPE = @p_factory_id
			AND    FP_PLAN_ID   = @p_plan_id

			--LOG 생성
			SET @v_message = 'RollBack by Error - Plan Group'
			SET @n_log_count = @n_log_count + 1
			EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'DELETE', @n_log_count, @v_log_code, @v_message, null

		END

	END
*/

	commit;

  END CATCH

  SET @n_log_count = @n_log_count + 1
  EXEC PR_LOG_PROCESS @sysdate, @v_master_id, @v_plan_id, @v_proc_name, null, 'END', 999999, null, '############### End of procedure ###############', null

  EXEC PR_XIF_LOG @v_proc_name, NULL, 'END',   999999, @v_temp1, '############### End of procedure ###############', NULL, @sysdate

END

