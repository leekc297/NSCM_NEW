
/*
 * Program ID   : PR_SCP_PLN_FP_PROD_TARGET 
 * Description  : FP 생산TARGET 전송
 * OutTable     :
 * Execute      : EXEC PR_SCP_PLN_FP_PROD_TARGET
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018.03.20   YYDOK         Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018.03.28   YYDOK         SCP_PLN_PROD_PLAN_TARGET_V 적용(FP,MRP용 생산타겟이 동일한 데이타를 처리)
 * 2018.06.11   YYDOK         FINAL CONFIRM시 FP로 타겟전송 추가 
 * 2018.07.03   YYDOK         ORIGIN_DIVISION_ID ADD
 * 2018.10.10   YYDOK         해당주차 FP TARGET INTERFACE YN (인터페이스해야할지 여부) 체크로직추가
 * 2020.10.08   KSW           프로시저 수행 마지막에 Target 전송 이상유무를 체크하는 프로시저를 호출한다.
 * 2023.02.28   KSG           PJ20230691R  LGES SCM 역량 강화 위한 SCP 개선과제 이행 : 소형 Pre FP 전송 추가로 PR도 수행
 * 2023.06.27   KSG           E20230622-000951 [SCM/물류 PI팀] 폴란드 법인 FP/RTS 시스템 분리 구축에 따른 I/F개발요청
 * 2025.12.17   kimcd         [PJ2025F254]  JV법인 ESS 혼용 생산 시스템 개선
 *                            JV ESS 생산에 따른 가상 Plant 계획 정보를 JV에 생산 Target으로 전송
 *                            가상 라인 계획은 FP로 전송하는 대상에서 제외
 */
 
CREATE PROCEDURE [dbo].[PR_SCP_PLN_FP_PROD_TARGET]
    ( 
      @p_division_id          NVARCHAR(10)
    , @p_start_yyyymmdd       NVARCHAR(8)
    , @p_plan_type            NVARCHAR(40)
    , @p_seq                  INT
    , @p_user_id              NVARCHAR(100)
) AS
  BEGIN
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    SET ANSI_WARNINGS OFF;

    -- LOG 용 변수 설정
    DECLARE @v_batch_user   NVARCHAR(150) = N'';  
    SET     @v_batch_user = @p_user_id
    DECLARE @v_program_name NVARCHAR(150) = N'PR_SCP_PLN_FP_PROD_TARGET';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);      
    DECLARE @v_table_id     NVARCHAR(150) = N'SCM_SYS_LOG_BATC'; 
    DECLARE @d_event_date   DATETIME;
    DECLARE @n_data_count   INTEGER = 0; -- 20230627 E20230622-000951

        ----------------------------------------------------------- 
        -- 0. validation
        -- PLAN_TYPE='MA'/'FN', CONFIRM된 경우에 처리함.
        -- 20230228  PJ20230691R  소형 Pre FP 전송 추가로 PR도 수행 추가
        -----------------------------------------------------------
        IF @p_plan_type NOT IN ( 'PR', 'MA','FN')
           BEGIN
              RETURN;
           END

        ----------------------------------------------------------
        -- 해당주차 SCP자동으로 수행하여 인터페이스 안내리도록
        -- SCP_PLN_INTERFACE_YN에 N으로 셋팅시 수행안함.
        ----------------------------------------------------------
        DECLARE @X_FP_TARGET_YN NVARCHAR(1) = 'Y';
        DECLARE @X_MRP_TARGET_YN NVARCHAR(1) = 'Y';

        SELECT @X_FP_TARGET_YN =  ISNULL(FP_TARGET_YN,'Y'),
               @X_MRP_TARGET_YN =  ISNULL(MRP_TARGET_YN,'Y')
          FROM SCP_PLN_INTERFACE_YN WITH(NOLOCK)
         WHERE DIVISION_ID         = @p_division_id 
           AND PLAN_START_YYYYMMDD = DBO.FN_GET_BUCKET_YYYYMMDD(0);

        IF @X_FP_TARGET_YN = 'N'
           BEGIN
              RETURN;
           END

  -- 시작 LOG
    SET @v_log_type = N'START';
    SET @v_log_message = N'########## Start of procedure ##########';
    SET @v_description = @v_program_name + ':'  + @p_division_id;
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH_CALL_TRAN  @p_program_name  =@v_program_name
                              ,@p_log_type      =@v_log_type
                              ,@p_log_count     =@n_log_count 
                              ,@p_log_message   =@v_log_message 
                              ,@p_description   =@v_description 
                              ,@p_event_date    =@d_event_date 
                              ;
    
    BEGIN TRY
      BEGIN
    
     --   BEGIN TRANSACTION; 
           
        IF @p_user_id IS NULL 
           BEGIN
              SET @p_user_id = 'SCP';
           END                

        ----------------------------------------------------------- 
        -- 1. interface data creation
        -----------------------------------------------------------        

            DECLARE @X_START_YYYYMMDD       NVARCHAR(8);
            DECLARE @X_CNT                  INT           = 0;
            DECLARE @X_SEND_SEQ             INT           = 1;
            
            --DECLARE @X_IF_TYPE              NVARCHAR(1)   = 'I';
            DECLARE @X_IF_ID                NVARCHAR(50)  = 'OSCP_OFP0_FP_PROD_TARGET';
            --DECLARE @X_IF_INS_DATE          DATETIME      = GETDATE();
            --DECLARE @X_IF_FLAG              NVARCHAR(100)  = 'N';
            --DECLARE @X_IF_SND_DATE          NVARCHAR(100)  = NULL;
            
            DECLARE @X_IF_RCV_DATE          DATETIME       = GETDATE();
            DECLARE @X_PROC_FLAG            NVARCHAR(1)     = 'N';
            DECLARE @X_PROC_DATE            DATETIME       =  NULL;
            DECLARE @X_PLAN_TYPE            NVARCHAR(40)    = @p_plan_type;
            DECLARE @X_PLAN_WEEK            NVARCHAR(12);
            
            DECLARE @X_TARGET_ID            NVARCHAR(200);
            DECLARE @X_ITEM_ID              NVARCHAR(40);
            DECLARE @X_OPERATION_GROUP      NVARCHAR(40);
            DECLARE @X_OPERATION_ID         NVARCHAR(40);            
            DECLARE @X_SITE_CODE            NVARCHAR(40);
            DECLARE @X_PLANT_ID             NVARCHAR(40);
            DECLARE @X_PROD_WEEK            NVARCHAR(8);
            DECLARE @X_YYYYMMDD             NVARCHAR(8);
            DECLARE @X_PROD_QTY             DECIMAL(18,3);
            DECLARE @X_ORDER_TYPE           NVARCHAR(40);
            DECLARE @X_PRODUCTION_LINE      NVARCHAR(40);
            DECLARE @X_PRIORITY             NVARCHAR(200);
            DECLARE @X_DIVISION             NVARCHAR(10);
            DECLARE @X_MARKET               NVARCHAR(10);
            DECLARE @X_CREATE_USER_ID       NVARCHAR(50);
            DECLARE @X_CREATE_DATE          DATETIME;
            DECLARE @X_MODIFY_USER_ID       NVARCHAR(50);
            DECLARE @X_MODIFY_DATE          DATETIME;

            --2025.12.17 kimcd [PJ2025F254] JV법인 ESS 혼용 생산 시스템 개선 임시 테이블 추가 시작
			DECLARE @v_from_division_id    NVARCHAR(30); -- 다른 사업부 계회 참조 필요성 점검
			--작업용 임시테이블 생성
			IF OBJECT_ID('tempdb..#Tbl_FP_PLAN') IS NOT NULL
			  DROP TABLE #Tbl_FP_PLAN
			CREATE TABLE #Tbl_FP_PLAN (
			   	[TARGET_ID] [nvarchar](200),
				[ITEM_ID] [nvarchar](40),
				[OPERATION_GROUP] [nvarchar](40),
				[OPERATION_ID] [nvarchar](20),
				[SITE_CODE] [nvarchar](40),
				[PLANT_ID] [nvarchar](40),
				[PROD_WEEK] [nvarchar](8),
				[YYYYMMDD] [nvarchar](8),
				[PROD_QTY] [numeric](18, 3),
				[ORDER_TYPE] [nvarchar](40),
				[PRODUCTION_LINE] [nvarchar](40),
				[PRIORITY] [nvarchar](200),
				[DIVISION] [nvarchar](10),
				[MARKET] [nvarchar](10),
				[CREATE_USER_ID] [nvarchar](50),
				[CREATE_DATE] [datetime],
				[MODIFY_USER_ID] [nvarchar](50),
				[MODIFY_DATE] [datetime],
				[ORIGIN_DIVISION_ID] [nvarchar](50)
				);
			--2025.12.17 kimcd [PJ2025F254] JV법인 ESS 혼용 생산 시스템 개선 임시 테이블 추가 종료
      
            IF LEN(ISNULL(@P_START_YYYYMMDD,'')) = 8 
               BEGIN            
                    SET @X_START_YYYYMMDD = @P_START_YYYYMMDD;  
               END     
            ELSE
               BEGIN
                    SET @X_START_YYYYMMDD = DBO.FN_GET_BUCKET_YYYYMMDD(0);
               END
            
            SELECT @X_CNT = COUNT(1)
              FROM DBO.SCP_PLN_INTERFACE_SEND_H WITH(NOLOCK)
             WHERE PLAN_START_YYYYMMDD = @X_START_YYYYMMDD
               AND DIVISION_ID         = @P_DIVISION_ID
               --AND PLAN_TYPE           = @P_PLAN_TYPE
               AND IF_ID               = @X_IF_ID;   
      
            IF (@X_CNT > 0)
               BEGIN
                    SELECT @X_CNT = MAX(IFSEQNO)
                      FROM DBO.SCP_PLN_INTERFACE_SEND_H WITH(NOLOCK)
                     WHERE PLAN_START_YYYYMMDD = @X_START_YYYYMMDD
                       AND DIVISION_ID         = @P_DIVISION_ID
                       --AND PLAN_TYPE           = @P_PLAN_TYPE
                       AND IF_ID               = @X_IF_ID;  
                       
                    SET @X_SEND_SEQ = @X_CNT +1;    
               
               END
      
            -- 전송주차 = 해당주차의 월요일 일자 YYYYMMDD + '001' 일련번호
            SET @X_PLAN_WEEK = @X_START_YYYYMMDD + '_' + DBO.FN_ZERO_LPAD( @X_SEND_SEQ,3 );
      
            BEGIN
			    -- 2025.12.17 kimcd [PJ2025F254] JV법인 ESS 혼용 생산 시스템 개선 추가 시작
				SELECT  TOP 1 @v_from_division_id = MS2.DIVISION_ID
				FROM    SCM_MST_SITE MS WITH(NOLOCK)
						INNER JOIN SCM_MST_SITE MS2 WITH(NOLOCK)
							ON MS.SCM_SITE_ID = MS2.ATTRIBUTE9
				WHERE   MS.DIVISION_ID = @p_division_id
				AND     MS.SITE_TYPE   = 'PLANT'
				AND     MS.VALID_YN    = 'Y';

				IF @v_from_division_id > ''
				    BEGIN
						SET @v_log_type = N'LOG';
						SET @v_log_message = N'########## make temp plan ##########';
						SET @v_description = @v_program_name + ':'  + N' make temp plan ';
						SET @d_event_date = SYSDATETIME();
						EXEC PR_SCM_SYS_LOG_BATCH_CALL_TRAN  @p_program_name  =@v_program_name
												  ,@p_log_type      =@v_log_type
												  ,@p_log_count     =@n_log_count 
												  ,@p_log_message   =@v_log_message 
												  ,@p_description   =@v_description 
												  ,@p_event_date    =@d_event_date 
												  ;

						WITH PLAN_SEQ AS (  SELECT PLAN_NAME, PLAN_SEQ, PLAN_TYPE, MASTER_ID, ENGINE_PLAN_ID, DIVISION_ID
											FROM  (SELECT PM.PLAN_NAME, PD.PLAN_SEQ, PD.PLAN_TYPE, PM.DIVISION_ID+'::'+ PM.PLAN_CYCLE AS MASTER_ID, PM.PLAN_ID + '::' + PD.PLAN_TYPE + '::' + CONVERT(NVARCHAR(30),PD.PLAN_SEQ)  AS ENGINE_PLAN_ID
														 ,PM.DIVISION_ID
														 ,ROW_NUMBER() OVER (PARTITION BY PM.DIVISION_ID
																			 ORDER BY  CASE PD.PLAN_TYPE WHEN 'FN' THEN 1 WHEN 'SE' THEN 2 WHEN 'MA' THEN 3 WHEN 'PR' THEN 4 ELSE 5 END
																					  ,CASE WHEN PD.CONFIRM_FLAG = 'Y' THEN 1 ELSE 2 END
																					  ,PD.PLAN_SEQ DESC) AS NUM
													FROM   SCM_MST_PLAN        PM WITH(NOLOCK)
														   INNER JOIN SCM_MST_PLAN_DETAIL PD WITH(NOLOCK)
		   												       ON  PM.PLAN_ID     = PD.PLAN_ID
															   AND PM.DIVISION_ID = PD.DIVISION_ID
													WHERE  PM.DIVISION_ID        IN (	SELECT  MS2.DIVISION_ID
																						FROM    SCM_MST_SITE MS WITH(NOLOCK)
																								INNER JOIN SCM_MST_SITE MS2 WITH(NOLOCK)
																									ON MS.SCM_SITE_ID = MS2.ATTRIBUTE9  -- 실제 생산 Site가 Attribute9에 관리됨
																						WHERE   MS.DIVISION_ID = @p_division_id
																						AND     MS.SITE_TYPE   = 'PLANT'
																						AND     MS.VALID_YN    = 'Y')
													AND    PM.PLAN_NAME          = @p_start_yyyymmdd
													AND    PM.PLAN_CYCLE         = 'WEEKLY'
													AND    PD.PLAN_STATUS        = '1'
													AND    PD.DISPLAY_YN         = 'Y'
													AND    PD.UI_DISPLAY_YN      = 'Y'
													AND    PD.NORMAL_COMPLETE_YN = 'Y'
													AND    PD.ACTIVE_FLAG        = 'Y' ) TP
											WHERE NUM = 1 )
						INSERT INTO #Tbl_FP_PLAN
								( TARGET_ID
								, ITEM_ID           
								, OPERATION_GROUP   
								, OPERATION_ID      
								, SITE_CODE      
								, PLANT_ID
								, PROD_WEEK
								, YYYYMMDD
								, PROD_QTY
								, ORDER_TYPE
								, PRODUCTION_LINE
								, PRIORITY
								, DIVISION
								, MARKET
								, CREATE_USER_ID
								, CREATE_DATE
								, MODIFY_USER_ID
								, MODIFY_DATE
								, ORIGIN_DIVISION_ID
								)
						  SELECT  SUB.TARGET_ID
								, SUB.ITEM_ID           
								, SUB.OPERATION_GROUP   
								, SUB.OPERATION_ID   AS OPERATION     
								, MS2.SCM_SITE_ID    AS SITE_CODE      
								, MS2.PLANT_ID
								, SUB.PROD_WEEK
								, SUB.YYYYMMDD
								, SUB.PROD_QTY
								, SUB.FCST_TYPE      AS ORDER_TYPE
								, MS2.LINE_ID        AS PRODUCTION_LINE
								, SUB.PRIORITY
								, MS2.DIVISION_ID    AS DIVISION
								, SUB.MARKET
								, SUB.CREATE_USER_ID
								, SUB.CREATE_DATE
								, SUB.MODIFY_USER_ID
								, SUB.MODIFY_DATE
								, MS2.DIVISION_ID    AS ORIGIN_DIVISION_ID
						  FROM (  SELECT  TARGET_ID
										, ITEM_ID           
										, OPERATION_GROUP   
										, OPERATION_ID      
										, SITE_ID
										, PLANT_ID
										, PROD_WEEK
										, YYYYMMDD
										, PROD_QTY
										, FCST_TYPE
										, PRODUCTION_LINE
										, PRIORITY
										, X.DIVISION_ID
										, DOM_EXP              AS MARKET
										, CREATE_USER_ID
										, CREATE_DATE
										, MODIFY_USER_ID
										, MODIFY_DATE
										, ORIGIN_DIVISION_ID
									 FROM dbo.SCP_PLN_PROD_PLAN_TARGET_V X WITH(NOLOCK)
									   INNER JOIN PLAN_SEQ  PS
										   ON     X.division_id         = PS.DIVISION_ID
										   AND    X.plan_start_yyyymmdd = @p_start_yyyymmdd
										   AND    X.plan_type           = PS.PLAN_TYPE
										   AND    X.seq                 = PS.PLAN_SEQ
								) AS SUB
					  INNER JOIN ( SELECT LM.OPERATION_ID, LM.ELECTRODE_TYPE, MS.DIVISION_ID, MS.SCM_SITE_ID, LM.LINE_ID, LM.PLANT_ID
										 ,MS2.DIVISION_ID AS LINK_DIVISION_ID, MS2.SCM_SITE_ID AS LINK_SCM_SITE_ID, LM.LINK_LINE_ID
										 FROM   SCM_MST_SITE MS WITH(NOLOCK)
												INNER JOIN SCM_MST_SITE MS2 WITH(NOLOCK)
													ON MS.SCM_SITE_ID = MS2.ATTRIBUTE9  -- 실제 생산 Site가 Attribute9에 관리됨
												INNER JOIN SCM_MST_LINE_SN LM WITH(NOLOCK)
													ON  LM.PLANT_ID = MS.PLANT_ID
													AND LM.LINK_LINE_ID > ''
										WHERE   MS.DIVISION_ID = @p_division_id
										AND     MS.SITE_TYPE   = 'PLANT'
										AND     MS.VALID_YN    = 'Y'
										) MS2
								ON  SUB.DIVISION_ID     = MS2.LINK_DIVISION_ID
								AND SUB.SITE_ID         = MS2.LINK_SCM_SITE_ID
								AND SUB.OPERATION_ID    = MS2.OPERATION_ID
								AND SUB.PRODUCTION_LINE = MS2.LINK_LINE_ID
								;

						SET	@n_log_count = @@ROWCOUNT;
						SET @v_log_type = N'LOG';
						SET @v_log_message = N'########## END make temp plan ##########';
						SET @v_description = @v_program_name + ':'  + N' END make temp plan ';
						SET @d_event_date = SYSDATETIME();
						EXEC PR_SCM_SYS_LOG_BATCH_CALL_TRAN  @p_program_name  =@v_program_name
												  ,@p_log_type      =@v_log_type
												  ,@p_log_count     =@n_log_count 
												  ,@p_log_message   =@v_log_message 
												  ,@p_description   =@v_description 
												  ,@p_event_date    =@d_event_date 
												  ;
						SET @n_log_count = 0;
					END; -- IF @v_from_division_id > ''
					-- 2025.12.17 kimcd [PJ2025F254] JV법인 ESS 혼용 생산 시스템 개선 추가 끝

                /******************************************
                 * 생산타겟 송신용 테이블에 기록한다.
                 ******************************************/       
                 
                 
                 INSERT INTO XIF_SCP_PROD_TARGET_R_SN
                           ( IF_RCV_DATE      ,
                             PROC_FLAG        ,
                             PROC_DATE        ,
                             PLAN_TYPE        ,
                             PLAN_WEEK        ,
                             TARGET_ID        ,
                             ITEM_ID          ,
                             OPERATION_GROUP  ,
                             OPERATION_ID     ,
                             SITE_CODE        ,
                             PLANT_ID         ,
                             PROD_WEEK        ,
                             YYYYMMDD         ,
                             PROD_QTY         ,
                             ORDER_TYPE       ,
                             PRODUCTION_LINE  ,
                             PRIORITY         ,
                             DIVISION         ,
                             MARKET           ,
                             CREATE_USER_ID   ,
                             CREATE_DATE      ,
                             MODIFY_USER_ID   ,
                             MODIFY_DATE      ,
                             ATTR_01              --ORIGIN_DIVISION_ID
                            )
                  SELECT  @X_IF_RCV_DATE
                        , @X_PROC_FLAG
                        , @X_PROC_DATE
                        , @X_PLAN_TYPE
                        , @X_PLAN_WEEK
                        , TARGET_ID
                        , ITEM_ID           
                        , OPERATION_GROUP   
                        , OPERATION_ID      
                        , SITE_ID              AS SITE_CODE      
                        , PLANT_ID
                        , PROD_WEEK
                        , YYYYMMDD
                        , PROD_QTY
                        , FCST_TYPE            AS ORDER_TYPE
                        , PRODUCTION_LINE
                        , PRIORITY
                        , DIVISION_ID          AS DIVISION
                        , DOM_EXP              AS MARKET
                        , CREATE_USER_ID
                        , CREATE_DATE
                        , MODIFY_USER_ID
                        , MODIFY_DATE
                        , ORIGIN_DIVISION_ID
                     FROM dbo.SCP_PLN_PROD_PLAN_TARGET_V  X WITH(NOLOCK)
                    WHERE 1=1
                      AND DIVISION_ID              = @p_division_id  --'81'
                      AND PLAN_START_YYYYMMDD      = @p_start_yyyymmdd  --'20180319'
                      AND PLAN_TYPE                = @p_plan_type    --'MA'
                      AND SEQ                      = @p_seq          --11
					  -- 2025.12.17 kimcd [PJ2025F254] JV법인 ESS 혼용 생산 시스템 개선 추가 시작
					  AND NOT EXISTS (SELECT TOP 1 1
									  FROM   SCM_MST_LINE_SN ML WITH(NOLOCK)
									  WHERE  ML.DIVISION_ID  = X.DIVISION_ID
									  AND    ML.OPERATION_ID = X.OPERATION_ID
									  AND    ML.PLANT_ID     = X.PLANT_ID
									  AND    ML.LINE_ID      = X.PRODUCTION_LINE
									  AND    ML.ACTIVE_FLAG  = 'Y'
									  AND    ML.VIRTUAL_LINE_YN = 'Y'
									  AND    ML.LINK_LINE_ID > '' )
				  UNION ALL
                  SELECT  @X_IF_RCV_DATE
                        , @X_PROC_FLAG
                        , @X_PROC_DATE
                        , @X_PLAN_TYPE
                        , @X_PLAN_WEEK
                        , TARGET_ID
						, ITEM_ID           
						, OPERATION_GROUP   
						, OPERATION_ID      
						, SITE_CODE      
						, PLANT_ID
						, PROD_WEEK
						, YYYYMMDD
						, PROD_QTY
						, ORDER_TYPE
						, PRODUCTION_LINE
						, PRIORITY
						, DIVISION
						, MARKET
						, CREATE_USER_ID
						, CREATE_DATE
						, MODIFY_USER_ID
						, MODIFY_DATE
						, ORIGIN_DIVISION_ID
                     FROM #Tbl_FP_PLAN WITH(NOLOCK)
                    WHERE 1=1
					  -- 2025.12.17 kimcd [PJ2025F254] JV법인 ESS 혼용 생산 시스템 개선 추가 끝
                   ;       
               
			     SET @n_data_count = @@ROWCOUNT; -- 20230627 E20230622-000951  IF Data 건수 전송용

                /******************************************
                 * 인터페이스 전송이력  테이블에 기록한다.
                 ******************************************/                                           
      
                INSERT INTO DBO.SCP_PLN_INTERFACE_SEND_H
                           ( PLAN_START_YYYYMMDD
                           , DIVISION_ID
                           , PLAN_TYPE
                           , IF_ID
                           , IFSEQNO
                           , CREATED_BY
                           , CREATION_DATE )
                           VALUES
                           (  
                             @X_START_YYYYMMDD
                           , @P_DIVISION_ID
                           , @P_PLAN_TYPE
                           , @X_IF_ID
                           , @X_SEND_SEQ
                           , @P_USER_ID
                           , GETDATE()    
                           );
               
            END    
      
        ----------------------------------------------------------- 
        -- 9. 종료 처리
        -----------------------------------------------------------

     --   IF @@TRANCOUNT > 0 
     --     BEGIN
     --        COMMIT WORK;
                                       
     --     END;

		--2025.12.17 kimcd [PJ2025F254] JV법인 ESS 혼용 생산 시스템 개선 임시 테이블 추가 시작
		--작업용 임시테이블  DROP
		IF OBJECT_ID('tempdb..#Tbl_FP_PLAN') IS NOT NULL
			DROP TABLE #Tbl_FP_PLAN
		--2025.12.17 kimcd [PJ2025F254] JV법인 ESS 혼용 생산 시스템 개선 임시 테이블 추가 종료
        -----------------------------------------------------------
        -- 실행 Logic END --
        -----------------------------------------------------------

        -- TXN LOG
        SET @v_log_type = N'TXN';    
        SET @n_log_count = @n_data_count;
        SET @v_log_message = N'INSERT INTO '+@v_table_id;
        SET @v_description = N'Process Complete...' + ':' + CONVERT(CHAR(8), @d_event_date, 112) + ':'  + @p_division_id;
        SET @d_event_date = SYSDATETIME();

        EXEC PR_SCM_SYS_LOG_BATCH_CALL_TRAN  @p_program_name  =@v_program_name
                                  ,@p_log_type      =@v_log_type
                                  ,@p_log_count     =@n_log_count 
                                  ,@p_log_message   =@v_log_message 
                                  ,@p_description   =@v_description 
                                  ,@p_event_date    =@d_event_date 
                                  ;

      END;

    END TRY

    BEGIN CATCH
        
   --   IF @@TRANCOUNT > 0 
   --     BEGIN
   --       ROLLBACK;
   --     END;

      -- ERROR LOG
      SET @v_log_type = N'ERROR';
      SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
      SET @v_description = N'ERROR_LINE : ' + STR(ERROR_LINE()) + ':'  + @p_division_id;
      SET @d_event_date = SYSDATETIME();
      EXEC PR_SCM_SYS_LOG_BATCH_CALL_TRAN  @p_program_name  =@v_program_name
                                ,@p_log_type      =@v_log_type
                                ,@p_log_count     =@n_log_count 
                                ,@p_log_message   =@v_log_message 
                                ,@p_description   =@v_description 
                                ,@p_event_date    =@d_event_date 
                                ;

      return -1 
    END CATCH;

    -- 종료 LOG
    SET @v_log_type = N'END';
    SET @v_log_message = N'########## END of procedure ##########';
    SET @v_description = @p_division_id;
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH_CALL_TRAN  @p_program_name  =@v_program_name
                              ,@p_log_type      =@v_log_type
                              ,@p_log_count     =@n_log_count 
                              ,@p_log_message   =@v_log_message 
                              ,@p_description   =@v_description 
                              ,@p_event_date    =@d_event_date 
                              ;

    ----------------------------------------------------------- start
	-- 2020.10.08   KSW :: 프로시저 수행 마지막에 Target 전송 이상유무를 체크하는 프로시저를 호출한다.
	-----------------------------------------------------------
	EXEC PR_SCP_PLN_IF_CHECK_SMS_SEND @p_division_id, @p_plan_type, 'FP_PROD' ;
	----------------------------------------------------------- end
	
    ----------------------------------------------------------- start
	-- 20230627 E20230622-000951 [SCM/물류 PI팀] 폴란드 법인 FP/RTS 시스템 분리 구축에 따른 I/F개발요청 
	--     법인 FP/RTS 시스템용 Target 전송
	-----------------------------------------------------------
    SET @v_log_type = N'START';
    SET @v_log_message = N'########## Start : 법인 FP/RTS 시스템용 Target 전송 ##########';
    SET @v_description = @v_program_name + ':'  + @p_division_id;
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH_CALL_TRAN  @p_program_name  =@v_program_name
                              ,@p_log_type      =@v_log_type
                              ,@p_log_count     =@n_log_count 
                              ,@p_log_message   =@v_log_message 
                              ,@p_description   =@v_description 
                              ,@p_event_date    =@d_event_date 
                              ;
    
    BEGIN TRY
      BEGIN

          DELETE XIF_FP_SCP_PROD_TARGET_S_SN
          WHERE  division  = @p_division_id
          AND    plan_type = @X_PLAN_TYPE
          AND    plan_week = @X_PLAN_WEEK;

          INSERT INTO XIF_FP_SCP_PROD_TARGET_S_SN
               (if_seq
	          , if_type
	          , if_id
	          , if_ins_date
	          , if_flag
              , if_snd_date
	          , plan_type, plan_week, target_id, item_id, operation_group, operation_id, site_code, plant_id
	          , prod_week, yyyymmdd, prod_qty, order_type, production_line, priority, division, market
	          , create_user_id, create_date, modify_user_id, modify_date
	          , gnrt_dttm
              , accum_count
	          , attr_01, attr_02, attr_03, attr_04, attr_05, attr_06, attr_07, attr_08, attr_09, attr_10
               )
          SELECT 'OFP0' + SUBSTRING(CONVERT(NVARCHAR(12), GETDATE(), 112), 3,6)
                        + REPLICATE('0', 10 - LEN(NEXT VALUE FOR XIF_FP_SEND_SEQ))
                        + CAST( NEXT VALUE FOR XIF_FP_SEND_SEQ AS NVARCHAR)         AS if_seq
	          , 'S'                    AS if_type
	          , 'OSCM_PFP0_SCP_TARGET' AS if_id
	          , GETDATE()              AS if_ins_date
	          , 'N'                    AS if_flag
	          , GETDATE()              AS if_snd_date
	          , plan_type, plan_week, target_id, item_id, operation_group, operation_id, site_code, plant_id
	          , prod_week, yyyymmdd, prod_qty, order_type, production_line, priority, division, market
	          , create_user_id, create_date, modify_user_id, modify_date
	          , create_date   AS gnrt_dttm    -- 추출 시간
	          , @n_data_count AS accum_count  -- IF Data 건수
	          , attr_01, attr_02, attr_03, attr_04, attr_05, attr_06, attr_07, attr_08, attr_09, attr_10
          FROM   XIF_SCP_PROD_TARGET_R_SN a WITH(NOLOCK)
          WHERE  a.division  = @p_division_id
          AND    a.plan_type = @X_PLAN_TYPE
          AND    a.plan_week = @X_PLAN_WEEK;
                 
          SET @n_log_count = @@ROWCOUNT;

      END;
    END TRY

    BEGIN CATCH

      -- ERROR LOG
      SET @v_log_type = N'ERROR';
      SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
      SET @v_description = N'ERROR_LINE : ' + STR(ERROR_LINE()) + ':'  + @p_division_id;
      SET @d_event_date = SYSDATETIME();
      EXEC PR_SCM_SYS_LOG_BATCH_CALL_TRAN  @p_program_name  =@v_program_name
                                ,@p_log_type      =@v_log_type
                                ,@p_log_count     =@n_log_count 
                                ,@p_log_message   =@v_log_message 
                                ,@p_description   =@v_description 
                                ,@p_event_date    =@d_event_date 
                                ;

      return -1 
    END CATCH;

    -- 종료 LOG
    SET @v_log_type = N'END';
    SET @v_log_message = N'########## END : 법인 FP/RTS 시스템용 Target 전송 ##########';
    SET @v_description = @p_division_id;
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH_CALL_TRAN  @p_program_name  =@v_program_name
                              ,@p_log_type      =@v_log_type
                              ,@p_log_count     =@n_log_count 
                              ,@p_log_message   =@v_log_message 
                              ,@p_description   =@v_description 
                              ,@p_event_date    =@d_event_date 
                              ;


    return 1  


  END;
