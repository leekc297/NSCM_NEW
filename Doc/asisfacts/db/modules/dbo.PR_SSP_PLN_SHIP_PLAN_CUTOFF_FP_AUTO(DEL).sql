

/*
 * Program ID   : PR_SSP_PLN_SHIP_PLAN_CUTOFF_FP_AUTO
 * Description  : PACK 전용 (SCP 에서 받는 REQ정보 대신 FP 에서 받는 PLAN으로 출하계획 생성
 * OutTable     :
 * Execute      : 
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2026.06.09   강주용         
 */
CREATE PROCEDURE [dbo].[PR_SSP_PLN_SHIP_PLAN_CUTOFF_FP_AUTO]
AS
  BEGIN
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
  --  SET ANSI_WARNINGS OFF;


    -- LOG 용 변수 설정
    DECLARE @v_batch_user   NVARCHAR(150) = N'ssp_batch';  

    DECLARE @v_program_name NVARCHAR(150) = N'PR_SSP_PLN_SHIP_PLAN_CUTOFF_FP_AUTO';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);      -- ▶ 상세설명 
    DECLARE @v_table_id     NVARCHAR(150) = N'PR_SSP_PLN_SHIP_PLAN_CUTOFF_FP_AUTO'; -- ▶ 테이블 필수
    DECLARE @d_event_date   DATETIME;

  -- 시작 LOG
    SET @v_log_type = N'START';
    SET @v_log_message = N'########## Start of procedure ##########';
    SET @v_description = @v_program_name + ':' + N' SHIP_REQ INSERT LOGIC';
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  =@v_program_name
                              ,@p_log_type      =@v_log_type
                              ,@p_log_count     =@n_log_count 
                              ,@p_log_message   =@v_log_message 
                              ,@p_description   =@v_description 
                              ,@p_event_date    =@d_event_date 
                              ,@p_user_id       =@v_batch_user
                              ;
    -- 임시 실행시간 확인용
    DECLARE @v_start_time   DATETIME     = SYSDATETIME();
    DECLARE @v_exec_time    NVARCHAR(10) = ''--'[00:00]';
	DECLARE @v_sms_desc     NVARCHAR(4000);

	DECLARE @v_division_id    NVARCHAR(30) = '';
	DECLARE @erp_stock_cnt    INT = 0;	
	DECLARE @owms_stock_cnt   INT = 0;	
	DECLARE @owms_org_stock_cnt   INT = 0;	
	DECLARE @stock_cnt   INT = 0;	

	DECLARE @v_company_desc  NVARCHAR(50) = '';
	DECLARE @v_t_company_id  NVARCHAR(50) = '';
 


    BEGIN TRY
      BEGIN
        BEGIN TRAN TX_SH

			--CURSOR 선언 
			DECLARE @company_id VARCHAR(30), 
			        @plan_start_yyyymmdd VARCHAR(8),  
					@cutoff_date VARCHAR(30), 
					@erp_stock_cutoff_yn VARCHAR(30), 
					@owms_stock_cutoff_yn VARCHAR(30), 
					@current_plan_date_yn VARCHAR(30), 
					@plan_cutoff_create_yn VARCHAR(30)

			DECLARE @idx INT     SET     @idx = 0 


			DECLARE CUR_PLAN_S CURSOR FOR  

			SELECT COMPANY_ID 
			     , PLAN_START_YYYYMMDD   AS PLAN_START_YYYYMMDD 
			     , CONVERT(char(8), DATEADD(DD, -1, CONVERT(DATETIME, PLAN_START_YYYYMMDD ,112)), 112)  AS CUTOFF_DATE 
			     , ERP_STOCK_CUTOFF_YN
			     , OWMS_STOCK_CUTOFF_YN
			     , CURRENT_PLAN_DATE_YN
			     , PLAN_CUTOFF_CREATE_YN
			  FROM SSP_MST_SHIP_PLAN_SCHEDULE  WITH(NOLOCK) 
			 WHERE 1 = 1
			   AND PLAN_START_YYYYMMDD = '20260624'--테스트용
			   --AND PLAN_START_YYYYMMDD = CONVERT(NVARCHAR, GETDATE(), 112) --운영용
			   --AND PLAN_START_YYYYMMDD = ( SELECT MIN(PLAN_START_YYYYMMDD) 
						--				   FROM  SSP_MST_SHIP_PLAN_SCHEDULE  WITH(NOLOCK) 
						--				   WHERE CURRENT_PLAN_DATE_YN = 'N'
						--				  )  
			   --AND CURRENT_PLAN_DATE_YN = 'N'
			   AND COMPANY_ID IN ( 'MI00' )--'MI00',
            ;

			OPEN CUR_PLAN_S; 

			FETCH NEXT FROM CUR_PLAN_S INTO @company_id, 
			                                @plan_start_yyyymmdd, 
											@cutoff_date,
											@erp_stock_cutoff_yn,
											@owms_stock_cutoff_yn,
											@current_plan_date_yn,
											@plan_cutoff_create_yn

				WHILE(@@FETCH_STATUS = 0) 
																																																																																																																																																													BEGIN; 
				--Idx 1씩 증가 
				SET @idx = @idx + 1 

				    -- 법인별 ERP 재고 생성 여부 확인 
					SELECT @erp_stock_cnt = COUNT(*) 
					FROM   SCM_DNM_STOCK_V WITH(NOLOCK)
					WHERE  CUTOFF_DATE = @cutoff_date -- '20190825'
					AND    COMPANY_ID  = @company_id --'G480'
					AND    STOCK_TYPE  = 'INVENTORY'
					;
					---- 2020.12.17 : ERP I/F 와 OWMS I/F 시간 불일치로 인한 긴급적용
					--SELECT @owms_org_stock_cnt = COUNT(*)
					--FROM SSP_DNM_OWMS_STOCK O WITH(NOLOCK) 
					--		JOIN SCM_MST_SITE S WITH(NOLOCK) 
					--		ON S.SITE_TYPE   = 'PLANT' 
					--		AND S.DIVISION_ID = O.DIVISION_ID
					--		AND S.PLANT_ID    = O.PLANT_ID
					--		AND S.COMPANY_ID  = @company_id
					--		AND O.CUTOFF_DATE = @cutoff_date		-- [C20200601-000370] CUTOFF DATE 조건 추가
					--		AND S.OPERATION_GROUP = CASE WHEN  S.OPERATION_GROUP = 'W' THEN 'W'
					--                                        ELSE  DBO.FN_GET_ITEM_OPERATION_GROUP(O.DIVISION_ID,O.ITEM_ID) END 
					--WHERE  1 = 1
					--;

					SELECT @stock_cnt = CASE WHEN A.TOT_CNT <> B.PASS_CNT THEN 1 ELSE 0 END
					FROM   (
							SELECT COUNT(*)  AS TOT_CNT
							FROM   SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
							WHERE  1 = 1
							AND    LOOKUP_TYPE = 'IF_STOCK_CHECK'
							AND    VALID_YN    = 'Y'
							AND    SEGMENT1    = 'PLAN_AUTO'
							AND    SEGMENT3    = '81_82'
							AND    SEGMENT4    = @company_id
						   ) A
						   LEFT OUTER JOIN 
						   (
							SELECT COUNT(*)  AS PASS_CNT
							FROM   SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
							WHERE  1 = 1
							AND    LOOKUP_TYPE = 'IF_STOCK_CHECK'
							AND    VALID_YN    = 'Y'
							AND    SEGMENT1    = 'PLAN_AUTO'
							AND    SEGMENT3    = '81_82'
							AND    SEGMENT4    = @company_id
							AND    SEGMENT5    = CONVERT(CHAR(8), GETDATE(), 112)
							AND    ATTRIBUTE1  = 'Y'
						   ) B
						   ON   1 = 1
					WHERE  1 = 1
					;
					set @erp_stock_cnt = 1 --- 수동작업시 설정/ 배포시 주석처리해야함.
					--IF @erp_stock_cnt > 0 AND @owms_org_stock_cnt > 0  -- ERP 재고 있을 경우 oWMS 재고 CUTOFF생성 START
					IF @erp_stock_cnt > 0 AND @stock_cnt = 0 -- ERP 재고 있을 경우 oWMS 재고 CUTOFF생성 START

					   BEGIN


							SELECT @v_company_desc = SEGMENT2 
							FROM SCM_ADM_LOOKUP_MASTER_DETAIL L WITH(NOLOCK)
							WHERE L.LOOKUP_TYPE = 'COMPANY_DESC' -- LOOKUP에 등록된 SSP TYPE 
							AND L.VALID_YN = 'Y'
							AND L.SEGMENT1 = @company_id
							;

							SET @v_t_company_id =  @company_id ; -- error SMS 발송용
							-----------------------------------------------------------	
							-- SMS 전송 : Daily Plan Cutoff End Message Start (56)
							--56 Daily Plan Cutoff Start 
							--57 Daily Plan Cutoff Error 
							--58 Daily Plan Cutoff End 
							-----------------------------------------------------------
							--SET @v_sms_desc = @company_id +':'+@v_company_desc +':';
 							--EXEC SCM_ADM_SMS_SEND_BATCH 56, @v_sms_desc;

							--UPDATE SSP_MST_SHIP_PLAN_SCHEDULE(ERP_STOCK_CUTOFF_YN)
							UPDATE SSP_MST_SHIP_PLAN_SCHEDULE
							SET    ERP_STOCK_CUTOFF_YN   = 'Y'
							,      CREATION_DATE      = GETDATE()
							,      CREATED_BY         = @v_batch_user
							WHERE COMPANY_ID = @company_id
							AND   PLAN_START_YYYYMMDD   = @plan_start_yyyymmdd
							;


					        ---------------------------------------------------------------------------   
							--법인별 OWMS 재고CUFOFF DATA 생성 (SSP_ANL_OWMS_STOCK_C2) 
							--ERP 재고는 CUTOFF DATA 생성 불필요(SCM_DNM_STOCK_V 사용)   
							---------------------------------------------------------------------------  
							--SELECT @owms_stock_cnt = COUNT(*) 							
							--FROM  SSP_ANL_OWMS_STOCK_C2 
							--WHERE CUTOFF_DATE = @cutoff_date
							--AND   PLAN_START_YYYYMMDD = @plan_start_yyyymmdd
							--AND   COMPANY_ID = @company_id
							--;


--							IF @owms_stock_cnt < 1  -- 기존 생성된 정보가 없으면  

--								BEGIN

--									DELETE 
--									FROM  SSP_ANL_OWMS_STOCK_C2 
--									WHERE CUTOFF_DATE = @cutoff_date
--									AND   PLAN_START_YYYYMMDD = @plan_start_yyyymmdd
--									AND   COMPANY_ID = @company_id
--									; 
                             
--									INSERT INTO SSP_ANL_OWMS_STOCK_C2 (
--									 CUTOFF_DATE
--									,DIVISION_ID
--									,COMPANY_ID
--									,PLAN_START_YYYYMMDD 
--									,FROM_SITE
--									,ITEM_ID
--									,PALLET_ID
--									,STOCK_QTY
--									,AVAILABLE_QTY
--									,AVAILABLE_QTY_ORIGIN
--									,NON_QC_QTY
--									,ALLOCATION_QTY
--									,BLOCK_QTY
--									,PACKING_QTY
--									,MOVING_QTY
--									,RCVLOC_QTY
--									,EXPIRATION_QTY
--									,LONG_QTY
--									,PROD_GROUP
--									,LOT_ID
--									,PLANT_ID
--									,GRADE
--									,PACKING_STATUS
--									,STOCK_STATUS
--									,STORAGE_ID
--									,CUSTOMER_CODE
--									,CUSTOMER_NAME
--									,LOT_DATE
--									,SOC
--									,CAPACITY_GRADE
--									,ORIGIN_FROM_DIVISION_ID
--									,CREATED_BY
--									,CREATION_DATE
--									,LAST_UPDATED_BY
--									,LAST_UPDATE_DATE
--									) 
--									SELECT 
--									 @cutoff_date  AS CUTOFF_DATE  
--									,O.DIVISION_ID
--									,S.COMPANY_ID
--									,@plan_start_yyyymmdd
--                                     -- OWMS Cutoff재고에 Warranty plant(A002) 적용
--									,CASE WHEN S.OPERATION_GROUP = 'W' THEN S.SCM_SITE_ID 
--			                              ELSE  [dbo].[FN_GET_SCM_SITE_ID_PLANT](O.PLANT_ID, [dbo].[FN_GET_ITEM_OPERATION_GROUP](O.DIVISION_ID, O.ITEM_ID))   END 
--									,O.ITEM_ID
--									,O.PALLET_ID
--									,O.STOCK_QTY
--									,O.AVAILABLE_QTY
--									,O.AVAILABLE_QTY_ORIGIN
--									,O.NON_QC_QTY
--									,O.ALLOCATION_QTY
--									,O.BLOCK_QTY
--									,O.PACKING_QTY
--									,O.MOVING_QTY
--									,O.RCVLOC_QTY
--									,O.EXPIRATION_QTY
--									,O.LONG_QTY
--									,O.PROD_GROUP
--									,O.LOT_ID
--									,O.PLANT_ID
--									,O.GRADE
--									,O.PACKING_STATUS
--									,O.STOCK_STATUS
--									,O.STORAGE_ID
--									,O.CUSTOMER_CODE
--									,O.CUSTOMER_NAME
--									,O.LOT_DATE
--									,O.SOC
--									,O.CAPACITY_GRADE
--									,O.ORIGIN_FROM_DIVISION_ID
--									,O.CREATED_BY
--									,O.CREATION_DATE
--									,'ssp_batch'--O.LAST_UPDATED_BY
--									,GETDATE()--O.LAST_UPDATE_DATE
--									FROM SSP_DNM_OWMS_STOCK O WITH(NOLOCK) 
--											JOIN SCM_MST_SITE S WITH(NOLOCK) 
--											ON S.SITE_TYPE   = 'PLANT' 
--											AND S.DIVISION_ID = O.DIVISION_ID
--											AND S.PLANT_ID    = O.PLANT_ID
--											AND S.COMPANY_ID  = @company_id
--											AND O.CUTOFF_DATE = @cutoff_date		-- [C20200601-000370] CUTOFF DATE 조건 추가
--											--AND S.OPERATION_GROUP = CASE WHEN  S.OPERATION_GROUP = 'W' THEN 'W'
--/*
--											AND S.OPERATION_GROUP = CASE WHEN  O.STORAGE_ID LIKE 'AS%' THEN 'W'
--					                                                     ELSE  DBO.FN_GET_ITEM_OPERATION_GROUP(O.DIVISION_ID,O.ITEM_ID) END 
--*/
--											AND S.OPERATION_GROUP = CASE WHEN  O.STORAGE_ID IN (select CODE from dbo.FN_LIST_LOOKUP_VALUE('PR_SSP_PLN_SHIP_PLAN_CUTOFF','AS_STORAGE')) THEN 'W'
--					                                                     ELSE  DBO.FN_GET_ITEM_OPERATION_GROUP(O.DIVISION_ID,O.ITEM_ID) END 
--						                    --AND S.OPERATION_GROUP = DBO.FN_GET_ITEM_OPERATION_GROUP(O.DIVISION_ID,O.ITEM_ID)
									
--									; 

									--UPDATE SSP_MST_SHIP_PLAN_SCHEDULE(OWMS_STOCK_CUTOFF_YN)
									UPDATE SSP_MST_SHIP_PLAN_SCHEDULE
									SET    OWMS_STOCK_CUTOFF_YN  = 'Y'
									,      LAST_UPDATE_DATE      = GETDATE()
									,      LAST_UPDATED_BY       = @v_batch_user
									WHERE COMPANY_ID = @company_id
									AND   PLAN_START_YYYYMMDD   = @plan_start_yyyymmdd
									;
							

--								END;

								---------------------------------------------------------------------------------------------------  
								--1.법인별 PLAN CUFOFF DATA 생성 (PR_SSP_ANL_SHIP_PLAN_CUTOFF 실행) <- @company_id, @cutoff_date 
								--------------------------------------------------------------------------------------------------- 	
print(@company_id);
								-- SSP_ANL_SHIP_PLAN_C 생성 (전일자 생성) 
								DECLARE @v_return1 INT ;
								EXEC @v_return1= PR_SSP_ANL_SHIP_PLAN_CUTOFF_FP_AUTO @company_id , @cutoff_date , @v_log_message OUTPUT;
print(@v_return1); 
print(@v_log_message);								
print(@cutoff_date);
							
								IF @v_return1 = -1 
								  BEGIN
								   SET @v_log_message = @company_id+'PR_SSP_ANL_SHIP_PLAN_CUTOFF;'+ @v_log_message ;
								   THROW 60000, @v_log_message, 1  ;
								  END;  

                                --UPDATE SSP_MST_SHIP_PLAN_SCHEDULE(PLAN_CUTOFF_CREATE_YN)
								UPDATE SSP_MST_SHIP_PLAN_SCHEDULE
								SET    PLAN_CUTOFF_CREATE_YN   = 'Y'
								,      PLAN_CUTOFF_CREATE_DATE = GETDATE()
								WHERE COMPANY_ID          = @company_id
								AND   PLAN_START_YYYYMMDD = @cutoff_date 
								;

        						---------------------------------------------------------------------------------------------------  
								--2.법인별 CONFIRM DATA 생성 (PR_SSP_ANL_SHIP_CONFIRM_BATCH_N) <- @company_id, @cutoff_date
								---------------------------------------------------------------------------------------------------  
								DECLARE @v_return2 INT ;
								EXEC @v_return2= PR_SSP_ANL_SHIP_CONFIRM_BATCH_N_FP_AUTO @company_id , @cutoff_date , @v_log_message OUTPUT;		
							
								--IF @v_return2 = -1 
								--  BEGIN
								--   SET @v_log_message = @company_id+'PR_SSP_ANL_SHIP_CONFIRM_BATCH_N;'+ @v_log_message ;
								--   THROW 60000, @v_log_message, 1  ;
								--  END; 
							
								--UPDATE SSP_MST_SHIP_PLAN_SCHEDULE(CONFIRM_CREATE_YN)
								UPDATE SSP_MST_SHIP_PLAN_SCHEDULE
								SET    CONFIRM_CREATE_YN = 'Y'
								,      CONFIRM_CREATE_DATE = GETDATE()
								WHERE COMPANY_ID          = @company_id
								AND   PLAN_START_YYYYMMDD = @cutoff_date 
								;


								 --* 2020.10.05   KIM BOK KI     SSP 출하 계획 FP I/F 로직 변경에 따른 호출 구문 주석 처리
								---------------------------------------------------------------------------------------------------  
								--3.FP출하타겟 전송 (PR_SSP_PLN_FP_SHIP_TARGET_N) <- @company_id, @cutoff_date
								---------------------------------------------------------------------------------------------------  
								--DECLARE @v_return3 INT ;
								--EXEC @v_return3= PR_SSP_PLN_FP_SHIP_TARGET_N @company_id , @cutoff_date , @v_log_message OUTPUT;		
							
								--IF @v_return3 = -1 
								--  BEGIN
								--   SET @v_log_message = @company_id+'PR_SSP_PLN_FP_SHIP_TARGET_N;'+ @v_log_message ;
								--   THROW 60000, @v_log_message, 1  ;
								--  END; 
							
							    --UPDATE SSP_MST_SHIP_PLAN_SCHEDULE(FP_TARGET_SEND_YN)
								UPDATE SSP_MST_SHIP_PLAN_SCHEDULE
								SET    FP_TARGET_SEND_YN = 'Y'
								,      FP_TARGET_SEND_DATE = GETDATE()
								WHERE COMPANY_ID          = @company_id
								AND   PLAN_START_YYYYMMDD = @cutoff_date 
								;

								---------------------------------------------------------------------------------------------------  
								--4.음수재고 Warning Mailing (PR_SSP_MAIL_SEND_BATCH_N) <- @company_id, @cutoff_date
								---------------------------------------------------------------------------------------------------  
								--DECLARE @v_return4 INT ;
								--EXEC @v_return4= PR_SSP_MAIL_SEND_BATCH_N @company_id ,  @v_log_message OUTPUT;

								--IF @v_return4 = -1 
								--  BEGIN
								--   SET @v_log_message = @company_id+'PR_SSP_MAIL_SEND_BATCH_N;'+ @v_log_message ;
								--   THROW 60000, @v_log_message, 1  ;
								--  END; 

								----UPDATE PR_SSP_MAIL_SEND_BATCH_N(완료)
								--UPDATE SSP_MST_SHIP_PLAN_SCHEDULE
								--SET    ATTRIBUTE1  = 'MAIL_1(MINUS_WARNING): ' + CONVERT(VARCHAR, GETDATE(), 121)
								--WHERE COMPANY_ID          = @company_id
								--AND   PLAN_START_YYYYMMDD = @cutoff_date 
								--;

								---------------------------------------------------------------------------------------------------  
								--5.확정구간 진입시 음수 재고 대상에 대한 삭제 Mailing (PR_SSP_MAIL_SEND_SHIP_REQ_DELETE) <- @company_id, @cutoff_date
								---------------------------------------------------------------------------------------------------  
								--DECLARE @v_return5 INT ;
								--EXEC @v_return5= PR_SSP_MAIL_SEND_SHIP_REQ_DELETE @company_id ,  @v_log_message OUTPUT;

								--IF @v_return5 = -1 
								--  BEGIN
								--   SET @v_log_message = @company_id+'PR_SSP_MAIL_SEND_SHIP_REQ_DELETE;'+ @v_log_message ;
								--   THROW 60000, @v_log_message, 1  ;
								--  END; 

								----UPDATE PR_SSP_MAIL_SEND_SHIP_REQ_DELETE(완료)
								--UPDATE SSP_MST_SHIP_PLAN_SCHEDULE
								--SET    ATTRIBUTE2  = 'MAIL_2(REQ_DEL): ' + CONVERT(VARCHAR, GETDATE(), 121)
								--WHERE COMPANY_ID          = @company_id
								--AND   PLAN_START_YYYYMMDD = @cutoff_date 
								--;
								---------------------------------------------------------------------------------------------------  
								--6.법인간 거래 대상에 대하서 구매담당자에게 Mailing (PR_SSP_MAIL_SEND_SHIP_PLAN_INTER_COM) <- @company_id, @cutoff_date
								--2020.07.13 법인간 거래 메일링 제외(신규 메일링으로 대체, 신규: PR_SSP_MAIL_SEND_SHIP_PLAN_INTER_COM_PO<--별도 호출됨)
								---------------------------------------------------------------------------------------------------  
								/*-- 제외(2020.07.13)
								DECLARE @v_return6 INT ;
								EXEC @v_return6= PR_SSP_MAIL_SEND_SHIP_PLAN_INTER_COM @company_id ,  @v_log_message OUTPUT;

								IF @v_return6 = -1 
								  BEGIN
								   SET @v_log_message = @company_id+'PR_SSP_MAIL_SEND_SHIP_PLAN_INTER_COM;'+ @v_log_message ;
								   THROW 60000, @v_log_message, 1  ;
								  END; 

								--UPDATE PR_SSP_MAIL_SEND_SHIP_PLAN_INTER_COM(완료)
								UPDATE SSP_MST_SHIP_PLAN_SCHEDULE
								SET    ATTRIBUTE3  = 'MAIL_3(INTER): ' + CONVERT(VARCHAR, GETDATE(), 121)
								WHERE COMPANY_ID          = @company_id
								AND   PLAN_START_YYYYMMDD = @cutoff_date 
								;
								*/

								--UPDATE SSP_MST_SHIP_PLAN_SCHEDULE(CURRENT_PLAN_DATE_YN)
								UPDATE SSP_MST_SHIP_PLAN_SCHEDULE
								SET    CURRENT_PLAN_DATE_YN  = 'Y'
								,      LAST_UPDATE_DATE      = GETDATE()
								,      LAST_UPDATED_BY       = @v_batch_user
								WHERE COMPANY_ID = @company_id
								AND   PLAN_START_YYYYMMDD   = @plan_start_yyyymmdd
								;

								-----------------------------------------------------------
								-- SMS 전송 : Daily Plan Cutoff End Message End (58)
								--56 Daily Plan Cutoff Start 
								--57 Daily Plan Cutoff Error 
								--58 Daily Plan Cutoff End 
								-----------------------------------------------------------
								SET @v_sms_desc = @company_id +':'+@v_company_desc +':';
--EXEC SCM_ADM_SMS_SEND_BATCH 58, @v_sms_desc;

--exec PR_SSP_XIF_SCS_PACK_SHIP_PLAN_S_82 @company_id,'','',''

					   END;-- ERP 재고 있을 경우 oWMS 재고 CUTOFF생성 END


				FETCH NEXT FROM CUR_PLAN_S INTO @company_id, 
												@plan_start_yyyymmdd, 
												@cutoff_date,
												@erp_stock_cutoff_yn,
												@owms_stock_cutoff_yn,
												@current_plan_date_yn,
												@plan_cutoff_create_yn ; 
	
			END; 

			CLOSE CUR_PLAN_S; 
			DEALLOCATE CUR_PLAN_S;


         -----------------------------------------------------------
        -- 실행 Logic END --
        -----------------------------------------------------------
 
        --IF @@TRANCOUNT > 0
        --  BEGIN
           COMMIT TRAN TX_SH;
        --  END;       


        -- TXN LOG
        SET @v_log_type = N'TXN';    -- ▶ 로그타입
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_message = N'EXECUTE '+@v_program_name;
        SET @v_description = N'Process Complete...' + ':' + CONVERT(CHAR(8), @d_event_date, 112);
        SET @d_event_date = SYSDATETIME();

        EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  =@v_program_name
                                  ,@p_log_type      =@v_log_type
                                  ,@p_log_count     =@n_log_count 
                                  ,@p_log_message   =@v_log_message 
                                  ,@p_description   =@v_description 
                                  ,@p_event_date    =@d_event_date 
                                  ,@p_user_id       =@v_batch_user
                                  ;      

    END
    END TRY

    BEGIN CATCH


      IF @@TRANCOUNT > 0
        BEGIN
          ROLLBACK TRAN TX_SH
       END;

		IF EXISTS (SELECT 1 FROM SYS.SYSCURSORS WITH(NOLOCK) WHERE CURSOR_NAME = 'CUR_PLAN_S')
			BEGIN
				CLOSE CUR_PLAN_S ;
				DEALLOCATE CUR_PLAN_S ;
			END
      
      -- ERROR LOG
      SET @v_log_type = N'ERROR';
      SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
      SET @v_description = @v_program_name + N'ERROR_LINE : ' + STR(ERROR_LINE());
      SET @d_event_date = SYSDATETIME();
      EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  =@v_program_name
                                ,@p_log_type      =@v_log_type
                                ,@p_log_count     =@n_log_count 
                                ,@p_log_message   =@v_log_message 
                                ,@p_description   =@v_description 
                                ,@p_event_date    =@d_event_date 
                                ,@p_user_id       =@v_batch_user
                                ;
			-----------------------------------------------------------
			-- SMS 전송 : Daily Plan Cutoff End Message Error (57)
			--56 Daily Plan Cutoff Start 
			--57 Daily Plan Cutoff Error 
			--58 Daily Plan Cutoff End 
			-----------------------------------------------------------
			SET @v_sms_desc = @company_id +':'+@v_company_desc +':';
 			EXEC SCM_ADM_SMS_SEND_BATCH 57, @v_sms_desc;
  PRINT(@v_description+'/'+@v_log_message);
      return -1
    END CATCH;

     --임시 운영반영시에 주석처리 할것.
     SET @v_exec_time  =  REPLICATE('0', 2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) + ':' + 
                          REPLICATE('0', 2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60)) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60)) 


    -- 종료 LOG
    SET @v_log_type = N'END';
    SET @v_log_message = N'########## END of procedure ##########';
    SET @v_description = N'['++'][' + @v_exec_time + ']'+'['+@v_company_desc + ']';  
    SET @d_event_date = SYSDATETIME()  ;
    EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  =@v_program_name
                              ,@p_log_type      =@v_log_type
                              ,@p_log_count     =@n_log_count 
                              ,@p_log_message   =@v_log_message 
                              ,@p_description   =@v_description 
                              ,@p_event_date    =@d_event_date 
                              ,@p_user_id       =@v_batch_user
                              ;
   
   			IF EXISTS (SELECT 1 FROM SYS.SYSCURSORS WITH(NOLOCK) WHERE CURSOR_NAME = 'CUR_PLAN_S')
				BEGIN
				   CLOSE CUR_PLAN_S ;
				   DEALLOCATE CUR_PLAN_S ;
				END
    return 1  

  END; 
